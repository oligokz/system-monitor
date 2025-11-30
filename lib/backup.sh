# =====================================================================
# BACKUP MODULE (Options 3 & 4)
# Incremental Backup (rsync + trash) & Backup Verification
# =====================================================================

# Data + Trash subfolders under the configured BACKUP_DEST
# Example structure:
#   backups/data/<source_name>_YYYY-MM-DD_HH-MM/
#   backups/trash/<source_name>/<filename>.<timestamp>
BACKUP_DATA_DIR="${BACKUP_DATA_DIR:-$BACKUP_DEST/data}"
BACKUP_TRASH_DIR="${BACKUP_TRASH_DIR:-$BACKUP_DEST/trash}"

# ------------------------------------------------------------
# 2.1 INCREMENTAL BACKUP (rsync + manual delete -> trash)
# ------------------------------------------------------------
create_incremental_backup() {
  while true; do
    clear
    box_top
    box_row "$YELLOW$BOLD" "INCREMENTAL BACKUP"
    box_sep

    echo "Press M to return to menu."
    echo

    # ------------------------------
    # Prompt: Source Directory
    # ------------------------------
    printf "Enter source directory [%s]: " "$BACKUP_SOURCE"
    read -r src_in

    case "$src_in" in
      M|m) return ;;
    esac

    local src="${src_in:-$BACKUP_SOURCE}"

    # ------------------------------
    # Prompt: Backup Data Directory (where backup folders live)
    # Example default: /path/to/project/backups/data
    # ------------------------------
    printf "Enter backup data directory [%s]: " "$BACKUP_DATA_DIR"
    read -r dest_in

    case "$dest_in" in
      M|m) return ;;
    esac

    local data_dest="${dest_in:-$BACKUP_DATA_DIR}"
    [[ "$data_dest" != /* ]] && data_dest="$BASE_DIR/$data_dest"

    echo
    echo "Source           : $src"
    echo "Backup data dir  : $data_dest"
    echo

    # Validate source
    if [[ ! -d "$src" ]]; then
      err "Source directory not found."
      log_error "Backup failed – source not found: $src"
      box_bottom

      printf "\nPress M to return... "
      while true; do
        read -r k
        [[ "$k" =~ ^[Mm]$ ]] && return
      done
    fi

    # Ensure data + trash directories exist
    mkdir -p "$data_dest"

    local trash_root trash_source_dir
    trash_root="$BACKUP_TRASH_DIR"
    [[ "$trash_root" != /* ]] && trash_root="$BASE_DIR/$trash_root"
    mkdir -p "$trash_root"

    # ------------------------------
    # Resolve source name and existing backup dir
    # ------------------------------
    local source_name timestamp backup_dir existing_backup new_backup_dir
    source_name="$(basename "$src")"
    timestamp="$(date +%Y-%m-%d_%H-%M)"

    # Find the latest existing backup directory for this source, if any
    existing_backup="$(find "$data_dest" -maxdepth 1 -type d -name "${source_name}_*" 2>/dev/null | sort | tail -n 1)"

    if [[ -n "$existing_backup" ]]; then
      backup_dir="$existing_backup"
      info "Existing backup directory found: $(basename "$backup_dir")"
    else
      backup_dir="$data_dest/${source_name}_$timestamp"
      mkdir -p "$backup_dir"
      info "No existing backup found. Creating new backup at: $(basename "$backup_dir")"
    fi

    # ------------------------------
    # Setup trash path: backups/trash/<source_name>/
    # ------------------------------
    trash_source_dir="$trash_root/$source_name"
    mkdir -p "$trash_source_dir"

    # ------------------------------
    # Detect deleted files and move them to trash
    # (only if we had an existing backup)
    # ------------------------------
    if [[ -n "$existing_backup" ]]; then
      info "Checking backup for deleted files to move into trash..."
      while IFS= read -r bfile; do
        # File path relative to backup_dir
        local rel src_file base trash_file
        rel="${bfile#$backup_dir/}"
        src_file="$src/$rel"

        if [[ ! -e "$src_file" ]]; then
          base="$(basename "$rel")"
          trash_file="$trash_source_dir/${base}.$timestamp"
          mv "$bfile" "$trash_file"
          log_info "Moved deleted file to trash: $rel -> $trash_file"
        fi
      done < <(find "$backup_dir" -type f 2>/dev/null)

      # Clean up any now-empty directories in the backup
      find "$backup_dir" -type d -empty -delete 2>/dev/null
    fi

    # ------------------------------
    # Run rsync to update backup (add/overwrite files)
    # ------------------------------
    echo
    info "Running rsync from source to backup directory..."
    rsync -av "$src"/ "$backup_dir"/
    local rsync_status=$?

    if (( rsync_status != 0 )); then
      err "rsync failed with status $rsync_status."
      log_error "Incremental backup failed (rsync status=$rsync_status) for source=$src"
      box_bottom

      printf "\nPress M to return, B to run another backup: "
      while true; do
        read -r key
        case "$key" in
          M|m) return ;;
          B|b) break ;;
        esac
      done
      continue
    fi

    # ------------------------------
    # Rename backup folder to reflect new timestamp
    # Ensures EXACTLY ONE backup dir per source with fresh timestamp
    # ------------------------------
    new_backup_dir="$data_dest/${source_name}_$timestamp"
    if [[ "$backup_dir" != "$new_backup_dir" ]]; then
      mv "$backup_dir" "$new_backup_dir"
      backup_dir="$new_backup_dir"
    fi

    # ------------------------------
    # Stats and summary
    # ------------------------------
    local file_count size
    file_count="$(find "$backup_dir" -type f 2>/dev/null | wc -l)"
    size="$(du -sh "$backup_dir" 2>/dev/null | awk '{print $1}')"

    echo
    echo "=== Incremental Backup Summary ==="
    echo "Source directory : $src"
    echo "Backup folder    : $backup_dir"
    echo "Files in backup  : $file_count"
    echo "Total size       : $size"
    ok "Incremental backup completed successfully."

    log_info "Incremental backup at $backup_dir (files=$file_count, size=$size)"

    box_bottom
    printf "\nPress M to return, B to run another backup: "
    while true; do
      read -r key
      case "$key" in
        M|m) return ;;   # exit function to main menu
        B|b) break ;;    # restart outer while for another backup
      esac
    done

  done  # end while true
}

# ------------------------------------------------------------
# 2.2 BACKUP VERIFICATION (source vs latest backup)
# With B-option to verify again
# ------------------------------------------------------------
verify_backup_integrity() {
  while true; do
    clear
    box_top
    box_row "$YELLOW$BOLD" "BACKUP VERIFICATION"
    box_sep

    echo "Press M to return to menu."
    echo

    # ------------------------------
    # Prompt: Source Directory
    # ------------------------------
    printf "Enter source directory to verify [%s]: " "$BACKUP_SOURCE"
    read -r src_in
    [[ "$src_in" =~ ^[Mm]$ ]] && return
    local src="${src_in:-$BACKUP_SOURCE}"

    # ------------------------------
    # Prompt: Backup Data Directory
    # ------------------------------
    printf "Enter backup data directory [%s]: " "$BACKUP_DATA_DIR"
    read -r dest_in
    [[ "$dest_in" =~ ^[Mm]$ ]] && return
    local data_dest="${dest_in:-$BACKUP_DATA_DIR}"
    [[ "$data_dest" != /* ]] && data_dest="$BASE_DIR/$data_dest"

    echo

    local source_name latest
    source_name="$(basename "$src")"

    # Find latest backup directory for this source
    latest="$(find "$data_dest" -maxdepth 1 -type d -name "${source_name}_*" 2>/dev/null | sort | tail -n 1)"

    echo "Source directory : $src"
    echo "Backup data dir  : $data_dest"
    echo "Latest backup    : ${latest:-<none>}"
    echo

    if [[ -z "$latest" ]]; then
      err "No backup directory found for source '$source_name'."
      box_bottom
      printf "\nPress M to return to menu, B to verify again: "
      while true; do
        read -r k
        case "$k" in
          M|m) return ;;
          B|b) break ;;
        esac
      done
      continue
    fi

    if [[ ! -d "$src" ]]; then
      err "Source directory does not exist: $src"
      box_bottom
      printf "\nPress M to return to menu, B to verify again: "
      while true; do
        read -r k
        case "$k" in
          M|m) return ;;
          B|b) break ;;
        esac
      done
      continue
    fi

    local src_count backup_count
    src_count="$(find "$src" -type f 2>/dev/null | wc -l)"
    backup_count="$(find "$latest" -type f 2>/dev/null | wc -l)"

    echo "Source files : $src_count"
    echo "Backup files : $backup_count"
    echo

    local mismatches=0 total_checked=0

    info "Comparing source files with latest backup..."

    while IFS= read -r sfile; do
      ((total_checked++))
      local rel bfile
      rel="${sfile#$src/}"
      bfile="$latest/$rel"

      if [[ ! -f "$bfile" ]]; then
        warn "Missing in backup: $rel"
        ((mismatches++))
        continue
      fi

      if ! cmp -s "$sfile" "$bfile"; then
        warn "Content mismatch: $rel"
        ((mismatches++))
      fi
    done < <(find "$src" -type f 2>/dev/null)

    echo
    echo "Files checked : $total_checked"
    echo "Mismatches    : $mismatches"
    echo

    if (( mismatches == 0 )); then
      ok "Backup verification PASSED – all source files exist and match in latest backup."
    else
      err "Backup verification FAILED – some files are missing or differ."
    fi

    box_bottom
    printf "\nPress M to return to menu, B to run verification again: "
    while true; do
      read -r k
      case "$k" in
        M|m) return ;;  # exit to main menu
        B|b) break ;;   # repeat verification loop
      esac
    done

  done  # end while true
}
