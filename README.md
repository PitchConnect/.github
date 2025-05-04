# PitchConnect Organization-Wide Workflows

This repository contains reusable GitHub Actions workflows that can be used across all repositories in the PitchConnect organization.

## 🚧 Workflow Automation Monitoring 🚧

We've recently implemented automated workflows for issue and PR tracking. During this rollout period:

1. **Please monitor issue label changes** when:
   - Creating a new issue (should get "triage" label)
   - Creating a draft PR (referenced issue should get "in-progress" label)
   - Marking a PR as ready (issue should get "review-ready" label)
   - Merging a PR (issue should get "merged-to-develop" label)

2. **If you notice any issues** with the automation (labels not changing, comments not appearing):
   - Please create an issue in this repository
   - Include details about what happened vs. what you expected
   - Reference the issue and PR numbers involved

Your feedback is crucial to ensuring these workflows function correctly across all repositories.

This notice will be removed once the rollout is complete and the workflows are verified to be working correctly.

## Available Workflows

### Issue Labeler

Automatically adds a label to new issues.

```yaml
name: Issue Labeler

on:
  issues:
    types: [opened]

jobs:
  label-issue:
    uses: PitchConnect/.github/.github/workflows/issue-labeler.yml@main
    permissions:
      issues: write
      contents: read
    with:
      label_name: 'triage'  # Optional, defaults to 'triage'
```

### Contributing Guidelines Reminder

Checks if issues/PRs reference CONTRIBUTING.md and adds a reminder comment if they don't.

```yaml
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
      contributing_url: 'https://github.com/PitchConnect/contribution-guidelines/blob/main/CONTRIBUTING.md'  # Optional
```

### PR Status Tracker

Updates issue labels based on PR status (draft, ready, merged).

```yaml
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
```

### Label Creator

Creates standard labels in the repository (can be run manually).

```yaml
name: Label Creator

on:
  workflow_dispatch:

jobs:
  create-labels:
    uses: PitchConnect/.github/.github/workflows/label-creator.yml@main
    permissions:
      issues: write
      contents: read
```

### CI Failure Reminder

Adds a comment to PRs when CI/CD checks fail, reminding about pre-commit hooks.

```yaml
name: CI Failure Reminder

on:
  workflow_run:
    workflows: ["CI", "Build", "Test"]  # Add your CI workflow names here
    types:
      - completed

jobs:
  remind-on-failure:
    uses: PitchConnect/.github/.github/workflows/ci-failure-reminder.yml@main
```

### Release PR Generator

Generates release PRs with all pending issues (can be run manually).

```yaml
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
```

## Implementation

To use these workflows in your repository:

1. Create a `.github/workflows` directory in your repository if it doesn't exist
2. Create a workflow file for each workflow you want to use
3. Copy the example YAML for that workflow into the file
4. Commit and push the changes

Alternatively, use the migration script to add all workflows at once:

```bash
# For standard repositories
./scripts/migrate_to_org_workflows.sh <repository-name>

# For GitFlow repositories
./scripts/migrate_to_org_workflows.sh <repository-name> --gitflow
```

## Important: GitFlow Considerations

For repositories using GitFlow with both `main` and `develop` as long-living branches:

**⚠️ CRITICAL: Workflows must be implemented on BOTH branches ⚠️**

1. First implement on `develop` branch
2. Create a separate PR to merge the same changes to `main` branch
3. Do not rely on normal release process to eventually get these changes to `main`

This ensures that automation works correctly regardless of which branch is targeted.

## Why Create Draft PRs Immediately?

Creating a draft PR as soon as you start working on an issue is critical for our automated workflow:

1. **Visibility**: It shows others that the issue is being worked on
2. **Automation**: It triggers our PR Status Tracker workflow to:
   - Label the issue as "in-progress"
   - Add a comment linking the issue to your PR
3. **Tracking**: It enables automatic status updates as your PR progresses
4. **Preventing Duplicated Work**: It prevents multiple people from working on the same issue

**Without a draft PR, the automation cannot track your progress, and the issue will remain in the "ready-for-development" state, potentially leading to duplicated work.**
