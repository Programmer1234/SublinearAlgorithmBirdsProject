function [ samples ] = query_distribution(signal_data, signal_fs, samples_number, samples_number_per_sftf, stft_interval_percentage)
%QUERY_DISTRIBUTION Summary of this function goes here
%   Detailed explanation goes here

assert(mod(samples_number, samples_number_per_sftf) == 0);

signal_length = length(signal_data);
sftf_number = samples_number / samples_number_per_sftf;
stft_length = uint32(lower(stft_interval_percentage * signal_length));

samples_matrix = zeros(sftf_number, samples_number_per_sftf);  % Initialize samples matrix

for i = 1 : sftf_number
    
    % Get random index from the data, that still allows to perform stft
    % on (index - stft_length/2, index + stft_length/2) as requested
    signal_random_index = randi([(stft_length/2+1) signal_length-(stft_length/2)], 1, 1);
    sub_signal_data = signal_data(signal_random_index - stft_length / 2 : signal_random_index + stft_length / 2);
    
    % Get the stft of the sub_signal
    sub_signal_stft = get_stft(sub_signal_data, signal_fs);
    
    samples_vec = randsample(400 , samples_number_per_sftf ,true, sub_signal_stft);
    
    samples_matrix(i, :) =  samples_vec;
end

samples = reshape(samples_matrix, 1, samples_number)';

hist(samples, 400);

end

