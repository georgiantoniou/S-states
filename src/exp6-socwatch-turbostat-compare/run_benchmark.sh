#!/bin/bash

###machine details###
USERNAME=""
PASSWD=""
HOST=""

start_benchmarks () {

    if [[ -z "$1" || -z "$2" ]]; then

            echo "***ERROR: Wrong Arguments***"
            echo "***SYNTAX: ./run_experiment benchmark startcore endcore extracommandattheend"
            exit;   
    fi 

    benchmark=$1
    startcore=$2
    endcore=$3
    commandend=$4

    

    #benchmark=$benchmark" &"
    process=`echo $benchmark | tr -d "." | tr -d "/" | awk '{print $1}'`
    sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "for((core=$startcore;core<$endcore;core++));do taskset -c \$core $benchmark & done; $commandend ;pgrep $process"
    
     
}


stop_benchmarks () {

    benchmark=$1
    process=`echo $benchmark | tr -d "." | tr -d "/" | tr "_" " " | awk '{print $1}'` 
    sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "pkill $process"

}

"$@"



