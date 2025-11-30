# System resource monitoring

check_system_resources() {
  clear
  box_top
  box_row "$CYAN$BOLD" "SYSTEM RESOURCES"
  box_sep

  # CPU load averages
  local load_str
  load_str=$(uptime | awk -F'load average: ' '{print $2}')
  IFS=',' read -r load1 load5 load15 <<<"$load_str"

  # Memory usage (MB)
  local mem_total mem_used mem_free mem_pct
  read -r _ mem_total mem_used mem_free _ < <(free -m | awk 'NR==2 {print $1,$2,$3,$4}')
  mem_pct=$(( mem_used * 100 / mem_total ))

  # Disk usage (root)
  local disk_used disk_total disk_pct
  read -r _ disk_total disk_used _ disk_pct _ < <(df -h / | awk 'NR==2 {print $1,$2,$3,$4,$5,$6}')

  echo "=== System Resources ==="
  printf "CPU Load: %s %s %s (1, 5, 15 min)\n" "$load1" "$load5" "$load15"
  printf "Memory : %sMB total, %sMB used (%s%%)\n" "$mem_total" "$mem_used" "$mem_pct"
  printf "Disk   : %s used of %s (%s)\n" "$disk_used" "$disk_total" "$disk_pct"

  local status=0
  (( mem_pct > 80 )) && { warn "Memory usage above 80%."; status=1; }
  local disk_pct_num=${disk_pct%\%}
  (( disk_pct_num > 80 )) && { warn "Root filesystem usage above 80%."; status=1; }

  (( status == 0 )) && ok "System resources within normal range." || warn "System thresholds exceeded."

  box_bottom
  log_info "System resources checked (status=$status)"

  printf "\nPress M to return to menu... "
  while true; do
      read -r key
      case "$key" in
          M|m) return ;;
          *) : ;;
      esac
  done
}
