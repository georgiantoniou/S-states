# Wall Power/iLo Power for different power states configuration

The aim of this experiment is to monitor the power consumption of the system in the following cases:

* power states disabled, running power virus
* power states disabled, idle
* core c-states enabled, idle
* core c-states enabled, package c-states enabled
* core c-states enabled, package c-states enabled, s-states enabled

We aim to identify what are the power savings opportunity from the platform and whether devices can autonomously enter D-States.

## Machine Configuration 
We configure the machine in the following way
* nohz = on
* uncore = default
* core = powersave
* driver = intel_pstate
* smt = off
* enabled/disabled core/package c-states from BIOS and grub both BIOS does not work for c-states
* powertop --auto-tune = doesn't matter
* S-states configuration: S-States are not supported only S0/S5

## Setting Configuration

I changed the configuration with the following way:

* `Turbo:` I used the script ./turbo-boost.sh  disable to disabled the following experiments
    * shasta_cstates_off_only_grub_turbo_off_idle
    * shasta_cstates1_on_turbo_off_idle
    * shasta_cstates1e_on_turbo_off_idle
    The rest of turbo disabled i did from the BIOS. The reason is because I noticed that when intel_pstate driver was enabled with performance  governor, and I was disabling turbo, some cores 
    still excited nominal frequency.
* `C-States:`
    * C6: remove intel_idle.max_cstate from grub file
    * C1E: disable C6 using the intel_idle.max_cstate=2 from grub file
    * C1: disable C1E using the intel_idle.max_cstate=1 from grub file
    * C0: 
        * intel_idle.max_cstate=0 idle=poll , system in C0 but consumes energy
        * intel_idle.max_cstate=0 processor.max_cstate=0/1 , system enters C1 because processor.max_cstate keeps C1 on.
        * intel_idle.max_cstate=0 idle=halt
        * intel_idle.max_cstate=0 processor.max_cstate=0/1 idle=halt
        * disable from BIOS only: does not work the system eneters C6 if grub does not contains any flags
* `Pkg C-States`: Disable/Enable from BIOS works fine
* `Frequency Driver`: From grub file disable pstates with intel_pstate=disable
* `Frequency governor`: sudo cpupower frequency-set -g performance/powersave/userspace etc