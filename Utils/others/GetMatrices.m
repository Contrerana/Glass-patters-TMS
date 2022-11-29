function Sout=GetMatrices(sFiles,ID,Group,Group2,Condition)
Sout=struct();
for ff=1:numel(sFiles)
    %% load the file
    a=load(sFiles{ff});
    %% get the data and metadata
    M=reshape(a.TF,4,[]);
    fband=a.Freqs{1};
    ROInames=a.RowNames;
    window=extractBetween(a.Comment,': ',fband);window=window{1};
    %% pass it to the output struct
    Sout(ff).ID=ID;
    Sout(ff).Group=Group;
    Sout(ff).Group2=Group2;
    Sout(ff).Condition=Condition;
    Sout(ff).window=window;
    Sout(ff).fband=fband;
    Sout(ff).ROInames=ROInames;
    Sout(ff).Conn=M;
end