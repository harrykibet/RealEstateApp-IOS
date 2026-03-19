#!/usr/bin/env python3
import os
import subprocess
import sys
import time
import requests
from pathlib import Path

HOME = Path.home()
SSH_DIR = HOME / ".ssh"
SSH_KEY_PATH = SSH_DIR / "id_ed25519_ci"
SSH_KEY_PUB_PATH = SSH_KEY_PATH.with_suffix(".pub")
TMP_KEY_IDS = Path("/tmp/ssh_key_ids")

GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")
GITLAB_TOKEN = os.getenv("GITLAB_TOKEN")

SESSION_NAME = f"codemagic-ci-{int(time.time())}"


def run(cmd: str):
    """Run a shell command safely."""
    result = subprocess.run(cmd, shell=True, text=True, capture_output=True)
    if result.returncode != 0:
        print(f"❌ Command failed: {cmd}")
        print("stdout:", result.stdout)
        print("stderr:", result.stderr)
        raise subprocess.CalledProcessError(result.returncode, cmd)
    return result.stdout.strip()


def ensure_ssh_dir():
    SSH_DIR.mkdir(mode=0o700, exist_ok=True)


def start_ssh_agent():
    """Ensure ssh-agent is running and export env variables."""
    agent_output = subprocess.run("eval $(ssh-agent -s)", shell=True, capture_output=True, text=True)
    if agent_output.returncode != 0:
        print("❌ Failed to start ssh-agent")
        print(agent_output.stderr)
        sys.exit(1)


def generate_key():
    if SSH_KEY_PATH.exists():
        print("→ SSH key already exists, skipping generation.")
        return
    print("→ Generating ephemeral SSH key...")
    run(f"ssh-keygen -t ed25519 -C '{SESSION_NAME}' -f {SSH_KEY_PATH} -N ''")


def read_pub_key() -> str:
    if not SSH_KEY_PUB_PATH.exists():
        raise FileNotFoundError(f"Public key not found at {SSH_KEY_PUB_PATH}")
    return SSH_KEY_PUB_PATH.read_text().strip()


def ssh_add_key():
    print("→ Adding key to ssh-agent...")
    run(f"ssh-add {SSH_KEY_PATH}")


def upload_github(pub_key: str) -> str | None:
    if not GITHUB_TOKEN:
        print("⚠️ GITHUB_TOKEN not set, skipping GitHub upload.")
        return None
    print("→ Uploading key to GitHub...")
    r = requests.post(
        "https://api.github.com/user/keys",
        headers={
            "Authorization": f"Bearer {GITHUB_TOKEN}",
            "Accept": "application/vnd.github+json",
        },
        json={"title": SESSION_NAME, "key": pub_key},
        timeout=10,
    )
    r.raise_for_status()
    return str(r.json()["id"])


def delete_github(key_id: str):
    if not GITHUB_TOKEN or not key_id:
        return
    print(f"→ Deleting GitHub key {key_id}...")
    requests.delete(
        f"https://api.github.com/user/keys/{key_id}",
        headers={"Authorization": f"Bearer {GITHUB_TOKEN}"},
        timeout=10,
    )


def upload_gitlab(pub_key: str) -> str | None:
    if not GITLAB_TOKEN:
        print("⚠️ GITLAB_TOKEN not set, skipping GitLab upload.")
        return None
    print("→ Uploading key to GitLab...")
    r = requests.post(
        "https://gitlab.com/api/v4/user/keys",
        headers={"PRIVATE-TOKEN": GITLAB_TOKEN},
        json={"title": SESSION_NAME, "key": pub_key},
        timeout=10,
    )
    r.raise_for_status()
    return str(r.json()["id"])


def delete_gitlab(key_id: str):
    if not GITLAB_TOKEN or not key_id:
        return
    print(f"→ Deleting GitLab key {key_id}...")
    requests.delete(
        f"https://gitlab.com/api/v4/user/keys/{key_id}",
        headers={"PRIVATE-TOKEN": GITLAB_TOKEN},
        timeout=10,
    )


def main():
    try:
        ensure_ssh_dir()
        start_ssh_agent()
        generate_key()
        pub_key = read_pub_key()
        ssh_add_key()

        gl_id = upload_gitlab(pub_key)
        gh_id = upload_github(pub_key)

        # Persist IDs for cleanup
        TMP_KEY_IDS.write_text(f"{gh_id or ''},{gl_id or ''}")

        print("✅ SSH key ready for CI usage")
        print("\n📌 Public key:")
        print(pub_key)
        print("\n👉 Add it to GitHub/GitLab if not uploaded via API.")

    except Exception as e:
        print("❌ Setup failed:", e)
        sys.exit(1)


def cleanup():
    try:
        if not TMP_KEY_IDS.exists():
            return
        gh_id, gl_id = TMP_KEY_IDS.read_text().split(",")
        delete_github(gh_id)
        delete_gitlab(gl_id)
        print("🧹 Cleanup complete")
        TMP_KEY_IDS.unlink()
    except Exception as e:
        print("⚠️ Cleanup failed:", e)


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "cleanup":
        cleanup()
    else:
        main()