function [ conf_matrix ] = confusion_matrix( birds_data )
%CONFUSION_MATRIX Summary of this function goes here
%   Detailed explanation goes here

birds_types_number = length(birds_data);

conf_matrix = zeros(birds_types_number, birds_types_number);

for i = 1 : birds_types_number
   for j = 1 : birds_types_number
       dist_matrix = pdist2(birds_data{i}.stft_samples', birds_data{j}.stft_samples', 'cityblock');
       dist_vec = reshape(dist_matrix, [size(dist_matrix, 1) * size(dist_matrix, 2) 1]);
       conf_matrix(i, j) = mean(dist_vec);
   end
end


end

