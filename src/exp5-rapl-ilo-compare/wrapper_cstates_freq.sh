###machine details###
USERNAME=""
PASSWD=""
HOST=""


/home/ganton12/S-states/src/machine-configuration/set-grub-reboot.sh 3 disabled enabled shasta

ssh ganton12@shasta "/home/ganton12/S-states/src/machine-configuration/configure.sh"

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 2GHz"

sleep 5

./run_experiment.sh main idle 5 120 /home/ganton12/data/exp5_rapl_ilo_compare shasta c6_2 idle 0 1

sleep 10

/home/ganton12/S-states/src/machine-configuration/set-grub-reboot.sh 2 disabled enabled shasta

ssh ganton12@shasta "/home/ganton12/S-states/src/machine-configuration/configure.sh"

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 2GHz"

sleep 5

./run_experiment.sh main idle 5 120 /home/ganton12/data/exp5_rapl_ilo_compare shasta c1e_2 idle 0 1

sleep 10

/home/ganton12/S-states/src/machine-configuration/set-grub-reboot.sh 1 disabled enabled shasta

ssh ganton12@shasta "/home/ganton12/S-states/src/machine-configuration/configure.sh"

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 2GHz"

sleep 5

./run_experiment.sh main idle 5 120 /home/ganton12/data/exp5_rapl_ilo_compare shasta c1_2 idle 0 1

sleep 10

/home/ganton12/S-states/src/machine-configuration/set-grub-reboot.sh 0 disabled enabled shasta

ssh ganton12@shasta "/home/ganton12/S-states/src/machine-configuration/configure.sh"

sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -g userspace"
sshpass -p "$PASSWD" ssh -f $USERNAME@$HOST "sudo cpupower frequency-set -f 2GHz"

sleep 5

./run_experiment.sh main idle 5 120 /home/ganton12/data/exp5_rapl_ilo_compare shasta c0_2_2 idle 0 1


echo "End: `date`"
