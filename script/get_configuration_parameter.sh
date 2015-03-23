#!/bin/bash

cluster_name=$(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters" | jq -r '.items[0].Clusters.cluster_name');

tag_value=$(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters/"$cluster_name"?fields=Clusters/desired_configs" | jq -r '.Clusters.desired_configs."'$1'".tag');

property_value=$(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters/"$cluster_name"/configurations?type="$1"&tag="$tag_value"" | jq -r '.items[0].properties."'$2'"');

echo $property_value

