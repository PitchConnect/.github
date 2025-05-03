# PitchConnect Organization-Wide Workflows

This repository contains reusable GitHub Actions workflows that can be used across all repositories in the PitchConnect organization.

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

## Important: GitFlow Considerations

For repositories using GitFlow with both `main` and `develop` as long-living branches:

**⚠️ CRITICAL: Workflows must be implemented on BOTH branches ⚠️**

1. First implement on `develop` branch
2. Create a separate PR to merge the same changes to `main` branch
3. Do not rely on normal release process to eventually get these changes to `main`

This ensures that automation works correctly regardless of which branch is targeted.
