#!/bin/bash
DB_USER="sa"
DB_PORT="1433"
DB_PASSWORD="1q2w3e4r$"
DB_NAMES="MyDb"

curl --location 'http://connect:8083/connectors/' \
    --header 'Accept: application/json' \
    --header 'Content-Type: application/json' \
    --data '{
  "name": "employee",
  "config": {
     "connector.class" : "io.debezium.connector.sqlserver.SqlServerConnector",
     "tasks.max" : "1",
     "database.server.name" : "mssql",
     "database.hostname" : "mssql",
     "database.port" : "'$DB_PORT'",
     "database.user" : "'$DB_USER'",
     "topic.prefix": "Employee",
     "database.password" : "'$DB_PASSWORD'",
     "database.names" : "'$DB_NAMES'",
     "database.encrypt": false,
     "schema.history.internal.kafka.bootstrap.servers": "kafka:9092",
     "schema.history.internal.kafka.topic": "dbo.History"
  }
}'
