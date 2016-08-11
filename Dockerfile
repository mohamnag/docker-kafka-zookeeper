FROM java:8-jdk
MAINTAINER Mohammad Naghavi <mohamnag@gmail.com>

# fixed, informational ENV vars:
ENV KAFKA_VERSION "0.10.0.1"
ENV SCALA_VERSION "2.11"
ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ENV KAFKA_BROKER_ID "-1"
ENV START_TIMEOUT "600"
# fixed
ENV KAFKA_PORT "9092"
# fixed
ENV KAFKA_ZOOKEEPER_CONNECT "localhost:2181"


# Kafka runtime config, may be overridden:
ENV KAFKA_ADVERTISED_PORT "9092"
ENV KAFKA_ADVERTISED_HOST_NAME "localhost"
ENV KAFKA_HEAP_OPTS ""
ENV KAFKA_LOG_DIRS "/kafka/kafka-logs-$HOSTNAME"


ADD http://mirror.klaus-uwe.me/apache/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz /tmp/kafka.tgz
RUN tar xfz /tmp/kafka.tgz -C /opt/ && \
    rm /tmp/kafka.tgz

EXPOSE 2181
EXPOSE 9092

ADD start-kafka.sh /usr/bin/start-kafka.sh
# TODO not really sure if this is needed, Kafka is running in auto create topic anyway!
ADD create-topics.sh /usr/bin/create-topics.sh

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]