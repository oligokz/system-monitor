#!/bin/bash
########################################################################
# FILE NAME : test_resources.sh
# PURPOSE   : Test system resource monitoring module
########################################################################

source "$(dirname "$0")/test_env.sh"
source "$LIB_DIR/resources.sh"

OUTFILE="test_resources"

{
echo "=== Running test_resources.sh ==="
echo "Timestamp: $TEST_TS"
echo "Test: CPU/MEM/LOAD/DF reporting"
echo

printf 'M\n' | check_system_resources

echo
echo "=== END OF TEST ==="

} | capture_output "$OUTFILE"
