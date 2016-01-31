Files List - List of the files we wrote, and a short explanation of them
======================================================================================================================
bucket.m - Given a distribution and 'epsilon' the method returns Buckets array as specified in TestIdentity algorithm
confusion_matrix.m - Build a confusion matrix. the (i,j) element in that matrix, is the average distance between all of the samples
                     of birds from type i, to all of the sampled of birds from j.
create_ground_truth.m - Computes the STFT sum of the ground truth samples.
create_plots_acc_and_ratio_vs_bird_count.m - Plots the graphs of our algorithm accuracy and accuracy ratio against the number of
                                             bird specie
freq_dist.m - Get distribution of frequencies of a signal using STFT.
get_stft_params.m - Returns our optimal parameters for STFT, given sample rate.
query_dist.m - Query from the black-box distribution samples using STFT on sub-signals.
read_sample_data.m - Read samples directory to a suitable struct.
stft.m  - Calculates the STFT of a given signal.
test_bird_identification.m - Test success rate of our bird identification algorithm.
test_identity.m - Our implementation of the TestIdentity algorithm suggested at Tugkan Batu's article.
test_identity_parameter_finder.m - Find correct parameters for our TestIdentity algorithm.
======================================================================================================================    
Usage:
Calling:
conf_matrix = test_bird_identification(<samples_dir>, <k_cross_vaidation_param>)

Causes our test_bird_identification algorithm run on <samples_dir>, divides samples to ground truth
and testing samples, according to the <k_cross_vaidation_param> parameter.
