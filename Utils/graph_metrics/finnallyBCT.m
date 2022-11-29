function GM=finnallyBCT(X,ID,Group,Group2,wind_freq,condition,tholds)
% Inputs:
%          X: connectivity matrix of channel by channels
%          ID: participant ID
%          Group: 'match','up','down','sham'
%          Group2:' match','mismatch','sham'
%          wind_freq: label with the win and freq info
%          condition: label with 'TMS' or 'postTMS' values  
%          tholds: array of thresholds to calculate metrics
% Ouputs:
%          GM: struct with the calculated graph metrics
%
%
% Lorena Santamaria Nov'22
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GM=struct();

%% do some checkings 
flag=issymmetric(X); %1: is 0 otherwise
%weights
if (max(X(:))<=1) & (min(X(:))==0)
   % no problem
elseif ~(max(X(:))<=1) & (min(X(:))==0)
   X=weight_conversion(X,'normalize'); %range [0,1] condition necessary for some metrics
elseif min(X(:))<0
   disp('something wrong');
   return
end
% get window info
win=extractBefore(wind_freq,'_');
fband=extractAfter(wind_freq,'_');

%% divide into directed or undirected metrics   
if flag
    % undirected network metrics
    for th=1:numel(tholds)
        fprintf('Processing participant: %s  window: %s   frequencyband: %s threshold %d \n', ID,win,fband,tholds(th));
        %thresholds
        x= threshold_proportional(X,tholds(th));
        % add all fix metadata
        GM(th).ID=ID;GM(th).group=Group;GM(th).group2=Group2;
        GM(th).condition=condition;GM(th).window=win;
        GM(th).fband=fband;GM(th).thold=tholds(th);
        % add graph metrics
        GM(th).degree=mean(degrees_und(x)); % control
        GM(th).density=density_und(x); % control
        
        GM(th).AvgStrength=mean(strengths_und(x));
        GM(th).MedianStrength=median(strengths_und(x));
        GM(th).MaxStrength=max(strengths_und(x));
        GM(th).MinStrength=min(strengths_und(x));
        
        GM(th).AvgCC=mean(clustering_coef_wu(x));
        GM(th).MedianCC=median(clustering_coef_wu(x));
        GM(th).MaxCC=max(clustering_coef_wu(x));
        GM(th).MinCC=min(clustering_coef_wu(x));
        GM(th).T=transitivity_wu(x);
        [~,Q]=community_louvain(x);
        GM(th).Q=Q;
        
        L=weight_conversion(x, 'lengths'); % connection legnth matrix
        D=distance_wei(L); %distance matrix
        [GM(th).CPL,GM(th).GE1,~,GM(th).rad,GM(th).dia]=charpath(D);
        GM(th).GE2=efficiency_wei(x);
        GM(th).AvgLE=mean(efficiency_wei(x,2));
        GM(th).MedianLE=median(efficiency_wei(x,2));
        GM(th).MaxLE=max(efficiency_wei(x,2));
        GM(th).MinLE=min(efficiency_wei(x,2));
    end    
else
    % directed network metrics
    for th=1:numel(tholds)
        fprintf('Processing participant: %s  window: %s   frequencyband: %s threshold %d \n', ID,win,fband,tholds(th)*100);
        %thresholds
        x= threshold_proportional(X,tholds(th));
        % add all fix metadata
        GM(th).ID=ID;GM(th).group=Group;GM(th).group2=Group2;
        GM(th).condition=condition;GM(th).window=win;
        GM(th).fband=fband;GM(th).thold=tholds(th);
        % add graph metrics
        [id,od,deg]=degrees_dir(x);
        GM(th).degree=mean(deg); % control
        GM(th).InDegree=id;
        GM(th).OutDegree=od;          
        GM(th).density=density_dir(x); % control
        
        [is,os,s]=strengths_dir(x);
        GM(th).AvgStrength=mean(s);
        GM(th).MedianStrength=median(s);
        GM(th).MaxStrength=max(s);
        GM(th).MinStrength=min(s);
        GM(th).InStregth=is;
        GM(th).OutStrength=os;
        
        GM(th).AvgCC=mean(clustering_coef_wd(x));
        GM(th).MedianCC=median(clustering_coef_wd(x));
        GM(th).MaxCC=max(clustering_coef_wd(x));
        GM(th).MinCC=min(clustering_coef_wd(x));
        GM(th).T=transitivity_wd(x);
        [~,Q]=community_louvain(x);
        GM(th).Q=Q;
        
        L=weight_conversion(x, 'lengths'); % connection legnth matrix
        D=distance_wei(L); %distance matrix
        [GM(th).CPL,GM(th).GE1,~,GM(th).rad,GM(th).dia]=charpath(D);
        GM(th).GE2=efficiency_wei(x);
        GM(th).AvgLE=mean(efficiency_wei(x,2));
        GM(th).MedianLE=median(efficiency_wei(x,2));
        GM(th).MaxLE=max(efficiency_wei(x,2));
        GM(th).MinLE=min(efficiency_wei(x,2));
    end
end
fprintf('Done processing participant %s  window %s   frequency band %s \n\n\n', ID,win,fband);