# Repository Sync Configu### Creating Personal Access Tokens

#### For Your Personal Account (Source):
1. Go to `Settings > Developer settings > Personal access tokens > Tokens (classic)`
2. Click "Generate new token (classic)"
3. Select these scopes:
   - `repo` (Full control of private repositories)
   - `read:user` (Read user profile information)
4. Copy the token and add it as `SOURCE_GITHUB_TOKEN` secret

#### For Target Organizations:

**For icp21 Organization:**
1. Go to `Settings > Developer settings > Personal access tokens > Tokens (classic)`
2. Click "Generate new token (classic)"  
3. Select these scopes:
   - `repo` (Full control of private repositories)
   - `read:org` (Read org and team membership)
   - `write:org` (Manage org access - needed to create repositories)
4. Copy the token and add it as `ICP21_GITHUB_TOKEN` secret

**For espresso21 Organization:**
1. Follow the same steps as above
2. Add the token as `ESPRESSO21_GITHUB_TOKEN` secret

**For Default/Legacy Target Organization:**
1. Follow the same steps as above
2. Add the token as `TARGET_GITHUB_TOKEN` secret

## Multi-Organization Setup

This tool now supports syncing different repositories to different organizations based on their topics:

### Setup for Multiple Organizations

1. **Configure Secrets**: Add tokens for each organization you want to sync to:
   ```
   SOURCE_GITHUB_TOKEN    - Your personal account token
   ICP21_GITHUB_TOKEN     - Token for icp21 organization  
   ESPRESSO21_GITHUB_TOKEN - Token for espresso21 organization
   TARGET_GITHUB_TOKEN    - Token for default organization (optional)
   ```

2. **Configure Variables**:
   ```
   SOURCE_USER            - Your GitHub username
   TARGET_ORG            - Default organization name (optional)
   ```

3. **Tag your repositories** with appropriate topics:
   - `codesync + icp21` → Syncs to icp21 organization
   - `codesync + espresso21` → Syncs to espresso21 organization
   - `codesync` only → Syncs to default organization (if configured)

### Benefits of Multi-Organization Sync

- **Flexible Routing**: Different repositories can sync to different organizations
- **Centralized Management**: Manage sync for multiple organizations from one workflow  
- **Topic-Based Control**: Simple topic system to control sync destinations
- **Backward Compatible**: Existing single-org setups continue to work
- **Per-Org Statistics**: Get detailed sync statistics for each organization

## Setup Instructions

### 1. Required Secrets

Add the following secrets to your repository settings (`Settings > Secrets and variables > Actions`):

- `SOURCE_GITHUB_TOKEN`: Personal Access Token for the source GitHub personal account with the following permissions:
  - `repo` (full repository access)
  - `read:user` (read user profile information)

**For Multi-Organization Sync:**
- `ICP21_GITHUB_TOKEN`: Personal Access Token for the `icp21` organization (if using)
- `ESPRESSO21_GITHUB_TOKEN`: Personal Access Token for the `espresso21` organization (if using)

**For Single Organization Sync (Legacy/Fallback):**
- `TARGET_GITHUB_TOKEN`: Personal Access Token for the target GitHub organization with the following permissions:
  - `repo` (full repository access)
  - `read:org` and `write:org` (organization access to create repositories)

### 2. Required Variables

Add the following repository variables (`Settings > Secrets and variables > Actions > Variables`):

- `SOURCE_USER`: Your GitHub username (e.g., `johndoe`)

**For Single Organization Sync (Legacy/Fallback):**
- `TARGET_ORG`: Name of the target GitHub organization (e.g., `my-company-org`)

**Note:** For multi-organization sync, target organizations are determined automatically based on repository topics.

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

- ✅ **Multi-Organization Sync**: Sync different repositories to different organizations based on topics
- ✅ **Topic-based Filtering**: Only syncs repositories with the "codesync" topic plus organization-specific topics
- ✅ **Organization Selection**: 
  - `codesync + icp21` → syncs to icp21 organization
  - `codesync + espresso21` → syncs to espresso21 organization
  - `codesync` only → syncs to default organization (if configured)
- ✅ **Branch-based Sync**: Syncs to "codesync" branch (not main) for review
- ✅ **Automatic repository creation**: Creates repositories in target org if they don't exist
- ✅ **Content sync**: Preserves all commit history and content
- ✅ **Safe merging**: Allows you to review changes before merging to main
- ✅ **Incremental sync**: Handles updates to existing branches
- ✅ **Per-organization statistics**: Detailed logging and statistics by organization
- ✅ **Error handling**: Detailed logging and error reporting
- ✅ **Skip archived repos**: Automatically skips archived repositories
- ✅ **Backward compatibility**: Works with existing single-organization setups

## How Repository Sync Works

1. **Repository Creation**: If a target repository doesn't exist, it's created automatically
2. **Content Sync**: Your main branch content is synced to a "codesync" branch in the target repository
3. **Review Process**: You can review the "codesync" branch and merge to main when ready
4. **Incremental Updates**: Subsequent pushes update the "codesync" branch with latest changes

This approach ensures you maintain control over what gets merged into the main branch of your target repositories.

## How to Mark Repositories for Sync

To sync a repository, you need to add the "codesync" topic along with an organization-specific topic:

### Multi-Organization Sync

1. Go to your repository on GitHub
2. Click the gear icon ⚙️ next to "About" on the repository page
3. In the "Topics" field, add both topics:
   - `codesync` (required for all synced repositories)
   - `icp21` (to sync to the icp21 organization)
   - OR `espresso21` (to sync to the espresso21 organization)
4. Click "Save changes"

**Examples:**
- Repository with topics `codesync, icp21` → syncs to `icp21` organization
- Repository with topics `codesync, espresso21` → syncs to `espresso21` organization
- Repository with topics `codesync, icp21, react` → syncs to `icp21` organization (additional topics are ignored)

### Legacy Single Organization Sync

If you have the `TARGET_ORG` variable and `TARGET_GITHUB_TOKEN` secret configured, repositories with only the `codesync` topic (and no organization-specific topics) will sync to the default target organization.

Only repositories with the "codesync" topic AND a valid target organization (either through organization-specific topics or default configuration) will be synced. This gives you full control over which repositories are included in the sync process.

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
3. Add the required topics to the Topics field:
   - `codesync` (always required)
   - `icp21` (for icp21 organization) OR `espresso21` (for espresso21 organization)
4. The repository will be included in the next sync run

**Examples:**
- Add topics: `codesync, icp21` → Repository will sync to icp21 organization
- Add topics: `codesync, espresso21` → Repository will sync to espresso21 organization
- Add topics: `codesync` → Repository will sync to default organization (if configured)

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

1. **Token Permissions**: Ensure tokens have sufficient permissions for each organization
2. **Organization Access**: Verify tokens can access both source and target organizations
3. **Missing Organization Tokens**: Repositories will be skipped if no valid organization token is configured
4. **Topic Configuration**: Ensure repositories have both `codesync` and a valid organization topic
5. **Rate Limiting**: GitHub API has rate limits; workflows include delays to handle this
6. **Large Repositories**: Very large repos may timeout; consider running sync manually for initial setup

### Multi-Organization Troubleshooting

1. **No repositories found**: Check that repositories have both `codesync` and organization-specific topics
2. **Organization token errors**: Verify organization-specific tokens are correctly configured as secrets
3. **Mixed sync results**: Check per-organization statistics in workflow logs to identify which org had issues
4. **Default org fallback**: Repositories with only `codesync` topic need `TARGET_ORG` and `TARGET_GITHUB_TOKEN` configured

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
