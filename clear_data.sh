#!/bin/bash

echo 'WARNING... this action is irreversible !!'
echo 'WARNING... this action is irreversible !!'
read -p "Are you sure ? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then

    for folder_data in `find ./zookeeper/data -maxdepth 1 -mindepth 1 -type d | sort`
    do
        # Pega o ID do node do nome da pasta
        export vID=$(echo $folder_data | sed -E "s/^(.*)([0-9]{1,})$/\2/g")
        
        sudo rm -R ./zookeeper/data/zookeeper${vID}/version-2
        sudo rm ./zookeeper/data/zookeeper${vID}/zookeeper_server.pid
        sudo rm ./zookeeper/log/zookeeper${vID}/zookeeper.out

    done

    # Atualiza o server.properties dos kafkas com o novo zookeeper adicionado
    for folder_data in `find ./kafka/config -maxdepth 1 -mindepth 1 -type d | sort`
    do
        # Pega o ID do node do nome da pasta
        export vID=$(echo $folder_data | sed -E "s/^(.*)([0-9]{1,})$/\2/g")
            
        sudo rm ./kafka/log/kafka${vID}/*

    done

fi



# PS3='Please enter your choice: '
# options=("Option 1" "Option 2" "Option 3" "Quit")
# select opt in "${options[@]}"
# do
#     case $opt in
#         "Option 1")
#             echo "you chose choice 1"
#             ;;
#         "Option 2")
#             echo "you chose choice 2"
#             ;;
#         "Option 3")
#             echo "you chose choice $REPLY which is $opt"
#             ;;
#         "Quit")
#             break
#             ;;
#         *) echo "invalid option $REPLY";;
#     esac
# done