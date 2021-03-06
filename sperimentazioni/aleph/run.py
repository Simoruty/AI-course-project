#!/usr/bin/python

import sys
import os
import subprocess
from time import gmtime, strftime, localtime
from datetime import datetime

cmd = "chmod +x **/*.yap"
subprocess.call(cmd, shell=True)
if not os.path.exists("./result/"):
    os.makedirs("./result/")
for dataset in ["elsevier", "jmlr", "mlj", "svln"]:
#for dataset in ["elsevier", "jmlr", "svln"]:
#for dataset in ["svln"]:
    print dataset +" started at "+ strftime("%H:%M:%S", localtime())
    sys.stdout.flush()
    startDataset = datetime.now()
    for fold in range(10):
#    for fold in range(2):
        startTime = datetime.now()
        print "---Fold " + str(fold) +" started at "+strftime("%H:%M:%S", localtime())
        sys.stdout.flush()
        cmd = "./"+dataset+"/"+dataset+"_f"+str(fold)+".yap -s50000 -h200000 2>&1 > /dev/null"
        subprocess.call(cmd, shell=True)
        fin = open("./result/"+dataset+".summary","a")
        fin.write("\n --- Fold "+str(fold)+"\n")
        fin.close()
        cmd0 = "cat ./"+dataset+"/"+dataset+"_f"+str(fold)+".rul >> ./result/"+dataset+".summary"
        subprocess.call(cmd0, shell=True)
        cmd1 = "cat ./"+dataset+"/"+dataset+"_f"+str(fold)+".log | grep -B 10 -m 1 '\[Test set summary\]' >> ./result/"+dataset+".summary"
        subprocess.call(cmd1, shell=True)
        print "---Fold " + str(fold) +" ended in: "+str(datetime.now()-startTime)
        sys.stdout.flush()
    print dataset+" ended in "+str(datetime.now()-startDataset)
    print "---------------------------------------------------"
    sys.stdout.flush()
