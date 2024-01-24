#!/usr/bin/env python

import os
import sys

def main(argv):
    worker_threads = int(argv[1])
    pid = os.popen('pgrep powernightmare').read().strip()
    tids = os.popen("ps -p {} -o tid= -L | sort -n | head -{}".format(pid, worker_threads)).read().strip()
    cpu_id = 0
    for tid in tids.splitlines():
        tset = os.popen("taskset -pc {} {}".format(cpu_id, int(tid)))
        print(tset.read())
        cpu_id += 1

if __name__ == '__main__':
    main(sys.argv)

