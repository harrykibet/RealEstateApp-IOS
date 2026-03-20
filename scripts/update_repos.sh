#!/bin/bash
set -e

# ---------------- CONFIG ----------------
repos=("gitlab" "github")
branch="main"
MAX_SIZE=$((50 * 1024 * 1024)) # 50MB
BLOCKED_EXTENSIONS=("app" "ipa" "dSYM" "log" "hprof")
BLOCKED_DIRECTORIES=("build/" "DerivedData/" ".build/" "Pods/" "Carthage/Build/" "xcuserdata/" ".swiftpm/" "spm/")
DRY_RUN=false
# ----------------------------------------

# -------- Parse Arguments --------
for arg in "$@"; do
    case $arg in
        --dry-run)
        DRY_RUN=true
        shift
        ;;
    esac
done

# -------- Colors --------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

# -------- Utility Functions --------
is_binary() {
    file "$1" | grep -q "binary"
}

check_blocked_files() {
    FILES=$(git diff --cached --name-only)

    for FILE in $FILES; do
        [ -f "$FILE" ] || continue

        # Block directories
        for DIR in "${BLOCKED_DIRECTORIES[@]}"; do
            if [[ "$FILE" == *"$DIR"* ]]; then
                echo -e "${RED}❌ Refusing to commit file in blocked directory: $FILE${NC}"
                exit 1
            fi
        done

        # Block extensions
        for EXT in "${BLOCKED_EXTENSIONS[@]}"; do
            if [[ "$FILE" == *.$EXT ]]; then
                echo -e "${RED}❌ Blocked file type: .$EXT ($FILE)${NC}"
                echo -e "${YELLOW}Add it to .gitignore or use Git LFS if intentional.${NC}"
                exit 1
            fi
        done
    done
}

check_large_files() {
    echo -e "${CYAN}🔍 Scanning for large files (>$(($MAX_SIZE / 1024 / 1024))MB)...${NC}"

    LARGE_FILES=$(find . -type f \( -name "*" \) -not -path "./.git/*" -not -path "./Pods/*" -not -path "./Carthage/Build/*" | while read f; do
        SIZE=$(stat -f %z "$f" 2>/dev/null || echo 0)
        if [ "$SIZE" -gt "$MAX_SIZE" ]; then
            echo "$SIZE $f"
        fi
    done)

    if [ -n "$LARGE_FILES" ]; then
        echo -e "${RED}⚠️ Large files detected:${NC}"
        echo "$LARGE_FILES" | while read size path; do
            SIZE_MB=$(($size / 1024 / 1024))
            echo -e "${YELLOW}- $path (${SIZE_MB}MB)${NC}"
        done
        echo -e "${RED}❌ Commit aborted due to large files.${NC}"
        exit 1
    else
        echo -e "${GREEN}✅ No oversized files found.${NC}"
    fi
}

ensure_clean_state() {
    if [ -d ".git/rebase-merge" ] || [ -d ".git/rebase-apply" ]; then
        echo -e "${RED}❌ Rebase in progress. Resolve first.${NC}"
        exit 1
    fi
}

show_commit_summary() {
    echo "${CYAN}📋 Commit Summary:${NC}"
    git --no-pager diff --cached --stat
    echo ""
}

update_repo() {
    local remote="$1"

    echo -e "${CYAN}🚀 Syncing: $remote${NC}"

    ensure_clean_state

    echo -e "${GRAY}→ Staging changes...${NC}"
    git add -u

    if [[ -n "$(git status --porcelain)" ]]; then
        check_blocked_files
        check_large_files

        timestamp="$(date +"%Y-%m-%d %H:%M:%S")"
        commit_message="chore(sync): auto update $timestamp"

        show_commit_summary

        if [ "$DRY_RUN" = true ]; then
            echo -e "${YELLOW}🧪 DRY RUN MODE — No commit performed.${NC}"
        else
            git commit -m "$commit_message"
            echo -e "${YELLOW}✔ Committed.${NC}"
        fi
    else
        echo -e "${GRAY}No local changes to commit.${NC}"
    fi

    echo -e "${GRAY}→ Pulling (rebase)...${NC}"
    git pull --rebase "$remote" "$branch"

    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}🧪 DRY RUN MODE — No push performed.${NC}"
        return
    fi

    echo -e "${GRAY}→ Pushing to $remote...${NC}"
    git push "$remote" "$branch"

    echo -e "${GREEN}✅ Synced $remote successfully.${NC}"
    echo "---------------------------------------------"
}

# -------- Execution --------
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo -e "${RED}❌ Not inside a Git repository.${NC}"
    exit 1
fi

for remote in "${repos[@]}"; do
    update_repo "$remote"
done

echo -e "${GREEN}🎯 All remotes processed.${NC}"
