#!/bin/sh
#export IP=$(ip route | awk '/link/ { print $7 }')
#export IP_HOST=$(ip route | awk '/default/ { print $3 }')
pid=0

# SIGTERM-handler
term_handler() {
  if [ $pid -ne 0 ]; then
    #kill -SIGTERM "$pid"
    bin/zkServer.sh stop
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

echo ">>> Configurando $ZOOCFG..."
sed -i "s/zookeeper$ID/$(ip route | awk '/link/ { print $7 }')/g" $ZOOCFG

sleep 2
echo ">>> Starting zookeeper $ID ..."
bin/zkServer.sh start $ZOOCFG & 
pid="$!"

trap 'term_handler' SIGHUP SIGINT SIGTERM

sleep 5

tail -f $ZOO_LOG_DIR/zookeeper.out & wait
