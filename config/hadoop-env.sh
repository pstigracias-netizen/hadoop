#!/bin/bash

export JAVA_HOME=${JAVA_HOME:-/usr/lib/jvm/java-11-openjdk-amd64}
export HADOOP_HOME=${HADOOP_HOME:-/usr/local/hadoop}
export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-$HADOOP_HOME/etc/hadoop}

export HDFS_NAMENODE_USER=${HDFS_NAMENODE_USER:-$(id -un)}
export HDFS_DATANODE_USER=${HDFS_DATANODE_USER:-$(id -un)}
export HDFS_SECONDARYNAMENODE_USER=${HDFS_SECONDARYNAMENODE_USER:-$(id -un)}
export YARN_RESOURCEMANAGER_USER=${YARN_RESOURCEMANAGER_USER:-$(id -un)}
export YARN_NODEMANAGER_USER=${YARN_NODEMANAGER_USER:-$(id -un)}

export HADOOP_SSH_OPTS="${HADOOP_SSH_OPTS:--o BatchMode=yes -o StrictHostKeyChecking=no}"
