#!/bin/bash

set -e  # stop if any command fails

BRANCH=$(git branch --show-current)

if [ -z "$BRANCH" ]; then
  echo "❌ Not on a git branch"
  exit 1
fi

echo "🚀 Pushing branch '$BRANCH' to GitHub..."
git push github "$BRANCH"

echo "🚀 Pushing branch '$BRANCH' to GitLab..."
git push gitlab "$BRANCH"

echo "✅ Both repositories updated successfully!"

