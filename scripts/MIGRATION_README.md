# Migration to Organization-Wide Workflows

This document explains how to use the migration script to add organization-wide workflows to a repository.

## Prerequisites

1. GitHub CLI (`gh`) installed and authenticated
2. Bash shell
3. Permission to push to the target repository

## Usage

```bash
./migrate_to_org_workflows.sh <repository-name> [--gitflow]
```

### Parameters

- `<repository-name>`: The name of the repository to migrate (without the organization name)
- `--gitflow`: Optional flag to indicate that the repository uses GitFlow (will create PRs for both main and develop branches)

### Examples

```bash
# Migrate a regular repository
./migrate_to_org_workflows.sh my-repository

# Migrate a GitFlow repository
./migrate_to_org_workflows.sh my-gitflow-repository --gitflow
```

## What the Script Does

1. Clones the target repository
2. Creates the necessary workflow files in the `.github/workflows` directory:
   - `issue-labeler.yml`
   - `contributing-reminder.yml`
   - `pr-status-tracker.yml`
   - `label-creator.yml`
   - `ci-failure-reminder.yml`
   - `release-pr-generator.yml`
3. Creates a branch and commits the changes
4. Creates a PR to merge the changes
5. If the repository uses GitFlow, creates a second PR for the other long-living branch

## After Running the Script

After the script completes successfully:

1. Review and merge the PR(s)
2. Run the Label Creator workflow to create the standard labels in the repository:
   - Go to the "Actions" tab in the repository
   - Select the "Label Creator" workflow
   - Click "Run workflow"
   - Click "Run workflow" again to confirm

## Troubleshooting

If the script fails:

1. Check the error message
2. Verify that you have permission to push to the repository
3. Verify that the repository exists
4. Try running the script again with the `--gitflow` flag if the repository uses GitFlow

If the workflows fail after merging:

1. Check the workflow logs for error messages
2. Verify that the workflows have the necessary permissions
3. Verify that the organization-wide workflows in the `.github` repository are working correctly
