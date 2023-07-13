clc;
clear;
close all
%% 从文件中读取数据
data = csvread('F:\数据集\pulse-transit-time-ppg\1.1.0\csv\combined_data.csv');

% 提取输入和输出数据
x = data(:, 1:5)';
y = data(:, 6:8)';


% 划分训练集和测试集
train_ratio = 0.8;
[trainInd, testInd] = dividerand(size(x, 2), train_ratio, 1 - train_ratio);

x_train = gpuArray(x(:, trainInd));
y_train = gpuArray(y(:, trainInd));
x_test = gpuArray(x(:, testInd));
y_test = gpuArray(y(:, testInd));

% 定义神经网络结构
numInputs = 5;          % 输入层神经元数量
numHiddenLayers = 5;    % 隐藏层数量
hiddenLayerSize = 10;   % 每个隐藏层的神经元数量
numOutputs = 3;         % 输出层神经元数量

% 创建多层感知机模型
net = feedforwardnet(repmat(hiddenLayerSize, 1, numHiddenLayers), 'trainscg');

% 设置训练参数
net.trainParam.epochs = 150;

% 在 GPU 上训练模型
net = train(net, x_train, y_train);

save("net.mat",'net');

% 使用模型进行预测
y_pred = sim(net, x_test);

%%
rmse = sqrt(mean((y_pred(3,:) - y_test(3,:)).^2));
disp(['RMSE: ', num2str(rmse)]);

