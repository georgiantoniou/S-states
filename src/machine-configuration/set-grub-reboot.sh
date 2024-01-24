#!/bin/bash

###################################################################################################
# This script configures properly the grub file. Specifically it takes as arguments the following:
#   -> C-States enabled: 
#       -> 0: only C0 (intel_indle.max_cstate=0 idle=poll) 
#       -> 1: C0/C1 (intel_indle.max_cstate=1)
#       -> 2: C0/C1/C1E (intel_indle.max_cstate=2)
#       -> 3: C0/C1/C1E/C6 (remove intel_indle.max_cstate from grub file if exists)
#   -> Intel P-States:
#       -> enabled: frequency driver is intel pstate (remove intel_pstate if exists)
#       -> disabled: frequency driver is acpi_cpufreq (intel_pstate=disable)
#   -> Tickless:
#       -> enabled: no timer interrupts on idle periods (nohz=on)
#       -> disabled: timer interrupts always (remove nohz=on from grub file)
#   -> Hostname: Hostname of node to change grub file
#####################################################################################################


if [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" ]]; then

    echo "Invalid argument: $1" >&2
    echo ""
    echo "Usage: $(basename $0) [0|1|2|3] [enabled|disabled] [enabled|disabled] [hostname]"
    exit 1
fi 

cstate=$1
pstate=$2
tickless=$3
host=$4
flagstoadd=""

#remove flags from grub file
ssh ganton12@$host "sudo sed -i 's/\(^GRUB_CMDLINE_LINUX=\".*\) nohz=[^[:space:]]*\(.*\"\)/\1\2/' /etc/default/grub"
ssh ganton12@$host "sudo sed -i 's/\(^GRUB_CMDLINE_LINUX=\".*\) intel_pstate=[^[:space:]]*\(.*\"\)/\1\2/' /etc/default/grub"
ssh ganton12@$host "sudo sed -i 's/\(^GRUB_CMDLINE_LINUX=\".*\) intel_idle.max_cstate=[^[:space:]]*\(.*\"\)/\1\2/' /etc/default/grub"
ssh ganton12@$host "sudo sed -i 's/\(^GRUB_CMDLINE_LINUX=\".*\) idle=[^[:space:]]*\(.*\"\)/\1\2/' /etc/default/grub"

#set cstates configuration

if [[ $cstate == "0" ]]; then
    flagstoadd=$flagstoadd"intel_idle.max_cstate=0 idle=poll"
elif [[ $cstate == "1" ]]; then
    flagstoadd=$flagstoadd"intel_idle.max_cstate=1"
elif [[ $cstate == "2" ]]; then
    flagstoadd=$flagstoadd"intel_idle.max_cstate=2"
fi

#set pstate_configuration

if [[ $pstate == "disabled" && $cstate == "3" ]]; then
    flagstoadd=$flagstoadd"intel_pstate=disable"
elif [[ $pstate == "disabled" ]]; then
    flagstoadd=$flagstoadd" intel_pstate=disable"
fi

#set tickless configuration
if [[ $pstate == "disabled" ]]; then
        flagstoadd=$flagstoadd" nohz=on"
fi

# Modify grub file
ssh ganton12@$host "sudo sed -i 's/\(^GRUB_CMDLINE_LINUX=\".*\)\"/\1 $flagstoadd\"/' /etc/default/grub"
echo "***Set following flags: $flagstoadd"

#Update grub file
#ssh ganton12@$host "sudo update-grub2"
ssh ganton12@$host "sudo grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg"

echo "***Update grub file"

#Reboot machine
echo "***Reboot $host"
ssh ganton12@$host "sudo reboot"

sleep 30

#Check if machine has booted

packets=`ping -c 1 $host | grep "received" | awk '{print $4}'`

while [[ $packets == "0" ]]; 
do
    
    sleep 30
    packets=`ping -c 1 $host | grep "received" | awk '{print $4}'`

done
echo "***$host had booted"

sleep 10