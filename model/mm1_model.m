function [feasible, waiting_time] = mm1_model(k, k_vm, p_sdn, capacity, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_edge, srv_agg, srv_core, srv_sdn)

srv_server = srv_server* k;
srv_edge = srv_edge * k;
srv_agg = srv_agg * k;
srv_core = srv_core * k;

avg_num_vnfs = 0;

for i = 1:length(vnf_chains)
    avg_num_vnfs = avg_num_vnfs + (length(vnf_chains{i}) + 1) * prob_services(i);
end

eff_prod_rate = zeros(length(vnf_chains), 1);
for i = 1:length(vnf_chains)
    len = length(vnf_chains{i}) + 1;
    eff_prod_rate(i) = ((len - 1) / len) * init_prod_rate;
end

prod_rate = sum(eff_prod_rate' .* prob_services) * capacity;

num_core = (k / 2)^2;
num_pods = k;
num_agg  = num_pods * (k/2);
num_edge = num_pods * (k/2);
num_servers = num_edge * (k/2);
num_vnfs = num_servers * k_vm;

p_vnf = 0;
p_server = (k_vm - 1) / (num_vnfs - 1);
p_edge = ((k/2) * k_vm - k_vm) / (num_vnfs - 1);
% test_edge = (((k / 2) - 1) * k_vm) / (num_vnfs - 1);
p_agg = ((k/2)^2 * k_vm - (k/2) * k_vm) / (num_vnfs - 1);
% test_agg = (((k / 2) - 1) * k * k_vm) / (2 * (num_vnfs - 1));
p_core = (num_vnfs - (k/2)^2 * k_vm) / (num_vnfs - 1);
% test_core = (num_vnfs - ((k/2)^2 * k_vm)) / (num_vnfs - 1);
p_sdn = p_sdn * (1 - p_server);

arv_vnf = ((num_vnfs - 1) / (num_vnfs - 1)) * prod_rate;

arv_server = k_vm * prod_rate ...
    + (num_vnfs - k_vm) * (1 / (num_vnfs - 1)) * k_vm * prod_rate ...
    + k_vm * prod_rate * p_sdn;
% test_arr_server = k_vm * prod_rate * (1 + ((num_vnfs - k_vm) / (num_vnfs - 1)) + p_sdn);

arv_edge = ((k/2) * k_vm) * ((num_vnfs - (k_vm)) / (num_vnfs - 1)) * prod_rate ...
    + (num_vnfs - ((k/2) * k_vm)) * (1 / (num_vnfs - 1)) * ((k / 2) * k_vm) * prod_rate;
% test_arr_edge = ((prod_rate * k * k_vm) / (2 * (num_vnfs - 1))) * (2 * num_vnfs - ((k/2) + 1) * k_vm);

arv_agg = ((k/2)^2 * k_vm) * ((num_vnfs - (k_vm * (k/2))) / (num_vnfs - 1)) * prod_rate * (1/(k/2)) ...
    + (num_vnfs - ((k/2)^2 * k_vm)) * prod_rate * (((k/2)^2 * k_vm) / (num_vnfs - 1)) * (1/(k/2));
% test_arr_agg = ((((k^2)/2) * k_vm * prod_rate) / (k * (num_vnfs - 1))) * (2 * num_vnfs - k_vm * ((k/2)^2 + k/2));

arv_core = p_core * num_vnfs * (1 / num_core) * prod_rate;

arv_sdn = num_vnfs * prod_rate * p_sdn;

if arv_vnf > srv_vm || arv_server > srv_server || arv_edge > srv_edge || arv_agg > srv_agg || arv_core > srv_core || arv_sdn > srv_sdn
    feasible = false;
else
    feasible = true;
end

proc_vnf = MM1(arv_vnf, srv_vm);
proc_server = MM1(arv_server, srv_server);
proc_edge = MM1(arv_edge, srv_edge);
proc_agg = MM1(arv_agg, srv_agg);
proc_core = MM1(arv_core, srv_core);
proc_sdn = (MM1(arv_sdn, srv_sdn) + proc_server) * p_sdn;

waiting_time = (proc_server + proc_vnf) * p_server ...
    + (proc_edge + 2 * proc_server + proc_sdn + proc_vnf) * p_edge ...
    + (proc_agg + 2 * proc_edge + 2 * proc_server + proc_sdn + proc_vnf) * p_agg ...
    + (proc_core + 2 * proc_agg + 2 * proc_edge + 2 * proc_server + proc_sdn + proc_vnf) * p_core;

waiting_time = waiting_time * (avg_num_vnfs - 1);

end

function time_in_system = MM1(arrival_rate, service_rate)
time_in_system = 1 / (service_rate - arrival_rate);

if arrival_rate == 0
    time_in_system = 0;
end
end