perminute=[242	245	244	248	247	248	242	244	246	242;
248	246	245	247	248	250	247	246	243	244;
246	248	250	252	248	250	246	248	245	250];
result=[0,0,0];
%正态性检验
for i=1:3
    x_i=perminute(i,:)'; %提取第i个group的睁眼状态下的脑电信号功率值
    [h,p]=lillietest(x_i); %正态性检验
    result(i)=p; 
end
result %检验正态检验的p值
 
%方差齐性检验
[p,stats]=vartestn(perminute'); %调用vartestn函数进行方差齐次性检验

p=anova1(perminute');
[p,table,stats]=anova2(perminute',5);

%多重比较
[c,m,h,gnames]=multcompare(stats); %多重比较
head={'组序号','组序号','置信下限','置信上限','组均值差','p-value'};
[head;num2cell(c)]  %将矩阵c转为元胞数组，并与head一起显示
head={'均值的估计值','标准误差'};
%m=num2cell(m);
[head;num2cell(m)]

