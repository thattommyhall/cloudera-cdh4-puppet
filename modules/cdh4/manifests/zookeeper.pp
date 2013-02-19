class cdh4::zookeeper::server(
  $zookeeper_hosts,
  $data_dir = "/var/lib/zookeeper",
  )  {

  Class["cdh4::hadoop::apt"] -> Class["cdh4::zookeeper::server"]
  
  $jmxremote_port   = false
    
  file { "/etc/zookeeper/conf/zoo.cfg":
    content => template("cdh4/zookeeper/zoo.cfg.erb"),
    require => Package["zookeeper-server"],
    notify => Service["zookeeper-server"],
  }
  
  file { "/etc/zookeeper/conf/zookeeper-env.sh":
    content => template("cdh4/zookeeper/zookeeper-env.sh.erb"),
    require => Package["zookeeper-server"],
    notify => Service["zookeeper-server"],
  }
  
  $myid = $zookeeper_hosts[$fqdn]

  exec { "zookeeper-server-initialize":
    command => "/usr/bin/zookeeper-server-initialize --myid=${myid}",
    unless  => "/usr/bin/test -f $cdh4::zookeeper::server::data_dir/myid",
    user    => "zookeeper",
    require => [File["/etc/zookeeper/conf/zoo.cfg"],File["/etc/zookeeper/conf/zookeeper-env.sh"]]
  }

  package { "zookeeper-server":
    ensure => latest
  }
  
  service { "zookeeper-server":
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
   }
}
