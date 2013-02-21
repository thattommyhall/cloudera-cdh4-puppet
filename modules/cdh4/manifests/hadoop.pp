class cdh4::hadoop::datanode {
  Class["cdh4::hadoop::base"] -> Class["cdh4::hadoop::datanode"]
  package { "hadoop-hdfs-datanode":
    ensure => "latest",
  }
  service { "hadoop-hdfs-datanode":
    ensure => "running",
    require => Package["hadoop-hdfs-datanode"],
  }
}

class cdh4::hadoop::tasktracker {
  Class["cdh4::hadoop::base"] -> Class["cdh4::hadoop::tasktracker"]
  package { "hadoop-0.20-mapreduce-tasktracker":
    ensure => "latest",
  }
  service { "hadoop-0.20-mapreduce-tasktracker":
    ensure => "running",
    require => Package["hadoop-0.20-mapreduce-tasktracker"],
  }
}

class cdh4::hadoop::secondary_namenode {
  Class["cdh4::hadoop::base"] -> Class["cdh4::hadoop::secondary_namenode"]
  package { "hadoop-hdfs-secondarynamenode":
    ensure => "latest",
    require => Package["hadoop"],
  }
  service { "hadoop-hdfs-secondarynamenode":
    ensure => "running",
    require => Service["hadoop-hdfs-namenode"],
  }
}

class cdh4::hadoop::namenode {
  Class["cdh4::hadoop::base"] -> Class["cdh4::hadoop::namenode"]
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

class cdh4::hadoop::jobtracker {
  Class["cdh4::hadoop::base"] -> Class["cdh4::hadoop::jobtracker"]
  package { "hadoop-0.20-mapreduce-jobtracker":
    ensure => "latest",
  }
  service { "hadoop-0.20-mapreduce-jobtracker":
    ensure => "running",
    require => Package["hadoop-0.20-mapreduce-jobtracker"],
  }
}

class cdh4::hadoop::base(
  $config_dir = "/etc/hadoop/conf.current",
  $hdfs_settings,
  $mapred_settings,
  $core_settings,
  ) {
  Class["cdh4::hadoop::apt"] -> Class["cdh4::hadoop::base"]
  File {
    owner => root,
    group => root,
    mode  => 755,
  }
  package { "hadoop":
    ensure => latest,
  }
  file { $config_dir:
    ensure  => directory,
    source  => 'puppet:///modules/cdh4/hadoop/etc/hadoop/conf/',
    recurse => true,
    require => Package["hadoop"],
  }
  file { "hdfs-site":
    path    => "${config_dir}/hdfs-site.xml",
    ensure  => file,
    content => template("cdh4/hadoop/hdfs-site.xml.erb"),
  }
  file { "mapred-site":
    path    => "${config_dir}/mapred-site.xml",
    ensure  => file,
    content => template("cdh4/hadoop/mapred-site.xml.erb"),
  }
  file { "core-site":
    path    => "${config_dir}/core-site.xml",
    ensure  => file,
    content => template("cdh4/hadoop/core-site.xml.erb"),
  }
  # file { "/etc/sysctl.d/60-reboot":
  #   ensure  => file,
  #   content => "kernel.panic = 10",
  # }
  exec { "update_hadoop_alternative_conf":
    command => "/usr/sbin/update-alternatives --install /etc/hadoop/conf hadoop-conf ${config_dir} 99",
    require => File[$config_dir],
    unless => "/usr/sbin/update-alternatives --display hadoop-conf | /bin/grep currently | /bin/grep ${config_dir}"
  }
}

class cdh4::hadoop::apt(
  # see http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh/dists/
  # for what versions exist, defaults to 4 (which will have packages in that change version so ensure => latest may cause issues elsewhere)
  $version = '4'
  ) {
  $operatingsystem_lowercase = inline_template("<%= operatingsystem.downcase %>")
  
	file { "/etc/apt/sources.list.d/cloudera.list":
		content => "
deb [arch=${architecture}] http://archive.cloudera.com/cdh4/${operatingsystem_lowercase}/${lsbdistcodename}/${architecture}/cdh ${lsbdistcodename}-cdh${version} contrib
deb-src http://archive.cloudera.com/cdh4/${operatingsystem_lowercase}/${lsbdistcodename}/${architecture}/cdh ${lsbdistcodename}-cdh${version} contrib
",
		mode    => 0444,
		ensure  => 'present',
	}

	exec { "import_cloudera_apt_key":
		command   => "/usr/bin/curl -s http://archive.cloudera.com/cdh4/${operatingsystem_lowercase}/${lsbdistcodename}/${architecture}/cdh/archive.key | /usr/bin/apt-key add -",
		subscribe => File["/etc/apt/sources.list.d/cloudera.list"],
		unless    => "/usr/bin/apt-key list | /bin/grep -q Cloudera",
    require => Package["curl"],
	}
  
	exec { "apt_get_update_for_cloudera":
		command => "/usr/bin/apt-get update",
		timeout => 240,
		returns => [ 0, 100 ],
		refreshonly => true,
		subscribe => [File["/etc/apt/sources.list.d/cloudera.list"], Exec["import_cloudera_apt_key"]],
  } 
}
