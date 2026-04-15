#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

COUNT="${1:-}"

if [[ -z "$COUNT" ]]; then
  echo "Gunakan: $0 <jumlah_worker_aktif>"
  exit 1
fi

if ! [[ "$COUNT" =~ ^[0-9]+$ ]]; then
  echo "jumlah_worker_aktif harus berupa angka"
  exit 1
fi

if (( COUNT < 0 || COUNT > 5 )); then
  echo "jumlah_worker_aktif harus antara 0 sampai 5"
  exit 1
fi

{
  for ((i = 1; i <= COUNT; i++)); do
    echo "worker$i"
  done
} > "$REPO_ROOT/config/workers"

echo "config/workers diperbarui:"
cat "$REPO_ROOT/config/workers"
