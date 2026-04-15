#!/bin/bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Gunakan: $0 <worker...>"
  exit 1
fi

for worker in "$@"; do
  echo "Menyalakan layanan di $worker"
  ssh "$worker" "bash -lc 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64; export HADOOP_HOME=/usr/local/hadoop; export PATH=\$PATH:\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin; cd ~/hadoop && bash scripts/setup-worker.sh && hdfs --daemon start datanode && yarn --daemon start nodemanager && jps'"
done
