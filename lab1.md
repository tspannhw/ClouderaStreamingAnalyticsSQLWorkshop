
Create Schema in Schema Registry named test 3

https://raw.githubusercontent.com/tspannhw/NiFItoKafkaConnect/master/test3.avsc

Add NiFi Flow to Populate Kafka Topic test 3

https://github.com/tspannhw/NiFItoKafkaConnect/blob/master/PushToKCEncoded.xml

Create HDFS Directories and Permissions for Kafka Connect and Flink SQL

HADOOP_USER_NAME=hdfs hdfs dfs -mkdir /tmp/sensors
HADOOP_USER_NAME=hdfs hdfs dfs -mkdir /user/admin
HADOOP_USER_NAME=hdfs hdfs dfs -mkdir /user/root
HADOOP_USER_NAME=hdfs hdfs dfs -chown root:root /user/root
HADOOP_USER_NAME=hdfs hdfs dfs -chown admin:admin /user/admin
HADOOP_USER_NAME=hdfs hdfs dfs -chmod -R 777 /user/admin
HADOOP_USER_NAME=hdfs hdfs dfs -chmod -R 777 /user/root
HADOOP_USER_NAME=hdfs hdfs dfs -chmod -R 777 /tmp/sensors

Build Kafka Connect Sink named test3

{
 "connector.class": "com.cloudera.dim.kafka.connect.hdfs.HdfsSinkConnector",
 "hdfs.uri": "hdfs://edge2ai-1.dim.local:8020",
 "tasks.max": "1",
 "topics": "test3",
 "value.converter.schema.registry.url": "http://edge2ai-1.dim.local:7788/api/v1",
 "value.converter.passthrough.enabled": "true",
 "hdfs.output": "/tmp/sensors/",
 "output.avro.passthrough.enabled": "true",
 "hadoop.conf.path": "file:///etc/hadoop/conf",
 "name": "test3",
 "output.writer": "com.cloudera.dim.kafka.connect.partition.writers.avro.AvroPartitionWriter",
 "value.converter": "com.cloudera.dim.kafka.connect.converts.AvroConverter",
 "output.storage": "com.cloudera.dim.kafka.connect.hdfs.HdfsPartitionStorage",
 "key.converter": "org.apache.kafka.connect.storage.StringConverter"
}


Build Flink SQL YARN Session
flink-yarn-session -tm 2048 -s 2 -d

Create sql-env.yaml for Catalogs
https://github.com/tspannhw/ClouderaStreamingAnalyticsSQLWorkshop/blob/main/sql-env2.yaml

sql-env.yaml

configuration:
  execution.target: yarn-session

catalogs:
  - name: registry
    type: cloudera-registry
    # Registry Client standard properties
    registry.properties.schema.registry.url: http://edge2ai-1.dim.local:7788/api/v1
    # registry.properties.key: 
    # Registry Client SSL properties
    # Kafka Connector properties
    connector.properties.bootstrap.servers: edge2ai-1.dim.local:9092
    connector.startup-mode: earliest-offset
  - name: kudu
    type: kudu
    kudu.masters: edge2ai-1.dim.local:7051

Run Flink SQK Client
flink-sql-client embedded -e sql-env.yaml

show catalogs;

use catalog registry;

show tables;

help;

describe test3;

select * from test3;


For more information:

Use Catalog in Flink SQL
See:   https://docs.cloudera.com/csa/1.2.0/flink-sql-table-api/topics/csa-schemaregistry-catalog.html

https://github.com/tspannhw/NiFItoKafkaConnect
https://github.com/tspannhw/meetup-sensors
https://www.datainmotion.dev/2020/05/flank-low-code-streaming-populating.html
