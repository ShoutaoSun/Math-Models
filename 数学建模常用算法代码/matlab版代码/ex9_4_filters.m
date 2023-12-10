clear;clc;
fs = 6400;  % 重采样频率
T = 1/fs;  % 周期
n = 5;  % 1Hz频率被分成n段
N = fs*n;  % 因为1Hz频率被分成了n段，所以频谱的x轴数组有fs*n个数
f = (0: N-1)*fs/N;  % 将fs个频率细分成fs*n个（即原来是[0, 1, 2, …, fs]，现在是[0, 1/N, 2/N, …, (N-1)*fs/N]）
t = (0: N-1)*T;  % 信号所持续的时长（N个周期）
nHz = 1000;  % 画的频谱的横坐标到nHz
Hz = nHz*n;  % 画的频谱的横坐标的数组个数
Wc=2*640/fs;
Wc1=2*512/fs;                                          %下截止频率 1Hz
Wc2=2*640/fs;
[b,a]=butter(2,[Wc1, Wc2],'bandpass');  % 二阶的巴特沃斯带通滤波

sr=xlsread('附件1.xls',1 );
x=sr(:,3);
subplot(2,3,1);
plot(x(1:1000),'r');
xlabel("time");ylabel("sensor 1");title("原始信号");

b  =  [1 1 1 1 1 1]/6;
x1 = filter(b,1,x);
fprintf("移动平均滤波信噪比\n");
-snr(x1,x-x1)
fprintf("均方根误差\n");
rms(x-x1)
subplot(2,3,2);
plot(x1(1:1000),'r');
xlabel("time");ylabel("sensor 1");title("移动平均滤波")

x1=medfilt1(x,10);
fprintf("中值滤波信噪比\n");
-snr(x1,x-x1)
fprintf("均方根误差\n");
rms(x-x1)
subplot(2,3,3);
plot(x1(1:1000),'r');
xlabel("time");ylabel("sensor 1");title("中值滤波")

[b,a]=butter(4,Wc,'low');  % 四阶的巴特沃斯低通滤波
x1=filter(b,a,x);
fprintf("低通滤波信噪比\n");
-snr(x1,x-x1)
fprintf("均方根误差\n");
rms(x-x1)
subplot(2,3,4);
plot(x1(1:1000),'r');
xlabel("time");ylabel("sensor 1");title("低通滤波")


wpt = wpdec(x,3,'db1');
x1 = wpcoef(wpt,[2 1]);
fprintf("小波包滤波信噪比\n");
-snr(x1,x(1:7350)-x1)
fprintf("均方根误差\n");
rms(x(1:7350)-x1)
subplot(2,3,5);
plot(x1(1:1000),'r'); 
xlabel("time");ylabel("sensor 1");title("小波包滤波")

[b,a]=butter(2,[Wc1, Wc2],'bandpass');  % 二阶的巴特沃斯带通滤波
x1=filter(b,a,x);
fprintf("带通滤波信噪比\n");
-snr(x1,x-x1)
fprintf("均方根误差\n");
rms(x-x1)
subplot(2,3,6);
plot(x1(1:1000),'r');
xlabel("time");ylabel("sensor 1");title("带通滤波")





