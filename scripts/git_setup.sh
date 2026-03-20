#!/usr/bin/env bash
set -euo pipefail

echo "========================================"
echo "GIT SETUP (SSH - HERMETIC)"
echo "========================================"

# =========================
# 🔐 REQUIRED ENV VARS
# =========================
: "${GIT_USER_NAME:?GIT_USER_NAME is required}"
: "${GIT_USER_EMAIL:?GIT_USER_EMAIL is required}"
: "${GITHUB_REPO:?GITHUB_REPO is required}"
: "${GITLAB_REPO:?GITLAB_REPO is required}"
: "${SSH_KEY_PATH:?SSH_KEY_PATH is required}"

REMOTE_GITHUB_NAME="${REMOTE_GITHUB_NAME:-github}"
REMOTE_GITLAB_NAME="${REMOTE_GITLAB_NAME:-gitlab}"

# =========================
# 🧾 Git Identity
# =========================
echo "→ Configuring git identity..."
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

# =========================
# 🔐 Validate SSH key
# =========================
if [ ! -f "$SSH_KEY_PATH" ]; then
  echo "❌ SSH key not found at $SSH_KEY_PATH"
  exit 1
fi

chmod 600 "$SSH_KEY_PATH"

# =========================
# 🚀 Hermetic SSH command
# =========================
export GIT_SSH_COMMAND="ssh -i $SSH_KEY_PATH -o IdentitiesOnly=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

echo "→ Using hermetic SSH:"
echo "$GIT_SSH_COMMAND"

# =========================
# 🌐 Remote URLs
# =========================
GITHUB_URL="git@github.com:${GITHUB_REPO}"
GITLAB_URL="git@gitlab.com:${GITLAB_REPO}"

echo "========================================"
echo "CONFIGURING REMOTES"
echo "========================================"

REMOTE1_NAME="$REMOTE_GITHUB_NAME"
REMOTE1_URL="$GITHUB_URL"

REMOTE2_NAME="$REMOTE_GITLAB_NAME"
REMOTE2_URL="$GITLAB_URL"

for i in 1 2; do
    NAME_VAR="REMOTE${i}_NAME"
    URL_VAR="REMOTE${i}_URL"

    NAME="${!NAME_VAR}"
    URL="${!URL_VAR}"

    if git remote get-url "$NAME" &>/dev/null; then
        existing=$(git remote get-url "$NAME")
        if [ "$existing" != "$URL" ]; then
            echo "→ Updating remote '$NAME'"
            git remote set-url "$NAME" "$URL"
        else
            echo "→ Remote '$NAME' already correct"
        fi
    else
        echo "→ Adding remote '$NAME'"
        git remote add "$NAME" "$URL"
    fi
done

echo "========================================"
echo "✅ GIT SETUP COMPLETE (HERMETIC SSH)"
echo "========================================"