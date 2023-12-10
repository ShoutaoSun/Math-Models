n=10000000; 
x1=unifrnd(22,23,n,1);  
x2=x1 - 10;
x3=unifrnd(11,13,n,1);  
fmax=-inf; % 初始化函数f的最大值为负无穷
for i=1:n
    x = [x1(i), x2(i), x3(i)]; 
if (-x(1)+2*x(2)+2*x(3)>=0)  &  (x(1)+2*x(2)+2*x(3)<=72)
        result = x(1)*x(2)*x(3); 
if  result  > fmax
            fmax = result; 
            X = x; 
         end
    end
end
fmax
X
