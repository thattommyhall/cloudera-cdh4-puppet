#!/bin/bash
mkdir -p /etc/puppet/
echo '[main]' > /etc/puppet/puppet.conf
echo 'pluginsync = true' >> /etc/puppet/puppet.conf
echo '127.0.0.1 localhost' > /etc/hosts
echo '33.33.66.1 puppet' >> /etc/hosts
echo '33.33.66.100 master.vagrant' >> /etc/hosts
echo '33.33.66.101 slave1.vagrant' >> /etc/hosts
echo '33.33.66.102 slave2.vagrant' >> /etc/hosts
echo '33.33.66.103 slave3.vagrant' >> /etc/hosts
echo '33.33.66.111 zookeeper1.vagrant' >> /etc/hosts
echo '33.33.66.112 zookeeper2.vagrant' >> /etc/hosts
echo '33.33.66.113 zookeeper3.vagrant' >> /etc/hosts
echo '33.33.66.120 hive.vagrant' >> /etc/hosts
mkdir -p /tmp/hadoop-name-dir
# chown hdfs:hdfs /tmp/hadoop-name-dir
mkdir -p /tmp/hadoop-data-dir
# chown hdfs:hdfs /tmp/hadoop-data-dir
mkdir -p /tmp/hadoop-mapred-dir
# chown mapred:maprep /tmp/hadoop-mapred-dir
