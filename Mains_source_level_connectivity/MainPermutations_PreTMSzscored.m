FoldersPath='Z:/lorena_TMSEEG_Entrainment/SourceConnectivity/brainstorm_db/GP_TMS2/data'; %protocol
Folders=dir(FoldersPath);Folders={Folders.name}';
Folders(~contains(Folders,'sub'))=[]; % all subjects within the protocol

% within subject conditions
%   folder 50: pre stimulation trials 
%   folder 200: stimulation trials 
%   folder 300: post stimulation trials 

% within subjects windows
%   w1: TMS
%   w2: some TMS + stimuli onset
%   w2: stimuli onset + answer

% groups: 
%   match
%   mismatch: up & down (half and half)
%   sham
%%  Find groups

idx_match=contains(Folders,'match');
idx_sham=contains(Folders,'sham');
idx_mismatch=contains(Folders,'up')|contains(Folders,'down');
sizes=[sum(idx_match),sum(idx_sham),sum(idx_mismatch)]

Fmatch=Folders(idx_match);
Fmiss=Folders(idx_mismatch);
Fsham=Folders(idx_sham);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                 GROUP DIFFERENCES PRE/DURING/POST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% set-ups
Condition={'200','300'};
fband={'tehta','alpha','beta','gamma'};
wind={'w1','w2','w3'};

[A,B,C]=ndgrid(1:2,1:4,1:3); %condition (2) / fband(4) / wind (3)
ind = [A(:),B(:),C(:)]';

%% do the combinations match-missmatch
for ii=1:size(ind,2)
    temp=ind(:,ii);
    sFiles1=GetFilesv2(FoldersPath,Fmatch,Condition{temp(1)},'granger',fband{temp(2)},wind{temp(3)},'source4ROI');
    sFiles2=GetFilesv2(FoldersPath,Fmiss,Condition{temp(1)},'granger',fband{temp(2)},wind{temp(3)},'source4ROI');

    PermutationTests_Connectivity(sFiles1,sFiles2,fband{temp(2)},wind{temp(3)},'source4ROIs_granger_zscored_match_miss');
end

%% do the combinations match-sham
for ii=1:size(ind,2)
    temp=ind(:,ii);
    sFiles1=GetFilesv2(FoldersPath,Fmatch,Condition{temp(1)},'granger',fband{temp(2)},wind{temp(3)},'source4ROI');
    sFiles2=GetFilesv2(FoldersPath,Fsham,Condition{temp(1)},'granger',fband{temp(2)},wind{temp(3)},'source4ROI');

    PermutationTests_Connectivity(sFiles1,sFiles2,fband{temp(2)},wind{temp(3)},'source4ROIs_granger_zscored_match_sham');
end
%% do the combinations mismatch-sham
for ii=1:size(ind,2)
    temp=ind(:,ii);
    sFiles1=GetFilesv2(FoldersPath,Fmiss,Condition{temp(1)},'granger',fband{temp(2)},wind{temp(3)},'source4ROI');
    sFiles2=GetFilesv2(FoldersPath,Fsham,Condition{temp(1)},'granger',fband{temp(2)},wind{temp(3)},'source4ROI');
    PermutationTests_Connectivity(sFiles1,sFiles2,fband{temp(2)},wind{temp(3)},'source4ROIs_granger_zscored_mismatch_sham');
end
