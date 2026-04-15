#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
SOURCE_HOSTS="$REPO_ROOT/config/hosts"
TARGET_HOSTS="/etc/hosts"
BEGIN_MARKER="# >>> hadoop-thesis-hosts >>>"
END_MARKER="# <<< hadoop-thesis-hosts <<<"
TMP_FILE=$(mktemp)

if [[ ! -f "$SOURCE_HOSTS" ]]; then
  echo "File tidak ditemukan: $SOURCE_HOSTS"
  exit 1
fi

if [[ ! -w "$TARGET_HOSTS" ]]; then
  echo "Tidak bisa menulis ke $TARGET_HOSTS"
  echo "Jalankan dengan sudo: sudo bash scripts/sync-hosts.sh"
  exit 1
fi

awk -v begin="$BEGIN_MARKER" -v end="$END_MARKER" '
  $0 == begin { skip=1; next }
  $0 == end { skip=0; next }
  !skip { print }
' "$TARGET_HOSTS" > "$TMP_FILE"

{
  cat "$TMP_FILE"
  echo
  echo "$BEGIN_MARKER"
  cat "$SOURCE_HOSTS"
  echo "$END_MARKER"
} > "$TARGET_HOSTS"

rm -f "$TMP_FILE"

echo "Mapping host Hadoop berhasil diterapkan ke $TARGET_HOSTS"
