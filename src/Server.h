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

#ifndef __CANONICAL_TREE_SERVER_H_
#define __CANONICAL_TREE_SERVER_H_

#include <omnetpp.h>

using namespace omnetpp;

namespace nfv_fattree {

class Server : public cSimpleModule
{
  protected:
    virtual void initialize();
    virtual void handleMessage(cMessage *msg);
    virtual void finish();

  private:
    int number_servers;
    int num_msg_received = 0;
    cQueue queue;

    simsignal_t received_cnt_signal;
    simsignal_t processed_signal;
    simsignal_t completed_signal;
    simsignal_t msg_hop_cnt_signal;
};

} //namespace

#endif
