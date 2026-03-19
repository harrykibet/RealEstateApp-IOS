#!/usr/bin/env python3
import os
import subprocess
import sys
import time
import requests
import datetime

HOME = os.path.expanduser("~")
SSH_KEY_PATH = f"{HOME}/.ssh/id_ed25519_ci"

# -----------------------------
# ⚠️ DEBUG TOKENS (hardcoded for CI debugging)
# -----------------------------
GITHUB_TOKEN = "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"
GITLAB_TOKEN = "glpat-aRFm8GwqjNvB9bxP445rGW86MQp1OmV6bzUwCw.01.1201ioa5p"

SESSION_NAME = f"codemagic-ci-{int(time.time())}"

def run(cmd):
    """Run shell commands safely."""
    subprocess.check_call(cmd, shell=True)

def generate_key():
    """Generate ephemeral SSH key if it does not exist."""
    if not os.path.exists(SSH_KEY_PATH):
        print("→ Generating ephemeral SSH key...")
        run(f"ssh-keygen -t ed25519 -C '{SESSION_NAME}' -f {SSH_KEY_PATH} -N ''")
    else:
        print("→ SSH key already exists, skipping generation.")

def read_pub():
    """Read public key contents."""
    with open(f"{SSH_KEY_PATH}.pub") as f:
        return f.read().strip()

def upload_github(pub_key: str) -> str:
    """Upload key to GitHub (no expiry possible via API)."""
    print("→ Uploading key to GitHub...")
    r = requests.post(
        "https://api.github.com/user/keys",
        headers={
            "Authorization": f"Bearer {GITHUB_TOKEN}",
            "Accept": "application/vnd.github+json"
        },
        json={"title": SESSION_NAME, "key": pub_key}
    )
    r.raise_for_status()
    return str(r.json()["id"])

def delete_github(key_id: str):
    print("→ Deleting GitHub key...")
    requests.delete(
        f"https://api.github.com/user/keys/{key_id}",
        headers={"Authorization": f"Bearer {GITHUB_TOKEN}"}
    )

def upload_gitlab(pub_key: str) -> str:
    """Upload key to GitLab with 1-day expiry."""
    print("→ Uploading key to GitLab (1-day expiry)...")
    expires = (datetime.datetime.utcnow() + datetime.timedelta(days=1)).strftime("%Y-%m-%d")
    r = requests.post(
        "https://gitlab.com/api/v4/user/keys",
        headers={"PRIVATE-TOKEN": GITLAB_TOKEN},
        json={"title": SESSION_NAME, "key": pub_key, "expires_at": expires}
    )
    r.raise_for_status()
    return str(r.json()["id"])

def delete_gitlab(key_id: str):
    print("→ Deleting GitLab key...")
    requests.delete(
        f"https://gitlab.com/api/v4/user/keys/{key_id}",
        headers={"PRIVATE-TOKEN": GITLAB_TOKEN}
    )

def main():
    try:
        generate_key()
        pub_key = read_pub()

        gh_id = upload_github(pub_key) if GITHUB_TOKEN else None
        gl_id = upload_gitlab(pub_key) if GITLAB_TOKEN else None

        print("→ Adding key to ssh-agent...")
        run(f"ssh-add {SSH_KEY_PATH}")

        print("✅ SSH key ready for CI usage")
        print("\n📌 Public key:")
        print(pub_key)

        # Persist IDs for cleanup
        with open("/tmp/ssh_key_ids", "w") as f:
            f.write(f"{gh_id or ''},{gl_id or ''}")

    except Exception as e:
        print("❌ Setup failed:", e)
        sys.exit(1)

def cleanup():
    """Remove ephemeral keys from GitHub/GitLab."""
    try:
        if not os.path.exists("/tmp/ssh_key_ids"):
            return

        with open("/tmp/ssh_key_ids") as f:
            gh_id, gl_id = f.read().split(",")

        if gh_id:
            delete_github(gh_id)
        if gl_id:
            delete_gitlab(gl_id)

        print("🧹 Cleanup complete")

    except Exception as e:
        print("⚠️ Cleanup failed:", e)

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "cleanup":
        cleanup()
    else:
        main()