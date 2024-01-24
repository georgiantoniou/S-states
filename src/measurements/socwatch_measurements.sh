#!/bin/bash
###########################################################################################################
# This script takes power measurements such as power consumption hardware c-state and p-state residency
# using socwatch. Below are the options on how to use socwatch to take measurements.
# 
# Format of the command: socwatch [general options] [post-processing options] [collection options]
# General Options:
#                     -h, --help       Display text describing options and usage
#                    -v, --version       Display tool version info
#             -l, --log <filename>       Save console output to the specified file
#                      --print-fms       Display CPU ID as Family.Model.Stepping
#
# Post-processing Options:
#              --no-post-processing       Do not automatically summarize data and do not generate any reports at the end of collection.  Use options --input and --result to generate reports from the intermediate files at a later time.
#         -i, --input <collection-name>   Specify the collection name (with full path) of an existing collection to generate reports
#         -o, --output <collection-name>  Specify output collection name [default "SoCWatchOutput"]
#             -r, --result <format>       Specify output file format from list below

#         Valid Output Formats:
#                                  sum    Write summary reports for all collected metrics to CSV file [default]
#                                vtune    Write data trace file (.pwr) in import format for visualization with Intel VTune Amplifier
#                                 json    Write data trace file (.swjson) in JSON format for visualization with Intel System Studio
#                                  int    Write data trace file (*_trace.csv) in CSV format
#                                 auto    Write summary data as single line to file Automation_Summary.csv


# Collection Options:
#           -f, --feature <feature>       Specify data to collect using Individual Feature or Feature Group name listed below
#                  -m, --max-detail       Collect over-time data for every feature specified
#         -n, --interval <milliseconds>   Change minimum time between collection points [default 100 ms]
#           -o, --output <filename>       Specify output file name prefix [default "SoCWatchOutput"]
#         -p, --program <executable>      Specify executable to be started prior to collection, all characters following executable name are given it as arguments
#         -s, --startdelay <seconds>      Time to wait before starting collection
#              -t, --time <seconds>       Collection duration (if omitted will collect until Ctrl-C entered)
#         -z, --auto-connected-standby    Automatically enter Connected Standby for the duration of the collection
#             --program-delay <seconds>   Time to wait before starting a program specified by "-p" option
#                         --polling       Collect data at timed intervals rather than context switch points

#         Feature Group:
#                                  cpu    core-temp, hw-cpu-cstate, hw-cpu-pstate, ia-throt-rsn
#                           cpu-cstate    hw-cpu-cstate
#                               cpu-hw    core-temp, hw-cpu-cstate, hw-cpu-pstate, ia-throt-rsn
#                           cpu-pstate    hw-cpu-pstate, ia-throt-rsn
#                                power    pkg-pwr, dram-pwr
#                            sa-pstate    ring-throt-rsn
#                               sstate    acpi-sstate
#                                  sys    core-temp, hw-cpu-cstate, hw-cpu-pstate, ia-throt-rsn, ring-throt-rsn, pkg-pwr, dram-pwr, acpi-sstate
#                                 temp    core-temp
#                                throt    ia-throt-rsn, ring-throt-rsn

#         Individual Features: 
#                          acpi-sstate    Measure acpi sstate residencies
#                            core-temp    CPU Core temperature statistics
#                            core-volt    Measure core voltage
#                             dram-pwr    DRAM power statistics
#                        hw-cpu-cstate    CPU C-state (Package, Core, etc.) Cx residency (hardware measured)
#                        hw-cpu-pstate    CPU Per-logical-processor P-state residency (hardware measured)
#                         ia-throt-rsn    CPU Core performance throttling reasons
#                              pkg-pwr    Package power statistics
#                       ring-throt-rsn    Ring performance throttling reasons
#
# Important Note! This directory /opt/intel/oneapi/vtune/latest/socwatch/x64/configs contains all the 
# MSR registers used by SocWatch to monitor its metrics
# 
# Examples:
#           sudo ./socwatch -l socwatch_log -o collection_output_file -f hw-cpu-cstate -t 180 (measure only hardware c-state, used commonly)
#         
##############################################################################################################


##################################################
# Start measuring system HW C-State residency
# argument 1: Password
# argument 2: Username
# argument 3: Hostname
# argument 4: Command
##################################################
start_measurements () {

    sshpass -p "$1" ssh -f $2@$3 "hostname; $4 &"

}

##################################################
# Stop measuring DRAM residency
##################################################
stop_measurements () {
   
    sleep 5
    sshpass -p "$1" ssh -f $2@$3 "sudo pkill socwatch"
    
}

##################################################
# Report C-State residency measurements
# argument 1: Password
# argument 2: Username
# argument 3: Hostname
##################################################
report_measurements () {

    sshpass -p $1 ssh -f $2@$3 "cat $4;" 
    #rm dram_mode_perf_output"

}

main () {

    if [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" || -z "$5" || -z "$6" || -z "$7" ]]; then

        echo "***ERROR: Wrong Arguments***"
        echo "***SYNTAX: ./socwatch_measurements.sh general_options post_processing_options collection_options exec_time username password hostname"
        echo "  Format of the command: socwatch [general options] [post-processing options] [collection options]
                General Options:
                                    -h, --help       Display text describing options and usage
                                -v, --version       Display tool version info
                            -l, --log <filename>       Save console output to the specified file
                                    --print-fms       Display CPU ID as Family.Model.Stepping

                Post-processing Options:
                            --no-post-processing       Do not automatically summarize data and do not generate any reports at the end of collection.  Use options --input and --result to generate reports from the intermediate files at a later time.
                        -i, --input <collection-name>   Specify the collection name (with full path) of an existing collection to generate reports
                        -o, --output <collection-name>  Specify output collection name [default "SoCWatchOutput"]
                            -r, --result <format>       Specify output file format from list below

                        Valid Output Formats:
                                                sum    Write summary reports for all collected metrics to CSV file [default]
                                            vtune    Write data trace file (.pwr) in import format for visualization with Intel VTune Amplifier
                                                json    Write data trace file (.swjson) in JSON format for visualization with Intel System Studio
                                                int    Write data trace file (*_trace.csv) in CSV format
                                                auto    Write summary data as single line to file Automation_Summary.csv


                Collection Options:
                        -f, --feature <feature>       Specify data to collect using Individual Feature or Feature Group name listed below
                                -m, --max-detail       Collect over-time data for every feature specified
                        -n, --interval <milliseconds>   Change minimum time between collection points [default 100 ms]
                        -o, --output <filename>       Specify output file name prefix [default "SoCWatchOutput"]
                        -p, --program <executable>      Specify executable to be started prior to collection, all characters following executable name are given it as arguments
                        -s, --startdelay <seconds>      Time to wait before starting collection
                            -t, --time <seconds>       Collection duration (if omitted will collect until Ctrl-C entered)
                        -z, --auto-connected-standby    Automatically enter Connected Standby for the duration of the collection
                            --program-delay <seconds>   Time to wait before starting a program specified by "-p" option
                                        --polling       Collect data at timed intervals rather than context switch points

                        Feature Group:
                                                cpu    core-temp, hw-cpu-cstate, hw-cpu-pstate, ia-throt-rsn
                                        cpu-cstate    hw-cpu-cstate
                                            cpu-hw    core-temp, hw-cpu-cstate, hw-cpu-pstate, ia-throt-rsn
                                        cpu-pstate    hw-cpu-pstate, ia-throt-rsn
                                            power    pkg-pwr, dram-pwr
                                        sa-pstate    ring-throt-rsn
                                            sstate    acpi-sstate
                                                sys    core-temp, hw-cpu-cstate, hw-cpu-pstate, ia-throt-rsn, ring-throt-rsn, pkg-pwr, dram-pwr, acpi-sstate
                                                temp    core-temp
                                            throt    ia-throt-rsn, ring-throt-rsn

                        Individual Features: 
                                        acpi-sstate    Measure acpi sstate residencies
                                        core-temp    CPU Core temperature statistics
                                        core-volt    Measure core voltage
                                            dram-pwr    DRAM power statistics
                                    hw-cpu-cstate    CPU C-state (Package, Core, etc.) Cx residency (hardware measured)
                                    hw-cpu-pstate    CPU Per-logical-processor P-state residency (hardware measured)
                                        ia-throt-rsn    CPU Core performance throttling reasons
                                            pkg-pwr    Package power statistics
                                    ring-throt-rsn    Ring performance throttling reasons
"
        exit;   
    fi 

    general_options=$1
    post_processing_options=$2 
    collection_options=$3
    exectime=$4  
    username=$5
    password=$6
    host=$7

    SOC_PATH="/opt/intel/oneapi/vtune/latest/socwatch/x64/socwatch"

    command="sudo "$SOC_PATH
    if [ "$general_options" != " " ]; then 
        command=$command" "$general_options
    fi
    
    if [ "$post_processing_options" != " " ]; then 
        command=$command" "$post_processing_options
    fi

    if [ "$collection_options" != " " ]; then 
        command=$command" "$collection_options
    fi

    command=$command" -t "$exectime
    #command="sudo perf stat -e "$events" -x \" \" -a --per-socket sleep "$exectime 
       
    start_measurements $password $username $host "$command" 

}
"$@"