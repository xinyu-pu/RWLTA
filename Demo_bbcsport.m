clc;clear;
addpath('./datasets');
addpath('./function');
%% load dataset
dataset='bbcsport.mat';
load(dataset);
%% set param
% Hyperparameters of RWLTA
p.weight = [1 2];
p.theta = 1.5;
p.lambda = [5 5 10];
% Parameters of clustering
epoch = 10;
nCluster = length(unique(gt));
gt = double(gt);
%% run
[S] = RWLTA(data, p);
for i = 1:epoch
    pre_y = SpectralClustering(S, nCluster);
    measurement(i,:) = ClusteringMeasure8( gt, pre_y );
end
avg_measurement = mean(measurement, 1);
std_measurement = std(measurement, 1);
ACC = [avg_measurement(1) std_measurement(1)]
NMI = [avg_measurement(2) std_measurement(2)]
Purity = [avg_measurement(3) std_measurement(3)]
precise = [avg_measurement(4) std_measurement(4)]
Recall = [avg_measurement(5) std_measurement(5)]
Fscore = [avg_measurement(6) std_measurement(6)]
RI = [avg_measurement(7) std_measurement(7)]
ARI = [avg_measurement(8) std_measurement(8)]