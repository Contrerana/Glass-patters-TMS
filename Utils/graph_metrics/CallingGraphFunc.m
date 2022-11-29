function GM=CallingGraphFunc(X,tholds)
%% Brain connectivity graph theory metrics
% Inputs:
%    X: struct with fields
%       ID: participant ID
%       Group: 'match','up','down','sham'
%       Group2:' match','mismatch','sham'
%       TMS: struct with connectivity metrics during TMS trials
%       postTMS: struct with connectivity metrics post TMS trials
%          tholds: array of thresholds to calculate metrics

% Output:
%   GM: struct with all the connectivity values per sub, condition,
%   group....
%   
%
%
% Lorena Santamaria Nov'22
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Npt=numel(X); % no of participants
GM=struct();
% Run a loop for each participant
for sb=1:Npt
    fprintf('Start processing participant %d is starting\n\n\n', sb);
    temp=X(sb);
    GMs=Call_BCT(temp,tholds);
    if sb==1
        GM=GMs;
    else
        GM=cat(2,GM,GMs);
    end
    fprintf('Pprocessing participant %d is done\n\n\n', sb);
end    



