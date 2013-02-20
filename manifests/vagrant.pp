class vagrant::hadoop::apt {
  class { "cdh4::hadoop::apt":
    version => '4.1.0',
  }
}

class vagrant::hadoop::base {
  include vagrant::hadoop::apt
  include cdh4::hadoop::base
}
