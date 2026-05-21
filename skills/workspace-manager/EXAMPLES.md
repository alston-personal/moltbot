# Workspace Manager - Quick Start Examples

## Example 1: Create a Basic Workspace

```bash
# Create a new workspace with default settings
skills/workspace-manager/scripts/create_workspace.sh my-project
```

**Output:**
```
ℹ Creating workspace: my-project
ℹ Location: /home/ubuntu/projects/my-project
✓ Created workspace directory
✓ Created .agent directory structure
✓ Created README.md
✓ Installed global skills (linked to /home/ubuntu/moltbot/skills)
✓ Created .gitignore

✓ Workspace created successfully!

Workspace path: /home/ubuntu/projects/my-project
```

## Example 2: Create Workspace with Custom Root

```bash
# Create workspace in a custom location
skills/workspace-manager/scripts/create_workspace.sh client-project --root /home/ubuntu/work
```

## Example 3: Install Skills to Existing Directory

```bash
# Add global skills to an existing project
skills/workspace-manager/scripts/install_global_skills.sh /home/ubuntu/legacy-project
```

## Example 4: List All Workspaces

```bash
# See all workspaces in default location
skills/workspace-manager/scripts/list_workspaces.sh
```

**Output:**
```
Workspaces in: /home/ubuntu/projects

  ● my-project
    Path: /home/ubuntu/projects/my-project
    Modified: 2026-01-30

  ○ old-project
    Path: /home/ubuntu/projects/old-project
    Modified: 2026-01-15

● = Managed workspace (has .agent directory)
○ = Unmanaged workspace

Total workspaces: 2
```

## Example 5: Use with AI Assistant

Simply tell the AI:

```
"Create a new workspace called data-pipeline"
```

The AI will automatically use the workspace-manager skill to:
1. Create the workspace directory
2. Set up the .agent structure
3. Install global skills
4. Generate initial files
5. Provide next steps

## Example 6: Full Workflow

```bash
# 1. Create new workspace
skills/workspace-manager/scripts/create_workspace.sh awesome-app

# 2. Navigate to workspace
cd /home/ubuntu/projects/awesome-app

# 3. Initialize git
git init

# 4. Create your first file
echo "console.log('Hello World');" > index.js

# 5. Open in VS Code (via Remote-SSH)
# Use "File > Open Folder" and select this directory
```

## Directory Structure After Creation

```
/home/ubuntu/projects/my-project/
├── .agent/
│   ├── global-skills -> /home/ubuntu/moltbot/skills  # Symlink
│   ├── skills/                                        # Your custom skills
│   └── workflows/                                     # Your custom workflows
├── .gitignore
└── README.md
```

## Tips

1. **Naming Convention**: Use lowercase with hyphens (e.g., `my-awesome-project`)
2. **Organization**: Group related projects in custom root directories
3. **Version Control**: Always initialize git after creating workspace
4. **Skills**: Global skills are automatically available in every workspace
