# Logging & verbose helpers
# Expects LOG_FILE, LOG_LEVEL, VERBOSE to be set by monitor.sh

log_init() {
  mkdir -p "$(dirname "$LOG_FILE")"
  : > "$LOG_FILE" 2>/dev/null || true
}

log_level_value() {
  case "$1" in
    ERROR) echo 1 ;;
    WARN)  echo 2 ;;
    INFO)  echo 3 ;;
    DEBUG) echo 4 ;;
    *)     echo 3 ;; # default INFO
  esac
}

_log_should_log() {
  local level="$1"
  local current
  current="$(log_level_value "$LOG_LEVEL")"
  local incoming
  incoming="$(log_level_value "$level")"
  [[ "$incoming" -le "$current" ]]
}

log_message() {
  local level="$1"; shift
  local msg="$*"
  if _log_should_log "$level"; then
    printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$msg" >>"$LOG_FILE"
  fi
}

log_error() { log_message "ERROR" "$*"; }
log_warn()  { log_message "WARN"  "$*"; }
log_info()  { log_message "INFO"  "$*"; }
log_debug() { log_message "DEBUG" "$*"; }

verbose() {
  if [[ "${VERBOSE,,}" == "true" ]]; then
    echo "[VERBOSE] $*"
    log_debug "$*"
  fi
}
