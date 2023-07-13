clc;
close all hidden;
clear all;
%% 读取视频
[filename, pathname] = uigetfile({'*.mp4', 'video file from phone(*.mp4)'}, ...
'please choose one video file');

if isequal(filename, 0) || isequal(pathname, 0) % 如果没有选择文件
    return;
end

str = strcat(pathname, filename);
fprintf(['the video file is: ' filename '. \n']); % 显示文件名

videoFileReader = VideoReader(str); % 打开视频文件
frame_width = videoFileReader.Width; % 每帧宽度
frame_height = videoFileReader.Height; % 每帧高度
frame_format = videoFileReader.VideoFormat; % 图像是彩色还是黑白，
td = videoFileReader.Duration; % 视频拍摄的时间
Fs = videoFileReader.FrameRate; % 帧频率

if td < 70
    str = ['在此版本程序中，为了傅里叶分析准确，视频时间要长于70s。' ...
               'The duration of the video should not be shorter than 70s ' ...
           'for better analysing.'];
    error(str);
else
    td = 70;
    frame_number = floor(Fs * td); % 帧数必须是整数
end

fprintf(['the number of frames is: ' num2str(frame_number) '. \n']);
fprintf(['the resolution of frames is: ' num2str(frame_width) '*' ...
             num2str(frame_height) '. \n']);
videoFrame = read(videoFileReader, 1);
channel_num = size(videoFrame, 3); % 颜色通道数量
%%
RGB = zeros(channel_num, frame_number); % 定义数据变量
temp = td / frame_number; % 连续两帧时间间隔
t = temp:temp:td; % 时间轴

while (1)
    figure, imshow(videoFrame) % 显示一张图片
    scrsz = get(0, 'ScreenSize'); set(gcf, 'Position', scrsz); % 获取手动框选ROI区域的坐标
    title('the first frame 第一帧图片')
    [x, y] = ginput(2); % range of ROI 定义ROI区域
    x = floor(sort(x));
    y = floor(sort(y));
    temp = [x(1) x(1) x(2) x(2) x(1); ...
                y(1) y(2) y(2) y(1) y(1)];
    hold on; plot(temp(1, :), temp(2, :), 'r-'); hold off; % 画出ROI区域
    answer = questdlg('Is the selection ok?', 'ROI Selection', ...
        'ok', 'chose again', 'stop the program', 'stop the program');

    switch answer % 判断是否选择正确
        case 'ok'
            break
        case 'chose again'
            close;
        case 'stop the program'
            return
    end

end

for i=1:frame_number
    temp=double(read(videoFileReader,i)); % read one frame 读一帧
    for j=1:channel_num
        RGB(j,i)=mean(mean(temp(y(1):y(2),x(1):x(2),j))); % channal 色通道
    end
end
figure,
for j = 1:channel_num
    subplot(channel_num, 1, j), plot(t, RGB(j, :), '.-'); % 画出每个通道的原始信号
    title(['通道' num2str(j) '的原始数据/the raw data of the number' ...
               num2str(j) 'channel'])
end
%% 脉搏波的平均幅值
for i = 1:channel_num
    normalized_RGB(i,:) = zscore(RGB(i,:));
end
% 指定截止频率范围
lowFreq = 0.7;   % 最低频率
highFreq = 2;   % 最高频率
% 设计带通滤波器
filterOrder = 4;    % 滤波器阶数
NyquistFreq = Fs/2;
Wn = [lowFreq/NyquistFreq, highFreq/NyquistFreq];
b = fir1(filterOrder, Wn, 'bandpass');
% 对信号应用滤波器
for i = 1:channel_num
    filtered_RGB(i,:) = filter(b, 1, normalized_RGB(i,:));
end
% 计算信号的幅值
for i = 1:channel_num
    mean_amplitude(i,:) = abs(filtered_RGB(i,:));
end

t_len = length(filtered_RGB(1,:));
t_cut = 1:t_len;
for j=1:channel_num
    subplot(channel_num,1,j),plot(t_cut,filtered_RGB(j,:),'.-');
    title(['通道' num2str(j) '的滤波后数据/the filtered data of the number' ...
        num2str(j) 'channel'])
end

%% 脉冲频率特征
dt = 1/30;
for i = 1:channel_num
   diff_signal = diff(normalized_RGB(i,:));
   derivative(i,:) = diff_signal / dt;
end


%% 脉搏形状变化率
dt = 1/30;
for i = 1:channel_num
   diff_signal = diff(normalized_RGB(i,:));
   derivative_2(i,:) = diff_signal / dt;
end

%% 预测心率和血压
load("net.mat")
predict_data = sim(net,[mean_amplitude,derivative,derivative_2]);