# PitchConnect Organization-Wide GitHub Actions

This repository contains organization-wide GitHub Actions workflows and templates for standardizing processes across all PitchConnect repositories.

## Available Workflows

### Reusable Workflows

These workflows can be called from other workflows:

| Workflow | Description | Usage |
|----------|-------------|-------|
| [issue-labeler.yml](.github/workflows/issue-labeler.yml) | Adds labels to new issues | `uses: PitchConnect/.github/.github/workflows/issue-labeler.yml@main` |
| [contributing-reminder.yml](.github/workflows/contributing-reminder.yml) | Reminds about contribution guidelines | `uses: PitchConnect/.github/.github/workflows/contributing-reminder.yml@main` |
| [pr-status-tracker.yml](.github/workflows/pr-status-tracker.yml) | Tracks PR status and updates issues | `uses: PitchConnect/.github/.github/workflows/pr-status-tracker.yml@main` |
| [label-creator.yml](.github/workflows/label-creator.yml) | Creates standard labels | `uses: PitchConnect/.github/.github/workflows/label-creator.yml@main` |
| [ci-failure-reminder.yml](.github/workflows/ci-failure-reminder.yml) | Reminds about pre-commit hooks on CI failure | `uses: PitchConnect/.github/.github/workflows/ci-failure-reminder.yml@main` |
| [contributing-sync.yml](.github/workflows/contributing-sync.yml) | Syncs CONTRIBUTING.md across repositories | `uses: PitchConnect/.github/.github/workflows/contributing-sync.yml@main` |
| [release-pr-generator.yml](.github/workflows/release-pr-generator.yml) | Generates release PRs | `uses: PitchConnect/.github/.github/workflows/release-pr-generator.yml@main` |
| [standard-setup.yml](.github/workflows/standard-setup.yml) | Standard repository setup | `uses: PitchConnect/.github/.github/workflows/standard-setup.yml@main` |

### Workflow Templates

These templates can be used to create new workflows in repositories:

| Template | Description |
|----------|-------------|
| [standard-setup.yml](.github/workflow-templates/standard-setup.yml) | Standard repository setup |
| [release-management.yml](.github/workflow-templates/release-management.yml) | Release management |

## How to Use

### Option 1: Use Workflow Templates

1. Go to the "Actions" tab in your repository
2. Click "New workflow"
3. Scroll down to "Workflows created by PitchConnect"
4. Select the workflow template you want to use
5. Commit the workflow file

### Option 2: Use Reusable Workflows Directly

Create a workflow file in your repository that calls the reusable workflows:

```yaml
name: Standard Repository Setup

on:
  issues:
    types: [opened]
  pull_request:
    types: [opened, converted_to_draft, ready_for_review, closed]

jobs:
  standard-setup:
    uses: PitchConnect/.github/.github/workflows/standard-setup.yml@main
```

## Labels

The following labels are created by the `label-creator.yml` workflow:

| Label | Color | Description |
|-------|-------|-------------|
| `triage` | Yellow (#fbca04) | Needs triage by maintainers |
| `in-progress` | Blue (#0052cc) | Issue is being worked on in a draft PR |
| `review-ready` | Purple (#5319e7) | Work is complete and ready for review |
| `merged-to-develop` | Green (#0e8a16) | Implementation has been merged to develop |
| `released` | Blue (#1d76db) | Feature has been released to production |

## Issue Lifecycle

1. **New Issue**: Labeled as `triage`
2. **Draft PR**: Referenced issues labeled as `in-progress`
3. **Ready for Review**: Issues labeled as `review-ready`
4. **Merged to Develop**: Issues labeled as `merged-to-develop`
5. **Released**: Issues labeled as `released` and closed

## Contributing

To contribute to these workflows:

1. Create a feature branch
2. Make your changes
3. Test your changes in a test repository
4. Create a PR to the `main` branch

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
