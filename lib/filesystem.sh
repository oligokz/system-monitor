########################################################################
# FILE NAME : filesystem.sh
# PURPOSE   : Filesystem usage reporting & analysis
# AUTHOR    : Bernard Lim (8001381B)
# VERSION   : 1.0
########################################################################

# =====================================================================
# FILESYSTEM USAGE REPORT MODULE (Option 5)
# With analyse-again mini-menu and M-to-menu navigation
# =====================================================================

# Generate a filesystem usage report and save it into reports/
generate_filesystem_report() {

  while true; do   # LOOP until user chooses M to return to menu
    clear
    box_top
    box_row "$GREEN$BOLD" "FILESYSTEM REPORT"
    box_sep

    # ------------------------------
    # NEW: Show navigation instruction
    # ------------------------------
    echo "Press M to return to menu."
    echo

    # ------------------------------
    # Prompt: Path to analyse
    # ------------------------------
    printf "Enter path to analyse [%s]: " "$FS_DEFAULT_PATH"
    read -r path_in

    case "$path_in" in
        M|m) return ;;                        # cancel and return to menu
    esac

    local path="${path_in:-$FS_DEFAULT_PATH}"

    # Validate the path before doing heavy work
    if [[ ! -d "$path" ]]; then
      err "Invalid path: $path"
      log_error "Filesystem report failed – invalid path: $path"
      box_bottom
      printf "\nPress M to return to menu... "
      while true; do
        read -r key
        case "$key" in
          M|m) return ;;
          *) : ;;
        esac
      done
    fi

    echo
    echo "Generating report for: $path"
    echo

    # Ensure reports directory exists
    mkdir -p "$REPORTS_DIR"

    local report
    report="$REPORTS_DIR/fs_$(date +%Y-%m-%d_%H-%M-%S).txt"

    # ==========================================================
    # Filesystem Report Generation
    # ==========================================================
    {
      echo "=== Filesystem Report ==="
      echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')"
      echo "Path     : $path"
      echo

      echo "Top 10 Largest Directories:"
      du -sh "$path"/* 2>/dev/null | sort -rh | head -n 10
      echo

      echo "Filesystem Usage by Type:"
      df -T 2>/dev/null | awk '
        NR>1 {
          used[$2]+=$4; total[$2]+=$3;
        }
        END {
          for (t in used) {
            pct = (used[t]*100)/total[t];
            printf "  %s: %.1fG / %.1fG (%.0f%%)\n",
                   t, used[t]/1024/1024, total[t]/1024/1024, pct;
          }
        }'
      echo

      echo "Directory with Most Files:"
      most=$(find "$path" -type f -printf "%h\n" 2>/dev/null | sort | uniq -c | sort -nr | head -n1)
      if [[ -n "$most" ]]; then
        count=$(echo "$most" | awk '{print $1}')
        dir=$(echo "$most" | awk '{$1=""; sub(/^ /,""); print}')
        echo "  $dir ($count files)"
      else
        echo "  No files found under $path"
      fi

      echo
      echo "Total Space for $path:"
      df -h "$path" 2>/dev/null | awk 'NR==2 {printf "  %s used of %s (%s)\n",$3,$2,$5}'
    } | tee "$report"

    ok "Filesystem report saved to $report."
    log_info "Filesystem report generated at $report (path=$path)"
    box_bottom


    # ==========================================================
    # MINI-MENU: Analyse another path or return to menu
    # ==========================================================
    echo
    echo "Choose an option:"
    echo "(A) Analyse another path"
    echo "(M) Return to main menu"
    echo

    while true; do
      printf "Enter choice: "
      read -r choice

      case "$choice" in
          A|a)
             # rerun the loop (analyse another path)
             break
             ;;

          M|m)
             return  # exit the entire function → return to menu
             ;;

          "")
             # ENTER = ignore (do nothing)
             ;;

          *)
             # invalid input = ignore
             ;;
      esac

    done

  done
}
