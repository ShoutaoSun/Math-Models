clear;clc;
n=900;%换电需求数
min_price=170;%换电价格范围
max_price=230;
A=normrnd(36,5,1,25);%初始期望，平均值为36，方差为5的高斯分布
E=fix(A); %朝0方向取整，如，4.1，4.5，4.8取整都是4
%下面是根据需求数调整E的大小
a=sum(E)-n;
A=A-a/25;
E=fix(A);
b=sum(E)-n;
A=A-b/25;
E=fix(A);
a1=0.05;a2=0.95;%距离成本与换点价格权重
x=rand(n,1).*20000;%初始化需求车辆位置
y=rand(n,1).*20000;
H=[2,2;2,6;2,10;2,14;2,18%初始化换电站位置
6,2;6,6;6,10;6,14;6,18
10,2;10,6;10,10;10,14;10,18
14,2;14,6;14,10;14,14;14,18
18,2;18,6;18,10;18,14;18,18].*1000;
%绘制初始化的司机与换电站的位置图
figure
plot(x,y,'r*')
hold on
plot(H(:,1),H(:,2),'bo')
legend('司机','换电站')
title('初始位置图')
 
%% 计算期望与实际期望
D=[];%需求车辆到各换电站的需求比例
price=200.*ones(1,25);
for i=1:length(H)
    for j=1:length(x)
            D(i,j)=a1*sqrt((H(i,1)-x(j))^2+(H(i,2)-y(j))^2)+a2*price(i);%总费用
    end
end
[d1,d2]=min(D);%选择最近距离换电站
C=tabulate(d2(:));%统计选择换电站次数
e=C(:,2);
err=sum(abs(E-e')); %期望差之和，即博弈对象
% ER(1)=err
%% 博弈
J=[]; %价格变化的差值
ER(1)=err;
for k=2:100
    j=0;
    for i=1:25
        if e(i)<E(i) && price(i)>=min_price
            price(i)=price(i)-1;
            j=j+1;
        end
        if e(i)>E(i) && price(i)<=max_price
            price(i)=price(i)+1;
            j=j+1;
        end
    end
    J=[J,j];
    DD=[];
    for i=1:length(H)
        for j=1:length(x)
            DD(i,j)=a1*sqrt((H(i,1)-x(j))^2+(H(i,2)-y(j))^2)+a2*price(i);
        end
    end
    [dd1,dd2]=min(DD);
    CC=tabulate(dd2(:));
    e=CC(:,2);
    err=sum(abs(E-e'));
    ER=[ER,err];
end
% 绘图
figure
plot(ER,'-o')
title('E-e的差值变化')
set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.32])
legend('E-e')
 
figure
plot(J,'r-o')
title('价格的差值变化')
xlabel('Iterations(t)')
set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.32])
legend('sum of Price(t)-Price(t-1)')
 
figure
bar(price,0.5)
hold on
plot([0,26],[min_price,min_price],'g--')
plot([0,26],[max_price,max_price],'r--')
title('换电站的换电价格')
ylabel('Price(￥)')
axis([0,26,0,300])
set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.32]);
 
figure
h=bar([e,E'],'gr');
set(h(1),'FaceColor','g'); set(h(2),'FaceColor','r');
axis([0,26,0,50])
title('出租车的预期和实际数量')
ylabel('E and e')
set(gcf,'unit','normalized','position',[0.2,0.2,0.64,0.32]);
xlabel('换电站')
legend('e','E')