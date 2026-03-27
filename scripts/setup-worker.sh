#!/bin/bash

set -e

HADOOP_HOME="/usr/local/hadoop"
HADOOP_CONF_DIR="$HADOOP_HOME/etc/hadoop"

echo "[1/4] Membuat direktori Hadoop di worker..."
mkdir -p "$HADOOP_HOME/tmp"
mkdir -p "$HADOOP_HOME/data/hdfs/datanode"

echo "[2/4] Menyalin konfigurasi ke direktori Hadoop..."
cp config/core-site.xml "$HADOOP_CONF_DIR/core-site.xml"
cp config/hdfs-site.xml "$HADOOP_CONF_DIR/hdfs-site.xml"
cp config/mapred-site.xml "$HADOOP_CONF_DIR/mapred-site.xml"
cp config/yarn-site.xml "$HADOOP_CONF_DIR/yarn-site.xml"

echo "[3/4] Mengatur permission..."
chown -R hadoop:hadoop "$HADOOP_HOME"

echo "[4/4] Setup worker selesai."
echo "Pastikan /etc/hosts sudah berisi master dan seluruh worker."
