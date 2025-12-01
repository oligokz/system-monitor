#!/bin/bash
########################################################################
# FILE NAME : test_edge_corrupted_backup.sh
# PURPOSE   : Corrupted backup detection test
########################################################################

source "$(dirname "$0")/test_env.sh"
source "$LIB_DIR/backup.sh"

OUTFILE="edge_corrupted_backup"

SRC_DIR="$BASE_DIR/tests/corrupt_src"
BACKUP_DIR="$BACKUP_DEST/data"

mkdir -p "$SRC_DIR"

# Create source file
echo "original content" > "$SRC_DIR/testfile.txt"

{
echo "=== CORRUPTED BACKUP EDGE-CASE TEST ==="
echo "Timestamp: $TEST_TS"
echo
echo "[STEP] Creating initial correct backup"
printf "$SRC_DIR\n$BACKUP_DIR\nM\n" | create_incremental_backup

echo
echo "[STEP] Corrupting backup manually"
LATEST=$(find "$BACKUP_DIR" -maxdepth 1 -type d -name "corrupt_src_*" | sort | tail -n 1)
echo "CORRUPTED DATA" > "$LATEST/testfile.txt"

echo
echo "[STEP] Running verification"
printf "$SRC_DIR\n$BACKUP_DIR\nM\n" | verify_backup_integrity

echo
echo "=== END OF TEST ==="
} | capture_output "$OUTFILE"
