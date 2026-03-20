#!/usr/bin/env bash
set -euo pipefail

echo "========================================"
echo "GIT SETUP (CI-aware)"
echo "========================================"

# =========================
# 🔐 REQUIRED ENV VARS
# =========================
: "${GIT_USER_NAME:?GIT_USER_NAME is required}"
: "${GIT_USER_EMAIL:?GIT_USER_EMAIL is required}"
: "${GITHUB_REPO:?GITHUB_REPO is required (e.g. org/repo.git)}"
: "${GITLAB_REPO:?GITLAB_REPO is required (e.g. org/repo.git)}"

# Optional overrides
REMOTE_GITHUB_NAME="${REMOTE_GITHUB_NAME:-github}"
REMOTE_GITLAB_NAME="${REMOTE_GITLAB_NAME:-gitlab}"
SSH_DIR="${SSH_DIR:-$HOME/.ssh}"
SSH_CONFIG="$SSH_DIR/config"

# -------------------------
# Configure git identity
# -------------------------
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"

# -------------------------
# Determine CI vs Local
# -------------------------
if [ "${CI:-false}" = "true" ]; then
    echo "⚡ CI mode detected — using HTTPS token authentication"

    : "${GITHUB_TOKEN:?GITHUB_TOKEN required in CI}"
    : "${GITLAB_TOKEN:?GITLAB_TOKEN required in CI}"

    # Setup token-based HTTPS auth for CI
    git config --global url."https://${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"
    git config --global url."https://${GITLAB_TOKEN}@gitlab.com/".insteadOf "https://gitlab.com/"

    GITHUB_URL="https://github.com/${GITHUB_REPO}"
    GITLAB_URL="https://gitlab.com/${GITLAB_REPO}"

else
    echo "⚡ Local mode detected — using SSH keys"

    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"

    GITHUB_KEY="${GITHUB_KEY_PATH:-$SSH_DIR/id_ed25519_github}"
    GITLAB_KEY="${GITLAB_KEY_PATH:-$SSH_DIR/id_ed25519_gitlab}"

    # -------------------------
    # Generate SSH keys if missing
    # -------------------------
    if [ ! -f "$GITHUB_KEY" ]; then
        ssh-keygen -t ed25519 -C "$GIT_USER_EMAIL (github)" -f "$GITHUB_KEY" -N ""
    fi
    if [ ! -f "$GITLAB_KEY" ]; then
        ssh-keygen -t ed25519 -C "$GIT_USER_EMAIL (gitlab)" -f "$GITLAB_KEY" -N ""
    fi

    # -------------------------
    # Start ssh-agent and add keys
    # -------------------------
    eval "$(ssh-agent -s)"
    ssh-add --apple-use-keychain "$GITHUB_KEY" 2>/dev/null || ssh-add "$GITHUB_KEY"
    ssh-add --apple-use-keychain "$GITLAB_KEY" 2>/dev/null || ssh-add "$GITLAB_KEY"

    # -------------------------
    # SSH config
    # -------------------------
    touch "$SSH_CONFIG"
    if ! grep -q "Host github.com" "$SSH_CONFIG"; then
        cat <<EOF >> "$SSH_CONFIG"

Host github.com
  HostName github.com
  User git
  IdentityFile $GITHUB_KEY
  AddKeysToAgent yes
  UseKeychain yes
EOF
    fi

    if ! grep -q "Host gitlab.com" "$SSH_CONFIG"; then
        cat <<EOF >> "$SSH_CONFIG"

Host gitlab.com
  HostName gitlab.com
  User git
  IdentityFile $GITLAB_KEY
  AddKeysToAgent yes
  UseKeychain yes
EOF
    fi
    chmod 600 "$SSH_CONFIG"

    GITHUB_URL="git@github.com:${GITHUB_REPO}"
    GITLAB_URL="git@gitlab.com:${GITLAB_REPO}"

    # Print public keys for manual upload
    echo ""
    echo "📌 Public keys (add to GitHub/GitLab if missing):"
    echo "GitHub:"
    cat "${GITHUB_KEY}.pub"
    echo ""
    echo "GitLab:"
    cat "${GITLAB_KEY}.pub"
fi

# -------------------------
# Configure remotes
# -------------------------
declare -A remotes=(
    ["$REMOTE_GITHUB_NAME"]="$GITHUB_URL"
    ["$REMOTE_GITLAB_NAME"]="$GITLAB_URL"
)

echo "========================================"
echo "CONFIGURING REMOTES"
echo "========================================"

for name in "${!remotes[@]}"; do
    url="${remotes[$name]}"

    if git remote get-url "$name" &>/dev/null; then
        existing=$(git remote get-url "$name")
        if [ "$existing" != "$url" ]; then
            echo "→ Updating remote '$name'"
            git remote set-url "$name" "$url"
        else
            echo "→ Remote '$name' already correct"
        fi
    else
        echo "→ Adding remote '$name'"
        git remote add "$name" "$url"
    fi
done

echo "========================================"
echo "✅ GIT SETUP COMPLETE"
echo "========================================"