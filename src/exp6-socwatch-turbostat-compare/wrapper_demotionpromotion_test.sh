# #####################################################
# System Configuration:
# 
# Grub File: nohz=on intel_pstate=disable
# Pkg C-States: Disabled
# Core C-States: C6
# Turbo: Disabled
# SMT: Disabled
# Idle Governor: Menu
# Frequency Governor: Performance
# Frequency Driver: acpi_cpufreq
# Uncore Frequency: set to 2.4 GHz
# Benchmark: idle, powernightmare
# Active Cores: 20
#
# Check whether disable/enable promotion demotion works
# 
# Naming Convestion for directories: 
#                                   idlegovernor_promotion/demotion
#
#!/bin/bash

###machine details###
USERNAME=""
PASSWD=""
HOST=""

###############################Experiments Shasta Validation################################
echo "Start: `date`"

#check whether disable C1E autopromotion works with idle

#disable idle governor c1e and c6 options
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "1" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state3/disable"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "1" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state2/disable"

sleep 5
# take measurements when system is idle
./run_experiment.sh main idle 5 120 /home/ganton12/data/exp6_validate_promotion_demotion shasta c1_promotion_disabled "idle" 0 1 "idle" 

sleep 10
#disable idle governor c6 options
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "1" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state3/disable"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "0" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state2/disable"

sleep 5
# take measurements when system is idle
./run_experiment.sh main idle 5 120 /home/ganton12/data/exp6_validate_promotion_demotion shasta c1c1e_promotion_disabled "idle" 0 1 "idle" 

sleep 10
# Check whether demotion works with idle
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "0" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state3/disable"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "1" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state2/disable"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "1" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state1/disable"

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo wrmsr 0xe2 0x10008400 -a"

sleep 5
# take measurements when system is idle
./run_experiment.sh main idle 5 120 /home/ganton12/data/exp6_validate_promotion_demotion shasta c6_demotionc1_disabled "idle" 0 1 "idle" 

sleep 10
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "0" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state3/disable"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "1" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state2/disable"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "1" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state1/disable"

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo wrmsr 0xe2 0x18008400 -a"

sleep 5
# take measurements when system is idle
./run_experiment.sh main idle 5 120 /home/ganton12/data/exp6_validate_promotion_demotion shasta c6_demotionc1c1e_disabled "idle" 0 1 "idle" 

sleep 10

# Check whether demotion works with active
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "0" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state3/disable"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "1" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state2/disable"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "1" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state1/disable"

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo wrmsr 0xe2 0x10008400 -a"

sleep 5
./run_experiment.sh main powernightmare 5 120 /home/ganton12/data/exp6_validate_promotion_demotion shasta c6_demotionc1_disabled "./powernightmare 800 20" 0 1 "python ./powernightmare-pt.py 20"

sleep 10

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "0" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state3/disable"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "1" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state2/disable"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "1" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state1/disable"

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo wrmsr 0xe2 0x18008400 -a"
sleep 5
./run_experiment.sh main powernightmare 5 120 /home/ganton12/data/exp6_validate_promotion_demotion shasta c6_demotionc1c1e_disabled "./powernightmare 800 20" 0 1 "python ./powernightmare-pt.py 20"

sleep 10

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "0" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state3/disable"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "0" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state2/disable"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "echo "0" |sudo tee /sys/devices/system/cpu/cpu*/cpuidle/state1/disable"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo wrmsr 0xe2 0x8400 -a"

echo "End: `date`"
