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

void VNF::initialize() {
    cModule* network = getParentModule();
    num_vms = network->par("num_vms");
    p_sdn = network->par("p_sdn");

    vnf_chains = std::vector<std::vector<int>>();
    prob_service = std::vector<int>();

    cStringTokenizer tokenizer_chains(network->par("vnf_chains"));

    while(tokenizer_chains.hasMoreTokens()) {
        cStringTokenizer tokenizer_vnfs(tokenizer_chains.nextToken(), ".");
        vnf_chains.push_back(
                tokenizer_vnfs.asIntVector());
    }


    std::string prob_service_par = network->par("prob_service");

    if (prob_service_par == "EQUAL") {
        for(int i = 0; i < vnf_chains.size(); i++)
            prob_service.push_back(100 * (1.0 / ((double) vnf_chains.size())));
    } else {
        cStringTokenizer tokenizer_services(network->par("prob_service"));
        prob_service = tokenizer_services.asIntVector();
    }

    queue = cQueue();

    completed_signal = registerSignal("completed");
    msg_hop_cnt_signal = registerSignal("msg_hop_count");
    received_cnt_signal = registerSignal("vnf_received_count");
    processed_signal = registerSignal("vnf_msg_processed");

    double par_prod = par("production_rate"),
           par_service = par("service_rate");

    if(par_prod == 0) return;

    inter_production_time = SimTime(1 / par_prod);
    inter_service_time = SimTime(1 / par_service);

    simtime_t production_rate = exponential(inter_production_time);

    cMessage *send_msg_evt = new cMessage("send", 1);
    scheduleAt(simTime() + production_rate, send_msg_evt);
}

void VNF::handleMessage(cMessage *msg) {
    if (msg->isSelfMessage() && msg->getKind() == 1) {
        delete msg;

        auto dmsg = new DestMessage();
        dmsg->setProduced(simTime());

        // Set VNF chain for message
        int v_idx = 0;
        int rng = intuniform(1, 100);

        int p_sum = 0;
        for (int i = 0; i < prob_service.size(); i++) {
            p_sum += prob_service[i];
            if(rng <= p_sum) {
                v_idx = i;
                break;
            }
        }

        auto vnf_chain = vnf_chains[v_idx];

        dmsg->setVnfChainArraySize(vnf_chain.size());

        for (int i = 0; i < vnf_chain.size(); i++)
            dmsg->setVnfChain(i, vnf_chain[i]);

        dmsg->setPathArraySize(vnf_chain.size());
        dmsg->setVisitsSDNArraySize(vnf_chain.size());

        for(int i = 0; i < vnf_chain.size(); i++) {
            int prev_target = i == 0 ? getIndex() : dmsg->getPath(i-1);
            int target = prev_target;

            while (target == prev_target)
                target = intuniform(0, num_vms - 1);

            dmsg->setPath(i, target);
            dmsg->setVisitsSDN(i, false);

            if(intuniform(0, 99) < p_sdn)
                dmsg->setVisitsSDN(i, true);
        }

        send(dmsg, "gate$o");

        simtime_t production_rate = exponential(inter_production_time);
        cMessage *send_msg_evt = new cMessage("send", 1);
        scheduleAt(simTime() + production_rate, send_msg_evt);

    } else if (msg->isSelfMessage() && msg->getKind() == 2) {

        delete msg;

        DestMessage *dmsg = check_and_cast<DestMessage *>(queue.pop());
        emit(processed_signal, simTime() - dmsg->getQueued());

        if (dmsg->getVnfPos() == (dmsg->getVnfChainArraySize() - 1)) {

            simtime_t travel_time = simTime() - dmsg->getProduced();

            emit(completed_signal, travel_time);
            emit(msg_hop_cnt_signal, dmsg->getHopCount());

            delete dmsg;

//            double prev_value = accuracy_detector.getMean();
//            accuracy_detector.collect(travel_time);
//            double new_value = accuracy_detector.getMean();
//
//            if(abs(prev_value - new_value) < 0.001)
//                endSimulation();

        } else {

            dmsg->setVnfPos(dmsg->getVnfPos() + 1);

            int ratio = dmsg->getVnfChain(dmsg->getVnfPos());

            while (ratio > 0) {

                int rng = intuniform(1, 100);

                if(ratio >= 100 || rng < ratio) {
                    auto new_msg = dmsg->dup();
                    send(new_msg, "gate$o");
                }

                ratio -= 100;
            }

            delete dmsg;
        }

        if (!queue.isEmpty()) {
            simtime_t service_rate = exponential(inter_service_time);
            cMessage *process_msg_evt = new cMessage("process", 2);
            scheduleAt(simTime() + service_rate, process_msg_evt);
        }

    } else if (!msg->isSelfMessage()) {

//        num_msg_received++;

        if (queue.isEmpty()) {
            simtime_t service_rate = exponential(inter_service_time);
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
//    emit(received_cnt_signal, num_msg_received / simTime());
}

} //namespace
