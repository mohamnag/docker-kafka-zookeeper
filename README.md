# Kafka & Zookeeper in one image
This image is **NOT** for production use but rather for testing purposes.

This is a sum of following two image:
 - https://github.com/wurstmeister/zookeeper-docker
 - https://github.com/wurstmeister/kafka-docker
 
So the credit goes mainly to their creators.

## Usage
This runs both Kafka and Zookeeper inside. Kafka is configured to use 
port `9092` internally and ZK the port `2181`. At least these two ports 
should be bound to host for external usage. If you bind the Kafka port 
to any other port on the host, you have to set the env variable 
`KAFKA_ADVERTISED_PORT` to that one.

The `KAFKA_ADVERTISED_HOST_NAME` has to be set to the host's name or IP
for Kafka to accept incoming connections.