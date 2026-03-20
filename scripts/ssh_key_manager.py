#!/usr/bin/env python3
import os
import subprocess
import sys
import time
import requests
import datetime
import atexit

HOME = os.path.expanduser("~")
SSH_KEY_PATH = f"{HOME}/.ssh/id_ed25519_ci"
SESSION_NAME = f"codemagic-ci-{int(time.time())}"

GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN")
GITLAB_TOKEN = os.environ.get("GITLAB_TOKEN")

STATE = {
    "github_key_id": None,
    "gitlab_key_id": None
}


# -----------------------------
# Utils
# -----------------------------
def run(cmd: str):
    subprocess.check_call(cmd, shell=True)


def require_env():
    missing = []
    if not GITHUB_TOKEN:
        missing.append("GITHUB_TOKEN")
    if not GITLAB_TOKEN:
        missing.append("GITLAB_TOKEN")

    if missing:
        raise RuntimeError(f"Missing required env vars: {', '.join(missing)}")


# -----------------------------
# SSH setup
# -----------------------------
def ensure_ssh_agent():
    if "SSH_AUTH_SOCK" not in os.environ:
        print("→ Starting ssh-agent...")
        output = subprocess.check_output("ssh-agent -s", shell=True).decode()
        for line in output.splitlines():
            if "SSH_AUTH_SOCK" in line or "SSH_AGENT_PID" in line:
                key, value = line.replace("export ", "").split(";")[0].split("=")
                os.environ[key] = value


def generate_key():
    if not os.path.exists(SSH_KEY_PATH):
        print("→ Generating SSH key...")
        run(f"ssh-keygen -t ed25519 -C '{SESSION_NAME}' -f {SSH_KEY_PATH} -N ''")


def read_pub():
    with open(f"{SSH_KEY_PATH}.pub") as f:
        return f.read().strip()


# -----------------------------
# GitHub
# -----------------------------
def upload_github(pub_key: str):
    print("→ Uploading key to GitHub...")
    r = requests.post(
        "https://api.github.com/user/keys",
        headers={
            "Authorization": f"Bearer {GITHUB_TOKEN}",
            "Accept": "application/vnd.github+json"
        },
        json={"title": SESSION_NAME, "key": pub_key},
        timeout=10
    )
    r.raise_for_status()
    STATE["github_key_id"] = str(r.json()["id"])


def delete_github():
    if not STATE["github_key_id"]:
        return

    print("→ Deleting GitHub key...")
    requests.delete(
        f"https://api.github.com/user/keys/{STATE['github_key_id']}",
        headers={"Authorization": f"Bearer {GITHUB_TOKEN}"},
        timeout=10
    )


# -----------------------------
# GitLab
# -----------------------------
def upload_gitlab(pub_key: str):
    print("→ Uploading key to GitLab...")
    expires = (datetime.datetime.utcnow() + datetime.timedelta(days=1)).strftime("%Y-%m-%d")

    r = requests.post(
        "https://gitlab.com/api/v4/user/keys",
        headers={"PRIVATE-TOKEN": GITLAB_TOKEN},
        json={"title": SESSION_NAME, "key": pub_key, "expires_at": expires},
        timeout=10
    )
    r.raise_for_status()
    STATE["gitlab_key_id"] = str(r.json()["id"])


def delete_gitlab():
    if not STATE["gitlab_key_id"]:
        return

    print("→ Deleting GitLab key...")
    requests.delete(
        f"https://gitlab.com/api/v4/user/keys/{STATE['gitlab_key_id']}",
        headers={"PRIVATE-TOKEN": GITLAB_TOKEN},
        timeout=10
    )


# -----------------------------
# Cleanup (GUARANTEED)
# -----------------------------
def cleanup():
    print("🧹 Running cleanup...")
    try:
        delete_github()
        delete_gitlab()
    except Exception as e:
        print("⚠️ Cleanup error:", e)


atexit.register(cleanup)


# -----------------------------
# Main
# -----------------------------
def main():
    require_env()

    ensure_ssh_agent()
    generate_key()
    pub_key = read_pub()

    upload_github(pub_key)
    upload_gitlab(pub_key)

    print("→ Adding key to ssh-agent...")
    run(f"ssh-add {SSH_KEY_PATH}")

    print("✅ SSH ready")


if __name__ == "__main__":
    main()