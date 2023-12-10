x0=[1,2,3,4,5];
y0=[1.6,1.8,3.2,5.9,6.8];
x=1:0.1:5;
y_linearintercept=interp1(x0,y0,x,'linear');
y_splineintercept=interp1(x0,y0,x,'spline');
y_lagrangeintercept=lagrange_intercept(x0,y0,x);
subplot(1,2,1);plot(x0,y0,'r*',x,y_linearintercept,'b-',x,y_splineintercept,'g-',x,y_lagrangeintercept,'r-'); 

x1=100:100:500;y1=100:100:400;
z1=[636,697,624,478,450;698,712,630,478,420;680,674,598,412,400;662,626,552,334,310];
x=100:10:500;y=100:10:400;
z=interp2(x1,y1',z1,x,y','spline');
subplot(1,2,2);mesh(x,y',z);hold on;mesh(x1,y1',z1);
function yh= lagrange_intercept(x,y,xh)
%此处显示有关此函数的摘要
%   此处显示详细说明
  n = length(x);
  m = length(xh);
  x = x(:);
  y = y(:);
  xh = xh(:);
  yh = zeros(m,1); 
  c1 = ones(1,n-1);
  c2 = ones(m,1);
  for i=1:n,
    xp = x([1:i-1 i+1:n]);
    yh = yh + y(i) * prod((xh*c1-c2*xp')./(c2*(x(i)*c1-xp')),2);
  end
end

