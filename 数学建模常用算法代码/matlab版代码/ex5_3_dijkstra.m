clc, clear, a=zeros(6);
a(1,[2,4,5,6])=[50,40,25,10]; 
a(2,[3,4,6])=[15,20,25];
a(3,[4,5])=[10,20]; 
a(4,[5,6])=[10,25];
a(5,6)=55; 
G = graph(a,'upper'); 
d = distances(G,'Method','positive')

