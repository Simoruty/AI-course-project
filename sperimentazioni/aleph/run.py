#!/usr/bin/python

import subprocess
from time import gmtime, strftime, localtime
from datetime import datetime

cmd = "chmod +x *.yap"
subprocess.call(cmd, shell=True)
#for dataset in ["elsevier", "jmlr", "mlj", "svln"]:
for dataset in ["elsevier"]:
    print dataset +" started at "+ strftime("%H:%M:%S", localtime())
    startDataset = datetime.now()
#    for fold in range(10):
    for fold in range(2):
        startTime = datetime.now()
        print "---Fold " + str(fold) +" started at "+strftime("%H:%M:%S", localtime())
        cmd = "./"+dataset+"_f"+str(fold)+".yap -s50000 -h200000 2>&1 > /dev/null"
        subprocess.call(cmd, shell=True)
        print "---Fold " + str(fold) +" endend in: "+str(datetime.now()-startTime)
    print dataset+" ended in "+str(datetime.now()-startDataset)
    print "---------------------------------------------------"

