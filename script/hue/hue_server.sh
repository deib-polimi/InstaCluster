#!/bin/bash
#get the nameof the cluster (removing \" when necessary)
cluster_name=$(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters" | jq '.items[0].Clusters.cluster_name');
cluster_name="${cluster_name%\"}"
cluster_name="${cluster_name#\"}"
echo "Cluster name detected from Ambari:"$cluster_name

#exporting in the path the script to manipulate ambari configuration
#PATH=$PATH:/var/lib/ambari-server/resources/scripts
path=/home/ubuntu/HDP-amazon-scripts


#modifying core-site
#add the hadoop.proxyuser.hue.hosts property
$path/script/configs.sh -u admin -p admin set master $cluster_name core-site "hadoop.proxyuser.hue.hosts" "*"

#add the hadoop.proxyuser.hue.groups  property
$path/script/configs.sh -u admin -p admin set master $cluster_name core-site "hadoop.proxyuser.hue.groups" "*"

#modifying mapred-site
#add the jobtracker.thrift.address  property
$path/script/configs.sh -u admin -p admin set master $cluster_name mapred-site "jobtracker.thrift.address" "0.0.0.0:9290"
#add the mapred.jobtracker.plugins  property
$path/script/configs.sh -u admin -p admin set master $cluster_name mapred-site "mapred.jobtracker.plugins" "org.apache.hadoop.thriftfs.ThriftJobTrackerPlugin"

#modifying oozie-site
#add the oozie.service.ProxyUserService.proxyuser.hue.hosts property
$path/script/configs.sh -u admin -p admin set master $cluster_name oozie-site "oozie.service.ProxyUserService.proxyuser.hue.hosts" "*"

#add the oozie.service.ProxyUserService.proxyuser.hue.groups property
$path/script/configs.sh -u admin -p admin set master $cluster_name oozie-site "oozie.service.ProxyUserService.proxyuser.hue.groups" "*"

echo "Configuration updated, stopping services"
#restarting services to update the configuration

#stopping services
#HDFS
# curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop HDFS via REST (updating hue configuration)"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' "http://master:8080/api/v1/clusters/"$cluster_name"/services/HDFS"
# #YARN
# curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop YARN via REST (updating hue configuration)"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' "http://master:8080/api/v1/clusters/"$cluster_name"/services/YARN"
# #OOZIE
# curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop OOZIE via REST (updating hue configuration)"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' "http://master:8080/api/v1/clusters/"$cluster_name"/services/OOZIE"
# #MAPREDUCE2
# curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Stop MAPREDUCE2 via REST (updating hue configuration)"}, "Body": {"ServiceInfo": {"state": "INSTALLED"}}}' "http://master:8080/api/v1/clusters/"$cluster_name"/services/MAPREDUCE2"

# #wait until all services have been stopped
# wait=true
# while [ $wait = true ]
# do
#         #wait for 30 seconds
#                 echo "waiting 30 seconds more..."
#         sleep 30
#         wait=false

#         #check if all requests have been completed
#         for request in $(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters/"$cluster_name"/requests"| jq '.items[] |.Requests.id')
#         do
#                 status=$(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters/"$cluster_name"/requests/"$request | jq '.Requests.request_status');
#                 status="${status%\"}"
#                 status="${status#\"}"
#                 if [ $status != COMPLETED ]
#                  then
#                   wait=true
#                 fi
#         done
# done

# echo "restarting.."

# #HDFS
# curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start HDFS via REST (updating hue configuration)"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' "http://master:8080/api/v1/clusters/"$cluster_name"/services/HDFS"
# #YARN
# curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start YARN via REST (updating hue configuration)"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' "http://master:8080/api/v1/clusters/"$cluster_name"/services/YARN"
# #OOZIE
# curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start OOZIE via REST (updating hue configuration)"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' "http://master:8080/api/v1/clusters/"$cluster_name"/services/OOZIE"
# #MAPREDUCE2
# curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"RequestInfo": {"context" :"Start MAPREDUCE2 via REST (updating hue configuration)"}, "Body": {"ServiceInfo": {"state": "STARTED"}}}' "http://master:8080/api/v1/clusters/"$cluster_name"/services/MAPREDUCE2"

# #wait until all services have been started
# wait=true
# while [ $wait = true ]
# do
#         #wait for 30 seconds
#                 echo "waiting 30 seconds more..."
#         sleep 30
#         wait=false

#         #check if all requests have been completed
#         for request in $(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters/"$cluster_name"/requests"| jq '.items[] |.Requests.id')
#         do
#                 status=$(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters/"$cluster_name"/requests/"$request | jq '.Requests.request_status');
#                 status="${status%\"}"
#                 status="${status#\"}"
#                 if [ $status != COMPLETED ]
#                  then
#                   wait=true
#                 fi
#         done
# done

echo "Ambari configuration prepared for hue"
echo "Configuring hue"

sh hue_server_conf.sh

