#!/bin/bash
########################################################################
# FILE NAME : test_process.sh
# PURPOSE   : Test process monitoring & analysis module
########################################################################

source "$(dirname "$0")/test_env.sh"
source "$LIB_DIR/process.sh"

OUTFILE="test_process"

{
echo "=== Running test_process.sh ==="
echo "Timestamp: $TEST_TS"
echo "Test: ps aux sorting + pgrep + PID inspection"
echo

printf 'M\n' | analyze_running_processes

echo
echo "=== END OF TEST ==="

} | capture_output "$OUTFILE"
