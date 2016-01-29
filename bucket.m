function [ k, buckets ] = bucket( q, epsilon )

D = length(q);
k = ceil(2 / log(1 + epsilon) * log(D)) + 1;
buckets = cell(k, 1);

for i = 1:k
    lower_edge = calc_boundary(i-2, epsilon, D);
    upper_edge = calc_boundary(i-1, epsilon, D);
    buckets{i} = find(q >= lower_edge & q < upper_edge);
end

end

function [boundary] = calc_boundary(i, epsilon, D)

if i < 0
    boundary = 0;
else
   boundary = (1 + epsilon)^i / (D * log(D));
end

end