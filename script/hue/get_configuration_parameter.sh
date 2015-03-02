#!/bin/bash

cluster_name=$(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters" | jq '.items[0].Clusters.cluster_name');
cluster_name="${cluster_name%\"}"
cluster_name="${cluster_name#\"}"

tag_value=$(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters/"$cluster_name"?fields=Clusters/desired_configs" | jq '.Clusters.desired_configs."'$1'".tag');
tag_value="${tag_value%\"}"
tag_value="${tag_value#\"}"

property_value=$(curl -s -u admin:admin -X GET  "http://master:8080/api/v1/clusters/"$cluster_name"/configurations?type="$1"&tag="$tag_value"" | jq '.items[0].properties."'$2'"');
property_value="${property_value%\"}"
property_value="${property_value#\"}"
echo $property_value

