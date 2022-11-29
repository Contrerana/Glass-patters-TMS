function PermutationTests_Connectivity(sFiles,sFiles2,fband,window,comment)
% Inputs:
%   sFiles: participants connectivity files for condition 1
%   sFiles2: participants connectiivty files for condition2
%   fband: 'theta','alpha','beta','gamma'
%   window: 'w1','w2' or 'w3'
%   
% Lorena Santamaria August 2022 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% find frequency band 
switch fband
    case 'theta'
        ff=[4 7.5];
    case 'tehta'
        ff=[4 7.5];
    case 'alpha'
        ff=[8 12];
    case 'beta'
        ff=[13 29];
    case 'gamma'
        ff=[30 45];
    otherwise
        errordlg('Wrong frequency input','Error');return;
end
%% find window
switch window
    case 'w1'
        ww=[-1.1 -0.1];
    case 'w2'
        ww=[-0.5 0.5];
    case 'w3'
        ww=[0 1];
    otherwise
        errordlg('Wrong time window input','Error');return;
end
%% Start a new report
bst_report('Start', sFiles);

%% Process: Perm t-test equal --> H0:(A=B), H1:(A<>B)
sFiles = bst_process('CallProcess', 'process_test_permutation2', sFiles, sFiles2, ...
    'timewindow',     ww, ...
    'freqrange',      ff, ...
    'rows',           '', ...
    'isabs',          0, ...
    'avgtime',        0, ...
    'avgrow',         0, ...
    'avgfreq',        1, ...
    'matchrows',      0, ...
    'iszerobad',      1, ...
    'Comment',        [comment '_' window '_' fband], ...
    'test_type',      'ttest_equal', ...  % Student's t-test   (equal variance) t = (mean(A)-mean(B)) / (Sx * sqrt(1/nA + 1/nB))Sx = sqrt(((nA-1)*var(A) + (nB-1)*var(B)) / (nA+nB-2))
    'randomizations', 10000, ...
    'tail',           'two');  % Two-tailed

% Save and display report
ReportFile = bst_report('Save', sFiles);
bst_report('Open', ReportFile);


