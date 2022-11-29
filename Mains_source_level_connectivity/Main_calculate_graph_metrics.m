%% Main programm to calculate graph metrics
% Calls the connectivity results from Brainstorm 
% Dependencies: BCT https://sites.google.com/site/bctnet/
%
% Lorena Santamaria Nov'22
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% paths
Folder='Z:\lorena_TMSEEG_Entrainment\SourceConnectivity\Results';  % files
addpath(genpath('C:\Users\ls785\Documents\MATLAB\Toolboxes\BCT')); %tollbox
%% gather the data
scalpTE=load(fullfile(Folder,'scalp_phaseTE_PreTMSzscored.mat'));
sourceTE4=load(fullfile(Folder,'source4ROIs','source_phaseTE_4ROIs_PreTMSzscored'));
sourcewPLI4=load(fullfile(Folder,'source4ROIs','source_wPLI_4ROIs_PreTMSzscored'));

%% get the field names
fieldname=fieldnames(scalpTE);scalpTE=getfield(scalpTE,fieldname{1});
fieldname=fieldnames(sourceTE4);sourceTE4=getfield(sourceTE4,fieldname{1});
fieldname=fieldnames(sourcewPLI4);sourcewPLI4=getfield(sourcewPLI4,fieldname{1});
clear('fieldname');
% now all equal so we can get the 'real' fieldnames
fields=fieldnames(scalpTE); % ID, group (4 levels), group2 (3 levels: up/down together), TMS trials, postTMS trials

%% thresholds to calculate metrics
tholds=[1,0.3,0.2,0.15,0.1];
tholds=1;
%% call the graph metrics function
GMscalpTE=CallingGraphFunc(scalpTE,tholds);
GMsourceTE4=CallingGraphFunc(sourceTE4,tholds);
GMsourcewPLI4=CallingGraphFunc(sourcewPLI4,tholds);               
%% tyding up for further analysis and saving it
list=fieldnames(GMscalpTE);
id=contains(list,'In');id2=contains(list,'Out');

% individual metrics only
GMscalpTE1=GMscalpTE;GMscalpTE1= rmfield(GMscalpTE1,list(id | id2));
TscalpTE=struct2table(GMscalpTE1);
writetable(TscalpTE,'GraphMetrics_Scalp_PhaseTE.csv')
save('GraphMetrics_scalp_phaseTE.mat','GMscalpTE');


GMsourceTE41=GMsourceTE4;GMsourceTE41= rmfield(GMsourceTE41,list(id | id2));
TsourceTE4ROIS=struct2table(GMsourceTE41);
writetable(TsourceTE4ROIS,'GraphMetrics_source_PhaseTE_4ROIs.csv')
save('GraphMetrics_source_phaseTE_4ROIs.mat','GMsourceTE4');

TsourcewPLI4ROIs=struct2table(GMsourcewPLI4);
writetable(TsourcewPLI4ROIs,'GraphMetrics_source_wPLI_4ROIs.csv')
save('GraphMetrics_source_wPLI_4ROIs.mat','GMsourcewPLI4');