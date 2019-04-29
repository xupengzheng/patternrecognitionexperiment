close all;
clear all;
%% 读取实验数据
data = load('实验1数据.mat');
X = data.samples.';
%% 设置初始均值
m1 = [1,1,1];m2 = [-1,1,-1];
