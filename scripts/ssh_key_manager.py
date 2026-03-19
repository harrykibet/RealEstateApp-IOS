#!/usr/bin/env python3
import os
import subprocess
import sys
import time
import requests

HOME = os.path.expanduser("~")
SSH_KEY_PATH = os.path.join(HOME, ".ssh", "id_ed25519_ci")
SESSION_NAME = f"codemagic-ci-{int(time.time())}"

# Get credentials from environment variables
GITHUB_USER = os.getenv("GITHUB_USER")
GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")
GITLAB_TOKEN = os.getenv("GITLAB_TOKEN")  # GitLab only needs token

TMP_ID_FILE = "/tmp/ssh_key_ids"

def run(cmd):
    subprocess.check_call(cmd, shell=True)

def generate_key():
    if os.path.exists(SSH_KEY_PATH):
        print("→ SSH key already exists, skipping generation.")
    else:
        print("→ Generating ephemeral SSH key...")
        run(f"ssh-keygen -t ed25519 -C '{SESSION_NAME}' -f {SSH_KEY_PATH} -N ''")

def read_pub():
    with open(f"{SSH_KEY_PATH}.pub") as f:
        return f.read().strip()

def upload_github(key):
    if not GITHUB_USER or not GITHUB_TOKEN:
        print("⚠️ GitHub credentials not set, skipping GitHub upload.")
        return None

    print("→ Uploading key to GitHub...")
    resp = requests.post(
        "https://api.github.com/user/keys",
        auth=(GITHUB_USER, GITHUB_TOKEN),
        json={"title": SESSION_NAME, "key": key},
    )
    resp.raise_for_status()
    return resp.json()["id"]

def delete_github(key_id):
    if not key_id:
        return
    print("→ Deleting GitHub key...")
    requests.delete(
        f"https://api.github.com/user/keys/{key_id}",
        auth=(GITHUB_USER, GITHUB_TOKEN)
    )

def upload_gitlab(key):
    if not GITLAB_TOKEN:
        print("⚠️ GitLab token not set, skipping GitLab upload.")
        return None
    print("→ Uploading key to GitLab...")
    resp = requests.post(
        "https://gitlab.com/api/v4/user/keys",
        headers={"PRIVATE-TOKEN": GITLAB_TOKEN},
        json={"title": SESSION_NAME, "key": key},
    )
    resp.raise_for_status()
    return resp.json()["id"]

def delete_gitlab(key_id):
    if not key_id:
        return
    print("→ Deleting GitLab key...")
    requests.delete(
        f"https://gitlab.com/api/v4/user/keys/{key_id}",
        headers={"PRIVATE-TOKEN": GITLAB_TOKEN},
    )

def add_to_ssh_agent():
    print("→ Adding key to ssh-agent...")
    run(f"ssh-add {SSH_KEY_PATH}")

def main():
    try:
        generate_key()
        pub_key = read_pub()
        add_to_ssh_agent()

        gh_id = upload_github(pub_key)
        gl_id = upload_gitlab(pub_key)

        # Persist IDs for cleanup
        with open(TMP_ID_FILE, "w") as f:
            f.write(f"{gh_id or ''},{gl_id or ''}")

        print("✅ SSH key ready for CI usage")
        print("\n📌 Public key:")
        print(pub_key)
        print("\n👉 Add to GitHub/GitLab if not uploaded via API.")

    except Exception as e:
        print("❌ Setup failed:", e)
        sys.exit(1)

def cleanup():
    try:
        if not os.path.exists(TMP_ID_FILE):
            return
        with open(TMP_ID_FILE) as f:
            gh_id, gl_id = f.read().split(",")
        delete_github(gh_id)
        delete_gitlab(gl_id)
        print("🧹 Cleanup complete")
    except Exception as e:
        print("⚠️ Cleanup failed:", e)

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "cleanup":
        cleanup()
    else:
        main()