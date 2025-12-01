#!/bin/bash
########################################################################
# FILE NAME : test_edge_empty_directory.sh
# PURPOSE   : Test behaviour for empty source directories
########################################################################

source "$(dirname "$0")/test_env.sh"
source "$LIB_DIR/backup.sh"
source "$LIB_DIR/filesystem.sh"

OUTFILE="edge_empty_directory"

TMP_EMPTY="$BASE_DIR/tests/tmp_empty_dir"
mkdir -p "$TMP_EMPTY"

{
echo "=== Running EMPTY DIRECTORY EDGE-CASE TEST ==="
echo "Timestamp: $TEST_TS"
echo
echo "[INFO] Using temporary empty directory: $TMP_EMPTY"
echo

# Backup test
printf "$TMP_EMPTY\nM\n" | create_incremental_backup

echo
# Filesystem test
printf "$TMP_EMPTY\nM\n" | generate_filesystem_report

echo
echo "=== END OF TEST ==="
} | capture_output "$OUTFILE"
