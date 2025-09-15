# Quick Start Guide

## 🚀 Get Started in 3 Steps

### 1. Setup
```bash
git clone https://github.com/VasanthKumarTR/code_sync.git
cd code_sync
chmod +x setup.sh
./setup.sh
```

### 2. Add Topics to Repositories

**For Multi-Organization Sync:**
Add both `codesync` and an organization-specific topic to your repositories:
- Go to your repository on GitHub
- Click the gear ⚙️ icon next to "About"  
- Add topics in the Topics field:
  - `codesync` + `icp21` → Syncs to icp21 organization
  - `codesync` + `espresso21` → Syncs to espresso21 organization
- Save changes

**For Single Organization Sync:**
Add only the `codesync` topic to sync to your default organization (if configured):
- Add `codesync` in the Topics field

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
- 🏷️ **Multi-Org Sync**: Different repos to different organizations based on topics
- 🎯 **Organization Selection**: `codesync + icp21` → icp21 org, `codesync + espresso21` → espresso21 org
- 🌿 **Safe Branching**: Syncs to "codesync" branch for review
- 🚫 **Skip Archived**: Automatically skips archived repos
- 📊 **Per-Org Stats**: Detailed sync statistics for each organization
- 🔐 **Secure**: Uses encrypted GitHub secrets

### ✅ Your Requirements Met
- ✅ **New Repository Creation**: Monitored every 10 minutes
- ✅ **Push to Main Branch**: Content syncs to "codesync" branch  
- ✅ **Personal Account → Organization**: Perfectly configured
- ✅ **Selective Sync**: Only repos with "codesync" topic
- ✅ **Safe Review Process**: Changes go to separate branch first

## 🎯 Perfect For
- Syncing different repositories to different organizations based on project types
- Managing multiple organization targets from a single personal account
- Creating selective backups to specific organizations
- Moving specific projects to appropriate organization structures
- Centralized management of multi-organization repository synchronization

That's it! Simple, clean, and focused on your exact needs.

Need help? Check the full README.md for detailed instructions!
