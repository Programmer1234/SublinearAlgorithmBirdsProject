function [s, f] = freq_dist(wav_data, sample_rate)

if size(wav_data,1) > 1
    x = wav_data;
else
    x = wav_data';
end

x = x(:, 1);                        % get the first channel
xmax = max(abs(x));                 % find the maximum abs values
x = x/xmax;                         % scalling the signal

[ wlen, h, nfft ] = get_stft_params( sample_rate );

% perform STFT
[s, f, t] = stft(x, wlen, h, nfft, sample_rate);

s = sum(s,2);
s_sum = sum(s);

if s_sum > 0
    s = s / sum(s);
end