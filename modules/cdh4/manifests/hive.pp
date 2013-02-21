class cdh4::hive::server {
  Class["cdh4::hive::base"] -> Class["cdh4::hive::server"]
  package { "hive-server": }
}

class cdh4::hive::server2 {
  Class["cdh4::hive::base"] -> Class["cdh4::hive::server2"]
  package { "hive-server2": }
}

class cdh4::hive::base(
  $hive_settings = {},
  $config_dir = "/etc/hive/conf.current"
  ){
  $hive_defaults = {
    'javax.jdo.option.ConnectionURL' => 'jdbc:derby:;databaseName=/var/lib/hive/metastore/metastore_db;create=true',
    'javax.jdo.option.ConnectionDriverName' => 'org.apache.derby.jdbc.EmbeddedDriver',
  }
  Class["cdh4::hadoop::apt"] -> Class["cdh4::hive::base"]
  package { ["libmysql-java","hive"]: }
  file { $config_dir:
    ensure  => directory,
    source  => 'puppet:///modules/cdh4/hive/etc/hive/conf/',
    recurse => true,
    require => Package["hive"],
  }
  file { "hive-site":
    path    => "${config_dir}/hive-site.xml",
    ensure  => file,
    content => template("cdh4/hive/hive-site.xml.erb"),
  }
  file { "hive-default":
    path    => "${config_dir}/hive-default.xml",
    ensure  => file,
    content => template("cdh4/hive/hive-default.xml.erb"),
  }
  exec { "update_hadoop_alternative_conf":
    command => "/usr/sbin/update-alternatives --install /etc/hive/conf hive-conf ${config_dir} 99",
    require => File[$config_dir],
    unless => "/usr/sbin/update-alternatives --display hive-conf | /bin/grep currently | /bin/grep ${config_dir}"
  }
}
