#!/bin/bash

for folder_data in `find ./zookeeper/data -maxdepth 1 -mindepth 1 -type d | sort -r | head -n 1`
do
    # Pega o ID do node do nome da pasta
    export vID=$(echo $folder_data | sed -E "s/^(.*)([0-9]{1,})$/\2/g")
    export vID=$(($vID+1))

    mkdir ./zookeeper/data/zookeeper${vID}
    mkdir ./zookeeper/log/zookeeper${vID}

    echo ${vID} >> ./zookeeper/data/zookeeper${vID}/myid

done

# Atualiza o server.properties dos kafkas com o novo zookeeper adicionado
for folder_data in `find ./kafka/config -maxdepth 1 -mindepth 1 -type d | sort`
do
    echo 'Updating kafka config files... '${folder_data}
    sed -E -i "s/^(zookeeper.connect=)(.*)$/\1\2\,zookeeper${vID}:2181/g" ${folder_data}/server.properties

done
