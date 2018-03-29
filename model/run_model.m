% Default
global k; global k_vm; global p_sdn; global prob_services; global vnf_chains;
global init_prod_rate; global srv_vm; global srv_server; global srv_tor;
global srv_agg; global srv_core; global srv_sdn;

set_to_large();
p_sdn = 1;
init_prod_rate = .25;
latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);

%% IncreasingArrival_Large
file = fopen('MODEL_IncreasingArrival_Large.out', 'w');

set_to_large();
for i = 5.0 : -0.2 : 0.8
    init_prod_rate = 1/i;
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% IncreasingArrival_Small
file = fopen('MODEL_IncreasingArrival_Small.out', 'w');

set_to_small();
for i = 5.0 : - 0.1 : 1.5
    init_prod_rate = 1/i;
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% IncreasingLength_Large
file = fopen('MODEL_IncreasingLength_Large.out', 'w');

set_to_large();
for i = 1 : 6
    vnf_chains = zeros(1, i) + 1;
    vnf_chains = {vnf_chains};
    mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', i, latency);
end

fclose(file);

%% IncreasingLength_Small
file = fopen('MODEL_IncreasingLength_Small.out', 'w');

set_to_small();
for i = 1 : 3
    vnf_chains = zeros(1, i) + 1;
    vnf_chains = {vnf_chains};
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', i, latency);
end

fclose(file);

%% DifferentChains_TwoLong
file = fopen('MODEL_DifferentChains_TwoLong.out', 'w');

set_to_large();
for i = 5.0 : -0.2 : 2.4
    init_prod_rate = 1/i;
    prob_services = [.5, .5];
    vnf_chains = {1, [1,1,1,1,1]};
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% DifferentChains_FourLong
file = fopen('MODEL_DifferentChains_FourLong.out', 'w');

set_to_large();
for i = 5.0 : -0.2 : 2.8
    init_prod_rate = 1/i;
    prob_services = [.25, .25, .25, .25];
    vnf_chains = {[1, 1], [1,1,1], [1,1,1,1], [1,1,1,1,1]};
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% DifferentServiceProb_Near
file = fopen('MODEL_DifferentServiceProb_Near.out', 'w');

set_to_large();
for i = 5.0 : -0.2 : 3.0
    init_prod_rate = 1/i;
    prob_services = [.1, .2, .3, .4];
    vnf_chains = {[1, 1], [1,1,1], [1,1,1,1], [1,1,1,1,1]};
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% DifferentServiceProb_Far
file = fopen('MODEL_DifferentServiceProb_Far.out', 'w');

set_to_large();
for i = 5.0 : -0.2 : 3.4
    init_prod_rate = 1/i;
    prob_services = [.1, .1, .1, .7];
    vnf_chains = {[1, 1], [1,1,1], [1,1,1,1], [1,1,1,1,1]};
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% DifferentPorts_Large
file = fopen('MODEL_DifferentPorts_Large.out', 'w');

set_to_large();
for i = 2 : 2 : 16
    k = i;
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', i, latency);
end

fclose(file);

%% DifferentPorts_Small
file = fopen('MODEL_DifferentPorts_Small.out', 'w');

set_to_small();
for i = 2 : 2 : 12
    k = i;
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', i, latency);
end

fclose(file);

%% DifferentSDN_Large
file = fopen('MODEL_DifferentSDN_Large.out', 'w');

set_to_large();
for i = 0 : 10 : 100
    p_sdn = i / 100;
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', p_sdn, latency);
end

fclose(file);

%% DifferentSDN_Small
file = fopen('MODEL_DifferentSDN_Small.out', 'w');

set_to_small();
for i = 0 : 10 : 60
    p_sdn = i / 100;
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', p_sdn, latency);
end

fclose(file);

%% DifferentRT_Base
file = fopen('MODEL_DifferentRT_Base.out', 'w');

set_to_large();
for i = 5.0 : -0.2 : 1.6 
    init_prod_rate = 1/i;
    vnf_chains = {[1, 1]};
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% DifferentRT_80
file = fopen('MODEL_DifferentRT_80.out', 'w');

for i = 5.0 : -0.2 : 1.4
    init_prod_rate = 1/i;
    vnf_chains = {[1, .8]};
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% DifferentRT_20
file = fopen('MODEL_DifferentRT_20.out', 'w');

for i = 5.0 : -0.2 : 1
    init_prod_rate = 1/i;
    vnf_chains = {[1, .2]};
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% All_Large
file = fopen('MODEL_All_Large.out', 'w');

set_to_large();
for i = 5.0 : -0.2 : 1.4
    init_prod_rate = 1/i;
    p_sdn = .20;
    prob_services = [.5, .5];
    vnf_chains = {[1, .8], [1, .5, .5]};
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

% All_Small
file = fopen('MODEL_All_Small.out', 'w');

set_to_small();
for i = 5.0 : -0.2 : 2.8
    init_prod_rate = 1/i;
    p_sdn = .20;
    prob_services = [.5, .5];
    vnf_chains = {[1, .8], [1,.5, .5]};
    latency = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% Helper functions
function set_to_large()
global k; global k_vm; global p_sdn; global prob_services; global vnf_chains;
global init_prod_rate; global srv_vm; global srv_server; global srv_tor;
global srv_agg; global srv_core; global srv_sdn;

k = 4;
k_vm = 2;
p_sdn = 0;

prob_services = 1;
vnf_chains = {1};

init_prod_rate = 1/5;

srv_vm = 2;
srv_server= 10;
srv_tor = 10;
srv_agg = 10;
srv_core = 10;
srv_sdn = 10;
end

function set_to_small()
global init_prod_rate;
global srv_vm; global srv_server; global srv_tor;
global srv_agg; global srv_core; global srv_sdn;

set_to_large();

init_prod_rate = 1/5;

srv_vm = 1;
srv_server = 5;
srv_tor = 5;
srv_agg = 5;
srv_core = 5;
srv_sdn = 5;
end
