m = 4;
prod_rate = 1/3;

srv_server = 2;
srv_tor = 2;
srv_agg = 2;
srv_core = 2;

num_core = m;
num_agg = m * (m / 2);
num_edge = m * (m / 2);
k = m * (m / 2) * (m / 2); % num_servers

p_server = 0;
p_tor = ((m / 2) - 1) / (k - 1); 
p_agg = ((m / 2) * (m / 2) - (m / 2)) / (k - 1);
p_core = (k - (m / 2) * (m / 2)) / (k - 1); % Needs to be squared because you have m/2 edge/aggs with m/2 servers each

arv_server = ((k - 1) / (k - 1)) * prod_rate;
arv_tor = (m / 2) * prod_rate + (k - (m/2)) * (1 / (k - 1)) * (m / 2) * prod_rate;
arv_agg = ((m/2)*(m/2)) * prod_rate * ((k -(m/2)) / (k - 1)) * (1/(m/2)) ...
        + (k - (m/2)*(m/2)) * prod_rate * (((m/2)*(m/2))/(k - 1)) * (1/(m/2));
arv_core = 1/m * k * p_core * prod_rate;

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