import sys
from resource_management import *
import subprocess

class Slave(Script):
  def install(self, env):
    subprocess.call("/home/ubuntu/HDP-amazon-scripts/script/spark/spark_worker.sh", shell=True)
  def stop(self, env):
    subprocess.call("/home/ubuntu/HDP-amazon-scripts/script/spark/spark_worker_stop.sh", shell=True)
  def start(self, env):
    subprocess.call("/home/ubuntu/HDP-amazon-scripts/script/spark/spark_worker_start.sh", shell=True)
    
  def status(self, env):
    print 'Status of the Sample Srv Slave';
  def configure(self, env):
    print 'Configure the Sample Srv Slave';
if __name__ == "__main__":
  Slave().execute()
