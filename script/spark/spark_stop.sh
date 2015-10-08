#!/bin/bash

path=/home/ubuntu/InstaCluster

#start the master and the slaves
sudo $SPARK_HOME/sbin/stop-master.sh

#start the jobserver (assumes that the spark job server is already in the image)
sudo $path/resources/job-server/server_stop.sh
