FROM openjdk:8u201-jre-alpine

ARG ZKV=3.4.14
ARG ZKH=/opt/zookeeper
ARG ZKL=/opt/zookeeper/log
ARG ZKD=/data/zookeeper

ENV ZOOKEEPER_HOME=${ZKH} \
    ZOOKEEPER_DATA=${ZKD} \
    ZOOKEEPER_VERSION=${ZKV} \
    ZOO_LOG_DIR=${ZKL} \
    ZOOCFG=${ZKH}/conf/zoo.cfg \
    PATH=${PATH}:${ZKH}/bin \
    CLASSPATH=${ZKH}-${ZKV}/lib:${ZKH}-${ZKV}:/usr/lib/jvm/java-1.8-openjdk/jre \
    USER=zookeeper \
    UID=99999 \
    GID=99999 

RUN addgroup --gid ${GID} ${USER} && \
    adduser --disabled-password --gecos "" \
    --home ${ZOOKEEPER_HOME} \
    --ingroup ${USER} \
    --no-create-home \
    --uid ${UID} ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN apk add --no-cache bash curl jq nano sudo && \
    cd /tmp && wget http://ftp.unicamp.br/pub/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz

RUN tar xfz /tmp/zookeeper-${ZOOKEEPER_VERSION}.tar.gz -C /opt && \
    rm /tmp/zookeeper-${ZOOKEEPER_VERSION}.tar.gz && \
    ln -s ${ZOOKEEPER_HOME}-${ZOOKEEPER_VERSION} ${ZOOKEEPER_HOME} && \
    mkdir ${ZOOKEEPER_DATA} -p && \
    mkdir ${ZOOKEEPER_HOME}/log

WORKDIR ${ZOOKEEPER_HOME}

COPY ./conf/* ${ZOOKEEPER_HOME}/conf/
COPY start.sh ${ZOOKEEPER_HOME}/

RUN chown ${USER}:${GID} ${ZOOKEEPER_DATA} && \
    chown ${USER}:${GID} -R ${ZOOKEEPER_HOME}-${ZOOKEEPER_VERSION} && \
    chown -h ${USER}:${GID} ${ZOOKEEPER_HOME} 

USER ${USER}

#RUN echo "sed -i 's/zookeeper1/${IP}/g' ${ZOOKEEPER_HOME}/conf/zoo.cfg" >> 

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD sh -c "./start.sh"

# ENTRYPOINT sleep infinity
# https://zookeeper.apache.org/doc/r3.1.2/zookeeperAdmin.html#sc_systemReq
# Set the Java heap size. This is very important to avoid swapping, which will seriously degrade ZooKeeper performance. To determine the correct value, use load tests, and make sure you are well below the usage limit that would cause you to swap. Be conservative - use a maximum heap size of 3GB for a 4GB machine.

# Gerar imagem
# docker build -t flinox/zookeeper_cluster .

# Rodar o container interativo
# docker run --rm --name zookeeper_cluster --hostname zookeeper_cluster \
# -u zookeeper:zookeeper -e ID=1 \
# -v /data/zookeeper1/:/data/zookeeper \
# -v /log/zookeeper1/:/opt/zookeeper/log \
# flinox/zookeeper_cluster

# Rodar o container normal
# docker run --rm --name zookeeper_cluster --hostname zookeeper_cluster -e ID=1 flinox/zookeeper_cluster