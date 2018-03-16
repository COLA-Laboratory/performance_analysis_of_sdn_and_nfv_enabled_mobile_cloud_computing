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

#include "Server.h"
#include "DestMessage_m.h"

namespace nfv_fattree {

Define_Module(Server);

void Server::initialize()
{
    id = getIndex();

    cModule* network = getParentModule();

    num_ports = network->par("k");
    num_vm_ports = network->par("vm_k");

    p_sdn = network->par("p_sdn");

    lb = id * num_vm_ports;
    ub = lb + num_vm_ports - 1;

    queue = cQueue();

    received_cnt_signal = registerSignal("server_received_count");
    processed_signal = registerSignal("server_msg_processed");
}

void Server::handleMessage(cMessage *msg)
{
    if (msg->isSelfMessage()) {

        delete msg;

        DestMessage *dmsg = check_and_cast<DestMessage *>(queue.pop());
        emit(processed_signal, simTime() - dmsg->getQueued());

        if (!queue.isEmpty()) {
            simtime_t service_rate = par("service_rate");
            cMessage *process_msg_evt = new cMessage("process", 2);
            scheduleAt(simTime() + service_rate, process_msg_evt);
        }

        // Decide if message should be forwarded to SDN controller
        int rng = intuniform(1, 100);

        if(rng <= p_sdn) {
            dmsg->setSource(id);
            send(dmsg, "sdn_gate$o");
        } else {
            int destination = dmsg->getDestination();

            if (destination < lb || destination > ub) {
                int port = num_vm_ports;
                send(dmsg, "gate$o", port);
            } else {
                int port = destination - lb;
                send(dmsg, "gate$o", port);
            }
        }

    } else {

        num_msg_received ++;

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

void Server::finish() {
    emit(received_cnt_signal, num_msg_received / simTime());
}

} //namespace
