#!/bin/bash

###################################################################################################
# This script installs library dependencies
#   
#####################################################################################################

sudo apt-get install msr-tools
sudo apt install linux-tools-4.15.0-213-generic
sudo apt-get install build-essential linux-source bc kmod cpio flex libncurses5-dev libelf-dev libssl-dev
sudo apt install sysstat

#install newer turbostat version for ubuntu 18.04
sudo mkdir /myturbostat
sudo chmod a+rwx /myturbostat/
cd /myturbostat/
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.4.10.tar.xz
tar -xf linux-5.4.10.tar.xz
cd /myturbostat/linux-5.4.10/tools/power/x86/turbostat/
sudo make -C turbostat
cp /myturbostat/linux-5.4.10/tools/power/x86/turbostat/turbostat /usr/local/bin
sudo chmod 777 /usr/local/bin/turbostat
