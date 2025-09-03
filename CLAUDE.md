# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a GitHub repository synchronization tool that automates syncing repositories from personal GitHub accounts to organizations. The project uses Node.js with the Octokit library for GitHub API interactions and GitHub Actions for automation.

## Common Commands

### Setup and Configuration
```bash
# Initial setup with interactive prompts
./setup.sh

# Manual setup using npm (install dependencies)
npm install
```

### Running Workflows
```bash
# Trigger sync manually via GitHub CLI
gh workflow run "Repository Sync"

# Trigger with force sync option
gh workflow run "Repository Sync" -f force_sync_all=true

# List workflow runs
gh workflow list
gh run list
```

### Development Commands
```bash
# Test dependencies installation
npm install @octokit/rest

# Run basic Node.js scripts
node sync-script.js
```

## Architecture

### Core Components

1. **GitHub Actions Workflow** (`.github/workflows/`):
   - `repo-sync.yml`: Single streamlined workflow that monitors for changes and syncs repositories with "codesync" topic

2. **Setup Script** (`setup.sh`):
   - Interactive configuration tool
   - Sets up GitHub CLI authentication
   - Configures repository secrets and variables
   - Tests token permissions and organization access

3. **Sync Logic** (embedded in workflow):
   - Uses `@octokit/rest` for GitHub API operations
   - Tracks last sync times to detect changes and avoid unnecessary syncs
   - Clones source repositories with authentication
   - Creates "codesync" branch in target repositories
   - Handles repository creation, branch management, and force-push scenarios

### Key Design Patterns

- **Topic-based filtering**: Only repositories with "codesync" topic are synchronized
- **Safe branching**: Content syncs to "codesync" branch, not main, for review
- **Change detection**: Tracks last sync times and only syncs when repositories have been updated
- **Authentication via tokens**: Uses GitHub Personal Access Tokens stored as repository secrets
- **Error handling**: Comprehensive logging and graceful failure handling
- **Efficient monitoring**: Runs every 5 minutes but skips unchanged repositories

### Configuration

The system requires these repository secrets:
- `SOURCE_GITHUB_TOKEN`: Personal access token for source account
- `TARGET_GITHUB_TOKEN`: Personal access token for target organization

And these repository variables:
- `SOURCE_USER`: GitHub username of source account
- `TARGET_ORG`: Target organization name

### Workflow Triggers

- **Schedule**: Runs every 5 minutes to detect changes quickly
- **Manual dispatch**: Can be triggered manually with optional force sync

## Important Notes

- Single streamlined workflow replaces previous multiple workflows for efficiency
- Runs every 5 minutes but only syncs repositories that have changed since last sync
- All logic is embedded within the GitHub Actions workflow as inline Node.js script
- Authentication and permissions are critical - tokens must have appropriate scopes
- The sync process preserves commit history and repository settings
- Archived repositories are automatically skipped during synchronization
- Change detection prevents unnecessary syncs, making frequent monitoring efficient