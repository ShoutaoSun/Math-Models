%% 清屏
clear, clc;
%% 导入数据
citys = [116.46 39.92
          117.2 39.13
          121.48 31.22
          106.54 29.59
          91.11 29.97
          87.68 43.77
          106.27 38.47
          111.65 40.82
          108.33 22.84
          126.63 45.75
          125.35 43.88
          123.38 41.8
          114.48 38.03
          112.53 37.87
          101.74 36.56
          117 36.65
          113.6 34.76
          118.78 32.04
          117.27 31.86
          120.19 30.26
          119.3 26.08
          115.89 28.68
          113 28.21
          114.31 30.52
          113.23 23.16
          121.5 25.05
          110.35 20.02
          103.73 36.03
          108.95 34.27
          104.06 30.67
          106.71 26.57
          102.73 25.04
          114.1 22.2
          113.33 22.13];
 %% 计算距离矩阵
 D = Distance2(citys);   %计算距离矩阵
 n = size(D, 1);         %计算城市个数
 %% 初始化参数
 NC_max = 3000;         %算法最大迭代次数
 NC = 1;                %算法初始迭代次数
 m = 35;                %蚂蚁的数目
 alpha = 1;             %信息素重要程度因子
 beta = 4;              %启发函数重要程度因子
 rho = 0.2;             %信息素挥发程度
 Q = 20;         %常数，表示蚂蚁循环一次所释放的信息素总量
 Eta = 1 ./ D;   %启发函数，表示蚂蚁从城市i转移到城市j的期望程度
 Tau = ones(n, n); %Tau(i, j)表示边(i, j)的信息素量，初始化都为1
 Table = zeros(m, n);   %m只蚂蚁的经过n个城市的路径记录表
 rBest = zeros(NC_max, n);         %记录各代的最佳路线
 lBest = inf .* ones(NC_max, 1);   %记录各代的最佳路线的总长度，初始化为正无穷
 lAverage = zeros(NC_max, 1);      %记录各代路线的平均长度
 %% 算法主体部分，迭代寻找最优路线
 while NC <= NC_max
     % ①随机产生各个蚂蚁的起点城市
     start = zeros(m, 1);        
     for i = 1:m
         temp = randperm(n);     %产生n个不重复的整数
         start(i) = temp(1);     %把temp中第一个数作为蚂蚁i的起点城市
     end
     Table(:, 1) = start;        %Table表的第一列即是所有蚂蚁的起点城市
     citys_index = 1: n;         %所有城市索引的集合
     
     % ②构造解空间    
     for i = 1:m                 %逐个蚂蚁进行路径选择
         for j = 2:n             %逐个城市路径选择(除起点城市外，剩下 n - 1 个城市待访问)
             tabu = Table(i, 1:(j - 1));  %蚂蚁i已访问的城市集合，也称为禁忌表
             allow_index = ~ismember(citys_index, tabu); %函数ismember(a,b)用于判断a的元素是否与b的元素相同，相同返回1
             Allow = citys_index(allow_index);               %Allow表用于存放蚂蚁待访问的城市集合(城市编号)
             P = Allow;
             
            %计算蚂蚁从城市（j - 1）到剩下未访问的城市的转移概率
             for k = 1:size(Allow, 2)
                 P(k) = Tau(tabu(end), Allow(k))^alpha * Eta(tabu(end), Allow(k))^beta;  %计算转移概率公式的分子部分
             end                                   %tabu(end)表示蚂蚁当前所在城市j，Allow(k)表示蚂蚁未访问的第k个城市
             P = P / sum(P);        %计算转移概率公式，sum(P)表示转移概率公式的分母部分
             
             %利用轮盘赌法选择下一个访问的城市(增加随机性)
             Pc = cumsum(P, 2);   %各行按列累加
             target_index = find(Pc >= rand);  %找到目标城市的索引集合
             target = Allow(target_index(1));  %选择索引集合的第一个城市作为蚂蚁下一个访问的城市
             Table(i, j) = target;   %确定蚂蚁i已访问的第j个城市
         end
     end
     
     % ③计算各个蚂蚁的路径距离
     length = zeros(m, 1);
     for i = 1:m
         Route = Table(i,: ); %Route存放蚂蚁i的行走路径
         for j = 1:(n - 1)
             length(i) = length(i) + D(Route(j), Route(j + 1));
         end
         length(i) = length(i) + D(Route(n), Route(1)); % 计算蚂蚁i最后一个城市到第一个城市的路径距离
     end
     
     % ④计算最短路径距离及平均距离
     if NC == 1
        [min_Length, min_index] = min(length);   %min_index返回的是最短路径的蚂蚁编号
        lBest(NC) = min_Length;
        lAverage(NC) = mean(length);
        rBest(NC, :) = Table(min_index, :);
     else
        [min_Length, min_index] = min(length);
        lBest(NC) = min(lBest(NC - 1), min_Length);  %比较上一代的最优值和本代的最优值
        lAverage(NC) = mean(length);
        if lBest(NC) == min_Length
            rBest(NC, :) = Table(min_index, :);      %记录最优路径
        else
            rBest(NC, :) = rBest((NC - 1), :);       
        end
     end
     
    % ⑤更新信息素
    Delta_tau = zeros(n, n);   %所有蚂蚁在城市i到城市j连接路径上释放的信息素浓度之和
    for i = 1: m               %逐个蚂蚁计算
        for j = 1: (n - 1)     %逐个城市计算
            Delta_tau(Table(i, j), Table(i, j + 1)) = Delta_tau(Table(i, j), Table(i, j + 1)) + Q / length(i);
        end
        Delta_tau(Table(i, n), Table(i, 1)) = Delta_tau(Table(i, n), Table(i, 1)) + Q / length(i);
    end
    Tau = (1 - rho) .* Tau + Delta_tau;
    
     % ⑥迭代次数加1，清空路径记录表
    NC = NC + 1;
    Table = zeros(m, n);
 end

%% 结果显示
[shortest_Length, shortest_index] = min(lBest);
shortest_Route = rBest(shortest_index, :);
disp(['最短距离:' num2str(shortest_Length)])
disp(['最短路径:' num2str([shortest_Route shortest_Route(1)])])
     
%% 绘图
figure(1)
plot([citys(shortest_Route,1); citys(shortest_Route(1),1)],...
     [citys(shortest_Route,2); citys(shortest_Route(1),2)],'o-');
grid on
for i = 1: size(citys, 1)
    text(citys(i, 1), citys(i, 2), ['   ' num2str(i)]);
end
text(citys(shortest_Route(1), 1), citys(shortest_Route(1), 2), '       起点');
text(citys(shortest_Route(end), 1), citys(shortest_Route(end), 2), '       终点');
xlabel('经度')
ylabel('纬度')
title(['蚁群算法优化路径(最短距离: ' num2str(shortest_Length) ')'])
figure(2)
plot(1: NC_max, lBest, 'b', 1: NC_max, lAverage, 'r:')
legend('最短距离', '平均距离')
xlabel('迭代次数')
ylabel('距离')
title('各代最短距离与平均距离对比')
            

