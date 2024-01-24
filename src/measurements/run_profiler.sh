#!/bin/bash
###########################################################################################
# This script uses the profiler script to take residency and rapl power measurements.
# It starts the profiler process, then start the collection of measurements and then reports
# the measurements
#############################################################################################

##################################################
# Start measuring system C-State residency and rapl counters
# argument 1: Password
# argument 2: Username
# argument 3: Hostname
# argument 4: Command
##################################################
start_measurements () {
    
    echo "sshpass -p "$1" ssh -f $2@$3 "python3 ~/profiler.py -n $3 start""
    sshpass -p "$1" ssh -f $2@$3 "python3 ~/profiler.py -n $3 start"
}

##################################################
# Stop measuring system C-State residency and rapl
##################################################
stop_measurements () {
   
   sshpass -p "$1" ssh -f $2@$3 "python3 ~/profiler.py -n $3 stop"
    
}

##################################################
# Report C-State residency measurements and rapl
# argument 1: Password
# argument 2: Username
# argument 3: Hostname
# argument 4: Directory to save files
##################################################
report_measurements () {

   sshpass -p "$1" ssh -f $2@$3 "python3 ~/profiler.py -n $3 report -d ~/profiler_temp";
   sleep 10
   #echo "sshpass -p $1 scp -d $2@$3:~/profiler_temp $4"
   sshpass -p "$1" scp $2@$3:~/profiler_temp/* $4;
   sshpass -p "$1" ssh -f $2@$3 "rm -r ~/profiler_temp";
   sshpass -p "$1" ssh -f $2@$3 "sudo pkill -f profiler.py";

}


main () {

    if [[ -z "$1" || -z "$2" || -z "$3" ]]; then

        echo "***ERROR: Wrong Arguments***"
        echo "***SYNTAX: ./run_profiler.sh username password hostname"
        exit;   
    fi 
  
    username=$1
    password=$2
    host=$3

    # start profiler process 
    sshpass -p "$password" ssh -f $username@$host "sudo python3 ~/profiler.py &"
   
    # start taking measurements
    #start_measurements $password $username $host
    
}
"$@"