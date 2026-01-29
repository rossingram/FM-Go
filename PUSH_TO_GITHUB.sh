#!/bin/bash
# Quick script to push FM-Go to GitHub

set -e

echo "🚀 Pushing FM-Go to GitHub"
echo "=========================="
echo ""

# Initialize git if needed
if [ ! -d .git ]; then
    echo "📦 Initializing git repository..."
    git init
fi

# Add all files
echo "📋 Adding files..."
git add .

# Check if there are changes
if git diff --staged --quiet && [ -n "$(git log 2>/dev/null)" ]; then
    echo "ℹ️  No changes to commit"
else
    echo "💾 Creating commit..."
    git commit -m "Initial commit: FM-Go Raspberry Pi FM radio receiver"
fi

# Check if remote exists
if git remote get-url origin &>/dev/null; then
    echo "✅ Remote 'origin' already configured"
    git remote set-url origin git@github.com:rossingram/FM-Go.git
else
    echo "🔗 Adding remote repository..."
    git remote add origin git@github.com:rossingram/FM-Go.git
fi

# Set branch to main
git branch -M main

echo ""
echo "🚀 Pushing to GitHub..."
echo ""

# Push to GitHub
git push -u origin main

echo ""
echo "✅ Successfully pushed to GitHub!"
echo ""
echo "📦 Users can now install with:"
echo "   curl -sSL https://raw.githubusercontent.com/rossingram/FM-Go/main/install.sh | sudo bash"
echo ""
echo "🌐 View repository at:"
echo "   https://github.com/rossingram/FM-Go"
