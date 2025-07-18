#!/bin/bash
# Post-task hook: Formats code, commits changes

set -e

echo "🔄 Running post-task hook..."

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a git repository"
    exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

# Ensure we're not on main
if [ "$CURRENT_BRANCH" = "main" ]; then
    echo "❌ Cannot run post-task hook on main branch"
    exit 1
fi

# Check if there are any changes to commit
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "ℹ️ No changes to commit"
    exit 0
fi

# Format code using available formatters
echo "🎨 Formatting code..."

# Get list of changed and untracked files
CHANGED_FILES=$(git diff --name-only && git diff --staged --name-only)
UNTRACKED_FILES=$(git ls-files --others --exclude-standard)
ALL_FILES="$CHANGED_FILES $UNTRACKED_FILES"

if [ -n "$ALL_FILES" ]; then
    echo "🔧 Running formatter on changed and new files..."
    ./format.sh $ALL_FILES
else
    echo "ℹ️ No files to format"
fi

# Stage all files including untracked ones
echo "📝 Staging files..."
for file in $ALL_FILES; do
    git add "$file"
done

# Create commit with descriptive message
COMMIT_MSG="$(cat <<EOF
Implement automated development workflow

🤖 Generated with Claude Code (https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"

echo "💾 Committing changes..."
git commit -m "$COMMIT_MSG"

echo "✅ Post-task hook completed successfully"
