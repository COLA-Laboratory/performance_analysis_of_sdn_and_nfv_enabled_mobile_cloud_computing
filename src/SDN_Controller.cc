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

#include "SDN_Controller.h"
#include "DestMessage_m.h"

namespace nfv_fattree {

Define_Module(SDN_Controller);

void SDN_Controller::initialize() {
    queue = cQueue();

    received_cnt_signal = registerSignal("sdn_received_count");
    processed_signal = registerSignal("sdn_msg_processed");
}

void SDN_Controller::handleMessage(cMessage *msg) {
    if (msg->isSelfMessage()) {

        delete msg;

        DestMessage *dmsg = check_and_cast<DestMessage *>(queue.pop());
        emit(processed_signal, simTime() - dmsg->getQueued());

        if (!queue.isEmpty()) {
            simtime_t service_rate = par("service_rate");
            cMessage *process_msg_evt = new cMessage("process", 2);
            scheduleAt(simTime() + service_rate, process_msg_evt);
        }

        dmsg->setVisitsSDN(dmsg->getVnfPos(), false);

        int port = dmsg->getSrcServer();
        send(dmsg, "gate$o", port);

    } else {

        num_msg_received++;

        if (queue.isEmpty()) {
            simtime_t service_rate = par("service_rate");
            cMessage *process_msg_evt = new cMessage("process", 2);
            scheduleAt(simTime() + service_rate, process_msg_evt);
        }

        DestMessage *dmsg = check_and_cast<DestMessage *>(msg);
        queue.insert(dmsg);

        dmsg->setQueued(simTime());
        dmsg->setHopCount(dmsg->getHopCount() + 1);
    }
}

void SDN_Controller::finish() {
    emit(received_cnt_signal, num_msg_received / simTime());
}

} //namespace
