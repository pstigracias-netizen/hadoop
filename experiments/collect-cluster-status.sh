#!/bin/bash

set -euo pipefail

RESULTS_DIR="${HOME}/hadoop/results/cluster-status-$(date +"%Y%m%d-%H%M%S")"
mkdir -p "$RESULTS_DIR"

jps > "$RESULTS_DIR/master-jps.txt"
hdfs dfsadmin -report > "$RESULTS_DIR/hdfs-report.txt"

for worker in worker1 worker2 worker3 worker4 worker5; do
  ssh "$worker" jps > "$RESULTS_DIR/${worker}-jps.txt"
done

echo "Status cluster tersimpan di $RESULTS_DIR"
