%% Normalise sources
%  GP_TMS (data collected and preprocessed by Lizzie)
%  Source values per participant and condition calculated but need
%  normalisation to make a group comparisons, we z-score them agains the
%  pre-TMS results (folder 50)
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
%% after source locatisation steps we can calculate the sources
for sb=1:numel(Folders)
    fprintf('Start processing participant %d named %s is starting\n\n\n', sb, Folders{sb});
    %% 50 folder trials (pre-TMS)  --> use it as baseline
    sFiles=dir(fullfile(FoldersPath,Folders{sb},'50','*.mat'));sFiles={sFiles.name}';
    sourceF=sFiles;sourceF(~contains(sFiles,'MN_EEG'))=[]; %get the corresponding file
    sourceF(contains(sourceF,'zscore'))=[]; % previously zscore data
    originalF=sFiles;originalF(~contains(sFiles,'average'))=[];%get the dependency file
    %add the folder
    sourceF=cellfun(@(c)[fullfile(Folders{sb},'50') '/' c],sourceF,'uni',false);
    originalF=cellfun(@(c)[fullfile(Folders{sb},'50') '/' c],originalF,'uni',false);
    %create the sFile
    sFiles={['link|' sourceF{1} '|' originalF{1}]};
    %% 200 folder trials (TMS)
    sFiles2=dir(fullfile(FoldersPath,Folders{sb},'200','*.mat'));sFiles2={sFiles2.name}';
    sourceF=sFiles2;sourceF(~contains(sFiles2,'MN_EEG'))=[]; %get the corresponding file
    sourceF(contains(sourceF,'zscore'))=[];
    originalF=sFiles2;originalF(~contains(sFiles2,'average'))=[];%get the dependency file
    %add the folder
    sourceF=cellfun(@(c)[fullfile(Folders{sb},'200') '\' c],sourceF,'uni',false);
    originalF=cellfun(@(c)[fullfile(Folders{sb},'200') '\' c],originalF,'uni',false);
    %create the sFile
    sFiles2={['link|' sourceF{1} '|' originalF{1}]};
    % calculate the baseline zscore
    zscore_source_preTMSbaseline(sFiles,sFiles2)
    %% 300 folder trials (post-TMS)
    sFiles3=dir(fullfile(FoldersPath,Folders{sb},'300','*.mat'));sFiles3={sFiles3.name}';
    sourceF=sFiles3;sourceF(~contains(sFiles3,'MN_EEG'))=[]; %get the corresponding file
    sourceF(contains(sourceF,'zscore'))=[];
    originalF=sFiles3;originalF(~contains(sFiles3,'average'))=[];%get the dependency file
    %add the folder
    sourceF=cellfun(@(c)[fullfile(Folders{sb},'300') '\' c],sourceF,'uni',false);
    originalF=cellfun(@(c)[fullfile(Folders{sb},'300') '\' c],originalF,'uni',false);
    %create the sFile
    sFiles3={['link|' sourceF{1} '|' originalF{1}]};
    %calculate the baseline zscore
    zscore_source_preTMSbaseline(sFiles,sFiles3);
end