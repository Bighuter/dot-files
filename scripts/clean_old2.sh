#!/usr/bin/env bash

set -euo pipefail

DAYS=100
DRY_RUN=false
DIRS=()

usage() {
    cat <<EOF
Usage: $0 [-n] [-d days] [-h] [directory ...]

Remove files (and empty directories) from the given directories that are
older than a specified number of days (default: 100).

If no directory is given, the script cleans the system trash and the
screenshots folder:
  ${HOME}/.local/share/Trash/files
  ${HOME}/Pictures/Screenshots

Options:
  -n        Dry run – show what would be deleted without actually deleting.
  -d days   Set age threshold (files modified more than 'days' days ago).
  -h        Show this help message.

Directories can be listed after the options. The script will process each
directory recursively, respecting the age threshold.
EOF
}

# Parse options
while getopts "nd:h" opt; do
    case "$opt" in
        n) DRY_RUN=true ;;
        d) DAYS="$OPTARG" ;;
        h) usage; exit 0 ;;
        *) usage; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

# Collect directories from remaining arguments
if [ $# -eq 0 ]; then
    # Default: clean both trash and screenshots
    DIRS=(
        "${HOME}/.local/share/Trash/files"
        "${HOME}/Pictures/Screenshots"
    )
else
    DIRS=("$@")
fi

# Validate days argument
if ! [[ "$DAYS" =~ ^[0-9]+$ ]]; then
    echo "Error: days must be a non-negative integer." >&2
    exit 1
fi

# Process each directory
for target_dir in "${DIRS[@]}"; do
    if [ ! -d "$target_dir" ]; then
        echo "Warning: Directory '$target_dir' does not exist – skipping." >&2
        continue
    fi

    echo "Processing: $target_dir"
    echo "Age threshold: $DAYS days"
    $DRY_RUN && echo "DRY RUN – no files will be deleted"

    # Build find command: files and directories, at depth >=1, older than DAYS
    if $DRY_RUN; then
        # -delete implies -depth, so directories are emptied before removal
        find "$target_dir" -mindepth 1 -mtime +"$DAYS" -print
    else
        # Note: -delete is a GNU find extension. For BSD/macOS, use:
        # find "$target_dir" -mindepth 1 -mtime +"$DAYS" -exec rm -rf {} +
        find "$target_dir" -mindepth 1 -mtime +"$DAYS" -delete
    fi
done
