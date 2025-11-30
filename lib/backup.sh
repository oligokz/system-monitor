########################################################################
# FILE NAME : backup.sh
# PURPOSE   : Incremental backup creation & backup integrity verification
# PROJECT   : System Monitor
# AUTHOR    : Bernard Lim (8001381B)
# VERSION   : 1.1
#
# FEATURES:
#   - Incremental backups using rsync
#   - Trash mechanism for deleted files
#   - User-confirmed creation of missing backup directories
#   - File-by-file verification with mismatch reporting
########################################################################

# Base data/trash directories inside backups/
BACKUP_DATA_DIR="${BACKUP_DATA_DIR:-$BACKUP_DEST/data}"
BACKUP_TRASH_DIR="${BACKUP_TRASH_DIR:-$BACKUP_DEST/trash}"

# =====================================================================
# OPTION 3 — Incremental Backup
# =====================================================================

# Create an incremental backup with trash-handling for deleted files
create_incremental_backup() {
  while true; do
    clear
    box_top
    box_row "$YELLOW$BOLD" "INCREMENTAL BACKUP"
    box_sep
    echo "Press M to return to menu."
    echo

    # --- Ask for source directory ---
    printf "Enter source directory [%s]: " "$BACKUP_SOURCE"
    read -r src_in
    [[ "$src_in" =~ ^[Mm]$ ]] && return
    local src="${src_in:-$BACKUP_SOURCE}"

    # Validate source directory
    if [[ ! -d "$src" ]]; then
      err "Source directory does not exist: $src"
      log_error "Backup failed – missing source: $src"
      box_bottom
      printf "\nPress M to return..."
      while read -r k; do [[ "$k" =~ ^[Mm]$ ]] && return; done
    fi

    # --- Ask for backup data directory ---
    printf "Enter backup data directory [%s]: " "$BACKUP_DATA_DIR"
    read -r dest_in
    [[ "$dest_in" =~ ^[Mm]$ ]] && return
    local data_dest="${dest_in:-$BACKUP_DATA_DIR}"

    [[ "$data_dest" != /* ]] && data_dest="$BASE_DIR/$data_dest"
    echo

    # === Missing directory? Ask user if they want to create it ===
    if [[ ! -d "$data_dest" ]]; then
      err "Backup data directory does not exist: $data_dest"
      log_warn "Missing backup directory: $data_dest"
      echo
      echo "Would you like System Monitor to create it?"
      echo "(Y) Yes — Create directory"
      echo "(N) No  — Return"
      echo
      while true; do
        printf "Enter choice: "
        read -r ans
        case "$ans" in
          Y|y)
            if mkdir -p "$data_dest"; then
              ok "Directory created: $data_dest"
              log_info "Created missing backup directory: $data_dest"
            else
              err "Failed to create directory."
              log_error "Failed to create backup directory: $data_dest"
              box_bottom
              printf "Press M to return..."
              while read -r k; do [[ "$k" =~ ^[Mm]$ ]] && return; done
            fi
            break
            ;;
          N|n)
            box_bottom
            return
            ;;
          *) echo "Please enter Y or N." ;;
        esac
      done
    fi

    # Ensure trash exists
    local trash_root="$BACKUP_TRASH_DIR"
    [[ "$trash_root" != /* ]] && trash_root="$BASE_DIR/$trash_root"
    mkdir -p "$trash_root"

    # Resolve source folder name
    local source_name timestamp
    source_name="$(basename "$src")"
    timestamp="$(date +%Y-%m-%d_%H-%M)"

    # Find latest backup for this source, if any
    local existing_backup backup_dir
    existing_backup="$(find "$data_dest" -maxdepth 1 -type d -name "${source_name}_*" 2>/dev/null | sort | tail -n 1)"

    if [[ -n "$existing_backup" ]]; then
      backup_dir="$existing_backup"
      info "Existing backup found: $(basename "$backup_dir")"
    else
      backup_dir="$data_dest/${source_name}_$timestamp"
      mkdir -p "$backup_dir"
      info "No existing backup found. Creating new folder."
    fi

    # Setup source-specific trash folder
    local trash_source_dir="$trash_root/$source_name"
    mkdir -p "$trash_source_dir"

    # --- Identify deleted files and move them to trash ---
    if [[ -n "$existing_backup" ]]; then
      info "Checking for deleted files..."
      while IFS= read -r bfile; do
        local rel="${bfile#$backup_dir/}"
        local src_file="$src/$rel"
        if [[ ! -e "$src_file" ]]; then
          local base trash_file
          base="$(basename "$rel")"
          trash_file="$trash_source_dir/${base}.$timestamp"
          mv "$bfile" "$trash_file"
          log_info "Deleted file moved to trash: $rel"
        fi
      done < <(find "$backup_dir" -type f)
      find "$backup_dir" -type d -empty -delete 2>/dev/null
    fi

    # --- Run rsync to update backup directory ---
    info "Synchronizing files using rsync..."
    rsync -av "$src"/ "$backup_dir"/
    if (( $? != 0 )); then
      err "rsync failed."
      log_error "rsync error during backup."
      box_bottom
      printf "\nPress M to exit, B to retry: "
      while read -r k; do
        case "$k" in
          M|m) return ;;
          B|b) break ;;
        esac
      done
      continue
    fi

    # Rename backup folder with fresh timestamp
    local new_backup_dir="$data_dest/${source_name}_$timestamp"
    if [[ "$backup_dir" != "$new_backup_dir" ]]; then
      mv "$backup_dir" "$new_backup_dir"
      backup_dir="$new_backup_dir"
    fi

    # --- Summary ---
    local file_count size
    file_count="$(find "$backup_dir" -type f | wc -l)"
    size="$(du -sh "$backup_dir" | awk '{print $1}')"

    echo
    echo "=== Incremental Backup Summary ==="
    echo "Source directory : $src"
    echo "Backup folder    : $backup_dir"
    echo "Files in backup  : $file_count"
    echo "Total size       : $size"
    ok "Backup completed successfully."
    log_info "Backup complete: $backup_dir"

    box_bottom
    printf "\nPress M to return, B to run another backup: "

    while read -r key; do
      case "$key" in
        M|m) return ;;
        B|b) break ;;
      esac
    done

  done  # end while
}


# =====================================================================
# OPTION 4 — Backup Verification
# =====================================================================

# Verify that latest backup matches the source directory
verify_backup_integrity() {
  while true; do
    clear
    box_top
    box_row "$YELLOW$BOLD" "BACKUP VERIFICATION"
    box_sep
    echo "Press M to return to menu."
    echo

    # --- Ask for source directory ---
    printf "Enter source directory to verify [%s]: " "$BACKUP_SOURCE"
    read -r src_in
    [[ "$src_in" =~ ^[Mm]$ ]] && return
    local src="${src_in:-$BACKUP_SOURCE}"

    if [[ ! -d "$src" ]]; then
      err "Source directory does not exist: $src"
      log_error "Verification failed – missing source: $src"
      box_bottom
      printf "\nPress M to return..."
      while read -r k; do [[ "$k" =~ ^[Mm]$ ]] && return; done
    fi

    # --- Ask for backup data directory ---
    printf "Enter backup data directory [%s]: " "$BACKUP_DATA_DIR"
    read -r dest_in
    [[ "$dest_in" =~ ^[Mm]$ ]] && return
    local data_dest="${dest_in:-$BACKUP_DATA_DIR}"
    [[ "$data_dest" != /* ]] && data_dest="$BASE_DIR/$data_dest"
    echo

    if [[ ! -d "$data_dest" ]]; then
      err "Backup data directory does not exist: $data_dest"
      log_error "Verification failed – missing backup data folder."
      box_bottom
      printf "\nPress M to return, B to try again: "
      while read -r k; do
        case "$k" in
          M|m) return ;;
          B|b) break ;;
        esac
      done
      continue
    fi

    # Find latest backup folder
    local source_name latest
    source_name="$(basename "$src")"
    latest="$(find "$data_dest" -maxdepth 1 -type d -name "${source_name}_*" | sort | tail -n 1)"

    echo "Source directory : $src"
    echo "Backup data dir  : $data_dest"
    echo "Latest backup    : ${latest:-<none>}"
    echo

    if [[ -z "$latest" ]]; then
      err "No backup found for this source."
      log_warn "Verification – no backup for $source_name"
      box_bottom
      printf "Press M to return, B to retry: "
      while read -r k; do
        case "$k" in
          M|m) return ;;
          B|b) break ;;
        esac
      done
      continue
    fi

    # Count files
    local src_count backup_count mismatches total_checked
    src_count="$(find "$src" -type f | wc -l)"
    backup_count="$(find "$latest" -type f | wc -l)"

    echo "Source files : $src_count"
    echo "Backup files : $backup_count"
    echo

    mismatches=0
    total_checked=0

    # Compare each file
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
        warn "Mismatch: $rel"
        ((mismatches++))
      fi
    done < <(find "$src" -type f)

    echo
    echo "Files checked : $total_checked"
    echo "Mismatches    : $mismatches"
    echo

    if (( mismatches == 0 )); then
      ok "Backup verification PASSED."
      log_info "Verification passed for $src"
    else
      err "Backup verification FAILED."
      log_error "Verification failed – mismatches=$mismatches"
    fi

    box_bottom
    printf "\nPress M to return, B to run verification again: "

    while read -r k; do
      case "$k" in
        M|m) return ;;
        B|b) break ;;
      esac
    done

  done
}
