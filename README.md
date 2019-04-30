# kafka_cluster
A Kafka cluster to run and go, contains zookeeper, kafka broker, kafka connect and kafka client.

# Under construction...

The owner of the volumes must have the UID 1000, or you need to change the UID and GID on Dockerfile.
```
/conf
/data
/log
```


## Run the container
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
