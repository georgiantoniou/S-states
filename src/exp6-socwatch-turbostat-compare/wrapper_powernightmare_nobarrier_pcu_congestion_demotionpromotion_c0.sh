# #####################################################
# System Configuration:
# 
# Grub File: nohz=on intel_pstate=disable
# Pkg C-States: Disabled
# Core C-States: C6
# Idle governor: C1 disabled
# MSR: 0xe2 = 10008400
# Turbo: Disabled
# SMT: Disabled
# Idle Governor: Menu
# Frequency Governor: Performance
# Frequency Driver: acpi_cpufreq
# Uncore Frequency: set to 2.4 GHz
# Benchmark: powernightmare
# Active Cores: 20
# Idle time: 10, 30, 40, 800 
#
# Calculate the difference between expected and actul power consumption (pcu congestion)
# using powernightmare with different sleep durations and turbostat for hardware cstate residency 
# counters. Socwatch summary has incosistencies for some reason. 
# Check with the one configuration and modified powernightmare so that it does not use barrier. 
# 
# Naming Convestion for directories: 
#                                sleep_time_active_cores
#
#!/bin/bash

###machine details###
USERNAME=""
PASSWD=""
HOST=""

###############################Experiments Shasta Validation################################
echo "Start: `date`"


/home/ganton12/S-states/src/machine-configuration/set-grub-reboot.sh 0 disabled enabled shasta

ssh ganton12@shasta "/home/ganton12/S-states/src/machine-configuration/configure.sh"

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo wrmsr 0xe2 0x18008400 -a"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g performance"

sleep 5

#configuration remains the same

#start with 20 active cores different sleep time

#sleep for 10us

./run_experiment.sh main powernightmare_nobarrier 5 120 /home/ganton12/data/exp6_powernightmare_pcu_congestion shasta c0_performance_nobarrier_10_20 "./powernightmare_nobarrier 10 20" 0 1 "python ./powernightmare-pt.py 20"

sleep 10

#sleep for 30us

./run_experiment.sh main powernightmare_nobarrier 5 120 /home/ganton12/data/exp6_powernightmare_pcu_congestion shasta c0_performance_nobarrier_30_20 "./powernightmare_nobarrier 30 20" 0 1 "python ./powernightmare-pt.py 20"

sleep 10

#sleep for 40us

./run_experiment.sh main powernightmare_nobarrier 5 120 /home/ganton12/data/exp6_powernightmare_pcu_congestion shasta c0_performance_nobarrier_40_20 "./powernightmare_nobarrier 40 20" 0 1 "python ./powernightmare-pt.py 20"

sleep 10

#sleep for 800us

./run_experiment.sh main powernightmare_nobarrier 5 120 /home/ganton12/data/exp6_powernightmare_pcu_congestion shasta c0_performance_nobarrier_800_20 "./powernightmare_nobarrier 800 20" 0 1 "python ./powernightmare-pt.py 20"

sleep 10

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 2.1GHz"

./run_experiment.sh main powernightmare_nobarrier 5 120 /home/ganton12/data/exp6_powernightmare_pcu_congestion shasta c0_userspace_nobarrier_10_20 "./powernightmare_nobarrier 10 20" 0 1 "python ./powernightmare-pt.py 20"

sleep 10

#sleep for 30us

./run_experiment.sh main powernightmare_nobarrier 5 120 /home/ganton12/data/exp6_powernightmare_pcu_congestion shasta c0_userspace_nobarrier_30_20 "./powernightmare_nobarrier 30 20" 0 1 "python ./powernightmare-pt.py 20"

sleep 10

#sleep for 40us

./run_experiment.sh main powernightmare_nobarrier 5 120 /home/ganton12/data/exp6_powernightmare_pcu_congestion shasta c0_userspace_nobarrier_40_20 "./powernightmare_nobarrier 40 20" 0 1 "python ./powernightmare-pt.py 20"

sleep 10

#sleep for 800us

./run_experiment.sh main powernightmare_nobarrier 5 120 /home/ganton12/data/exp6_powernightmare_pcu_congestion shasta c0_userspace_nobarrier_800_20 "./powernightmare_nobarrier 800 20" 0 1 "python ./powernightmare-pt.py 20"

sleep 10

echo "End: `date`"
