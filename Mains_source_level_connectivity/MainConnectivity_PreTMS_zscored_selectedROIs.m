%% Compute wPLI 
%  GP_TMS (data collected and preprocessed by Lizzie)
%  Only 4 ROI: frontal, main motor areas, stimulation place and visual
%
%  Dependencies: Brainstorm
%
%  Lorena Santamaria -Oct 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% path and folders
FoldersPath='Z:\lorena_TMSEEG_Entrainment\SourceConnectivity\brainstorm_db\GP_TMS2\data'; %protocol
Folders=dir(FoldersPath);Folders={Folders.name}';
Folders(~contains(Folders,'sub'))=[]; % all subjects within the protocol
% within each subject there are 3 folders 
%   folder 50: pre stimulation trials (~200 trials) -- this has been used
%   to zscore the other two datasets
%   folder 200: stimulation trials (additional 100 trigger when the stim
%             stopped)(~200 trials)
%   folder 300: post stimulation trials (~400 trials)
%% ROI
ROI_list={'G_occipital_middle L','G_front_sup L','G_precentral L','G_pariet_inf-Angular L'};
% 10 ROI:
% ROI_list={'G_front_sup L', 'G_front_sup R', 'G_occipital_middle L', 'G_occipital_middle R',...
%        'S_intrapariet_and_P_trans L', 'S_intrapariet_and_P_trans R', 'S_oc_sup_and_transversal L',...
%         'S_oc_sup_and_transversal R', 'S_precentral-sup-part L', 'S_precentral-sup-part R'}
%% after source locatisation steps we can calculate the sources
for sb=1:numel(Folders)
    fprintf('Start processing participant %d named %s is starting\n\n\n', sb, Folders{sb});
    %% 200 folder trials (pre-TMS)
    sFiles=dir(fullfile(FoldersPath,Folders{sb},'200','*.mat'));sFiles={sFiles.name}';
    sFiles(~contains(sFiles,'results_zscore'))=[]; %get the zscore file(s)
    %add the folder
    sFiles=cellfun(@(c)[fullfile(Folders{sb},'200') '\' c],sFiles,'uni',false);
% % % % % % % % % % % % % % %     cumpute_wPLI_windows(sFiles,'w3','gamma',ROIlist); 
% % % % % % % %     cumpute_PhaseTE_windows(sFiles,'w1','theta', ROIlist)
    compute_Granger_bivariate_windows(sFiles,'w3','gamma', ROI_list);
    %% 300 folder trials (pre-TMS)
    sFiles=dir(fullfile(FoldersPath,Folders{sb},'300','*.mat'));sFiles={sFiles.name}';
    sFiles(~contains(sFiles,'results_zscore'))=[]; %get the zscore file(s)    %add the folder
    sFiles=cellfun(@(c)[fullfile(Folders{sb},'300') '\' c],sFiles,'uni',false);
% % % % % % % % % % % % % % % %    cumpute_wPLI_windows(sFiles,'w3','gamma',ROIlist);
% % % % % % % % % % % % % %      cumpute_PhaseTE_windows(sFiles,'w1','alpha',ROIlist);
    compute_Granger_bivariate_windows(sFiles,'w3','gamma', ROI_list);
end
