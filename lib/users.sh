# User activity monitoring

track_user_activity() {
  clear
  box_top
  box_row "$CYAN$BOLD" "USER ACTIVITY"
  box_sep

  echo "=== User Activity ==="

  declare -A user_sessions
  local total_sessions=0

  # who output: user tty date time ...
  while read -r user tty date time _; do
    (( total_sessions++ ))
    (( user_sessions["$user"]++ ))

    # Compute session duration
    local login_str="$date $time"
    local now_ts login_ts diff hours mins duration
    now_ts=$(date +%s)

    if login_ts=$(date -d "$login_str" +%s 2>/dev/null); then
      diff=$(( now_ts - login_ts ))
      hours=$(( diff / 3600 ))
      mins=$(( (diff % 3600) / 60 ))
      duration="${hours}h ${mins}m"
    else
      duration="N/A"
    fi

    printf "%-8s %-8s %-16s (%s)\n" "$user" "$tty" "$time" "$duration"
  done < <(who)

  echo
  echo "Active Sessions : $total_sessions"

  echo "Users with multiple sessions:"
  local found_multi=0
  for u in "${!user_sessions[@]}"; do
    if (( user_sessions["$u"] > 1 )); then
      printf "  %s (%d sessions)\n" "$u" "${user_sessions[$u]}"
      found_multi=1
    fi
  done
  (( found_multi == 0 )) && echo "  None"

  box_bottom
  log_info "User activity checked (sessions=$total_sessions)"

  printf "\nPress M to return to menu... "
  while true; do
      read -r key
      case "$key" in
          M|m) return ;;
          *) : ;;
      esac
  done
}
