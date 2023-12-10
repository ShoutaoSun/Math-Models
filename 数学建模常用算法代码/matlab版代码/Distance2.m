function D = Distance2(citys)
%% 计算两两城市之间的距离
% 输入:各城市的经纬度坐标(citys)
% 输出:两两城市之间的距离(D)
 
n = size(citys, 1);
D = zeros(n, n);
r = 6378.137;   %地球半径
for i = 1: n
    for j = i + 1: n
        D(i, j) = r * acosd( cosd( citys(i,1) - citys(j,1) )* cosd(citys(i, 2))* cosd(citys(j, 2))+ sind(citys(i,2))* sind(citys(j,2)) );
        D(j, i) = D(i, j);
    end
    D(i, i) = 1e-4;              %对角线的值为0，但由于后面的启发因子要取倒数，因此用一个很小数代替0
end