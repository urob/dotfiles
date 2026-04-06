#!/bin/sh
# Read JSON data that Claude Code sends to stdin
input=$(cat)

# Extracts fields for status
MODEL=$(echo "$input" | jq -r '.model.display_name')
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
CTX=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')

COST_FMT=$(printf '$%.2f' "$COST")


GRAY='\033[37m'
GREEN='\033[32m'
YELLOW='\033[33m'
RESET='\033[0m'
LIGHTYELLOW='\033[1,33m'

if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH="$(git branch --show-current 2>/dev/null)"
    STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

    GIT_STATUS="${GRAY}(${BRANCH}${RESET}"
    [ "$STAGED" -gt 0 ] && GIT_STATUS="${GREEN}+${STAGED}${RESET}"
    [ "$MODIFIED" -gt 0 ] && GIT_STATUS="${GIT_STATUS}${YELLOW}~${MODIFIED}${RESET}"
    GIT_STATUS="${GIT_STATUS}${GRAY})${RESET}"
else
    GIT_STATUS=""
fi

echo -e "${GRAY}[$MODEL] $CTX% | $COST_FMT | ${DIR##*/}${RESET}${GIT_STATUS}${RESET}"
