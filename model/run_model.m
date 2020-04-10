% Default
global k; global k_vm; global p_sdn; global prob_services; global vnf_chains;
global init_prod_rate; global srv_vm; global srv_server; global srv_tor;
global srv_agg; global srv_core; global srv_sdn; global capacity;

% root_dir = '/media/joebillingsley/Data/projects/NFV_FatTree/data';
root_dir = 'D:/Research/NFV_FatTree/data';

%% IncreasingNumPorts
reset();

for i = 4 : 4 : 24   
    file_path = fullfile(root_dir, ['MODEL_IncreasingNumPorts_' int2str(i) '.out']);
    file = fopen(file_path, 'w');
    
    k = i;
    
    for j = 0:.25:100
        init_prod_rate = j;
        [feasible, latency] = mm1_model(k, k_vm, p_sdn, capacity, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
        
        if(feasible)
            fprintf(file, '%f %f\n', init_prod_rate, latency);
        end
    end
    
    fclose(file);
end

%% IncreasingSDN
reset();

for i = 0 : 10 : 100
    
    file_path = fullfile(root_dir, ['MODEL_SDN_' int2str(i) '.out']);
    file = fopen(file_path, 'w');
    
    p_sdn = i / 100;
    
    for j = 0:.25:100
        init_prod_rate = j;
        [feasible, latency] = mm1_model(k, k_vm, p_sdn, capacity, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
        
        if(feasible)
            fprintf(file, '%f %f\n', init_prod_rate, latency);
        end
    end
    
    fclose(file);
end

%% FilteringVNFs
reset();

for i = 0 : 20 : 100
    
    file_path = fullfile(root_dir, ['MODEL_FilteringVNFs_' int2str(i) '.out']);
    file = fopen(file_path, 'w');
    
    vnf_chains = {[1, i/100]};
    
    for j = 0:.25:100
        init_prod_rate = j;
        [feasible, latency] = mm1_model(k, k_vm, p_sdn, capacity, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
        
        if(feasible)
            fprintf(file, '%f %f\n', init_prod_rate, latency);
        end
    end
    
    fclose(file);
end

%% DifferentLengths
reset();

for i = 1 : 8
    
    file_path = fullfile(root_dir, ['MODEL_DifferentLengths_' int2str(i) '.out']);
    file = fopen(file_path, 'w');
    
    vnf_chains = {zeros(1, i) + 1};
    
    for j = 0:.25:100
        init_prod_rate = j;
        [feasible, latency] = mm1_model(k, k_vm, p_sdn, capacity, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
        
        if(feasible)
            fprintf(file, '%f %f\n', init_prod_rate, latency);
        end
    end
    
    fclose(file);
end

%% MultipleServices
reset();

for i = 1 : 5
    
    file_path = fullfile(root_dir, ['MODEL_MultipleServices_' int2str(i) '.out']);
    file = fopen(file_path, 'w');
    
    prob_services = zeros(1, i) + (1 / i);
    vnf_chains = cell(1, i);
    
    for j = 1:i
        vnf_chains{j} = zeros(1, j) + 1;
    end
    
    for j = 0:.25:100
        init_prod_rate = j;
        [feasible, latency] = mm1_model(k, k_vm, p_sdn, capacity, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
        
        if(feasible)
            fprintf(file, '%f %f\n', init_prod_rate, latency);
        end
    end
    
    fclose(file);
end

%% Helper functions
function reset()
global k; global k_vm; global p_sdn; global prob_services;
global vnf_chains; global srv_vm; global srv_server;
global srv_tor; global srv_agg; global srv_core; global srv_sdn;
global capacity;

k = 8;
k_vm = 2;
p_sdn = 0;
capacity = 1;

vnf_chains = {1};
prob_services = 1;

% 1 gigabits per second is 1.25e+8
% Max ethernet packet is 1518 bytes
% ~ 82345 ethernet packets per second

srv_vm = 82;
srv_server = 82;
srv_tor = 82;
srv_agg = 82;
srv_core = 82;
srv_sdn = 82;
end