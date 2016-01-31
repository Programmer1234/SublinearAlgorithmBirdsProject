function [ wlen, h, nfft ] = get_stft_params( sample_rate )

wlen = fix(2^10 * sample_rate / 44100);         % window length (recomended to be power of 2)
h = fix(wlen/(2^2));                     % hop size (recomended to be power of 2)
nfft = 2^13;                        % number of fft points (recomended to be power of 2)

end

