function GM=Call_BCT(A,tholds)
% Inputs:
%    A: struct with one participant info
%       ID: participant ID
%       Group: 'match','up','down','sham'
%       Group2:' match','mismatch','sham'
%       TMS: struct with connectivity metrics during TMS trials
%       postTMS: struct with connectivity metrics post TMS trials
%          tholds: array of thresholds to calculate metrics
 
% Output:
%   GM: struct with all the connectivity values
%   
%
%
% Lorena Santamaria Nov'22
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check the TMS and postTMS fields exist and gather that info
fieldlist=fieldnames(A);
if sum(strcmp(fieldlist,'TMS'))==1
    TMS=getfield(A,'TMS'); % all windows and frequency connectivities
else
    disp('No enough arguments');
    return;
end

if sum(strcmp(fieldlist,'postTMS'))==1
    postTMS=getfield(A,'postTMS'); % all windows and frequency connectivities
else
    disp('No enough arguments');
    return;
end
%% get the general info
ID=A.ID;Group=A.Group;Group2=A.Group2;
%% we can TMS and postTMS trials ==> loop to get the graph metrics
fieldlist=fieldnames(TMS);
GM=struct();
for ff=1:numel(fieldlist)
    % TMS trials
    X=getfield(TMS,fieldlist{ff}); %the connectivity matrix
    GM1=finnallyBCT(X,ID,Group,Group2,fieldlist{ff},'TMS',tholds);
    % postTMS trials
    X=getfield(postTMS,fieldlist{ff}); %the connectivity matrix
    GM2=finnallyBCT(X,ID,Group,Group2,fieldlist{ff},'postTMS',tholds);   
    % both together
    combined = cat(2,GM1,GM2); 
    if ff==1
        GM=combined;
    else
        GM=cat(2,GM,combined);
    end
end

