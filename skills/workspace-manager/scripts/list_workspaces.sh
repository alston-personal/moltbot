#!/bin/bash
set -euo pipefail

# List Workspaces Script
# Lists all workspaces in the projects directory

DEFAULT_PROJECTS_ROOT="${PROJECTS_ROOT:-/home/ubuntu/projects}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${YELLOW}ℹ${NC} $1"; }

# Function to show usage
show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

List all workspaces in the projects directory.

Options:
    --root PATH            Root directory for projects (default: ${DEFAULT_PROJECTS_ROOT})
    -h, --help             Show this help message

Examples:
    $0
    $0 --root /home/ubuntu/custom-projects

EOF
}

# Parse arguments
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
            print_error "Unexpected argument: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Check if projects root exists
if [[ ! -d "$PROJECTS_ROOT" ]]; then
    print_error "Projects directory does not exist: $PROJECTS_ROOT"
    print_info "Create it with: mkdir -p $PROJECTS_ROOT"
    exit 1
fi

# List workspaces
echo -e "${BLUE}Workspaces in: $PROJECTS_ROOT${NC}"
echo ""

WORKSPACE_COUNT=0
while IFS= read -r -d '' workspace; do
    WORKSPACE_COUNT=$((WORKSPACE_COUNT + 1))
    WORKSPACE_NAME=$(basename "$workspace")
    
    # Check if it has .agent directory (indicates it's a managed workspace)
    if [[ -d "$workspace/.agent" ]]; then
        MARKER="${GREEN}●${NC}"
    else
        MARKER="${YELLOW}○${NC}"
    fi
    
    # Get modification time
    MOD_TIME=$(stat -c '%y' "$workspace" 2>/dev/null | cut -d' ' -f1 || echo "unknown")
    
    echo -e "  $MARKER $WORKSPACE_NAME"
    echo -e "    Path: $workspace"
    echo -e "    Modified: $MOD_TIME"
    echo ""
done < <(find "$PROJECTS_ROOT" -maxdepth 1 -type d ! -name "$(basename "$PROJECTS_ROOT")" -print0 | sort -z)

if [[ $WORKSPACE_COUNT -eq 0 ]]; then
    print_info "No workspaces found in $PROJECTS_ROOT"
    echo ""
    print_info "Create a new workspace with:"
    echo "  skills/workspace-manager/scripts/create_workspace.sh my-project"
else
    echo -e "${GREEN}●${NC} = Managed workspace (has .agent directory)"
    echo -e "${YELLOW}○${NC} = Unmanaged workspace"
    echo ""
    echo "Total workspaces: $WORKSPACE_COUNT"
fi

echo ""
