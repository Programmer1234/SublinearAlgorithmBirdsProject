function [ e, s1, s2, M_pass, M_fail , epsilon_opts, s1_opts, s2_opts] = test_identity_parameter_finder( n, pass_thresh, diff_thresh)

e = [];
s1 = [];
s2 = [];

q_dist = fspecial('gaussian',[n 1], sqrt(n));
q_vals = (1:n)';
q = [q_dist q_vals];

[close, far] = gen_test_dists(q, n, pass_thresh, diff_thresh);

epsilon_opts = 0.2:0.05:1;
s1_opts = 5:1:30;
s2_opts = 1:-0.1:0.1;

M_pass = zeros(length(epsilon_opts), length(s1_opts), length(s2_opts));
M_fail = zeros(length(epsilon_opts), length(s1_opts), length(s2_opts));

test_count = 5;

i = 1;          
for epsilon = epsilon_opts
    j = 1;
    for curr_s1 = s1_opts
        k = 1;
        for curr_s2 = s2_opts                      
            [pass_I, ~, ~] = test_identity(close, q, epsilon, curr_s1, curr_s2);
            [fail_I, ~, ~] = test_identity(far, q, epsilon, curr_s1, curr_s2);
            
            for l=1:test_count-1
                [curr_pass_I, ~, ~] = test_identity(close, q, epsilon, curr_s1, curr_s2);
                [curr_fail_I, ~, ~] = test_identity(far, q, epsilon, curr_s1, curr_s2);
                pass_I = pass_I + curr_pass_I;
                fail_I = fail_I + curr_fail_I;
            end
            
            pass_I = pass_I / test_count;
            fail_I = fail_I / test_count;
            
            M_pass(i,j,k) = pass_I;
            M_fail(i,j,k) = fail_I;
            
            if pass_I > 0.55  && fail_I < 0.45  && pass_I < 1 && fail_I > 0
                e = [e epsilon];
                s1 = [s1 curr_s1];
                s2 = [s2 curr_s2];
                fprintf('e = %f, s1 = %f, s2 = %f, (%d, %d, %d) \n', epsilon, curr_s1, curr_s2, i, j, k);
            end
            
            k = k + 1;
        end
        
        j = j + 1;
    end
    
    i = i + 1;
end

end

function[close, far] = gen_test_dists(q, n, pass_thresh, diff_thresh)

close_noise = abs(randn(n,1));
close_noise = close_noise / sum(close_noise);
close.dist = q(:,1) + close_noise;
close.dist = close.dist / sum(close.dist);

while (norm(close.dist - q(:,1), 1) > pass_thresh * 1.2)
    close.dist = close.dist + q(:,1);
    close.dist = close.dist / sum(close.dist);
end

far_noise = abs(randn(n,1));
far_noise = far_noise / sum(far_noise);
far.dist = q(:,1) + far_noise;
far.dist = far.dist / sum(far.dist);

while (norm(far.dist - q(:,1), 1) > diff_thresh * 1.2)
    far.dist = far.dist + q(:,1);
    far.dist = far.dist / sum(far.dist);
end

close.queryn = @(n) randsample(q(:,2), n, true, far.dist);
far.queryn = @(n) randsample(q(:,2), n, true, far.dist);

end

