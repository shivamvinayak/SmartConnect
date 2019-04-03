function RelaysPaths = ComputeRelaysUsed(path,numsources,numrelays,hmax)
numnodes=numsources+numrelays+1;
RelaysPaths = zeros(numnodes,2);
for i=2:numsources+1
    node1=i;
    for j=hmax:-1:1
        node2 = path(node1,j);
        if(node1~=node2) 
            RelaysPaths(node2,1)=RelaysPaths(node2,1)+1;
            RelaysPaths(node2,2)=1;
        end;
        node1=node2;
    end
end