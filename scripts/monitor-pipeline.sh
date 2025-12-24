#!/bin/bash

# Monitor GitHub Actions Pipeline
# This script helps monitor the pipeline status

echo "🔍 Monitoring GitHub Actions Pipeline..."
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo ""
    echo "Please check the pipeline status manually:"
    echo "👉 https://github.com/moradom/TaskManage/actions"
    echo ""
    echo "To install GitHub CLI:"
    echo "  - macOS: brew install gh"
    echo "  - Linux: https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
    echo "  - Windows: winget install GitHub.cli"
    exit 1
fi

# Get the latest workflow run
echo "📊 Latest workflow runs:"
gh run list --limit 5

echo ""
echo "⏳ Watching the latest run..."
echo ""

# Watch the latest run
gh run watch

echo ""
echo "✅ Monitoring complete!"
