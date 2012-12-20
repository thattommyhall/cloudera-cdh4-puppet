class java {
  File["/etc/apt/sources.list.d/oab.list"] ~> Exec['get gpg key'] ~> Exec['refresh-apt'] 
  File["/root/java-accept-lic"] ~> Exec["accept-java-lic"] ~> Exec['refresh-apt'] -> Package["sun-java6-jdk"] 
  
  File { 
    owner => "root", 
    group => "root",
    mode => 0440,
  }
  
  file { "/etc/apt/sources.list.d/oab.list":
    source => "puppet:///modules/java/etc/apt/sources.list.d/oab.list", 
  }
  
  exec { "get gpg key":
    command => "/usr/bin/apt-key add /tmp/vagrant-puppet/modules-0/java/files/deb/pubkey.asc",
    refreshonly => true,
  }    
  
  exec { "refresh-apt":
    command => "/usr/bin/apt-get update",
    refreshonly => true,
  }
  
  file { "/root/java-accept-lic":
    source => "puppet:///modules/java/root/java-accept-lic", 
  }
  
  exec { "accept-java-lic":
    command => "/usr/bin/debconf-set-selections /root/java-accept-lic",
    refreshonly => true,
  }
  
  package { "sun-java6-jdk":
    ensure  => "present",
  }
}
