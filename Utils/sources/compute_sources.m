function compute_sources(sFiles)

% Start a new report
bst_report('Start', sFiles);

% Process: Compute sources [2018]
sFiles = bst_process('CallProcess', 'process_inverse_2018', sFiles, [], ...
    'output',  1, ...  % Kernel only: shared
    'inverse', struct(...
         'Comment',        'MN: EEG', ...
         'InverseMethod',  'minnorm', ...
         'InverseMeasure', 'amplitude', ...
         'SourceOrient',   {{'fixed'}}, ...
         'Loose',          0.2, ...
         'UseDepth',       1, ...
         'WeightExp',      0.5, ...
         'WeightLimit',    10, ...
         'NoiseMethod',    'reg', ...
         'NoiseReg',       0.1, ...
         'SnrMethod',      'fixed', ...
         'SnrRms',         1e-06, ...
         'SnrFixed',       3, ...
         'ComputeKernel',  1, ...
         'DataTypes',      {{'EEG'}}));

% Save and display report
ReportFile = bst_report('Save', sFiles);
bst_report('Open', ReportFile);

