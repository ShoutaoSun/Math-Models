P1=0.000004; % 树木自然着火概率
P2 =0.01; %空地长出树木概率
%假设空地长出树木，树木燃烧变成空地只需要1回合
size =400; %森林大小
trees =zeros(size,size);
d1 = [size , 1:size-1];
d2 = [2:size , 1];
result = image(cat(3, (trees == 2), (trees == 1), zeros(size)))
for i =1:2000
    neighbour = (trees(d1,:)==2)+(trees(d2,:)==2)+(trees(:,d1)==2)+(trees(:,d2)==2);%周围着火树木数量
    trees =trees+(trees==1 &(neighbour>0|rand(size,size)<=P1)) ...%自然着火，受周围影响着火
      + (neighbour==0 &rand(size,size)<=P2& trees==0) +(trees==2)*(-2); %周围无火焰的空地恢复成树木，燃烧树木变成空地
  set(result, 'cdata', cat(3, (trees == 2), (trees == 1), zeros(size)) );
  drawnow
  pause(0.01)
end
