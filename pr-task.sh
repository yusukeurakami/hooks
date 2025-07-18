#!/bin/bash
# PR-task hook: Creates PR using gh CLI if available

set -e

echo "🔄 Running PR-task hook..."

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a git repository"
    exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

# Only proceed if not on main or master branch
if [ "$CURRENT_BRANCH" == "main" ] || [ "$CURRENT_BRANCH" == "master" ]; then
    echo "📍 Current branch is $CURRENT_BRANCH. No need to create PR."
    exit 0
fi

# Push to remote
echo "⬆️ Pushing to remote..."
git push -u origin "$CURRENT_BRANCH"

# Create PR using gh CLI if available
if command -v gh &> /dev/null; then
    echo "🔀 Creating pull request..."

    PR_TITLE="feat: $(echo "$CURRENT_BRANCH" | sed 's/feat\///' | sed 's/-/ /g')"
    PR_BODY="$(cat <<EOF
## Summary
- Automated development workflow implementation
- Changes made via Claude Code assistant

## Test plan
- [ ] CI/CD pipeline passes
- [ ] Pre-commit hooks pass
- [ ] Unit tests pass

🤖 Generated with [Claude Code](https://claude.ai/code)
EOF
)"

    gh pr create --title "$PR_TITLE" --body "$PR_BODY" --base main --head "$CURRENT_BRANCH"

    echo "✅ Pull request created successfully"
    echo "🔗 View PR: $(gh pr view --json url -q .url)"
else
    echo "⚠️ gh CLI not available, skipping PR creation"
    echo "📋 Branch pushed: $CURRENT_BRANCH"
    echo "🔗 Create PR manually at: https://github.com/$(git config --get remote.origin.url | sed 's/.*://' | sed 's/\.git$//')/compare/main...$CURRENT_BRANCH"
fi
