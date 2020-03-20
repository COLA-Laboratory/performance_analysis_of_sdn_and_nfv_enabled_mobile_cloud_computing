//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

#include "CoreSwitch.h"
#include "DestMessage_m.h"

namespace nfv_fattree {

Define_Module(CoreSwitch);

void CoreSwitch::initialize() {
    cModule* network = getParentModule();

    num_ports = network->par("k");
    num_vm_ports = network->par("vm_k");

    received_cnt_signal = registerSignal("core_received_count");
    processed_signal = registerSignal("core_msg_processed");

    queue = cQueue();

    double par_service = par("service_rate");
    inter_service_time = SimTime(1 / par_service);
}

void CoreSwitch::handleMessage(cMessage *msg) {
    if (msg->isSelfMessage()) {

        delete msg;

        DestMessage *dmsg = check_and_cast<DestMessage *>(queue.pop());
        emit(processed_signal, simTime() - dmsg->getQueued());

        if (!queue.isEmpty()) {
            simtime_t service_rate = exponential(inter_service_time);
            cMessage *process_msg_evt = new cMessage("process", 2);
            scheduleAt(simTime() + service_rate, process_msg_evt);
        }

        int destination = dmsg->getPath(dmsg->getVnfPos());

        int port = floor(destination / ((num_ports / 2) * (num_ports / 2) * num_vm_ports));

        send(dmsg, "gate$o", port);

    } else {

//        num_msg_received ++;

        if (queue.isEmpty()) {
            simtime_t service_rate = exponential(inter_service_time);;
            cMessage *process_msg_evt = new cMessage("process", 2);
            scheduleAt(simTime() + service_rate, process_msg_evt);
        }

        DestMessage *dmsg = check_and_cast<DestMessage *>(msg);
        queue.insert(dmsg);

        dmsg->setQueued(simTime());
        dmsg->setHopCount(dmsg->getHopCount() + 1);
    }
}

void CoreSwitch::finish() {
//    emit(received_cnt_signal, num_msg_received / simTime());
}

} /* namespace canonical_tree */
