#!/bin/bash
# Pre-task hook: Ensures we're on main branch, pulls latest, and creates feature branch

set -e

echo "🔄 Running pre-task hook..."

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a git repository"
    exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

# Only proceed if on main or master branch
if [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; then
    echo "📍 Current branch is $CURRENT_BRANCH. No action needed."
    exit 0
fi

# Pull latest changes from remote main/master
echo "⬇️ Pulling latest changes from remote $CURRENT_BRANCH..."
git pull origin "$CURRENT_BRANCH"

# Generate feature branch name with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FEATURE_BRANCH="feat/claude-task-$TIMESTAMP"

# Create and switch to feature branch
echo "🌿 Creating feature branch: $FEATURE_BRANCH"
git checkout -b "$FEATURE_BRANCH"

echo "✅ Pre-task hook completed successfully"
echo "📋 Ready to work on: $FEATURE_BRANCH"
