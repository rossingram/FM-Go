# Setting Up GitHub Repository

## Step 1: Create GitHub Repository

1. Go to [GitHub](https://github.com/new)
2. Create a new repository named `FM-Go`
3. **Do NOT** initialize with README, .gitignore, or license (we already have these)
4. Copy the repository URL (e.g., `https://github.com/YOUR_USERNAME/FM-Go.git`)

## Step 2: Initialize and Push

Run these commands in the project directory:

```bash
# Initialize git repository
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: FM-Go Raspberry Pi FM radio receiver"

# Add remote repository
git remote add origin git@github.com:rossingram/FM-Go.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## Step 3: Update README with Your URL

After pushing, update the README.md file to replace `YOUR_USERNAME` with your actual GitHub username, or update the curl command to use the raw GitHub URL:

```bash
curl -sSL https://raw.githubusercontent.com/rossingram/FM-Go/main/install.sh | sudo bash
```

## Step 4: (Optional) Set Up Custom Domain

If you want to use `install.fm-go.org` instead of the GitHub raw URL:

1. Set up a domain or subdomain pointing to GitHub Pages or a simple redirect
2. Create an `install.sh` file that redirects to the GitHub raw URL, or
3. Host the installer script on your own server

## Verification

After pushing, verify the installation works:

```bash
# Test the curl command (replace YOUR_USERNAME)
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/FM-Go/main/install.sh | head -20
```

You should see the installer script output.
