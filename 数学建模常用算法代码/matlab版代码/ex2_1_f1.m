[x,y]=ode15s(@c1,[0,2000],[2 0])
plot(x,y(:,1),'*')

function dy = c1(x,y)
 dy=zeros(2,1);
 dy(1)=y(2);
 dy(2)=500*(1-2*y(1)^2)*y(2)-2*y(1);
end