#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

source "$SCRIPT_DIR/hadoop-env.sh"
"$SCRIPT_DIR/check-node.sh" master

mkdir -p "$HADOOP_HOME/tmp"
mkdir -p "$HADOOP_HOME/data/hdfs/namenode"
mkdir -p "$HADOOP_HOME/data/hdfs/datanode"
mkdir -p "$HADOOP_HOME/logs"

cp "$REPO_ROOT/config/core-site.xml" "$HADOOP_CONF_DIR/core-site.xml"
cp "$REPO_ROOT/config/hdfs-site.xml" "$HADOOP_CONF_DIR/hdfs-site.xml"
cp "$REPO_ROOT/config/mapred-site.xml" "$HADOOP_CONF_DIR/mapred-site.xml"
cp "$REPO_ROOT/config/yarn-site.xml" "$HADOOP_CONF_DIR/yarn-site.xml"
cp "$REPO_ROOT/config/workers" "$HADOOP_CONF_DIR/workers"
cp "$REPO_ROOT/config/hadoop-env.sh" "$HADOOP_CONF_DIR/hadoop-env.sh"

chown -R "$HADOOP_OWNER_USER:$HADOOP_OWNER_GROUP" "$HADOOP_HOME"

echo "Setup master selesai."
