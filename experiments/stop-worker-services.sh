#!/bin/bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Gunakan: $0 <worker...>"
  exit 1
fi

for worker in "$@"; do
  echo "Menghentikan layanan di $worker"
  ssh "$worker" "bash -lc 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64; export HADOOP_HOME=/usr/local/hadoop; export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin; hdfs --daemon stop datanode >/dev/null 2>&1 || true; yarn --daemon stop nodemanager >/dev/null 2>&1 || true; jps'"
done
