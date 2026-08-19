%% InfoseekNeuralAnalysisLearning

% Analyzing neural datasets from learning during task training
% that information is provided and
% manipulations of delay between information and reward

%% HOUSEKEEPING

clear; close all;
rng('shuffle')
set(0,'DefaultFigureWindowStyle','docked'); % plot in docked window

% DATA FOLDER
datapath=uigetdir('','Choose data directory');

% plotfolder
if exist(fullfile(datapath,'plots'))
    plotfolder=fullfile(datapath,'plots');
else
    mkdir(fullfile(datapath,'plots'))
    plotfolder=fullfile(datapath,'plots');
end

% LOAD PARAMS
params=load(fullfile(datapath,'InfoseekNeuroAnalysisParams.mat'));

% LOAD DATASET INFO (SESSION TABLE)
load(fullfile(datapath,['BpodInfoseekSessions_',params.dataset{1},'.mat']));

% SAVING
output_dir = plotfolder;

%% SET OR SELECT SESSIONS TO LOAD

% DELAY MANIPULATIONS (10s vs 1s)
mice = {'JB424','JB425','JB426','JB432','JB433','JB434'};
days = {{'20220527','20220531','20220606','20220607'},... % long short
    {'20220518','20220519','20220607','20220609'},... % long short
    {'20220616','20220617','20220711','20220713'},... % long short
    {'20220623','20220627','20220706','20220707'},... % long short
    {'20220629','20220630','20220708','20220711'},...% SHORT LONG
    {'20220812','20220817','20220824','20220825'}}; % long short
conditions = {{{'20220606','20220607'},{'20220527','20220531'}},...
    {{'20220607','20220609'},{'20220518','20220519'}},...
    {{'20220711','20220713'},{'20220616','20220617'}},... % short long
    {{'20220706','20220707'},{'20220623','20220627'}},...
    {{'20220629','20220630'},{'20220708','20220711'}},...
    {{'20220824','20220825'},{'20220812','20220817'}}};
conditionNames = {'Short Delay','Long Delay'};

% DELAY MANIPULATIONS (1s vs 10s--10s sessions after 1s sessions)
% mice = {'JB424','JB425','JB426','JB432','JB433','JB434'};
% days = {{'20220606','20220607','20220616','20220617'},... % long short
%     {'20220607','20220609','20220616','20220617'},... % long short
%     {'20220711','20220713','20220728','20220729'},... % long short
%     {'20220706','20220707','20220727','20220728'},... % long short
%     {'20220629','20220630','20220708','20220711'},...% long short
%     {'20220824','20220825','20220906','20220907'}}; % long short
% conditions = {{{'20220606','20220607'},{'20220616','20220617'}},...
%     {{'20220607','20220609'},{'20220616','20220617'}},...
%     {{'20220711','20220713'},{'20220728','20220729'}},... % short long
%     {{'20220706','20220707'},{'20220727','20220728'}},...
%     {{'20220629','20220630'},{'20220708','20220711'}},...
%     {{'20220824','20220825'},{'20220906','20220907'}}};
% conditionNames = {'Short Delay1','Long Delay2'};


% DELAY MANIPULATIONS (10s vs 10s--early 10s sessions vs 10s sessions after testing at 1s)
% mice = {'JB424','JB425','JB426','JB432','JB433','JB434'};
% days = {{'20220527','20220531','20220616','20220617'},...
%     {'20220518','20220519','20220616','20220617'},...
%     {'20220616','20220617','20220728','20220729'},... % long long
%     {'20220623','20220627','20220727','20220728'},... % long long
%     {'20220621','20220711'},...% long long
%     {'20220812','20220817','20220906','20220907'}}; % long long
% conditions = {{{'20220527','20220531'},{'20220616','20220617'}},...
%     {{'20220518','20220519'},{'20220616','20220617'}},...
%     {{'20220616','20220617'},{'20220728','20220729'}},... % long long
%     {{'20220623','20220627'},{'20220727','20220728'}},...
%     {{'20220621'},{'20220711'}},...
%     {{'20220812','20220817'},{'20220906','20220907'}}};
% conditionNames = {'Long Delay1','Long DelayC2'};

% LEARNING--before vs. after the introduction of information
% mice = {'JB413','JB424','JB425','JB426','JB432','JB433','JB434'};
% days = {{'20211014','20211015','20211102','20211103'},...
%     {'20220105','20220106','20220121','20220124'},...
%     {'20220105','20220106','20220119','20220120'},...
%     {'20220126','20220127','20220131','20220201'},...
%     {'20220428','20220429','20220505','20220506'},...
%     {'20220428','20220429','20220505','20220506'},...
%     {'20220428','20220429','20220504','20220505'}};
% conditions = {{{'20211014','20211015'},{'20211102','20211103'}},...
%     {{'20220105','20220106'},{'20220121','20220124'}},...
%     {{'20220105','20220106'},{'20220119','20220120'}},...
%     {{'20220126','20220127'},{'20220131','20220201'}},...
%     {{'20220428','20220429'},{'20220505','20220506'}},...
%     {{'20220428','20220429'},{'20220505','20220506'}},...
%     {{'20220428','20220429'},{'20220504','20220505'}}};
% conditionNames={'Pre-learning','Late Learning'};

condct=numel(conditions{1});
alldays={};
for m=1:numel(mice)
    alldays=[alldays days{m}];
end
alldays=strjoin(alldays);

allconditions = strjoin(conditionNames);


%% LOAD INDIVIDUAL FILE DATA INTO Z

% Z(m) for each mouse has event arrays cells x time x trials
% concatenated by all trials each day
% create condition array to label trial by condition

files=dir('random');
for m=1:numel(mice)
   regfname=dir(fullfile(datapath,[mice{m} '_' num2str(numel(days{m})) 'days_' strjoin(days{m},'_') '_reg.mat']));
   load(fullfile(datapath,regfname.name),'MATCHED_ROIS');
   reg{m}=MATCHED_ROIS;
   for d=1:numel(days{m})
       dates=days{m};
       filename=[mice{m} '_' dates{d} '*neural.mat'];
       files=[files; dir(fullfile(datapath,filename))];
       f=numel(files);
       file=dir(fullfile(datapath,filename));
       disp(['loading file ',file.name]);
       b=load(fullfile(file.folder,file.name));
       ff=find(strcmp(b.day{1},days{m}));
       ROIS=reg{m}(:,ff);
       trialCt=numel(b.mouse);
       b.file(1:trialCt,1)=f; 
       vars=fields(b);
       if exist('z','var') == 0
           for i = 1:numel(vars)
               if strcmp(vars{i}(1:2),'C_')
                   % only registered cells for activity matrices
                   z(m).(vars{i}) = b.(vars{i})(ROIS,:,:);
               else
                   % for trial-size matrices
                   z(m).(vars{i})=b.(vars{i});
               end
           end
       else
           if numel(z)>=m
               for i = 1:numel(vars)
                   if strcmp(vars{i}(1:2),'C_')
                       z(m).(vars{i})=cat(3,z(m).(vars{i}),b.(vars{i})(ROIS,:,:));
                   else
                       z(m).(vars{i})=cat(1,z(m).(vars{i}),b.(vars{i}));            
                   end
               end
           else
               for i = 1:numel(vars)
                   if strcmp(vars{i}(1:2),'C_')
                       % only registered cells for activity matrices
                       z(m).(vars{i}) = b.(vars{i})(ROIS,:,:);
                   else
                       % for trial-size matrices
                       z(m).(vars{i})=b.(vars{i});
                   end
               end
           end
       end
       b=[];
       trialCt=[];
       vars=[];      
   end
   z(m).cd=NaN(size(z(m).day));
   for i=1:numel(conditions{m})
       z(m).cd(ismember(z(m).day,conditions{m}{i}))=i;
   end
end

numFiles=numel(files);
for m=1:numel(mice)
    maxTrials(m)=size(z(m).day,1);
end
maxTrials=max(maxTrials);


%% CREATE CONDITIONAL ACTIVITY PSTHs

% make conditional activity by condition (cell array)
% e.g. odor1FirstInfo{1}
% then concatenate by mouse

for m=1:numel(mice)
    a=z(m);
    a.nameEventsFirst = [9,6,7];
    
    for cd=1:numel(conditions{m})
%         c.baseline{cd}=a.baseline(:,:,a.cd==cd);
%         c.C_baseline=a.C_baseline;
        c.events{1,cd} = a.C_trialStart(:,:,a.cd==cd);
        c.events{2,cd} = a.C_centerEntry(:,:,a.cd==cd);
        c.events{3,cd} = a.C_odor1(:,:,a.cd==cd);
        c.events{4,cd} = a.C_centerExit(:,:,a.cd==cd);
        c.events{5,cd} = a.C_sideEntry(:,:,a.cd==cd);
        c.events{6,cd} = a.C_odor2(:,:,a.cd==cd);
        c.events{7,cd} = a.C_outcome(:,:,a.cd==cd);
        c.events{8,cd} = a.C_odor1All(:,:,a.cd==cd);
        c.events{9,cd} = a.C_odor1First(:,:,a.cd==cd);
        c.events{10,cd} = a.C_baseline(:,:,a.cd==cd);
        c.events{11,cd} = a.C_trial(:,:,a.cd==cd);
        c.events{12,cd} = a.C_sideExit(:,:,a.cd==cd);
        c.events{13,cd} = a.C_centerExitFirst(:,:,a.cd==cd);
        c.C_odor1First{cd}=a.C_odor1First(:,:,a.cd==cd);

        c.C_odor1FirstInfo{cd} = a.C_odor1First(:,:,a.cd==cd&a.imageTrialType==2 & a.imagingPrevCorrect == 1);
        c.C_odor1FirstRand{cd} = a.C_odor1First(:,:,a.cd==cd&a.imageTrialType==3 & a.imagingPrevCorrect == 1);
        c.C_odor1FirstInfoForced{cd} = a.C_odor1First(:,:,a.imagingChoice==1&a.cd==cd & a.imagingPrevCorrect == 1);
        c.C_odor1FirstInfoChoice{cd} = a.C_odor1First(:,:,a.imagingChoice==2&a.cd==cd & a.imagingPrevCorrect == 1);
        c.C_odor1FirstRandForced{cd} = a.C_odor1First(:,:,a.imagingChoice==3&a.cd==cd & a.imagingPrevCorrect == 1);
        c.C_odor1FirstRandChoice{cd} = a.C_odor1First(:,:,a.imagingChoice==4&a.cd==cd & a.imagingPrevCorrect == 1);
        c.C_odor2A{cd} = a.C_odor2(:,:,a.imagingOdor2 == 1&a.cd==cd & a.imagingPrevCorrect == 1 & a.imagingChoice==1);
        c.C_odor2B{cd} = a.C_odor2(:,:,a.imagingOdor2 == 2&a.cd==cd & a.imagingPrevCorrect == 1 & a.imagingChoice==1);
        c.C_odor2C{cd} = a.C_odor2(:,:,a.imagingOdor2 == 3&a.cd==cd & a.imagingPrevCorrect == 1 & a.imagingChoice==3);
        c.C_odor2D{cd} = a.C_odor2(:,:,a.imagingOdor2 == 4&a.cd==cd& a.imagingPrevCorrect == 1 & a.imagingChoice==3);
        c.C_odor2info{cd} = a.C_odor2(:,:,(a.imagingOdor2 == 1 | a.imagingOdor2 == 2) & a.imagingPrevCorrect == 1 & a.imagingChoice==1&a.cd==cd);
        c.C_odor2rand{cd} = a.C_odor2(:,:,(a.imagingOdor2 == 3 | a.imagingOdor2 == 4) & a.imagingPrevCorrect == 1 & a.imagingChoice==3&a.cd==cd);        
        c.C_outcomeInfoBig{cd} = a.C_outcome(:,:,(a.imagingOutcome == 11 | a.imagingOutcome == 2)& a.cd==cd);
        c.C_outcomeInfoSmall{cd} = a.C_outcome(:,:,(a.imagingOutcome == 13 | a.imagingOutcome == 4 | a.imagingOutcome == 5 | a.imagingOutcome == 14) & a.cd==cd);
        c.C_outcomeRandBig{cd} = a.C_outcome(:,:,(a.imagingOutcome == 17 | a.imagingOutcome == 6) & a.cd==cd);
        c.C_outcomeRandSmall{cd} = a.C_outcome(:,:,(a.imagingOutcome == 19 | a.imagingOutcome == 8) &a.cd==cd);
        c.C_outcomeBig{cd} = a.C_outcome(:,:,(a.imagingOutcome == 2 | a.imagingOutcome == 6 | a.imagingOutcome == 11| a.imagingOutcome == 17) & a.cd==cd);
        c.C_outcomeSmall{cd} = a.C_outcome(:,:,(a.imagingOutcome == 4 | a.imagingOutcome == 8 | a.imagingOutcome == 13 | a.imagingOutcome == 14 | a.imagingOutcome == 19 | a.imagingOutcome == 5) & a.cd==cd);

        c.C_trialInfoForcedBig{cd} = a.C_trial(:,:,a.imagingOutcome == 11 & a.cd==cd);
        c.C_trialInfoForcedSmall{cd} = a.C_trial(:,:,a.imagingOutcome == 13 | a.imagingOutcome == 14 & a.cd==cd);
        c.C_trialRandForcedBig{cd} = a.C_trial(:,:,a.imagingOutcome == 17 & a.cd==cd);
        c.C_trialRandForcedSmall{cd} = a.C_trial(:,:,a.imagingOutcome == 19 & a.cd==cd);
    
        
        % BASELINE
        c.baseline = cell(numel(params.events),2);
        for i = 1:numel(params.events)
        c.baseline{i,cd}=c.events{i,cd};
        end

        imagingChoiceCD=a.imagingChoice(a.cd==cd & a.imagingPrevCorrect == 1);
        imagingOutcomeCD=a.imagingOutcome(a.cd==cd);
        imagingePrevCorrCD=a.imagingPrevCorrect(a.cd==cd);
%         c.baselineTypes = cell(3,1); % size of namesfirst, 1 for each event with conditional activity
        c.baselineTypes{1,cd}(imagingePrevCorrCD==1,1:4) = 1; % all trials for center odors
        c.baselineTypes{2,cd}(imagingePrevCorrCD==1,4) = 0; % for side odors
        c.baselineTypes{2,cd}(imagingChoiceCD == 1 | imagingChoiceCD == 2,1) = 1; %info for info big
        c.baselineTypes{2,cd}(imagingChoiceCD == 1 | imagingChoiceCD == 2,2) = 1; %info for info small
        c.baselineTypes{2,cd}(imagingChoiceCD == 3 | imagingChoiceCD == 4,3) = 1; %rand for rand big
        c.baselineTypes{2,cd}(imagingChoiceCD == 3 | imagingChoiceCD == 4,4) = 1; %rand for rand small
        c.baselineTypes{3,cd}(1:sum(a.imagingTrials & a.cd==cd),4) = 0;
        c.baselineTypes{3,cd}(imagingOutcomeCD == 11 | imagingOutcomeCD == 2,1) = 1; %info big for info big
        c.baselineTypes{3,cd}(imagingOutcomeCD == 13 | imagingOutcomeCD == 4 | imagingOutcomeCD == 5 | imagingOutcomeCD == 14,2) = 1; % info small for info small
        c.baselineTypes{3,cd}(imagingChoiceCD == 3 | imagingChoiceCD == 4,3) = 1; %rand for rand big
        c.baselineTypes{3,cd}(imagingChoiceCD == 3 | imagingChoiceCD == 4,4) = 1; % rand for rand small

        for i = 1:3
           e = a.nameEventsFirst(i);
           for ci = 1:4
               c.baselineCond{i,cd} = c.baseline{e,cd}(:,:,c.baselineTypes{i,cd}(:,ci)==1);
           end
        end
    c.rxn{cd}=a.rxn(a.cd==cd);
    c.imageTrialType{cd}=a.imageTrialType(a.cd==cd);
    c.imagingOutcome{cd}=a.imagingOutcome(a.cd==cd);
    c.imagingChoice{cd}=a.imagingChoice(a.cd==cd);
    c.imagingPrevOutcome{cd}=a.imagingPrevOutcome(a.cd==cd);
    
    end
    
    vars=fields(c);
    for i=1:numel(vars)
        for cd=1:numel(conditions{m})
            if contains(vars{i},'C_')
                [numcells,numtime,numtrials]=size(c.(vars{i}){cd});
                b=NaN(numcells,numtime,maxTrials);
                b(1:numcells,1:numtime,1:numtrials)=c.(vars{i}){cd};
                if m==1
                   allmice.(vars{i}){cd} = b; 
                else
                   allmice.(vars{i}){cd}=cat(1,allmice.(vars{i}){cd},b);
                end
                clear b;
            elseif iscell(c.(vars{i})) & size(c.(vars{i}),1)>1
                for n=1:size(c.(vars{i}),1)
                    [numcells,numtime,numtrials]=size(c.(vars{i}){n,cd});
                    b=NaN(numcells,numtime,maxTrials);
                    b(1:numcells,1:numtime,1:numtrials)=c.(vars{i}){n,cd};
                    if m==1
                       allmice.(vars{i}){n,cd} = b; 
                    else
                       allmice.(vars{i}){n,cd}=cat(1,allmice.(vars{i}){n,cd},b);
                    end
                    clear b;                    
                end
            else
                if m==1
                    allmice.(vars{i}){cd}=c.(vars{i}){cd};
                else
                    allmice.(vars{i}){cd}=cat(1,allmice.(vars{i}){cd},c.(vars{i}){cd});
                end                
            end
        end
    end
    
    mouse(1:size(a.C_odor1First,1),1)=m;
    if m==1
        allmice.mouse = mouse;
    else
        allmice.mouse=cat(1,allmice.mouse,mouse);
    end
        
    clear a c mouse;
end

a=allmice;
clear allmice;


%% NAMES

a.neuronCt=size(a.C_odor1FirstInfo{1},1);

a.nameEventsFirst = [9,6,7];
a.namesFirst = {{'C_odor1FirstInfoForced','C_odor1FirstInfoChoice',...
    'C_odor1FirstRandForced','C_odor1FirstRandChoice'};...
    {'C_odor2A','C_odor2B','C_odor2C','C_odor2D'};... 
    {'C_outcomeInfoBig','C_outcomeInfoSmall','C_outcomeRandBig',...
    'C_outcomeRandSmall'}};
a.labels = {{'Center Odor Info Forced','Center Odor Info Choice','Center Odor No Info Forced','Center Odor No Info Choice'};...
    {'Side Odor A Info Water','Side Odor B Info No Water','Side Odor No Info C','Side Odor No Info D'};...
    {'Outcome Info Water','Outcome Info No Water','Outcome Rand Water','Outcome Rand No Water'}};

a.compNamesFirst = {{'C_odor1FirstInfoForced','C_odor1FirstRandForced'};...
    {'C_odor2A','C_odor2B'};{'C_odor2C','C_odor2D'};...
    {'C_odor2info','C_odor2rand'};...
    {'C_outcomeInfoBig','C_outcomeInfoSmall'};{'C_outcomeRandBig',...
    'C_outcomeRandSmall'}};
a.compEventsFirst = [9,6,6,6,7,7];
a.compLabels = { 'Info - No Info';...
    'Info Water A - Info No Water B';'No Info C - No Info D';...
    'Info AB - No Info CD';
    'Info Water - Info No Water';'No Info Water - No Info No Water'};
a.conditionLabels = {{'Info Forced','No Info Forced'};...
    {'A Info Water','B Info No Water'};{'No Info C','No Info D'};...
    {'AB','CD'};...
    {'Info Water','Info No Water'};{'No Info Water','No Info No Water'}};

%% SET ANALYSIS WINDOWS

framesAroundEvent = params.intervals./1000*params.Fs;
for e = 1:numel(params.events)
    a.t{e}=((1:2*framesAroundEvent(e))-framesAroundEvent(e))*(1/params.Fs);
    a.okt{e} = params.resp_win(1) <= a.t{e} & a.t{e} <= params.resp_win(2);
    a.tpre{e} = params.pre_win(1) <= a.t{e} & a.t{e} <= params.pre_win(2);
end

iStart = 40;
iStop = 56;
PID=0.075;

%% SIGNIFICANCE

a.pcrit = 0.05;
a.maxcrit = 0.2;
a.diffcrit=0.1;

%% PLOTTING COLORS

a.grey = [.8 .8 .8];
a.purple = [121 32 196] ./ 255;
a.lightPurple = [204 204 255] ./ 255;
a.orange = [251 139 6] ./ 255;
a.lightOrange = [255 204 153] ./ 255;
a.cornflower = [100 149 237] ./ 255;
a.teal = [0 128 128] ./ 255;
a.darkcyan = [0 139 139] ./ 255;
a.blues = [222,235,247;158,202,225;49,130,189]./ 255;
a.reds = [254,224,210;252,146,114;222,45,38]./ 255;
a.purples = [239,237,245;188,189,220;117,107,177]./ 255;
a.oranges = [254,230,206;253,174,107;230,85,13]./ 255;

a.magma=magma();
a.inferno=inferno();
a.plasma=plasma();
a.viridis=viridis();

a.rwb = make_colormap('b','w','r');
a.rbb = make_colormap('b','k','r');
a.rwt = make_colormap(a.darkcyan,'w','r');
a.rbt = make_colormap(a.darkcyan,'k','r');
a.rbc = make_colormap('c','k','r');
a.ckr= make_colormap([0 0.5 0.6],'k',[0.85 0 0]);

RA=0;

%% SIGNIFICANT CONDITIONAL RESPONSE IN EACH LEARNING CONDITION

for cm=1:condct
    for cd = 1:numel(a.namesFirst)
       cname = a.namesFirst{cd};
       e = a.nameEventsFirst(cd);
       cy = cellfun(@(z) a.(z),cname,'uniform',0);
        t=a.t{e};
        okt=a.okt{e};
       for ci = 1:numel(cname)
           y=cy{ci}{cm};
           if ~isempty(y)
               % mean across time (vals for each trial for each cell)
               ybaseline = squeeze(mean(a.baselineCond{cd,cm}(:,a.tpre{e},:),2,'omitnan'));
               [maxval,maxidx]=max(y(:,16:39,:),[],2,'omitnan');
               maxval=squeeze(maxval);maxidx=squeeze(maxidx);
               basetimes=t(okt);
    %            decay = @(b)
                ybaselineExp=[];
                for i=1:numel(basetimes)
                    ybaselineExp(:,i,:)=maxval.*0.5.^((basetimes(i)-t(maxidx+16))/0.4);
                end
                ybaselineExp=squeeze(mean(ybaselineExp,2)); 
                               
                ypost = squeeze(mean(y(:,a.okt{e},:),2,'omitnan'));
                a.postAct{cd,cm}{ci} = mean(ypost,2,'omitnan');
                a.baseAct{cd,cm}{ci} = mean(ybaseline,2,'omitnan');
                a.baseActExp{cd,cm}{ci}=mean(ybaselineExp,2,'omitnan');           

                badidx=a.baseAct{cd,cm}{ci}-a.baseActExp{cd,cm}{ci}>a.maxcrit;
                ybase=ybaselineExp;
                ybase(badidx,:)=ybaseline(badidx,:);           
           
               pvals=NaN(a.neuronCt,1);
               for u = 1:a.neuronCt
                   if sum(~isnan(ypost(u,:)))>0
                   pvals(u,1) = ranksum(ybaseline(u,:),ypost(u,:));
                   pvalsPS(u,1) =ranksum(ybase(u,:),ypost(u,:));
                   pvalsExp(u,1) = ranksum(ybaselineExp(u,:),ypost(u,:));
                   end
               end
               a.C_condBasePostP{cd,cm}(:,ci)=pvals;
               a.C_condBasePostPS{cd,cm}(:,ci)=pvalsPS;
               a.C_condBasePostPExp{cd,cm}(:,ci)=pvalsExp;
               ymean=mean(y,3,'omitnan');
               maxresp = max(ymean(:,a.okt{e}),[],2);
               a.C_condBasePostRSActive{cd,cm}(:,ci) = a.C_condBasePostP{cd,cm}(:,ci)<a.pcrit&a.postAct{cd,cm}{ci}-a.baseAct{cd,cm}{ci}>0.1;
               a.C_condBasePostRSActiveExp{cd,cm}(:,ci) = a.C_condBasePostPS{cd,cm}(:,ci)<a.pcrit&a.postAct{cd,cm}{ci}-a.baseAct{cd,cm}{ci}>0.1;          

%          
           end
       end
    end
end

for cm=1:condct
activeCells=[];
for cd = 1:numel(a.namesFirst)
    cnames = a.namesFirst{cd};
    activeCellscd = a.C_condBasePostRSActiveExp{cd,cm};        
    activeCells = [activeCells activeCellscd];
end
a.cellTypes{cm}=activeCells;
end


%% SHUFFLE ACTIVITY BETWEEN INFO-NO INFO (CONDITIONS) TO FIND SIGNIFICANT DIFF WITHIN EACH CONDITION WITHIN LEARNING TIMES

mouseCells=histc(a.mouse(:),unique(a.mouse));
mouseCellCts=[0; cumsum(mouseCells)];

clear yy;
for cd = 1:size(a.compNamesFirst)
    cname = a.compNamesFirst{cd};
    e = a.compEventsFirst(cd);
    
    cy = cellfun(@(z) a.(z),cname,'uniform',0);
    
    for ci=1:condct
        y1 = cy{1}{ci}; % info activity for each time
        y2 = cy{2}{ci}; % random activity for each time
        n1=sum(~isnan(y1(cumsum(mouseCells),1,:)),3); % number of non-NaN trials per mouse
        n2=sum(~isnan(y2(cumsum(mouseCells),1,:)),3);
        clear ii;
        for m=1:numel(mice)
            yy1{m}=y1(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:n1(m)); % that mouse's activity (noNaN) for condition 1
            yy2{m}=y2(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:n2(m));
            yy{m}=cat(3,yy1{m},yy2{m}); % stack condition 1 and condition 2 for that mouse
            ii{m}(1:n1(m),1)=1; % label for condition 1 trials for that mouse
            ii{m}(n1(m)+1:n1(m)+n2(m),1)=2; % label for condition 2 trials for that mouse       
        end

        for j=1:1000
            for m=1:numel(mice) 
                shuffle = ii{m}(randperm(size(ii{m},1))'); % shuffle whether trials are condition 1 or condition 2
                y1shuffle=yy{m}(:,:,shuffle==1); % take a random subset to be condition 1 of condition 1 size
                s1=NaN(size(y1shuffle,1),size(y1shuffle,2),max(n1)); % fill with NaN for matched size
                s1(:,:,1:size(y1shuffle,3))=y1shuffle;
                y2shuffle=yy{m}(:,:,shuffle==2);
                s2=NaN(size(y2shuffle,1),size(y2shuffle,2),max(n2));
                s2(:,:,1:size(y2shuffle,3))=y2shuffle;
                if m==1 % concatenate mice back together
                   y1=s1;
                   y2=s2;
                else
                    y1=cat(1,y1,s1);
                    y2=cat(1,y2,s2);
                end
            end

            y11=y1(:,:,1:2:end); %condition 1 (info) odd trials
            y12=y1(:,:,2:2:end); % condition 1 even trials

            y21=y2(:,:,1:2:end); % condition 2 (rand)
            y22=y2(:,:,2:2:end);    

            y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1 odd trials
            y1mean2 = mean(y12,3,'omitnan'); % mean across trials in cond 1 even trials
            y2mean1 = mean(y21,3,'omitnan');
            y2mean2 = mean(y22,3,'omitnan');
            y1meanPost1 = mean(y1mean1(:,a.okt{e}),2,'omitnan'); % mean post-act in condition 1 odd trials
            y1meanPost2 = mean(y1mean2(:,a.okt{e}),2,'omitnan'); % mean post-act in condition 1 even trials
            y2meanPost1 = mean(y2mean1(:,a.okt{e}),2,'omitnan');
            y2meanPost2 = mean(y2mean2(:,a.okt{e}),2,'omitnan');
            y1meanPre1 = mean(y1mean1(:,a.tpre{e}),2,'omitnan'); % mean post-act in condition 1 odd trials
            y1meanPre2 = mean(y1mean2(:,a.tpre{e}),2,'omitnan'); % mean post-act in condition 1 even trials
            y2meanPre1 = mean(y2mean1(:,a.tpre{e}),2,'omitnan');
            y2meanPre2 = mean(y2mean2(:,a.tpre{e}),2,'omitnan');        

            activityDifference1 = y1mean1-y2mean1; % condition 1 odd trials - condition 2 odd trials (then multiply by sign of even trials)
            activityDifference2 = y1mean2-y2mean2;
            a.activityDifferenceEBMShuffle{cd,ci}(:,:,j) = ((sign(activityDifference1).*activityDifference2)+(sign(activityDifference2).*activityDifference1))/2;

            actDiffPost1 = y1meanPost1-y2meanPost1; % difference in post 1sec between condition 1 odds and condition 2 odds
            actDiffPost2 = y1meanPost2-y2meanPost2;
            a.actDiffPostEBMShuffle{cd,ci}(:,j) = ((sign(actDiffPost1).*actDiffPost2)+(sign(actDiffPost2).*actDiffPost1))/2;

            actDiffPre1 = y1meanPre1-y2meanPre1; % difference in post 1sec between condition 1 odds and condition 2 odds
            actDiffPre2 = y1meanPre2-y2meanPre2;
            a.actDiffPreEBMShuffle{cd,ci}(:,j) = ((sign(actDiffPre1).*actDiffPre2)+(sign(actDiffPre2).*actDiffPre1))/2;               
        end
    end
end

%% CODING INDEX

disp('Calculating EBM index for each event');

for cd = 1:size(a.compNamesFirst)
    cname = a.compNamesFirst{cd};
    e = a.compEventsFirst(cd);
    
    cy = cellfun(@(z) a.(z),cname,'uniform',0);
    for ci=1:condct
    
    y1 = cy{1}{ci};
    y2 = cy{2}{ci};
    
    y11=y1(:,:,1:2:end);
    y12=y1(:,:,2:2:end);
    
    y21=y2(:,:,1:2:end);
    y22=y2(:,:,2:2:end);    
    
    y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
    y1mean2 = mean(y12,3,'omitnan');
    y2mean1 = mean(y21,3,'omitnan');
    y2mean2 = mean(y22,3,'omitnan');
    
    y1meanPost1 = mean(y1mean1(:,a.okt{e}),2,'omitnan');
    y1meanPre1 = mean(y1mean1(:,a.tpre{e}),2,'omitnan');
    y1meanPost2 = mean(y1mean2(:,a.okt{e}),2,'omitnan');
    y1meanPre2 = mean(y1mean2(:,a.tpre{e}),2,'omitnan');
    y2meanPost1 = mean(y2mean1(:,a.okt{e}),2,'omitnan');
    y2meanPre1 = mean(y2mean1(:,a.tpre{e}),2,'omitnan');
    y2meanPost2 = mean(y2mean2(:,a.okt{e}),2,'omitnan');
    y2meanPre2 = mean(y2mean2(:,a.tpre{e}),2,'omitnan');
    
    activityDifference1 = y1mean1-y2mean1; % difference on odd trials
    activityDifference2 = y1mean2-y2mean2;
    a.activityDifferenceEBM{cd,ci} = (sign(activityDifference1).*activityDifference2+sign(activityDifference2).*activityDifference1).*0.5;
    a.popActDiffEBM{cd,ci}=mean(a.activityDifferenceEBM{cd,ci});
    
    actDiffPost1 = y1meanPost1-y2meanPost1; % difference in post 1sec between condition 1 odds and condition 2 odds
    actDiffPost2 = y1meanPost2-y2meanPost2;
    a.actDiffPostEBM{cd,ci} = (sign(actDiffPost1).*actDiffPost2+sign(actDiffPost2).*actDiffPost1)/2;
    
    actDiffPre1 = y1meanPre1-y2meanPre1; % difference in post 1sec between condition 1 odds and condition 2 odds
    actDiffPre2 = y1meanPre2-y2meanPre2;
    a.actDiffPreEBM{cd,ci} = (sign(actDiffPre1).*actDiffPre2+sign(actDiffPre2).*actDiffPre1)/2;    
    
    for t=1:size(activityDifference1,2)
        a.activityDifferenceEBMSig{cd,ci}(:,t) = signrank(a.activityDifferenceEBM{cd,ci}(:,t));
    end
    
    a.actDiffIdxEBMPostSig{cd,ci} = signrank(mean(a.activityDifferenceEBM{cd,ci}(:,a.okt{e}),2));
    a.actDiffIdxEBMPreSig{cd,ci} = signrank(mean(a.activityDifferenceEBM{cd,ci}(:,a.tpre{e}),2));
    end
       
end

%% SIGNFICANT DIFFERENCES

for cd = 1:size(a.compNamesFirst)
    % cd =1 info, rand
    for ci=1:condct
    
        trueDiff = a.actDiffPostEBM{cd,ci}-a.actDiffPreEBM{cd,ci};
        trueDiffPop = mean(a.actDiffPostEBM{cd,ci}) - mean(a.actDiffPreEBM{cd,ci});

        shuffleDiff = a.actDiffPostEBMShuffle{cd,ci}-a.actDiffPreEBMShuffle{cd,ci};
        shuffleDiffPop = mean(a.actDiffPostEBMShuffle{cd,ci})-mean(a.actDiffPreEBMShuffle{cd,ci});

        a.actDiffPopIdxEBMSig{cd,ci}=sum(shuffleDiffPop>trueDiffPop)/1000;
        a.actDiffIdxEBMSig{cd,ci}=sum(shuffleDiff>trueDiff,2)/1000;
    end

    trueCondDiffPop = mean(a.actDiffPostEBM{cd,2})-mean(a.actDiffPostEBM{cd,1});
    shuffleCondDiffPop = mean(a.actDiffPostEBMShuffle{cd,2}) - mean(a.actDiffPostEBMShuffle{cd,1});
    
    a.actDiffPopCondEBMSig{cd}=sum(shuffleCondDiffPop>trueCondDiffPop)/1000;
    
end

%% ** MEAN CODING INDEX IN EACH CONDITION IN EACH LEARNING TIME

for cd=1:size(a.compNamesFirst)

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
set(fig,'renderer','painters');
hold on;

e=a.compEventsFirst(cd);
t=a.t{e};
y1=a.activityDifferenceEBM{cd,1};
y2=a.activityDifferenceEBM{cd,2};
label1=[conditionNames{1}, 'p= ', num2str(a.actDiffPopIdxEBMSig{cd,1})];
label2=[conditionNames{2}, 'p= ' ,num2str(a.actDiffPopIdxEBMSig{cd,2})];

p1 = a.actDiffPopIdxEBMSig{cd,1};
p2 = a.actDiffPopIdxEBMSig{cd,2};
if p1 == 0; pstr1 = 'p<2e-308'; else; pstr1 = sprintf('p=%.3e', p1); end
if p2 == 0; pstr2 = 'p<2e-308'; else; pstr2 = sprintf('p=%.3e', p2); end
label1 = [conditionNames{1}, ' ', pstr1];
label2 = [conditionNames{2}, ' ', pstr2];

nsubplot(1,1,1,1);
h_for_legend=[];
h_for_legend(end+1)=plot(t,mean(y1,'omitnan'),'Color','r','linewidth',4);
h = fill([t, fliplr(t)], [mean(y1,'omitnan')-sem(y1), fliplr(mean(y1,'omitnan')+sem(y1))], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(t,mean(y2,'omitnan'),'Color','b','linewidth',4);
h = fill([t, fliplr(t)], [mean(y2,'omitnan')-sem(y2), fliplr(mean(y2,'omitnan')+sem(y2))], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
plot([0+PID 0+PID],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
plot([1.2 1.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);

legend(h_for_legend,{label1 label2},'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel(a.compLabels{cd})
title(a.compLabels{cd})

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_EBMdiff_',a.compLabels{cd},[conditionNames{:}]]),'pdf');
end

%% **MEAN CODING INDEX DIFFERENCE BETWEEN LEARNING TIME PERIODS

for cd=1:size(a.compNamesFirst)
figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
set(fig,'renderer','painters');
hold on;

e=a.compEventsFirst(cd);
t=a.t{e};
y1=a.activityDifferenceEBM{cd,1};
y2=a.activityDifferenceEBM{cd,2};
% meanSh1=mean(squeeze(mean(a.activityDifferenceEBMShuffle{cd,1},1)),2);
% semSh1=sem(squeeze(mean(a.activityDifferenceEBMShuffle{cd,1},1)),2);
% meanSh2=mean(squeeze(mean(a.activityDifferenceEBMShuffle{cd,2},1)),2);
% semSh2=sem(squeeze(mean(a.activityDifferenceEBMShuffle{cd,2},1)),2);

p = a.actDiffPopCondEBMSig{cd};
if p == 0
    pstr = 'p<2e-308';
else
    pstr = sprintf('p=%.3e', p);
end
% title([a.compLabels{cd} ' ' pstr])

nsubplot(1,1,1,1);
plot(t,squeeze(mean(a.activityDifferenceEBMShuffle{cd,2},'omitnan'))-squeeze(mean(a.activityDifferenceEBMShuffle{cd,1},'omitnan')),'Color',a.grey,'linewidth',0.5);
plot(t,mean(y2,'omitnan')-mean(y1,'omitnan'),'Color',a.purple,'linewidth',4);
xlabel('Time')
ylabel(conditionNames)
title([a.compLabels{cd} ' ' pstr])
% title([a.compLabels{cd} ' p=' num2str(a.actDiffPopCondEBMSig{cd})])
plot([0+PID 0+PID],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
plot([1.2 1.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_EBMdiffShuffle_',a.compLabels{cd},'_absDiffShuffleEBM_',[conditionNames{:}]]),'pdf');
end

%% **INFO AND NO INFO MEAN ACTIVITY RESPONDING CELLS ONLY

infoRespCells1=a.C_condBasePostRSActiveExp{1,1}(:,1);
noInfoRespCells1=a.C_condBasePostRSActiveExp{1,1}(:,3);
infoRespCells2=a.C_condBasePostRSActiveExp{1,2}(:,1);
noInfoRespCells2=a.C_condBasePostRSActiveExp{1,2}(:,3);

yInfo1=mean(a.C_odor1FirstInfoForced{1},3,'omitnan');
yRand1=mean(a.C_odor1FirstRandForced{1},3,'omitnan');
yInfo2=mean(a.C_odor1FirstInfoForced{2},3,'omitnan');
yRand2=mean(a.C_odor1FirstRandForced{2},3,'omitnan');

yInfo1=yInfo1-mean(yInfo1(:,30:40),2);
yInfo2=yInfo2-mean(yInfo2(:,30:40),2);
yRand1=yRand1-mean(yRand1(:,30:40),2);
yRand2=yRand2-mean(yRand2(:,30:40),2);

yInfo1=yInfo1(infoRespCells1,:);
yInfo2=yInfo2(infoRespCells2,:);
yRand1=yRand1(noInfoRespCells1,:);
yRand2=yRand2(noInfoRespCells2,:);

yInfo1mean=mean(yInfo1);
yInfo2mean=mean(yInfo2);
yRand1mean=mean(yRand1);
yRand2mean=mean(yRand2);

yInfo1sem=std(yInfo1,[],1) ./ sqrt(size(yInfo1,1));
yInfo2sem=std(yInfo2,[],1) ./ sqrt(size(yInfo2,1));
yRand1sem=std(yRand1,[],1) ./ sqrt(size(yRand1,1));
yRand2sem=std(yRand2,[],1) ./ sqrt(size(yRand2,1));

e = a.nameEventsFirst(1);
ypostI1 = squeeze(mean(a.C_odor1FirstInfoForced{1}(infoRespCells1,a.okt{e},:),2,'omitnan')); % one value for each trial for each responding cell (mean over 1s post)
ypostI2 = squeeze(mean(a.C_odor1FirstInfoForced{2}(infoRespCells2,a.okt{e},:),2,'omitnan')); % one value for each trial for each responding cell (mean over 1s post)
ypostImean1=mean(ypostI1,'omitnan')';
ypostImean2=mean(ypostI2,'omitnan')';
ptrials(1,1)=ranksum(ypostI1(:),ypostI2(:)); % one value for each trial for each responding cell (mean over 1s post)
pcells(1,1)=ranksum(ypostImean1(:),ypostImean2(:));
ypostN1 = squeeze(mean(a.C_odor1FirstRandForced{1}(noInfoRespCells1,a.okt{e},:),2,'omitnan'));
ypostN2 = squeeze(mean(a.C_odor1FirstRandForced{2}(noInfoRespCells2,a.okt{e},:),2,'omitnan'));
ypostNmean1=mean(ypostN1,'omitnan')';
ypostNmean2=mean(ypostN2,'omitnan')';
ptrials(1,2)=ranksum(ypostN1(:),ypostN2(:));
pcells(1,2)=ranksum(ypostNmean1(:),ypostNmean2(:));

t=a.t{9};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;

nsubplot(1,2,1,1);
h_for_legend=[];
h_for_legend(end+1)=plot(t,yInfo1mean,'Color','r','linewidth',4);
h = fill([t, fliplr(t)], [yInfo1mean-yInfo1sem, fliplr(yInfo1mean+yInfo1sem)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(t,yInfo2mean,'Color','b','linewidth',4);
h = fill([t, fliplr(t)], [yInfo2mean-yInfo2sem, fliplr(yInfo2mean+yInfo2sem)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
xlim([-0.5 1.2]);
xticks([-2:0.2:2]);
axis square;

legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of Info')
% title('Info, responding cells only, p trials= p cells=')
pstr1 = sprintf('%.4e', ptrials(1));
pstr2 = sprintf('%.4e', pcells(1));
title(sprintf('Info, responding cells only, p trials=%s p cells=%s', pstr1, pstr2))

nsubplot(1,2,1,2);
h_for_legend=[];
h_for_legend(end+1)=plot(t,yRand1mean,'Color','r','linewidth',4);
h = fill([t, fliplr(t)], [yRand1mean-yRand1sem, fliplr(yRand1mean+yRand1sem)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(t,yRand2mean,'Color','b','linewidth',4);
h = fill([t, fliplr(t)], [yRand2mean-yRand2sem, fliplr(yRand2mean+yRand2sem)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
xlim([-0.5 1.2]);
xticks([-2:0.2:2]);
axis square;

legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of No Info')
% title('No Info, responding cells only')
pstr1 = sprintf('%.4e', ptrials(2));
pstr2 = sprintf('%.4e', pcells(2));
title(sprintf('No Info, responding cells only, p trials=%s p cells=%s', pstr1, pstr2))

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_meanActivityRespondingcells_',[conditionNames{:}]]),'pdf');

%% **DIFFERENTIATING CELLS VENNS

for cd=1:1:size(a.compNamesFirst)
%     diffCells=[a.C_condShuffleDifferent{cd,1} a.C_condShuffleDifferent{cd,2}];
    diffCells=[a.actDiffIdxEBMSig{cd,1}<0.05 a.actDiffIdxEBMSig{cd,2}<0.05];
    cond1Cells = diffCells(:,1);
    cond2Cells = diffCells(:,2);

    setLabels = {conditionNames{1}; conditionNames{2}};

    vennPlot{1}=find(cond1Cells);
    vennPlot{2}=find(cond2Cells);
    
    [tbl,chi2,p] = crosstab(cond1Cells,cond2Cells);

    figure();
    fig = gcf;
    fig.PaperUnits = 'inches';
    set(fig,'PaperOrientation','landscape');
    fig.PaperSize = [11 8.5];
    fig.PaperPosition = [0 0 10 8];

    h=vennEulerDiagram(vennPlot, setLabels, 'drawProportional', true,'showintersectioncounts',true);

    % axis square;
    title([a.compLabels{cd} ' EBM diff cells p=' num2str(p)])
    saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_',allconditions,'_',a.compLabels{cd},'_EBMVenn']),'pdf');
end

%% **CONDITIONAL MEAN ACTIVITY BEFORE AND AFTER

for cd = 1:size(a.compNamesFirst)
    cname = a.compNamesFirst{cd};
    e = a.compEventsFirst(cd);
    cy = cellfun(@(z) a.(z),cname,'uniform',0); 
    
    ya1 = cy{1}{1}; % info in that learning condition
    ya2 = cy{1}{2}; % info in that learning condition
    yb1 = cy{2}{1}; %rand in that learning condition
    yb2 = cy{2}{2}; %rand in that learning condition
    ya1TrialMean=mean(ya1,3,'omitnan'); %yInfo1
    ya2TrialMean=mean(ya2,3,'omitnan');
    yb1TrialMean=mean(yb1,3,'omitnan'); %yRand1   
    yb2TrialMean=mean(yb2,3,'omitnan');      
    ya1Trialmean=ya1TrialMean-mean(ya1TrialMean(:,30:40),2);
    ya2Trialmean=ya2TrialMean-mean(ya2TrialMean(:,30:40),2);
    yb1Trialmean=yb1TrialMean-mean(yb1TrialMean(:,30:40),2);
    yb2Trialmean=yb2TrialMean-mean(yb2TrialMean(:,30:40),2);
    ya1mean=mean(ya1Trialmean);
    ya2mean=mean(ya2Trialmean);
    yb1mean=mean(yb1Trialmean);
    yb2mean=mean(yb2Trialmean);
%     ya1mean=mean(ya1TrialMean-mean(ya1TrialMean(:,30:40),2),1); %yInfo1mean
%     ya2mean=mean(ya2TrialMean-mean(ya2TrialMean(:,30:40),2),1);
%     yb1mean=mean(yb1TrialMean-mean(yb1TrsialMean(:,30:40),2),1);
%     yb2mean=mean(yb2TrialMean-mean(yb2TrialMean(:,30:40),2),1);
    ya1sem=std(ya1Trialmean,[],1,'omitnan')./sqrt(size(ya1Trialmean,1));
    ya2sem=std(ya2Trialmean,[],1,'omitnan')./sqrt(size(ya2Trialmean,1));
    yb1sem=std(yb1Trialmean,[],1,'omitnan')./sqrt(size(yb1Trialmean,1));
    yb2sem=std(yb2Trialmean,[],1,'omitnan')./sqrt(size(yb2Trialmean,1));
    t=a.t{e};

    figure()
    fig=gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 11 8.5];
    set(fig,'PaperOrientation','landscape');
    hold on;

    nsubplot(1,2,1,1);
    h_for_legend=[];
    h_for_legend(end+1)=plot(t,ya1mean,'Color','r','linewidth',4);
    h = fill([t, fliplr(t)], [ya1mean-ya1sem, fliplr(ya1mean+ya1sem)], 'r','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    h_for_legend(end+1)=plot(t,ya2mean,'Color','b','linewidth',4);
    h = fill([t, fliplr(t)], [ya2mean-ya2sem, fliplr(ya2mean+ya2sem)], 'b','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    xlim([-0.5 1.2]);
    xticks([-2:0.2:2]);
%     ylim([-0.02 0.1])
    axis square;

    legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
    xlabel('Time')
    ylabel(['Mean of ' a.conditionLabels{cd}{1}])
    title([a.conditionLabels{cd}{1} ', all cells'])

    nsubplot(1,2,1,2);
    h_for_legend=[];
    h_for_legend(end+1)=plot(t,yb1mean,'Color','r','linewidth',4);
    h = fill([t, fliplr(t)], [yb1mean-yb1sem, fliplr(yb1mean+yb1sem)], 'r','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    h_for_legend(end+1)=plot(t,yb2mean,'Color','b','linewidth',4);
    h = fill([t, fliplr(t)], [yb2mean-yb2sem, fliplr(yb2mean+yb2sem)], 'b','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    xlim([-0.5 1.2]);
    xticks([-2:0.2:2]);
%     ylim([-0.02 0.1])
    axis square;

    legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
    xlabel('Time')
    ylabel(['Mean of ' a.conditionLabels{cd}{2}])
    title([a.conditionLabels{cd}{2}  ', all cells'])

    saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_meanActivitybyCondition_',allconditions,'_',a.compLabels{cd}]),'pdf');
end

%%

y_info=[];
y_rand=[];

for cd=1:numel(conditions{1})
   y_info{cd}=mean(a.C_odor1FirstInfoForced{cd},3,'omitnan');
   y_rand{cd}=mean(a.C_odor1FirstRandForced{cd},3,'omitnan');
   ydiff{cd}=y_info{cd}-y_rand{cd};
    [infoSort(:,cd),infoIdx(:,cd)] = sort(mean(y_info{cd}(:,40:64),2,'omitnan'),'descend');
    [randSort(:,cd),randIdx(:,cd)] = sort(mean(y_rand{cd}(:,40:64),2,'omitnan'),'descend');
    [diffSort(:,cd),diffIdx(:,cd)] = sort(mean(ydiff{cd}(:,40:64),2,'omitnan'),'descend');
end

e=3;
t=a.t{e};
color_limits=[-1.4,1.4];
color_limits=[-1.6 1.6];
diff_limits = [-0.8 0.8];

%% **TimeConditionDifferencesEBM

    EBM_limits=[-1.4 1.4];

    figure()
    fig=gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 11 8.5];
    set(fig,'PaperOrientation','landscape');


    yEBM{1}=a.activityDifferenceEBM{1,1};
    yEBM{2}=a.activityDifferenceEBM{1,2};
    yEBMDiff1=yEBM{2}-yEBM{1};

    [~,cell_sort_ids]=sort(mean(yEBM{2}(:,40:64),2),'descend');
    
    for ci=1:condct
    ax=nsubplot(1,condct+2,1,ci);
    imagesc(t,1:size(yEBM{ci},1),yEBM{ci}(cell_sort_ids,:),EBM_limits);
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
%         ax.YAxis.Visible = 'off';
    xlim([-0.2 1.45]);
    xlabel('Seconds');
    title(['Info-No Info ' conditionNames{ci}]);
    set(ax, 'Ydir', 'reverse')
    colorbar()
    end
    
    ax=nsubplot(1,condct+2,1,condct+1);
    imagesc(t,1:size(yEBMDiff1,1),yEBMDiff1(cell_sort_ids,:),[-1 1]);
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
    ax.YAxis.Visible = 'off';
    xlim([-0.2 1]);
    xlabel('Seconds');
    title('Diff 2 - Diff 1');
    set(ax, 'Ydir', 'reverse')
    colorbar()
    
   
    if RA==1
    colormap(a.ckr);
    else
    colorcet('D1')
    end

    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 0.96, [strjoin(mice,' _ '),' Sort By Diff in Condition ',conditionNames{2}],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');

    saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_TimeConditionDifferencesEBM_SortDiff_',conditionNames{2}]),'pdf');
    


%% **TimeConditionDifferences

for cd=1:numel(conditions{1})

    cell_sort_ids=infoIdx(:,cd);
    % cell_sort_ids=randIdx;

    figure()
    fig=gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 11 8.5];
    set(fig,'PaperOrientation','landscape');

    for ci=1:condct
    ax=nsubplot(1,condct*2+2*condct-1,1,ci);
    y=y_info{ci};
    y=y-mean(y(:,30:40),2);
    imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
    ax.YAxis.Visible = 'off';
    xlim([-0.2 1.45]);
    xlabel('Seconds');
    title({'Info  '; conditionNames{ci}}); %{'First line';'Second line'}
    set(ax, 'Ydir', 'reverse')
    colorbar();
    end

    y_info1=y_info{1};
    y_info2=y_info{2};
    ax=nsubplot(1,condct*2+2*condct-1,1,condct+1);
    y=y_info2-y_info1;
    imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
    ax.YAxis.Visible = 'off';
    xlim([-0.2 1.45]);
    xlabel('Seconds');
    title({'Info,'; 'Condition 2-1'});
    set(ax, 'Ydir', 'reverse')
    colorbar()

    if condct==3
    y_info1=y_info{1};
    y_info2=y_info{3};
    ax=nsubplot(1,condct*2+2*condct-1,1,condct+2);
    y=y_info2-y_info1;
    imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
    ax.YAxis.Visible = 'off';
    xlim([-0.2 1.45]);
    xlabel('Seconds');
    title({'Info,'; 'Condition 3-1'});
    set(ax, 'Ydir', 'reverse')
    colorbar()
    end

    for ci=1:condct
    ax=nsubplot(1,condct*2+2*condct-1,1,ci+condct+2);
    y=y_rand{ci};
    y=y-mean(y(:,30:40),2);
    imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
    ax.YAxis.Visible = 'off';
    xlim([-0.2 1.45]);
    xlabel('Seconds');
    title({'NO Info  '; conditionNames{ci}});
    set(ax, 'Ydir', 'reverse')
    colorbar()
    end

    y1=y_rand{1};
    y2=y_rand{2};
    ax=nsubplot(1,condct*2+2*condct-1,1,condct*2+3);
    y=y2-y1;
    imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
    ax.YAxis.Visible = 'off';
    xlim([-0.2 1.45]);
    xlabel('Seconds');
    title({'NO Info,'; 'Condition 2-1'});
    set(ax, 'Ydir', 'reverse')
    colorbar()

    if condct==3
    y_rand1=y_rand{1};
    y_rand2=y_rand{3};
    ax=nsubplot(1,condct*2+2*condct-1,1,condct*2+4);
    y=y_rand2-y_rand1;
    imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
    ax.YAxis.Visible = 'off';
    xlim([-0.2 1.45]);
    xlabel('Seconds');
    title({'NO Info,'; 'Condition 3-1'});
    set(ax, 'Ydir', 'reverse')
    end
    colorbar()
    colorcet('D1');
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 0.96, [strjoin(mice,' _ '),' Sort Info ',conditionNames{cd}],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');


    colorcet('D1');
saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_TimeConditionDifferences_SortInfo_',conditionNames{cd}]),'pdf');

% %%%%%%%%%%%%%%%%%%%%%%%
cell_sort_ids=randIdx(:,cd);

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');

for ci=1:condct
ax=nsubplot(1,condct*2+2*condct-1,1,ci);
y=y_info{ci};
y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title({'Info  '; conditionNames{ci}});
set(ax, 'Ydir', 'reverse')
colorbar()
end

y_info1=y_info{1};
y_info2=y_info{2};
ax=nsubplot(1,condct*2+2*condct-1,1,condct+1);
y=y_info2-y_info1;
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title({'Info,'; 'Condition 2-1'});
set(ax, 'Ydir', 'reverse')
colorbar()

if condct==3
y_info1=y_info{1};
y_info2=y_info{3};
ax=nsubplot(1,condct*2+2*condct-1,1,condct+2);
y=y_info2-y_info1;
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title({'Info,'; 'Condition 3-1'});
set(ax, 'Ydir', 'reverse')
colorbar()
end

for ci=1:condct
ax=nsubplot(1,condct*2+2*condct-1,1,ci+condct+2);
y=y_rand{ci};
y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title({'NO Info  '; conditionNames{ci}});
set(ax, 'Ydir', 'reverse')
colorbar()
end

y1=y_rand{1};
y2=y_rand{2};
ax=nsubplot(1,condct*2+2*condct-1,1,condct*2+3);
y=y2-y1;
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title({'NO Info,'; 'Condition 2-1'});
set(ax, 'Ydir', 'reverse')
colorbar()

if condct==3
y_rand1=y_rand{1};
y_rand2=y_rand{3};
ax=nsubplot(1,condct*2+2*condct-1,1,condct*2+4);
y=y_rand2-y_rand1;
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title({'NO Info,'; 'Condition 3-1'});
set(ax, 'Ydir', 'reverse')
colorbar()
end


colorcet('D1');
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, [strjoin(mice,' _ '),' Sort NO Info ',conditionNames{cd}],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');

colorcet('D1');
saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_TimeConditionDifferences_SortNOInfo_',conditionNames{cd}]),'pdf');

end



%% **HEATMAP OF PRE VS POST LEARNING CENTER ODOR RESPONSES

y_info=[]; infoSort=[]; infoIdx=[];
y_rand=[]; randSort=[]; randIdx=[];
diffSort=[];diffIdx=[];

for cd=1:numel(conditions{1})
   y_info{cd}=mean(a.C_odor1FirstInfoForced{cd},3,'omitnan');
   y_rand{cd}=mean(a.C_odor1FirstRandForced{cd},3,'omitnan');
   
   y_info{cd}=y_info{cd}-mean(y_info{cd}(:,30:40),2);
   y_rand{cd}=y_rand{cd}-mean(y_rand{cd}(:,30:40),2);
   ydiff{cd}=y_info{cd}-y_rand{cd};
    [infoSort(:,cd),infoIdx(:,cd)] = sort(mean(y_info{cd}(:,40:64),2,'omitnan'),'descend');
    [randSort(:,cd),randIdx(:,cd)] = sort(mean(y_rand{cd}(:,40:64),2,'omitnan'),'descend');
    [diffSort(:,cd),diffIdx(:,cd)] = sort(mean(ydiff{cd}(:,40:64),2,'omitnan'),'descend');
end

e=3;
t=a.t{e};
color_limits=[-1.6 1.6];
diff_limits = [-0.8 0.8];

cd=2;
cell_sort_ids=diffIdx(:,cd);

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');


ax=nsubplot(1,4,1,1);
y=y_info{1};
% y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
% imagesc(t,1:size(y,1),y3,color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'Left  '; conditionNames{1}}); %{'First line';'Second line'}
set(ax, 'Ydir', 'reverse')
% ylim([0 20])
colorbar();

ax=nsubplot(1,4,1,2);
y=y_rand{1};
% y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'Right  '; conditionNames{1}}); %{'First line';'Second line'}
set(ax, 'Ydir', 'reverse')
colorbar();

ax=nsubplot(1,4,1,3);
y=y_info{2};
% y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'Info  '; conditionNames{2}}); %{'First line';'Second line'}
set(ax, 'Ydir', 'reverse')
colorbar();

ax=nsubplot(1,4,1,4);
y=y_rand{2};
% y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'No Info  '; conditionNames{2}}); %{'First line';'Second line'}
set(ax, 'Ydir', 'reverse')
colorbar();


colorcet('D1');
% colormap(a.ckr);
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, [strjoin(mice,' _ '),' Sort Info ',conditionNames{cd}],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');


saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_TimeConditionDifferences_SortNEW_',conditionNames{cd}]),'pdf');

%% **CODING STABILITY

fig = figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [1 1 10 7];
set(fig,'PaperOrientation','landscape');
set(fig,'renderer','painters');

y_info{1}=mean(a.C_odor1FirstInfoForced{1},3,'omitnan');
y_rand{1}=mean(a.C_odor1FirstRandForced{1},3,'omitnan');
y_info{2}=mean(a.C_odor1FirstInfoForced{2},3,'omitnan');
y_rand{2}=mean(a.C_odor1FirstRandForced{2},3,'omitnan');

info1=mean(y_info{1}(:,a.okt{e}),2);
info2=mean(y_info{2}(:,a.okt{e}),2);
rand1=mean(y_rand{1}(:,a.okt{e}),2);
rand2=mean(y_rand{2}(:,a.okt{e}),2);

ax1=nsubplot(1,2,1,1);
hold on;
scatter(ax1,info1,info2, 'k');
[co,p]=corr(info1,info2,'Type','Pearson');
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
h = refline(1, 0);          % slope = 1, intercept = 0
h.Color = 'r';              % optional: change color
h.LineStyle = '--'; 
xlabel('Mean Info Activity Day 1');
ylabel('Mean Info Activity Day 2');
title(['Info corr= ' num2str(co) ' p= ' num2str(p,'%.4g') ]);
axis equal;
hold off;

ax2=nsubplot(1,2,1,2);
hold on;
scatter(ax2,rand1,rand2, 'k');
[co,p]=corr(rand1,rand2,'Type','Pearson');
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
h = refline(1, 0);          % slope = 1, intercept = 0
h.Color = 'r';              % optional: change color
h.LineStyle = '--'; 
xlabel('Mean Rand Activity Day 1');
ylabel('Mean Rand Activity Day 2');
title(['Rand corr= ' num2str(co) ' p= ' num2str(p,'%.4g') ]);
axis square;
hold off;
saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_ConditionCorr']),'pdf');
