# Repository Sync Configu### Creating Personal Access Tokens

#### For Your Personal Account (Source):
1. Go to `Settings > Developer settings > Personal access tokens > Tokens (classic)`
2. Click "Generate new token (classic)"
3. Select these scopes:
   - `repo` (Full control of private repositories)
   - `read:user` (Read user profile information)
4. Copy the token and add it as `SOURCE_GITHUB_TOKEN` secret

#### For Target Organization:
1. Go to `Settings > Developer settings > Personal access tokens > Tokens (classic)`
2. Click "Generate new token (classic)"  
3. Select these scopes:
   - `repo` (Full control of private repositories)
   - `read:org` (Read org and team membership)
   - `write:org` (Manage org access - needed to create repositories)
4. Copy the token and add it as `TARGET_GITHUB_TOKEN` secrets repository contains GitHub Actions workflows to automatically sync repositories from a personal GitHub account to a GitHub organization.

## Setup Instructions

### 1. Required Secrets

Add the following secrets to your repository settings (`Settings > Secrets and variables > Actions`):

- `SOURCE_GITHUB_TOKEN`: Personal Access Token for the source GitHub personal account with the following permissions:
  - `repo` (full repository access)
  - `read:user` (read user profile information)
  
- `TARGET_GITHUB_TOKEN`: Personal Access Token for the target GitHub organization with the following permissions:
  - `repo` (full repository access)
  - `read:org` and `write:org` (organization access to create repositories)

### 2. Required Variables

Add the following repository variables (`Settings > Secrets and variables > Actions > Variables`):

- `SOURCE_USER`: Your GitHub username (e.g., `johndoe`)
- `TARGET_ORG`: Name of the target GitHub organization (e.g., `my-company-org`)

### 3. Creating Personal Access Tokens

#### For GitHub.com:
1. Go to `Settings > Developer settings > Personal access tokens > Tokens (classic)`
2. Click "Generate new token (classic)"
3. Select appropriate scopes as mentioned above
4. Copy the token and add it as a secret

#### For GitHub Enterprise:
1. Go to your GitHub Enterprise instance
2. Follow similar steps as above

### 4. Workflow Files

This repository includes three workflows:

#### `sync-repos.yml` - Main Sync Workflow
- **Triggers**: 
  - Manual dispatch
  - Push to main branch
  - Daily schedule (2 AM UTC)
- **Purpose**: Syncs all repositories with "codesync" topic from source to target organization

#### `monitor-repos.yml` - New Repository Monitor
- **Triggers**: 
  - Every 10 minutes (configurable)
  - Manual dispatch
- **Purpose**: Checks for new repositories with "codesync" topic and triggers sync if found

#### `advanced-sync.yml` - Enhanced Sync with Options
- **Triggers**: 
  - Every 6 hours
  - Manual dispatch with options (dry-run, specific repos, etc.)
- **Purpose**: Parallel processing with matrix strategy and advanced features

#### `push-trigger.yml` - Individual Repository Push Sync (Template)
- **Triggers**: 
  - Push to main/master branch (when placed in individual repos)
- **Purpose**: Template workflow for immediate sync on push to main
- **Setup**: Copy this workflow to individual repositories for instant sync on push

## Features

- ✅ **Topic-based Filtering**: Only syncs repositories with the "codesync" topic
- ✅ **Branch-based Sync**: Syncs to "codesync" branch (not main) for review
- ✅ **Automatic repository creation**: Creates repositories in target org if they don't exist
- ✅ **Content sync**: Preserves all commit history and content
- ✅ **Safe merging**: Allows you to review changes before merging to main
- ✅ **Incremental sync**: Handles updates to existing branches
- ✅ **Error handling**: Detailed logging and error reporting
- ✅ **Skip archived repos**: Automatically skips archived repositories

## How Repository Sync Works

1. **Repository Creation**: If a target repository doesn't exist, it's created automatically
2. **Content Sync**: Your main branch content is synced to a "codesync" branch in the target repository
3. **Review Process**: You can review the "codesync" branch and merge to main when ready
4. **Incremental Updates**: Subsequent pushes update the "codesync" branch with latest changes

This approach ensures you maintain control over what gets merged into the main branch of your target repositories.

## How to Mark Repositories for Sync

To sync a repository, you need to add the "codesync" topic to it:

1. Go to your repository on GitHub
2. Click the gear icon ⚙️ next to "About" on the repository page
3. In the "Topics" field, add `codesync`
4. Click "Save changes"

Only repositories with the "codesync" topic will be synced. This gives you full control over which repositories are included in the sync process.

## Configuration Options

### Customizing Sync Frequency

Edit the cron schedule in the workflows:

```yaml
schedule:
  - cron: '0 2 * * *'  # Daily at 2 AM UTC
  # - cron: '0 */6 * * *'  # Every 6 hours
  # - cron: '*/30 * * * *'  # Every 30 minutes
```

### Excluding Repositories

By default, only repositories with the "codesync" topic are synced. To exclude a repository from syncing, simply remove the "codesync" topic from it.

### Including Additional Repositories

To include a repository in the sync process:

1. Go to the repository on GitHub
2. Click the gear icon next to "About"
3. Add "codesync" to the Topics field
4. The repository will be included in the next sync run

### Working with the Codesync Branch

When repositories are synced, content goes to the "codesync" branch in the target repository:

1. **Review Changes**: Check the "codesync" branch for new content
2. **Create Pull Request**: Create a PR from "codesync" to "main" for review
3. **Merge When Ready**: Merge the PR after review and testing
4. **Automatic Updates**: Future syncs will update the "codesync" branch

This workflow ensures you maintain control over what enters your main branch.

### Repository Settings Sync

The workflow syncs the following repository settings:
- Description
- Private/Public visibility
- Issues enabled/disabled
- Projects enabled/disabled  
- Wiki enabled/disabled

## Troubleshooting

### Common Issues

1. **Token Permissions**: Ensure tokens have sufficient permissions
2. **Organization Access**: Verify tokens can access both source and target organizations
3. **Rate Limiting**: GitHub API has rate limits; workflows include delays to handle this
4. **Large Repositories**: Very large repos may timeout; consider running sync manually for initial setup

### Monitoring Workflow Runs

Check workflow runs in the `Actions` tab to monitor sync status and view detailed logs.

### Manual Sync

To manually trigger a sync:
1. Go to `Actions` tab
2. Select `Sync Repositories` workflow
3. Click `Run workflow`
4. Optionally check "Sync all repositories" for a full sync

## Security Considerations

- Store tokens as encrypted secrets, never in code
- Use principle of least privilege for token permissions
- Regularly rotate personal access tokens
- Monitor workflow logs for any security issues
- Consider using GitHub Apps for enhanced security (advanced setup)

## Advanced Configuration

### Using GitHub Apps (Recommended for Production)

For production use, consider using GitHub Apps instead of personal access tokens:

1. Create a GitHub App with necessary permissions
2. Install the app on both source and target organizations
3. Modify workflows to use app authentication
4. This provides better security and audit trails

## Support

If you encounter issues:
1. Check the workflow run logs in the Actions tab
2. Verify all secrets and variables are correctly set
3. Ensure tokens have the required permissions
4. Check GitHub's status page for any service issues
