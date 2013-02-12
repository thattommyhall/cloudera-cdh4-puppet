class zookeeper::install {
  require hadoop::apt,java
  $data_dir          = "/var/lib/zookeeper"
  $zookeeper_hosts   =  {
    "zookeeper1" => 1,
    "zookeeper2" => 2,
    "zookeeper3" => 3
  }
  $jmxremote_port   = false
  
  file { "/etc/zookeeper/conf/zoo.cfg":
    content => template("zookeeper/zoo.cfg.erb"),
    require => Package["zookeeper-server"],
  }
  
  file { "/etc/zookeeper/conf/zookeeper-env.sh":
    content => template("zookeeper/zookeeper-env.sh.erb"),
    require => Package["zookeeper-server"],
  }
  
  $myid = $zookeeper_hosts[$hostname]

  exec { "zookeeper-server-initialize":
    command => "/usr/bin/zookeeper-server-initialize --myid=${myid}",
    unless  => "/usr/bin/test -f $zookeeper::install::data_dir/myid",
    user    => "zookeeper",
    require => [File["/etc/zookeeper/conf/zoo.cfg"],File["/etc/zookeeper/conf/zookeeper-env.sh"]]
  }

  package { "zookeeper-server": ensure => installed }
}

class zookeeper::service {
  service { "zookeeper-server":
    ensure     => running,
    require    => Package["zookeeper-server"],
    hasrestart => true,
    hasstatus  => true,
    subscribe  => Class["zookeeper::install"],
   }
}

class zookeeper::node {
  include zookeeper::install
  include zookeeper::service
}
