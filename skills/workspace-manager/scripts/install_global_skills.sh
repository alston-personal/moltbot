#!/bin/bash
set -euo pipefail

# Install Global Skills Script
# Installs global skills into an existing workspace

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
Usage: $0 WORKSPACE_PATH

Install global skills into an existing workspace.

Arguments:
    WORKSPACE_PATH          Path to the workspace directory

Examples:
    $0 /home/ubuntu/projects/my-project
    $0 ~/projects/my-app

EOF
}

# Parse arguments
WORKSPACE_PATH=""

if [[ $# -eq 0 ]]; then
    print_error "Workspace path is required"
    show_usage
    exit 1
fi

while [[ $# -gt 0 ]]; do
    case $1 in
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
            WORKSPACE_PATH="$1"
            shift
            ;;
    esac
done

# Expand tilde and make absolute path
WORKSPACE_PATH="${WORKSPACE_PATH/#\~/$HOME}"
WORKSPACE_PATH="$(cd "$WORKSPACE_PATH" 2>/dev/null && pwd || echo "$WORKSPACE_PATH")"

# Validate workspace exists
if [[ ! -d "$WORKSPACE_PATH" ]]; then
    print_error "Workspace does not exist: $WORKSPACE_PATH"
    exit 1
fi

print_info "Installing global skills to: $WORKSPACE_PATH"

# Create .agent directory if it doesn't exist
mkdir -p "$WORKSPACE_PATH/.agent"
print_success "Ensured .agent directory exists"

# Check if moltbot skills exist
if [[ ! -d "$MOLTBOT_ROOT/skills" ]]; then
    print_error "Moltbot skills directory not found at: $MOLTBOT_ROOT/skills"
    exit 1
fi

# Create or update symbolic link to global skills
if [[ -L "$WORKSPACE_PATH/.agent/global-skills" ]]; then
    print_info "Updating existing global-skills link..."
    rm "$WORKSPACE_PATH/.agent/global-skills"
elif [[ -d "$WORKSPACE_PATH/.agent/global-skills" ]]; then
    print_info "Removing existing global-skills directory..."
    rm -rf "$WORKSPACE_PATH/.agent/global-skills"
fi

ln -sf "$MOLTBOT_ROOT/skills" "$WORKSPACE_PATH/.agent/global-skills"
print_success "Installed global skills (linked to $MOLTBOT_ROOT/skills)"

# Count skills
SKILLS_COUNT=$(find "$MOLTBOT_ROOT/skills" -maxdepth 1 -type d ! -name 'skills' | wc -l)

echo ""
print_success "Global skills installation complete!"
echo ""
echo "Workspace: $WORKSPACE_PATH"
echo "Skills installed: $SKILLS_COUNT"
echo ""
