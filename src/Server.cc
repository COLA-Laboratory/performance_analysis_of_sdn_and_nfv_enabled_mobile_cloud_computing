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
    cModule* network = getParentModule();
    number_servers = network->par("num_servers");
    num_vnfs = network->par("num_vnfs");

    queue = cQueue();

    completed_signal = registerSignal("completed");
    msg_hop_cnt_signal = registerSignal("msg_hop_count");
    received_cnt_signal = registerSignal("server_received_count");
    processed_signal = registerSignal("server_msg_processed");

    simtime_t production_rate = par("production_rate");

    cMessage *send_msg_evt = new cMessage("send", 1);
    scheduleAt(simTime() + production_rate, send_msg_evt);
}

void Server::handleMessage(cMessage *msg)
{
    if (msg->isSelfMessage() && msg->getKind() == 1) {
        delete msg;

        auto dmsg = new DestMessage();
        dmsg->setProduced(simTime());

        int target = getIndex();
        while (target == getIndex()) {
            target = intuniform(0, number_servers - 1);
        }

        dmsg->setDestination(target);
        dmsg->setVnfCount(num_vnfs - 1);

        send(dmsg, "gate$o");

        simtime_t production_rate = par("production_rate");
        cMessage *send_msg_evt = new cMessage("send", 1);
        scheduleAt(simTime() + production_rate, send_msg_evt);

    } else if (msg->isSelfMessage() && msg->getKind() == 2) {

        delete msg;

        DestMessage *dmsg = check_and_cast<DestMessage *>(queue.pop());
        emit(processed_signal, simTime() - dmsg->getQueued());

        if(dmsg->getVnfCount() <= 1) {
            emit(completed_signal, simTime() - dmsg->getProduced());
            emit(msg_hop_cnt_signal, dmsg->getHopCount());

            delete dmsg;
        } else {
            int target = getIndex();

            while (target == getIndex()) {
                target = intuniform(0, number_servers - 1);
            }

            dmsg->setDestination(target);
            dmsg->setVnfCount(dmsg->getVnfCount() - 1);

            send(dmsg, "gate$o");
        }

        if(!queue.isEmpty()) {
            simtime_t service_rate = par("service_rate");
            cMessage *process_msg_evt = new cMessage("process", 2);
            scheduleAt(simTime() + service_rate, process_msg_evt);
        }

    } else if (!msg->isSelfMessage()) {

        num_msg_received ++;

        if(queue.isEmpty()) {
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
