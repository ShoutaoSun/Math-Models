clc, clear, close all, a=zeros(7); 
a(1,[2 3])=[50,60];a(3,[4,7])=[52,45]; 
a(2,[4 5])=[65 40]; a(4,[5:7])=[50,30,42]; 
a(5,6)=70; 
s=cellstr(strcat('v',int2str([1:7]'))); 
G=graph(a,s,'upper'); 
p=plot(G,'EdgeLabel',G.Edges.Weight) 
T=minspantree(G,'Method','sparse') 
L=sum(T.Edges.Weight), highlight(p,T) 

