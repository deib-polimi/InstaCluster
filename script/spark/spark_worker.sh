#!/bin/bash

# get spark master
master=$(curl -u admin:admin  -H 'X-Requested-By: ambari' -X GET http://localhost:8080/api/v1/clusters/cumpa/services/SPARK/components/SPARK_DRIVER | jq -r ".host_components | map(select(.HostRoles.component_name = \"SPARK_DRIVER\"))[0] | .HostRoles.host_name")

#set up the driver url
echo "spark.master                     spark://"$master":7077"  | sudo tee --append /etc/spark/conf/spark-defaults.conf
