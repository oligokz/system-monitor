#!/bin/bash
########################################################################
# FILE NAME : test_users.sh
# PURPOSE   : Test user activity monitoring module
########################################################################

source "$(dirname "$0")/test_env.sh"
source "$LIB_DIR/users.sh"

OUTFILE="test_users"

{
echo "=== Running test_users.sh ==="
echo "Timestamp: $TEST_TS"
echo "Test: who + last + auth log parsing"
echo

printf 'M\n' | track_user_activity

echo
echo "=== END OF TEST ==="

} | capture_output "$OUTFILE"
