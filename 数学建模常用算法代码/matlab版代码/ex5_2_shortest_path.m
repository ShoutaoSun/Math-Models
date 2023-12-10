clc, clear, close all 
E = [1,2,50; 1,4,40; 1,5,25; 1,6,10; 2,3,15; 2,4,20; 2,6,25; 
3,4,10;3,5,20; 4,5,10; 4,6,25; 5,6,55]; 
G = graph(E(:,1), E(:,2), E(:,3)); 
p = plot(G,'EdgeLabel',G.Edges.Weight,'Layout', 'circle');
[path2, d2] = shortestpath(G, 1, 2) %求1到2的最短路
highlight(p,path2,'EdgeColor','r','LineWidth',1.5)%在图中画出path2的路线
[path3, d3] = shortestpath(G, 1, 3, 'method','positive') %同上，'method','positive'可省略
highlight(p,path3,'EdgeColor', 'm','LineWidth',1.5) 

