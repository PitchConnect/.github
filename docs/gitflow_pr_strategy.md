# GitFlow PR Strategy for Organization-Wide Workflows

This document outlines the recommended strategy for implementing organization-wide workflows in repositories that use GitFlow.

## Background

When implementing organization-wide workflows in repositories that use GitFlow, we need to ensure that the workflows are available on both the `main` and `develop` branches. Initially, we created separate PRs for each branch, but this approach has some drawbacks:

1. **Duplication of Effort**: Creating separate PRs for each branch requires duplicating the same changes.
2. **Potential Inconsistencies**: If the PRs are not identical, there could be inconsistencies between branches.
3. **Extra Maintenance**: Managing multiple PRs increases the maintenance burden.

## Recommended Approach

Based on our experience implementing workflows in the fogis-api-client-python repository, we recommend the following approach:

1. **Create a PR for the `main` Branch First**:
   ```bash
   # Clone the repository
   git clone https://github.com/PitchConnect/<repository-name>.git
   cd <repository-name>
   
   # Create a branch from main
   git checkout main
   git checkout -b feature/add-org-workflows
   
   # Add the workflow files
   mkdir -p .github/workflows
   # Create workflow files...
   
   # Commit and push
   git add .github/workflows/
   git commit -m "Add organization-wide workflows"
   git push -u origin feature/add-org-workflows
   
   # Create PR
   gh pr create --title "Add organization-wide workflows" --body-file <pr-body-file> --base main
   ```

2. **Merge the PR to the `main` Branch**:
   - Review and merge the PR to the `main` branch.
   - This ensures that the workflows are available on the `main` branch.

3. **Pull the Changes into the `develop` Branch**:
   ```bash
   # Checkout develop branch
   git checkout develop
   
   # Pull changes from main
   git pull origin main
   
   # Resolve any conflicts
   # ...
   
   # Push changes to develop
   git push origin develop
   ```

4. **Run the Label Creator Workflow**:
   - Go to the "Actions" tab in the repository
   - Select the "Label Creator" workflow
   - Click "Run workflow"
   - Click "Run workflow" again to confirm

## Benefits

This approach has several benefits:

1. **Reduced Duplication**: Changes are made once and then pulled into the other branch.
2. **Consistency**: Ensures that both branches have the same workflows.
3. **Follows GitFlow Pattern**: Aligns with the normal GitFlow pattern where changes eventually flow from `main` to `develop`.
4. **Simplified Maintenance**: Only one PR needs to be reviewed and managed.

## Special Cases

In some cases, you may need to make branch-specific adjustments:

1. **Branch-Specific Configurations**:
   - If the workflows need different configurations on different branches, make these adjustments after pulling the changes.
   - Create a separate PR for these branch-specific adjustments.

2. **Conflicts**:
   - If there are conflicts when pulling changes from `main` to `develop`, resolve them carefully.
   - Consider creating a separate PR for conflict resolution if the conflicts are complex.

## Conclusion

By following this approach, we can efficiently implement organization-wide workflows in repositories that use GitFlow, ensuring consistency and reducing maintenance overhead.
