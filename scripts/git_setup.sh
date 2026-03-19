#!/usr/bin/env bash

set -euo pipefail

echo "========================================"
echo "GIT + SSH SETUP"
echo "========================================"

GIT_NAME="harrykibet"
GIT_EMAIL="trmnjames@gmail.com"

SSH_DIR="$HOME/.ssh"
GITHUB_KEY="$SSH_DIR/id_ed25519_github"
GITLAB_KEY="$SSH_DIR/id_ed25519_gitlab"

mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

echo "→ Setting global git config..."
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

echo "→ Generating GitHub SSH key..."
if [ ! -f "$GITHUB_KEY" ]; then
  ssh-keygen -t ed25519 -C "$GIT_EMAIL (github)" -f "$GITHUB_KEY" -N ""
else
  echo "GitHub key already exists, skipping..."
fi

echo "→ Generating GitLab SSH key..."
if [ ! -f "$GITLAB_KEY" ]; then
  ssh-keygen -t ed25519 -C "$GIT_EMAIL (gitlab)" -f "$GITLAB_KEY" -N ""
else
  echo "GitLab key already exists, skipping..."
fi

echo "→ Starting ssh-agent..."
eval "$(ssh-agent -s)"

ssh-add --apple-use-keychain "$GITHUB_KEY"
ssh-add --apple-use-keychain "$GITLAB_KEY"

echo "→ Configuring SSH config..."

SSH_CONFIG="$SSH_DIR/config"

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

echo "========================================"
echo "✅ SETUP COMPLETE"
echo "========================================"

echo ""
echo "📌 Copy your public keys:"
echo ""
echo "GitHub:"
cat "${GITHUB_KEY}.pub"
echo ""
echo "GitLab:"
cat "${GITLAB_KEY}.pub"
echo ""
echo "👉 Add them to GitHub & GitLab SSH settings."
