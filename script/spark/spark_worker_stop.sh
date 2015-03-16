#!/bin/bash

#stop the slave
$SPARK_HOME/sbin/spark-daemons.sh stop org.apache.spark.deploy.worker.Worker 1