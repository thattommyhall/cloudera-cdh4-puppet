#!/bin/bash
mkdir -p /etc/puppet/
echo '[main]' > /etc/puppet/puppet.conf
echo 'pluginsync = true' >> /etc/puppet/puppet.conf
echo '127.0.0.1 localhost' > /etc/hosts
echo '33.33.66.1 puppet' >> /etc/hosts
echo '33.33.66.100 master' >> /etc/hosts
echo '33.33.66.101 slave1' >> /etc/hosts
echo '33.33.66.102 slave2' >> /etc/hosts
echo '33.33.66.103 slave3' >> /etc/hosts

mkdir -p /data0/mapred/local
mkdir -p /data0/hdfs/data/
