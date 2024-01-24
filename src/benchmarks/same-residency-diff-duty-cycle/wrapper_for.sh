#!/bin/bash

declare -a for_iterations=(1 1000 10000 100000 1000000 10000000 100000000)
exp_iterations=10

for (( i=1 ; i<=$exp_iterations ; i++ )); 
do
    for it in "${for_iterations[@]}"
    do
        echo "$i $it"
        sudo perf stat ./forbench $it &>> "iter_"$i"_for_"$it
    done
done