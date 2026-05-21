#!/bin/bash
set -euo pipefail

# Workspace Creation Script
# Creates a new workspace directory with global skills installed

# Default configuration
DEFAULT_PROJECTS_ROOT="${PROJECTS_ROOT:-/home/ubuntu/projects}"
MOLTBOT_ROOT="/home/ubuntu/moltbot"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${YELLOW}ℹ${NC} $1"; }

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 WORKSPACE_NAME [OPTIONS]

Create a new workspace with global skills installed.

Arguments:
    WORKSPACE_NAME          Name of the workspace to create

Options:
    --root PATH            Root directory for projects (default: ${DEFAULT_PROJECTS_ROOT})
    -h, --help             Show this help message

Examples:
    $0 my-new-project
    $0 my-app --root /home/ubuntu/custom-projects

EOF
}

# Parse arguments
WORKSPACE_NAME=""
PROJECTS_ROOT="${DEFAULT_PROJECTS_ROOT}"

while [[ $# -gt 0 ]]; do
    case $1 in
        --root)
            PROJECTS_ROOT="$2"
            shift 2
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        -*)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
        *)
            if [[ -z "$WORKSPACE_NAME" ]]; then
                WORKSPACE_NAME="$1"
            else
                print_error "Multiple workspace names provided: '$WORKSPACE_NAME' and '$1'"
                show_usage
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate workspace name
if [[ -z "$WORKSPACE_NAME" ]]; then
    print_error "Workspace name is required"
    show_usage
    exit 1
fi

# Validate workspace name format (alphanumeric, hyphens, underscores)
if ! [[ "$WORKSPACE_NAME" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    print_error "Workspace name must contain only letters, numbers, hyphens, and underscores"
    exit 1
fi

# Create workspace path
WORKSPACE_PATH="${PROJECTS_ROOT}/${WORKSPACE_NAME}"

# Check if workspace already exists
if [[ -d "$WORKSPACE_PATH" ]]; then
    print_error "Workspace already exists at: $WORKSPACE_PATH"
    exit 1
fi

# Create projects root if it doesn't exist
if [[ ! -d "$PROJECTS_ROOT" ]]; then
    print_info "Creating projects root directory: $PROJECTS_ROOT"
    mkdir -p "$PROJECTS_ROOT"
fi

print_info "Creating workspace: $WORKSPACE_NAME"
print_info "Location: $WORKSPACE_PATH"

# Create workspace directory
mkdir -p "$WORKSPACE_PATH"
print_success "Created workspace directory"

# Create .agent directory structure
print_info "Setting up .agent directory..."
mkdir -p "$WORKSPACE_PATH/.agent/workflows"
mkdir -p "$WORKSPACE_PATH/.agent/skills"
print_success "Created .agent directory structure"

# Create basic README
cat > "$WORKSPACE_PATH/README.md" << EOF
# ${WORKSPACE_NAME}

Created: $(date '+%Y-%m-%d %H:%M:%S')

## About

This is a new workspace created with workspace-manager skill.

## Getting Started

Add your project description and setup instructions here.

EOF
print_success "Created README.md"

# Install global skills
print_info "Installing global skills..."
if [[ -d "$MOLTBOT_ROOT/skills" ]]; then
    # Create symbolic link to moltbot skills
    ln -sf "$MOLTBOT_ROOT/skills" "$WORKSPACE_PATH/.agent/global-skills"
    print_success "Installed global skills (linked to $MOLTBOT_ROOT/skills)"
else
    print_error "Warning: Moltbot skills directory not found at $MOLTBOT_ROOT/skills"
    print_info "Skipping global skills installation"
fi

# Create .gitignore
cat > "$WORKSPACE_PATH/.gitignore" << 'EOF'
# Dependencies
node_modules/
venv/
__pycache__/
*.pyc

# Environment
.env
.env.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Build outputs
dist/
build/
*.log

EOF
print_success "Created .gitignore"

# Summary
echo ""
print_success "Workspace created successfully!"
echo ""
echo "Workspace path: $WORKSPACE_PATH"
echo ""
print_info "Next steps:"
echo "  1. Open the workspace in your IDE"
echo "  2. Initialize version control: cd $WORKSPACE_PATH && git init"
echo "  3. Start building your project!"
echo ""

# Output the path for programmatic use
echo "$WORKSPACE_PATH"
