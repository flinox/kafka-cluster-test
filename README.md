# kafka_cluster
A Kafka cluster to run and go, contains zookeeper, kafka broker, kafka connect and kafka client.

# Under construction...

Create a UID=99999 and GID=99999 on host to map the volume to avoid error of  permission denied.
```
sudo addgroup --gid 99999 zookeeper
```

```
sudo adduser --disabled-password --gecos "" --home /opt/zookeeper --ingroup zookeeper --no-create-home --uid 99999 zookeeper
```

Define permissions on folders data and log

```
sudo chmod 775 log -R
sudo chmod 775 data -R
```



