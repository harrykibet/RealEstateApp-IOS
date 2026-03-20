#!/usr/bin/env bash
set -euo pipefail

echo "========================================"
echo "GIT SETUP (SSH ONLY)"
echo "========================================"

# =========================
# 🔐 REQUIRED ENV VARS
# =========================
: "${GIT_USER_NAME:?GIT_USER_NAME is required}"
: "${GIT_USER_EMAIL:?GIT_USER_EMAIL is required}"
: "${GITHUB_REPO:?GITHUB_REPO is required (org/repo.git)}"
: "${GITLAB_REPO:?GITLAB_REPO is required (org/repo.git)}"

# Optional
REMOTE_GITHUB_NAME="${REMOTE_GITHUB_NAME:-github}"
REMOTE_GITLAB_NAME="${REMOTE_GITLAB_NAME:-gitlab}"

SSH_DIR="${SSH_DIR:-$HOME/.ssh}"
SSH_CONFIG="$SSH_DIR/config"
SSH_KEY_PATH="${SSH_KEY_PATH:-$SSH_DIR/id_ed25519_ci}"

# =========================
# 🧾 Git Identity
# =========================
echo "→ Configuring git identity..."
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

# =========================
# 🔐 SSH Environment
# =========================
echo "→ Preparing SSH environment..."

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Ensure ssh-agent is running
if [ -z "${SSH_AUTH_SOCK:-}" ]; then
  echo "→ Starting ssh-agent..."
  eval "$(ssh-agent -s)"
fi

# Add key (assumes Python script already created it)
if [ -f "$SSH_KEY_PATH" ]; then
  echo "→ Adding SSH key to agent..."
  ssh-add --apple-use-keychain "$SSH_KEY_PATH" 2>/dev/null || ssh-add "$SSH_KEY_PATH"
else
  echo "❌ SSH key not found at $SSH_KEY_PATH"
  echo "Make sure ssh_key_manager.py runs before this step"
  exit 1
fi

# =========================
# ⚙️ SSH CONFIG
# =========================
echo "→ Configuring SSH..."

touch "$SSH_CONFIG"

if ! grep -q "Host github.com" "$SSH_CONFIG"; then
cat <<EOF >> "$SSH_CONFIG"

Host github.com
  HostName github.com
  User git
  IdentityFile $SSH_KEY_PATH
  AddKeysToAgent yes
  UseKeychain yes
EOF
fi

if ! grep -q "Host gitlab.com" "$SSH_CONFIG"; then
cat <<EOF >> "$SSH_CONFIG"

Host gitlab.com
  HostName gitlab.com
  User git
  IdentityFile $SSH_KEY_PATH
  AddKeysToAgent yes
  UseKeychain yes
EOF
fi

chmod 600 "$SSH_CONFIG"

# =========================
# 🌐 Remote URLs (SSH ONLY)
# =========================
GITHUB_URL="git@github.com:${GITHUB_REPO}"
GITLAB_URL="git@gitlab.com:${GITLAB_REPO}"

echo "========================================"
echo "CONFIGURING REMOTES"
echo "========================================"

# Bash 3 compatible (no associative arrays)
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
echo "✅ GIT SETUP COMPLETE (SSH)"
echo "========================================"