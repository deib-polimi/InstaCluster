#!/bin/bash

path=/home/ubuntu/HDP-amazon-scripts

#start the master and the slaves
$SPARK_HOME/sbin/stop-master.sh

#start the jobserver (assumes that the spark job server is already in the image)
$path/resources/job-server/server_stop.sh
