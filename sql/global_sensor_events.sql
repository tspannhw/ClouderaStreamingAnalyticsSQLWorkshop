CREATE TABLE global_sensor_events (
 uuid STRING, 
	systemtime STRING ,  
temperaturef STRING , 
pressure DOUBLE, 
humidity DOUBLE, 
lux DOUBLE, 
proximity int, 
oxidising DOUBLE , 
reducing DOUBLE, 
nh3 DOUBLE , 
gasko STRING,
`current` INT, 
voltage INT ,
`power` INT,
`total` INT,
fanstatus STRING
) WITH (
	'connector.type'    	 = 'kafka',
	'connector.version' 	 = 'universal',
	'connector.topic'   	 = 'global_sensor_events',
	'connector.startup-mode' = 'earliest-offset',
	'connector.properties.bootstrap.servers' = 'edge2ai-1.dim.local:9092',
	'connector.properties.group.id' = 'flink-sql-global-sensor-join',
	'format.type' = 'json'
)
