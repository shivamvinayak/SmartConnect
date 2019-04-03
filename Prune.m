function [nRelaysUsed accept vRelay path sumhi]= Prune(RelaysUsed,vRelay,numsources,numrelays,S,C,hmax,path,H)
numnodes=numsources+numrelays+1;
A = intersect(vRelay,RelaysUsed);
B = setdiff(RelaysUsed,vRelay);
RelaysPaths = ComputeRelaysUsed(path,numsources,numrelays,hmax);
[minRelay,minRelayInd] = min(RelaysPaths(B,1));
vRelay = [vRelay; B(minRelayInd)];
B(minRelayInd)=[];
%minRelayInd = ind(minRelayInd);
nRelaysUsed = union(A,B);
if iscolumn(nRelaysUsed)   newnodes = [1, 2:numsources+1 , nRelaysUsed'];
else newnodes = [1, 2:numsources+1 , nRelaysUsed];
end;
nS = S(newnodes,:);
nC = C(newnodes,newnodes);
nnumnodes = size(nS,1);
nnumrelays = numrelays+nnumnodes-numnodes;
[nW npath]=DP_HC_MWT(nS,nC,nnumnodes,hmax);
nRelaysPaths = ComputeRelaysUsed(npath,numsources,nnumrelays,hmax);
accept=false;
sumhi = sum(nW(2:numsources+1,hmax));
if (sumhi<H)
    accept=true;
    path=npath;
    if isrow(nRelaysUsed) nRelaysUsed = nRelaysUsed'; end;
    nodes = [1:numsources+1 nRelaysUsed'];
    nRelaysUsed = nodes(find(nRelaysPaths(:,2)));
    if isrow(nRelaysUsed) nRelaysUsed = nRelaysUsed'; end;
    %% This part uses the relays used, and computes the path using only relays used. Added, after we found the error, where more than one node was removed in an iteration.
    nS = S(newnodes,:);
    nC = C(newnodes,newnodes);
    nnumnodes = size(nS,1);
    nnumrelays = numrelays+nnumnodes-numnodes;
    [nW npath]=DP_HC_MWT(nS,nC,nnumnodes,hmax);
    %%
    nRelaysUsed = setdiff(nRelaysUsed,1:numsources+1);    
end;
end

    
    
