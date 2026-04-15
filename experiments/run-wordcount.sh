#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/common.sh"

INPUT_PATH=""
OUTPUT_PATH=""
LABEL=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --input)
      INPUT_PATH="$2"
      shift 2
      ;;
    --output)
      OUTPUT_PATH="$2"
      shift 2
      ;;
    --label)
      LABEL="$2"
      shift 2
      ;;
    *)
      echo "Argumen tidak dikenal: $1"
      exit 1
      ;;
  esac
done

if [[ -z "$INPUT_PATH" || -z "$OUTPUT_PATH" ]]; then
  echo "Gunakan: $0 --input <path_hdfs_input> --output <path_hdfs_output> [--label nama_run]"
  exit 1
fi

if [[ -z "$LABEL" ]]; then
  LABEL="$(basename "$INPUT_PATH")_$(date +%Y%m%d_%H%M%S)"
fi

ensure_results_csv

EXAMPLES_JAR=$(find /usr/local/hadoop/share/hadoop/mapreduce -maxdepth 1 -name 'hadoop-mapreduce-examples-*.jar' | head -n 1)

if [[ -z "$EXAMPLES_JAR" ]]; then
  echo "Jar contoh MapReduce tidak ditemukan."
  exit 1
fi

small_file_count=$(hdfs dfs -count "$INPUT_PATH" | awk '{print $2}')
total_bytes=$(hdfs dfs -count "$INPUT_PATH" | awk '{print $3}')
worker_count=$(active_worker_count)
log_file="$RESULTS_DIR/${LABEL}.log"

hdfs dfs -rm -r -f "$OUTPUT_PATH" >/dev/null 2>&1 || true

start_epoch=$(date +%s)
set +e
hadoop jar "$EXAMPLES_JAR" wordcount "$INPUT_PATH" "$OUTPUT_PATH" 2>&1 | tee "$log_file"
cmd_status=${PIPESTATUS[0]}
set -e
end_epoch=$(date +%s)

duration_seconds=$((end_epoch - start_epoch))
status_text="SUCCESS"
if [[ $cmd_status -ne 0 ]]; then
  status_text="FAILED"
fi

echo "$(timestamp_now),$LABEL,$INPUT_PATH,$OUTPUT_PATH,$worker_count,$small_file_count,$total_bytes,$duration_seconds,$status_text" >> "$RESULTS_DIR/experiment_results.csv"

echo "Label run        : $LABEL"
echo "Durasi           : ${duration_seconds} detik"
echo "Jumlah worker    : $worker_count"
echo "Jumlah smallfile : $small_file_count"
echo "Total bytes      : $total_bytes"
echo "Status           : $status_text"
echo "Log              : $log_file"

exit "$cmd_status"
