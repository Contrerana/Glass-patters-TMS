function sFiles1=GetFilesv2(FoldersPath,Folder,Condition, Conntype, Fband,wind, level)
% Get the list of files for subsequent analysis
% Inputs (strings):
%   FoldersPath: path to the protocol
%   Folder: group folder (individual participants)
%   Condition: '50','200' or '300' 
%   Conntype:  'wpli' or 'phaseTE' 
%   Fband: 'theta','alpha','beta','gamma'
%   wind: 'w1','w2' or 'w3'
%   level: 'scalp' or 'source' or 'source4ROIs'
% Outputs:
%   sFiles: cell array with the desired files
%
% Lorena Santamaria August 2022 (c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sFiles1=cell(1,numel(Folder));
for sb=1:numel(Folder)
    % get the connectivity files by Conntype
    sFiles=dir(fullfile(FoldersPath,Folder{sb},Condition,'*.mat'));sFiles={sFiles.name};
    sFiles(~contains(sFiles,Conntype))=[]; 
    switch level
        case 'scalp'
            sFiles(~contains(sFiles,'scalp'))=[];
        case 'source'
            sFiles(~contains(sFiles,'zscore2'))=[]; %normalised preTMS (10 ROIs)
        case 'source4ROI'
            sFiles(~contains(sFiles,'zscore2'))=[]; 
            sFiles(~contains(sFiles,'4ROI'))=[]; % only 4 ROIs
    end
    % get the window and frequency of interest
    sFiles(~(contains(sFiles,Fband) & contains(sFiles,wind)))=[];
    sFiles=cellfun(@(c)[fullfile(Folder{sb},Condition) '\' c],sFiles,'uni',false);
    % storage it
    sFiles1(sb)=sFiles;
end