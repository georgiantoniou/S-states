# #####################################################
# System Configuration:
# 
# Grub File: intel_idle.max_cstate=0 nohz=on intel_pstate=disable
# Pkg C-States: Disabled
# Core C-States: C0
# Turbo: Disabled
# SMT: Disabled
# Idle Governor: Menu
# Frequency Governor: Userspacw
# Frequency: 2.1, 2, 1.6, 1.2, 0.8
# Frequency Driver: acpi_cpufreq
# Uncore Frequency: set to 2.4 GHz
# Benchmark: idle, power virus
# Active Cores: 20
#
# Goal of the Experiment: Check whether the power consumption of rapl agrees with ilo on average
#                           and also on measurements (timestamps)
# 
# Naming Convestion for directories: 
#                                   c-states_active_Frequency
#
#!/bin/bash

###machine details###
USERNAME=""
PASSWD=""
HOST=""

###############################Experiments Shasta Validation################################
echo "Start: `date`"

# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 2.1GHz"

# #take measurements when power virus running
# ./run_experiment.sh main power_virus 5 180 /home/ganton12/data/exp5_rapl_ilo_compare shasta c0_2-1 "./power_virus" 0 20 
# echo "sleep 10"
# sleep 10

# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 2GHz"

# #take measurements when power virus running
# ./run_experiment.sh main power_virus 5 180 /home/ganton12/data/exp5_rapl_ilo_compare shasta c0_2 "./power_virus" 0 20 
# echo "sleep 10"
# sleep 10

# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 1.6GHz"

# #take measurements when power virus running
# ./run_experiment.sh main power_virus 5 180 /home/ganton12/data/exp5_rapl_ilo_compare shasta c0_1-6 "./power_virus" 0 20 
# echo "sleep 10"
# sleep 10

# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 1.2GHz"

# #take measurements when power virus running
# ./run_experiment.sh main power_virus 5 180 /home/ganton12/data/exp5_rapl_ilo_compare shasta c0_1-2 "./power_virus" 0 20 
# echo "sleep 10"
# sleep 10

# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 800MHz"

# #take measurements when power virus running
# ./run_experiment.sh main power_virus 5 180 /home/ganton12/data/exp5_rapl_ilo_compare shasta c0_0-8 "./power_virus" 0 20 
# echo "sleep 10"
# sleep 10


sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 2.1GHz"

# ##### idle experiments #######
./run_experiment.sh main idle 5 180 /home/ganton12/data/exp5_power_cstate_vary_uncore shasta c0_2-1 idle 0 1

echo "sleep 10"
sleep 10

# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 2GHz"

# ##### idle experiments #######
# ./run_experiment.sh main idle 5 180 /home/ganton12/data/exp5_power_cstate_vary_uncore shasta c0_2 idle 0 1

# echo "sleep 10"
# sleep 10

# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 1.6GHz"

# # ##### idle experiments #######
# ./run_experiment.sh main idle 5 180 /home/ganton12/data/exp5_power_cstate_vary_uncore shasta c0_1-6 idle 0 1

# echo "sleep 10"
# sleep 10

# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 1.2GHz"

# # ##### idle experiments #######
# ./run_experiment.sh main idle 5 180 /home/ganton12/data/exp5_power_cstate_vary_uncore shasta c0_1-2 idle 0 1

# echo "sleep 10"
# sleep 10

# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 800MHz"

# # ##### idle experiments #######
# ./run_experiment.sh main idle 5 180 /home/ganton12/data/exp5_power_cstate_vary_uncore shasta c0_0-8 idle 0 1

# echo "sleep 10"
# sleep 10

echo "End: `date`"
