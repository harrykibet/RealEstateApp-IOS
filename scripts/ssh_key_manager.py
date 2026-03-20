#!/usr/bin/env python3
import os
import subprocess
import sys
import time
import requests
import datetime
from typing import Optional

HOME = os.path.expanduser("~")
SSH_KEY_PATH = os.environ.get("SSH_KEY_PATH", f"{HOME}/.ssh/id_ed25519_ci")
STATE_FILE = "/tmp/ssh_key_state"
SESSION_NAME = f"codemagic-ci-{int(time.time())}"

GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN")
GITLAB_TOKEN = os.environ.get("GITLAB_TOKEN")

# =============================
# Utils
# =============================
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


def request_with_retry(method, url, **kwargs):
    for attempt in range(3):
        try:
            response = requests.request(method, url, timeout=10, **kwargs)
            response.raise_for_status()
            return response
        except Exception as e:
            if attempt == 2:
                raise
            print(f"⚠️ Retry {attempt+1} failed: {e}")
            time.sleep(2)


# =============================
# SSH Key
# =============================
def generate_key():
    if not os.path.exists(SSH_KEY_PATH):
        print("→ Generating SSH key...")
        run(f"ssh-keygen -t ed25519 -C '{SESSION_NAME}' -f {SSH_KEY_PATH} -N ''")


def read_pub():
    with open(f"{SSH_KEY_PATH}.pub") as f:
        return f.read().strip()


# =============================
# GitHub
# =============================
def upload_github(pub_key: str) -> Optional[str]:
    if not GITHUB_TOKEN:
        return None

    print("→ Uploading key to GitHub...")

    r = request_with_retry(
        "POST",
        "https://api.github.com/user/keys",
        headers={
            "Authorization": f"Bearer {GITHUB_TOKEN}",
            "Accept": "application/vnd.github+json"
        },
        json={"title": SESSION_NAME, "key": pub_key},
    )

    return str(r.json()["id"])


def delete_github(key_id: str):
    if not key_id:
        return

    print("→ Deleting GitHub key...")

    request_with_retry(
        "DELETE",
        f"https://api.github.com/user/keys/{key_id}",
        headers={"Authorization": f"Bearer {GITHUB_TOKEN}"}
    )


# =============================
# GitLab
# =============================
def upload_gitlab(pub_key: str) -> Optional[str]:
    if not GITLAB_TOKEN:
        return None

    print("→ Uploading key to GitLab...")

    expires = (datetime.datetime.utcnow() + datetime.timedelta(days=1)).strftime("%Y-%m-%d")

    r = request_with_retry(
        "POST",
        "https://gitlab.com/api/v4/user/keys",
        headers={"PRIVATE-TOKEN": GITLAB_TOKEN},
        json={"title": SESSION_NAME, "key": pub_key, "expires_at": expires},
    )

    return str(r.json()["id"])


def delete_gitlab(key_id: str):
    if not key_id:
        return

    print("→ Deleting GitLab key...")

    request_with_retry(
        "DELETE",
        f"https://gitlab.com/api/v4/user/keys/{key_id}",
        headers={"PRIVATE-TOKEN": GITLAB_TOKEN}
    )


# =============================
# State persistence
# =============================
def save_state(gh_id: Optional[str], gl_id: Optional[str]):
    with open(STATE_FILE, "w") as f:
        f.write(f"{gh_id or ''},{gl_id or ''}")


def load_state():
    if not os.path.exists(STATE_FILE):
        return None, None

    with open(STATE_FILE) as f:
        content = f.read().strip()

    if not content:
        return None, None

    parts = content.split(",")
    gh = parts[0] if len(parts) > 0 and parts[0] else None
    gl = parts[1] if len(parts) > 1 and parts[1] else None

    return gh, gl


# =============================
# Setup
# =============================
def setup():
    require_env()

    generate_key()
    pub_key = read_pub()

    gh_id = None
    gl_id = None

    try:
        gh_id = upload_github(pub_key)
        gl_id = upload_gitlab(pub_key)

        save_state(gh_id, gl_id)

        print("✅ SSH key uploaded and ready")

    except Exception as e:
        print("❌ Setup failed:", e)

        # rollback partial state
        try:
            if gh_id:
                delete_github(gh_id)
            if gl_id:
                delete_gitlab(gl_id)
        except Exception as cleanup_err:
            print("⚠️ Rollback failed:", cleanup_err)

        sys.exit(1)


# =============================
# Cleanup
# =============================
def cleanup():
    print("🧹 Running cleanup...")

    gh_id, gl_id = load_state()

    try:
        if gh_id:
            delete_github(gh_id)
        if gl_id:
            delete_gitlab(gl_id)

        if os.path.exists(STATE_FILE):
            os.remove(STATE_FILE)

        print("✅ Cleanup complete")

    except Exception as e:
        print("⚠️ Cleanup failed:", e)


# =============================
# Entry
# =============================
if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "cleanup":
        cleanup()
    else:
        setup()