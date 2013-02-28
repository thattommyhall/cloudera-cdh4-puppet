node default {
  package { ["curl","screen"]:
    ensure => "latest",
  }
}

node /slave\d+/ inherits default {
  require java
  include vagrant::hadoop::base
  include cdh4::hadoop::datanode
  include cdh4::hadoop::tasktracker
  # include hbase::regionserver
}

node master inherits default {
  require java
  include vagrant::hadoop::base
  include cdh4::hadoop::namenode
  include cdh4::hadoop::jobtracker
  # include hbase::master
}

node hiveserver inherits default {
  require java
  include vagrant::hadoop::apt
  class { 'cdh4::hive::base': }
  class { 'cdh4::hive::server': }
  class { 'cdh4::hive::server_service': }
}

node /zookeeper\d+/ inherits default {
  require java
  include vagrant::hadoop::apt
  class { "cdh4::zookeeper::server":
    zookeeper_hosts => {
      "zookeeper1.vagrant" => 1,
      "zookeeper2.vagrant" => 2,
      "zookeeper3.vagrant" => 3,
    }
  }
}

