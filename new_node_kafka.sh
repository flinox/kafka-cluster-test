#!/bin/bash

for folder_data in `find ./kafka/config -maxdepth 1 -mindepth 1 -type d | sort -r | head -n 1`
do
    # Pega o ID do node do nome da pasta
    export v_node_ID=$(echo $folder_data | sed -E "s/^(.*)([0-9]{1,})$/\2/g")
    export v_new_node_ID=$(($v_node_ID+1))

    cp -R ./kafka/config/kafka${v_node_ID} ./kafka/config/kafka${v_new_node_ID}
    mkdir ./kafka/log/kafka${v_new_node_ID}

    sed -E -i "s/^(broker.id=)([0-9]{1,})$/\1${v_new_node_ID}/g" ./kafka/config/kafka${v_new_node_ID}/server.properties

done
