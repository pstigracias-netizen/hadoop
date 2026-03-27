#!/bin/bash

set -e

HADOOP_HOME="/usr/local/hadoop"
HADOOP_CONF_DIR="$HADOOP_HOME/etc/hadoop"

echo "[1/5] Membuat direktori Hadoop di master..."
mkdir -p "$HADOOP_HOME/tmp"
mkdir -p "$HADOOP_HOME/data/hdfs/namenode"
mkdir -p "$HADOOP_HOME/data/hdfs/datanode"

echo "[2/5] Menyalin konfigurasi ke direktori Hadoop..."
cp config/core-site.xml "$HADOOP_CONF_DIR/core-site.xml"
cp config/hdfs-site.xml "$HADOOP_CONF_DIR/hdfs-site.xml"
cp config/mapred-site.xml "$HADOOP_CONF_DIR/mapred-site.xml"
cp config/yarn-site.xml "$HADOOP_CONF_DIR/yarn-site.xml"
cp config/workers "$HADOOP_CONF_DIR/workers"

echo "[3/5] Mengatur permission..."
chown -R hadoop:hadoop "$HADOOP_HOME"

echo "[4/5] Menampilkan daftar worker..."
cat "$HADOOP_CONF_DIR/workers"

echo "[5/5] Setup master selesai."
echo "Langkah berikutnya:"
echo "  1. Salin file config/hosts ke /etc/hosts pada semua node"
echo "  2. Jalankan setup-worker.sh di setiap worker"
echo "  3. Format NameNode: hdfs namenode -format"
echo "  4. Start service: start-dfs.sh && start-yarn.sh"
