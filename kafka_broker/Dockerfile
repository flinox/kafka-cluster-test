FROM openjdk:8u201-jre-alpine

ENV KAFKA_HOME=/opt/kafka \
    PATH=${PATH}:${KAFKA_HOME}/bin \
    KAFKA_VERSION=2.2.0 \
    SCALA_VERSION=2.12

RUN apk add --no-cache bash curl jq docker \
 && cd /tmp && wget http://ftp.unicamp.br/pub/apache/kafka/2.2.0/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
 && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt \
 && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
 && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME} \
 && rm /tmp/*

VOLUME ["/kafka"]

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
#CMD ["start-kafka.sh"]