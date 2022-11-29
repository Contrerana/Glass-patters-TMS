%% Preparation for source connectivity analysis 
%  GP_TMS (data collected and preprocessed by Lizzie)
%  
%  Dependencies: Brainstorm
%
%  Lorena Santamaria August 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% path and folders
FoldersPath='Z:\lorena_TMSEEG_Entrainment\SourceConnectivity\brainstorm_db\GP_TMS2\data'; %protocol
Folders=dir(FoldersPath);Folders={Folders.name}';
Folders(~contains(Folders,'sub'))=[]; % all subjects within the protocol
% within each subject there are 3 folders 
%   folder 50: pre stimulation trials (~200 trials)
%   folder 200: stimulation trials (additional 100 trigger when the stim
%             stopped)(~200 trials)
%   folder 300: post stimulation trials (~400 trials)

%% start source locatisation steps
for sb=1:numel(Folders)
    fprintf('Start processing participant %d named %s is starting\n\n\n', sb, Folders{sb});
    % 50 folder trials (pre-TMS)
    sFiles=dir(fullfile(FoldersPath,Folders{sb},'50','*.mat'));sFiles={sFiles.name};
    sFiles(~contains(sFiles,'trial'))=[];
    sFiles1=cellfun(@(c)[fullfile(FoldersPath,Folders{sb},'50') '\' c],sFiles,'uni',false);
    % 200 folder trials (TMS)
    sFiles=dir(fullfile(FoldersPath,Folders{sb},'200','*.mat'));sFiles={sFiles.name};
    sFiles(~contains(sFiles,'trial'))=[];
    sFiles2=cellfun(@(c)[fullfile(FoldersPath,Folders{sb},'200') '\' c],sFiles,'uni',false);
    % 300 folder trials (TMS)
    sFiles=dir(fullfile(FoldersPath,Folders{sb},'300','*.mat'));sFiles={sFiles.name};
    sFiles(~contains(sFiles,'trial'))=[];
    sFiles3=cellfun(@(c)[fullfile(FoldersPath,Folders{sb},'300') '\' c],sFiles,'uni',false);
    % concatenate them
    sFiles=[sFiles1,sFiles2,sFiles3];
    % calculate things:
    % step 1:inverse model: standard anatomy and standard locations then
    % we only need to calculate it for 1 participant and then copy it to the
    % rest as it will be the same for all
    % step 2: noise covariance from a non-significant part of the trial
    compute_noise_covariance(sFiles);
    % step 3: data covariance from the data (part where actually
    % interesting things are going on)
    compute_data_covariance(sFiles);
    % step 4: average per participant and per condition
    compute_average_condition(sFiles);
    fprintf('Participant %d named %s is done\n\n\n', sb, Folders{sb});
    clear('sFiles','sFiles1','sFiles2','sFiles3');
end

