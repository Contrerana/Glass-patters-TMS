function cumpute_wPLI_windows(sFiles,window,fband, ROI_list)
% sFiles: source info from participant 
% wPLI is calculate per window and f band of interest
% 10 scouts or ROI predefined from previous studies
% window of interes:
%                   w1: -1100ms to -100ms
%                   w2:  -500 to 500ms
%                   w3:    0 to 1000ms  
% frequencies of interest:
%   'theta', '4, 7.5' / 'alpha', '8, 12' /'beta', '13, 29'/'gamma', '30, 45'
% 10 ROI:{'G_front_sup L', 'G_front_sup R', 'G_occipital_middle L', 'G_occipital_middle R',...
%        'S_intrapariet_and_P_trans L', 'S_intrapariet_and_P_trans R', 'S_oc_sup_and_transversal L',...
%         'S_oc_sup_and_transversal R', 'S_precentral-sup-part L', 'S_precentral-sup-part R'}
%
% 4 ROI:{'G_occipital_middle L','G_front_sup L','G_precentral
%         L','G_parietal_inf_angular L'}
%
%
% Lorena Santamaria -August 2022 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% first parameters
switch window
    case 'w1'
        twin=[-1.1 -0.1];
    case 'w2'
        twin=[-0.5 00.5];
    case 'w3'
        twin=[0 1];
    otherwise
        disp('Error');return;
end

switch fband
    case 'theta'
        bands={'theta', '4, 7.5', 'mean'};
    case 'alpha'
        bands={'alpha', '8, 12', 'mean'};
    case 'beta'
        bands={'beta', '13, 29', 'mean'};
    case 'gamma'
        bands={'gamma', '30, 45', 'mean'};
    otherwise
        return
end


%% Start a new report
bst_report('Start', sFiles);

% Process: wPLI: Weighted phase lag index
sFiles = bst_process('CallProcess', 'process_plv1n', sFiles, [], ...
    'timewindow', twin, ... %[-1.1 -0.1] [-0.5 0.5] [0 1]
    'scouts',     {'Destrieux',ROI_list}, ...
    'scoutfunc',  1, ...  % Mean
    'scouttime',  1, ...  % Before
    'freqbands',  bands,...%{'gamma', '30, 45', 'mean'}
    'plvmethod',  'wpli', ...  % wPLI: Weighted phase lag index
    'keeptime',   0, ...
    'plvmeasure', 2, ...  % Magnitude
    'outputmode', 1);  % Save individual results (one file per input file)

% Save and display report
ReportFile = bst_report('Save', sFiles);
bst_report('Open', ReportFile);

