class vagrant::hadoop::apt {
  class { "cdh4::hadoop::apt":
    version => '4.1.0',
  }
}

class vagrant::hadoop::base {
  include vagrant::hadoop::apt
  $master = 'master.vagrant'
  class { "cdh4::hadoop::base":
    core_settings => {
      'fs.default.name' => 'hdfs://master.vagrant:9000',
    },
    hdfs_settings => {
      'dfs.name.dir' => '/var/hadoop/dfs/name',
      'dfs.data.dir' => '/tmp/hadoop-data-dir',
    },
    mapred_settings => {
      'mapred.local.dir' => '/tmp/hadoop-mapred-dir',
      'mapred.job.tracker' => 'master.vagrant',
      'mapred.tasktracker.map.tasks.maximum' => $processorcount,
      'mapred.tasktracker.reduce.tasks.maximum' => $physicalprocessorcount,
    }
  }
}
