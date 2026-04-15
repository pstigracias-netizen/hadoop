#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/common.sh"

COUNT="${1:-}"
LINES_PER_FILE="${2:-$DEFAULT_LINE_COUNT}"
WORDS_PER_LINE="${3:-$DEFAULT_LINE_WIDTH}"

if [[ -z "$COUNT" ]]; then
  echo "Gunakan: $0 <jumlah_file> [baris_per_file] [kata_per_baris]"
  exit 1
fi

if ! [[ "$COUNT" =~ ^[0-9]+$ ]]; then
  echo "jumlah_file harus berupa angka"
  exit 1
fi

DATASET_DIR="$DATASETS_DIR/files_$COUNT"
rm -rf "$DATASET_DIR"
mkdir -p "$DATASET_DIR"

WORDS=(
  hadoop mapreduce yarn namenode datanode block cluster
  dataset smallfile benchmark worker master throughput latency
  scheduler replication storage network memory cpu disk
  analytics processing distributed experiment thesis monitoring
)

for ((i = 1; i <= COUNT; i++)); do
  file_path="$DATASET_DIR/file_$(printf "%05d" "$i").txt"
  {
    echo "file_id=$i"
    echo "scenario=small-files-benchmark"
    for ((line = 1; line <= LINES_PER_FILE; line++)); do
      row=()
      for ((word = 1; word <= WORDS_PER_LINE; word++)); do
        idx=$(( (i + line + word) % ${#WORDS[@]} ))
        row+=("${WORDS[$idx]}")
      done
      printf "%s\n" "${row[*]}"
    done
  } > "$file_path"
done

echo "Dataset berhasil dibuat: $DATASET_DIR"
echo "Jumlah file      : $(dataset_file_count "$DATASET_DIR")"
echo "Total ukuran byte: $(dataset_total_bytes "$DATASET_DIR")"
