clc, clear, close all
a = zeros(6); a(1,[2,4])=[8,7]; 
a(2,[3,4])=[9,5]; a(3,[4,6])=[2,5]; 
a(4,5)=9; a(5,[3,6])=[6,10]; 
G = digraph(a);
H=plot(G,'EdgeLabel',G.Edges.Weight); 
[M,F]=maxflow(G,1,6)           
F.Edges, highlight(H,F, 'EdgeColor','r','LineWidth',1.5)

