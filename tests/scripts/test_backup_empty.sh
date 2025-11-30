#!/bin/bash
OUT="backup_empty_output.txt"
SRC="tests/testdata/empty_src"
DEST="tests/testdata/backup_empty_test"

mkdir -p "$SRC" "$DEST"

echo "=== Test: Backup Empty Directory ===" > "$OUT"
echo "Date: $(date)" >> "$OUT"
echo >> "$OUT"

{
  echo "[Source Directory]"
  echo "$SRC"
  echo

  echo "[Directory contents before backup]"
  ls -la "$SRC"
  echo

  echo "[Running incremental backup]"
  rsync -av --update "$SRC/" "$DEST/" 2>&1
  echo

  echo "[Backup directory contents]"
  ls -la "$DEST"
} >> "$OUT"

echo "Output saved to $OUT"
