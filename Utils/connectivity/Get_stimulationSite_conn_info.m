%% Get the connectivity metrics from the stim site only
load('source_phaseTE_4ROIs_PreTMSzscored.mat');
% gather the info we need
ROIs=Conn(1).ROInames;
stim='G_pariet_inf-Angular L';
idx=strcmp(ROIs,stim);
IDs=unique({Conn.ID});

%% go for it
Conn2=[];
for sb=1:numel(IDs)
    % subject substruct
    ids=strcmp({Conn.ID},IDs{sb}); % 3 windows 4 freq 2 conditions
    temp=Conn(ids);
    % matrix
    M={temp.Conn};
    % get the row 'from stim site to'
    Mstim=cellfun(@(x) x(idx,:),M,'UniformOutput',false);
    occ=cellfun(@(x) x(1),Mstim,'UniformOutput',false);
    frontal=cellfun(@(x) x(2),Mstim,'UniformOutput',false);
    motor=cellfun(@(x) x(3),Mstim,'UniformOutput',false);
    % put it back 
    [temp.TOocc]=occ{:};
    [temp.TOfrontal]=frontal{:};
    [temp.TOmotor]=motor{:};
    % remove what we dont need
    temp=rmfield(temp,'Conn'); 
    temp=rmfield(temp,'ROInames');
    % Joint to the main one
    if sb==1
        Conn2=temp;
    else
        Conn2=[Conn2,temp];
    end
end
%% pass it to a csv file and save it
T=struct2table(Conn2);
writetable(T,fullfile(SavingPath,'source4ROIs','source_phase_TE_4ROIs_fromStimArea.csv'));



