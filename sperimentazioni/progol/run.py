#!/usr/bin/python

import subprocess
from time import gmtime, strftime

cmd = "chmod +x *.yap"
subprocess.call(cmd, shell=True)
#for dataset in ["elsevier", "jmlr", "mlj", "svln"]:
for dataset in ["elsevier"]:
    print "Begin " + dataset
#    for fold in range(10):
    for fold in range(1):
        print "---Fold " + str(fold)
        cmd = "./"+dataset+"_f"+str(fold)+".yap -s50000 -h200000 2>&1 > /dev/null"
        subprocess.call(cmd, shell=True)
        strftime("%H:%M:%S", gmtime())

