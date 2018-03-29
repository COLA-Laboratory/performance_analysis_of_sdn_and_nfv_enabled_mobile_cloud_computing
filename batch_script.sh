#!/bin/bash
cd /media/joebillingsley/Data/projects/NFV_FatTree/simulations

# If it's stupid and it works... 
../src/NFV_FatTree -m -u Cmdenv -c IncreasingArrival_Large -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c IncreasingArrival_Small -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c IncreasingLength_Large -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c IncreasingLength_Small -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c DifferentChains_TwoLong -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c DifferentChains_FourLong -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c DifferentPorts_Large -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c DifferentPorts_Small -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c DifferentSDN_Large -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c DifferentSDN_Small -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c DifferentRT_Base -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c DifferentRT_80 -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c DifferentRT_20 -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c All_Large -n .:../src --cpu-time-limit=120s omnetpp.ini
../src/NFV_FatTree -m -u Cmdenv -c All_Small -n .:../src --cpu-time-limit=120s omnetpp.ini

