function Psorout = PSO_TSP(xy,dmat,Popsize,IterNum,showProg,showResult)
%利用粒子群优化算法解决TSP问题
nargs = 6;%代表函数要输入参数的个数
 
for i = nargin:nargs-1
    switch i
        case 0  %产生城市数据
            xy = [488,814;1393,595;2735,2492;4788,4799;4825,1702;789,2927;4853,1120;4786,3757;2427,1276;4002,2530;710,3496;2109,4455;4579,4797;3962,2737;4798,694;3279,747;179,1288;4246,4204;4670,1272;3394,4072;3789,1218;3716,4647;
                1962,1750];
%            xy = 5000*rand(39,2);%产生40个城市坐标40*2矩阵
        case 1  %计算距离矩阵
            N = size(xy,1);
            a = meshgrid(1:N);%生成N*N升序矩阵
            dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),N,N);% '为矩阵的转置，reshape把数据生成N*N的矩阵
        case 2  %设置粒子群数目
            Popsize = 500;
        case 3  %设置迭代次数
            IterNum = 2000;
        case 4  %是否展示迭代过程
            showProg = 1;
        case 5  %是否展示结果
            showResult = 1;
        otherwise
    end
end
%对输入参数进行检查
[N,~] = size(xy);%城市个数、维数
[nr,nc] = size(dmat);%距离矩阵的行数和列数
if N~=nr || N~=nc
    error('城市坐标或距离矩阵输入有误')
end
showProg = logical(showProg(1));%将数值转变为逻辑值
showResult = logical(showResult(1));
%画出城市位置分布图
figure(1);
plot (xy(:,1),xy(:,2),'k.','MarkerSize',14);
title('城市坐标位置');
 
%% PSO参数初始化
c1 = 0.1;                   %个体学习因子
c2 = 0.075;                 %社会学习因子
w = 1;                      %惯性因子
pop = zeros(Popsize,N);     %粒子位置
v = zeros(Popsize,N);       %粒子速度
iter = 1;                   %迭代次数计时
fitness = zeros(Popsize,1); %适应度函数值
Pbest = zeros(Popsize,N);   %个体极值路径
Pbest_fitness = zeros(Popsize,1);   %个体极值
Gbest = zeros(IterNum,N);            %群体极值路径
Gbest_fitness = zeros(Popsize,1);     %群体极值
Length_ave = zeros(IterNum,1);
ws = 1;                                %惯性因子最大值
we = 0.5;                               %惯性因子最小值
 
%% 产生初始位置和速度
for i = 1:Popsize
    pop(i,:) = randperm(N);
    v(i,:) = randperm(N);
end
%计算粒子适应度值
for i =1:Popsize
    for j =1:N-1
        fitness(i) = fitness(i) + dmat(pop(i,j),pop(i,j+1));
    end
    fitness(i) = fitness(i) + dmat(pop(i,end),pop(i,1));%加上终点回到起点的距离
end
%计算个体极值和群体极值
Pbest_fitness = fitness;
Pbest = pop;
[Gbest_fitness(1),min_index] = min(fitness);
Gbest(1,:) = pop(min_index);
Length_ave(1) = mean(fitness);
 
%% 迭代寻优
while iter <IterNum
    %更新迭代次数与惯性系数
    iter = iter +1;
    w = ws-(ws-we)*(iter/IterNum)^2;%动态惯性系数
    %更新速度
    %个体极值序列交换部分
    change1 = positionChange(Pbest,pop);
    change1 = changeVelocity(c1,change1);%是否进行交换
    %群体极值序列交换部分
    change2 = positionChange(repmat(Gbest(iter-1,:),Popsize,1),pop);%将Gbest复制成m行
    change2 = changeVelocity(c2,change2);
    %原速度部分
    v = OVelocity(w,v);
    %修正速度
    for i = 1:Popsize
        for j =1:N
            if change1(i,j) ~= 0
                v(i,j) = change1(i,j);
            end
            if change2(i,j) ~= 0
                v(i,j) = change2(i,j);
            end
        end
    end
    %更新粒子位置
    pop = updatePosition(pop,v);%更新粒子的位置，也就是更新路径序列
    %适应度值更新
    fitness = zeros(Popsize,1);
    for i = 1:Popsize
        for j = 1:N-1
            fitness(i) = fitness(i) + dmat(pop(i,j),pop(i,j+1));
        end
        fitness(i) = fitness(i) + dmat(pop(i,end),pop(i,1));
    end
    
    %个体极值与群体极值的更新
    for i =1:Popsize
        if fitness(i) < Pbest_fitness(i)
            Pbest_fitness(i) = fitness(i);
            Pbest(i,:) = pop(i,:);
        end
    end
    [minvalue,min_index] = min(fitness);
    if minvalue <Gbest_fitness(iter-1)
        Gbest_fitness(iter) = minvalue;
        Gbest(iter,:) = pop(min_index,:);
        if showProg
            figure(2);
            for i = 1:N-1 %画出中间段
                plot([xy(Gbest(iter,i),1),xy(Gbest(iter,i+1),1)],[xy(Gbest(iter,i),2),xy(Gbest(iter,i+1),2)],'bo-','LineWidth',2);
                hold on;
            end
            plot([xy(Gbest(iter,end),1),xy(Gbest(iter,1),1)],[xy(Gbest(iter,end),2),xy(Gbest(iter,1),2)],'bo-','LineWidth',2);
            title(sprintf('最优路线距离 = %1.2f，迭代次数 = %d次',minvalue,iter));
            hold off
        end 
    else
        Gbest_fitness(iter) = Gbest_fitness(iter-1);
        Gbest(iter,:) = Gbest(iter-1,:);
    end
    Length_ave(iter) = mean(fitness);
end
%% 结果显示
[Shortest_Length,index] = min(Gbest_fitness);
BestRoute = Gbest(index,:);
if showResult
   figure(3);
   plot([xy(BestRoute,1);xy(BestRoute(1),1)],[xy(BestRoute,2);xy(BestRoute(1),2)],'o-')
   grid on
   xlabel('城市位置横坐标');
   ylabel('城市位置纵坐标');
   title(sprintf('粒子群算法优化路径最短距离：%1.2f',Shortest_Length));
   figure(4);
   plot(1:IterNum,Gbest_fitness,'b',1:IterNum,Length_ave,'r:')
   legend('最短距离','平均距离');
   xlabel('迭代次数');
   ylabel('距离')
   title('各代最短距离与平均距离对比');
end
if nargout
    Psorout{1} = BestRoute;
    Psorout{2} = Shortest_Length; 
end     
end
 
function change = positionChange(best,pop)
%记录将pop变成best的交换序列
for i = 1:size(best,1)
    for j =1:size(best,2)
        change(i,j) = find(pop(i,:)==best(i,j));%在粒子i中找到best(i,j)位置索引
        temp = pop(i,j);%将序列交换
        pop(i,j) = pop(i,change(i,j));
        pop(i,change(i,j)) = temp;
    end
end
end
function change = changeVelocity(c,change)
%以一定的概率保留序列
for i =1:size(change,1)
    for j = 1:size(change,2)
        if rand > c
            change(i,j) = 0;
        end
    end
end
end
function v = OVelocity(c,v)
%以一定的概率保留上一次迭代的交换序列
for i =1:size(v,1)
    for j = 1:size(v,2)
        if rand >c
            v(i,j) = 0;
        end
    end
end
end
function pop = updatePosition(pop,v)
%利用速度记录的交换序列进行位置的更新
for i = 1:size(pop,1)
    for j =1:size(pop,2)
        if v(i,j) ~= 0
            temp = pop(i,j);
            pop(i,j) = pop(i,v(i,j));
            pop(i,v(i,j)) = temp;
        end
    end
end
end