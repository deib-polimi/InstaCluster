#!/bin/bash

##############
# NOT TESTED #
##############

path=/home/ubuntu/InstaCluster

#set the address of the namenode 
namenode_ip=$(sh $path/script/get_configuration_parameter.sh hdfs-site dfs.namenode.http-address | cut -d ":" -f 1);

# set up the configuration (assumption is that the NN is in $namenode)
## set the logging folder
echo "spark.eventLog.dir               hdfs://$namenode_ip:8020/spark-app-logs" | sudo tee --append /etc/spark/conf/spark-defaults.conf

spark_job_server=$(sh $path/script/get_component_host.sh SPARK SPARK_DRIVER);

#set up the driver url
echo "spark.master                     spark://$spark_job_server:7077"  | sudo tee --append /etc/spark/conf/spark-defaults.conf

sudo sed -i "s/SPARK_MASTER_HOST/$spark_job_server/g" /etc/spark/conf/spark-defaults.conf


#set the address of the RM 
rm_ip=$(sh $path/script/get_configuration_parameter.sh yarn-site yarn.resourcemanager.hostname);


#get the RM host
#copy the yarn configuration 
if [ ! -d "/etc/hadoop/conf" ]; then
echo "downloading yarn configuration"
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

local_ip=$(wget -qO- http://instance-data/latest/meta-data/local-ipv4)

driver=$(cat /etc/hosts | grep $local_ip | cut -d " " -f2)
echo "SPARK_MASTER_IP=$driver"  | sudo tee --append /etc/spark/conf/spark-env.sh
#create the directory for standalone logs
namenode_ip=$(sh $path/script/get_configuration_parameter.sh hdfs-site dfs.namenode.http-address | cut -d ":" -f 1);
sudo -u ubuntu ssh $namenode_ip "sudo -u hdfs hdfs dfs -mkdir /spark-app-logs"
sudo -u ubuntu ssh $namenode_ip "sudo -u hdfs hdfs dfs -chmod 777 /spark-app-logs"