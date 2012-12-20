node /slave\d+/ {
  include hadoop::datanode
  include hadoop::tasktracker
}

node master {
  include hadoop::namenode
  include hadoop::jobtracker
}
