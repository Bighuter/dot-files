#!/usr/bin/env bash
set -euo pipefail

# Defaults
DAYS=100
DRY_RUN=false
VERBOSE=false
INCLUSIVE=false   # if true, delete items that are >= DAYS old
EXTRA_DIRS=()

TRASH_FILES="${HOME}/.local/share/Trash/files"
TRASH_INFO="${HOME}/.local/share/Trash/info"

usage() {
    cat <<EOF
Usage: $0 [-n] [-v] [-i] [-d days] [-h] [directory ...]

Clean system trash and optionally other directories of items older than a
given number of days (default: 100).

SYSTEM TRASH:
  Items are deleted based on DeletionDate in .trashinfo files.
  If the corresponding file/directory in Trash/files is missing,
  the orphaned .trashinfo file is also deleted if old enough.

ADDITIONAL DIRECTORIES:
  Cleaned using file modification time (-mtime). Use -v to list files.

Options:
  -n        Dry run – show what would be deleted without actually deleting.
  -v        Verbose – show parsed dates and age calculations.
  -i        Inclusive mode – delete items that are >= DAYS old.
  -d days   Age threshold (default: 100).
  -h        Show this help.

If no directory arguments given, defaults to cleaning trash and ~/Pictures/Screenshots.
EOF
}

# Parse options
while getopts "nvid:h" opt; do
    case "$opt" in
        n) DRY_RUN=true ;;
        v) VERBOSE=true ;;
        i) INCLUSIVE=true ;;
        d) DAYS="$OPTARG" ;;
        h) usage; exit 0 ;;
        *) usage; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

if ! [[ "$DAYS" =~ ^[0-9]+$ ]]; then
    echo "Error: days must be a non-negative integer." >&2
    exit 1
fi

# Extra directories
if [ $# -eq 0 ]; then
    EXTRA_DIRS=("${HOME}/Pictures/Screenshots")
else
    EXTRA_DIRS=("$@")
fi

# ----------------------------------------------------------------------
# Function: age_seconds
#   Convert a DeletionDate string to seconds since epoch.
#   Returns 0 and sets a global variable $age_epoch on success.
# ----------------------------------------------------------------------
age_seconds() {
    local del_str="$1"
    # Try GNU date first
    if epoch=$(date -d "$del_str" +%s 2>/dev/null); then
        age_epoch="$epoch"
        return 0
    fi
    # Try BSD date (macOS)
    if epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$del_str" +%s 2>/dev/null); then
        age_epoch="$epoch"
        return 0
    fi
    # If all fails, return 1
    return 1
}

# ----------------------------------------------------------------------
# Function: clean_trash
#   Deletes trash entries (and orphaned .trashinfo files) older than DAYS.
# ----------------------------------------------------------------------
clean_trash() {
    if [[ ! -d "$TRASH_INFO" ]]; then
        echo "Warning: Trash info directory '$TRASH_INFO' not found – skipping trash cleanup." >&2
        return
    fi
    if [[ ! -d "$TRASH_FILES" ]]; then
        echo "Warning: Trash files directory '$TRASH_FILES' not found – skipping trash cleanup." >&2
        return
    fi

    echo "=== Cleaning system trash (using DeletionDate from .trashinfo) ==="
    echo "Age threshold: $DAYS days ($([ "$INCLUSIVE" = true ] && echo "≥ $DAYS" || echo "> $DAYS"))"
    $DRY_RUN && echo "DRY RUN – no files will be deleted"
    $VERBOSE && echo "Verbose mode ON"

    # Get current time in seconds
    now_sec=$(date +%s)
    threshold_sec=$(( DAYS * 86400 ))

    # Process each .trashinfo file
    while IFS= read -r -d '' info_file; do
        # Extract DeletionDate line
        del_line=$(grep -m1 '^DeletionDate=' "$info_file" || true)
        if [[ -z "$del_line" ]]; then
            echo "Warning: No DeletionDate in $info_file – skipping" >&2
            continue
        fi

        # Remove "DeletionDate=" prefix, keep the rest
        del_str="${del_line#DeletionDate=}"

        # Try to get seconds since epoch
        if age_seconds "$del_str"; then
            age_sec=$(( now_sec - age_epoch ))
            # Determine if item is old enough
            if $INCLUSIVE; then
                old_enough=$(( age_sec >= threshold_sec ))
            else
                old_enough=$(( age_sec > threshold_sec ))
            fi
            if $VERBOSE; then
                echo "  $info_file : DeletionDate=$del_str, age=$(( age_sec / 86400 )) days"
            fi
            if [[ $old_enough -eq 1 ]]; then
                base_name=$(basename "$info_file" .trashinfo)
                target="$TRASH_FILES/$base_name"
                if [[ -e "$target" ]]; then
                    if $DRY_RUN; then
                        echo "Would delete: $target"
                        echo "Would delete: $info_file"
                    else
                        rm -rf "$target"
                        rm -f "$info_file"
                    fi
                else
                    # Orphaned info file – delete it as well
                    if $DRY_RUN; then
                        echo "Would delete orphaned info file: $info_file"
                    else
                        rm -f "$info_file"
                    fi
                fi
            fi
        else
            # Fallback to date‑only comparison (integer YYYYMMDD)
            del_date=$(echo "$del_str" | cut -dT -f1)
            if [[ ! "$del_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
                echo "Warning: Could not parse date from '$del_str' in $info_file – skipping" >&2
                continue
            fi
            del_int=$(echo "$del_date" | tr -d '-')
            today_int=$(date +%Y%m%d)
            threshold_int=$(( today_int - DAYS ))
            if $INCLUSIVE; then
                old_enough=$(( del_int <= threshold_int ))
            else
                old_enough=$(( del_int < threshold_int ))
            fi
            if $VERBOSE; then
                echo "  $info_file : date=$del_date, del_int=$del_int, threshold=$threshold_int, old_enough=$old_enough"
            fi
            if [[ $old_enough -eq 1 ]]; then
                base_name=$(basename "$info_file" .trashinfo)
                target="$TRASH_FILES/$base_name"
                if [[ -e "$target" ]]; then
                    if $DRY_RUN; then
                        echo "Would delete: $target"
                        echo "Would delete: $info_file"
                    else
                        rm -rf "$target"
                        rm -f "$info_file"
                    fi
                else
                    # Orphaned info file – delete it as well
                    if $DRY_RUN; then
                        echo "Would delete orphaned info file: $info_file"
                    else
                        rm -f "$info_file"
                    fi
                fi
            fi
        fi
    done < <(find "$TRASH_INFO" -maxdepth 1 -name '*.trashinfo' -print0)
}

# ----------------------------------------------------------------------
# Function: clean_directory (unchanged)
# ----------------------------------------------------------------------
clean_directory() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        echo "Warning: Directory '$dir' does not exist – skipping." >&2
        return
    fi

    echo "=== Cleaning directory: $dir (using file modification time) ==="
    echo "Age threshold: $DAYS days"
    $DRY_RUN && echo "DRY RUN – no files will be deleted"

    if $DRY_RUN; then
        find "$dir" -mindepth 1 -mtime +"$DAYS" -print
    else
        find "$dir" -mindepth 1 -mtime +"$DAYS" -delete 2>/dev/null || \
        find "$dir" -mindepth 1 -mtime +"$DAYS" -exec rm -rf {} +
    fi
}

# ----------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------
clean_trash
for d in "${EXTRA_DIRS[@]}"; do
    clean_directory "$d"
done
echo "Done."
