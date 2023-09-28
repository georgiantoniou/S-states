#!/bin/sh
###########################################################################################
# This script only takes measurements, it does not change the configuration of the machine.
# It accepts as parameters the benchmark-executioncommand (idle if idle needed), the number of runs, 
# the execution time of each run, the directory to save the measurements. 
# use the following command to run it: ./run_experiments.sh main idle 5 120 c_states_on_idle
#############################################################################################


###shasta details###

###################

##################################################
# Start getting measurements from the power supply
# argument 1: Result directory
# argument 2: Execution Time
# argument 3: Number of iteration
##################################################
start_measurements () {
    
    if [[ -d $1 ]]; then
        echo "***ERROR: RESULT_DIR already exists***"
        exit
    else
        mkdir $1
    fi

    python3 ../measurements/pdu.py $USERPDU $PASSWDPDU $HOSTPDU $2 &> $1/"pdu_"$3"_"$2".out" &
    pdu_pid=`echo "$!"`
    return $pdu_pid
}

##################################################
# Stop PDU measurements. Collect the last 20
# minutes iLO power measurements
# argument 1: PDU Process ID
# argument 2: Result Directory
# argument 3: Number of iteration
# argument 4: Execution Time
##################################################
stop_measurements () {
   
    kill -9 $1

    python3 ../measurements/iLO_power.py $USERILO $PASSWDILO $HOSTILO &> $2/"ilo_all_"$3"_"$4".out"
    
}

##################################################
# Extract correct measurements from iL0 20 min 
# trace
# argument 1: Result Directory
# argument 2: Number of iteration
# argument 3: Execution Time
##################################################

report_measurements () {
    etime=$3

    ((lines = etime/10*19))
    sed -n '/PowerDetail/,$p' $1/"ilo_all_"$2"_"$3".out" | head -n-3 | grep -v "PowerDetail" | tail -$lines &> $1/"ilo_part_"$2"_"$3".out"
    
}

store_config () {
    
echo "$1 $2 $3 $4 pdu iLO" > $4/"machine_configuration.out"
echo "$USERNAME $PASSWD $HOST $USERILO $PASSWDILO $HOSTILO $USERPDU $PASSWDPDU $HOSTPDU" >> $4/"machine_configuration.out"

}

main () {

    if [[ -z $1 || -z $2 || -z $3 || -z $4 ]]; then

        echo "***ERROR: Wrong Arguments***"
        echo "***SYNTAX: ./run_experiment main benchmark #runs executiontime resultdir"
        exit;   
    fi 

    benchmark=$1
    runs=$2
    exec_time=$3
    result_dir=$4

    echo "$1 $2 $3 $4"
    exit

    if [[ "$BENCHMARK" == "idle" ]]; then
        BENCHMARK=" &"
    
    else
        BENCHMARK=$BENCHMARK" &"
    fi
    
    for (( i=1 ; i<=$RUNS ; i++ )); 
    do
        #start taking measurements
        start_measurements $result_dir $exec_time $i
        pids=`echo "$?"`

        #execute benchmark
        if [[ "$benchmark" != "idle" ]]; then

            bench_pid=`sshpass -p '$PASSWD' ssh $USERNAME@$HOST "$benchmark; echo "$!""` 
        fi
        
        sleep $EXEC_TIME

        if [[ "$benchmark" != "idle" ]]; then
            sshpass -p '$PASSWD' ssh $USERNAME@$HOST "kill -9 $bench_pid"
        fi

        #stop taking measurements
        stop_measurements $pids $RESULT_DIR $i $EXEC_TIME $PASSILO

        #report measurements
        report_measurements $RESULT_DIR $i $EXEC_TIME

    done


    store_config $BENCHMARK $RUNS $EXEC_TIME $RESULT_DIR
}

"$@"