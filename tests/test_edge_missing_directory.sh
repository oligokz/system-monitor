#!/bin/bash
########################################################################
# FILE NAME : test_edge_missing_directory.sh
# PURPOSE   : Test behaviour when directories do not exist
########################################################################

source "$(dirname "$0")/test_env.sh"
source "$LIB_DIR/resources.sh"
source "$LIB_DIR/filesystem.sh"
source "$LIB_DIR/backup.sh"

OUTFILE="edge_missing_directory"

{
echo "=== Running MISSING DIRECTORY EDGE-CASE TEST ==="
echo "Timestamp: $TEST_TS"
echo

# 1) Filesystem module
echo "[TEST] Filesystem with missing directory"
printf "/this/path/does/not/exist\nM\n" | generate_filesystem_report

echo
# 2) Backup module
echo "[TEST] Backup with missing source"
printf "/this/path/does/not/exist\nM\n" | create_incremental_backup

echo
# 3) Backup verification
echo "[TEST] Verify backup with missing source"
printf "/this/path/does/not/exist\nM\n" | verify_backup_integrity

echo
echo "=== END OF TEST ==="
} | capture_output "$OUTFILE"
