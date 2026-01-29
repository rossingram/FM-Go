#!/bin/bash
# Quick script to set up GitHub repository for FM-Go

set -e

echo "🚀 FM-Go GitHub Setup"
echo "===================="
echo ""

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install git first."
    exit 1
fi

# Check if already a git repo
if [ -d .git ]; then
    echo "⚠️  Git repository already initialized"
else
    echo "📦 Initializing git repository..."
    git init
fi

# Add all files
echo "📋 Adding files to git..."
git add .

# Check if there are changes to commit
if git diff --staged --quiet; then
    echo "ℹ️  No changes to commit"
else
    echo "💾 Creating initial commit..."
    git commit -m "Initial commit: FM-Go Raspberry Pi FM radio receiver"
fi

echo ""
echo "✅ Local git repository ready!"
echo ""
echo "Next steps:"
echo "1. Create a new repository on GitHub: https://github.com/new"
echo "2. Name it 'FM-Go' (or your preferred name)"
echo "3. Do NOT initialize with README, .gitignore, or license"
echo "4. Copy the repository URL"
echo "5. Run these commands (replace YOUR_USERNAME and REPO_NAME):"
echo ""
echo "   git remote add origin git@github.com:rossingram/FM-Go.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "After pushing, users can install with:"
echo "   curl -sSL https://raw.githubusercontent.com/rossingram/FM-Go/main/install.sh | sudo bash"
