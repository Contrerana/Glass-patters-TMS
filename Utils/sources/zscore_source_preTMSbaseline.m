function zscore_source_preTMSbaseline(sFiles,sFiles2)
% zscore normalisation of the source value per participant to can make a fair comparison accross groups 
% normalisation is agains the whole pre-TMS values this time  
% inputs: 
%       sFiles: baseline
%       sFiles2: file to be normalised agains baseline
%
%
% Lorena Santamaria August 2022 (c)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start a new report
bst_report('Start', sFiles);

% Process: Z-score transformation: [All file]
sFiles = bst_process('CallProcess', 'process_baseline_norm2', sFiles, sFiles2, ...
    'baseline',   [], ...
    'source_abs', 0, ...
    'method',     'zscore');  % Z-score transformation:    x_std = (x - &mu;) / &sigma;

% Save and display report
ReportFile = bst_report('Save', sFiles);
bst_report('Open', ReportFile);

