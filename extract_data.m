addpath('.');

in_dir = '/media/joebillingsley/Data/projects/NFV_FatTree/simulations/results';
out_dir = '/media/joebillingsley/Data/projects/NFV_FatTree/data';

cd (out_dir);
delete SIMULATION_*.out

cd (in_dir);

test_problems = dir;
test_problems = test_problems(~ismember({test_problems.name},{'.','..', 'parameters'}));

file_runs = zeros(length(test_problems), 1);

test_group_ptrn = '-';

for i = 1 : length(test_problems)
    temp = regexp(test_problems(i).name, test_group_ptrn, 'split');
    test_groups(i) = temp(1);
end

test_groups = unique(test_groups);

param_ptrn = '(?<=-)[0-9.]*(?=-)';
mean_ptrn = '(?<=scalar FatTree Time_In_System:mean )([0-9.]*|-nan|nan)';

for i = 1 : length(test_groups)
    test_group = test_groups{i};
    test_files = dir([test_group, '*']);
    test_files = natsortfiles({test_files.name});
   
    for j = 1 : size(test_files, 2)
        
        test_file = test_files(j);
        test_file = test_file{1};
        arr_rate = extract_arrival_rate(test_file);
        
        if strcmp(test_group, 'DifferentLengths')
            
            [num_services, lengths, vnfs] = extract_services(test_file);
            out_fname = [test_group '_' num2str(lengths(1))];
            
        elseif strcmp(test_group, 'FilteringVNFs')
            
            [num_services, lengths, vnfs] = extract_services(test_file);
            out_fname = [test_group '_' num2str(vnfs(end))];
            
        elseif strcmp(test_group, 'IncreasingNumPorts') || strcmp(test_group, 'IncreasingSDN')
            
            comma_pos = strfind(test_file, ',');
            
            if isempty(comma_pos)
                par = 4;
            else
                par = extract_parameter(test_file);
            end
                
            out_fname = [test_group '_' num2str(par)];
            
        elseif strcmp(test_group, 'LowNumPorts')
            
            par = 2;
            out_fname = 'IncreasingNumPorts_2';
            
        elseif strcmp(test_group, 'MultipleServices')
            
            [num_services, lengths, vnfs] = extract_services(test_file);
            out_fname = [test_group '_' num2str(num_services)];
            
        else
            error("No match for test group %s", test_group);
        end
        
        fread = fullfile(in_dir, test_file);
        fread = fileread(fread);
                
        mean = regexp(fread, mean_ptrn, 'match');
        mean = str2double(mean);
        
        if isnan(mean)
            mean = 0;
        end
        
        fwrite = fullfile(out_dir, ['SIMULATION_' out_fname '.out']);
        fwrite = fopen(fwrite, 'a');
        
        fprintf(fwrite, '%f %f \n', arr_rate, mean);
        
        fclose(fwrite);
    end
end

function arrival_rate = extract_arrival_rate(str)
dash_pos = strfind(str, '-');
comma_pos = strfind(str, ',');

if comma_pos > 0
    arrival_rate = str(dash_pos(1)+1:comma_pos(1)-1);
else
    arrival_rate = str(dash_pos(1)+1:dash_pos(2)-1);
end

arrival_rate = str2double(arrival_rate);
end

function [num_services, lengths, vnfs] = extract_services(str)

dash_pos = strfind(str, '-');
comma_pos = strfind(str, ',');

services = str(comma_pos(1)+1:dash_pos(2)-1);
services = strsplit(services, '_');

num_services = length(services);

for i=1:num_services
    vnf_str = strsplit(services{i}, '.');
    lengths(i) = length(vnf_str);
    
    for j=1:lengths(i)
        vnfs(i,j) = str2double(vnf_str(j));
    end
end

end

function parameter = extract_parameter(str)

dash_pos = strfind(str, '-');
comma_pos = strfind(str, ',');

parameter = str(comma_pos(1)+1:dash_pos(2)-1);
parameter = str2double(parameter);

end
