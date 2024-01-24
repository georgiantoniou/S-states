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
# Benchmark: powernightmare
# Active Cores: 1,5,10,15,20
#
# Check whether c0 hints from c0 actual differs based on the # transitions per core or
# # of concurrent cores sending transition requests
# 
# Naming Convestion for directories: 
#                                  socwatch_sleep_time_active_cores
#
#!/bin/bash

###machine details###
USERNAME=""
PASSWD=""
HOST=""

###############################Experiments Validation################################
echo "Start: `date`"

#configuration remains the same

#start with 20 active cores different sleep time

#sleep for 10us

./run_experiment.sh main powernightmare 5 120 /home/ganton12/data/exp6_powernightmare_socwatch shasta socwatch_10_20 "./powernightmare 10 20" 0 1 "python ./powernightmare-pt.py 20"

sleep 10

#sleep for 30us

./run_experiment.sh main powernightmare 5 120 /home/ganton12/data/exp6_powernightmare_socwatch shasta socwatch_30_20 "./powernightmare 30 20" 0 1 "python ./powernightmare-pt.py 20"

sleep 10

#sleep for 40us

./run_experiment.sh main powernightmare 5 120 /home/ganton12/data/exp6_powernightmare_socwatch shasta socwatch_40_20 "./powernightmare 40 20" 0 1 "python ./powernightmare-pt.py 20"

sleep 10

#sleep for 800us

./run_experiment.sh main powernightmare 5 120 /home/ganton12/data/exp6_powernightmare_socwatch shasta socwatch_800_20 "./powernightmare 800 20" 0 1 "python ./powernightmare-pt.py 20"

sleep 10


#40us sleep time different active cores

#sleep for 40us 15 threads

./run_experiment.sh main powernightmare 5 120 /home/ganton12/data/exp6_powernightmare_socwatch shasta socwatch_40_15 "./powernightmare 40 15" 0 1 "python ./powernightmare-pt.py 15"

sleep 10

#sleep for 40us 10 threads

./run_experiment.sh main powernightmare 5 120 /home/ganton12/data/exp6_powernightmare_socwatch shasta socwatch_40_10 "./powernightmare 40 10" 0 1 "python ./powernightmare-pt.py 10"

sleep 10

#sleep for 40us 5 threads

./run_experiment.sh main powernightmare 5 120 /home/ganton12/data/exp6_powernightmare_socwatch shasta socwatch_40_5 "./powernightmare 40 5" 0 1 "python ./powernightmare-pt.py 5"

sleep 10

#sleep for 40us 1 threads

./run_experiment.sh main powernightmare 5 120 /home/ganton12/data/exp6_powernightmare_socwatch shasta socwatch_40_1 "./powernightmare 40 1" 0 1 "python ./powernightmare-pt.py 1"

sleep 10

echo "End: `date`"
