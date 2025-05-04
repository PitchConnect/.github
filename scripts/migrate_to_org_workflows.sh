#!/bin/bash

# Script to migrate a repository to use organization-wide workflows
# Usage: ./migrate_to_org_workflows.sh <repository-name> [--gitflow]

set -e

# Check if repository name is provided
if [ $# -lt 1 ]; then
  echo "Usage: $0 <repository-name> [--gitflow]"
  exit 1
fi

REPO_NAME=$1
GITFLOW=false

# Check if --gitflow flag is provided
if [ "$2" == "--gitflow" ]; then
  GITFLOW=true
fi

# Create temporary directory
TEMP_DIR=$(mktemp -d)
echo "Created temporary directory: $TEMP_DIR"

# Clone the repository
echo "Cloning repository: $REPO_NAME"
gh repo clone "PitchConnect/$REPO_NAME" "$TEMP_DIR/$REPO_NAME"
cd "$TEMP_DIR/$REPO_NAME"

# Set git configuration
git config user.email "github-actions@github.com"
git config user.name "GitHub Actions"

# Create .github/workflows directory if it doesn't exist
mkdir -p .github/workflows

# Create issue-labeler.yml
echo "Creating issue-labeler.yml"
cat > .github/workflows/issue-labeler.yml << 'EOF'
name: Issue Labeler

on:
  issues:
    types: [opened]

jobs:
  label-issue:
    uses: PitchConnect/.github/.github/workflows/issue-labeler.yml@main
    with:
      label_name: 'triage'
EOF

# Create contributing-reminder.yml
echo "Creating contributing-reminder.yml"
cat > .github/workflows/contributing-reminder.yml << 'EOF'
name: Contributing Guidelines Reminder

on:
  issues:
    types: [opened]
  pull_request:
    types: [opened]

jobs:
  check-contributing-reference:
    uses: PitchConnect/.github/.github/workflows/contributing-reminder.yml@main
    with:
      contributing_url: 'https://github.com/PitchConnect/contribution-guidelines/blob/main/CONTRIBUTING.md'
EOF

# Create pr-status-tracker.yml
echo "Creating pr-status-tracker.yml"
cat > .github/workflows/pr-status-tracker.yml << 'EOF'
name: PR Status Tracker

on:
  pull_request:
    types: [opened, converted_to_draft, ready_for_review, closed]

jobs:
  track-pr-status:
    uses: PitchConnect/.github/.github/workflows/pr-status-tracker.yml@main
    permissions:
      issues: write
      pull-requests: write
      contents: read
EOF

# Create label-creator.yml
echo "Creating label-creator.yml"
cat > .github/workflows/label-creator.yml << 'EOF'
name: Label Creator

on:
  workflow_dispatch:

jobs:
  create-labels:
    uses: PitchConnect/.github/.github/workflows/label-creator.yml@main
    permissions:
      issues: write
      contents: read
EOF

# Create ci-failure-reminder.yml
echo "Creating ci-failure-reminder.yml"
cat > .github/workflows/ci-failure-reminder.yml << 'EOF'
name: CI Failure Reminder

on:
  workflow_run:
    workflows: ["CI", "Build", "Test"]
    types:
      - completed

jobs:
  remind-on-failure:
    uses: PitchConnect/.github/.github/workflows/ci-failure-reminder.yml@main
EOF

# Create release-pr-generator.yml
echo "Creating release-pr-generator.yml"
cat > .github/workflows/release-pr-generator.yml << 'EOF'
name: Release PR Generator

on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Release version (e.g., 1.2.0)'
        required: true

jobs:
  generate-release-pr:
    uses: PitchConnect/.github/.github/workflows/release-pr-generator.yml@main
    with:
      version: ${{ github.event.inputs.version }}
EOF

# Function to create a branch, commit changes, and create a PR
create_branch_and_pr() {
  local branch_name=$1
  local base_branch=$2
  local pr_title="Add organization-wide workflows"
  
  # Create a new branch
  git checkout -b "$branch_name" "$base_branch"
  
  # Add and commit changes
  git add .github/workflows/
  git commit -m "Add organization-wide workflows"
  
  # Push changes
  git push -u origin "$branch_name"
  
  # Create PR
  pr_body="# Add Organization-Wide Workflows

This PR adds organization-wide workflows to the repository:

1. **Issue Labeler**: Automatically adds a \"triage\" label to new issues
2. **Contributing Guidelines Reminder**: Checks if issues/PRs reference CONTRIBUTING.md
3. **PR Status Tracker**: Updates issue labels based on PR status
4. **Label Creator**: Creates standard labels in the repository
5. **CI Failure Reminder**: Reminds about pre-commit hooks on CI failure
6. **Release PR Generator**: Generates release PRs with all pending issues

## Benefits

1. **Automated Issue Tracking**: Issues are automatically labeled and tracked through the development lifecycle
2. **Consistent Process**: Ensures a consistent process across all repositories
3. **Reduced Manual Work**: Automates repetitive tasks
4. **Better Visibility**: Provides better visibility into the status of issues and PRs

## After Merging

After merging this PR, please run the Label Creator workflow to create the standard labels in the repository."
  
  gh pr create --title "$pr_title" --body "$pr_body" --base "$base_branch"
}

# Create branch and PR for default branch
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
echo "Default branch: $DEFAULT_BRANCH"
create_branch_and_pr "feature/add-org-workflows" "$DEFAULT_BRANCH"

# If GitFlow, create branch and PR for the other long-living branch
if [ "$GITFLOW" = true ]; then
  if [ "$DEFAULT_BRANCH" = "main" ]; then
    OTHER_BRANCH="develop"
  else
    OTHER_BRANCH="main"
  fi
  
  echo "GitFlow repository detected. Creating PR for $OTHER_BRANCH branch as well."
  git fetch origin "$OTHER_BRANCH"
  create_branch_and_pr "feature/add-org-workflows-$OTHER_BRANCH" "$OTHER_BRANCH"
fi

echo "Migration completed successfully!"
echo "PRs created for the repository: $REPO_NAME"
echo "Please review and merge the PRs, then run the Label Creator workflow."

# Clean up
cd -
rm -rf "$TEMP_DIR"
