#!/bin/sh
###########################################################################################
# This script only takes measurements, it does not change the configuration of the machine.
# It accepts as parameters the benchmark-executioncommand (idle if idle needed), the number of runs, 
# the execution time of each run, the directory to save the measurements. 
# use the following command to run it: ./run_experiments.sh main idle 5 120 c_states_on_idle
#############################################################################################

start_measurements () {
    
    if [[ -d $1 ]]; then
        echo "***ERROR: RESULT_DIR already exists***"
        exit
    else
        mkdir $1
    fi

    python3 ../measurements/pdu.py user '' shasta $2 &> $1/"pdu_"$3"_"$2"_.out" &
    pdu_pid=`echo "$!"`
    return $pdu_pid
}

stop_measurements () {
    
    kill -9 $1

    python3 ../measurements/iLO_power.py ganton12 '' url &> $2/"ilo_all_"$3"_"$4"_.out"
    
}

report_measurements () {
    

    cat $2/"ilo_all_"$3"_"$4"_.out" | 
    
}

main () {

    if [[ -z $1 || -z $2 || -z $3 || -z $4  ]]; then

        echo "***ERROR: Wrong Arguments***"
        echo "***SYNTAX: ./run_experiment main benchmark #runs executiontime resultdir"
        exit;   
    fi 

    BENCHMARK=$1
    RUNS=$2
    EXEC_TIME=$3
    RESULT_DIR=$4

    if [[ "$BENCHMARK" == "idle" ]]; then
        BENCHMARK=" &"
    
    else
        BENCHMARK=$BENCHMARK" &"
    fi
    
    for (( i=1 ; i<=$RUNS ; i++ )); 
    do
        #start taking measurements
        start_measurements $RESULT_DIR $EXEC_TIME $i
        pids=`echo "$?"`

        #execute benchmark
        bench_pid=`sshpass -p 't@uyM59bQ' ssh ganton12@shasta.in.cs.ucy.ac.cy "$BENCHMARK; echo "$!""` 
        sleep $EXEC_TIME

        sshpass -p 't@uyM59bQ' ssh ganton12@shasta.in.cs.ucy.ac.cy "kill -9 $bench_pid"

        #stop taking measurements
        stop_measurements $pids $RESULT_DIR $i $EXEC_TIME

        #report measurements
        report_measurements

    done


    store_config 



}










"$@"