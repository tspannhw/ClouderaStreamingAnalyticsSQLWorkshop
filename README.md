# ClouderaStreamingAnalyticsSQLWorkshop

Apache Flink SQL 1.10 / CSA / Cloudera on YARN

**Apache Flink SQL Lab Setup - HDFS Preparation**

```
HADOOP_USER_NAME=hdfs hdfs dfs -mkdir /user/admin
HADOOP_USER_NAME=hdfs hdfs dfs -mkdir /user/root
HADOOP_USER_NAME=hdfs hdfs dfs -chown root:root /user/root
HADOOP_USER_NAME=hdfs hdfs dfs -chown admin:admin /user/admin
HADOOP_USER_NAME=hdfs hdfs dfs -chmod -R 777 /user
```

**Build a Flink YARN Session**

```
flink-yarn-session -tm 2048 -s 2 -d
```

**Then run your sql client**

```
flink-sql-client embedded -e sql-env.yaml
```

**Build a table**

```
CREATE TABLE sensors (
     sensor_id INT, sensor_ts DOUBLE, sensor_0 DOUBLE,sensor_1 DOUBLE,sensor_3 DOUBLE, sensor_4 DOUBLE, sensor_5 DOUBLE, sensor_6 DOUBLE, sensor_7 DOUBLE, sensor_8 DOUBLE, sensor_9 DOUBLE, sensor_10 DOUBLE, sensor_11 DOUBLE
) WITH (
    'connector.type'         = 'kafka',
    'connector.version'      = 'universal',
    'connector.topic'        = 'iot',
    'connector.startup-mode' = 'earliest-offset',
    'connector.properties.bootstrap.servers' = 'edge2ai-1.dim.local:9092',
    'format.type' = 'json'
);
```

**Show the table**

```
SHOW tables;
```

**Start our query.**

```
SELECT * FROM sensors;
```

**Flink SQL**

image::images/cfmreferencearch.png\[width=800\]

**References**

*   [https://towardsdatascience.com/event-driven-supply-chain-for-crisis-with-flinksql-be80cb3ad4f9](https://towardsdatascience.com/event-driven-supply-chain-for-crisis-with-flinksql-be80cb3ad4f9)
*   [https://docs.cloudera.com/csa/1.1.0/overview/topics/csa-overview.html](https://docs.cloudera.com/csa/1.1.0/overview/topics/csa-overview.html)
*   [https://ci.apache.org/projects/flink/flink-docs-stable/dev/table/catalogs.html](https://ci.apache.org/projects/flink/flink-docs-stable/dev/table/catalogs.html)
*   [https://ci.apache.org/projects/flink/flink-docs-stable/dev/table/sqlClient.html](https://ci.apache.org/projects/flink/flink-docs-stable/dev/table/sqlClient.html)
*   https://github.com/tspannhw/meetup-sensors
*   https://github.com/tspannhw/FlinkSQLDemo/
