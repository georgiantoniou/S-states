#!/bin/bash

#disable smt
#echo off |sudo tee /sys/devices/system/cpu/smt/control

#fixed uncore frequency
sudo modprobe msr
sudo wrmsr 0x620 0x1818

# put frequency governor to performance

sudo cpupower frequency-set -g performance

#disable turbo

#~/S-states/src/machine-configuration/turbo-boost.sh disable