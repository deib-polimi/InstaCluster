#!/bin/bash

#start the slave
$SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker spark://master:7077
