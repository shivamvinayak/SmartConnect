function [W path]=DP_HC_MWT(S,C,nnodes,hmax)
% Dynamic program to compute the shortest paths with hop count to every
% source node in the network. W shows the minimum hops required in n hops,
% where n is the column number. path shows the path followed from the sink
% to each source node. 
W = ones(nnodes,hmax);
path=ones(nnodes,hmax);
W =inf*W;
W(:,1)=C(:,1);
for j=2:hmax
    for i=1:nnodes
        %nnodes;
        %horzcat(W(:,j-1),C(:,i))
        [a,b] = min(W(:,j-1) + C(:,i));
        W(i,j) = a;
        %if(b==i)
        %    path(i,j)=path(i,j-1);
        %else
            path(i,j)=b;
        %end
    end;
end;  

