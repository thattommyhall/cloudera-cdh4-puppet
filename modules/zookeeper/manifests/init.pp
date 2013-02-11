class cdh4::zookeeper::config(
	$data_dir          = "/var/lib/zookeeper",
	$zookeeper_hosts   = undef,
	$jmxremote_port   = 9998)
{
	file { "/etc/zookeeper/conf/zoo.cfg":
		content => template("cdh4/zookeeper/zoo.cfg.erb"),
		require => Package["zookeeper-server"],
	}

	# If jmxremote_port is false, zookeeper-env.sh
	# won't have any content.  Might as well not render it.
	file { "/etc/zookeeper/conf/zookeeper-env.sh":
		content => template("cdh4/zookeeper/zookeeper-env.sh.erb"),
		require => Package["zookeeper-server"],
		ensure  => $jmxremote_port ? {
			false   => "absent",
			default => "present"
		}
	}
}

class cdh4::zookeeper::install {
  package { "zookeeper-server": ensure => installed }
}
