function [c,ceq] = feixianxing(x)
      c = [-x(1)^2+x(2)-x(3)^2; x(1)+x(2)^2+x(3)^2-20];
      ceq = [-x(1)-x(2)^2+2; x(2)+2*x(3)^2-3]; 
end
