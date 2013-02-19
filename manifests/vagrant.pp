class vagrant::hadoop::apt {
  class { "cdh4::hadoop::apt":
    version => '4.1.4',
  }
}

class vagrant::hadoop::package {

}
