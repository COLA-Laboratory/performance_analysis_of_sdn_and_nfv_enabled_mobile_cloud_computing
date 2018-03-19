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

#include "VNF.h"
#include "DestMessage_m.h"

namespace nfv_fattree {

Define_Module(VNF);

int total_target = 0;
int msg_gen = 0;

void VNF::initialize() {
    cModule* network = getParentModule();
    num_vms = network->par("num_vms");

    vnf_chains = std::vector<std::vector<int>>();

    cStringTokenizer tokenizer_chains(network->par("vnf_chains"));

    while(tokenizer_chains.hasMoreTokens()) {
        cStringTokenizer tokenizer_vnfs(tokenizer_chains.nextToken(), ".");
        vnf_chains.push_back(
                tokenizer_vnfs.asIntVector());
    }

    queue = cQueue();

    completed_signal = registerSignal("completed");
    msg_hop_cnt_signal = registerSignal("msg_hop_count");
    received_cnt_signal = registerSignal("vnf_received_count");
    processed_signal = registerSignal("vnf_msg_processed");

    simtime_t production_rate = par("production_rate");

    if(getIndex() == 1) {
        cMessage *send_msg_evt = new cMessage("send", 1);
        scheduleAt(simTime() + production_rate, send_msg_evt);
    }
}

void VNF::handleMessage(cMessage *msg) {
    if (msg->isSelfMessage() && msg->getKind() == 1) {
        delete msg;

        auto dmsg = new DestMessage();
        dmsg->setProduced(simTime());

        // Find a target VM
        int target = getIndex();

        while (target == getIndex()) {
            target = intuniform(0, num_vms - 1);
        }

        total_target += target;
        msg_gen ++;

        dmsg->setDestination(target);

        // Set VNF chain for message
        int v_idx = intuniform(0, vnf_chains.size() - 1);

        EV << vnf_chains.size();

        auto vnf_chain = vnf_chains[v_idx];

        dmsg->setVnfChainArraySize(vnf_chain.size());

        for (int i = 0; i < vnf_chain.size(); i++)
            dmsg->setVnfChain(i, vnf_chain[i]);

        send(dmsg, "gate$o");

        simtime_t production_rate = par("production_rate");
        cMessage *send_msg_evt = new cMessage("send", 1);
        scheduleAt(simTime() + production_rate, send_msg_evt);

    } else if (msg->isSelfMessage() && msg->getKind() == 2) {

        delete msg;

        DestMessage *dmsg = check_and_cast<DestMessage *>(queue.pop());
        emit(processed_signal, simTime() - dmsg->getQueued());

        if (dmsg->getVnfPos() == (dmsg->getVnfChainArraySize() - 1)) {
            emit(completed_signal, simTime() - dmsg->getProduced());
            emit(msg_hop_cnt_signal, dmsg->getHopCount());

            delete dmsg;
        } else {
            int target = getIndex();

            while (target == getIndex()) {
                target = intuniform(0, num_vms - 1);
            }

            dmsg->setDestination(target);
            dmsg->setVnfPos(dmsg->getVnfPos() + 1);
            dmsg->setKnowsPath(false);

            send(dmsg, "gate$o");
        }

        if (!queue.isEmpty()) {
            simtime_t service_rate = par("service_rate");
            cMessage *process_msg_evt = new cMessage("process", 2);
            scheduleAt(simTime() + service_rate, process_msg_evt);
        }

    } else if (!msg->isSelfMessage()) {

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

void VNF::finish() {
    emit(received_cnt_signal, num_msg_received / simTime());
}

} //namespace
