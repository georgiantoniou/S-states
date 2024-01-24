#!/bin/bash
###########################################################################################################
# This script takes residency measurements for dram using performance counters on cascade lake.
# The counters used for the residency measurements are the following:
# UNC_M_CLOCKTICKS: Counts clockticks of the fixed frequency clock of the memory controller 
#                   using one of the programmable counters. (EventSel=00H, UMask=00H, Counter=0,1,2,3)
#  
# UNC_M_POWER_CKE_CYCLES.RANK(0-7): Number of cycles spent in CKE ON mode. The filter allows you to select
#                                   a rank to monitor. If multiple ranks are in CKE ON mode at one time,
#                                   the counter will ONLY increment by one rather than doing accumulation.
#                                   Multiple counters will need to be used to track multiple ranks 
#                                   simultaneously. There is no distinction between the different CKE modes
#                                   (APD, PPDS, PPDF). This can be determined based on the system
#                                   programming. These events should commonly be used with Invert to get the
#                                   the number of cycles in power saving mode. Edge Detect is also useful
#                                   here. Make sure that you do NOT use Invert with Edge Detect (this just
#                                   confuses the system and is not necessary). (EventSel=83H, UMask=01H,
#                                   02H,04H,08H,10H,20H,40H,80H,Counter=0,1,2,3)
# UNC_M_POWER_CHANNEL_PPD:  Counts cycles when all the ranks in the channel are in PPD (PreCharge Power 
#                           Down) mode. If IBT (Input Buffer Terminators)=off is enabled, then this event
#                           counts the cycles n PPD mode. If IBT=off is not enabled, then this event counts
#                           the number of cycles when being in PPD mode could have been taken advantage of.
#                           (EventSel=85H, UMask=00H, Counter=0,1,2,3)
# UNC_M_POWER_SELF_REFRESH:    Counts the number of cycles when the iMC (memory controller is in the 
#                              self-refresh and has a clock. This happens in some ACPI CPU package 
#                              C-states for the sleep levels. For example the PCU (Power Control Unit) may
#                              ask the iMC to enter self-refresh even though some of the cores are still 
#                              processing. One use of this is for Intel Dynamic Power Technology. Self-
#                              refresh is required during package C3 and C6, but there is no clock in the
#                              iMC at this time, so it is not possible to count these cases. 
#                              (EventSel=43H, UMask=00H, Counter=0,1,2,3)
#
##############################################################################################################


##################################################
# Start measuring system C-State residency
# argument 1: Password
# argument 2: Username
# argument 3: Hostname
# argument 4: Command
##################################################
start_measurements () {

    sshpass -p "$1" ssh -f $2@$3 "hostname; $4 &> dram_mode_perf_output &"

}

##################################################
# Stop measuring DRAM residency
##################################################
stop_measurements () {
   
    sleep 5
    sshpass -p "$1" ssh -f $2@$3 "sudo pkill perf"
    
}

##################################################
# Report C-State residency measurements
# argument 1: Password
# argument 2: Username
# argument 3: Hostname
##################################################
report_measurements () {

    sshpass -p $1 ssh -f $2@$3 "cat dram_mode_perf_output;" 
    #rm dram_mode_perf_output"

}

main () {

    if [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" ]]; then

        echo "***ERROR: Wrong Arguments***"
        echo "***SYNTAX: ./dram_powermode_measurements.sh time username password hostname"
        exit;   
    fi 

    exectime=$1  
    username=$2
    password=$3
    host=$4

    ############################################################################################
    # Per event counter used:
    #       
    #       uncore_imc/clockticks/              : Memory Controller Clock Ticks
    #       uncore_imc_0/event=0x83,umask=*/    : Cycles spend in CKE ON
    #       uncore_imc/event=0x85,umask=*/      : All ranks in PPD
    #       uncore_imc/event=0x43,umask=*/      : DRAM in self - refresh and memory controller 
    #                                             has clock
    #############################################################################################
    

    events="uncore_imc_0/clockticks/,uncore_imc_1/clockticks/,uncore_imc_2/clockticks/,uncore_imc_3/clockticks/,uncore_imc_4/clockticks/,uncore_imc_5/clockticks/,\
uncore_imc_0/event=0x83,umask=0x01/,uncore_imc_0/event=0x83,umask=0x02/,uncore_imc_1/event=0x83,umask=0x01/,uncore_imc_1/event=0x83,umask=0x02/,uncore_imc_2/event=0x83,umask=0x01/,uncore_imc_2/event=0x83,umask=0x02/,\
uncore_imc_3/event=0x83,umask=0x01/,uncore_imc_3/event=0x83,umask=0x02/,uncore_imc_4/event=0x83,umask=0x01/,uncore_imc_4/event=0x83,umask=0x02/,uncore_imc_5/event=0x83,umask=0x01/,uncore_imc_5/event=0x83,umask=0x02/,\
uncore_imc/event=0x85,umask=0x00/,uncore_imc/event=0x43,umask=0x00/"

    command="sudo perf stat -e "$events" -x \" \" -a --per-socket sleep "$exectime 
      
    #echo "$command"
        
    start_measurements $password $username $host "$command" 

}
"$@"