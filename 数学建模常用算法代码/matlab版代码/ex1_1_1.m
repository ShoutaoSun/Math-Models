c = [-2 -3];  
A = [2 -1;
        -1 1;
        -1 -1];
b = [2 1 -1];   
[x fval] = linprog(c, A, b, [], [],[],[]) 

[x,fval] =linprog(c,A,b,Aeq,beq,lb,ub)

min y=-2x1-3x2
2x1-x2<=2
-x1+x2<=1
-x1-x2<=1