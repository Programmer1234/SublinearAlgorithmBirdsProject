function [gt_data]  = create_ground_truth( sample_dir, gt_samples )
%PROCESS_DATA Summary of this function goes here
%   Detailed explanation goes here

% Initalize output data with the birds types
gt_data = read_sample_data(sample_dir, gt_samples);

%Set all of the sftf samples
for i = 1 : length(gt_data)
    sample_count = length(gt_data{i}.data);
    gt_data{i}.freq_dist = cell(sample_count,1);
    
    for j = 1:sample_count
        [cur_stft, ~] = freq_dist(gt_data{i}.data{j}, gt_data{i}.sample_rate(j));
        gt_data{i}.freq_dist{j} = [cur_stft (1:length(cur_stft))'];
    end
end

end