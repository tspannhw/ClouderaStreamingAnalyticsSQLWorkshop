# ClouderaStreamingAnalyticsSQLWorkshop

**Lab 1**

Welcome to the initial lab for utilizing Apache Flink SQL 1.10 / CSA / Cloudera on YARN.

First we will need to make sure that the Apache Flink user you will be running under has access to HDFS. HDFS will be used to hold logs and important run time data. You can also output data to HDFS as needed. You can run HDFS commands or change via the Hue interface.

**Apache Flink SQL Lab Setup - HDFS Preparation**

```
HADOOP_USER_NAME=hdfs hdfs dfs -mkdir /user/admin
HADOOP_USER_NAME=hdfs hdfs dfs -mkdir /user/root
HADOOP_USER_NAME=hdfs hdfs dfs -chown root:root /user/root
HADOOP_USER_NAME=hdfs hdfs dfs -chown admin:admin /user/admin
HADOOP_USER_NAME=hdfs hdfs dfs -chmod -R 777 /user
```

You will need to login to the Flink server via SSH or via the webSSH.

**Build a Flink YARN Session**

```
flink-yarn-session -tm 2048 -s 2 -d
```

**Then run your sql client**

```
flink-sql-client embedded -e sql-env.yaml
```

**Build a table**

![](https://user-images.githubusercontent.com/18673814/86636756-ae69d500-bfa2-11ea-96c5-65bfe9277eb3.png)

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

**Using the Flink Dashboard UI**

We will navigate to the Flink UI to examine our running Flink SQL job.

![](https://user-images.githubusercontent.com/18673814/86636997-f1c44380-bfa2-11ea-9baa-4e67dd68e2f2.png)

**Flink SQL**

Now that we have run our query for a while and have seen new Kafka events added to our query real-time. Let's kill this query with CTRL-C.

**Lab 2**

Now we will create another table on another Kafka topic.

```
CREATE TABLE devices (
     sensor_id INT, sensor_ts DOUBLE, host STRING, systemtime STRING, cpu STRING, diskusage STRING, memory DOUBLE, uuid STRING, deviceid STRING

) WITH (
    'connector.type'         = 'kafka',
    'connector.version'      = 'universal',
    'connector.topic'        = 'devices',
    'connector.startup-mode' = 'earliest-offset',
    'connector.properties.bootstrap.servers' = 'edge2ai-1.dim.local:9092',
    'format.type' = 'json'
);
```

Now that we have made a table on our **iot** sensors Kafka topic, we will add one for destination data.

```
INSERT INTO global_sensor_events 
SELECT 
    devices.uuid, 
    devices.systemtime,  
    sensor_0,
    sensor_1,
    sensor_2,
    sensor_3,
    sensor_4,
    sensor_5,
    sensor_6,
    sensor_7,
    sensor_8,
    sensor_9,
    sensor_10
    sensor_11
FROM devices,
     sensors
WHERE
    devices.sensor_id = sensors.sensor_id
AND
    devices.sensor_ts = sensors.sensor_ts
```

We can now query this new table and also view it in the Flink UI.

You have now written a real-time streaming event application to join two Kafka streams with simple SQL.

**References**

*   [https://towardsdatascience.com/event-driven-supply-chain-for-crisis-with-flinksql-be80cb3ad4f9](https://towardsdatascience.com/event-driven-supply-chain-for-crisis-with-flinksql-be80cb3ad4f9)
*   [https://docs.cloudera.com/csa/1.1.0/overview/topics/csa-overview.html](https://docs.cloudera.com/csa/1.1.0/overview/topics/csa-overview.html)
*   [https://ci.apache.org/projects/flink/flink-docs-stable/dev/table/catalogs.html](https://ci.apache.org/projects/flink/flink-docs-stable/dev/table/catalogs.html)
*   [https://ci.apache.org/projects/flink/flink-docs-stable/dev/table/sqlClient.html](https://ci.apache.org/projects/flink/flink-docs-stable/dev/table/sqlClient.html)
*   https://github.com/tspannhw/meetup-sensors
*   https://github.com/tspannhw/FlinkSQLDemo/
