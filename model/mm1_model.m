k = 6;
prod_rate = 1/2;

srv_server = 4;
srv_tor = 4;
srv_agg = 4;
srv_core = 4;

num_core = (k / 2)^2;
num_pods = k;
num_agg  = num_pods * (k/2);
num_edge = num_pods * (k/2);
num_servers = num_edge * (k/2);

p_server = 0;
p_tor = ((k/2) - 1) / (num_servers - 1); 
p_agg = ((k/2)^2 - (k/2)) / (num_servers - 1);
p_core = (num_servers - (k/2)^2) / (num_servers - 1);

arv_server = ((num_servers - 1) / (num_servers - 1)) * prod_rate;
arv_tor = (k/2) * prod_rate + (num_servers - (k/2)) * (1 / (num_servers - 1)) * (k / 2) * prod_rate;
arv_agg = ((k/2)*(k/2)) * prod_rate * ((num_servers -(k/2)) / (num_servers - 1)) * (1/(k/2)) ...
        + (num_servers - (k/2)*(k/2)) * prod_rate * (((k/2)*(k/2))/(num_servers - 1)) * (1/(k/2));
arv_core = (1 / num_core) * num_servers * p_core * prod_rate;

proc_server = MM1(arv_server, srv_server);
proc_tor = MM1(arv_tor, srv_tor);
proc_agg = MM1(arv_agg, srv_agg);
proc_core = MM1(arv_core, srv_core);

waiting_time = (proc_tor + proc_server) * p_tor ...
             + (proc_agg + 2 * proc_tor + proc_server) * p_agg ...
             + (proc_core + 2 * proc_agg + 2 * proc_tor + proc_server) * p_core;

waiting_time
        
function time_in_system = MM1(arrival_rate, service_rate)
    time_in_system = 1 / (service_rate - arrival_rate);
end