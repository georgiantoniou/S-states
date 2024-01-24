# #####################################################
# System Configuration:
# 
# Grub File: intel_idle.max_cstate=1 nohz=on intel_pstate=disable
# Pkg C-States: Disabled
# Core C-States: C1
# Turbo: Disabled
# SMT: Disabled
# Idle Governor: Menu
# Frequency Governor: Performance
# Frequency Driver: acpi_cpufreq
# Uncore Frequency: set to 2.4 GHz
#
# Goal of the Experiment: Check whether the power management agent drops requests due to time
# as a result the expected power consumption differs from the actual measured power consumption.
# Expected power consumption represents the residency multiply by the power per core per c-state
# 
# Naming Convestion for directories: 
#                                   c-states_active-socket_active-cores_active-iterations
#
#!/bin/bash

###machine details###
USERNAME=""
PASSWD=""
HOST=""

###############################Experiments for PCU Congestion################################
echo "Start: `date`"

#take measurements for socket 0 cores 5 simple loop 50K active iterations
./run_experiment.sh main simple_loop 5 180 /home/ganton12/data/exp3_pcu_congestions shasta c1_0_5_50K "./simple_loop 180 50000" 0 5 

echo "sleep 10"
sleep 10

#take measurements for socket 0 cores 10 simple loop 50K active iterations
./run_experiment.sh main simple_loop 5 180 /home/ganton12/data/exp3_pcu_congestions shasta c1_0_10_50K "./simple_loop 180 50000" 0 10 

echo "sleep 10"
sleep 10

#take measurements for socket 0 cores 15 simple loop 50K active iterations
./run_experiment.sh main simple_loop 5 180 /home/ganton12/data/exp3_pcu_congestions shasta c1_0_15_50K "./simple_loop 180 50000" 0 15 

echo "sleep 10"
sleep 10

#take measurements for socket 0 cores 20 simple loop 50K active iterations
./run_experiment.sh main simple_loop 5 180 /home/ganton12/data/exp3_pcu_congestions shasta c1_0_20_50K "./simple_loop 180 50000" 0 20


echo "sleep 10"
sleep 10

#take measurements for socket 0 cores 25 simple loop 50K active iterations
./run_experiment.sh main simple_loop 5 180 /home/ganton12/data/exp3_pcu_congestions shasta c1_0_25_50K "./simple_loop 180 50000" 0 25

echo "sleep 10"
sleep 10

#take measurements for socket 1 cores 20 simple loop 50K active iterations
./run_experiment.sh main simple_loop 5 180 /home/ganton12/data/exp3_pcu_congestions shasta c1_1_20_50K "./simple_loop 180 50000" 20 40

echo "sleep 10"
sleep 10

#take measurements for socket 0 cores 20 simple loop 100K active iterations
./run_experiment.sh main simple_loop 5 180 /home/ganton12/data/exp3_pcu_congestions shasta c1_0_20_100K "./simple_loop 180 100000" 0 20

echo "sleep 10"
sleep 10

#take measurements for socket 0 cores 20 simple loop 200K active iterations
./run_experiment.sh main simple_loop 5 180 /home/ganton12/data/exp3_pcu_congestions shasta c1_0_20_200K "./simple_loop 180 200000" 0 20

echo "sleep 10"
sleep 10

#take measurements for socket 0 cores 20 simple loop 400K active iterations
./run_experiment.sh main simple_loop 5 180 /home/ganton12/data/exp3_pcu_congestions shasta c1_0_20_400K "./simple_loop 180 400000" 0 20

echo "sleep 10"
sleep 10

#take measurements for idle loops
./run_experiment.sh main idle 5 180 /home/ganton12/data/exp3_pcu_congestions shasta c1_idle idle 0 20

echo "sleep 10"
sleep 10

echo "End: `date`"
