#!/usr/bin/env python

import subprocess

scatter = "1,2,3,0,5,6,7,4"

for i in [1, 2, 4, 8]:
    
    pinning = ",".join(scatter.split(",")[:i] ) 
    cmd = "taskset -c " + pinning + " ./main_XEON -n 600000 -b 512 -i 152 -s"
    print(cmd)    
    subprocess.call(cmd, shell=True)



