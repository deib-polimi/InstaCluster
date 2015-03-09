# get spark master

getHost(name){

return $(curl -u admin:admin  -H 'X-Requested-By: ambari' -X GET http://localhost:8080/api/v1/clusters/cumpa/services/SPARK/components/$name | jq -r ".host_components | map(select(.HostRoles.component_name = \"$name\"))[0] | .HostRoles.component_name")

}

master=getHost("SPARK_DRIVER")

#set up the driver url
echo "spark.master                     spark://"$master":7077"  | sudo tee --append /etc/spark/conf/spark-defaults.conf
