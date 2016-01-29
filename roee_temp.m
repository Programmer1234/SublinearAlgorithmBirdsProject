domain_size = 1000;
q_dist = fspecial('gaussian',[domain_size 1],25);

q_vals = (1:domain_size)';

q = [q_dist q_vals];

small_noise = randn(domain_size,1)/10000;
p.dist = q_dist + abs(small_noise);
p.dist = p.dist / sum(p.dist);

disp(norm(p.dist-q_dist,1));

p.queryn = @(n) randsample(q_vals, n, true, p.dist);

I = 0;

for i = 1:20
    I = I + test_identity( p, q, 0.4 );
end

Small_I = I / 20;

small_noise = randn(domain_size,1)/1000;
p.dist = q_dist + abs(small_noise);
p.dist = p.dist / sum(p.dist);

disp(norm(p.dist-q_dist,1));

p.queryn = @(n) randsample(q_vals, n, true, p.dist);

I = 0;

for i = 1:20
    I = I + test_identity( p, q, 0.3 );
end

Large_I = I / 20;

disp(Small_I);
disp(Large_I);