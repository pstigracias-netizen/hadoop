#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

RESULTS_DIR="${RESULTS_DIR:-$REPO_ROOT/results}"
DATASETS_DIR="${DATASETS_DIR:-$REPO_ROOT/datasets}"
DEFAULT_LINE_COUNT="${DEFAULT_LINE_COUNT:-20}"
DEFAULT_LINE_WIDTH="${DEFAULT_LINE_WIDTH:-12}"

mkdir -p "$RESULTS_DIR"
mkdir -p "$DATASETS_DIR"

timestamp_now() {
  date +"%Y-%m-%dT%H:%M:%S%z"
}

active_worker_count() {
  grep -cve '^\s*$' "$REPO_ROOT/config/workers"
}

dataset_file_count() {
  local dataset_dir="$1"
  find "$dataset_dir" -maxdepth 1 -type f | wc -l | tr -d ' '
}

dataset_total_bytes() {
  local dataset_dir="$1"
  find "$dataset_dir" -maxdepth 1 -type f -printf "%s\n" | awk '{sum += $1} END {print sum + 0}'
}

ensure_results_csv() {
  local csv_file="$RESULTS_DIR/experiment_results.csv"
  if [[ ! -f "$csv_file" ]]; then
    echo "timestamp,label,input_path,output_path,worker_count,small_file_count,total_bytes,duration_seconds,status" > "$csv_file"
  fi
}
