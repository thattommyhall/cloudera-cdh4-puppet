Install Cloudera CDH4 with puppet
=================================

Puppet modules to install hadoop, hbase, java, hive, impala, zookeeper in a production cluster.
Inital code from robbkidd's fork of my cdh3 module [here][robkidd] 
[robbkidd]: https://github.com/robbkidd/cloudera-cdh4-puppet

Prerequisites
=============

You must use [OAB][oab] to produce Java packages for install. Run OAB
according to its instructions and then place the generate files found in OAB's `deb/` directory into this
project's `modules/java/files/deb/` directory before running `vagrant up`.

[oab]: https://github.com/flexiondotorg/oab-java6

Copyright
=========

Copyright (c) 2012 Tom Hall. 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

