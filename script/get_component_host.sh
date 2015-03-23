#!/bin/bash

cluster_name=$(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters" | jq -r '.items[0].Clusters.cluster_name');

host=$(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters/"$cluster_name"/services/$1/components/$2" | jq -r '.host_components[].HostRoles.host_name');

echo $host

