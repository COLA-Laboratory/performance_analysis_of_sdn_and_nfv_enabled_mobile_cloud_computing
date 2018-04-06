#!/bin/bash
cd /media/joebillingsley/Data/projects/NFV_FatTree/simulations

# If it's stupid and it works... 
../src/NFV_FatTree -m -u Cmdenv -c IncreasingNumPorts -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c LowNumPorts -n .:../src --sim-time-limit=20s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c IncreasingSDN -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c FilteringVNFs -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c DifferentLengths -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c MultipleServices -n .:../src --cpu-time-limit=120s omnetpp.ini

