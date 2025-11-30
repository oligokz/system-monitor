#!/bin/bash
########################################################################
# System Monitor - Linux System Monitoring & Backup Utility (Modular)
# Course : CIML019 - Software Defined Infrastructure & Services
# Author : BERNARD LIM KOK SONG - 8001381B
# Version: 1.0
#
# Main controller script:
#   - Loads config and shared variables
#   - Loads all function modules from ./lib
#   - Displays interactive menu
#   - Routes user choices to functions
########################################################################

# -----------------------------
# Project Paths
# -----------------------------
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$BASE_DIR/lib"
CONFIG_DIR="$BASE_DIR/config"
LOG_DIR="$BASE_DIR/logs"
BACKUP_DEST_BASE="$BASE_DIR/backups"
REPORTS_DIR="$BASE_DIR/reports"
TESTS_DIR="$BASE_DIR/tests"

mkdir -p "$LIB_DIR" "$CONFIG_DIR" "$LOG_DIR" "$BACKUP_DEST_BASE" "$REPORTS_DIR" "$TESTS_DIR"

# -----------------------------
# Default Config Values
# -----------------------------
DEFAULT_BACKUP_SOURCE="/home/$USER/documents"
DEFAULT_BACKUP_DEST="$BACKUP_DEST_BASE"
DEFAULT_FS_PATH="/"

BACKUP_SOURCE="$DEFAULT_BACKUP_SOURCE"
BACKUP_DEST="$DEFAULT_BACKUP_DEST"
FS_DEFAULT_PATH="$DEFAULT_FS_PATH"
LOG_FILE="$LOG_DIR/system_monitor.log"
LOG_LEVEL="INFO"
VERBOSE="false"

# Load settings.conf if present (overrides defaults above)
if [[ -f "$CONFIG_DIR/settings.conf" ]]; then
  # shellcheck source=/dev/null
  source "$CONFIG_DIR/settings.conf"
fi

# Normalise relative paths in config (make them project-relative)
[[ "$BACKUP_DEST" != /* ]] && BACKUP_DEST="$BASE_DIR/$BACKUP_DEST"
[[ "$LOG_FILE"    != /* ]] && LOG_FILE="$BASE_DIR/$LOG_FILE"
[[ -z "$FS_DEFAULT_PATH" ]] && FS_DEFAULT_PATH="/"

LAST_BACKUP_REF_FILE="$BACKUP_DEST/.last_backup"

# -----------------------------
# Load Modules
# -----------------------------
# logging first so others can use it
# shellcheck source=/dev/null
source "$LIB_DIR/logging.sh"
log_init

# shellcheck source=/dev/null
source "$LIB_DIR/ui.sh"
# shellcheck source=/dev/null
source "$LIB_DIR/resources.sh"
# shellcheck source=/dev/null
source "$LIB_DIR/users.sh"
# shellcheck source=/dev/null
source "$LIB_DIR/backup.sh"
# shellcheck source=/dev/null
source "$LIB_DIR/filesystem.sh"
# shellcheck source=/dev/null
source "$LIB_DIR/process.sh"

# -----------------------------
# Dependency Check
# -----------------------------
check_dependencies() {
  local missing=()
  local deps=(uptime free df who last find rsync du ps awk date)

  for cmd in "${deps[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      missing+=("$cmd")
    fi
  done

  if ((${#missing[@]})); then
    err "Missing required commands: ${missing[*]}"
    echo "Please install them and re-run this script."
    log_error "Missing dependencies: ${missing[*]}"
    exit 1
  fi
}

# -----------------------------
# Menu / Help
# -----------------------------
display_menu() {
  clear

  # Title box
  box_top
  box_row "$PINK$BOLD" "LINUX SYSTEM MONITORING"
  box_row "$PINK$BOLD" "& BACKUP UTILITY - SysSnapshot"
  box_row "$PINK$BOLD" "VERSION 1.0"
  box_bottom

  # Joined menu box
  box_top

  # SYSTEM HEALTH
  box_row "$CYAN$BOLD" "SYSTEM HEALTH & USER ACTIVITY"
  box_sep
  box_row "$CYAN" "1) Check System Resources"
  box_row "$CYAN" "2) Track User Activity & Sessions"

  # BACKUP
  box_sep
  box_row "$YELLOW$BOLD" "BACKUP MANAGEMENT"
  box_sep
  box_row "$YELLOW" "3) Create Incremental Backup"
  box_row "$YELLOW" "4) Verify Backup Integrity"

  # REPORTING
  box_sep
  box_row "$GREEN$BOLD" "REPORTING & ANALYSIS"
  box_sep
  box_row "$GREEN" "5) Generate Filesystem Usage Report"
  box_row "$GREEN" "6) Analyze Running Processes"

  # EXIT
  box_sep
  box_row "$RED$BOLD" "0) Exit"

  box_bottom

  printf "\n%sEnter choice (0–6): %s" "$BOLD" "$RESET"
}

show_help() {
  cat <<EOF
SysSnapshot - Linux System Monitoring & Backup Utility (Modular)

Usage:
  ./monitor.sh            # run interactive menu
  ./monitor.sh --help     # show this help

Project structure:
  monitor.sh              - main controller
  lib/*.sh                - feature modules
  config/settings.conf    - configuration (paths, logging)
  logs/system_monitor.log - log file
  backups/                - backup destination
  reports/                - generated reports
  tests/                  - test scripts

EOF
}

# -----------------------------
# Entry Point
# -----------------------------
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  show_help
  exit 0
fi

check_dependencies
log_info "SysSnapshot started (modular version)."

while true; do
  display_menu
  read -r choice
  case "$choice" in
    1) check_system_resources ;;
    2) track_user_activity ;;
    3) create_incremental_backup ;;
    4) verify_backup_integrity ;;
    5) generate_filesystem_report ;;
    6) analyze_running_processes ;;
    0) echo "Goodbye!"; log_info "SysSnapshot exited by user."; exit 0 ;;
    *) err "Invalid choice. Please enter a number between 0 and 6."; sleep 1 ;;
  esac
done
