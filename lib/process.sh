# =====================================================================
# PROCESS ANALYSIS MODULE (Option 6)
# =====================================================================

analyze_running_processes() {
  clear
  box_top
  box_row "$GREEN$BOLD" "PROCESS ANALYSIS"
  box_sep
  box_bottom

  echo "=== Process Analysis ==="
  echo

  # ----------------- Top 10 by CPU -----------------
  echo "Top 10 by CPU:"
  printf "%-10s %-7s %-6s %s\n" "USER" "PID" "%CPU" "COMMAND"
  ps aux --sort=-%cpu | awk 'NR==1 {next} NR<=11 {printf "%-10s %-7s %-6s %s\n",$1,$2,$3,$11}'
  echo

  # ----------------- Top 10 by Memory --------------
  echo "Top 10 by Memory:"
  printf "%-10s %-7s %-6s %s\n" "USER" "PID" "%MEM" "COMMAND"
  ps aux --sort=-%mem | awk 'NR==1 {next} NR<=11 {printf "%-10s %-7s %-6s %s\n",$1,$2,$4,$11}'
  echo

  # ----------------- Process States ----------------
  echo "Process States:"
  ps -eo stat= | awk '
    {
      s = substr($1,1,1);
      count[s]++;
    }
    END {
      printf "  Running (R):   %d\n", count["R"]+0;
      printf "  Sleeping (S):  %d\n", count["S"]+0;
      printf "  DiskSleep (D): %d\n", count["D"]+0;
      printf "  Stopped (T):   %d\n", count["T"]+0;
      printf "  Zombie (Z):    %d\n", count["Z"]+0;
    }'
  echo

  # ----------------- Long-running >24h -------------
  echo "Long-running processes (>24h):"
  printf "%-7s %-10s %-10s %s\n" "PID" "USER" "ELAPSED" "COMMAND"

  local long_count=0
  while read -r pid user etime comm; do
    local is_long=0

    # Case 1: format includes days (dd-hh:mm:ss)
    if [[ "$etime" == *-* ]]; then
      is_long=1
    else
      # Case 2: hh:mm:ss format
      IFS=':' read -r h m s <<<"$etime"
      if [[ "$etime" == *:*:* ]]; then
        (( h >= 24 )) && is_long=1
      fi
    fi

    if (( is_long == 1 )); then
      printf "%-7s %-10s %-10s %s\n" "$pid" "$user" "$etime" "$comm"
      (( long_count++ ))
    fi

  done < <(ps -eo pid,user,etime,comm --no-headers)

  (( long_count == 0 )) && echo "  None found." || echo "Total long-running processes: $long_count"

  echo
  ok "Process analysis complete."
  log_info "Process analysis completed (long_running=$long_count)"

  box_bottom

  # ----------------- Navigation (M to menu) -----------------
  printf "\nPress M to return to menu... "
  while true; do
      read -r key
      case "$key" in
          M|m) return ;;     # return to main menu
          *) : ;;            # ENTER or any other key ignored
      esac
  done
}
