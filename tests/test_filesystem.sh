#!/bin/bash
########################################################################
# FILE NAME : test_filesystem.sh
# PURPOSE   : Test filesystem usage reporting module
########################################################################

source "$(dirname "$0")/test_env.sh"
source "$LIB_DIR/filesystem.sh"

OUTFILE="test_filesystem"

{
echo "=== Running test_filesystem.sh ==="
echo "Timestamp: $TEST_TS"
echo "Test: DU + DF + mounts + directory analysis"
echo
echo "NOTE: This test is interactive. Follow module prompts."
echo

generate_filesystem_report

echo
echo "=== END OF TEST ==="

} | capture_output "$OUTFILE"
