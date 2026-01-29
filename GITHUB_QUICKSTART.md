# Quick GitHub Setup Guide

## 🚀 Fast Setup (3 Steps)

### 1. Create GitHub Repository

Go to https://github.com/new and create a new repository:
- **Name**: `FM-Go`
- **Visibility**: Public (recommended) or Private
- **DO NOT** check "Initialize with README" (we already have one)

### 2. Push Your Code

Run the setup script:
```bash
./setup-github.sh
```

Then follow the instructions it prints, or manually:

```bash
# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: FM-Go Raspberry Pi FM radio receiver"

# Add your GitHub repository as remote
git remote add origin git@github.com:rossingram/FM-Go.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### 3. Update README

After pushing, edit `README.md` and replace `YOUR_USERNAME` with your actual GitHub username in the curl command.

## ✅ Installation Command for Users

Once your repository is live, users can install with:

```bash
curl -sSL https://raw.githubusercontent.com/rossingram/FM-Go/main/install.sh | sudo bash
```

## 📝 Installation URLs

**Installation command:**
```bash
curl -sSL https://raw.githubusercontent.com/rossingram/FM-Go/main/install.sh | sudo bash
```

**Clone repository:**
```bash
git clone https://github.com/rossingram/FM-Go.git
cd FM-Go
sudo ./install.sh
```

## 🔗 Repository URLs

- **Clone URL (HTTPS)**: `https://github.com/rossingram/FM-Go.git`
- **Clone URL (SSH)**: `git@github.com:rossingram/FM-Go.git`
- **Raw Installer**: `https://raw.githubusercontent.com/rossingram/FM-Go/main/install.sh`
- **Web View**: `https://github.com/rossingram/FM-Go`
