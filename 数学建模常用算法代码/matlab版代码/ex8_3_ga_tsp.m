clear;clc;
% 输入数据
vertexs=importdata('city.txt');          %城市坐标
n=length(vertexs);                        %城市数目
dist=zeros(n);                            %城市距离矩阵
for i = 1:n
    for j = 1:n
        dist(i,j)=distance(vertexs(i,:),vertexs(j,:));
    end
end
% 遗传算法参数设置
NIND=50;                        %种群大小
MAXGEN=150;                     %迭代次数
Pm=0.9;                         %交叉概率
Pc=0.1;                         %变异概率
pSwap=0.2;                      %选择交换结构的概率
pReversion=0.5;                 %选择逆转结构的概率
pInsertion=0.3;                 %选择插入结构的概率
N=n;                            %染色体长度=城市数目
% 种群初始化
Chrom=InitPop(NIND,N);
% 优化
gen=1;                          %计数器
bestChrom=Chrom(1,:);           %初始全局最优个体
bestL=RouteLength(bestChrom,dist);%初始全局最优个体的总距离
BestChrom=zeros(MAXGEN,N);      %记录每次迭代过程中全局最优个体
BestL=zeros(MAXGEN,1);          %记录每次迭代过程中全局最优个体的总距离
while gen<=MAXGEN
    SelCh=BinaryTourment_Select(Chrom,dist);            %二元锦标赛选择          
    SelCh=Recombin(SelCh,Pm);                           %OX交叉
    SelCh=Mutate(SelCh,Pc,pSwap,pReversion,pInsertion); %变异
    Chrom=SelCh;                                        %将Chrom更新为SelCh
    Obj=ObjFunction(Chrom,dist);                        %计算当前代所有个体总距离
    [minObj,minIndex]=min(Obj);                         %找出当前代中最优个体
    if minObj<=bestL                                    %将当前代中最优个体与全局最优个体进行比较，如果当前代最优个体更好，则将全局最优个体进行替换
        bestChrom=Chrom(minIndex,:); 
        bestL=minObj;
    end
    BestChrom(gen,:)=bestChrom;                         %记录每一代全局最优个体，及其总距离
    BestL(gen,:)=bestL;
    disp(['第' num2str(gen) '次迭代：全局最优路线总距离 = ' num2str(bestL)]); %显示外层循环每次迭代的信全局最优路线的总距离
    figure(1);                                          %画出每次迭代的全局最优路线图
    PlotRoute(bestChrom,vertexs(:,1),vertexs(:,2))
    pause(0.01);
    gen=gen+1;    %计数器加1
end
figure;                                                 % 打印每次迭代的全局最优个体的总距离变化趋势图
plot(BestL,'LineWidth',1);
title('优化过程')
xlabel('迭代次数');
ylabel('总距离');

function dist = distance(a,b)
%a          第一个城市坐标
%b          第二个城市坐标
%dist       两个城市之间距离
    x = (a(1)-b(1))^2;
    y = (a(2)-b(2))^2;
    dist = (x+y)^(1/2);
end

function Dist=ObjFunction(Chrom,dist)
%Chrom           种群
%dist            距离矩阵
%Dist            每个个体的目标函数值，即每个个体的总距离
    NIND=size(Chrom,1);                     %种群大小
    Dist=zeros(NIND,1);                      %目标函数初始化为0
    for i=1:NIND
        route=Chrom(i,:);                   %当前个体
        Dist(i,1)=RouteLength(route,dist);   %计算当前个体的总距离
    end
end

function L=RouteLength(route,dist)
%route               路线
%dist                距离矩阵
%L                   该路线总距离
    n=length(route);
    route=[route route(1)];
    L=0;
    for k=1:n 
        i=route(k);
        j=route(k+1); 
        L=L+dist(i,j); 
    end
end

function Chrom=InitPop(NIND,N)
%种群初始化
%NIND        种群大小
%N           染色体长度
%Chrom       随机生成的初始种群
    Chrom=zeros(NIND,N);                %种群初始化为NIND行N列的零矩阵
    for i=1:NIND
        Chrom(i,:)=randperm(N);         %每个个体为1~N的随机排列
    end
end

function FitnV=Fitness(Obj)
%适应度函数，总距离的倒数    
%输入Obj：     每个个体的总距离
%输出FitnV：   每个个体的适应度值，即总距离的倒数
    FitnV=1./Obj;
end

function Selch=BinaryTourment_Select(Chrom,dist)
%Chrom           种群
%dist            距离矩阵
%Selch           二元锦标赛选择出的个体
    Obj=ObjFunction(Chrom,dist);            %计算种群目标函数值，即每个个体的总距离
    FitnV=Fitness(Obj);                     %计算每个个体的适应度值，即总距离的倒数
    [NIND,N]=size(Chrom);                   %NIND-种群个数、N-种群长度
    Selch=zeros(NIND,N);                    %初始化二元锦标赛选择出的个体
    for i=1:NIND
        R=randperm(NIND);                   %生成一个1~NIND的随机排列
        index1=R(1);                        %第一个比较的个体序号
        index2=R(2);                        %第二个比较的个体序号
        fit1=FitnV(index1,:);               %第一个比较的个体的适应度值（适应度值越大，说明个体质量越高）
        fit2=FitnV(index2,:);               %第二个比较的个体的适应度值
        %如果个体1的适应度值 大于等于 个体2的适应度值，则将个体1作为第i选择出的个体
        if fit1>=fit2
            Selch(i,:)=Chrom(index1,:);
        else
            %如果个体1的适应度值 小于 个体2的适应度值，则将个体2作为第i选择出的个体
            Selch(i,:)=Chrom(index2,:);
        end
    end
end

function SelCh=Recombin(SelCh,Pc)
% 交叉操作
%SelCh    被选择的个体
%Pc       交叉概率
% SelCh   交叉后的个体
    NSel=size(SelCh,1);
    for i=1:2:NSel-mod(NSel,2)
        if Pc>=rand %交叉概率Pc
            [SelCh(i,:),SelCh(i+1,:)]=OX(SelCh(i,:),SelCh(i+1,:));
        end
    end
end
function [a,b]=OX(a,b)
%输入：a和b为两个待交叉的个体
%输出：a和b为交叉后得到的两个个体
    L=length(a);
    while 1
        r1=randsrc(1,1,[1:L]);
        r2=randsrc(1,1,[1:L]);
        if r1~=r2
            s=min([r1,r2]);
            e=max([r1,r2]);
            a0=[b(s:e),a];
            b0=[a(s:e),b];
            for i=1:length(a0)
                aindex=find(a0==a0(i));
                bindex=find(b0==b0(i));
                if length(aindex)>1
                    a0(aindex(2))=[];
                end
                if length(bindex)>1
                    b0(bindex(2))=[];
                end
                if i==length(a)
                    break
                end
            end
            a=a0;
            b=b0;
            break
        end
    end
end
 

function SelCh=Mutate(SelCh,Pm,pSwap,pReversion,pInsertion)
% 变异操作
%SelCh           被选择的个体
%Pm              变异概率
%pSwap           选择交换结构的概率
%pReversion      选择逆转结构的概率
%pInsertion      选择插入结构的概率
%SelCh           变异后的个体
    NSel=size(SelCh,1);
    for i=1:NSel
        if Pm>=rand
            index=Roulette(pSwap,pReversion,pInsertion);
            route1=SelCh(i,:);
            if index==1                %交换结构
                route2=Swap(route1);
            elseif index==2            %逆转结构
                route2=Reversion(route1);
            else                       %插入结构
                route2=Insertion(route1);
            end
            SelCh(i,:)=route2;
        end
    end
end

function index=Roulette(pSwap,pReversion,pInsertion)
%pSwap           选择交换结构的概率
%pReversion      选择逆转结构的概率
%pInsertion      选择插入结构的概率
%index           最终选择的邻域结构
    p=[pSwap pReversion pInsertion];
    r=rand;
    c=cumsum(p);
    index=find(r<=c,1,'first');
end

function route2=Swap(route1)
%交换操作
%route1          原路线1
%route2          经过交换结构变换后的路线2
    n=length(route1);
    seq=randperm(n);
    I=seq(1:2);
    i1=I(1);
    i2=I(2);
    route2=route1;
    route2([i1 i2])=route1([i2 i1]);
end

function route2=Reversion(route1)
%逆转变换
%route1          路线1
%route2          经过逆转结构变换后的路线2
    n=length(route1);
    seq=randperm(n);
    I=seq(1:2);
    i1=min(I);
    i2=max(I);
    route2=route1;
    route2(i1:i2)=route1(i2:-1:i1);
end

function route2=Insertion(route1)
%插入变换
%route1          路线1
%route2          经过插入结构变换后的路线2
    n=length(route1);
    seq=randperm(n);
    I=seq(1:2);
    i1=I(1);
    i2=I(2);
    if i1<i2
        route2=route1([1:i1-1 i1+1:i2 i1 i2+1:end]);
    else
        route2=route1([1:i2 i1 i2+1:i1-1 i1+1:end]);
    end
end

function PlotRoute(route,x,y)
%route           路线
%x,y             x,y坐标
    route=[route route(1)];
    plot(x(route),y(route),'k-o','MarkerSize',10,'MarkerFaceColor','w','LineWidth',1.5);
    xlabel('x');
    ylabel('y');
end