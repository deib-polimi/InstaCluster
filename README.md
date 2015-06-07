# HDP-amazon-scripts
Scripts for the Amazon image that supports Ambari and Hue

This repository contains the nessecary bash scripts and resources needed to set up Ambari/Hue-enabled cluster 
using Amazon EC2 virtual machine (VM) instantces.
An AMI with pre-installed scripts is available in the us-west-1 region with id: ami-e99171ad
They are embedded in the public amazon machine image (AMI) and 
run in two phases:

1. After booting the VM - to discover and configure all the VMs of the cluster to be able to communicate 
among each other and start Ambari server and agents on the master and slaves, respectively.
2. After cluster installation - to set up Spark (standalone) and Hue to work togeather with the projects from the Hadoop ecosystem 
installed by Ambari.

## Structure of the repository

HDP-amazon-scripts/

  scripts/
  
    - install_prerequisite.bsh	-  Assumes that the base Ubuntu 12.04 image is running and installs some general 
    prerequisits (Ansible, Java8, htop, lynx, unzip, aws CLI 1.7.3.0, git)
  
    - installScripts.bsh  -  Prepares the image with installed prerequisits to be exported as Ambari/Hue-enabled AMI; 
    it sets up the necessary enviroment variables and copies the files from the resources folder to the appropriate 
    directories in the image 
    
    - rc.local  -  When the AMI is instantiated this script is called at startup. It, in turn, calls setup.bsh script 
    and logs the output in /home/ubuntu/setup.log
    
    - setup.bsh  -  distinguishes between the two roles the VM may assume: master and slave. Based on the role it 
    calls either slave_setup.bsh or master_setup.bsh	
    
    - slave_setup.bsh 	-  it creates a temporary user used to communicate with the master and establish passwordless 
    ssh. Then it installs the ambari-agent
    
    - master_setup.bsh - discovers the slaves using the aws CLI (access and secret keys); creates the appropriate hosts
    file (naming convention: master and slave[0-9]+) and sends it to the slaves; removes tmpuser from the slaves via 
    update_key.bsh establishes passwordless ssh by distributing the keys to the slaves; assigns slaves correct hostnames 
    using fixhostname.bsh; sets up ansible; installs ambari server and starts it.

    - update_key.bsh - removes tmpuser from the VM
    
    - fixhostname.bsh	 -  changes the hostname of the VM
    
    - hue/	 -  

    - spark.bsh  -  

    - hostnameEcho.bsh
  
  resources/
  
  sampleParameterFile.txt - sample file to gives as user provided data when lanching an AMI in order to specify the needed parameters.
  
## Installation of the Scripts
To build a new image from scratch we suggest to start from the official ubuntu 12.04 cloud image (the latest version supported by Ambari) with ami: ami-09ad494d but any other Ubuntu 12.04 image is fine. 
Clone the repo in the machine and run 
```
bash installScripts.bsh
```

To install the prerequitite run 
```
bash install_prerequisite.bsh
```

Create an image from the running instance and use is as base for the cluster.

## Cluster Installation
To install the cluster spawn a number of replicas of the previously created machine (a preconfigured one will come soon)
giving as user provided data your AWS_ACCES_KEY_ID only (follow the syntax in sampleParameterFiles.txt).

When machines have been started spawn another replica adding as user data a file with the same format of sampleParameterFiles.txt with the keys to access the aws cli tool. 

## Parameters needed for cluster installation

- AWS_ACCESS_KEY_ID  - your aws access key needed to query aws about runnign instances and discover slaves
- AWS_SECRET_ACCESS_KEY - your aws secret key needed to query aws about runnign instances and discover slaves
- AWS_DEFAULT_REGION - the region in which to look for slaves
- REVOKE_KEYS - wether to revoke the key after the slave discovery (useful for many security reasons)
