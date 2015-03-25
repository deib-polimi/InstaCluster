#!/bin/bash
path=/home/ubuntu/HDP-amazon-scripts
#get cluster name
cluster_name=$(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters" | jq -r '.items[0].Clusters.cluster_name');

# get spark master
master=$(sh $path/script/get_component_host.sh SPARK SPARK_DRIVER);

#set up the driver url
sudo sed -i '/spark.master/d' /etc/spark/conf/spark-defaults.conf
echo "spark.master                     spark://"$master":7077"  | sudo tee --append /etc/spark/conf/spark-defaults.conf
#set the address of the namenode 
namenode_ip=$(sh $path/script/get_configuration_parameter.sh hdfs-site dfs.namenode.http-address | cut -d ":" -f 1);

# set up the configuration (assumption is that the NN is in $namenode)
## set the logging folder
sudo sed -i '/spark.eventLog.dir/d' /etc/spark/conf/spark-defaults.conf
echo "spark.eventLog.dir               hdfs://$namenode_ip:8020/spark-app-logs" | sudo tee --append /etc/spark/conf/spark-defaults.conf

#set the master and jobserver ip (they are always colocated)
echo "SPARK_MASTER_IP=$master"  | sudo tee --append /etc/spark/conf/spark-env.sh
sudo sed -i "s/SPARK_MASTER_HOST/$master/g" /etc/spark/conf/spark-defaults.conf