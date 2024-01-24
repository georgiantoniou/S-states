# #####################################################
# System Configuration:
# 
# Grub File: nohz=on intel_pstate=disable
# Pkg C-States: Disabled
# Core C-States: C6
# Turbo: Disabled
# SMT: Disabled
# Idle Governor: Menu
# Frequency Governor: userspace
# Frequencies: 2.1, 2.0, 1.6, 1.2, 0.8 GHz
# Frequency Driver: acpi_cpufreq
# Uncore Frequency: set to 2.4 GHz
# Benchmark: simple-loop
# Active Cores: 1
#
# Check whether the system changes frequency as you expect
# 
# Naming Convestion for directories: 
#                                   frequency_iteration
#
#!/bin/bash

###machine details###
USERNAME=""
PASSWD=""
HOST=""

###############################Experiments Validation################################
echo "Start: `date`"

#Change governor to userspace
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"

#Change Frequency to 2.1
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 2100MHz"

sleep 5

runs=5

for (( i=1 ; i<=$runs ; i++ )); 
do

    sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "time ./simple-loop" &> "/home/ganton12/data/exp6_validate_freq/2_1_GHZ_"$i
    sleep 60
done

sleep 10

#Change Frequency to 2
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 2000MHz"

sleep 5

for (( i=1 ; i<=$runs ; i++ )); 
do

    sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "time ./simple-loop" &> "/home/ganton12/data/exp6_validate_freq/2_0_GHZ_"$i;
    sleep 60
done

sleep 10

#Change Frequency to 1.6
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 1600MHz"

sleep 5

for (( i=1 ; i<=$runs ; i++ )); 
do

    sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "time ./simple-loop" &> "/home/ganton12/data/exp6_validate_freq/1_6_GHZ_"$i;
    sleep 60
done

sleep 10

#Change Frequency to 1.2
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 1200MHz"

sleep 5

for (( i=1 ; i<=$runs ; i++ )); 
do

    sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "time ./simple-loop" &> "/home/ganton12/data/exp6_validate_freq/1_2_GHZ_"$i;
    sleep 60
done

sleep 10

#Change Frequency to 0.8
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 800MHz"

sleep 5

for (( i=1 ; i<=$runs ; i++ )); 
do

    sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "time ./simple-loop" &> "/home/ganton12/data/exp6_validate_freq/0_8_GHZ_"$i;
    sleep 60
done

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g performance"
sleep 5
echo "End: `date`"
