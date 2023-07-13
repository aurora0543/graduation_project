clear;
clc; close all;
%%
% 读取CSV文件
data = readtable(".\数据集\pulse-transit-time-ppg\1.1.0\csv\s1_run.csv");

% 读取"subjects_info.csv"文件
subjectsInfo = readmatrix(fullfile(".\数据集\pulse-transit-time-ppg\1.1.0\subjects_info.csv"));

% 提取时间列
timeColumn = data(:, 1);
timeColumn = table2array(timeColumn);

% 将字符串转换为MATLAB的日期时间格式
timeFormat = 'yyyy/mm/dd HH:MM:SS';
timeColumn = datetime(timeColumn, 'InputFormat', timeFormat);

% 计算时间间隔
timeInterval = timeColumn(2) - timeColumn(1);

% 计算采样率
samplingRate = 1 / seconds(timeInterval);

% 显示采样率
disp(['采样率为：' num2str(samplingRate) ' Hz']);
%%
% 指定文件夹路径
folderPath = '.\数据集\pulse-transit-time-ppg\1.1.0\csv\';

% 获取文件夹中所有CSV文件的列表
fileList = dir(fullfile(folderPath, 's*.csv'));
numFiles = length(fileList);

% 创建一个空的结果矩阵
resultMatrix = [];
h = waitbar(0, '正在处理...');
% 循环遍历每个CSV文件
for i = 1:numFiles
    % 读取CSV文件
    filePath = fullfile(folderPath, fileList(i).name);
    data = readmatrix(filePath);

    % 提取第4到第9列的前100秒片段
    startIndex = 1;
    endIndex = min(startIndex + 240 * samplingRate, size(data, 1));
    extractedData = data(startIndex:endIndex, [4, 6, 7, 9]);

    % 补充相同行索引的"subjects_info.csv"数据
    infoRow = repmat(subjectsInfo(i, 4)/(subjectsInfo(i, 5)^2), size(extractedData, 1), 1);
    extractedData = [extractedData, infoRow];

    % 生成HR并补充到片段中
    minValue = subjectsInfo(i, 11);
    maxValue = subjectsInfo(i, 12);
    randomNumbers = round(minValue + (maxValue - minValue) * rand(size(extractedData, 1), 1));
    extractedData = [extractedData, randomNumbers];


    % 生成BSP并补充到片段中
    minValue = subjectsInfo(i, 7);
    maxValue = subjectsInfo(i, 8);
    randomNumbers = round(minValue + (maxValue - minValue) * rand(size(extractedData, 1), 1));
    extractedData = [extractedData, randomNumbers];

    % 生成DSP并补充到片段中
    minValue = subjectsInfo(i, 9);
    maxValue = subjectsInfo(i, 10);
    randomNumbers = round(minValue + (maxValue - minValue) * rand(size(extractedData, 1), 1));
    extractedData = [extractedData, randomNumbers];

    % 将提取的数据拼接到结果矩阵中
    resultMatrix = [resultMatrix; extractedData];
    waitbar(i / numFiles, h);
end
% 关闭进度条
close(h);
% 将结果矩阵写入新的CSV文件
outputFilePath = fullfile(folderPath, 'combined_data.csv');
writematrix(resultMatrix, outputFilePath);
%%
% 读取 "combined_data.csv" 文件
data = readmatrix(fullfile(folderPath, 'combined_data.csv'), 'Delimiter', ',');
% 提取前5列数据
dataToNormalize = data(:, 1:4);

% 计算每列的均值和标准差
means = mean(dataToNormalize);
stds = std(dataToNormalize);

% Z-score 标准化
normalizedData = (dataToNormalize - means) ./ stds;

% 将标准化后的数据替换原始数据的前5列
data(:, 1:4) = normalizedData;

% 将结果写入新的 CSV 文件
outputFilePath = fullfile(folderPath, 'combined_data.csv');
writematrix(data, outputFilePath, 'Delimiter', ',');
delet(data);
