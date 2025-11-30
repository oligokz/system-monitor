#!/bin/bash
OUT="backup_missing_output.txt"
SRC="tests/testdata/missing_src"   # Deleted directory
DEST="tests/testdata/backup_missing_test"

rm -rf "$SRC"   # Ensure missing
mkdir -p "$DEST"

echo "=== Test: Backup Missing Directory ===" > "$OUT"
echo "Date: $(date)" >> "$OUT"
echo >> "$OUT"

{
  echo "[Attempting to back up missing directory]"
  echo "Source: $SRC"
  echo

  if [ ! -d "$SRC" ]; then
    echo "ERROR: Source directory does not exist."
  else
    rsync -av "$SRC/" "$DEST/" 2>&1
  fi
} >> "$OUT"

echo "Output saved to $OUT"
