#!/bin/bash

##############
# NOT TESTED #
##############

path=/home/ubuntu/HDP-amazon-scripts

#set the address of the namenode 
namenode_ip=$(sh $path/script/get_configuration_parameter.sh hdfs-site dfs.namenode.http-address | cut -d ":" -f 1);

# set up the configuration (assumption is that the NN is in $namenode)
## set the logging folder
echo "spark.eventLog.dir               hdfs://$namenode_ip:8020/user/ubuntu/spark-app-logs" | sudo tee --append /etc/spark/conf/spark-defaults.conf

#set up the driver url
echo 'spark.master                     spark://localhost:7077'  | sudo tee --append /etc/spark/conf/spark-defaults.conf


#set the address of the RM 
rm_ip=$(sh $path/script/get_configuration_parameter.sh yarn-site yarn.resourcemanager.hostname);


#get the RM host
#copy the yarn configuration 
if [ ! -d "/etc/hadoop/conf" ]; then

sudo mkdir -p /etc/hadoop/conf
sudo chown ubuntu:ubuntu /etc/hadoop/conf
scp -r $rm_ip:/etc/hadoop/conf /etc/hadoop 

fi

#set YARN_CONF_DIR env variable
echo 'YARN_CONF_DIR=/etc/hadoop/conf' | sudo tee --append /etc/environment

#get the nameof the cluster (removing \" when necessary)
#cluster_name=$(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters" | jq '.items[0].Clusters.cluster_name');
#cluster_name="${cluster_name%\"}"
#cluster_name="${cluster_name#\"}"
#echo "Cluster name detected from Ambari:"$cluster_name

#push the configuration to all the slaves
#ansible $cluster_name -m copy -a "src=/etc/spark dest=/etc" --sudo
#ansible $cluster_name -a "chown -R ubuntu /etc/spark " --sudo
#ansible $cluster_name -a "chmod -R +x /etc/spark/bin" --sudo
#ansible $cluster_name -a "chmod -R +x /etc/spark/sbin" --sudo


#set the address of the namenode 
historyserver_ip=$(sh $path/script/get_configuration_parameter.sh yarn-site yarn.log.server.url | cut -d ":" -f 2 | cut -d "/" -f 3);

# set up the history server connection between YARN and SPARK
echo "spark.yarn.historyServer.address 	       http://$historyserver_ip:8088" | sudo tee --append /etc/spark/conf/spark-defaults.conf
