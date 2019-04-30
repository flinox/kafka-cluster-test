#!/bin/sh
#export IP=$(ip route | awk '/link/ { print $7 }')
#export IP_HOST=$(ip route | awk '/default/ { print $3 }')
pid=0

# SIGTERM-handler
term_handler() {
  if [ $pid -ne 0 ]; then
    #kill -SIGTERM "$pid"
    echo ""
    echo ">>> Shutting down zookeeper $ID ..."
    bin/zkServer.sh stop $ZOOCFG
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

echo ">>> Configurando $ZOOCFG..."
#sed -i "s/zookeeper$ID/$(ip route | awk '/link/ { print $7 }')/g" $ZOOCFG

qtde_found=$(cat $ZOOCFG | grep -c "server.$ID")

if [ $qtde_found -eq 0 ]; then
   #string not contained in file
   echo "server.$ID=$(ip route | awk '/link/ { print $7 }'):2888:3888" >> $ZOOCFG
   echo "$ID" > $ZOOKEEPER_DATA/myid
else
   #string is in file at least once
   sed -i "s/server.$ID=zookeeper$ID/server.$ID=$(ip route | awk '/link/ { print $7 }')/g" $ZOOCFG
fi

sleep 2
echo ">>> Starting zookeeper $ID ..."
bin/zkServer.sh start $ZOOCFG & 
pid="$!"

trap 'term_handler' SIGHUP SIGINT SIGTERM

sleep 5

tail -f $ZOO_LOG_DIR/zookeeper.out & wait
