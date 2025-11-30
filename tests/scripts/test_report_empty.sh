#!/bin/bash
OUT="report_empty_output.txt"
TARGET="tests/testdata/empty_src"

mkdir -p "$TARGET"

echo "=== Test: Filesystem Report (Empty Directory) ===" > "$OUT"
echo "Date: $(date)" >> "$OUT"
echo >> "$OUT"

{
  echo "[Analysing path]"
  echo "$TARGET"
  echo

  echo "[du results]"
  du -sh "$TARGET"/* 2>&1
  echo

  echo "[Directory with most files]"
  find "$TARGET" -type f -printf "%h\n" 2>/dev/null | sort | uniq -c | sort -nr | head -n 1
} >> "$OUT"

echo "Output saved to $OUT"
