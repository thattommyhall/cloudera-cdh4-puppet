Install Cloudera CDH4 with puppet
=================================

Puppet modules to install hadoop, hbase and java.

This project is based on a fork of thattommyhall/cloudera-cdh3-puppet. My intention was more to have
a little, disposable CDH4 cluster to experiment with than to test puppet installation of CDH, but
these modules might be reusable for a bigger install. 

Prerequisites
=============

You must use [OAB][oab] to produce Java packages for install. Run OAB
according to its instructions and then place the generate files found in OAB's `deb/` directory into this
project's `modules/java/files/deb/` directory before running `vagrant up`.

[oab]: https://github.com/flexiondotorg/oab-java6

