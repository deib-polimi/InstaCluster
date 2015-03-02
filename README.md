# HDP-amazon-scripts
Scripts for the Amazon image that supports Ambari and Hue

This repository contains the nessecary bash scripts and resources needed to set up Ambari/Hue-enabled cluster 
using Amazon EC2 virtual machine (VM) instantces. They are embedded in the public amazon machine image (AMI) and 
run in two phases:

1. After booting the VM - to discover and configure all the VMs of the cluster to be able to communicate 
among each other and start Ambari server and agents on the master and slaves, respectively.
2. After cluster installation - to set up Spark and Hue to work togeather with the projects from the Hadoop ecosystem 
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
  
