function [ I, p_est, sample_count] = test_identity( p, q, epsilon, ex_p_est, ex_sample_count, stage_1_const, stage_2_const)

% q is of format q(:,1) = dist, q(:,2) = vals (domain)
% p is a struct that contains a query func

if nargin < 7
    stage_1_const = 12;
    stage_2_const = 0.5;
end

[~,sortperm] = sort(q(:,2));
q = q(sortperm, :);

q_dist = q(:,1);
q_vals = q(:,2);

n = length(q_vals);
[ k, buckets ] = bucket( q_dist, epsilon/sqrt(2));

if nargin < 5
    sample_count = round(stage_1_const * sqrt(n) * log(n) * epsilon^(-2));

    if isfield(p, 'queryn')
        p_samples = p.queryn(sample_count);
    else
        p_samples = zeros(sample_count, 1);

        for i=1:sample_count
            p_samples = p.query();
        end
    end
    
    p_est = [...
        histc(p_samples, q_vals) / sample_count ...
        q_vals];
else
    p_est = ex_p_est;
    sample_count = ex_sample_count;
end

coarse_dist = 0;

for i=k:-1:2
    rest_q_L1 = sum(q_dist(buckets{i}));

    if rest_q_L1 < (epsilon / k)
        continue
    end
    
    samples_in_bucket = sum(p_est(buckets{i}, 1)) * sample_count;
    min_sample_count = stage_2_const * (epsilon / k) * sample_count;
    
    if samples_in_bucket < min_sample_count
        I = 0;
        return;
    end
    
    rest_p_L1 = sum(p_est(buckets{i}, 1));
    rest_p_L2 = norm(p_est(buckets{i}, 1) / rest_q_L1, 2)^2;
    
    min_rest_p_L2 = (1 + epsilon^2) / length(buckets{i});
    
    if rest_p_L2 > min_rest_p_L2
        I = 0;
        return
    end
    
    coarse_dist = coarse_dist + abs(rest_p_L1 - rest_q_L1);
    
    if coarse_dist > epsilon
        I = 0;
        return
    end
end

I = 1;

end

