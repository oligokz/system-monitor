#!/bin/bash
########################################################################
# FILE NAME : monitor.sh
# PROJECT   : System Monitor – Linux System Monitoring & Backup Utility
# COURSE    : CIML019 - Software Defined Infrastructure & Services
# AUTHOR    : Bernard Lim (8001381B)
# VERSION   : 1.0
# DATE      : 2025-11-30
#
# DESCRIPTION:
#   Main controller script for System Monitor. Responsible for:
#     • Loading configuration values
#     • Loading feature modules from ./lib
#     • Performing dependency checks
#     • Displaying interactive menu
#     • Routing user selections to modules
#
#   Auto-created folders:
#     config/   – settings.conf
#     logs/     – system_monitor.log
#     backups/  – incremental backups
#     reports/  – filesystem/process reports
#     tests/    – test results
########################################################################


# =====================================================================
# PROJECT PATHS & REQUIRED DIRECTORIES
# =====================================================================
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="$BASE_DIR/lib"
CONFIG_DIR="$BASE_DIR/config"
LOG_DIR="$BASE_DIR/logs"
BACKUP_DEST_BASE="$BASE_DIR/backups"
REPORTS_DIR="$BASE_DIR/reports"
TESTS_DIR="$BASE_DIR/tests"

mkdir -p "$LIB_DIR" "$CONFIG_DIR" "$LOG_DIR" "$BACKUP_DEST_BASE" "$REPORTS_DIR" "$TESTS_DIR"


# =====================================================================
# DEFAULT CONFIG VALUES (Overridden by settings.conf)
# =====================================================================
DEFAULT_BACKUP_SOURCE="/home/$USER/documents"
DEFAULT_BACKUP_DEST="$BACKUP_DEST_BASE"
DEFAULT_FS_PATH="/"

BACKUP_SOURCE="$DEFAULT_BACKUP_SOURCE"
BACKUP_DEST="$DEFAULT_BACKUP_DEST"
FS_DEFAULT_PATH="$DEFAULT_FS_PATH"
LOG_FILE="$LOG_DIR/system_monitor.log"
LOG_LEVEL="INFO"
VERBOSE="false"

# Load optional settings file
if [[ -f "$CONFIG_DIR/settings.conf" ]]; then
  # shellcheck disable=SC1090
  source "$CONFIG_DIR/settings.conf"
fi

# Normalize paths
[[ "$BACKUP_DEST" != /* ]] && BACKUP_DEST="$BASE_DIR/$BACKUP_DEST"
[[ "$LOG_FILE"    != /* ]] && LOG_FILE="$BASE_DIR/$LOG_FILE"
[[ -z "$FS_DEFAULT_PATH" ]] && FS_DEFAULT_PATH="/"

LAST_BACKUP_REF_FILE="$BACKUP_DEST/.last_backup"


# =====================================================================
# LOAD MODULES (logging first)
# =====================================================================
# Logging module
# shellcheck disable=SC1090
source "$LIB_DIR/logging.sh"
log_init

# UI module
# shellcheck disable=SC1090
source "$LIB_DIR/ui.sh"

# System resources
# shellcheck disable=SC1090
source "$LIB_DIR/resources.sh"

# User activity
# shellcheck disable=SC1090
source "$LIB_DIR/users.sh"

# Backup management
# shellcheck disable=SC1090
source "$LIB_DIR/backup.sh"

# Filesystem reporting
# shellcheck disable=SC1090
source "$LIB_DIR/filesystem.sh"

# Process analysis
# shellcheck disable=SC1090
source "$LIB_DIR/process.sh"


# =====================================================================
# FUNCTION: check_dependencies
# PURPOSE : Ensure required system commands exist
# =====================================================================
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
    echo "Please install them and re-run System Monitor."
    log_error "Missing dependencies: ${missing[*]}"
    exit 1
  fi
}


# =====================================================================
# FUNCTION: display_menu
# PURPOSE : Render main menu
# =====================================================================
display_menu() {
  clear

  # Title box (UPDATED to System Monitor)
  box_top
  box_row "$PINK$BOLD" "SYSTEM MONITOR"
  box_row "$PINK$BOLD" "LINUX SYSTEM MONITORING & BACKUP UTILITY"
  box_row "$PINK$BOLD" "VERSION 1.0"
  box_bottom

  # Menu block
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


# =====================================================================
# FUNCTION: show_help
# PURPOSE : CLI help
# =====================================================================
show_help() {
  cat <<EOF
System Monitor – Linux System Monitoring & Backup Utility

Usage:
  ./monitor.sh            # Run interactive menu
  ./monitor.sh --help     # Display this help

Project structure:
  monitor.sh              - main script
  lib/*.sh                - modules
  config/settings.conf    - config file
  logs/system_monitor.log - log file
  backups/                - backup destination
  reports/                - generated reports
  tests/                  - manual test results

EOF
}


# =====================================================================
# ENTRY POINT
# =====================================================================
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  show_help
  exit 0
fi

check_dependencies
log_info "System Monitor started."

# Main interactive loop
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
    0) echo "Goodbye!"; log_info "System Monitor exited by user."; exit 0 ;;
    *) err "Invalid choice. Please enter a number between 0 and 6."; sleep 1 ;;
  esac
done
