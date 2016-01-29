function [file_list, files_number] = get_all_files(dir_name)

dir_data = dir(dir_name);      %# Get the data for the current directory
dir_index = [dir_data.isdir];  %# Find the index for directories
file_list = {dir_data(~dir_index).name}';  %'# Get a list of the files
if ~isempty(file_list)
    file_list = cellfun(@(x) fullfile(dir_name,x),...  %# Prepend path to files
                       file_list,'UniformOutput',false);
end

sub_dirs = {dir_data(dir_index).name};  %# Get a list of the subdirectories
valid_index = ~ismember(sub_dirs,{'.','..'});  %# Find index of subdirectories
                                               %#   that are not '.' or '..'
for i_dir = find(valid_index)                  %# Loop over valid subdirectories
    next_dir = fullfile(dir_name,sub_dirs{i_dir});    %# Get the subdirectory path
    file_list = [file_list; get_all_files(next_dir)];  %# Recursively call getAllFiles
end

files_number = length(file_list);

end