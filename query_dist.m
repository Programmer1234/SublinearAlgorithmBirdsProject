function [ samples_vec ] = query_dist(signal_data, signal_fs, number_of_queries)
NUMBER_OF_SAMPLES_PER_STFT = 256;

[ wlen, h, nfft ] = get_stft_params( signal_fs );

signal_length = length(signal_data);
samples_vec = zeros(1, number_of_queries);  % Initialize samples matrix

number_of_queries_done = 0;
indx = 1;

while number_of_queries_done < number_of_queries
    
    % Get random index from the data, that still allows to perform stft
    % on (index - stft_length/2, index + stft_length/2) as requested
    sub_signal_stft = 0;
    while sum(sub_signal_stft) == 0 || isnan(sub_signal_stft(1))
        signal_random_index = randi([1 signal_length-(wlen)], 1, 1);
        sub_signal_data = signal_data(signal_random_index : signal_random_index + wlen - 1);
        [sub_signal_stft, ~] = stft(sub_signal_data, wlen, h, nfft, signal_fs);
    end
    
    % Get the stft of the sub_signal
    
    % Calc how many queries we sample now
    number_of_queries_from_cur_stft = min(ceil(NUMBER_OF_SAMPLES_PER_STFT * sum(sub_signal_stft)), number_of_queries-number_of_queries_done);
    
    % Sample as much points as needed
    samples_from_cur_stft = randsample(length(sub_signal_stft) ,  number_of_queries_from_cur_stft ,true, sub_signal_stft);
    
    % Set the samples in the total number of samples
    samples_vec(indx : indx + (number_of_queries_from_cur_stft-1)) =  samples_from_cur_stft;
    
    % Update
    indx = indx + number_of_queries_from_cur_stft;
    number_of_queries_done = number_of_queries_done + number_of_queries_from_cur_stft;
end

samples_vec = samples_vec';

end

