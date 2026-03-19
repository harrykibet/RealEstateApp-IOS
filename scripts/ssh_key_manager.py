#!/usr/bin/env python3
import os
import subprocess
import sys
import time
import json
import requests

HOME = os.path.expanduser("~")
SSH_KEY_PATH = f"{HOME}/.ssh/id_ed25519_ci"

SESSION_NAME = f"codemagic-ci-{int(time.time())}"

def run(cmd):
    subprocess.check_call(cmd, shell=True)

def generate_key():
    if not os.path.exists(SSH_KEY_PATH):
        print("→ Generating ephemeral SSH key...")
        run(f"ssh-keygen -t ed25519 -C '{SESSION_NAME}' -f {SSH_KEY_PATH} -N ''")
    else:
        print("→ SSH key already exists, skipping generation.")

def read_pub():
    with open(f"{SSH_KEY_PATH}.pub") as f:
        return f.read().strip()

def upload_github(key, token):
    if not token:
        print("⚠️ GitHub token not provided, skipping GitHub upload.")
        return None
    print("→ Uploading key to GitHub...")
    r = requests.post(
        "https://api.github.com/user/keys",
        headers={
            "Authorization": f"Bearer {token}",
            "Accept": "application/vnd.github+json"
        },
        json={"title": SESSION_NAME, "key": key}
    )
    r.raise_for_status()
    return r.json()["id"]

def delete_github(key_id, token):
    if not key_id or not token:
        return
    print("→ Deleting GitHub key...")
    requests.delete(
        f"https://api.github.com/user/keys/{key_id}",
        headers={"Authorization": f"Bearer {token}"}
    )

def upload_gitlab(key, token):
    if not token:
        print("⚠️ GitLab token not provided, skipping GitLab upload.")
        return None
    print("→ Uploading key to GitLab...")
    r = requests.post(
        "https://gitlab.com/api/v4/user/keys",
        headers={"PRIVATE-TOKEN": token},
        json={"title": SESSION_NAME, "key": key}
    )
    r.raise_for_status()
    return r.json()["id"]

def delete_gitlab(key_id, token):
    if not key_id or not token:
        return
    print("→ Deleting GitLab key...")
    requests.delete(
        f"https://gitlab.com/api/v4/user/keys/{key_id}",
        headers={"PRIVATE-TOKEN": token}
    )

def main(github_token, gitlab_token):
    try:
        generate_key()
        pub = read_pub()

        gh_id = upload_github(pub, github_token)
        gl_id = upload_gitlab(pub, gitlab_token)

        print("→ Adding key to ssh-agent...")
        run(f"ssh-add {SSH_KEY_PATH}")

        print("✅ SSH key ready for CI usage")
        print("\n📌 Public key:")
        print(pub)

        # Persist IDs for cleanup
        with open("/tmp/ssh_key_ids", "w") as f:
            f.write(f"{gh_id or ''},{gl_id or ''}")

    except Exception as e:
        print("❌ Setup failed:", e)
        sys.exit(1)

def cleanup(github_token, gitlab_token):
    try:
        if not os.path.exists("/tmp/ssh_key_ids"):
            return

        with open("/tmp/ssh_key_ids") as f:
            gh_id, gl_id = f.read().split(",")

        delete_github(gh_id, github_token)
        delete_gitlab(gl_id, gitlab_token)

        print("🧹 Cleanup complete")

    except Exception as e:
        print("⚠️ Cleanup failed:", e)

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "cleanup":
        cleanup(
            sys.argv[2] if len(sys.argv) > 2 else "",
            sys.argv[3] if len(sys.argv) > 3 else ""
        )
    else:
        main(
            sys.argv[1] if len(sys.argv) > 1 else "",
            sys.argv[2] if len(sys.argv) > 2 else ""
        )