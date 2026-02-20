#!/bin/bash
# ensure-trash-hook.sh
# Ensures rm is replaced with trash-put system-wide via pacman hook

set -euo pipefail

HOOK_DIR="/etc/pacman.d/hooks"
HOOK_FILE="$HOOK_DIR/rm-to-trash.hook"
WRAPPER_SCRIPT="/usr/local/bin/rm-wrapper.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    log_error "This script must be run as root (use sudo)"
    exit 1
fi

# Ensure trash-put is installed
if ! command -v trash-put &> /dev/null; then
    log_error "trash-put not found. Install trash-cli first:"
    echo "  pacman -S trash-cli"
    exit 1
fi

log_info "trash-put found at: $(which trash-put)"

# Create hook directory if needed
if [[ ! -d "$HOOK_DIR" ]]; then
    log_info "Creating hook directory: $HOOK_DIR"
    mkdir -p "$HOOK_DIR"
fi

# Create the wrapper script that handles the actual logic
# This is easier than putting complex logic directly in the hook
log_info "Creating wrapper script: $WRAPPER_SCRIPT"

cat > "$WRAPPER_SCRIPT" << 'EOF'
#!/bin/bash
# rm-wrapper.sh - Handles rm -> trash-put replacement
# Called by pacman hook when rm binaries change

RM_PATH="/usr/bin/rm"
RMPERMA_PATH="/usr/bin/rmperma"
BIN_RM="/bin/rm"
BIN_RMPERMA="/bin/rmperma"
TRASH_PUT="/usr/bin/trash-put"

log() {
    echo "[rm-to-trash] $1" >&2
}

# Function to backup binary if it's not already a symlink
backup_if_real() {
    local src="$1"
    local dest="$2"
    
    if [[ -e "$src" ]]; then
        if [[ -L "$src" ]]; then
            log "$src is already a symlink ($(readlink -f "$src")), skipping backup"
            return 0
        fi
        
        # It's a real file, back it up
        if [[ -e "$dest" ]]; then
            log "Backup $dest already exists, overwriting with new version"
        fi
        
        log "Backing up real binary: $src -> $dest"
        mv -f "$src" "$dest"
        return 0
    else
        log "$src does not exist, skipping"
        return 1
    fi
}

# Function to ensure symlink exists
ensure_symlink() {
    local link_path="$1"
    local target="$2"
    
    # Remove if exists (whether file or wrong symlink)
    if [[ -e "$link_path" ]] || [[ -L "$link_path" ]]; then
        if [[ -L "$link_path" ]] && [[ "$(readlink -f "$link_path")" == "$(readlink -f "$target")" ]]; then
            log "$link_path already correctly linked to $target"
            return 0
        fi
        log "Removing existing $link_path"
        rm -f "$link_path"
    fi
    
    log "Creating symlink: $link_path -> $target"
    ln -s "$target" "$link_path"
}

log "=== Running rm-to-trash hook ==="

# Ensure trash-put exists
if [[ ! -x "$TRASH_PUT" ]]; then
    log "ERROR: trash-put not found at $TRASH_PUT"
    exit 1
fi

# Backup real rm binaries if they exist (only if not symlinks)
backup_if_real "$RM_PATH" "$RMPERMA_PATH"
backup_if_real "$BIN_RM" "$BIN_RMPERMA"

# Create symlinks to trash-put
ensure_symlink "$RM_PATH" "$TRASH_PUT"
ensure_symlink "$BIN_RM" "$TRASH_PUT"

log "=== rm-to-trash hook complete ==="
EOF

chmod +x "$WRAPPER_SCRIPT"
log_info "Wrapper script created and made executable"

# Create the pacman hook
log_info "Creating pacman hook: $HOOK_FILE"

cat > "$HOOK_FILE" << EOF
[Trigger]
Type = File
Operation = Install
Operation = Upgrade
Operation = Remove
Target = usr/bin/rm
Target = bin/rm

[Action]
Description = Replace rm with trash-put... rm will be available as rmperam...
When = PostTransaction
Exec = /usr/bin/bash -c '/usr/local/bin/rm-wrapper.sh'
EOF

log_info "Pacman hook created"

# Run the wrapper immediately to set up current state
log_info "Running wrapper script now to handle current state..."
if "$WRAPPER_SCRIPT"; then
    log_info "Initial setup complete!"
else
    log_error "Initial setup failed!"
    exit 1
fi

# Verify the setup
log_info "Verifying setup..."
echo ""
echo "=== Current rm status ==="
for path in /usr/bin/rm /bin/rm /usr/bin/rmperma /bin/rmperma; do
    if [[ -e "$path" ]]; then
        if [[ -L "$path" ]]; then
            echo "  $path -> $(readlink -f "$path")"
        else
            echo "  $path (real binary file)"
        fi
    else
        echo "  $path (does not exist)"
    fi
done

echo ""
echo "=== trash-put status ==="
if command -v trash-put &> /dev/null; then
    echo "  trash-put: $(which trash-put)"
else
    echo "  trash-put: NOT FOUND"
fi

echo ""
log_info "Setup complete!"
echo ""
echo "To use the real rm permanently, use: rmperma"
echo "To temporarily use real rm once, use: /usr/bin/rmperma or \$(which rmperma)"
echo ""
log_warn "NOTE: This affects ALL users and scripts system-wide!"
log_warn "To uninstall, run: rm -f $HOOK_FILE $WRAPPER_SCRIPT && mv /usr/bin/rmperma /usr/bin/rm && mv /bin/rmperma /bin/rm "
