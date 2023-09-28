# Measurements 
This directory contains scripts for measurements. They have been tested on shasta. A server machine with the following specifications:


## Scripts

### `iLO_power.py`
This script fetches the power measurements generated from iLo console. It fetches the power measurements from the last 20 minutes. It uses the fast powermeter which returns a sample every 10 seconds and reports the min,max and average overall power consumption. Additionally, it monitors the power consumption of the cpu and the dim. The syntax of the commena is the following:

prerequisites: 
```
pip install python-ilorest-library
```

``` 
python3 ./iLO_power.py username password url
```

### `pdu.py`
This script monitors the power consumption samples every x seconds (usually 5 is not fixed) fromm the power supply of shasta. It monitors the wall power.

```
python3 ./pdu.py username password hostname time
```

