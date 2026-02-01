#!/bin/bash

# Navigate to your local repository
cd /path/to/your/repository

# Check if the repository exists
if [ ! -d ".git" ]; then
  echo "Error: This is not a git repository."
  exit 1
fi

# Check if GitLab remote exists, if not, add it
git remote get-url gitlab &>/dev/null
if [ $? -ne 0 ]; then
  git remote add gitlab git@gitlab.com:harrykibet/RealEstateApp-IOS.git
  echo "Added GitLab remote as 'gitlab' with URL git@gitlab.com:harrykibet/RealEstateApp-IOS.git"
else
  echo "GitLab remote already exists."
fi

# Check if GitHub remote exists, if not, add it
git remote get-url origin &>/dev/null
if [ $? -ne 0 ]; then
  git remote add origin git@github.com:harrykibet/RealEstateApp-IOS.git
  echo "Added GitHub remote as 'origin' with URL git@github.com:harrykibet/RealEstateApp-IOS.git"
else
  echo "GitHub remote already exists."
fi

# Verify remotes
echo "Current remotes:"
git remote -v
