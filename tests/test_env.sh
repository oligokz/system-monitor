#!/bin/bash
########################################################################
# FILE NAME : test_env.sh
# PURPOSE   : Bootstrap environment for all System Monitor test scripts
# PROJECT   : System Monitor
# AUTHOR    : Bernard Lim (8001381B)
########################################################################

# -----------------------------------------------------------
# Resolve BASE_DIR ? one level above tests/
# -----------------------------------------------------------
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

LIB_DIR="$BASE_DIR/lib"
CONFIG_DIR="$BASE_DIR/config"

# -----------------------------------------------------------
# Load configuration (settings.conf)
# -----------------------------------------------------------
if [[ -f "$CONFIG_DIR/settings.conf" ]]; then
  # shellcheck disable=SC1090
  source "$CONFIG_DIR/settings.conf"
else
  echo "ERROR: settings.conf not found in $CONFIG_DIR"
  exit 1
fi

# Ensure LOG_FILE absolute
if [[ "$LOG_FILE" != /* ]]; then
  LOG_FILE="$BASE_DIR/$LOG_FILE"
fi

# Ensure BACKUP_DEST absolute
if [[ "$BACKUP_DEST" != /* ]]; then
  BACKUP_DEST="$BASE_DIR/$BACKUP_DEST"
fi

export BASE_DIR LIB_DIR CONFIG_DIR LOG_FILE BACKUP_DEST

# -----------------------------------------------------------
# Load UI + Logging modules
# -----------------------------------------------------------
# shellcheck disable=SC1090
source "$LIB_DIR/ui.sh"
# shellcheck disable=SC1090
source "$LIB_DIR/logging.sh"

# Initialize logging
log_init
log_info "===== Starting test: $(basename "$0") ====="

# -----------------------------------------------------------
# Output Capture Helper
# -----------------------------------------------------------
TEST_RESULTS_DIR="$BASE_DIR/tests/results"
mkdir -p "$TEST_RESULTS_DIR"

TEST_TS="$(date '+%Y-%m-%d_%H-%M-%S')"

capture_output() {
    local file="$1"
    tee "$TEST_RESULTS_DIR/${TEST_TS}_${file}.txt"
}
