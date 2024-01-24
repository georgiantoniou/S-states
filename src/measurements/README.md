# Measurements 
This directory contains scripts for measurements. They have been tested on shasta. A server machine with the following specifications:

lscpu output:
```
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                40
On-line CPU(s) list:   0-39
Thread(s) per core:    1
Core(s) per socket:    20
Socket(s):             2
NUMA node(s):          2
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 85
Model name:            Intel(R) Xeon(R) Gold 5218R CPU @ 2.10GHz
Stepping:              7
CPU MHz:               2000.000
CPU max MHz:           2100.0000
CPU min MHz:           800.0000
BogoMIPS:              4200.00
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              1024K
L3 cache:              28160K
NUMA node0 CPU(s):     0-19
NUMA node1 CPU(s):     20-39
Flags:                 fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm 3dnowprefetch epb cat_l3 cdp_l3 invpcid_single intel_ppin ssbd mba rsb_ctxsw ibrs ibpb stibp ibrs_enhanced tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm cqm mpx rdt_a avx512f avx512dq rdseed adx smap clflushopt clwb intel_pt avx512cd avx512bw avx512vl xsaveopt xsavec xgetbv1 cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local dtherm arat pln pts hwp hwp_act_window hwp_pkg_req pku ospke avx512_vnni md_clear spec_ctrl intel_stibp flush_l1d arch_capabilities
```

OS:
```
CentOS 7
```

kernel version:
```
3.10
```

## Scripts

### `iLO_power.py`
This script fetches the power measurements generated from iLo console. It fetches the power measurements from the last 20 minutes. It uses the fast powermeter which returns a sample every 10 seconds and reports the min,max and average overall power consumption. Additionally, it monitors the power consumption of the cpu and the dim. The syntax of the command is the following:

prerequisites: 
```
pip install python-ilorest-library
```
run commands:
``` 
python3 ./iLO_power.py username password url
```

### `pdu.py`
This script monitors the power consumption, samples every x seconds (usually 5 is not fixed) from the power supply of shasta. It monitors the wall power.

run commands:
```
python3 ./pdu.py username password hostname time
```

### `turbostat_residency.sh`
This script monitors the core, pkg c-states residency and power (core, pkg RAPL) every x seconds for y iterations for a remote machine. 

prerequisites: 
```
sudo apt install linux-tools-common linux-tools-$(uname -r)
#in case turbostat version is old and does not support the syntax of our script 
#install newer turbostat version from source code
sudo mkdir /myturbostat
sudo chmod a+rwx /myturbostat/
cd /myturbostat/
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.4.10.tar.xz
tar -xf linux-5.4.10.tar.xz
cd /myturbostat/linux-5.4.10/tools/power/x86/turbostat/
sudo make -C turbostat
cp /myturbostat/linux-5.4.10/tools/power/x86/turbostat/turbostat /usr/local/bin
sudo chmod 777 /usr/local/bin/turbostat
```
run commands:
```
chmod 777 ./turbostat_residency.sh

#start measurements
./turbostat_residency.sh main number_of_iterations interval USERNAME PASSWD HOST

#stop measurements
./turbostat_residency.sh stop_measurements PASSWD USERNAME HOST 

#report measurements
./turbostat_residency.sh report_measurements PASSWD USERNAME HOST &> output_file
```

### `socwatch_measurements.sh`
This script monitors amongh other things the hardware core c-state residency using intel socwatch tool. Inside the script there are more details on how you can run it with different parameters. I have only tested the script with the summary report.

prerequisites (already installed on shasta): 
```
wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \ | gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list

sudo apt update

sudo apt install intel-basekit

#Installation guidelines change regularly so its good to check with webpage (https://www.intel.com/content/www/us/en/docs/oneapi/installation-guide-linux/2024-0/apt.html#GUID-B1770241-0BBB-4E9C-B85B-9268CA66F15C) 
```
run commands:
```
chmod 777 ./socwatch_measurements.sh

#start measurements
./socwatch_measurements.sh main "-l $socwatch_log" "-o $socwatch_output" "-f hw-cpu-cstate" time USERNAME PASSWD HOST

#report measurements
./socwatch_measurements.sh report_measurements PASSWD USERNAME HOST socwatch_output.csv &> destination.csv
```

### `run_profiler.sh`
A simple profiler for collecting and analyzing processor C-state residency/transitions, interrupts, utilization and power measurements(RAPL/perf) on a remote machine.

run commands:
```
#start measurements
./run_profiler.sh main USERNAME PASSWD HOST
sleep 10
./run_profiler.sh start_measurements PASSWD USERNAME HOST

#stop measurements
./run_profiler.sh stop_measurements PASSWD USERNAME HOST

#report measurements
./run_profiler.sh report_measurements PASSWD USERNAME HOST destination_dir

```