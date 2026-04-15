#!/bin/bash

set -euo pipefail

export JAVA_HOME="${JAVA_HOME:-/usr/lib/jvm/java-11-openjdk-amd64}"
export HADOOP_HOME="${HADOOP_HOME:-/usr/local/hadoop}"
export HADOOP_CONF_DIR="${HADOOP_CONF_DIR:-$HADOOP_HOME/etc/hadoop}"
export HADOOP_OWNER_USER="${HADOOP_OWNER_USER:-$(id -un)}"
export HADOOP_OWNER_GROUP="${HADOOP_OWNER_GROUP:-$(id -gn)}"
export PATH="$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH"
