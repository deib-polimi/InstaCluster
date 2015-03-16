#!/bin/bash
cluster_name=$(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters" | jq -r '.items[0].Clusters.cluster_name');

# get spark master
master=$(curl -u admin:admin  -H 'X-Requested-By: ambari' -X GET http://master:8080/api/v1/clusters/$cluster_name/services/SPARK/components/SPARK_DRIVER | jq -r ".host_components | map(select(.HostRoles.component_name = \"SPARK_DRIVER\"))[0] | .HostRoles.host_name")


#start the slave
$SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker spark://$master:7077

