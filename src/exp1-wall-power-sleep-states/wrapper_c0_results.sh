# #####################################################
# # cstates have been disabled with 
# # intel_idle.max_cstate=0 and processor.max_cstate=0
# # measure power consumption of the system for different
# # governors (performance,powersave) and turbo enabled/
# # disabled. The frequency driver is intel_pstates
# #
#!/bin/bash

###machine details###
USERNAME=""
PASSWD=""
HOST=""


# ################################Configuration for intel_pstate enabled################################
# echo "Start: `date`"
# #configure machine
# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g performance"
# # #sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "~/turbo-boost.sh enable"

# echo "sleep 10"
# sleep 10

# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-info"
# #sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "cat /proc/cpuinfo | grep MHz | tr \"\n\" \" \" "


# echo "sleep 20"
# sleep 20

# #take measurements for idle
# ./run_experiment.sh main idle 5 180 /home/ganton12/data/exp1-wall-power-sleep-states/ shasta cstates_off_intel_processor_idle_halt_turbo_off_intel_pstate_performance 

# # # #configure machine
# # # sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "~/turbo-boost.sh disable"

# # # echo "sleep 10"
# # # sleep 10

# # # sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "cat /proc/cpuinfo | grep MHz | tr \"\n\" \" \" "

# # # echo "sleep 20"
# # # sleep 20

# # # #take measurements for idle
# # # ./run_experiment.sh main idle 5 180 /home/ganton12/data/exp1-wall-power-sleep-states/ shasta cstates_on_intel_processor_max_cstate_turbo_off_intel_pstate_performance


# #configure machines 
# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g powersave"
# #sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "~/turbo-boost.sh enable"

# echo "sleep 10"
# sleep 10

# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-info"
# #sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "cat /proc/cpuinfo | grep MHz | tr \"\n\" \" \" "

# echo "sleep 20"
# sleep 20

# #take measurements for idle
# ./run_experiment.sh main idle 5 180 /home/ganton12/data/exp1-wall-power-sleep-states/ shasta cstates_off_intel_processor_idle_halt_turbo_off_intel_pstate_powersave

# # # #configure machine
# # # sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "~/turbo-boost.sh disable"

# # # echo "sleep 10"
# # # sleep 10

# # # sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "cat /proc/cpuinfo | grep MHz | tr \"\n\" \" \" "

# # # echo "sleep 20"
# # # sleep 20

# # # #take measurements for idle
# # # ./run_experiment.sh main idle 5 180 /home/ganton12/data/exp1-wall-power-sleep-states/ shasta cstates_on_intel_processor_max_cstate_turbo_off_intel_pstate_powersave

# echo "End: `date`"


###############################Configuration for acpi_cpufreq enabled################################
echo "Start: `date`"
#configure machine
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g performance"
#sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "~/turbo-boost.sh enable"

echo "sleep 10"
sleep 10

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-info"
#sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "cat /proc/cpuinfo | grep MHz | tr \"\n\" \" \" "


echo "sleep 20"
sleep 20

#take measurements for idle
./run_experiment.sh main idle 5 180 /home/ganton12/data/exp1-wall-power-sleep-states/ shasta cstates1_on_turbo_off_acpi_cpufreq_performance 

# #configure machine
# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "~/turbo-boost.sh disable"

# echo "sleep 10"
# sleep 10

# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "cat /proc/cpuinfo | grep MHz | tr \"\n\" \" \" "

# echo "sleep 20"
# sleep 20

# #take measurements for idle
# ./run_experiment.sh main idle 5 180 /home/ganton12/data/exp1-wall-power-sleep-states/ shasta cstates_off_intel_processor_idle_halt_turbo_off_intel_pstate_performance


#configure machines 
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g powersave"
#sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "~/turbo-boost.sh enable"

echo "sleep 10"
sleep 10

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-info"
#sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "cat /proc/cpuinfo | grep MHz | tr \"\n\" \" \" "

echo "sleep 20"
sleep 20

#take measurements for idle
./run_experiment.sh main idle 5 180 /home/ganton12/data/exp1-wall-power-sleep-states/ shasta cstates1_on_turbo_off_acpi_cpufreq_powersave

# #configure machine
# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "~/turbo-boost.sh disable"

# echo "sleep 10"
# sleep 10

# sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "cat /proc/cpuinfo | grep MHz | tr \"\n\" \" \" "

# echo "sleep 20"
# sleep 20

# #take measurements for idle
# ./run_experiment.sh main idle 5 180 /home/ganton12/data/exp1-wall-power-sleep-states/ shasta cstates_off_intel_processor_idle_halt_turbo_off_intel_pstate_powersave

#configure machines 
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 2100MHz"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -d 2100MHz"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -u 2100MHz"

#sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "~/turbo-boost.sh enable"

echo "sleep 10"
sleep 10

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-info"
#sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "cat /proc/cpuinfo | grep MHz | tr \"\n\" \" \" "

echo "sleep 20"
sleep 20

#take measurements for idle
./run_experiment.sh main idle 5 180 /home/ganton12/data/exp1-wall-power-sleep-states/ shasta cstates1_on_turbo_off_acpi_cpufreq_userspace


echo "End: `date`"
