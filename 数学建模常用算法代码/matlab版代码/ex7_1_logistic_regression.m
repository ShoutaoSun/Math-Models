%% 数据准备
% x_{i} \in {1 \times d} 一个样本
% y_{i} \in {0,1}
% 二分类 随机生成数据。  200个数据  每个数据2个特征
% 在我们的数据中，一行表示一个样本
data=1*rand(300,2);
label=zeros(300,1);
 
label((data(:,2)>1+data(:,1)>1))=1;
%在data上加常数特征项；
data=[data,ones(size(data,1),1)];
 
%打乱顺序
randIndex = randperm(size(data,1));
data_new=data(randIndex,:);
label_new=label(randIndex,:);
 
%80%训练  20%测试
k=0.8*size(data,1);
X=data_new(1:k,:);
Y=label_new(1:k,:);
tstX=data_new(k+1:end,:);
tstY=label_new(k+1:end,:);
 

max_iter = 300;
%% 调用函数
[loss,acc,pre_Y] = logistic_regression(X,Y,tstX,tstY,max_iter);
acc
% 画出迭代过程损失函数值的变化
plot(loss(2:end))

function [loss,acc,pre_Y] = logistic_regression(X,Y,tstX,tstY,max_iter)
%% 梯度下降法
iter = 1;
epsilon = 1e-5;
loss = zeros(max_iter,1);
alpha = 1; % 学习率为1
[m,d] = size(X);
theta = rand(d,1); % 初始化
while iter < max_iter
    % 计算梯度
    % 将求和写成矩阵的形式
    h = 1./(1+exp(-X*theta)); % h(\theta)
    item1 = repmat(h,1,d); 
    item2 = repmat(Y,1,d);
    g = sum(X.*(item1-item2))/m;  
    g = g'; % 梯度    
    
    theta = theta-alpha*g;
    
    iter = iter+1;
    loss(iter) = -(Y'*log(h)+(1-Y')*log(1-h))/m; % 计算交叉熵损失
    
    if norm(loss(iter)-loss(iter-1)) < epsilon
        break;
    end
end
%% 预测
tmp = tstX*theta;
p1 = 1./(1+exp(-tmp));
% 预测值
pre_Y = p1>0.5; % 大于0.5表示正类
% 精度
acc = sum(pre_Y==tstY)/length(tstY)*100;
end