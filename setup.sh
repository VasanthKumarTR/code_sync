#!/bin/bash

# Repository Sync Setup Script
# This script helps you set up the repository sync workflows

set -e

echo "🚀 Repository Sync Setup"
echo "========================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    print_error "GitHub CLI (gh) is not installed. Please install it first:"
    echo "  - macOS: brew install gh"
    echo "  - Linux: https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
    echo "  - Windows: https://github.com/cli/cli/releases"
    exit 1
fi

print_status "GitHub CLI found"

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    print_warning "You're not authenticated with GitHub CLI"
    echo "Please run: gh auth login"
    exit 1
fi

print_status "GitHub CLI authenticated"

# Get repository information
REPO_OWNER=$(gh repo view --json owner --jq '.owner.login' 2>/dev/null || echo "")
REPO_NAME=$(gh repo view --json name --jq '.name' 2>/dev/null || echo "")

if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ]; then
    print_error "Could not determine repository information. Make sure you're in a git repository."
    exit 1
fi

print_status "Repository: $REPO_OWNER/$REPO_NAME"

echo ""
echo "📝 Configuration Setup"
echo "======================"

# Prompt for source username
echo ""
print_info "Enter your source GitHub username (personal account where repositories will be synced FROM):"
read -p "Source Username: " SOURCE_USER

if [ -z "$SOURCE_USER" ]; then
    print_error "Source username cannot be empty"
    exit 1
fi

# Prompt for target organization
print_info "Enter your target organization name (where repositories will be synced TO):"
read -p "Target Organization: " TARGET_ORG

if [ -z "$TARGET_ORG" ]; then
    print_error "Target organization cannot be empty"
    exit 1
fi

echo ""
print_info "Setting up repository variables..."

# Set repository variables
gh variable set SOURCE_USER --body "$SOURCE_USER" --repo "$REPO_OWNER/$REPO_NAME"
gh variable set TARGET_ORG --body "$TARGET_ORG" --repo "$REPO_OWNER/$REPO_NAME"

print_status "Repository variables configured"

echo ""
echo "🔐 Token Setup"
echo "=============="
echo ""
print_warning "You need to create Personal Access Tokens for both organizations."
echo ""
print_info "For the SOURCE personal account ($SOURCE_USER), create a token with these scopes:"
echo "  - repo (Full control of private repositories)"
echo "  - read:user (Read user profile information)"
echo ""
print_info "For the TARGET organization ($TARGET_ORG), create a token with these scopes:"
echo "  - repo (Full control of private repositories)"
echo "  - read:org (Read org and team membership, read org projects)"
echo "  - write:org (Manage org access - needed to create repositories)"
echo ""

# Prompt for source token
echo ""
print_info "Create a Personal Access Token for the SOURCE personal account:"
echo "  1. Go to: https://github.com/settings/tokens/new"
echo "  2. Select the scopes mentioned above"
echo "  3. Generate token and copy it"
echo ""
read -p "Enter SOURCE GitHub token: " -s SOURCE_TOKEN
echo ""

if [ -z "$SOURCE_TOKEN" ]; then
    print_error "Source token cannot be empty"
    exit 1
fi

# Prompt for target token
print_info "Create a Personal Access Token for the TARGET organization:"
echo "  1. Go to: https://github.com/settings/tokens/new"
echo "  2. Select the scopes mentioned above (including write:org)"
echo "  3. Generate token and copy it"
echo ""
read -p "Enter TARGET GitHub token: " -s TARGET_TOKEN
echo ""

if [ -z "$TARGET_TOKEN" ]; then
    print_error "Target token cannot be empty"
    exit 1
fi

# Set secrets
print_info "Setting up repository secrets..."

echo "$SOURCE_TOKEN" | gh secret set SOURCE_GITHUB_TOKEN --repo "$REPO_OWNER/$REPO_NAME"
echo "$TARGET_TOKEN" | gh secret set TARGET_GITHUB_TOKEN --repo "$REPO_OWNER/$REPO_NAME"

print_status "Repository secrets configured"

echo ""
echo "🧪 Testing Configuration"
echo "========================"

# Test tokens and organizations
print_info "Testing source personal account access..."

# Create a temporary test script
cat > test_config.js << 'EOF'
const { Octokit } = require('@octokit/rest');

async function testConfig() {
    const sourceToken = process.argv[2];
    const targetToken = process.argv[3];
    const sourceUser = process.argv[4];
    const targetOrg = process.argv[5];
    
    const sourceOctokit = new Octokit({ auth: sourceToken });
    const targetOctokit = new Octokit({ auth: targetToken });
    
    try {
        // Test source user access
        console.log('Testing source user access...');
        const sourceUserResponse = await sourceOctokit.users.getAuthenticated();
        console.log(`✓ Source user (${sourceUser}): ${sourceUserResponse.data.name || sourceUser}`);
        
        // Test target org access
        console.log('Testing target organization access...');
        const targetOrgResponse = await targetOctokit.orgs.get({ org: targetOrg });
        console.log(`✓ Target org (${targetOrg}): ${targetOrgResponse.data.name || targetOrg}`);
        
        // Count repositories
        console.log('Counting repositories...');
        const sourceRepos = await sourceOctokit.repos.listForAuthenticatedUser({ 
            visibility: 'all', 
            affiliation: 'owner',
            per_page: 1 
        });
        const targetRepos = await targetOctokit.repos.listForOrg({ org: targetOrg, per_page: 1 });
        
        console.log(`✓ Source repositories found: ${sourceRepos.headers.link ? 'Many' : sourceRepos.data.length}`);
        console.log(`✓ Target repositories found: ${targetRepos.headers.link ? 'Many' : targetRepos.data.length}`);
        
        console.log('\n✅ Configuration test successful!');
        
    } catch (error) {
        console.error('❌ Configuration test failed:', error.message);
        if (error.status === 404) {
            console.error('   User/Organization not found or access denied');
        } else if (error.status === 401) {
            console.error('   Invalid or insufficient token permissions');
        }
        process.exit(1);
    }
}

testConfig();
EOF

# Check if Node.js is available
if command -v node &> /dev/null; then
    # Install @octokit/rest if needed
    if [ ! -d "node_modules" ]; then
        print_info "Installing dependencies for configuration test..."
        npm init -y &> /dev/null
        npm install @octokit/rest &> /dev/null
    fi
    
    # Run the test
    node test_config.js "$SOURCE_TOKEN" "$TARGET_TOKEN" "$SOURCE_USER" "$TARGET_ORG"
    
    # Clean up
    rm -f test_config.js
else
    print_warning "Node.js not found. Skipping configuration test."
    print_info "You can manually test the configuration by running the workflows."
fi

echo ""
echo "🎉 Setup Complete!"
echo "=================="
echo ""
print_status "Repository sync is now configured!"
echo ""
print_info "Configuration Summary:"
echo "  • Source User: $SOURCE_USER"
echo "  • Target Organization: $TARGET_ORG"
echo "  • Repository: $REPO_OWNER/$REPO_NAME"
echo ""
print_info "Available workflows:"
echo "  • sync-repos.yml: Main sync workflow (manual, scheduled, on push)"
echo "  • monitor-repos.yml: Monitors for new repositories every 10 minutes"
echo "  • advanced-sync.yml: Advanced sync with parallel processing and options"
echo "  • push-trigger.yml: Template for individual repo push triggers"
echo ""
print_info "Next steps:"
echo "  1. Add 'codesync' topic to repositories you want to sync"
echo "  2. Go to the Actions tab in your repository to see the workflows"
echo "  3. Run 'Sync Repositories' manually for the initial sync"
echo "  4. Content will sync to 'codesync' branch in target repos (not main)"
echo "  5. Review and merge 'codesync' branch to main in target repos as needed"
echo ""
print_info "To manually trigger a sync:"
echo "  gh workflow run 'Sync Repositories' --repo $REPO_OWNER/$REPO_NAME"
echo ""
print_warning "Security reminders:"
echo "  • Regularly rotate your Personal Access Tokens"
echo "  • Monitor workflow runs for any security issues"
echo "  • Review synced repositories periodically"
