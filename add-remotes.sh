#!/bin/bash

set -e  # exit on error

GITHUB_URL="https://github.com/harrykibet/RealEstateApp-IOS.git"
GITLAB_URL="https://gitlab.com/harrykibet/RealEstateApp-IOS.git"

echo "🔍 Checking if this is a git repository..."
git rev-parse --is-inside-work-tree > /dev/null

add_or_update_remote() {
  local name=$1
  local url=$2

  if git remote | grep -q "^${name}$"; then
    echo "🔄 Remote '$name' exists. Updating URL..."
    git remote set-url "$name" "$url"
  else
    echo "➕ Adding remote '$name'..."
    git remote add "$name" "$url"
  fi
}

add_or_update_remote github "$GITHUB_URL"
add_or_update_remote gitlab "$GITLAB_URL"

echo ""
echo "✅ Remotes configured successfully:"
git remote -v

