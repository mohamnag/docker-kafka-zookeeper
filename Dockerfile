FROM openjdk:16-slim
MAINTAINER Martin Dos Santos <plateadodev@gmail.com>

# fixed, informational ENV vars:
# for Kafka
ENV KAFKA_VERSION "2.6.0"
ENV SCALA_VERSION "2.13"
ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ENV KAFKA_BROKER_ID "-1"
ENV START_TIMEOUT "600"
ENV KAFKA_PORT "9092"
ENV KAFKA_ZOOKEEPER_PORT "2181"
# for ZK
ENV ZOOKEEPER_VERSION "zookeeper-3.6.2"
ENV ZK_HOME /opt/apache-${ZOOKEEPER_VERSION}-bin


# Kafka runtime config, may be overridden:
ENV KAFKA_ADVERTISED_PORT "9092"
ENV KAFKA_ADVERTISED_HOST_NAME "localhost"
ENV KAFKA_HEAP_OPTS ""
ENV KAFKA_LOG_DIRS "/kafka/kafka-logs-$HOSTNAME"


# Install Kafka
 ADD http://www-eu.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz /tmp/kafka.tgz
 RUN tar xfz /tmp/kafka.tgz -C /opt/ && \
    rm /tmp/kafka.tgz

# Install ZK
ADD http://mirror.vorboss.net/apache/zookeeper/${ZOOKEEPER_VERSION}/apache-${ZOOKEEPER_VERSION}-bin.tar.gz /tmp/zookeeper.tar.gz
RUN tar -xzf /tmp/zookeeper.tar.gz -C /opt/
RUN rm /tmp/zookeeper.tar.gz
RUN ls /opt/
RUN mv /opt/apache-${ZOOKEEPER_VERSION}-bin/conf/zoo_sample.cfg /opt/apache-${ZOOKEEPER_VERSION}-bin/conf/zoo.cfg
RUN ls /opt/
RUN sed  -i "s|/tmp/zookeeper|$ZK_HOME/data|g" $ZK_HOME/conf/zoo.cfg; mkdir $ZK_HOME/data

# net-tools needed for create-topics.sh
RUN apt-get update && apt-get install -y net-tools

ADD start-kafka.sh /usr/bin/start-kafka.sh
# TODO not really sure if this is needed, Kafka is running in auto create topic anyway!
ADD create-topics.sh /usr/bin/create-topics.sh

EXPOSE 2181 2888 3888
EXPOSE 9092

VOLUME [ "/kafka", "${ZK_HOME}/conf", "${ZK_HOME}/data" ]

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]
