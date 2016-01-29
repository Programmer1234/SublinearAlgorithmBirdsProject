function [ birds_data ] = create_ground_truth( birds_dir )
%PROCESS_DATA Summary of this function goes here
%   Detailed explanation goes here

[file_list, files_number] = get_all_files(birds_dir);
[bird_type_list, types_number] = get_bird_types(file_list);

fprintf('There are %d types of birds.\n', types_number);

% Initalize output data with the birds types
birds_data = cell(types_number, 1);
for i = 1 : types_number
    birds_data{i,1} = struct('bird_type', bird_type_list{i,1}, 'stft_data', []);
end

% Set all of the sftf samples
for i = 1 : files_number
    
    file_path = file_list{i};
    disp(file_path);
    
    cur_bird_stft = get_stft(file_path);
    cur_bird_type = get_bird_type(file_path);
    
    freq_hist_matrix(i,:) = cur_bird_stft;
    for j = 1 : types_number
        if strcmp(birds_data{j,1}.bird_type, cur_bird_type)
            disp(birds_data{j,1}.bird_type)
            birds_data{j}.stft_data = [birds_data{j}.stft_data cur_bird_stft];
        end
    end
end

dist_matrix = pdist2(freq_hist_matrix, freq_hist_matrix, 'cityblock');

% Calc the average of the sftf of the calculate samples
for j = 1 : types_number
    birds_data{j}.stft_data = mean(birds_data{j}.stft_data, 2);
end

end

function [bird_type_list, types_number] = get_bird_types(file_list)

files_number = length(file_list);

bird_type_list = cell(files_number, 1);
    
for i = 1 : files_number
    bird_type = get_bird_type(file_list{i});
    bird_type_list{i,1} =  bird_type;
end
% Remove repitions
bird_type_list(~cellfun('isempty', bird_type_list)) 
bird_type_list = unique(bird_type_list);
types_number = length(bird_type_list);

end

function bird_type = get_bird_type(file_path)
   [~,file_name,~] = fileparts(file_path);
    bird_type = regexp(file_name, '[0123456789]', 'split');
    bird_type = bird_type{1}; 
end