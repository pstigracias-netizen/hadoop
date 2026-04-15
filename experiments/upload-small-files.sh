#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "$SCRIPT_DIR/common.sh"

LOCAL_DATASET_DIR="${1:-}"
HDFS_TARGET_DIR="${2:-}"

if [[ -z "$LOCAL_DATASET_DIR" || -z "$HDFS_TARGET_DIR" ]]; then
  echo "Gunakan: $0 <folder_dataset_lokal> <folder_hdfs_tujuan>"
  exit 1
fi

if [[ ! -d "$LOCAL_DATASET_DIR" ]]; then
  echo "Folder dataset tidak ditemukan: $LOCAL_DATASET_DIR"
  exit 1
fi

hdfs dfs -rm -r -f "$HDFS_TARGET_DIR" >/dev/null 2>&1 || true
hdfs dfs -mkdir -p "$HDFS_TARGET_DIR"
hdfs dfs -put "$LOCAL_DATASET_DIR"/* "$HDFS_TARGET_DIR/"

echo "Dataset berhasil diunggah ke HDFS: $HDFS_TARGET_DIR"
hdfs dfs -count "$HDFS_TARGET_DIR"
