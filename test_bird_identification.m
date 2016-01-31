function [ confusion_matrix_cell ] = test_bird_identification( sample_dir, k_cross )

bird_samples = get_bird_samples(sample_dir, 6);
bird_count = length(bird_samples);

fprintf('There are %d types of birds.\n', bird_count);

rounds = 30;
epsilon = 3;

confusion_matrix_cell = cell(k_cross);

parfor i = 1:k_cross
    curr_confusion_matrix = zeros(bird_count, bird_count + 1);
    [gt_samples, test_samples] = get_samples(bird_samples, i, k_cross);
    
    fprintf('Size of GT: %d, Test: %d .\n', ...
        length(gt_samples{1}.sample_list), ...
        length(test_samples{1}.sample_list));

    gt_data  = create_ground_truth( sample_dir, gt_samples );
    sample_data = read_sample_data( sample_dir, test_samples);
    
    for j = 1:length(sample_data)
        curr_species = sample_data{j};
        
        for k = 1:length(curr_species.data)
            %fprintf('Testing file: %s \n', curr_species.sample_list{k});
            avgIdent = test_sample(gt_data, curr_species.data{k}, curr_species.sample_rate(k), rounds, epsilon);
            
            val = max(avgIdent);
            
            if val > 0
                choices = find(avgIdent == val);
                if any(choices==j)
                    choice = j;
                else
                    choice = choices(1);
                end
                
                curr_confusion_matrix(j, choice) = curr_confusion_matrix(j, choice) + 1;
            else
                curr_confusion_matrix(j, bird_count+1) = curr_confusion_matrix(j,bird_count+1) + 1;
            end
        end
    end
    
    confusion_matrix_cell{i} = curr_confusion_matrix;
end

confusion_matrix = zeros(bird_count, bird_count + 1);

for i = 1:length(confusion_matrix_cell)
    confusion_matrix = confusion_matrix + confusion_matrix_cell{i};
end

confusion_matrix = bsxfun(@rdivide, confusion_matrix, sum(confusion_matrix,2));

fprintf('\nAccuracy Per Species:\n');
disp(diag(confusion_matrix));

fprintf('Average Species Accuracy: %f\n\n', mean(diag(confusion_matrix)));

fprintf('Confusion Matrix: \n');
disp(confusion_matrix);

end

function[ avgIdent ] = test_sample(gt_data, data, sample_rate, rounds, epsilon)
    p.queryn = @(n) query_dist(data, sample_rate, n);
    avgIdent = zeros(length(gt_data),1);
    for i=1:rounds
        sample_count = 0;
        for j=1:length(gt_data)
            current_gt_data = gt_data{j};
            for k = 1:length(current_gt_data.freq_dist)
                if sample_count == 0
                    [ res, p_est, sample_count] = test_identity( p, gt_data{j}.freq_dist{k}, epsilon);
                else
                    res = test_identity( p, gt_data{j}.freq_dist{k}, epsilon, p_est, sample_count);
                end
                avgIdent(j) = avgIdent(j) + res;
            end
        end
    end
    
    if sum(avgIdent) > 0
        avgIdent = avgIdent / sum(avgIdent);
    end
    
%     for i=1:length(gt_data)
%         fprintf('Result of testing against %s: %f \n', gt_data{i}.name, avgIdent(i));
%     end
end

function [bird_samples] = get_bird_samples(sample_dir, max_len)

sample_subdirs=dir(sample_dir); 
sample_subdirs=sample_subdirs([sample_subdirs.bytes]==0);
sample_subdirs = sample_subdirs(arrayfun(@(x) x.name(1), sample_subdirs) ~= '.');
sample_subdirs= {sample_subdirs.name};

if max_len < length(sample_subdirs)
    sample_subdirs = sample_subdirs(1:max_len);
end

bird_samples = cell(length(sample_subdirs),1);

curr = 1;
for sample_subdir=sample_subdirs
    bird_entry.name = sample_subdir{1};
    current_sample_list = dir(fullfile(sample_dir, bird_entry.name));
    current_sample_list=current_sample_list([current_sample_list.bytes]>0);
    bird_entry.sample_list= {current_sample_list.name};
    perm = randperm(length(bird_entry.sample_list));
    bird_entry.sample_list = bird_entry.sample_list(perm);
    bird_samples{curr} = bird_entry;
    curr = curr + 1;
end

end

function [gt_samples, test_samples] = get_samples(bird_samples, i, k_cross)

gt_samples = cell(length(bird_samples),1);
test_samples = cell(length(bird_samples),1);

for j = 1:length(bird_samples)
    bird_entry = bird_samples{j};
    gt_entry.name = bird_entry.name;
    test_entry.name = bird_entry.name;

    test_indices = 1:length(bird_entry.sample_list);
    gt_sample_count = round(length(test_indices)/k_cross);
    gt_start_index = gt_sample_count  * (i-1) + 1;
    gt_indices = gt_start_index:gt_start_index+gt_sample_count-1;
    test_indices(gt_indices) = [];

    gt_entry.sample_list = bird_entry.sample_list(gt_indices);
    test_entry.sample_list = bird_entry.sample_list(test_indices);
    gt_samples{j} = gt_entry; 
    test_samples{j} = test_entry; 
end
    
end
