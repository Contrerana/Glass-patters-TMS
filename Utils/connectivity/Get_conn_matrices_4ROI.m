%%  Retrieve connectivity matrices source level
%   % within each subject there are 3 folders 
%   folder 200: stimulation trials (additional 100 trigger for stim time)(~200 trials)
%   folder 300: post stimulation trials (~400 trials)
%
%  Lorena Santamaria Oct 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% path and folders
FoldersPath='Z:\lorena_TMSEEG_Entrainment\SourceConnectivity\brainstorm_db\GP_TMS2\data'; %protocol
Folders=dir(FoldersPath);Folders={Folders.name}';
Folders(~contains(Folders,'sub'))=[]; % all subjects within the protocol


%% after source locatisation steps we can calculate the sources
Conn=struct(); % storage the connectivity matrices (TMS and post TMS)
for sb=1:numel(Folders)
    fprintf('Getting connectivity matrix from %d named %s is starting\n\n\n', sb, Folders{sb});
    ID=extractBefore(Folders{sb},'_');
    Group=extractAfter(Folders{sb},'_');
    if strcmp(Group,'up') | strcmp(Group,'down')
        Group2='missmatch';
    else
        Group2=Group;
    end
    % 200 folder trials (TMS)
    sFiles=dir(fullfile(FoldersPath,Folders{sb},'200','*.mat'));sFiles={sFiles.name};
    sFiles(~contains(sFiles,'zscore2'))=[];  
    sFiles(~contains(sFiles,'4ROI'))=[]; % remove other connectivity values
    sFiles(contains(sFiles,'granger'))=[];% remove other connectivity values
    sFiles(~contains(sFiles,'phaseTE'))=[];% remove other connectivity values
    sFiles=cellfun(@(c)[fullfile(FoldersPath,Folders{sb},'200') '\' c],sFiles,'uni',false);% add full path
    TMS=GetMatrices(sFiles,ID,Group,Group2,'TMS');
    % 300 folder trials (post TMS)
    sFiles=dir(fullfile(FoldersPath,Folders{sb},'300','*.mat'));sFiles={sFiles.name};
    sFiles(~contains(sFiles,'zscore2'))=[];  
    sFiles(~contains(sFiles,'4ROI'))=[]; % remove other connectivity values
    sFiles(contains(sFiles,'granger'))=[];% remove other connectivity values
    sFiles(~contains(sFiles,'phaseTE'))=[];% remove other connectivity values
    sFiles=cellfun(@(c)[fullfile(FoldersPath,Folders{sb},'300') '\' c],sFiles,'uni',false);
    postTMS=GetMatrices(sFiles,ID,Group,Group2,'postTMS');
    % join them
    if sb==1
        Conn=cat(2,TMS,postTMS);
    else
        temp=cat(2,TMS,postTMS);
        Conn=[Conn,temp];
    end
    fprintf('Participant %d named %s is done\n\n\n', sb, Folders{sb});
end

%% save it
SavingPath='Z:\lorena_TMSEEG_Entrainment\SourceConnectivity\Results';
save(fullfile(SavingPath,'source4ROIs','source_phaseTE_4ROIs_PreTMSzscored.mat'),'Conn');


%% Calculate the mean and the median for each window 
ConnAvg=[];
IDs=unique({Conn.ID}); % participants names
for sb=1:numel(IDs)
    % find the corresponding rows
    idx=strcmp({Conn.ID},IDs{sb}); % 3 windows 4 freq 2 conditions
    % get the substruct
    temp=Conn(idx);
    % obtain the values we want
    M={temp.Conn};
    % remove useless fields
    temp=rmfield(temp,'ROInames'); 
    temp=rmfield(temp,'Conn'); 
    % do the calculations
    men=cellfun(@(x) mean(x(:)),M,'UniformOutput',false);
    medn=cellfun(@(x) median(x,'all'),M,'UniformOutput',false);
    Max=cellfun(@(x) max(x(:)),M,'UniformOutput',false);
    Min=cellfun(@(x) min(x(:)),M,'UniformOutput',false);
    % put it back
    [temp.AvgConn]=men{:};
    [temp.MeanConn]=medn{:};
    [temp.MaxConn]=Max{:};
    [temp.MinConn]=Min{:};
    % Joint to the main one
    if sb==1
        ConnAvg=temp;
    else
        ConnAvg=[ConnAvg,temp];
    end
end
%% pass it to a csv file and save it
T=struct2table(ConnAvg);
writetable(T,fullfile(SavingPath,'source4ROIs','source_wPLI_4ROIs_PreTMSzscored_avg.csv'));

