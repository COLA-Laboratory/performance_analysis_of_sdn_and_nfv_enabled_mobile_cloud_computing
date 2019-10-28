% Default
global k; global k_vm; global p_sdn; global prob_services; global vnf_chains;
global init_prod_rate; global srv_vm; global srv_server; global srv_tor;
global srv_agg; global srv_core; global srv_sdn;

root_dir = '/media/joebillingsley/Data//projects/NFV_FatTree/out/data';

%% Test
reset();
for j = 0 : 0.1 : 5
    k = 2;
    k_vm = 2;
    init_prod_rate = 2;    
    p_sdn = 0;
    
    [feasible, latency] = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);   
end

%% IncreasingNumPorts
reset();

for i = 2 : 2 : 12
    
    file_path = fullfile(root_dir, ['MODEL_IncreasingNumPorts_' int2str(i) '.out']);
    file = fopen(file_path, 'w');
    
    k = i;
    
    for j = 0 : 0.1 : 5
        init_prod_rate = j;
        [feasible, latency] = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
        
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
    
    for j = 0 : 0.1 : 5
        init_prod_rate = j;
        [feasible, latency] = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
        
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
    
    for j = 0 : 0.1 : 5
        init_prod_rate = j;
        [feasible, latency] = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
        
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
    
    for j = 0 : 0.1 : 5
        init_prod_rate = j;
        [feasible, latency] = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
        
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
    
    for j = 0 : 0.1 : 5
        init_prod_rate = j;
        [feasible, latency] = mm1_model(k, k_vm, p_sdn, prob_services, vnf_chains, init_prod_rate, srv_vm, srv_server, srv_tor, srv_agg, srv_core, srv_sdn);
        
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

k = 4;
k_vm = 2;
p_sdn = 0;

vnf_chains = {1};
prob_services = 1;

srv_vm = 20;
srv_server= 40;
srv_tor = 40;
srv_agg = 40;
srv_core = 40;
srv_sdn = 40;
end