Facter.add("hadoop_hdfs_data_dirs") do
  setcode { Dir.glob('/data*/hdfs/data/').join(',') }
end

Facter.add("hadoop_mapred_local_dirs") do
  setcode { Dir.glob('/data*/mapred/local/').join(',') }
end

mapper_ratio = 0.8
oversubscription = 0.2
total_slots = (Facter.processorcount.to_i * (1+oversubscription)).ceil

Facter.add("mapred_tasktracker_reduce_tasks_maximum") do
  setcode { (total_slots * (1-mapper_ratio)).ceil }
end

Facter.add("mapred_tasktracker_map_tasks_maximum") do
  setcode { (total_slots * mapper_ratio).ceil }
end
