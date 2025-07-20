# Quick Start Guide

## 🚀 Get Started in 3 Steps

### 1. Setup
```bash
git clone https://github.com/VasanthKumarTR/code_sync.git
cd code_sync
chmod +x setup.sh
./setup.sh
```

### 2. Add Topic to Repositories
Add the `codesync` topic to any repository you want to sync:
- Go to your repository on GitHub
- Click the gear ⚙️ icon next to "About"  
- Add `codesync` in the Topics field
- Save changes

### 3. Run Initial Sync
```bash
# Using GitHub CLI
gh workflow run "Sync Repositories"

# Or go to Actions tab in GitHub and click "Run workflow"
```

## 📋 What You Get

### ✅ 3 Automated Workflows
- **sync-repos.yml**: Main sync (daily + manual + on push)
- **monitor-repos.yml**: Checks for new repos every 10 minutes  
- **advanced-sync.yml**: Parallel sync with options (dry-run, etc.)

### ✅ Key Features
- 🔄 **Content Sync**: Full commit history and content
- 🏗️ **Auto-Create**: Creates missing repositories  
- 🏷️ **Topic-based**: Only syncs repos with "codesync" topic
- 🌿 **Safe Branching**: Syncs to "codesync" branch for review
- 🚫 **Skip Archived**: Automatically skips archived repos
- 🔐 **Secure**: Uses encrypted GitHub secrets

### ✅ Your Requirements Met
- ✅ **New Repository Creation**: Monitored every 10 minutes
- ✅ **Push to Main Branch**: Content syncs to "codesync" branch  
- ✅ **Personal Account → Organization**: Perfectly configured
- ✅ **Selective Sync**: Only repos with "codesync" topic
- ✅ **Safe Review Process**: Changes go to separate branch first

## 🎯 Perfect For
- Syncing your personal repositories to a company organization
- Creating selective backups of important repositories
- Moving specific projects to an organization structure

That's it! Simple, clean, and focused on your exact needs.

Need help? Check the full README.md for detailed instructions!
