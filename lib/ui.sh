# Colour & UI helpers (48-char width boxes)

ORANGE=$'\e[38;5;208m'
CYAN=$'\e[38;5;51m'
YELLOW=$'\e[38;5;226m'
PINK=$'\e[38;5;205m'
RED=$'\e[38;5;203m'
GREEN=$'\e[38;5;46m'
OKGREEN=$'\e[38;5;82m'
BOLD=$'\e[1m'
RESET=$'\e[0m'

WIDTH=48
INNER=$((WIDTH-2))

hline() {
  local color="$1"
  printf '%s' "$color"
  printf '─%.0s' $(seq 1 "$INNER")
  printf '%s' "$RESET"
}

center() {
  local text="$1"
  local len=${#text}
  if (( len >= INNER )); then
    printf '%.*s' "$INNER" "$text"
  else
    local left=$(( (INNER - len) / 2 ))
    local right=$(( INNER - len - left ))
    printf '%*s%s%*s' "$left" '' "$text" "$right" ''
  fi
}

box_row() {
  local color="$1"
  local text="$2"
  printf '%s│%s' "$ORANGE" "$RESET"
  printf '%s' "$color"
  center "$text"
  printf '%s' "$RESET"
  printf '%s│%s\n' "$ORANGE" "$RESET"
}

box_sep() {
  printf '%s├%s' "$ORANGE" "$RESET"; hline "$ORANGE"; printf '%s┤%s\n' "$ORANGE" "$RESET"
}

box_top() {
  printf '%s┌%s' "$ORANGE" "$RESET"; hline "$ORANGE"; printf '%s┐%s\n' "$ORANGE" "$RESET"
}

box_bottom() {
  printf '%s└%s' "$ORANGE" "$RESET"; hline "$ORANGE"; printf '%s┘%s\n' "$ORANGE" "$RESET"
}

info() { printf '%s[i]%s %s\n'   "$CYAN"   "$RESET" "$1"; }
ok()   { printf '%s[OK]%s %s\n'  "$OKGREEN" "$RESET" "$1"; }
warn() { printf '%s[!]%s %s\n'   "$YELLOW" "$RESET" "$1"; }
err()  { printf '%s[ERR]%s %s\n' "$RED"    "$RESET" "$1"; }
