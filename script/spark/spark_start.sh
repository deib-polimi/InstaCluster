#!/bin/bash

path=/home/ubuntu/HDP-amazon-scripts

#get the namenode host
namenode_ip=$(sh $path/script/get_configuration_parameter.sh hdfs-site dfs.namenode.http-address | cut -d ":" -f 1);
sudo -u ubuntu ssh $namenode_ip "sudo -u hdfs hdfs dfs -mkdir /spark-app-logs"
sudo -u ubuntu ssh $namenode_ip "sudo -u hdfs hdfs dfs -chmod 777 /spark-app-logs"

#start the master and the slaves
sudo $SPARK_HOME/sbin/start-master.sh

#start the jobserver (assumes that the spark job server is already in the image)
sudo $path/resources/job-server/server_start.sh
