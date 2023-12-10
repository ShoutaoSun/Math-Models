clc, clear, close all
global a 
a=zeros(6); 
a(1,2)=56;a(1,3)=35;a(1,4)=21;a(1,5)=51;a(1,6)=60;
a(2,3)=21;a(2,4)=57;a(2,5)=78;a(2,6)=70; a(3,4)=36;
a(3,5)=68;a(3,6)=68; a(4,5)=51;a(4,6)=61;a(5,6)=13;
a=a+a';L=size(a,1); %返回矩阵的行数，2则是列数
c1=[5 1:4 6 ]; %5/1：4/6
[circle,long]=modifycircle(c1,L); %
c2=[5 6 1:4 ]; %改变初始圈，该算法的最后一个顶点不动
[circle2,long2]=modifycircle(c2,L);
if long2<long
    long=long2;
    circle=circle2;
end
circle,long
%外置函数
function [circle,long]=modifycircle(c1,L)
global a 
flag=1; 
while flag>0 
    flag=0;
    for m=1:L-3 
        for n=m+2:L-1 
            if a(c1(m),c1(n))+a(c1(m+1),c1(n+1))<a(c1(m),c1(m+1))+a(c1(n),c1(n+1)) 
                flag=1; 
                c1(m+1:n)=c1(n:-1:m+1); 
             end 
        end 
    end 
end 
long=a(c1(1),c1(L)); 
for i=1:L-1
    long=long+a(c1(i),c1(i+1)); 
end 
circle=c1;
end

