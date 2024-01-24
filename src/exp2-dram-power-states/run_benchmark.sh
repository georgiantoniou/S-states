#!/bin/bash

###machine details###
USERNAME=""
PASSWD=""
HOST=""

start_benchmarks () {

    if [[ -z "$1" || -z "$2" ]]; then

            echo "***ERROR: Wrong Arguments***"
            echo "***SYNTAX: ./run_experiment benchmark #cores"
            exit;   
    fi 

    benchmark=$1
    cores=$2

    for (( i=1 ; i<=$2 ; i++ )); 
    do

        #benchmark=$benchmark" &"
        process=`echo $benchmark | tr -d "." | tr -d "/"`
        sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "for((core=0;core<$cores;core++));do taskset -c \$core $benchmark & done; pgrep $process"
        
        exit
    done 
}


stop_benchmarks () {

    benchmark=$1
    process=`echo $benchmark | tr -d "." | tr -d "/"`

    sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "pkill $process"

}

"$@"



