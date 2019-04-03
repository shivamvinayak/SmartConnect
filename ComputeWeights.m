function C=ComputeWeights(S,numnodes,range)

% if the two nodes are within range, edge weight is 1, otherwise it is
% infinity. Weight of the path between a node to itself is 0.
for i=1:numnodes
    for j=1:numnodes
        dis(i,j) = sqrt((S(i,1)-S(j,1))^2+(S(i,2)-S(j,2))^2);
        if(dis(i,j)>range) C(i,j)=inf; end;
        if(dis(i,j)<range) C(i,j)=1; end;
        if(i==j) C(i,j)=0;end;
    end;
end;