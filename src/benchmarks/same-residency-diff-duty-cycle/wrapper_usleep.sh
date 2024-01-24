#!/bin/bash

declare -a usleep_time=(10 100 1000 10000 100000 1000000)
exp_iterations=10

for (( i=2 ; i<=$exp_iterations ; i++ )); 
do
    for dur in "${usleep_time[@]}"
    do
        echo "$i $dur"
        sudo perf stat ./usleepbench $dur &> "iter_"$i"_usleep_"$dur &
        sleep 7.5
        sudo pkill usleepbench
    done
    
done