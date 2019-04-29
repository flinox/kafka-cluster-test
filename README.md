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

export ID=2

docker run --rm \
--name zookeeper${ID} --hostname zookeeper${ID} \
-u 1000:1000 -e ID=${ID} \
-v $(pwd)/data/zookeeper${ID}/:/data/zookeeper \
-v $(pwd)/log/zookeeper${ID}/:/opt/zookeeper/log \
-v $(pwd)/conf/:/opt/zookeeper/conf \
flinox/zookeeper_cluster
```

