#!/bin/bash
########################################################################
# FILE NAME : test_backup.sh
# PURPOSE   : Test incremental backup & verification modules
########################################################################

source "$(dirname "$0")/test_env.sh"
source "$LIB_DIR/backup.sh"

OUTFILE="test_backup"

{
echo "=== Running test_backup.sh ==="
echo "Timestamp: $TEST_TS"
echo "Test: rsync incremental logic + deleted-file trash + integrity check"
echo
echo "TEST 1: Perform incremental backup"
echo "      ? Follow the prompts"
echo

create_incremental_backup

echo
echo "TEST 2: Modify/delete a file in your source directory"
echo "      ? Then run backup verification next"
echo

verify_backup_integrity

echo
echo "=== END OF TEST ==="

} | capture_output "$OUTFILE"
