clc
clear 
addpath('./datasets');
addpath('./function');
addpath('./furnace'); % Dowload from https://github.com/xinyu-pu/furnace.git
%% load dataset
dataset='scene15.mat';
load(dataset);
nCluster = length(unique(gt));
%% parameters
p_set.weight = {[0.5 1 1.5], [1 1.5 2], [0.5 1 5], [0.5 5 5], [1 2 4], [1 5 10], [1 10 10], [2 3 6], [2 4 8]};
p_set.theta =  {0.01, 0.1, 0.2, 0.4, 0.6, 0.8, 1, 1.5, 2};
lambda_range = [0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1, 5];
p_set.lambda =  {};
for i = lambda_range
    for j = lambda_range
        for k = lambda_range
            p_set.lambda{end+1} = [i, j, k];
        end
    end
end
tunne_arg.parallel = "off";
tunne_arg.parallel_thread = 4;
tunne_arg.bar = "off";
tunne_arg.path = "./result_scene15.mat";
[ best_param ] = alchemy( @(x, y, p)run_clustering(x, y, p, nCluster), data, gt, p_set, tunne_arg );