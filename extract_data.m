cd simulations/results;

in_dir = '/media/joebillingsley/Data/projects/NFV_FatTree/simulations/results';
out_dir = '/media/joebillingsley/Data/projects/NFV_FatTree/out/data';

test_problems = dir;
test_problems = test_problems(~ismember({test_problems.name},{'.','..', 'parameters'}));

file_runs = zeros(length(test_problems), 1);

test_group_ptrn = '-';

for i = 1 : length(test_problems)
    temp = regexp(test_problems(i).name, test_group_ptrn, 'split');
    test_group(i) = temp(1);
end

test_group = unique(test_group);

param_ptrn = '(?<=-)[0-9.]*(?=-)';
mean_ptrn = '(?<=scalar FatTree Time_In_System:mean )[0-9.]*';

for i = 1 : length(test_group)
    test_files = dir([test_group{i}, '*']);
    
    fwrite = fullfile(out_dir, ['SIMULATION_' test_group{i} '.out']);
    fwrite = fopen(fwrite, 'w');
    
    if(contains(test_group{i}, ["IncreasingLength", "DifferentPorts", "DifferentSDN"]))
        
        for j = 1 : size(test_files, 1)
            fread = fullfile(in_dir, test_files(j).name);
            fread = fileread(fread);
            
            param = regexp(test_files(j).name, param_ptrn, 'match');
            param = param{1};
            
            if(contains(test_group{i}, "IncreasingLength"))
                param = length(strsplit(param, '.'));
                param = num2str(param);
            end
            
            mean = regexp(fread, mean_ptrn, 'match');
            mean = str2double(mean);
            
            fprintf(fwrite, '%s %f \n', param, mean);
        end
        
        continue;
    end
    
    for j = size(test_files, 1) : -1 : 1
        fread = fullfile(in_dir, test_files(j).name);
        fread = fileread(fread);
        
        param = regexp(test_files(j).name, param_ptrn, 'match');
        param = str2double(param{1});
        
        mean = regexp(fread, mean_ptrn, 'match');
        mean = str2double(mean);
        
        fprintf(fwrite, '%f %f \n', 1 / param, mean);
    end
end

function num = extract_numbers(str)

str_parsed = regexprep(str, '[A-z#-]+', '');
num = str2double(str_parsed);

end