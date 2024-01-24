#!/bin/bash
###########################################################################################
# This script only takes measurements, it does not change the configuration of the machine.
# It accepts as parameters the benchmark-executioncommand (idle if idle needed), the number of runs, 
# the execution time of each run, the directory to save the measurements. 
# use the following command to run it: ./run_experiments.sh main idle 5 120 c_states_on_idle
#############################################################################################


###shasta details###
USERNAME=""
PASSWD=""
HOST=""
USERILO=""
PASSWDILO=""
HOSTILO=""
USERPDU=""
PASSWDPDU=""
HOSTPDU=""
###################

##################################################
# Start getting measurements from the power supply
# argument 1: Result directory
# argument 2: Execution Time
# argument 3: Number of iteration
##################################################
start_measurements () {
        
    python3 ../measurements/pdu.py $USERPDU $PASSWDPDU $HOSTPDU $2 &> $1/"pdu_"$3"_"$2".out" &
    ../measurements/turbostat_residency.sh main 1 180 $USERNAME $PASSWD $HOST &
    ../measurements/run_profiler.sh main $USERNAME $PASSWD $HOST &

}

##################################################
# Stop PDU measurements. Collect the last 20
# minutes iLO power measurements
# argument 1: Result Directory
# argument 2: Number of iteration
# argument 3: Execution Time
##################################################
stop_measurements () {
   
    python3 ../measurements/iLO_power.py $USERILO $PASSWDILO $HOSTILO &> $1/"ilo_all_"$2"_"$3".out"
    ../measurements/turbostat_residency.sh stop_measurements $PASSWD $USERNAME $HOST &
    ../measurements/run_profiler.sh stop_measurements $PASSWD $USERNAME $HOST
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
    cat $1/"ilo_part_"$2"_"$3".out" | grep -e Peak | tr -d "\"" | tr -d " " | tr -d "," | tr ":" "," &> $1/"ilo_peak_"$2"_"$3".out"
    cat $1/"ilo_part_"$2"_"$3".out" | grep -e Minimum | tr -d "\"" | tr -d " " | tr -d "," | tr ":" "," &> $1/"ilo_minimum_"$2"_"$3".out"
    cat $1/"ilo_part_"$2"_"$3".out" | grep -e Average | tr -d "\"" | tr -d " " | tr -d "," | tr ":" "," &> $1/"ilo_average_"$2"_"$3".out"
    cat $1/"ilo_part_"$2"_"$3".out" | grep -e CpuWatts | tr -d "\"" | tr -d " " | tr -d "," | tr ":" "," &> $1/"ilo_cpuwatts_"$2"_"$3".out"
    cat $1/"ilo_part_"$2"_"$3".out" | grep -e DimmWatts | tr -d "\"" | tr -d " " | tr -d "," | tr ":" "," &> $1/"ilo_dimmwatts_"$2"_"$3".out"
    cat $1/"ilo_part_"$2"_"$3".out" | grep -e AmbTemp | tr -d "\"" | tr -d " " | tr -d "," | tr ":" "," &> $1/"ilo_ambtemp_"$2"_"$3".out"
    ../measurements/turbostat_residency.sh report_measurements $PASSWD $USERNAME $HOST &> $1/"turbostat_"$2"_"$3".out"
    mkdir $1/profiler_"$2"_"$3"
    ../measurements/run_profiler.sh report_measurements $PASSWD $USERNAME $HOST $1/profiler_"$2"_"$3"

}

##################################################
# Report Details about the configuration of the 
# current experiment
# argument 1: Benchmark
# argument 2: Number of Iteration
# argument 3: Execution Time
# argument 4: Result Directory
##################################################
store_config () {
    
    if [[ -d $4 ]]; then
        echo "***ERROR: RESULT_DIR already exists***"
        exit
    else
        mkdir $4
    fi

    echo "Start: `date`" > $4"/experiment_configuration.out"
    #echo "$1 $2 $3 $4 pdu iLO" >> $4"/experiment_configuration.out"
    echo "$1 $2 $3 $4 iLO" >> $4"/experiment_configuration.out"
    echo "$USERNAME $PASSWD $HOST $USERILO $PASSWDILO $HOSTILO $USERPDU $PASSWDPDU $HOSTPDU" >> $4/"experiment_configuration.out"

}

##################################################
# Report the end time of the experiment
# argument 1: Result Directory
##################################################
report_end_of_experiment () {

    echo "End: `date` >> $1/experiment_configuration.out"
    
    echo "End: `date`" >> $1"/experiment_configuration.out"
    exit
}

main () {

    if [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" || -z "$5" || -z "$6" || -z "$7" || -z "$8" || -z "$9" ]]; then

        echo "***ERROR: Wrong Arguments***"
        echo "***SYNTAX: ./run_experiment main benchmarkname #runs executiontime resultdir machine conf runcommand startcore endcore"
        exit;   
    fi 

    benchmark=$1
    runs=$2
    exec_time=$3
    run_command=$7
    start_core=$8
    end_core=$9

    #make root result dir if not exist
    if [[ ! -d $4 ]]; then
        mkdir $4
    fi

    result_dir=$4"/"$5"_"$6"_"$1
    store_config $benchmark $runs $exec_time $result_dir
     
    for (( i=1 ; i<=$runs ; i++ )); 
    do
        
        #start taking measurements
        
        start_measurements $result_dir $exec_time $i

        #execute benchmark
        if [ "$benchmark" != "idle" ]; then

            ./run_benchmark.sh start_benchmarks "$run_command" $start_core $end_core 
        
        fi

        sleep $exec_time

        #stop benchmark
        if [[ "$benchmark" != "idle" ]]; then
            
            ./run_benchmark.sh stop_benchmarks $run_command

        fi

        #stop taking measurements
        echo "stop_measurements $result_dir $i $exec_time"
        stop_measurements $result_dir $i $exec_time
        
        # #report measurements
        report_measurements $result_dir $i $exec_time
    done
    
    report_end_of_experiment $result_dir
}
"$@"