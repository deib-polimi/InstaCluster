echo "Configuring hue"

path=/home/ubuntu/HDP-amazon-scripts

#copy the template over the current configuration file
hue_conf=/etc/hue/conf/hue.ini
sudo cp $path/resources/hue.ini.template $hue_conf

#set the address of the web server
webserver_ip=$(wget -qO- http://instance-data/latest/meta-data/local-ipv4)
webserver_port=8808
#echo $webserver_ip
sudo sed -i "s/WEB_SERVER_IP/$webserver_ip/g" $hue_conf
sudo sed -i "s/WEB_SERVER_PORT/$webserver_port/g" $hue_conf

#set the address of the namenode 
namenode_ip=$(sh $path/script/get_configuration_parameter.sh hdfs-site dfs.namenode.http-address | cut -d ":" -f 1);
#echo $namenode_ip
sudo sed -i "s/NAME_NODE_IP/$namenode_ip/g" $hue_conf

#set the address of the resource manager server
resource_manager_ip=$(sh $path/script/get_configuration_parameter.sh yarn-site yarn.resourcemanager.address | cut -d ":" -f 1);
#echo $resource_manager_ip
sudo sed -i "s/RESOURCE_MANAGER_IP/$resource_manager_ip/g" $hue_conf

#set the address of the history server
history_server_ip=$(sh $path/script/get_configuration_parameter.sh yarn-site yarn.log.server.url | cut -d ":" -f 2 | cut -d "/" -f 3 );
#echo $history_server_ip
sudo sed -i "s/HISTORY_SERVER_IP/$history_server_ip/g" $hue_conf

#set the address of oozie server
oozie_ip=$(sh $path/script/get_configuration_parameter.sh oozie-site oozie.base.url | cut -d ":" -f 2 | cut -d "/" -f 3 );
#echo $oozie_ip
sudo sed -i "s/OOZIE_IP/$oozie_ip/g" $hue_conf

#set the address of hive server
hive_server_ip=$(sh $path/script/get_configuration_parameter.sh hive-site hive.metastore.uris | cut -d ":" -f 2 | cut -d "/" -f 3 );
#echo $hive_server_ip
sudo sed -i "s/HIVE_SERVER_IP/$hive_server_ip/g" $hue_conf

#set the address of hbase server
hbase_ip=$(sh $path/script/get_configuration_parameter.sh hbase-site hbase.rootdir | cut -d ":" -f 2 | cut -d "/" -f 3 );
#echo $hbase_ip
sudo sed -i "s/HBASE_MASTER_IP/$hbase_ip/g" $hue_conf

#set the address of the zookeeper ensamble
zookeeper_ensable=$(sh $path/script/get_configuration_parameter.sh hive-site hive.zookeeper.quorum);
#echo $zookeeper_ensable
sudo sed -i "s/ZOOKEEPER_ENSABLE/$zookeeper_ensable/g" $hue_conf

#set the address of the zookeeper ensamble
spark_job_server=$(sh $path/script/get_componen_host.sh SPARK SPARK_DRIVER);
#echo $spark_job_server
sudo sed -i "s/SPARK_JOB_SERVER/$spark_job_server/g" $hue_conf


sudo service hue restart
