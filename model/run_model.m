% Default
global k; global k_vm; global p_sdn; global vnf_chains;
global init_prod_rate; global srv_vm; global srv_server; global srv_tor;
global srv_agg; global srv_core; global srv_sdn;

%% IncreasingArrival_Large
file = fopen('IncreasingArrival_Large', 'w');

set_to_large();
for i = 0.8 : 0.2 : 5.0
    init_prod_rate = 1/i;
    latency = mm1_model(k, k_vm, p_sdn, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% IncreasingArrival_Small
file = fopen('IncreasingArrival_Small', 'w');

set_to_small();
for i = 1.5 : 0.1 : 5.0
    init_prod_rate = 1/i;
    latency = mm1_model(k, k_vm, p_sdn, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% IncreasingLength_Large
file = fopen('IncreasingLength_Large', 'w');

set_to_large();
for i = 1 : 6
    vnf_chains = zeros(1, i) + 1;
    vnf_chains = {vnf_chains};
    mm1_model(k, k_vm, p_sdn, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', i, latency);
end

fclose(file);

%% IncreasingLength_Small
file = fopen('IncreasingLength_Small', 'w');

set_to_small();
for i = 1 : 3
    vnf_chains = zeros(1, i) + 1;
    vnf_chains = {vnf_chains};
    latency = mm1_model(k, k_vm, p_sdn, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', i, latency);
end

fclose(file);

%% DifferentChains_TwoLong
file = fopen('DifferentChains_TwoLong', 'w');

set_to_large();
for i = 2.4 : 0.2 : 5.0
    init_prod_rate = 1/i;
    vnf_chains = {1, [1,1,1,1,1]};
    latency = mm1_model(k, k_vm, p_sdn, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% DifferentChains_FourLong
file = fopen('DifferentChains_FourLong', 'w');

set_to_large();
for i = 2.8 : 0.2 : 5.0
    init_prod_rate = 1/i;
    vnf_chains = {[1, 1], [1,1,1], [1,1,1,1], [1,1,1,1,1]};
    latency = mm1_model(k, k_vm, p_sdn, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% DifferentPorts_Large
file = fopen('DifferentPorts_Large', 'w');

set_to_large();
for i = 2 : 2 : 16
    k = i;
    latency = mm1_model(k, k_vm, p_sdn, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', i, latency);
end

fclose(file);

%% DifferentPorts_Small
file = fopen('DifferentPorts_Small', 'w');

set_to_small();
for i = 2 : 2 : 12
    k = i;
    latency = mm1_model(k, k_vm, p_sdn, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', i, latency);
end

fclose(file);

%% DifferentSDN_Large
file = fopen('DifferentSDN_Large', 'w');

set_to_large();
for i = 0 : 10 : 100
    p_sdn = i / 100;
    latency = mm1_model(k, k_vm, p_sdn, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', p_sdn, latency);
end

fclose(file);

%% DifferentSDN_Small
file = fopen('DifferentSDN_Small', 'w');

set_to_small();
for i = 0 : 10 : 60
    p_sdn = i / 100;
    latency = mm1_model(k, k_vm, p_sdn, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', p_sdn, latency);
end

fclose(file);

%% DifferentRT_Base
file = fopen('DifferentRT_Base', 'w');

set_to_large();
for i = 1.6 : 0.2 : 5.0
    init_prod_rate = 1/i;
    vnf_chains = {[1, 1]};
    latency = mm1_model(k, k_vm, p_sdn, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% DifferentRT_80
file = fopen('DifferentRT_80', 'w');

for i = 1.4 : 0.2 : 5.0
    init_prod_rate = 1/i;
    vnf_chains = {[1, .8]};
    latency = mm1_model(k, k_vm, p_sdn, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% DifferentRT_20
file = fopen('DifferentRT_20', 'w');

for i = 1 : 0.2 : 5.0
    init_prod_rate = 1/i;
    vnf_chains = {[1, .2]};
    latency = mm1_model(k, k_vm, p_sdn, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% All_Large
file = fopen('All_Large', 'w');

set_to_large();
for i = 1.4 : 0.2 : 5.0
    init_prod_rate = 1/i;
    p_sdn = .20;
    vnf_chains = {[1, .8], [1, .5, .5]};
    latency = mm1_model(k, k_vm, p_sdn, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

% All_Small
file = fopen('All_Small', 'w');

set_to_small();
for i = 2.8 : 0.2 : 5.0
    init_prod_rate = 1/i;
    p_sdn = .20;
    vnf_chains = {[1, .8], [1,.5, .5]};
    latency = mm1_model(k, k_vm, p_sdn, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
    
    fprintf(file, '%f %f\n', init_prod_rate, latency);
end

fclose(file);

%% Helper functions
function set_to_large()
global k; global k_vm; global p_sdn; global vnf_chains;
global init_prod_rate; global srv_vm; global srv_server; global srv_tor;
global srv_agg; global srv_core; global srv_sdn;

k = 4;
k_vm = 2;
p_sdn = 0;

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
