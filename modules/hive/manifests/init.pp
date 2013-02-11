class hive::server {
  require hive::common
  package { "hive-server": }
}

class hive::server2 {
  require hive::common
  package { "hive-server2": }
}

class hive::mysql-connector {
  package { "libmysql-java": }
}

class hive::common {
  require hadoop::base
  require hive::mysql-connector
}
