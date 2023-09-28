# Wall Power/iLo Power for different power states configuration

The aim of this experiment is to monitor the power consumption of the system in the following cases:

* power states disabled, running power virus
* power states disabled, idle
* core c-states enabled, idle
* core c-states enabled, package c-states enabled
* core c-states enabled, package c-states enabled, s-states enabled


## Machine Configuration 
We configure the machine in the following way
* nohz = on
* uncore = default
* core = powersave
* driver = doesnt matter
* enabled/disabled core/package c-states from BIOS
* powertop --auto-tune = doesn't matter