#!/bin/bash
OUT="backup_permission_output.txt"
SRC="tests/testdata/no_permission_src"
DEST="tests/testdata/backup_permission_test"

mkdir -p "$SRC" "$DEST"
chmod -r "$SRC"   # Remove read permission

echo "=== Test: Backup With Insufficient Permissions ===" > "$OUT"
echo "Date: $(date)" >> "$OUT"
echo >> "$OUT"

{
  echo "[Source Directory]"
  echo "$SRC"
  echo

  echo "[Attempt rsync backup]"
  rsync -av "$SRC/" "$DEST/" 2>&1
  echo

  echo "[Expected: Permission denied]"
} >> "$OUT"

# restore permission so your script does not break later
chmod +r "$SRC"

echo "Output saved to $OUT"
