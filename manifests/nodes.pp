node /slave\d+/ {
  include hadoop::datanode
  include hadoop::tasktracker
  include hbase::regionserver
}

node master {
  include hadoop::namenode
  include hadoop::jobtracker
  include hbase::master
}

node hiveserver {
  include hive::server
}

node /zookeeper\d+/ {
  include zookeeper::node
}
