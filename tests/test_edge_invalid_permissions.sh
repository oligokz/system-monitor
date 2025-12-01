#!/bin/bash
########################################################################
# FILE NAME : test_edge_invalid_permissions.sh
# PURPOSE   : Test behaviour when lacking permissions
########################################################################

source "$(dirname "$0")/test_env.sh"
source "$LIB_DIR/filesystem.sh"
source "$LIB_DIR/backup.sh"

OUTFILE="edge_invalid_permissions"

# Create restricted folder
RESTRICTED="$BASE_DIR/tests/restricted_dir"
mkdir -p "$RESTRICTED"
chmod 000 "$RESTRICTED"

{
echo "=== PERMISSION DENIED EDGE-CASE TEST ==="
echo "Timestamp: $TEST_TS"
echo
echo "[INFO] Restricted directory created: $RESTRICTED"
echo

# Filesystem scan on restricted path
printf "$RESTRICTED\nM\n" | generate_filesystem_report

echo
# Backup on restricted path
printf "$RESTRICTED\nM\n" | create_incremental_backup

echo
echo "=== END OF TEST ==="
} | capture_output "$OUTFILE"

# Restore permissions after test
chmod 755 "$RESTRICTED"
