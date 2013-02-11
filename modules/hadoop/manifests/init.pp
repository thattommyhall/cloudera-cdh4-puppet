#The only dependency outside the hadoop module is java in hadoop::package
class hadoop::datanode {
  require hadoop::base
  package { "hadoop-hdfs-datanode":
    ensure => "latest",
  }
  service { "hadoop-hdfs-datanode":
    ensure => "running",
    require => Package["hadoop-hdfs-datanode"],
  }
}

class hadoop::tasktracker {
  require hadoop::base
  package { "hadoop-0.20-mapreduce-tasktracker":
    ensure => "latest",
  }
  service { "hadoop-0.20-mapreduce-tasktracker":
    ensure => "running",
    require => Package["hadoop-0.20-mapreduce-tasktracker"],
  }
}

class hadoop::secondary_namenode {
  require hadoop::base
  package { "hadoop-hdfs-secondarynamenode":
    ensure => "latest",
    require => Package["hadoop"],
  }
  service { "hadoop-hdfs-secondarynamenode":
    ensure => "running",
    require => Service["hadoop-hdfs-namenode"],
  }
}

class hadoop::namenode {
  require hadoop::base
  package { "hadoop-hdfs-namenode":
    ensure => "latest",
    require => Package["hadoop"],
  }
  file { ["/var/hadoop","/var/hadoop/dfs", "/var/hadoop/dfs/name"]:
    ensure => directory,
    owner  => 'hdfs'
  }
  service { "hadoop-hdfs-namenode":
    ensure => "running",
  }
}

class hadoop::jobtracker {
  require hadoop::base
  package { "hadoop-0.20-mapreduce-jobtracker":
    ensure => "latest",
  }
  service { "hadoop-0.20-mapreduce-jobtracker":
    ensure => "running",
    require => Package["hadoop-0.20-mapreduce-jobtracker"],
  }
}

class hadoop::base {
  require hadoop::package
  File {
    owner => root,
    group => root,
    mode  => 755,
  }
  file { "/etc/hosts":
    source => "puppet:///modules/hadoop/etc/hosts",
    ensure => "file",
    mode => "0744",
  }
  file { "/etc/hadoop/conf.cluster/":
    ensure  => directory,
    source  => 'puppet:///modules/hadoop/etc/hadoop/conf.cluster/',
    recurse => true,
  }
  file { "hdfs-site":
    path    => "/etc/hadoop/conf.cluster/hdfs-site.xml",
    ensure  => file,
    content => template("hadoop/hdfs-site.xml.erb"),
  }
  file { "mapred-site":
    path    => "/etc/hadoop/conf.cluster/mapred-site.xml",
    ensure  => file,
    content => template("hadoop/mapred-site.xml.erb"),
  }
  file { "/etc/sysctl.d/60-reboot":
    ensure  => file,
    content => "kernel.panic = 10",
  }
  exec { "update_hadoop_alternative_conf":
    command => "/usr/sbin/update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.cluster 99",
    require => File["/etc/hadoop/conf.cluster"],
  }
}

class hadoop::package {
  require hadoop::apt,java
  package { "hadoop":
    ensure => "latest",
  }
}

class hadoop::apt {
  Package['curl'] -> Exec["add_cloudera_repokey"]
  File["/etc/apt/sources.list.d/cloudera.list"] ~> Exec["add_cloudera_repokey"]  ~> Exec["apt-get update"]

  package { "curl":
    ensure => "latest",
  }

  file { "/etc/apt/sources.list.d/cloudera.list":
    owner  => "root",
    group  => "root",
    mode   => 0440,
    source => "puppet:///modules/hadoop/etc/apt/sources.list.d/cloudera.list",
  }

  exec { "add_cloudera_repokey":
    command     => "/usr/bin/curl -s http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh/archive.key | sudo apt-key add -",
    refreshonly => true
  }

  exec { "apt-get update":
    command     => "/usr/bin/apt-get -q -q update",
    logoutput   => false,
    refreshonly => true,
  }
}


