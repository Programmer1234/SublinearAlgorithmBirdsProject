function [ samples_vec ] = query_distribution(signal_data, signal_fs, number_of_queries)
%QUERY_DISTRIBUTION Summary of this function goes here
%   Detailed explanation goes here

NUMBER_OF_SAMPLES_PER_STFT = 2^9;
STFT_INTERVAL_PERC = 0.1;
HIGHEST_FREQUENCY = 400;            % Filtering freuqencies higher than this

signal_length = length(signal_data);
sftf_number = uint32(upper(number_of_queries / NUMBER_OF_SAMPLES_PER_STFT));
stft_length = uint32(lower(STFT_INTERVAL_PERC * signal_length));

samples_vec = zeros(1, number_of_queries);  % Initialize samples matrix

number_of_queries_done = 0;
indx = 1;

for i = 1 : sftf_number
    
    % Get random index from the data, that still allows to perform stft
    % on (index - stft_length/2, index + stft_length/2) as requested
    s_sum = 0;
    while s_sum == 0 || isnan(s_sum)
        signal_random_index = randi([1 signal_length-(stft_length)], 1, 1);
        sub_signal_data = signal_data(signal_random_index : signal_random_index + (stft_length));
        [sub_signal_stft, s_sum] = get_stft(sub_signal_data, signal_fs);
    end
    
    % Get the stft of the sub_signal
    
    % Calc how many queries we sample now
    number_of_queries_from_cur_stft = min(NUMBER_OF_SAMPLES_PER_STFT, number_of_queries-number_of_queries_done);
    
    % Sample as much points as needed
    samples_from_cur_stft = randsample(HIGHEST_FREQUENCY ,  number_of_queries_from_cur_stft ,true, sub_signal_stft);
    
    % Set the samples in the total number of samples
    samples_vec(indx : indx + (number_of_queries_from_cur_stft-1)) =  samples_from_cur_stft;
    
    % Update
    indx = indx + number_of_queries_from_cur_stft;
    number_of_queries_done = number_of_queries_done + number_of_queries_from_cur_stft;
end

samples_vec = samples_vec';

end

