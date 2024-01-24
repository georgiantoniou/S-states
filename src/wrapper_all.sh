#!/bin/bash


#first run power consumption per c-state

# C6 Experiment

/home/ganton12/S-states/src/machine-configuration/set-grub-reboot.sh 3 disabled enabled shasta

ssh ganton12@shasta "/home/ganton12/S-states/src/machine-configuration/configure.sh"

sleep 10
cd /home/ganton12/S-states/src/exp5-rapl-ilo-compare/
./wrapper_c6_results.sh &> wrapper_c6_results.out

# C1E Experiment
/home/ganton12/S-states/src/machine-configuration/set-grub-reboot.sh 2 disabled enabled shasta

ssh ganton12@shasta "/home/ganton12/S-states/src/machine-configuration/configure.sh"

sleep 10

./wrapper_c1e_results.sh &> wrapper_c1e_results.out

# C1 Experiment
/home/ganton12/S-states/src/machine-configuration/set-grub-reboot.sh 1 disabled enabled shasta

ssh ganton12@shasta "/home/ganton12/S-states/src/machine-configuration/configure.sh"

sleep 10

./wrapper_c1_results.sh &> wrapper_c1_results.out

# C0 Experiment
/home/ganton12/S-states/src/machine-configuration/set-grub-reboot.sh 0 disabled enabled shasta

ssh ganton12@shasta "/home/ganton12/S-states/src/machine-configuration/configure.sh"

sleep 10

./wrapper_c0_results.sh &> wrapper_c0_results.out


# Then run demotion promotion with simpletime
/home/ganton12/S-states/src/machine-configuration/set-grub-reboot.sh 3 disabled enabled shasta

ssh ganton12@shasta "/home/ganton12/S-states/src/machine-configuration/configure.sh"

ssh ganton12@shasta "sudo wrmsr 0x620 0x1818"

# Then run pcu congestion analysis with simple-time benchmark and governors performance and userspace

sleep 10

cd /home/ganton12/S-states/src/exp6-socwatch-turbostat-compare/

./wrapper_simpletime_pcu_congestion_demotionpromotion.sh &> ./wrapper_simpletime_pcu_congestion_demotionpromotion.out 


