function [ data_entries ] = read_sample_data( sample_dir, path_entries )

% Initalize output data with the birds types
data_entries = path_entries;

for i = 1:length(data_entries)
    sample_count = length(data_entries{i}.sample_list);
    data_entries{i}.data = cell(sample_count,1);
    data_entries{i}.sample_rate = zeros(sample_count,1);

    for j = 1:sample_count
        file_path = fullfile(sample_dir, data_entries{i}.name, data_entries{i}.sample_list{j});
        [file_data, file_fs] = audioread(file_path);
        data_entries{i}.data{j} = file_data;
        data_entries{i}.sample_rate(j) = file_fs;
    end
end

end

