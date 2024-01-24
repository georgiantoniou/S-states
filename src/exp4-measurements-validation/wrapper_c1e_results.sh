# #####################################################
# System Configuration:
# 
# Grub File: intel_idle.max_cstate=1 nohz=on intel_pstate=disable
# Pkg C-States: Disabled
# Core C-States: C1E
# Turbo: Disabled
# SMT: Disabled
# Idle Governor: Menu
# Frequency Governor: Performance
# Frequency Driver: acpi_cpufreq
# Uncore Frequency: set to 2.4 GHz
#
# Goal of the Experiment: Validate the power measurements on shasta
# 
# Naming Convestion for directories: 
#                                   c-states_active-socket_active-cores_active-iterations
#
#!/bin/bash

###machine details###
USERNAME=""
PASSWD=""
HOST=""

###############################Experiments Shasta Validation################################
echo "Start: `date`"

##### simple loop experiments #######

./run_experiment.sh main power_virus 5 180 /home/ganton12/data/exp4_shasta_validation shasta c1e_0_1 "./power_virus" 0 1 
echo "sleep 10"
sleep 10

./run_experiment.sh main power_virus 5 180 /home/ganton12/data/exp4_shasta_validation shasta c1e_0_5 "./power_virus" 0 5 
echo "sleep 10"
sleep 10

./run_experiment.sh main power_virus 5 180 /home/ganton12/data/exp4_shasta_validation shasta c1e_0_10 "./power_virus" 0 10 
echo "sleep 10"
sleep 10

./run_experiment.sh main power_virus 5 180 /home/ganton12/data/exp4_shasta_validation shasta c1e_0_15 "./power_virus" 0 15 
echo "sleep 10"
sleep 10

./run_experiment.sh main power_virus 5 180 /home/ganton12/data/exp4_shasta_validation shasta c1e_0_20 "./power_virus" 0 20 
echo "sleep 10"
sleep 10

##### idle experiments #######
./run_experiment.sh main idle 5 180 /home/ganton12/data/exp4_shasta_validation shasta c1e_idle idle 0 1

echo "sleep 10"
sleep 10

echo "End: `date`"
