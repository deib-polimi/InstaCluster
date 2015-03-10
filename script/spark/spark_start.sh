#!/bin/bash

path=/home/ubuntu/HDP-amazon-scripts

#start the master and the slaves
sudo $SPARK_HOME/sbin/start-master.sh

#start the jobserver (assumes that the spark job server is already in the image)
sudo $path/resources/job-server/server_start.sh
