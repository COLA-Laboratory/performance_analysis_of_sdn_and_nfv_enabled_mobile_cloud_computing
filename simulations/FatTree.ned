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

package nfv_fattree.simulations;

import nfv_fattree.VNF;
import nfv_fattree.Server;
import nfv_fattree.EdgeSwitch;
import nfv_fattree.AggregateSwitch;
import nfv_fattree.CoreSwitch;
import nfv_fattree.SDN_Controller;

network FatTree
{
    parameters:
        // m-port n-tree
        int k; // num_ports
        int vm_k;
        
        int p_sdn;
        
        int num_core = (k / 2) * (k / 2);
        int num_pods = k;
        int num_agg = num_pods * (k / 2);
        int num_edge = num_pods * (k / 2);
        int num_servers = num_edge * (k / 2);
        int num_vms = num_servers * vm_k;
        
        string vnf_lengths;
        
        @statistic[Time_In_System](title="Time in System"; source="completed"; record=stats; interpolationmode=none);
        
        @statistic[Rec_VNF](title="Arrival Rate - VNF"; source="vnf_received_count"; record=stats; interpolationmode=none);
        @statistic[Rec_Server](title="Arrival Rate - Server"; source="server_received_count"; record=stats; interpolationmode=none);
        @statistic[Rec_Edge](title="Arrival Rate - Edge"; source="edge_received_count"; record=stats; interpolationmode=none);
        @statistic[Rec_Agg](title="Arrival Rate - Aggregate"; source="agg_received_count"; record=stats; interpolationmode=none);
        @statistic[Rec_Core](title="Arrival Rate - Core"; source="core_received_count"; record=stats; interpolationmode=none);
        @statistic[Rec_SDN](title="Arrival Rate - SDN"; source="sdn_received_count"; record=stats; interpolationmode=none);
        
        @statistic[Proc_VNF](title="Queueing Time - VNF"; source="vnf_msg_processed"; record=stats; interpolationmode=none);
        @statistic[Proc_Server](title="Queueing Time - Server"; source="server_msg_processed"; record=stats; interpolationmode=none);
        @statistic[Proc_Edge](title="Queueing Time - Edge"; source="edge_msg_processed"; record=stats; interpolationmode=none);
        @statistic[Proc_Agg](title="Queueing Time - Aggregate"; source="agg_msg_processed"; record=stats; interpolationmode=none);
        @statistic[Proc_Core](title="Queueing Time - Core"; source="core_msg_processed"; record=stats; interpolationmode=none);
        @statistic[Proc_SDN](title="Queueing Time - SDN"; source="sdn_msg_processed"; record=stats; interpolationmode=none);
        
        @statistic[Hop_Count](title="Hop Count"; source="msg_hop_count"; record=stats; interpolationmode=none);
        
    types:
        channel Channel extends ned.DelayChannel {
            delay = 0ms;
        }

    submodules:
        vms[num_vms]: VNF;
        servers[num_servers]: Server;
        edge[num_edge]:EdgeSwitch;
        aggregate[num_agg]:AggregateSwitch;
        core[num_core]:CoreSwitch;
        sdn: SDN_Controller;

    connections:
        
        for i=0..num_vms-1 {
            vms[i].gate <--> Channel <--> servers[floor(i/vm_k)].gate++;
        }
        
        for i=0..num_servers-1 {
            servers[i].gate++ <--> Channel <--> edge[floor(i/(k/2))].gate++;
        }
        
        for i=0..num_servers-1 {
            servers[i].sdn_gate <--> Channel <--> sdn.gate++;
        }
        
        for i=0..num_edge - 1, for j=0..num_agg - 1 {
            edge[i].gate++ <--> Channel <--> aggregate[j].gate++ if j >= floor(i/(k /2)) * (k/2) && j < floor(i/(k/2)) * (k/2) + (k/2);
        }
        
        for i=0..num_agg - 1, for j=0..num_core - 1 { 
            aggregate[i].gate++ <--> Channel <--> core[j].gate++ if j >= ((i % (k / 2)) * (k / 2)) && j < ((i % (k / 2)) * (k / 2) + (k/2));
        }
}
