# kafka_cluster

A simple kafka cluster to give you an ideia, how it works.
I'm learning too, so if you found an error or have a suggestion to change, please let me know...

But i test and everything work, very tolerant a failures, it's amazing !!

So, you need to run 
```
docker-compose up
```

And... good to go !
Maybe you need to tunning parameters, configurations and so on... but, this code will give you a good ideia to work with kafka.

## Pre-reqs

The owner of the volumes must have the UID 1000, or you need to change the UID and GID on respectives kafka/Dockerfile and zookeeper/Dockerfile.

The folders are:

```
kafka/config
kafka/log

zookeeper/conf
zookeeper/data
zookeeper/log
```

Where kafka/config is the configuration folder for every node of kafka
Where zookeeper/conf is the configuration folder who is shared for every node of zookeeper, if you want, you can create conf isolated for zookeeper.

Is very important before you run and use your cluster, you need to configure a persistent volumes for store the data:
```
zookeeper/data
```
And maybe another for logs
```
zookeeper/log
kafka/log
```

Build the dockerfile to create an image of zookeeper and another for kafka, something like:

```
cd ~/github.com/flinox/kafka_cluster/zookeeper
docker build -t flinox/zookeeper_cluster .

cd ~/github.com/flinox/kafka_cluster/kafka
docker build -t flinox/kafka_cluster .
```

Initialy the zookeeper and kafka are not safety, because I'm using on zookeeper image the ALLOW_ANONYMOUS_LOGIN: "yes", but if you expect use this in production I recomend you turn off this variable.

## Run the cluster

After configure, to run the container inside your AWS cloud or your onpremises server, just run:

```
docker-compose up
```

You will start 3 zookeeper and 3 kafka brokers.

## To evolve

### Another zookeeper node

Just add on your docker-compose.yml another service, for example:
```
  zookeeper4:
    image: flinox/zookeeper_cluster
    user: "1000:1000"
    hostname: zookeeper4
    container_name: zookeeper4
    networks:
      - cluster-net
    volumes:
      - ./zookeeper/data/zookeeper4:/data/zookeeper
      - ./zookeeper/log/zookeeper4:/opt/zookeeper/log
      - ./zookeeper/conf:/opt/zookeeper/conf
    ports:
      - "2181:2181"
    environment:
      ALLOW_ANONYMOUS_LOGIN: "yes"
      ID: 4
```
Every new node will automatically update the zookeeper/conf/zoo.cfg with the ip of new node.

### Another kafka node

Just add on your docker-compose.yml another service, for example:
```
  kafka4:
    image: flinox/kafka_cluster
    user: "1000:1000"    
    hostname: kafka4
    container_name: kafka4
    networks:
      - cluster-net
    volumes:
      - ./kafka/log/kafka4:/opt/kafka/logs
      - ./kafka/config/kafka4:/opt/kafka/config
    ports:
      - "9092:9092"
    environment:
      ID: 4
      ALLOW_PLAINTEXT_LISTENER: "yes"
```

Before run, make a copy of folder:
```
kafka/config/kafka1
to
kafka/config/kafka4
```

Change the file server.properties :
```
# The broker.id is automatically updated by start.sh script, but you can set the value of your new node
# in our example is 4
broker.id=4

# If you have zookeeper nodes you need to include on this parameter
# I will work on create a script to do this soon
zookeeper.connect=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181
```


### Commands

```
cd ~/github.com/flinox/kafka_cluster/zookeeper

export ID=1

docker run --rm \
--name zookeeper${ID} --hostname zookeeper${ID} \
-u 1000:1000 -e ID=${ID} \
-v $(pwd)/data/zookeeper${ID}/:/data/zookeeper \
-v $(pwd)/log/zookeeper${ID}/:/opt/zookeeper/log \
-v $(pwd)/conf/:/opt/zookeeper/conf \
flinox/zookeeper_cluster
```

## Adding another node on cluster

```
export ID=2

docker run --rm \
--name zookeeper${ID} --hostname zookeeper${ID} \
-u 1000:1000 -e ID=${ID} \
-v $(pwd)/data/zookeeper${ID}/:/data/zookeeper \
-v $(pwd)/log/zookeeper${ID}/:/opt/zookeeper/log \
-v $(pwd)/conf/:/opt/zookeeper/conf \
flinox/zookeeper_cluster
```

After you need restart all others nodes, like node 1, for example:
```
docker exec -it zookeeper1 ./bin/zkServer.sh restart $ZOOCFG
```

## Adding another node on cluster

```
export ID=3

docker run --rm \
--name zookeeper${ID} --hostname zookeeper${ID} \
-u 1000:1000 -e ID=${ID} \
-v $(pwd)/data/zookeeper${ID}/:/data/zookeeper \
-v $(pwd)/log/zookeeper${ID}/:/opt/zookeeper/log \
-v $(pwd)/conf/:/opt/zookeeper/conf \
flinox/zookeeper_cluster
```

Now you don't need to restart the others, it will recognize the new nodes.

## Running another client to consult who is the leader
```
docker run -it --rm --name flinox_zookeeper flinox/flinox:v2 sh
root@5486cd28fda8:/# echo stat | nc 172.17.0.3 2181 | grep Mode
Mode: leader
root@5486cd28fda8:/# echo stat | nc 172.17.0.2 2181 | grep Mode
Mode: follower
root@5486cd28fda8:/# echo stat | nc 172.17.0.4 2181 | grep Mode
Mode: follower
```

## To validate if zookeeper service is healthy or not
```
echo stat | nc 172.17.0.3 2181
echo mntr | nc 172.17.0.3 2181
echo isro | nc 172.17.0.3 2181

echo stat | nc 172.17.0.2 2181
echo mntr | nc 172.17.0.2 2181
echo isro | nc 172.17.0.2 2181

echo stat | nc 172.17.0.4 2181
echo mntr | nc 172.17.0.4 2181
echo isro | nc 172.17.0.4 2181


```


# Running a cluster with 3 zookeepers and 3 kafkas

```

# ZOOKEEPER
#######################
cd ~/github.com/flinox/kafka_cluster/zookeeper

export ID=1

docker run --rm \
--name zookeeper${ID} --hostname zookeeper${ID} \
--network bridge \
-u 1000:1000 -e ID=${ID} -e ALLOW_ANONYMOUS_LOGIN=yes \
-v $(pwd)/data/zookeeper${ID}/:/data/zookeeper \
-v $(pwd)/log/zookeeper${ID}/:/opt/zookeeper/log \
-v $(pwd)/conf/:/opt/zookeeper/conf \
flinox/zookeeper_cluster &

sleep 5
export ID=2

docker run --rm \
--name zookeeper${ID} --hostname zookeeper${ID} \
--network bridge \
-u 1000:1000 -e ID=${ID} -e ALLOW_ANONYMOUS_LOGIN=yes \
-v $(pwd)/data/zookeeper${ID}/:/data/zookeeper \
-v $(pwd)/log/zookeeper${ID}/:/opt/zookeeper/log \
-v $(pwd)/conf/:/opt/zookeeper/conf \
flinox/zookeeper_cluster &

sleep 5
export ID=3

docker run --rm \
--name zookeeper${ID} --hostname zookeeper${ID} \
--network bridge \
-u 1000:1000 -e ID=${ID} -e ALLOW_ANONYMOUS_LOGIN=yes \
-v $(pwd)/data/zookeeper${ID}/:/data/zookeeper \
-v $(pwd)/log/zookeeper${ID}/:/opt/zookeeper/log \
-v $(pwd)/conf/:/opt/zookeeper/conf \
flinox/zookeeper_cluster &


# KAFKA
#######################
cd ~/github.com/flinox/kafka_cluster/kafka

sleep 5
export ID=1

docker run --rm \
--name kafka${ID} --hostname kafka${ID} \
--network bridge \
-u 1000:1000 -e ID=${ID} -e ALLOW_PLAINTEXT_LISTENER=yes \
-v $(pwd)/log/kafka${ID}/:/opt/kafka/logs \
-v $(pwd)/config/kafka${ID}:/opt/kafka/config \
flinox/kafka_cluster &

sleep 5
export ID=2

docker run --rm \
--name kafka${ID} --hostname kafka${ID} \
--network bridge \
-u 1000:1000 -e ID=${ID} -e ALLOW_PLAINTEXT_LISTENER=yes \
-v $(pwd)/log/kafka${ID}/:/opt/kafka/logs \
-v $(pwd)/config/kafka${ID}:/opt/kafka/config \
flinox/kafka_cluster &

```

## Test the cluster

kafka-topics --create --zookeeper zookeeper1:2181 --replication-factor 1 --partitions 1 --topic test

kafka-topics --list --zookeeper zookeeper1:2181

kafka-console-producer --broker-list kafka1:9092,kafka2:9093,kafka3:9094 --topic test


kafka-console-consumer --bootstrap-server kafka1:9092,kafka2:9093,kafka3:9094 --topic test --from-beginning

