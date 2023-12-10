clc;clear;
%读取数据
data=xlsread('huiseguanlian.xlsx');
%数据标准化
data1=mapminmax(data',0,1); %标准化到0-1区间
data1=data1';
%%绘制 x1,x4,x5,x6,x7 的折线图
figure(1)
t=[2007:2013];
plot(t,data1(:,1),'LineWidth',2)
hold on 
for i=1:4
    plot(t,data1(:,3+i),'--')
    hold on
end
xlabel('year')
legend('x1','x4','x5','x6','x7')
title('灰色关联分析')
 
%%计算灰色相关系数
%得到其他列和参考列相等的绝对值
for i=4:7
    data1(:,i)=abs(data1(:,i)-data1(:,1));
end
 
%得到绝对值矩阵的全局最大值和最小值
data2=data1(:,4:7);
d_max=max(max(data2));
d_min=min(min(data2));
%灰色关联矩阵
a=0.5;   %分辨系数
data3=(d_min+a*d_max)./(data2+a*d_max);
xishu=mean(data3);
disp(' x4,x5,x6,x7 与 x1之间的灰色关联度分别为：')
disp(xishu)