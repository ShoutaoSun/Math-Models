x0 = [1 1 1];  
lb = [0 0 0];  
[x,fval] = fmincon(@func,x0,[],[],[],[],lb,[],@feixianxing);