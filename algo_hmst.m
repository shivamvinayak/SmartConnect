clc;
clear;
clrmx=[];

%Clearing the status info
dlmwrite('textfiles/path_info_kconnect.txt',clrmx,'delimiter','\t');
dlmwrite('textfiles/path_info_final.txt',clrmx,'delimiter','\t');
dlmwrite('textfiles/path_info_tosend.txt',clrmx,'delimiter','\t');

%reading the QoS parameters
bounds = dlmread('textfiles/hop_to_delay_bound.txt');
D=dlmread('textfiles/delay.txt');
K=dlmread('textfiles/k.txt');

range = dlmread('textfiles/communication_range.txt');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%HARDCODING
%range=8;% for testing purpose
delay = D;

for i=1:1:length(bounds)
   if(delay<bounds(i))
        break;
   end
end

hops_max = i-1;
hmax=hops_max; % max hop-count possible in the design!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%HARDCODING
%hmax=5;%for testing purpose

dlmwrite('textfiles/hops.txt',hops_max);
dlmwrite('textfiles/repair_status.txt',2);
dlmwrite('textfiles/SPT_status.txt',0);

S = dlmread('textfiles/coordinates.txt'); %Coordinates of the potetial locations

source_array=dlmread('textfiles/sources.txt');% Coordinates of source nodes
source_array = source_array(1:length(source_array)-1);

numsources=size(source_array,1);
numsources=numsources-1;
numnodes=size(S,1);
numrelays=numnodes-numsources;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%HARDCODING
H=50;
nodelist = 1:numnodes;
b=setdiff(nodelist,source_array);
nodelist(1:numsources+1)=source_array;
nodelist(numsources+2:numnodes)=b;

tempa = S(source_array,:);
tempb = S;
tempb(source_array,:)=[];
S=[tempa;tempb];

C = ComputeWeights(S,numnodes,range); % returns valid edges in the graph

[W path]=DP_HC_MWT(S,C,numnodes,hmax);
%keyboard

RelaysPaths = ComputeRelaysUsed(path,numsources,numrelays,hmax);
DPminhi = sum(W([2:numsources+1],hmax));

if (DPminhi > H)
    disp('delay constraint is possibly infeasible');
	dlmwrite('textfiles/SPT_status.txt',2);
else
    dlmwrite('textfiles/SPT_status.txt',1);
    vRelay = [];  %% Visited relays
    RelaysUsed = numsources+1+ find(RelaysPaths(numsources+2:numnodes,2)); % Removing the source nodes which is being used as relays.
    
    tempRelaysUsed = [1:numsources+1 RelaysUsed'];
    nS = S(tempRelaysUsed,:);
    temp_numnodes=size(tempRelaysUsed,2);
    
    nC = ComputeWeights(nS,temp_numnodes,range);
    
    [W path]=DP_HC_MWT(nS,nC,temp_numnodes,hmax);
    
    SigHi=[sum(W([2:numsources+1],hmax))];
    [ai bi]=size(RelaysUsed);
    CountRelays=[ai];
    %OptRelays = ai;
    %keyboard
    count=1;
    while (all(ismember(RelaysUsed,vRelay))==0)
        [nRelaysUsed accept vRelay npath sumhi]=Prune(RelaysUsed,vRelay,numsources,numrelays,S,C,hmax,path,H);
        if (accept==true)
            count=count+1;
            if (sumhi==inf) sumhi=SigHi(count-1); end;
            SigHi = [SigHi,sumhi];
            [ai bi] = size(nRelaysUsed);
            RelaysUsed = nRelaysUsed;
            path=npath;
            CountRelays = [CountRelays, ai];
            OutputRelays(2*count-1) = CountRelays(end);
            OutputRelays(2*count)= sumhi;   
            disp(size(npath));
            disp(size(nRelaysUsed));
        end;
    end;
    
    %displayop(S,path,numsources,numrelays,hmax
    RelaysUsed = nodelist(RelaysUsed);
    RelaysUsed = [source_array; RelaysUsed'];

    pathvector = path;
    for i=hmax-1:-1:1
       pathvector(:,i)=pathvector(pathvector(:,i+1),i);  
    end
    for i=hmax:-1:1
     pathvector(:,i)=RelaysUsed(pathvector(:,i));
    end
    pathvector = pathvector(1:numsources+1,:);
    path_order = zeros(numsources+1,hmax);
    path_order(:,1) = source_array;
    
    for j=2:hmax        
        path_order(:,j)=pathvector(:,hmax-j+2);
    end
    
    path_to_be_send = zeros(numsources+1,hmax);
    for i=1:numsources+1
        temp=path_order(i,:);
        for j=hmax-1:-1:1
            if temp(j)==temp(j+1)
                temp(j)=[];
                temp=[temp 0];
            end
        end
        path_to_be_send(i,:)=temp;
    end;
        
    disp('delay is feasible');
    dlmwrite('textfiles/path_info_tosend.txt',path_to_be_send,'delimiter','\t')

end;
    
