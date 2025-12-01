#!/bin/bash
########################################################################
# FILE NAME : test_edge_mismatch_file.sh
# PURPOSE   : Backup mismatch detection test
########################################################################

source "$(dirname "$0")/test_env.sh"
source "$LIB_DIR/backup.sh"

OUTFILE="edge_mismatch_file"

SRC_DIR="$BASE_DIR/tests/mismatch_src"
BACKUP_DIR="$BACKUP_DEST/data"

mkdir -p "$SRC_DIR"

echo "version1" > "$SRC_DIR/sample.txt"

{
echo "=== FILE MISMATCH EDGE-CASE TEST ==="
echo "Timestamp: $TEST_TS"
echo
echo "[STEP] Creating initial backup"
printf "$SRC_DIR\n$BACKUP_DIR\nM\n" | create_incremental_backup

echo
echo "[STEP] Modifying source file (to force mismatch)"
echo "version2" > "$SRC_DIR/sample.txt"

echo
echo "[STEP] Running verification"
printf "$SRC_DIR\n$BACKUP_DIR\nM\n" | verify_backup_integrity

echo
echo "=== END OF TEST ==="
} | capture_output "$OUTFILE"
