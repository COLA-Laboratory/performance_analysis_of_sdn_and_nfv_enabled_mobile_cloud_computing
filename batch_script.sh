#!/bin/bash
cd /media/joebillingsley/Data/projects/NFV_FatTree/simulations

# If it's stupid and it works... 
# ../src/Simulations -m -u Cmdenv -c LowNumPorts -n .:../src --cpu-time-limit=20s omnetpp.ini
../src/Simulations -m -u Cmdenv -c IncreasingNumPorts -n .:../src --cpu-time-limit=20 omnetpp.ini
../src/Simulations -m -u Cmdenv -c IncreasingSDN -n .:../src --cpu-time-limit=20s omnetpp.ini
../src/Simulations -m -u Cmdenv -c FilteringVNFs -n .:../src --cpu-time-limit=20s omnetpp.ini
../src/Simulations -m -u Cmdenv -c DifferentLengths -n .:../src --cpu-time-limit=20s omnetpp.ini
../src/Simulations -m -u Cmdenv -c MultipleServices -n .:../src --cpu-time-limit=20s omnetpp.ini

