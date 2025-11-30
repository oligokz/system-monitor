########################################################################
# FILE NAME : logging.sh
# PURPOSE   : Logging helpers and VERBOSE support for SysSnapshot
# AUTHOR    : Bernard Lim (8001381B)
# VERSION   : 1.0
# NOTES     : Expects LOG_FILE, LOG_LEVEL, VERBOSE to be set by monitor.sh
########################################################################

# Initialise the log file and ensure directory exists
log_init() {
  mkdir -p "$(dirname "$LOG_FILE")"
  : > "$LOG_FILE" 2>/dev/null || true
}

# Map a log level name to a numeric value for comparison
log_level_value() {
  case "$1" in
    ERROR) echo 1 ;;
    WARN)  echo 2 ;;
    INFO)  echo 3 ;;
    DEBUG) echo 4 ;;
    *)     echo 3 ;; # default INFO
  esac
}

# Internal check if a given level should be logged
_log_should_log() {
  local level="$1"
  local current
  current="$(log_level_value "$LOG_LEVEL")"
  local incoming
  incoming="$(log_level_value "$level")"
  [[ "$incoming" -le "$current" ]]
}

# Write a formatted log message to the log file
log_message() {
  local level="$1"; shift
  local msg="$*"
  if _log_should_log "$level"; then
    printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$msg" >>"$LOG_FILE"
  fi
}

# Convenience wrapper for ERROR level
log_error() { log_message "ERROR" "$*"; }

# Convenience wrapper for WARN level
log_warn()  { log_message "WARN"  "$*"; }

# Convenience wrapper for INFO level
log_info()  { log_message "INFO"  "$*"; }

# Convenience wrapper for DEBUG level
log_debug() { log_message "DEBUG" "$*"; }

# Print verbose messages to stdout and DEBUG log (when VERBOSE=true)
verbose() {
  if [[ "${VERBOSE,,}" == "true" ]]; then
    echo "[VERBOSE] $*"
    log_debug "$*"
  fi
}
