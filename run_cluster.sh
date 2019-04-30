
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
