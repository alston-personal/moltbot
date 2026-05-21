---
name: workspace-manager
description: Manage workspaces by creating new project directories and installing global skills. Use when the user wants to create a new workspace, set up a new project directory, or install global skills into a workspace.
---

# Workspace Manager

This skill helps create and configure new workspaces with proper directory structure and global skills installation.

## Configuration

The default projects root directory is `/home/ubuntu/projects`. To customize, set the `PROJECTS_ROOT` environment variable.

## Creating a New Workspace

To create a new workspace with global skills installed:

```bash
skills/workspace-manager/scripts/create_workspace.sh [workspace-name] [--root /custom/path]
```

### Examples

```bash
# Create workspace with default root (/home/ubuntu/projects)
skills/workspace-manager/scripts/create_workspace.sh my-new-project

# Create workspace with custom root
skills/workspace-manager/scripts/create_workspace.sh my-app --root /home/ubuntu/custom-projects
```

### What This Does

1. **Creates directory structure**: Creates the workspace directory at the specified location
2. **Initializes .agent directory**: Sets up `.agent/` folder for workspace-specific configuration
3. **Installs global skills**: Copies all global skills from the current workspace to the new workspace
4. **Creates README**: Generates a basic README.md file with workspace information
5. **Outputs path**: Returns the absolute path to the new workspace for easy navigation

## Installing Skills to Existing Workspace

To install global skills into an existing workspace:

```bash
skills/workspace-manager/scripts/install_global_skills.sh [workspace-path]
```

### Example

```bash
skills/workspace-manager/scripts/install_global_skills.sh /home/ubuntu/my-existing-project
```

## Listing Workspaces

To list all workspaces in the projects directory:

```bash
skills/workspace-manager/scripts/list_workspaces.sh [--root /custom/path]
```

## Global Skills

Global skills are skills that should be available in every workspace. By default, this includes skills from the main moltbot installation at `/home/ubuntu/moltbot/skills`.

The installation process creates symbolic links to preserve disk space while keeping skills synchronized with the source.

## Opening Workspace in VS Code

After creating a workspace, guide the user to open it in VS Code Remote-SSH:

1. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
2. Type "File: Open Folder"
3. Navigate to the workspace path provided by the script
4. Select the folder to open

## Best Practices

- **Use descriptive names**: Name workspaces after their purpose (e.g., `web-scraper`, `data-analysis`)
- **Organize by type**: Consider creating subdirectories for different project types
- **Regular cleanup**: Periodically review and archive unused workspaces
