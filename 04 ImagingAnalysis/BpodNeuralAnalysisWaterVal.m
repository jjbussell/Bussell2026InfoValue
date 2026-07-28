% %% TO DO

% check names

% shuffle for larry sig cells/PCs/over time
% decoding within mouse vs overall
% sig cells (ROC, signrank)

%% TO PULL MULTI- or SINGLE-MOUSE, MULTI-SESSION DATA IN AND ANALYZE

clear all; close all;

rng('shuffle')

set(0,'DefaultFigureWindowStyle','docked'); % plot in docked window

%% DATA FOLDER

datapath=uigetdir('','Choose data directory');
% datapath = 'D:\Dropbox\BpodInfoseek\Analysis\CombinedPipeline';

% plotfolder
if exist(fullfile(datapath,'plots'))
    plotfolder=fullfile(datapath,'plots');
else
    mkdir(fullfile(datapath,'plots'))
    plotfolder=fullfile(datapath,'plots');
end

output_dir = plotfolder;

%% LOAD PARAMS
params=load(fullfile(datapath,'InfoseekNeuroAnalysisParamsStay.mat'));

%% LOAD DATASET INFO (SESSION TABLE)
load(fullfile(datapath,['BpodInfoseekSessions_',params.dataset{1},'.mat']));

%% SET SESSIONS TO LOAD

% mice = {'JB483','JB484'};
% days = {{'20240614','20240618','20240625','20240628'},{'20240614','20240619','20240628','20240701'}};
% okMice=[1 2];

mice = {'JB483','JB484','JB506','JB507','JB509'};
days = {{'20240614','20240618','20240625','20240628'},{'20240614','20240619','20240628','20240701'},{'20250205','20250206','20250212','20250213'},{'20250206','20250207','20250213','20250214'},{'20250205','20250206','20250213','20250214'}};
okMice=[1 2 3 4 5];

% mice = {'JB413','JB426'};
% days = {{'20211123','20211124','20211220','20211223'},{'20220302','20220303','20220316','20220317'}};
% okMice=[1 2];
% mice = {'JB413','JB424','JB425','JB426','JB432','JB433','JB434'};
% days = {{'20211123','20211124','20211220','20211223'},...
%     {'20220210','20220211','20220223','20220224'},...
%     {'20220203','20220207','20220217','20220218'},...
%     {'20220302','20220303','20220316','20220317'},...
%     {'20220526','20220527','20220613','20220614'},...
%     {'20220526','20220527','20220608','20220609'},...
%     {'20220526','20220527','20220606','20220607'}};
% okMice = [1 2 3 4 5 6 7];
% mice = {'JB426'};
% days = {{'20220302','20220303','20220316','20220317'},{1}};

alldays={};
for m=1:numel(mice)
    alldays=[alldays days{m}];
end
alldays=strjoin(alldays);

%% PULL IN DATA FOR EACH MOUSE

files=dir('random');
for m=1:numel(mice)
   regfname=dir(fullfile(datapath,[mice{m} '_' num2str(numel(days{m})) 'days*_SCOUTreg.mat']));
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
%       files=[files; dir(fullfile(datapath,filename))];
       m=find(strcmp(b.mouse{1},mice));
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
end

numFiles=numel(files);
for m=1:numel(mice)
    maxTrialsAll(m)=size(z(m).day,1);
end
maxTrials=max(maxTrialsAll);

%% Conditional activity within each animal

for m=1:numel(mice)
    a=z(m);
    
    c.C_baseline=a.C_baseline;
    c.C_events{1} = a.C_trialStart;
    c.C_events{2} = a.C_centerEntry;
    c.C_events{3} = a.C_odor1;
    c.C_events{4} = a.C_centerExit;
    c.C_events{5} = a.C_sideEntry;
    c.C_events{6} = a.C_odor2;
    c.C_events{7} = a.C_outcome;
    c.C_events{8} = a.C_odor1All;
    c.C_events{9} = a.C_odor1First;
    c.C_events{10} = a.C_baseline;
    c.C_events{11} = a.C_trial;
    c.C_events{12} = a.C_sideExit;
    c.C_events{13} = a.C_centerExitFirst;
    c.C_events{14} = a.C_tone;
    
    % ONLY CORRECT TRIALS
    c.C_odor1Info = a.C_odor1(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==2);
    c.C_odor1Rand = a.C_odor1(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==3);
    c.C_odor1Small = a.C_odor1(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==1);
    c.C_odor1Big = a.C_odor1(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==4);

    c.C_odor1InfoFirst = a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==2);
    c.C_odor1RandFirst = a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==3);
    c.C_odor1SmallFirst = a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==1);
    c.C_odor1BigFirst = a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==4);
    
    %{
    % outcomes
    1 small no choice
    2 small correct
    3 small NP
    4 small incorrect
    5 info no choice
    6 info big
    7 info big NP
    8 info small
    9 info small NP
    10 info incorrect
    11 rand no choice
    12 rand big
    13 rand big NP
    14 rand small
    15 rand small NP
    16 rand incorrect
    17 big no choice
    18 big correct
    19 big NP
    20 big incorrect
    %}
    
    infoBig = [6,7];
    infoSmall = [8,9];
    randBig = [12,13];
    randSmall = [14,15];
    bigWater = [18,19];
    smallWater = [2,3];

    c.C_odor1FirstInfoForcedBig = a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & ismember(a.imagingOutcome,infoBig));
    c.C_odor1FirstInfoForcedSmall = a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & ismember(a.imagingOutcome,infoSmall));
    c.C_odor1FirstRandForcedBig = a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & ismember(a.imagingOutcome,randBig));
    c.C_odor1FirstRandForcedSmall = a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & ismember(a.imagingOutcome,randSmall));
    c.C_odor1FirstBigForced = a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & ismember(a.imagingOutcome,bigWater));
    c.C_odor1FirstSmallForced = a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & ismember(a.imagingOutcome,smallWater));

    left = a.infoSide==0 & a.imagingChoice==2 | a.bigSide==0 & a.imagingChoice==4 | a.infoSide==1 & a.imagingChoice==3 | a.bigSide==1 & a.imagingChoice==1;
    right = a.infoSide==0 & a.imagingChoice==3 | a.bigSide==0 & a.imagingChoice==1 | a.infoSide==1 & a.imagingChoice==2 | a.bigSide==1 & a.imagingChoice==4;
    c.C_odor1FirstLeft = a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & left==1);
    c.C_odor1FirstRight = a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & right==1);    
    
    c.C_odor1FirstInfoLeft=a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & a.infoSide==0&a.imagingChoice==2);
    c.C_odor1FirstInfoRight=a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & a.infoSide==1&a.imagingChoice==2);
    c.C_odor1FirstRandRight=a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & a.infoSide==0&a.imagingChoice==3);
    c.C_odor1FirstRandLeft=a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & a.infoSide==1&a.imagingChoice==3);
    c.C_odor1FirstBigLeft=a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & a.bigSide==0&a.imagingChoice==4);
    c.C_odor1FirstBigRight=a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & a.bigSide==1&a.imagingChoice==4);
    c.C_odor1FirstSmallRight=a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & a.bigSide==0&a.imagingChoice==1);
    c.C_odor1FirstSmallLeft=a.C_odor1First(:,:,a.imagingPrevCorrect == 1 & a.bigSide==1&a.imagingChoice==1);    
     
    centerEntryCount=a.centerEntryCount(a.imagingTrials==1);
    c.C_odor1OnlyInfo = a.C_odor1(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==2 & centerEntryCount==1);
    c.C_odor1OnlyRand = a.C_odor1(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==3 & centerEntryCount==1);
    c.C_odor1OnlyBig = a.C_odor1(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==4 & centerEntryCount==1);
    c.C_odor1OnlySmall = a.C_odor1(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==1 & centerEntryCount==1);    

    c.C_centerExitInfo = a.C_centerExit(:,:,a.imagingPrevCorrect == 1 &a.imagingChoice==2);
    c.C_centerExitRand = a.C_centerExit(:,:,a.imagingPrevCorrect == 1 &a.imagingChoice==3);
    c.C_centerExitBig = a.C_centerExit(:,:,a.imagingPrevCorrect == 1 &a.imagingChoice==4);
    c.C_centerExitSmall = a.C_centerExit(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==1);

    c.C_sideEntryInfo = a.C_sideEntry(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==2);
    c.C_sideEntryRand = a.C_sideEntry(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==3);
    c.C_sideEntryBig = a.C_sideEntry(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==4);
    c.C_sideEntrySmall = a.C_sideEntry(:,:,a.imagingPrevCorrect == 1 & a.imagingChoice==4);

    c.C_odor2A = a.C_odor2(:,:,a.imagingOdor2 == 1);
    c.C_odor2B = a.C_odor2(:,:,a.imagingOdor2 == 2);
    c.C_odor2C = a.C_odor2(:,:,a.imagingOdor2 == 3);
    c.C_odor2D = a.C_odor2(:,:,a.imagingOdor2 == 4);
    c.C_odor2Water = a.C_odor2(:,:,a.imagingOdor2 == 5);
    c.C_odor2info = a.C_odor2(:,:,a.imagingOdor2 == 1 | a.imagingOdor2 == 2);
    c.C_odor2rand = a.C_odor2(:,:,a.imagingOdor2 == 3 | a.imagingOdor2 == 4);

    c.C_odor2BStay = a.C_odor2(:,:,a.imagingOutcome == 13 | a.imagingOutcome == 4);
    c.C_odor2BLeave = a.C_odor2(:,:,a.imagingOutcome == 14 | a.imagingOutcome == 5);

    c.C_sideExitA = a.C_sideExit(:,:,a.imagingOdor2 == 1);
    c.C_sideExitB = a.C_sideExit(:,:,a.imagingOdor2 == 2);
    c.C_sideExitC = a.C_sideExit(:,:,a.imagingOdor2 == 3);
    c.C_sideExitD = a.C_sideExit(:,:,a.imagingOdor2 == 4);
    c.C_sideExitWater = a.C_sideExit(:,:,a.imagingOdor2 == 5);
    
    c.C_toneInfoBig = a.C_tone(:,:,ismember(a.imagingOutcome,infoBig));
    c.C_toneInfoSmall = a.C_tone(:,:,ismember(a.imagingOutcome,infoSmall));
    c.C_toneRandBig = a.C_tone(:,:,ismember(a.imagingOutcome,randBig));
    c.C_toneRandSmall = a.C_tone(:,:,ismember(a.imagingOutcome,randSmall));
    c.C_toneBig = a.C_tone(:,:,ismember(a.imagingOutcome,bigWater));
    c.C_toneSmall = a.C_tone(:,:,ismember(a.imagingOutcome,smallWater));
    
    c.C_outcomeInfoBig = a.C_outcome(:,:,ismember(a.imagingOutcome,infoBig));
    c.C_outcomeInfoSmall = a.C_outcome(:,:,ismember(a.imagingOutcome,infoSmall));
    c.C_outcomeRandBig = a.C_outcome(:,:,ismember(a.imagingOutcome,randBig));
    c.C_outcomeRandSmall = a.C_outcome(:,:,ismember(a.imagingOutcome,randSmall));
    c.C_outcomeBig = a.C_outcome(:,:,ismember(a.imagingOutcome,bigWater));
    c.C_outcomeSmall = a.C_outcome(:,:,ismember(a.imagingOutcome,smallWater));
    
    centerEntryCount=a.centerEntryCount(a.imagingTrials==1);
    %centerEntryCount==1 & 
    c.C_trialInfo=a.C_trial(:,:,a.imagingPrevCorrect == 1 & ismember(a.imagingOutcome,[infoBig infoSmall]));
    c.C_trialRand=a.C_trial(:,:,a.imagingPrevCorrect == 1 & ismember(a.imagingOutcome,[randBig randSmall]));
    c.C_trialInfoBig = a.C_trial(:,:,a.imagingPrevCorrect == 1 & ismember(a.imagingOutcome,infoBig));
    c.C_trialInfoSmall = a.C_trial(:,:,a.imagingPrevCorrect == 1 & ismember(a.imagingOutcome,infoSmall));
    c.C_trialRandBig = a.C_trial(:,:,a.imagingPrevCorrect == 1 & ismember(a.imagingOutcome,randBig));
    c.C_trialRandSmall = a.C_trial(:,:,a.imagingPrevCorrect == 1 & ismember(a.imagingOutcome,randSmall));
    c.C_trialBig = a.C_trial(:,:,a.imagingPrevCorrect == 1 & ismember(a.imagingOutcome,bigWater));
    c.C_trialSmall = a.C_trial(:,:,a.imagingPrevCorrect == 1 & ismember(a.imagingOutcome,smallWater));
    c.C_trialLeft = a.C_trial(:,:,a.imagingPrevCorrect == 1 & left==1);
    c.C_trialRight = a.C_trial(:,:,a.imagingPrevCorrect == 1 & right==1);
    
    c.C_trialRandForcedC = a.C_trial(:,:,a.imagingPrevCorrect == 1 & a.imagingOdor2 == 3);
    c.C_trialRandForcedD = a.C_trial(:,:,a.imagingPrevCorrect == 1 & a.imagingOdor2 == 4);
    
    c.C_trialInfoPrevInfo=a.C_trial(:,:,ismember(a.imagingPrevOutcome,[infoSmall]) & ismember(a.imagingOutcome,[infoBig infoSmall]));
    c.C_trialInfoPrevRand=a.C_trial(:,:,ismember(a.imagingPrevOutcome,[randSmall]) & ismember(a.imagingOutcome,[infoBig infoSmall]));
    c.C_trialRandPrevInfo=a.C_trial(:,:,ismember(a.imagingPrevOutcome,[infoSmall]) & ismember(a.imagingOutcome,[randBig randSmall]));
    c.C_trialRandPrevRand=a.C_trial(:,:,ismember(a.imagingPrevOutcome,[randSmall]) & ismember(a.imagingOutcome,[randBig randSmall]));
    
    c.C_trial=a.C_trial;
    
    % BASELINES

    % used to limit baseline to appropriate trial types
    % for both a.baseline and a.C_events of appropriate event with a.tpre
    % time just before event on appropriate trials OR

    c.baseline = cell(numel(c.C_events),1);
    for i = 1:numel(c.C_events)
        c.baseline{i,1}=c.C_events{i};
    end

    c.baselineTypes = cell(6,1); % size of namesfirst, 1 for each event with conditional activity

    c.baselineTypes{1}(a.imagingPrevCorrect == 1,1:4) = 1; % all trials for center odors
    c.baselineTypes{2}(a.imagingPrevCorrect == 1,1:4) = 1; % all trials for center odors
    c.baselineTypes{3}(a.imagingPrevCorrect == 1,1:4) = 1; % all trials for center odors
    c.baselineTypes{4}(1:sum(a.imagingTrials,1),5) = 0; % for side odors
    c.baselineTypes{4}(a.imagingChoice == 2,1) = 1; %info for info big
    c.baselineTypes{4}(a.imagingChoice == 2,2) = 1; %info for info small
    c.baselineTypes{4}(a.imagingChoice == 3,3) = 1; %rand for rand big
    c.baselineTypes{4}(a.imagingChoice == 3,4) = 1; %rand for rand small
    c.baselineTypes{4}(a.imagingChoice == 1 | a.imagingChoice == 4,5) = 1; %big or small for amount trials
    c.baselineTypes{5}(a.imagingOutcome == 6 | a.imagingOutcome == 7,1) = 1; %info big for info big
    c.baselineTypes{5}(a.imagingOutcome == 8 | a.imagingOutcome == 9,2) = 1; % info small for info small
    c.baselineTypes{5}(a.imagingChoice == 3,[3 4]) = 1; %rand for rand big and small  
    c.baselineTypes{6}(a.imagingOutcome == 6 | a.imagingOutcome == 7,1) = 1; %info big for info big
    c.baselineTypes{6}(a.imagingOutcome == 8 | a.imagingOutcome == 9,2) = 1; % info small for info small
    c.baselineTypes{6}(a.imagingOutcome == 12 | a.imagingOutcome == 13,3) = 1; %rand big for rand big
    c.baselineTypes{6}(a.imagingOutcome == 14 | a.imagingOutcome == 15,4) = 1; %rand small for rand small
    c.baselineTypes{6}(a.imagingChoice == 4,5) = 1; %big for big
    c.baselineTypes{6}(a.imagingChoice == 1,6) = 1; %small for small
    
    a.nameEventsFirst = [9,9,9,6,7,14];
    c.baselineCond = cell(size(c.baselineTypes,1),1);
    for cd = 1:size(c.baselineTypes,1)
       e = a.nameEventsFirst(cd);
       for ci = 1:size(c.baselineTypes{cd},2)
           c.baselineCond{cd}{ci} = c.baseline{e}(:,:,c.baselineTypes{cd}(:,ci)==1);
       end
    end

    
    c=rmfield(c,'baselineTypes');
%     c=rmfield(c,'compBaselineTypes');

    c.rxn=a.rxn;
%     c.infoside=a.infoSide;
%     c.bigside=a.bigSide;
    c.day=a.day;
    c.imageTrialType=a.imageTrialType;
    c.imagingOutcome=a.imagingOutcome;
    c.imagingChoice=a.imagingChoice;
    c.imagingPrevOutcome=a.imagingPrevOutcome;
    c.imagingPrevCorrect=a.imagingPrevCorrect;
   
    % STACK CELLS FROM EACH MOUSE IN X, ADD NaNs TO MAX TRIALS SO SAME SIZE
    vars=fields(c);
    for i=1:numel(vars)
        if strcmp(vars{i},'C_events')
            for j=1:numel(c.C_events)
                [numcells,numtime,numtrials]=size(c.(vars{i}){j});
                b=NaN(numcells,numtime,maxTrials);
                b(1:numcells,1:numtime,1:numtrials)=c.(vars{i}){j};
                if m==1
                   allmice.(vars{i}){j} = b; 
                else
                   allmice.(vars{i}){j}=cat(1,allmice.(vars{i}){j},b);
                end
                b=[];                
            end
        elseif strncmp(vars{i},'C_',2)
            [numcells,numtime,numtrials]=size(c.(vars{i}));
            b=NaN(numcells,numtime,maxTrials);
            b(1:numcells,1:numtime,1:numtrials)=c.(vars{i});    
            if m==1
               allmice.(vars{i}) = b; 
            else
               allmice.(vars{i})=cat(1,allmice.(vars{i}),b);
            end
            b=[];
        else
            if iscell(c.(vars{i}))
                if strcmp(vars{i},'day')
                    if m==1
                        allmice.day = c.day;
                    else
                        allmice.day=cat(1,allmice.day,c.day);
                    end
                else
                    for j=1:numel(c.(vars{i}))
                        if size(c.(vars{i}){1},1)==1
                            for ci=1:6
                                if numel(c.(vars{i}){j})>=ci
                                    [numcells,numtime,numtrials]=size(c.(vars{i}){j}{ci});
                                    b=NaN(numcells,numtime,maxTrials);
                                    b(1:numcells,1:numtime,1:numtrials)=c.(vars{i}){j}{ci};                        
                                    if m==1
                                       allmice.(vars{i}){j}{ci} = b; 
                                    else
                                       allmice.(vars{i}){j}{ci}=cat(1,allmice.(vars{i}){j}{ci},b);
                                    end
                                    b=[];
                                end
                            end
                        else
                            [numcells,numtime,numtrials]=size(c.(vars{i}){j});
                            b=NaN(numcells,numtime,maxTrials);
                            b(1:numcells,1:numtime,1:numtrials)=c.(vars{i}){j};
                            if m==1
                               allmice.(vars{i}){1,j} = b; 
                            else
                               allmice.(vars{i}){1,j}=cat(1,allmice.(vars{i}){j},b);
                            end
                            b=[];
                        end
                    end
                end
            else
                if m==1
                    allmice.(vars{i})=c.(vars{i});
                else
                    allmice.(vars{i})=cat(1,allmice.(vars{i}),c.(vars{i}));
                end
            end
        end
    end
    if m==1
        allmice.mouse(1:size(a.C_odor1,1),1)=m;
    else
       mouse(1:size(a.C_odor1,1),1)=m;
       allmice.mouse=cat(1,allmice.mouse,mouse);
    end
    clear a c mouse;
end


clear a;
a=allmice;
clear b c left right;
clear allmice;

a.neuronCt=size(a.C_odor1Info,1);

%% CONDITION NAMES - put in params

a.namesFirst = {{'C_odor1FirstInfoLeft','C_odor1FirstInfoRight','C_odor1FirstRandLeft','C_odor1FirstRandRight'};...
    {'C_odor1FirstBigLeft','C_odor1FirstBigRight','C_odor1FirstSmallLeft','C_odor1FirstSmallRight'};...
    {'C_odor1InfoFirst','C_odor1RandFirst','C_odor1BigFirst','C_odor1SmallFirst'};...
    {'C_odor2A','C_odor2B','C_odor2C','C_odor2D','C_odor2Water'};... 
    {'C_toneInfoBig','C_toneInfoSmall','C_toneRandBig','C_toneRandSmall'};...
    {'C_outcomeInfoBig','C_outcomeInfoSmall','C_outcomeRandBig','C_outcomeRandSmall','C_outcomeBig','C_outcomeSmall'}};
a.nameEventsFirst = [9,9,9,6,7,14];
a.compNamesFirst = {{'C_odor1FirstLeft','C_odor1FirstRight'};...
    {'C_odor1InfoFirst','C_odor1RandFirst'};...
    {'C_odor1BigFirst','C_odor1SmallFirst'};...
    {'C_odor2A','C_odor2B'};...
    {'C_odor2C','C_odor2D'};...
    {'C_odor2info','C_odor2rand'};...
    {'C_toneInfoBig','C_toneInfoSmall'};...
    {'C_toneRandBig','C_toneRandSmall'};...
    {'C_outcomeInfoBig','C_outcomeInfoSmall'};...
    {'C_outcomeRandBig','C_outcomeRandSmall'};...
    {'C_odor2B','C_odor2C'};...
    {'C_odor2A','C_odor2D'}};
a.compEventsFirst = [9,9,9,6,6,6,14,14,7,7,6,6];

a.trialCompNames={{'C_trialInfo','C_trialRand'};{'C_trialBig','C_trialSmall'};{'C_trialInfoBig','C_trialInfoSmall'};...
    {'C_trialRandForcedD','C_trialRandForcedC'};{'C_trialRandBig','C_trialRandSmall'}};
a.trialCompEvents=[11,11,11,11,11];

%% TIMES

framesAroundEvent = params.intervals./1000*params.Fs;
PID=0.075;

% time (in sec relative to odor onset) at each moment in the trial
for e = 1:numel(params.events)
    a.t{e}=((1:2*framesAroundEvent(e))-framesAroundEvent(e))*(1/params.Fs);
    a.okt{e} = params.resp_win(1) <= a.t{e} & a.t{e} <= params.resp_win(2);
    a.tRespEarly{e} = params.earlyResp(1) <= a.t{e} & a.t{e} <= params.earlyResp(2);
    a.tRespLate{e} = params.lateResp(1) <= a.t{e} & a.t{e} <= params.lateResp(2);
    a.tpre{e} = params.pre_win(1) <= a.t{e} & a.t{e} <= params.pre_win(2);
    a.tpreEarly{e} = params.earlyPre(1) <= a.t{e} & a.t{e} <= params.earlyPre(2);
    a.tpreLate{e} = params.latePre(1) <= a.t{e} & a.t{e} <= params.latePre(2);
end


%% ACTIVITY BY EVENT
% RANKSUM and ROC for each cell for mean response pre and post within each event
% 
% for e = 1:numel(a.C_events)
%    y = a.C_events{e};
%    ypre = squeeze(mean(a.baseline{e}(:,a.tpre{e},:),2,'omitnan'));
%    ypreEarly = squeeze(mean(a.baseline{e}(:,a.tpreEarly{e},:),2,'omitnan'));
%    ypreLate = squeeze(mean(a.baseline{e}(:,a.tpreLate{e},:),2,'omitnan'));
%    ypost = squeeze(mean(y(:,a.okt{e},:),2,'omitnan'));
%    ypostEarly = squeeze(mean(y(:,a.tRespEarly{e},:),2,'omitnan'));
%    ypostLate = squeeze(mean(y(:,a.tRespLate{e},:),2,'omitnan'));
%    
%    ypremean = mean(ypre,2,'omitnan');
%    ypostmean = mean(ypost,2,'omitnan');
% %    [a.C_eventsPopROC(e),a.C_eventsPopROCP(e)] = rocarea3(ypostmean,ypremean);  
%    a.C_eventsPopPrePostP(e) = ranksum(ypremean,ypostmean);
%       
%    for u = 1:a.neuronCt
%       % compare distributions of mean resp in time window across trials for each cell
%       a.C_eventsPrePostP(u,e) = ranksum(ypre(u,:),ypost(u,:)); % this is a t-test!!! does cell respond to this event
% %       [a.C_eventsPrePostROC(u,e),a.C_eventsPrePostROCP(u,e)] = rocarea3(ypre(u,:)',ypost(u,:)');
% %       [a.C_eventsPrePostEarlyROC(u,e),a.C_eventsPrePostEarlyROCP(u,e)] = rocarea3(ypreEarly(u,:)',ypostEarly(u,:)');
% %       [a.C_eventsPrePostLateROC(u,e),a.C_eventsPrePostLateROCP(u,e)] = rocarea3(ypreLate(u,:)',ypostLate(u,:)');
%    end
% end

%% CONDITIONAL RESPONSE OVER TIME (SLIDING FRAME ROC) NO JUST EACH FRAME
% disp('Calculating ROC over time');
% 
% % a.win = neuron.Fs/2;
% % a.win = 5;
% 
% for cd = 1:numel(a.namesFirst)
%    cname = a.namesFirst{cd};
%    e = a.nameEventsFirst(cd);
%    cy = cellfun(@(z) a.(z),cname,'uniform',0);
%    for ci = 1:numel(cname)
%        y = cy{ci};
%        ybaseline = a.baselineCond{cd}{ci}(:,a.tpre{e},:);
%        if ~isempty(y)& size(y,3)>1
%            for u=1:a.neuronCt
%               baseline = [];
%               activity = [];
%               timeActivity = [];
%               timeBaseline = [];
%               baseline = squeeze(ybaseline(u,:,:))';
%               baseline = reshape(baseline,numel(baseline),1);
%               activity = squeeze(y(u,:,:))';
%               for t = 1:size(y,2)
%                   timeActivity(:,t) = activity(:,t);
%                   timeBaseline(:,t) = baseline;
%                   a.smoothRS{cd}{ci}(u,t) = ranksum(timeBaseline(:,t),timeActivity(:,t));
%               end
% %             [a.ROCsmooth{cd}{ci}(u,:),a.pvalsmooth{cd}{ci}(u,:)]=rocarea3(timeBaseline,timeActivity);
%            end
%        end
%    end
% end

%% ROC CUTOFFS

a.pcrit = 0.05;
% a.ROCstd = std(reshape([a.ROCsmooth{4}{:}],1,numel([a.ROCsmooth{4}{:}])));
a.ROCcrit = 0.1;
a.maxcrit = 0.2;
a.diffcrit=0.1;
a.minFrames = 5;

% for cd = 1:numel(a.namesFirst)
%     cname = a.namesFirst{cd};
%     cy = cellfun(@(z) a.(z),cname,'uniform',0);
%     for ci=1:numel(cname)
%         y = cy{ci};
%         a.firstActive{cd}{ci}=NaN(a.neuronCt,1);
%         a.activeFrameCt{cd}{ci}=NaN(a.neuronCt,1);
%         a.condActive{cd}{ci}=NaN(a.neuronCt,1);
%         a.active{cd}{ci}=NaN(a.neuronCt,size(y,2));
%         if ~isempty(y)& size(y,3)>1
%         for u=1:a.neuronCt
% %             a.active{cd}{ci}(u,:)=a.pvalsmooth{cd}{ci}(u,:)<a.pcrit&a.ROCsmooth{cd}{ci}(u,:)-0.5>a.ROCcrit;
%             a.active{cd}{ci}(u,:)=a.smoothRS{cd}{ci}(u,:)<a.pcrit;        
%         end
%        a.activeFrameCt{cd}{ci} = sum(a.active{cd}{ci}(:,size(y,2)/2:end),2);
%        a.condActive{cd}{ci}=a.activeFrameCt{cd}{ci}>a.minFrames;
%        for u=1:a.neuronCt
%            if a.condActive{cd}{ci}(u,1)==1
%             a.firstActive{cd}{ci}(u,1) = find(a.active{cd}{ci}(u,size(y,2)/2:end),1);
%            end
%        end
%         end
%          a.C_condActivePercent{cd}{ci}=sum(a.condActive{cd}{ci})/a.neuronCt;
%     end
%     a.condActiveAllCell{cd} = [a.condActive{cd}{:}];
% end
% 
% a.condActiveAll=[a.condActiveAllCell{:}];

%% ACTIVITY BY CONDITION - RESPOND TO CONDITION

disp('Calculating conditional responses');

% RESPONSE TO EVENT WITHIN EACH CONDITION (PRE/BASELINE vs POST)

for cd = 1:numel(a.namesFirst)
   cname = a.namesFirst{cd};
   e = a.nameEventsFirst(cd);
   cy = cellfun(@(z) a.(z),cname,'uniform',0);
   t=a.t{e};
   okt=a.okt{e};   
   
%    a.C_condPrePostROC{cd}=cell(a.neuronCt,numel(cname));
%    a.C_condPrePostROCP{cd}=cell(a.neuronCt,numel(cname));
%    a.C_condBasePostROC{cd}=cell(a.neuronCt,numel(cname));
%    a.C_condBasePostROCP{cd}=cell(a.neuronCt,numel(cname));
%    a.C_condPrePostP{cd}=cell(a.neuronCt,numel(cname));
   a.C_condBasePostP{cd}=cell(a.neuronCt,numel(cname));
%    a.C_condPrePostEarlyROC{cd}=cell(a.neuronCt,numel(cname));
%    a.C_condPrePostEarlyROCP{cd}=cell(a.neuronCt,numel(cname));
%    a.C_condBasePostEarlyROC{cd}=cell(a.neuronCt,numel(cname));
%    a.C_condBasePostEarlyROCP{cd}=cell(a.neuronCt,numel(cname));
%    a.C_condPrePostLateROC{cd}=cell(a.neuronCt,numel(cname));
%    a.C_condPrePostLateROCP{cd}=cell(a.neuronCt,numel(cname));
%    a.C_condBasePostLateROC{cd}=cell(a.neuronCt,numel(cname));
%    a.C_condBasePostLateROCP{cd}=cell(a.neuronCt,numel(cname));
   
   for ci = 1:numel(cname)
       y = cy{ci};
       if ~isempty(y)
           % mean across time (vals for each trial for each cell)
           ybaseline = squeeze(mean(a.baselineCond{cd}{ci}(:,a.tpre{e},:),2,'omitnan'));

  
            
%            ybaselineEarly = squeeze(mean(a.baselineCond{cd}{ci}(:,a.tpreEarly{e},:),2,'omitnan'));
%            ybaselineLate = squeeze(mean(a.baselineCond{cd}{ci}(:,a.tpreLate{e},:),2,'omitnan'));
    %            overall baseline
%            ypre = squeeze(mean(a.C_events{e}(:,a.tpre{e},a.baselineTypes{cd}(:,ci)==1),2,'omitnan'));
%            ypreEarly = squeeze(mean(a.C_events{e}(:,a.tpreEarly{e},a.baselineTypes{cd}(:,ci)==1),2,'omitnan'));
%            ypreLate = squeeze(mean(a.C_events{e}(:,a.tpreLate{e},a.baselineTypes{cd}(:,ci)==1),2,'omitnan'));
           ypost = squeeze(mean(y(:,a.okt{e},:),2,'omitnan'));
%            ypostEarly = squeeze(mean(y(:,a.tRespEarly{e},:),2,'omitnan'));
%            ypostLate = squeeze(mean(y(:,a.tRespLate{e},:),2,'omitnan'));
           % mean across trials act pre/post for each cell
           a.baseAct{cd}{ci} = mean(ybaseline,2,'omitnan'); %cross trials
                      
%            a.preAct{cd}{ci} = mean(ypre,2,'omitnan');
           a.postAct{cd}{ci} = mean(ypost,2,'omitnan');
           % within condition for each cell compare distributions between pre/post activity (mean for each trial)
                      % find maximum value in 1.2s before event on each trial
           [maxval,maxidx]=max(y(:,16:39,:),[],2,'omitnan');
           maxval=squeeze(maxval);maxidx=squeeze(maxidx);
           basetimes=t(okt);
%            decay = @(b)
           ybaselineExp=[];
           for i=1:numel(basetimes)
               ybaselineExp(:,i,:)=maxval.*0.5.^((basetimes(i)-t(maxidx+16))/0.4);
           end
           ybaselineExp=squeeze(mean(ybaselineExp,2,'omitnan')); %across time
           
%            a.baseActExp{cd}{ci}=mean(ybaselineExp,2,'omitnan'); %across trials
           
%            badidx=a.baseAct{cd}{ci}-a.baseActExp{cd}{ci}>a.maxcrit;
            badidx=(ybaseline-ybaselineExp)>a.maxcrit;
           ybase=ybaselineExp;
%            ybase(badidx,:)=ybaseline(badidx,:);
            ybase(badidx)=ybaseline(badidx); 
           
           for u = 1:a.neuronCt
%               a.C_condPrePostP{cd}{u,ci} = ranksum(ypre(u,:),ypost(u,:));
              a.C_condBasePostP{cd}{u,ci} = ranksum(ybaseline(u,:),ypost(u,:));
              a.C_condBasePostPExp{cd}{u,ci} = ranksum(ybaselineExp(u,:),ypost(u,:));
              a.C_condBasePostPS{cd}{u,ci} = ranksum(ybase(u,:),ypost(u,:));

%               [a.C_condPrePostROC{cd}{u,ci},a.C_condPrePostROCP{cd}{u,ci}] = rocarea3(ypre(u,:)',ypost(u,:)');
%               [a.C_condPrePostEarlyROC{cd}{u,ci},a.C_condPrePostEarlyROCP{cd}{u,ci}] = rocarea3(ypreEarly(u,:)',ypostEarly(u,:)');
%               [a.C_condPrePostLateROC{cd}{u,ci},a.C_condPrePostLateROCP{cd}{u,ci}] = rocarea3(ypreLate(u,:)',ypostLate(u,:)');
%               [a.C_condBasePostROC{cd}{u,ci},a.C_condBasePostROCP{cd}{u,ci}] = rocarea3(ybaseline(u,:)',ypost(u,:)');
%               [a.C_condBasePostEarlyROC{cd}{u,ci},a.C_condBasePostEarlyROCP{cd}{u,ci}] = rocarea3(ybaselineEarly(u,:)',ypostEarly(u,:)');
%               [a.C_condBasePostLateROC{cd}{u,ci},a.C_condBasePostLateROCP{cd}{u,ci}] = rocarea3(ybaselineLate(u,:)',ypostLate(u,:)');
           end
           
%            cellPs = cell2mat(a.C_condBasePostROCP{cd}(:,ci));
%            cellROC = cell2mat(a.C_condBasePostROC{cd}(:,ci));
           ymean=mean(y,3,'omitnan');
           maxresp = max(ymean(:,a.okt{e}),[],2);
%            a.C_condBasePostActive{cd}{ci} = cellPs<a.pcrit&abs(cellROC-0.5)>a.ROCcrit;
%            a.C_condBasePostActive{cd}{ci} = cellPs<a.pcrit&maxresp>a.maxcrit&cellROC>0.5;
%            a.C_condBasePostRSActive{cd}{ci} = cell2mat(a.C_condBasePostP{cd}(:,ci))<a.pcrit&abs(a.postAct{cd}{ci}-a.baseAct{cd}{ci})>a.maxcrit;
%            a.C_condBasePostRSActive{cd}{ci} = cell2mat(a.C_condBasePostP{cd}(:,ci))<a.pcrit&maxresp>a.maxcrit&abs(a.postAct{cd}{ci}-a.baseAct{cd}{ci})>a.maxcrit;
            a.C_condBasePostRSActive{cd}{ci} = cell2mat(a.C_condBasePostP{cd}(:,ci))<a.pcrit&abs(a.postAct{cd}{ci}-a.baseAct{cd}{ci})>a.maxcrit;
            a.C_condBasePostRSActiveExp{cd}{ci} = cell2mat(a.C_condBasePostPS{cd}(:,ci))<a.pcrit&abs(a.postAct{cd}{ci}-a.baseAct{cd}{ci})>a.maxcrit;
            a.C_condBasePostRSActiveExpPos{cd}{ci} = cell2mat(a.C_condBasePostPS{cd}(:,ci))<a.pcrit&a.postAct{cd}{ci}-a.baseAct{cd}{ci}>0.1;
%            a.C_condPrePostpercent{cd}{ci} = sum(cell2mat(a.C_condPrePostP{cd}(:,ci))<a.pcrit)/a.neuronCt;
            a.C_condBasePostpercent{cd}{ci} = sum(cell2mat(a.C_condBasePostP{cd}(:,ci))<a.pcrit)/a.neuronCt;
%            a.C_condPrePostROCpercent{cd}{ci} = sum(cell2mat(a.C_condPrePostROCP{cd}(:,ci))<a.pcrit)/a.neuronCt;
%            a.C_condPrePostEarlyROCpercent{cd}{ci} = sum(cell2mat(a.C_condPrePostEarlyROCP{cd}(:,ci))<a.pcrit)/a.neuronCt;
%            a.C_condPrePostLateROCpercent{cd}{ci} = sum(cell2mat(a.C_condPrePostLateROCP{cd}(:,ci))<a.pcrit)/a.neuronCt;
%            a.C_condBasePostEarlyROCpercent{cd}{ci} = sum(cell2mat(a.C_condBasePostEarlyROCP{cd}(:,ci))<a.pcrit)/a.neuronCt;
%            a.C_condBasePostLateROCpercent{cd}{ci} = sum(cell2mat(a.C_condBasePostLateROCP{cd}(:,ci))<a.pcrit)/a.neuronCt;
%            a.C_condBasePostROCpercent{cd}{ci} = sum(a.C_condBasePostActive{cd}{ci})/a.neuronCt;
%            a.C_condPrePostROCpercentActive{cd}{ci}  = sum(cell2mat(a.C_condPrePostROCP{cd}(:,ci))<a.pcrit & cell2mat(a.C_condPrePostROC{cd}(:,ci))>0.5)/a.neuronCt;
%            a.C_condPrePostROCpercentInhibit{cd}{ci}  = sum(cell2mat(a.C_condPrePostROCP{cd}(:,ci))<a.pcrit & cell2mat(a.C_condPrePostROC{cd}(:,ci))<0.5)/a.neuronCt;
       end
   end
end

%% SHUFFLE ACTIVITY

mouseCells=histc(a.mouse(:),unique(a.mouse));
mouseCellCts=[0; cumsum(mouseCells)];

for cd = 1:size(a.compNamesFirst)
    cname = a.compNamesFirst{cd};
    e = a.compEventsFirst(cd);
    cy = cellfun(@(z) a.(z),cname,'uniform',0);    
    y1 = cy{1}; % all mice all activity for condition 1
    y2 = cy{2};
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
        
        y1mean = mean(y1,3,'omitnan'); % mean across trials in cond 1
        y2mean = mean(y2,3,'omitnan');

        y1meanPost = mean(y1mean(:,a.okt{e}),2,'omitnan');
        y1meanPre = mean(y1mean(:,a.tpre{e}),2,'omitnan');
        y2meanPost = mean(y2mean(:,a.okt{e}),2,'omitnan');
        y2meanPre = mean(y2mean(:,a.tpre{e}),2,'omitnan');
        
        a.shuffleDiff{cd}(:,:,j)=abs(y1mean-y2mean);
        a.shuffleDiffPost{cd}(:,j)=abs(y1meanPost-y2meanPost); % this is randNeuronAreas
        a.shuffleDiffPre{cd}(:,j)=abs(y1meanPre-y2meanPre);
        
        y11=y1(:,:,1:2:end); %condition 1 odd trials
        y12=y1(:,:,2:2:end); % condition 1 even trials

        y21=y2(:,:,1:2:end);
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
        a.activityDifferenceEBMShuffle{cd}(:,:,j) = ((sign(activityDifference1).*activityDifference2)+(sign(activityDifference2).*activityDifference1))/2;
    
        actDiffPost1 = y1meanPost1-y2meanPost1; % difference in post 1sec between condition 1 odds and condition 2 odds
        actDiffPost2 = y1meanPost2-y2meanPost2;
        a.actDiffPostEBMShuffle{cd}(:,j) = ((sign(actDiffPost1).*actDiffPost2)+(sign(actDiffPost2).*actDiffPost1))/2;
        
        actDiffPre1 = y1meanPre1-y2meanPre1; % difference in post 1sec between condition 1 odds and condition 2 odds
        actDiffPre2 = y1meanPre2-y2meanPre2;
        a.actDiffPreEBMShuffle{cd}(:,j) = ((sign(actDiffPre1).*actDiffPre2)+(sign(actDiffPre2).*actDiffPre1))/2;          
    end
end

%% ACTIVITY BETWEEN CONDITIONS (DIFFERENTIAL) - DIFFERENT BETWEEN CONDITIONS

disp('Calculating differential responses (ROCs)');

% RESPONSE ACROSS CONDITIONS MEAN AND OVER TIME

%  population ROC (distrib of avg cell response to condition)


for cd = 1:size(a.compNamesFirst)
    cname = a.compNamesFirst{cd};
    e = a.compEventsFirst(cd);
    cy = cellfun(@(z) a.(z),cname,'uniform',0);    
    y1 = cy{1};
    y2 = cy{2};
    
    y1mean = mean(y1,3,'omitnan'); % mean across trials in cond 1
    y2mean = mean(y2,3,'omitnan');
    
    y1meanPost = mean(y1mean(:,a.okt{e}),2,'omitnan');
    y1meanPre = mean(y1mean(:,a.tpre{e}),2,'omitnan');
    y2meanPost = mean(y2mean(:,a.okt{e}),2,'omitnan');
    y2meanPre = mean(y2mean(:,a.tpre{e}),2,'omitnan');
    
    if ~isempty(y1) & ~isempty(y2)
    
        % ROC and pval that population differentiates conditions across time
%         [a.rocsPop{cd,1},a.ROCPopPvals{cd,1}] = rocarea3(y2mean,y1mean);

        % ROC and pval that population differentiates conditions
%         [a.rocPopPost{cd,1},a.rocPopPostpval{cd,1}] = rocarea3(y2meanPost,y1meanPost);
%         [a.rocPopPre{cd,1},a.rocPopPrepval{cd,1}] = rocarea3(y2meanPre,y1meanPre);    

        % DIFFERENCE AND ABSOLUTE DIFFERENCE
        a.activityTimeDiff{cd} = y1mean-y2mean;
        a.absActivityTimeDiff{cd} = abs(y1mean-y2mean);
        a.activityPostDiff{cd} = y1meanPost-y2meanPost;
        a.absActivityPostDiff{cd} = abs(y1meanPost-y2meanPost);
        a.activityPreDiff{cd} = y1meanPre-y2meanPre;
        a.absActivityPreDiff{cd} = abs(y1meanPre-y2meanPre);
        
        % ARE THESE CORRECT?
        a.pNeuronsPost{cd} = zeros(a.neuronCt,1);
        a.pNeuronsPre{cd} = zeros(a.neuronCt,1);
        a.pNeuronsTime{cd} = zeros(a.neuronCt,size(a.absActivityTimeDiff{cd},2));
        for i=1:a.neuronCt
            a.pNeuronsPost{cd}(i) = 100*sum((a.shuffleDiffPost{cd}(:)>a.absActivityPostDiff{cd}(i))) ...
                /length(a.shuffleDiffPost{cd}(:));
            a.pNeuronsPre{cd}(i) = 100*sum((a.shuffleDiffPre{cd}(:)>a.absActivityPreDiff{cd}(i))) ...
                /length(a.shuffleDiffPre{cd}(:));            
            for t=1:size(a.absActivityTimeDiff{cd},2)
                randActivity =squeeze(a.shuffleDiff{cd}(:,t,:))';
                a.pNeuronsTime{cd}(i,t) = 100*sum((randActivity(:)>a.absActivityTimeDiff{cd}(i,t))) ...
                    /length(randActivity(:));
            end
        end
        a.nSigPost{cd}=sum(a.pNeuronsPost{cd}<(a.pcrit*100)&a.absActivityPostDiff{cd}>a.diffcrit)/a.neuronCt;
        a.nSigPre{cd}=sum(a.pNeuronsPre{cd}<(a.pcrit*100)&a.absActivityPreDiff{cd}>a.diffcrit)/a.neuronCt;
        a.nSigTime{cd}=sum(a.pNeuronsTime{cd}<(a.pcrit*100)&a.absActivityTimeDiff{cd}>a.diffcrit)/a.neuronCt;
        
        for t=1:size(a.absActivityTimeDiff{cd},2)
            a.popAbsDiffP{cd}(1,t)=signrank(a.absActivityTimeDiff{cd}(:,t));
        end

        % RANK-SUM & ROCs between conditions
        for u = 1:a.neuronCt
            Activity_1 = squeeze(cy{1}(u,:,:))';
            Activity_2 = squeeze(cy{2}(u,:,:))';
%             Baseline_1 = squeeze(a.baselineComp{cd}(u,a.tpre{e},:))';
%             Baseline_2 = squeeze(a.baselineComp{cd}(u,a.tpre{e},:))';

            % rank-sum p-val that cell differentiates conditions across time
            for t = 1:size(Activity_1,2)
               a.RSpvals{cd,1}(u,t) = ranksum(Activity_1(:,t),Activity_2(:,t));
            end

            a.RSpvalsmean{cd,1}(u,1) = ranksum(mean(Activity_2(:,a.okt{e}),2,'omitnan'),mean(Activity_1(:,a.okt{e}),2,'omitnan'));
            a.RSpvalsmeanPre{cd,1}(u,1) = ranksum(mean(Activity_2(:,a.tpre{e}),2,'omitnan'),mean(Activity_1(:,a.tpre{e}),2,'omitnan'));
%             a.RSpvalsmeanBase{cd,1}(u,1) = ranksum(mean(Baseline_2,2,'omitnan'),mean(Baseline_1,2,'omitnan'));

            % ROC and pval that cell differentiates conditions across time
%             [a.rocs{cd,1}(u,:),a.ROCpvals{cd,1}(u,:)] = rocarea3(Activity_2,Activity_1);
            
            % ROC and pval that cell differentiates conditions pre and post
            % event (mean response)
%             [a.rocsmean{cd,1}(u,1),a.ROCpvalsmean{cd,1}(u,1)] = rocarea3(mean(Activity_2(:,a.okt{e}),2,'omitnan'),mean(Activity_1(:,a.okt{e}),2,'omitnan'));
%             [a.rocsmeanEarly{cd,1}(u,1),a.ROCpvalsmeanEarly{cd,1}(u,1)] = rocarea3(mean(Activity_2(:,a.tRespEarly{e}),2,'omitnan'),mean(Activity_1(:,a.tRespEarly{e}),2,'omitnan'));
%             [a.rocsmeanLate{cd,1}(u,1),a.ROCpvalsmeanLate{cd,1}(u,1)] = rocarea3(mean(Activity_2(:,a.tRespLate{e}),2,'omitnan'),mean(Activity_1(:,a.tRespLate{e}),2,'omitnan'));
%             [a.rocsmeanbase{cd,1}(u,1),a.ROCpvalsbasemean{cd,1}(u,1)] = rocarea3(mean(Baseline_2,2),mean(Baseline_1,2,'omitnan'));
%             [a.rocsmeanPre{cd,1}(u,1),a.ROCpvalsmeanPre{cd,1}(u,1)] = rocarea3(mean(Activity_2(:,a.tpre{e}),2,'omitnan'),mean(Activity_1(:,a.tpre{e}),2,'omitnan'));
%             [a.rocsmeanPreEarly{cd,1}(u,1),a.ROCpvalsmeanPreEarly{cd,1}(u,1)] = rocarea3(mean(Activity_2(:,a.tpreEarly{e}),2,'omitnan'),mean(Activity_1(:,a.tpreEarly{e}),2,'omitnan'));
%             [a.rocsmeanPreLate{cd,1}(u,1),a.ROCpvalsmeanPreLate{cd,1}(u,1)] = rocarea3(mean(Activity_2(:,a.tpreLate{e}),2,'omitnan'),mean(Activity_1(:,a.tpreLate{e}),2,'omitnan'));
        end

%         a.pcellsROC{cd,:} = sum(a.ROCpvals{cd,1}<a.pcrit)/a.neuronCt;
%         a.pcellsmeanROC{cd,:} = sum(a.ROCpvalsmean{cd,1}<a.pcrit)/a.neuronCt;
%         a.pcellsmeanROCEarly{cd,:} = sum(a.ROCpvalsmeanEarly{cd,1}<a.pcrit)/a.neuronCt;
%         a.pcellsmeanROCLate{cd,:} = sum(a.ROCpvalsmeanLate{cd,1}<a.pcrit)/a.neuronCt;
%         a.pcellsmeanpreROC{cd,:} = sum(a.ROCpvalsmeanPre{cd,1}<a.pcrit)/a.neuronCt;
%         a.pcellsmeanbaseROC{cd,:} = sum(a.ROCpvalsbasemean{cd,1}<a.pcrit)/a.neuronCt;
%         a.pcellsmeanpreROCEarly{cd,:} = sum(a.ROCpvalsmeanPreEarly{cd,1}<a.pcrit)/a.neuronCt;
%         a.pcellsmeanpreROCLate{cd,:} = sum(a.ROCpvalsmeanPreLate{cd,1}<a.pcrit)/a.neuronCt;
        a.pcellsRS{cd,:} = sum(a.RSpvals{cd,1}<a.pcrit&a.absActivityPostDiff{cd}>a.diffcrit)/a.neuronCt;
        a.pcellsmeanRS{cd,:} = sum(a.RSpvalsmean{cd,1}<a.pcrit&a.absActivityPostDiff{cd}>a.diffcrit)/a.neuronCt;
        a.pcellsmeanpreRS{cd,:} = sum(a.RSpvalsmeanPre{cd,1}<a.pcrit&a.absActivityPreDiff{cd}>a.diffcrit)/a.neuronCt;
%         a.pcellsmeanBaseRS{cd,:} = sum(a.RSpvalsmeanBase{cd,1}<a.pcrit&a.absActivityBaseDiff{cd}>a.diffcrit)/a.neuronCt;
%         a.sigcells{cd,:} = a.ROCpvalsmean{cd,1}<a.pcrit;
            % MEAN ROCS
         
        a.C_condRSdifferent{cd}=a.RSpvalsmean{cd,1}<a.pcrit&a.absActivityPostDiff{cd}>a.diffcrit;
        a.C_condShuffleDifferent{cd}=a.pNeuronsPost{cd}<(a.pcrit*100)&a.absActivityPostDiff{cd}>a.diffcrit;     
            
%         a.C_condRSdifferent{cd}=a.RSpvalsmean{cd,1}<a.pcrit&a.absActivityPostDiff{cd}>a.maxcrit;
%         a.C_condROCdifferent{cd}=a.ROCpvalsmean{cd,1}<a.pcrit&abs(a.rocsmean{cd}-0.5)>a.ROCcrit;
%         a.C_condShuffleDifferent{cd}=a.pNeuronsPost{cd}<(a.pcrit*100)&a.absActivityPostDiff{cd}>a.maxcrit;

    % mean ROC for pop over time
%     a.rocsPopMean{cd,1} = mean(abs(a.rocs{cd}-0.5),1);
    
    else
%         a.rocsPop{cd,1} = NaN;
%         a.ROCPopPvals{cd,1} = NaN;
%         a.rocPopPost{cd,1} = NaN;
%         a.rocPopPostpval{cd,1} = NaN;
%         a.rocPopPre{cd,1} = NaN;
%         a.rocPopPrepval{cd,1} = NaN;
        a.activityTimeDiff{cd} = NaN;
        a.absActivityTimeDiff{cd} = NaN;
        a.RSpvals{cd,1} = NaN(a.neuronCt,80);
        a.RSpvalsmean{cd,1} = NaN(a.neuronCt,1);
        a.RSpvalsmeanPre{cd,1} = NaN(a.neuronCt,1);
%         a.rocs{cd,1} = NaN(a.neuronCt,80);
%         a.ROCpvals{cd,1} = NaN(a.neuronCt,80);
%         a.rocsmean{cd,1} = NaN(a.neuronCt,1);
%         a.ROCpvalsmean{cd,1} = NaN(a.neuronCt,1);
%         a.ROCpvalsbasemean{cd,1} = NaN(a.neuronCt,1);
%         a.rocsmeanEarly{cd,1} = NaN(a.neuronCt,1);
%         a.ROCpvalsmeanEarly{cd,1} = NaN(a.neuronCt,1);
%         a.rocsmeanLate{cd,1} = NaN(a.neuronCt,1);
%         a.ROCpvalsmeanLate{cd,1} = NaN(a.neuronCt,1);
%         a.rocsmeanPre{cd,1} = NaN(a.neuronCt,1);
%         a.rocsmeanbase{cd,1} = NaN(a.neuronCt,1);
%         a.ROCpvalsmeanPre{cd,1} = NaN(a.neuronCt,1);
%         a.rocsmeanPreEarly{cd,1} = NaN(a.neuronCt,1);
%         a.ROCpvalsmeanPreEarly{cd,1} = NaN(a.neuronCt,1);
%         a.rocsmeanPreLate{cd,1} = NaN(a.neuronCt,1);
%         a.ROCpvalsmeanPreLate{cd,1} = NaN(a.neuronCt,1);
%         a.pcellsROC{cd,:} = NaN;
%         a.pcellsmeanROC{cd,:} = NaN;
%         a.pcellsmeanROCEarly{cd,:} = NaN;
%         a.pcellsmeanROCLate{cd,:} = NaN;
%         a.pcellsmeanpreROC{cd,:} = NaN;
%         a.pcellsmeanprebaseROC{cd,:} = NaN;
%         a.pcellsmeanpreROCEarly{cd,:} = NaN;
%         a.pcellsmeanpreROCLate{cd,:} = NaN;
        a.pcellsRS{cd,:} = NaN;
        a.pcellsmeanRS{cd,:} = NaN;
        a.pcellsmeanpreRS{cd,:} = NaN;
%         a.pcellsmeanpreBaseRS{cd,:} = NaN;
%         a.sigcells{cd,:} = NaN;
%         a.rocsPopMean{cd,1} = NaN;
    end

end

% %%
% a.ROCpercent = [a.pcellsmeanROC(1);a.pcellsmeanROCEarly(1);...
%     a.pcellsmeanROCLate(1);a.pcellsmeanROC(2:end)];
% % a.ROCpercentPre = [a.pcellsmeanpreROC(1);a.pcellsmeanpreROCEarly(1);...
% %     a.pcellsmeanpreROCLate(1);a.pcellsmeanpreROC(2:end)];
% a.rocsmeanEarlyLate = [a.rocsmean(1);a.rocsmeanEarly(1);a.rocsmeanLate(1);...
%     a.rocsmean(2:end)];
% a.ROCpvalsmeanEarlyLate = [a.ROCpvalsmean(1);a.ROCpvalsmeanEarly(1);a.ROCpvalsmeanLate(1);...
%     a.ROCpvalsmean(2:end)];

%% SIGNIFICANT DIFFERENCE (non-cross-validated)



%% ETHAN BALANCED DIFFERENCE

for cd = 1:size(a.compNamesFirst)
    cname = a.compNamesFirst{cd};
    e = a.compEventsFirst(cd);
    cy = cellfun(@(z) a.(z),cname,'uniform',0);    
    y1 = cy{1};
    y2 = cy{2};
    
    y11=y1(:,:,1:2:end); %condition 1 odd trials
    y12=y1(:,:,2:2:end); % condition 1 even trials
    
    y21=y2(:,:,1:2:end);
    y22=y2(:,:,2:2:end);    
    
    y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1 odd trials
    y1mean2 = mean(y12,3,'omitnan'); % mean across trials in cond 1 even trials
    y2mean1 = mean(y21,3,'omitnan');
    y2mean2 = mean(y22,3,'omitnan');
    
    y1meanPost1 = mean(y1mean1(:,a.okt{e}),2,'omitnan'); % mean post-act in condition 1 odd trials
    y1meanPre1 = mean(y1mean1(:,a.tpre{e}),2,'omitnan');
    y1meanPost2 = mean(y1mean2(:,a.okt{e}),2,'omitnan'); % mean post-act in condition 1 even trials
    y1meanPre2 = mean(y1mean2(:,a.tpre{e}),2,'omitnan');    
    y2meanPost1 = mean(y2mean1(:,a.okt{e}),2,'omitnan');
    y2meanPre1 = mean(y2mean1(:,a.tpre{e}),2,'omitnan');   
    y2meanPost2 = mean(y2mean2(:,a.okt{e}),2,'omitnan');
    y2meanPre2 = mean(y2mean2(:,a.tpre{e}),2,'omitnan');
    
    activityDifference1 = y1mean1-y2mean1; % condition 1 odd trials - condition 2 odd trials (then multiply by sign of even trials)
    activityDifference2 = y1mean2-y2mean2;
    a.activityDifferenceEBM{cd} = (sign(activityDifference1).*activityDifference2+sign(activityDifference2).*activityDifference1)/2;
    a.popActDiffEBM{cd}=mean(a.activityDifferenceEBM{cd});
    
    actDiffPost1 = y1meanPost1-y2meanPost1; % difference in post 1sec between condition 1 odds and condition 2 odds
    actDiffPost2 = y1meanPost2-y2meanPost2;
    a.actDiffPostEBM{cd} = (sign(actDiffPost1).*actDiffPost2+sign(actDiffPost2).*actDiffPost1)/2;

    actDiffPre1 = y1meanPre1-y2meanPre1; % difference in post 1sec between condition 1 odds and condition 2 odds
    actDiffPre2 = y1meanPre2-y2meanPre2;
    a.actDiffPreEBM{cd} = (sign(actDiffPre1).*actDiffPre2+sign(actDiffPre2).*actDiffPre1)/2;       
    
    for t=1:size(activityDifference1,2)
        a.activityDifferenceEBMSig{cd}(:,t) = signrank(a.activityDifferenceEBM{cd}(:,t));
    end
    
    a.actDiffIdxEBMPostSig{cd} = signrank(mean(a.activityDifferenceEBM{cd}(:,a.okt{e}),2));
    a.actDiffIdxEBMPreSig{cd} = signrank(mean(a.activityDifferenceEBM{cd}(:,a.tpre{e}),2));
    

%     for i=1:a.neuronCt
%         a.pactDiffPostEBM{cd}(i) = sum(abs(a.actDiffPostEBMShuffle{cd}(:))>abs(a.actDiffPostEBM{cd}(i))) ...
%             /length(a.actDiffPostEBMShuffle{cd}(:));           
%         for t=1:size(a.absActivityTimeDiff{cd},2)
%             randActivity =squeeze(a.activityDifferenceEBMShuffle{cd}(:,t,:))';
%             a.pactDiffEBM{cd}(i,t) = sum(abs(randActivity(:))> abs(a.activityDifferenceEBM{cd}(i,t))) ...
%                 /length(randActivity(:));              
%         end
%     end
    
    
%     randMean=squeeze(mean(a.activityDifferenceEBMShuffle{cd},1));
%     for t=1:size(a.popActDiffEBM{cd},2)
%         a.ppopActDiffEBM{cd}(1,t)=mean(abs(randMean(t,:))>=abs(a.popActDiffEBM{cd}(1,t)));
%     end
    
end

%% SIGNFICANT DIFFERENCES

for cd = 1:size(a.compNamesFirst)
    trueDiff = a.actDiffPostEBM{cd}-a.actDiffPreEBM{cd};
    trueDiffPop = mean(a.actDiffPostEBM{cd}) - mean(a.actDiffPreEBM{cd});

    shuffleDiff = a.actDiffPostEBMShuffle{cd}-a.actDiffPreEBMShuffle{cd};
    shuffleDiffPop = mean(a.actDiffPostEBMShuffle{cd})-mean(a.actDiffPreEBMShuffle{cd});

    a.actDiffPopIdxEBMSig{cd}=sum(shuffleDiffPop>trueDiffPop)/1000;
    a.actDiffIdxEBMSig{cd}=sum(shuffleDiff>trueDiff,2)/1000;
end

%%
clear cy yy y1 yy1 y2 yy2 y11 y12 y y21 y22 s1 y1shuffle s2 y2shuffle timeBaseline randActivity

%% SHUFFLE FULL TRIAL ACTIVITY

mouseCells=histc(a.mouse(:),unique(a.mouse));
mouseCellCts=[0; cumsum(mouseCells)];

for cd = 1:size(a.trialCompNames)
    cname = a.trialCompNames{cd};
    e = a.trialCompEvents(cd);
    cy = cellfun(@(z) a.(z),cname,'uniform',0);    
    y1 = cy{1}; % all mice all activity for condition 1
    y2 = cy{2};
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
    
    for j=1:100
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
        
        y1mean = mean(y1,3,'omitnan'); % mean across trials in cond 1
        y2mean = mean(y2,3,'omitnan');
        a.shuffleDiffTrial{cd}(:,:,j)=abs(y1mean-y2mean);
        
        y11=y1(:,:,1:2:end);
        y12=y1(:,:,2:2:end);

        y21=y2(:,:,1:2:end);
        y22=y2(:,:,2:2:end);
        y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
        y1mean2 = mean(y12,3,'omitnan');
        y2mean1 = mean(y21,3,'omitnan');
        y2mean2 = mean(y22,3,'omitnan');
        activityDifferenceTrial1 = y1mean1-y2mean1;
        activityDifferenceTrial2 = y1mean2-y2mean2;
        a.activityDifferenceTrialEBMShuffle{cd}(:,:,j) = (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;
  
    end
end


%% ACTIVITY BETWEEN CONDITIONS (DIFFERENTIAL) - WHOLE TRIAL
% 
% disp('Calculating differential responses (ROCs)');
% 
% % RESPONSE ACROSS CONDITIONS MEAN AND OVER TIME
% 
% %  population ROC (distrib of avg cell response to condition)
% 
% 
% for cd = 1:size(a.trialCompNames)
%     cname = a.trialCompNames{cd};
%     e = a.trialCompEvents(cd);
%     cy = cellfun(@(z) a.(z),cname,'uniform',0);    
%     y1 = cy{1};
%     y2 = cy{2};
%     
%     y1mean = mean(y1,3,'omitnan'); % mean across trials in cond 1
%     y2mean = mean(y2,3,'omitnan');
%     
% %     y1meanPost = mean(y1mean(:,a.okt{e}),2,'omitnan');
% %     y1meanPre = mean(y1mean(:,a.tpre{e}),2,'omitnan');
% %     y2meanPost = mean(y2mean(:,a.okt{e}),2,'omitnan');
% %     y2meanPre = mean(y2mean(:,a.tpre{e}),2,'omitnan');
%     
%     if ~isempty(y1) & ~isempty(y2)   
% 
%         % DIFFERENCE AND ABSOLUTE DIFFERENCE
%         a.activityTimeDiffTrial{cd} = y1mean-y2mean;
%         a.absActivityTimeDiffTrial{cd} = abs(y1mean-y2mean);
% %         a.activityPostDiffTrial{cd} = y1meanPost-y2meanPost;
% %         a.absActivityPostDiffTrial{cd} = abs(y1meanPost-y2meanPost);
% %         a.activityPreDiffTrial{cd} = y1meanPre-y2meanPre;
% %         a.absActivityPreDiffTrial{cd} = abs(y1meanPre-y2meanPre);
%         
%         % ARE THESE CORRECT?
% %         a.pNeuronsPostTrial{cd} = zeros(a.neuronCt,1);
% %         a.pNeuronsPreTrial{cd} = zeros(a.neuronCt,1);
% %         a.pNeuronsTimeTrial{cd} = zeros(a.neuronCt,size(a.absActivityTimeDiffTrial{cd},2));
% %         for i=1:a.neuronCt
% %             a.pNeuronsPostTrial{cd}(i) = 100*sum((a.shuffleDiffPostTrial{cd}(:)>a.absActivityPostDiffTrial{cd}(i))) ...
% %                 /length(a.shuffleDiffPostTrial{cd}(:));
% %             a.pNeuronsPreTrial{cd}(i) = 100*sum((a.shuffleDiffPreTrial{cd}(:)>a.absActivityPreDiffTrial{cd}(i))) ...
% %                 /length(a.shuffleDiffPreTrial{cd}(:));            
% %             for t=1:size(a.absActivityTimeDiffTrial{cd},2)
% %                 randActivity =squeeze(a.shuffleDiffTrial{cd}(:,t,:))';
% %                 a.pNeuronsTimeTrial{cd}(i,t) = 100*sum((randActivity(:)>a.absActivityTimeDiffTrial{cd}(i,t))) ...
% %                     /length(randActivity(:));                
% %             end
% %         end
% %         a.nSigPostTrial{cd}=sum(a.pNeuronsPostTrial{cd}<(a.pcrit*100)&a.absActivityPostDiffTrial{cd}>a.diffcrit)/a.neuronCt;
% %         a.nSigPreTrial{cd}=sum(a.pNeuronsPreTrial{cd}<(a.pcrit*100)&a.absActivityPreDiffTrial{cd}>a.diffcrit)/a.neuronCt;
% %         a.nSigTimeTrial{cd}=sum(a.pNeuronsTimeTrial{cd}<(a.pcrit*100)&a.absActivityTimeDiffTrial{cd}>a.diffcrit)/a.neuronCt;
% 
%         % RANK-SUM & ROCs between conditions
%         for u = 1:a.neuronCt
%             Activity_1 = squeeze(cy{1}(u,:,:))';
%             Activity_2 = squeeze(cy{2}(u,:,:))';
% 
%             % rank-sum p-val that cell differentiates conditions across time
%             for t = 1:size(Activity_1,2)
%                a.RSpvalsTrial{cd,1}(u,t) = ranksum(Activity_1(:,t),Activity_2(:,t));
%             end
% 
% %             a.RSpvalsmeanTrial{cd,1}(u,1) = ranksum(mean(Activity_2(:,a.okt{e}),2,'omitnan'),mean(Activity_1(:,a.okt{e}),2,'omitnan'));
% %             a.RSpvalsmeanPreTrial{cd,1}(u,1) = ranksum(mean(Activity_2(:,a.tpre{e}),2,'omitnan'),mean(Activity_1(:,a.tpre{e}),2,'omitnan'));
%         end
% %         a.pcellsRSTrial{cd,:} = sum(a.RSpvalsTrial{cd,1}<a.pcrit&a.absActivityPostDiffTrial{cd}>a.diffcrit)/a.neuronCt;
% %         a.pcellsmeanRSTrial{cd,:} = sum(a.RSpvalsmeanTrial{cd,1}<a.pcrit&a.absActivityPostDiffTrial{cd}>a.diffcrit)/a.neuronCt;
% %         a.pcellsmeanpreRSTrial{cd,:} = sum(a.RSpvalsmeanPreTrial{cd,1}<a.pcrit&a.absActivityPreDiffTrial{cd}>a.diffcrit)/a.neuronCt;
%             % MEAN ROCS
%          
% %         a.C_condRSdifferentTrial{cd}=a.RSpvalsmeanTrial{cd,1}<a.pcrit&a.absActivityPostDiffTrial{cd}>a.diffcrit;
% %         a.C_condShuffleDifferentTrial{cd}=a.pNeuronsPostTrial{cd}<(a.pcrit*100)&a.absActivityPostDiffTrial{cd}>a.diffcrit;     
% 
%     % mean ROC for pop over time
%     
%     else
%         a.activityTimeDiffTrial{cd} = NaN;
%         a.absActivityTimeDiffTrial{cd} = NaN;
%         a.RSpvalsTrial{cd,1} = NaN(a.neuronCt,80);
% %         a.RSpvalsmeanTrial{cd,1} = NaN(a.neuronCt,1);
% %         a.RSpvalsmeanPreTrial{cd,1} = NaN(a.neuronCt,1);
% 
%         a.pcellsRSTrial{cd,:} = NaN;
% %         a.pcellsmeanRSTrial{cd,:} = NaN;
% %         a.pcellsmeanpreRSTrial{cd,:} = NaN;
%     end
% 
% end

%% WHOLE TRIAL EBM BALANCED DIFF

for cd = 1:size(a.trialCompNames)
    cname = a.trialCompNames{cd};
    e = a.trialCompEvents(cd);
    cy = cellfun(@(z) a.(z),cname,'uniform',0);    
    y1 = cy{1};
    y2 = cy{2};
    
    clear cy;
    
%     y11=y1(:,:,1:2:end);
%     y12=y1(:,:,2:2:end);
%     
%     y21=y2(:,:,1:2:end);
%     y22=y2(:,:,2:2:end);    
    
%     y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
%     y1mean2 = mean(y12,3,'omitnan');
%     y2mean1 = mean(y21,3,'omitnan');
%     y2mean2 = mean(y22,3,'omitnan');

    y1mean1 = mean(y1(:,:,1:2:end),3,'omitnan'); % mean across trials in cond 1
    y1mean2 = mean(y1(:,:,2:2:end),3,'omitnan');
    
    clear y1;
    
    y2mean1 = mean(y2(:,:,1:2:end),3,'omitnan');
    y2mean2 = mean(y2(:,:,2:2:end),3,'omitnan');
    
    clear y2;
    
    y1meanPost1 = mean(y1mean1(:,a.okt{e}),2,'omitnan');
    y1meanPre1 = mean(y1mean1(:,a.tpre{e}),2,'omitnan');
    y1meanPost2 = mean(y1mean2(:,a.okt{e}),2,'omitnan');
    y1meanPre2 = mean(y1mean2(:,a.tpre{e}),2,'omitnan');    
    y2meanPost1 = mean(y2mean1(:,a.okt{e}),2,'omitnan');
    y2meanPre1 = mean(y2mean1(:,a.tpre{e}),2,'omitnan');   
    y2meanPost2 = mean(y2mean2(:,a.okt{e}),2,'omitnan');
    y2meanPre2 = mean(y2mean2(:,a.tpre{e}),2,'omitnan');
    
    activityDifferenceTrial1 = y1mean1-y2mean1;
    activityDifferenceTrial2 = y1mean2-y2mean2;
    a.activityDifferenceTrialEBM{cd} = (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;
    
    for t=1:size(activityDifferenceTrial1,2)
        a.activityDifferenceTrialEBMSig{cd}(:,t) = signrank(a.activityDifferenceTrialEBM{cd}(:,t));
    end
    
end


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END ORIG ANALYSIS NEURAL ANALYZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %% SEPARATE ACTIVITY BY MOUSE FOR SHUFFLE/DECODING
% 
% iStart = 40;
% iStop = 56;
% N=size(a.C_odor1InfoFirst,1);
% 
% % reconstruct activity for each mouse - make function!
% mouseCells=histc(a.mouse(:),unique(a.mouse));
% mouseCellCts=[0; cumsum(mouseCells)];
% nmI=sum(~isnan(a.C_odor1InfoFirst(cumsum(mouseCells),1,:)),3);
% nmR=sum(~isnan(a.C_odor1RandFirst(cumsum(mouseCells),1,:)),3);
% nmB=sum(~isnan(a.C_odor1BigFirst(cumsum(mouseCells),1,:)),3);
% nmS=sum(~isnan(a.C_odor1SmallFirst(cumsum(mouseCells),1,:)),3);
% 
% 
% % doesn't include NaNs!!
% for m=1:numel(mice)
%    I{m}=a.C_odor1InfoFirst(mouseCellCts(m)+1:mouseCellCts(m+1),iStart:iStop,1:nmI(m)); 
%    R{m}=a.C_odor1RandFirst(mouseCellCts(m)+1:mouseCellCts(m+1),iStart:iStop,1:nmR(m));
%    B{m}=a.C_odor1BigFirst(mouseCellCts(m)+1:mouseCellCts(m+1),iStart:iStop,1:nmB(m));
%    S{m}=a.C_odor1SmallFirst(mouseCellCts(m)+1:mouseCellCts(m+1),iStart:iStop,1:nmS(m));
%    mAct{m}=cat(3,I{m},R{m},B{m},S{m});
%    iI{m}(1:nmI(m),1)=1;
%    iR{m}(1:nmR(m),1)=2;
%    iB{m}(1:nmB(m),1)=3;
%    iS{m}(1:nmS(m),1)=4;
%    ii{m}=[iI{m};iR{m};iB{m};iS{m}];
%    mxT(m)=numel(ii{m});
% end
% 
% mxT=max(mxT);
% 
% % can use above for decoding!!
% %% SHUFFLE for stats
% 
% nRuns = 1000;
% randPCAreaI = zeros(nRuns,1);
% randPCAreaW = zeros(nRuns,1);
% randNeuronAreasI = zeros(nRuns,N);
% randNeuronAreasW = zeros(nRuns,N);
% 
% for j=1:nRuns
%     for m=1:numel(mice)
%         % shuffle all trials (all types)
%         iShuffle{m}=ii{m}(randperm(size(ii{m},1)));
%         for i=1:4
%             rs{i} = mAct{m}(:,:,iShuffle{m}==i);
%             s{i}=NaN(size(rs{i},1),size(rs{i},2),mxT);
%             s{i}(:,:,1:size(rs{i},3))=rs{i};     
%             if m==1
%                shuffleR{i} = s{i};
%             else
%                shuffleR{i} = cat(1,shuffleR{i},s{i});
%             end
%         end       
%     end
% 
% %     data{j}=suffleR;
%     
%     rsI = squeeze(mean(shuffleR{1},3,'omitnan'));
%     rsR = squeeze(mean(shuffleR{2},3,'omitnan'));
%     rsB = squeeze(mean(shuffleR{3},3,'omitnan'));
%     rsS = squeeze(mean(shuffleR{4},3,'omitnan'));
%     
%     rsI = rsI - rsI(:,1);
%     rsR = rsR - rsR(:,1);
%     rsB = rsB - rsB(:,1);
%     rsS = rsS - rsS(:,1);
% 
%     rsIN = rsI-rsR; % neurons x time (selected interval)
% 
%     [UsIN SsIN VsIN] = svd(rsIN);
%     LsIN = diag(SsIN).^2;
%     LsIN = 100*LsIN/sum(LsIN);
% 
%     randPCAreaI(j) = abs(mean(UsIN(:,1)'*rsIN));
%     randNeuronAreasI(j,:) = abs(mean(rsIN,2));
%     
%     rsW = rsB-rsS;
%     
%     [UsW SsW VsW] = svd(rsW);
%     LsW = diag(SsW).^2;
%     LsW = 100*LsW/sum(LsW);
% 
%     randPCAreaW(j) = abs(mean(UsW(:,1)'*rsW));
%     randNeuronAreasW(j,:) = abs(mean(rsW,2));     
%  
% end
% 
% %% PCA
% 
% rI = mean(a.C_odor1InfoFirst(:,iStart:iStop,:),3,'omitnan');
% rR = mean(a.C_odor1RandFirst(:,iStart:iStop,:),3,'omitnan');
% rB = mean(a.C_odor1BigFirst(:,iStart:iStop,:),3,'omitnan');
% rS = mean(a.C_odor1SmallFirst(:,iStart:iStop,:),3,'omitnan');
% 
% rI = rI - rI(:,1);
% rR = rR - rR(:,1);
% rB = rB - rB(:,1);
% rS = rS - rS(:,1);
% 
% rIN = rI-rR;
% 
% rW = rB-rS;
% 
% [UIN SIN VIN] = svd(rIN);
% LIN = diag(SIN).^2;
% LIN = 100*LIN/sum(LIN);
% percentVarInfo = 100*(var(rI'*UIN(:,1))+var(rR'*UIN(:,1)))/ ...
%                     (sum(var(rI'))+sum(var(rR')))
% 
% [UINSort iINSort] = sort(UIN(:,1),'descend');
% 
% PCArea = abs(mean(UIN(:,1)'*rIN));
% sNeuronAreas = mean(rIN,2);
% NeuronAreas = abs(sNeuronAreas);
% [ASort iASort] = sort(NeuronAreas,'descend');
% [sASort isASort] = sort(sNeuronAreas,'descend');
% 
% pPC = 100*sum(randPCAreaI>PCArea)/nRuns;
% pNeurons = zeros(N,1);
% for i=1:N
%     pNeurons(i) = 100*sum((randNeuronAreasI(:)>NeuronAreas(i))) ...
%         /length(randNeuronAreasI(:));
% end
% nSig  = sum(pNeurons<5)'
% a.PCAinfocells=pNeurons<5;
% 
% % save('pStats','nSig','pPC', 'pNeurons');
% 
% [UW SW VW] = svd(rW);
% LW = diag(SW).^2;
% LW = 100*LW/sum(LW);
% [UWSort iWSort] = sort(UW(:,1),'descend');
% % [sLRSort,isLRSort] = sort(mean(rLR,2),'descend');
% percentVarLeftRight = 100*(var(rB'*UW(:,1))+var(rS'*UW(:,1)))/ ...
%                     (sum(var(rB'))+sum(var(rS')))
% 
% PCAreaW = abs(mean(UW(:,1)'*rW));
% sNeuronAreasW = mean(rW,2);
% NeuronAreasW = abs(sNeuronAreasW);
% [ASortW iASortW] = sort(NeuronAreasW,'descend');
% [sASortW isASortW] = sort(sNeuronAreasW,'descend');
% 
% pPCW = 100*sum(randPCAreaW>PCAreaW)/nRuns
% pNeuronsW = zeros(N,1);
% for i=1:N
%     pNeuronsW(i) = 100*sum((randNeuronAreasW(:)>NeuronAreasW(i))) ...
%         /length(randNeuronAreasW(:));
% end
% nSigW  = sum(pNeuronsW<5)'
% 
% % save('pStats','nSig','pPC', 'pNeurons');
% 
% %%
% 
% rIvar = rI - mean(rI,2);
% rRvar = rR - mean(rR,2);
% rINvar = rIvar-rRvar;
% [UINvar SINvar VINvar] = svd(rINvar);
% percentVarInfo = 100*(var(rIvar'*UINvar(:,1))+var(rRvar'*UINvar(:,1)))/ ...
%                     (sum(var(rIvar'))+sum(var(rRvar')))
% 
% rBvar = rB - mean(rB,2);
% rSvar = rS - mean(rS,2);
% rWvar = rBvar-rSvar;
% [UWvar SWvar VWvar] = svd(rWvar);
% percentVarVigSmall = 100*(var(rBvar'*UWvar(:,1))+var(rSvar'*UWvar(:,1)))/ ...
%                     (sum(var(rBvar'))+sum(var(rSvar')))
% 
% %% DECODING
% 
% % %mAct is concatenated activity for each mouse
% % % ii is 1-4 code for trial type
% % 
% % minI=min(nmI(okMice));
% % minR=min(nmR(okMice));
% % minB=min(nmB(okMice));
% % minS=min(nmS(okMice));
% % 
% % xI=[];xR=[];xB=[];xS=[];
% % ms=okMice;
% % for mm=1:numel(okMice)
% %     m=ms(mm);
% % rnI=randperm(nmI(m)); % random list of trials of this type for this mouse
% % xI=cat(1,xI,squeeze(mean(I{m}(:,:,rnI(1:minI)),2)));
% % rnR=randperm(nmR(m));
% % xR=cat(1,xR,squeeze(mean(R{m}(:,:,rnR(1:minR)),2)));
% % rnB=randperm(nmB(m));
% % xB=cat(1,xB,squeeze(mean(B{m}(:,:,rnB(1:minB)),2)));
% % rnS=randperm(nmS(m));
% % xS=cat(1,xS,squeeze(mean(S{m}(:,:,rnS(1:minS)),2)));
% % end
% % 
% % xI=xI'; xR=xR'; xB=xB'; xS=xS';
% % 
% % yI=ones(size(xI,1),1).*1;
% % yR=ones(size(xR,1),1).*-1;
% % yB=ones(size(xB,1),1).*1;
% % yS=ones(size(xS,1),1).*-1;
% % xx=cat(1,xIL,xIR,xNL,xNR);
% % y=cat(1,yIL,yIR,yNL,yNR);
% % 
% % nTrial = size(xx,1);
% % decodeName='Info';
% % 
% % % randomly scrambly across trials
% % iTt = randperm(nTrial);
% % xx = xx(iTt,:);
% % y = y(iTt);  
% % % train SVM
% % svmTrain = fitclinear(xx,y); 
% % %check error percent
% % eTrain = 100*sum((y.*(xx*svmTrain.Beta+svmTrain.Bias)>=0))/nTrial;
% 
% % define weights and sort
% % wDecode = svmTrain.Beta/norm(svmTrain.Beta);
% % [wSort iDSort] = sort(wDecode,'descend');
% % 
% % percentages = [LIN(1) LLR(1) eTrain]
% % [correl(1),corrpval(1)]=corr(UIN(:,1),ULR(:,1));
% % [correl(2),corrpval(2)]=corr(UIN(ismember(a.mouse,okMice),1),wDecode);
% % [correl(3),corrpval(3)]=corr(ULR(ismember(a.mouse,okMice),1),wDecode);
% % [correl(4),corrpval(4)]=corr(UIN(:,1),mean(rIN,2));
% % correlations = [correl(:)];
% % corrpvals = [corrpval(:)];
% % correlations = [corr(UIN(:,1),ULR(:,1)) corr(UIN(a.mouse~=2,1),wDecode)...
% %     corr(ULR(a.mouse~=2,1),wDecode) corr(UIN(:,1),mean(rIN,2))]
% 
% %% DECODING OVER TIME
% 
% decodeEvent='Center Odor First';
% e=3;
% 
% nTest = 1000;
% i1List = 1:5:76;
% eTest = zeros(length(i1List),1);
% 
% t=a.t{e}(i1List+2);
% 
% minI=min(nmI(okMice));
% minR=min(nmR(okMice));
% minB=min(nmB(okMice));
% minS=min(nmS(okMice));
% 
% % randomize trial order within each type within each mouse,
% % then concatenate across mice (only minimum number of that trial type
% % across all mice)
% m=1;
% xI=[];xR=[];xB=[];xS=[];
% ms=okMice;
% for mm=1:numel(okMice)
%     m=ms(mm);
%     mI=a.C_odor1InfoFirst(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmI(m));
%     rnI=randperm(nmI(m));
%     xI=cat(1,xI,mI(:,:,rnI(1:minI)));
%     mR=a.C_odor1RandFirst(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmR(m));
%     rnR=randperm(nmR(m));
%     xR=cat(1,xR,mR(:,:,rnR(1:minR)));
%     mB=a.C_odor1BigFirst(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmB(m));
%     rnB=randperm(nmB(m));
%     xB=cat(1,xB,mB(:,:,rnB(1:minB)));
%     mS=a.C_odor1SmallFirst(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmS(m));
%     rnS=randperm(nmS(m));
%     xS=cat(1,xS,mS(:,:,rnS(1:minS)));    
% end
% 
% 
% %% INFO
% i1=50;
% i2=54;
% 
% decodeName='Info';
% decode=1;
% for jj=1:length(i1List)
%     i1 = i1List(jj);
%     i2 = i1+4;
%     xIt=squeeze(mean(xI(:,i1:i2,:),2))'; % mean across time period, trials x cells
%     xRt=squeeze(mean(xR(:,i1:i2,:),2))';
%     xBt=squeeze(mean(xB(:,i1:i2,:),2))';
%     xSt=squeeze(mean(xS(:,i1:i2,:),2))';
%     
%     x1=xIt;
%     x2=xRt;
% 
%     x_size=min([size(x1,1) size(x2,1)]);
%     xx1=randperm(size(x1,1));
%     xx2=randperm(size(x2,1));
%     x1=x1(xx1,:);
%     x2=x2(xx2,:);
%     x1=x1(1:x_size,:);
%     x2=x2(1:x_size,:);    
%     
%     x=cat(1,x1,x2); % all types together
%     nTrial = size(x,1);
%     nOut = round(0.2*nTrial);
%     yI=ones(size(x1,1),1).*1;
%     yR=ones(size(x2,1),1).*-1;
%     y=cat(1,yI,yR);
% 
%     errTest = zeros(nTest,1);
%     for i=1:nTest
%         ip = randperm(nTrial);
%         iTest = ip(1:nOut);
%         iT = randperm(nTrial);
%         xx = x(iT,:);
%         yy = y(iT,:);
%         xTest = xx(iTest,:);
%         yTest = yy(iTest);
%         xx(iTest,:) = [];
%         yy(iTest,:) = [];
%         svmInfo = fitclinear(xx,yy);
%         errTest(i)=100*sum((yTest.*(xTest*svmInfo.Beta+svmInfo.Bias)<0))/nOut;
%         infoWeights(:,i)=svmInfo.Beta;
%     end
%     error{decode}(:,jj)=100-errTest;
%     eTest(decode,jj) = mean(100-errTest);
%     decodeweights{decode}(:,jj)=mean(infoWeights,2);
%     
%     if jj==12
% %         infoDecodeIdx = mean(abs(infoWeights),2)./std(abs(infoWeights),0,2);
%         infoDecodeIdx = mean(abs(infoWeights),2);
%     end
% end
% 
% preError=[];postError=[];
% 
% SEM = std(error{decode})/sqrt(length(error{decode}));               % Standard Error
% ts = tinv([0.025  0.975],length(error{decode})-1);      % T-Score
% interval(1,:) = ts(1)*SEM;
% interval(2,:) = ts(2)*SEM;
% preError(decode,:)=mean(error{decode}(:,5:8),2);
% postError(decode,:)=mean(error{decode}(:,9:12),2);
% pDecode(decode)=signrank(preError(decode,:),postError(decode,:),'tail','left');
% 
% % PLOTTING
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [1 1 10 7];
%     set(fig,'PaperOrientation','landscape');
% set(fig,'renderer','painters');
% ax=nsubplot(1,1,1,1);
% plot(ax,t,eTest(decode,:));
% errorbar(t,eTest(decode,:),interval(1,:),interval(2,:),"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
% hold on;
% plot([-1 +1].*10^10,[50 50],'k','linewidth',2,'xliminclude','off')
% plot([0+PID 0+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor On
% plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor Off
% plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'color',[.8 .8 .8],'linewidth',2,'yliminclude','off') % Side Odor on
% 
% xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% xticks2 = xticks2 + PID;
% xticks(xticks2);
% xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% set(gca, 'XTickLabel', xticklabels2);
% plot([0.075 0.075], ylim, '--r');
% xlim([-0.5+PID 2])
% 
% ylim([40 100])
% xlabel('decoding time (s)')
% ylabel('decoding accuracy')
% hold off;
% title([strjoin(mice,' _ ') ' decoding ' decodeName ' at ' decodeEvent ' p=' num2str(pDecode(decode))]);
% saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_' decodeName '_' decodeEvent]),'pdf');
% 
% 
% %% DECODE WATER WITH INFO DECODER
% 
% decodeName='WaterInfo';
% decode=3;
% for jj=1:length(i1List)
%     i1 = i1List(jj);
%     i2 = i1+4;
%     
%     xIt=squeeze(mean(xI(:,i1:i2,:),2))'; % mean across time period, trials x cells
%     xRt=squeeze(mean(xR(:,i1:i2,:),2))';
%     xBt=squeeze(mean(xB(:,i1:i2,:),2))';
%     xSt=squeeze(mean(xS(:,i1:i2,:),2))';
% 
%     x1=xBt;
%     x2=xSt;
% 
%     x_size=min([size(x1,1) size(x2,1)]);
%     xx1=randperm(size(x1,1));
%     xx2=randperm(size(x2,1));
%     x1=x1(xx1,:);
%     x2=x2(xx2,:);
%     x1=x1(1:x_size,:);
%     x2=x2(1:x_size,:);    
%     
%     x=cat(1,x1,x2); % all types together
%     nTrial = size(x,1);
%     nOut = round(0.2*nTrial);
%     yI=ones(size(x1,1),1).*1;
%     yR=ones(size(x2,1),1).*-1;
%     y=cat(1,yI,yR);
% 
%     errTest = zeros(nTest,1);
%     for i=1:nTest
%         ip = randperm(nTrial);
%         iTest = ip(1:nOut);
%         iT = randperm(nTrial);
%         xx = x(iT,:);
%         yy = y(iT,:);
%         xTest = xx(iTest,:);
%         yTest = yy(iTest);
%         xx(iTest,:) = [];
%         yy(iTest,:) = [];
% %         svmInfo = fitclinear(xx,yy);
%         errTest(i)=100*sum((yTest.*(xTest*svmInfo.Beta+svmInfo.Bias)<0))/nOut;
%     end
%     error{decode}(:,jj)=100-errTest;
%     eTest(decode,jj) = mean(100-errTest);
% %     decodeweights{decode}(:,jj)=svmInfo.Beta; 
% end    
% 
% preError=[];postError=[];
% 
% SEM = std(error{decode})/sqrt(length(error{decode}));               % Standard Error
% ts = tinv([0.025  0.975],length(error{decode})-1);      % T-Score
% interval(1,:) = ts(1)*SEM;
% interval(2,:) = ts(2)*SEM;
% preError(decode,:)=mean(error{decode}(:,5:8),2);
% postError(decode,:)=mean(error{decode}(:,9:12),2);
% pDecode(decode)=signrank(preError(decode,:),postError(decode,:),'tail','left');
% 
% % PLOTTING
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [1 1 10 7];
%     set(fig,'PaperOrientation','landscape');
% set(fig,'renderer','painters');
% ax=nsubplot(1,1,1,1);
% plot(ax,t,eTest(decode,:));
% errorbar(t,eTest(decode,:),interval(1,:),interval(2,:),"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
% hold on;
% plot([-1 +1].*10^10,[50 50],'k','linewidth',2,'xliminclude','off')
% plot([0+PID 0+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor On
% plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor Off
% plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'color',[.8 .8 .8],'linewidth',2,'yliminclude','off') % Side Odor on
% 
% xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% xticks2 = xticks2 + PID;
% xticks(xticks2);
% xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% set(gca, 'XTickLabel', xticklabels2);
% plot([0.075 0.075], ylim, '--r');
% xlim([-0.5+PID 2])
% 
% ylim([0 100])
% xlabel('decoding time (s)')
% ylabel('decoding accuracy')
% hold off;
% title([strjoin(mice,' _ ') ' decoding ' decodeName ' at ' decodeEvent ' p=' num2str(pDecode(decode))]);
% saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_' decodeName '_' decodeEvent]),'pdf');
% 
% %% Water
% i1=50;
% i2=54;
% 
% decodeName='Water';
% decode=2;
% for jj=1:length(i1List)
%     i1 = i1List(jj);
%     i2 = i1+4;
%     xIt=squeeze(mean(xI(:,i1:i2,:),2))'; % mean across time period, trials x cells
%     xRt=squeeze(mean(xR(:,i1:i2,:),2))';
%     xBt=squeeze(mean(xB(:,i1:i2,:),2))';
%     xSt=squeeze(mean(xS(:,i1:i2,:),2))';
% 
%     x1=xBt;
%     x2=xSt;
% 
%     x_size=min([size(x1,1) size(x2,1)]);
%     xx1=randperm(size(x1,1));
%     xx2=randperm(size(x2,1));
%     x1=x1(xx1,:);
%     x2=x2(xx2,:);
%     x1=x1(1:x_size,:);
%     x2=x2(1:x_size,:);    
%     
%     x=cat(1,x1,x2); % all types together
%     nTrial = size(x,1);
%     nOut = round(0.2*nTrial);
%     yI=ones(size(x1,1),1).*1;
%     yR=ones(size(x2,1),1).*-1;
%     y=cat(1,yI,yR);
% 
%     errTest = zeros(nTest,1);
%     for i=1:nTest
%         ip = randperm(nTrial);
%         iTest = ip(1:nOut);
%         iT = randperm(nTrial);
%         xx = x(iT,:);
%         yy = y(iT,:);
%         xTest = xx(iTest,:);
%         yTest = yy(iTest);
%         xx(iTest,:) = [];
%         yy(iTest,:) = [];
%         svmWater = fitclinear(xx,yy);
%         errTest(i)=100*sum((yTest.*(xTest*svmWater.Beta+svmWater.Bias)<0))/nOut;
%         waterWeights(:,i)=svmWater.Beta;
%     end
%     error{decode}(:,jj)=100-errTest;
%     eTest(decode,jj) = mean(100-errTest);
%     decodeweights{decode}(:,jj)=mean(waterWeights,2);
%     
%     if jj==12
% %        waterDecodeIdx = mean(abs(waterWeights),2)./std(abs(waterWeights),0,2);
%         waterDecodeIdx = mean(abs(waterWeights),2);
%     end    
% end
% 
% preError=[];postError=[];
% 
% SEM = std(error{decode})/sqrt(length(error{decode}));               % Standard Error
% ts = tinv([0.025  0.975],length(error{decode})-1);      % T-Score
% interval(1,:) = ts(1)*SEM;
% interval(2,:) = ts(2)*SEM;
% preError(decode,:)=mean(error{decode}(:,5:8),2);
% postError(decode,:)=mean(error{decode}(:,9:12),2);
% pDecode(decode)=signrank(preError(decode,:),postError(decode,:),'tail','left');
% 
% % PLOTTING
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [1 1 10 7];
%     set(fig,'PaperOrientation','landscape');
% set(fig,'renderer','painters');
% ax=nsubplot(1,1,1,1);
% plot(ax,t,eTest(decode,:));
% errorbar(t,eTest(decode,:),interval(1,:),interval(2,:),"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
% hold on;
% plot([-1 +1].*10^10,[50 50],'k','linewidth',2,'xliminclude','off')
% plot([0+PID 0+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor On
% plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor Off
% plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'color',[.8 .8 .8],'linewidth',2,'yliminclude','off') % Side Odor on
% 
% xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% xticks2 = xticks2 + PID;
% xticks(xticks2);
% xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% set(gca, 'XTickLabel', xticklabels2);
% plot([0.075 0.075], ylim, '--r');
% xlim([-0.5+PID 2])
% 
% ylim([40 100])
% xlabel('decoding time (s)')
% ylabel('decoding accuracy')
% hold off;
% title([strjoin(mice,' _ ') ' decoding ' decodeName ' at ' decodeEvent ' p=' num2str(pDecode(decode))]);
% saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_' decodeName '_' decodeEvent]),'pdf');
% 
% 
% %% DECODE INFO WITH WATER DECODER
% 
% decodeName='InfoWater';
% decode=4;
% for jj=1:length(i1List)
%     i1 = i1List(jj);
%     i2 = i1+4;
%     
%     xIt=squeeze(mean(xI(:,i1:i2,:),2))'; % mean across time period, trials x cells
%     xRt=squeeze(mean(xR(:,i1:i2,:),2))';
%     xBt=squeeze(mean(xB(:,i1:i2,:),2))';
%     xSt=squeeze(mean(xS(:,i1:i2,:),2))';
% 
%     x1=xIt;
%     x2=xRt;
% 
%     x_size=min([size(x1,1) size(x2,1)]);
%     xx1=randperm(size(x1,1));
%     xx2=randperm(size(x2,1));
%     x1=x1(xx1,:);
%     x2=x2(xx2,:);
%     x1=x1(1:x_size,:);
%     x2=x2(1:x_size,:);    
%     
%     x=cat(1,x1,x2); % all types together
%     nTrial = size(x,1);
%     nOut = round(0.2*nTrial);
%     yI=ones(size(x1,1),1).*1;
%     yR=ones(size(x2,1),1).*-1;
%     y=cat(1,yI,yR);
% 
%     errTest = zeros(nTest,1);
%     for i=1:nTest
%         ip = randperm(nTrial);
%         iTest = ip(1:nOut);
%         iT = randperm(nTrial);
%         xx = x(iT,:);
%         yy = y(iT,:);
%         xTest = xx(iTest,:);
%         yTest = yy(iTest);
%         xx(iTest,:) = [];
%         yy(iTest,:) = [];
% %         svmInfo = fitclinear(xx,yy);
%         errTest(i)=100*sum((yTest.*(xTest*svmWater.Beta+svmWater.Bias)<0))/nOut;
%     end
%     error{decode}(:,jj)=100-errTest;
%     eTest(decode,jj) = mean(100-errTest);
% %     decodeweights{decode}(:,jj)=svmWater.Beta; 
% end    
% 
% preError=[];postError=[];
% 
% SEM = std(error{decode})/sqrt(length(error{decode}));               % Standard Error
% ts = tinv([0.025  0.975],length(error{decode})-1);      % T-Score
% interval(1,:) = ts(1)*SEM;
% interval(2,:) = ts(2)*SEM;
% preError(decode,:)=mean(error{decode}(:,5:8),2);
% postError(decode,:)=mean(error{decode}(:,9:12),2);
% pDecode(decode)=signrank(preError(decode,:),postError(decode,:),'tail','left');
% 
% % PLOTTING
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [1 1 10 7];
%     set(fig,'PaperOrientation','landscape');
% set(fig,'renderer','painters');
% ax=nsubplot(1,1,1,1);
% plot(ax,t,eTest(decode,:));
% errorbar(t,eTest(decode,:),interval(1,:),interval(2,:),"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
% hold on;
% plot([-1 +1].*10^10,[50 50],'k','linewidth',2,'xliminclude','off')
% plot([0+PID 0+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor On
% plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor Off
% plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'color',[.8 .8 .8],'linewidth',2,'yliminclude','off') % Side Odor on
% 
% xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% xticks2 = xticks2 + PID;
% xticks(xticks2);
% xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% set(gca, 'XTickLabel', xticklabels2);
% plot([0.075 0.075], ylim, '--r');
% xlim([-0.5+PID 2])
% 
% ylim([00 100])
% xlabel('decoding time (s)')
% ylabel('decoding accuracy')
% hold off;
% title([strjoin(mice,' _ ') ' decoding ' decodeName ' at ' decodeEvent ' p=' num2str(pDecode(decode))]);
% saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_' decodeName '_' decodeEvent]),'pdf');
% 
% %%
% 
% a.decodeweights=decodeweights;
% 
% %% DECODING INFO FORCED VS NO INFO FORCED BY MOUSE
% 
% % uses matrix trials x cells
% 
% % PARAMS
% event = 'C_odor1First'; % to decode around first presentation of center odor
% decodeEvent='Center Odor First';
% decode=1;
% decodeName='Info';
% e=3;
% nOut= 20;
% nTest = 100;
% i1List = 1:5:76;
% t=a.t{e}(i1List+2);
% eTest = zeros(length(i1List),1);
% i1=50;
% i2=54;
% 
% for m=1:numel(mice)
% 
% for jj=1:length(i1List)
%     i1 = i1List(jj);
%     i2 = i1+4;
%     % trials x cells
% %     xx_info=cat(3,a.C_odor1FirstInfoForced(a.mouse==m,i1:i2,:),a.C_odor1FirstInfoChoice(a.mouse==m,i1:i2,:));
%     x_info=squeeze(mean(a.C_odor1InfoFirst(a.mouse==m,i1:i2,:),2,'omitnan'))';
%     x_info=x_info(~isnan(x_info(:,1)),:);
%     x_rand=squeeze(mean(a.C_odor1Rand(a.mouse==m,i1:i2,:),2,'omitnan'))';
%     x_rand=x_rand(~isnan(x_rand(:,1)),:);
%     
%     x_size=min([size(x_info,1) size(x_rand,1)]); 
%     xx1=randperm(size(x_info,1));
%     xx2=randperm(size(x_rand,1));
%     x_info=x_info(xx1,:);
%     x_rand=x_rand(xx2,:);
%     x_info=x_info(1:x_size,:);
%     x_rand=x_rand(1:x_size,:);
%     
%     x=[x_info; x_rand];
% 
%     y_info=ones(size(x_info,1),1);
%     y_rand=ones(size(x_rand,1),1)*-1;
%     y=[y_info;y_rand];
% 
%     nTrial = size(x,1);
%     nRand=size(x_rand,1);
%     nOut=round(0.2*nTrial);
%     
%     % set up classifier
%     % cross valiation tests
%     errTest = zeros(nTest,1);
%     for i=1:nTest
%         ii = randperm(nTrial);
%         iTest = ii(1:nOut);
%         iT = randperm(nTrial);
%         xx = x(iT,:);
%         yy = y(iT,:);
%         xTest = xx(iTest,:);
%         yTest = yy(iTest);
%         xx(iTest,:) = [];
%         yy(iTest,:) = [];
%         svmInfoF{m} = fitclinear(xx,yy);
%         errTest(i)=100*sum((yTest.*(xTest*svmInfoF{m}.Beta+svmInfoF{m}.Bias)<0))/nOut;
%     end
%     eTest(jj) = mean(errTest);
%     clear y_info y_rand
% end
% 
% decodeErrorInfoF(m,:)=100-eTest;
% 
% end
% 
% SEM = std(decodeErrorInfoF)/sqrt(length(decodeErrorInfoF));               % Standard Error
% ts = tinv([0.025  0.975],length(decodeErrorInfoF)-1);      % T-Score
% interval(1,:) = ts(1)*SEM;
% interval(2,:) = ts(2)*SEM;
% preError=mean(decodeErrorInfoF(:,5:8),2);
% postError=mean(decodeErrorInfoF(:,9:12),2);
% pDecode=signrank(preError,postError,'tail','left');
% 
% % DECODING PLOT
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [1 1 10 7];
%     set(fig,'PaperOrientation','landscape');
% set(fig,'renderer','painters')
% ax=nsubplot(1,1,1,1);
% for m=1:numel(okMice)
% plot(ax,t,decodeErrorInfoF(m,:),'color','b','linewidth',1,'marker','o','MarkerFaceColor','b');
% end
% plot(ax,t,mean(decodeErrorInfoF),'color','k','linewidth',4,'marker','o','MarkerFaceColor','k');
% errorbar(t,mean(decodeErrorInfoF),interval(1,:),interval(2,:),"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
% hold on;
% plot([-1 +1].*10^10,[50 50],'k','linewidth',2,'xliminclude','off')
% plot([0+PID 0+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor On
% plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor Off
% plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'color',[.8 .8 .8],'linewidth',2,'yliminclude','off') % Side Odor on
% 
% xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% xticks2 = xticks2 + PID;
% xticks(xticks2);
% xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% set(gca, 'XTickLabel', xticklabels2);
% plot([0.075 0.075], ylim, '--r');
% xlim([-0.5+PID 2])
% 
% % ylim([0 100])
% xlabel('decoding time (s)')
% ylabel('decoding error')
% hold off;
% title([strjoin(mice,' _ ') ' decoding Forced Info vs Forced No Info at ' decodeEvent ' p=' num2str(pDecode)]);
% % saveas(fig,fullfile(output_dir,[mice{m},'_',strjoin(days{m}),'_',allconditions,'_decodingPERMOUSE_', decodeName,'_',decodeEvent]),'pdf');        
% saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_INFOBYMOUSE_' decodeEvent]),'pdf');
% 
% 
% %% DECODING WATER VS NO WATER BY MOUSE
% 
% % uses matrix trials x cells
% 
% % PARAMS
% event = 'C_odor1First'; % to decode around first presentation of center odor
% decodeEvent='Center Odor First';
% decode=1;
% decodeName='Water';
% e=3;
% nOut= 20;
% nTest = 100;
% i1List = 1:5:76;
% t=a.t{e}(i1List+2);
% eTest = zeros(length(i1List),1);
% i1=50;
% i2=54;
% 
% for m=1:numel(mice)
% 
% for jj=1:length(i1List)
%     i1 = i1List(jj);
%     i2 = i1+4;
%     % trials x cells
% %     xx_info=cat(3,a.C_odor1FirstInfoForced(a.mouse==m,i1:i2,:),a.C_odor1FirstInfoChoice(a.mouse==m,i1:i2,:));
%     x_info=squeeze(mean(a.C_odor1BigFirst(a.mouse==m,i1:i2,:),2,'omitnan'))';
%     x_info=x_info(~isnan(x_info(:,1)),:);
%     x_rand=squeeze(mean(a.C_odor1Small(a.mouse==m,i1:i2,:),2,'omitnan'))';
%     x_rand=x_rand(~isnan(x_rand(:,1)),:);
%     
%     x_size=min([size(x_info,1) size(x_rand,1)]); 
%     xx1=randperm(size(x_info,1));
%     xx2=randperm(size(x_rand,1));
%     x_info=x_info(xx1,:);
%     x_rand=x_rand(xx2,:);
%     x_info=x_info(1:x_size,:);
%     x_rand=x_rand(1:x_size,:);
%     
%     x=[x_info; x_rand];
% 
%     y_info=ones(size(x_info,1),1);
%     y_rand=ones(size(x_rand,1),1)*-1;
%     y=[y_info;y_rand];
% 
%     nTrial = size(x,1);
%     nRand=size(x_rand,1);
%     nOut=round(0.2*nTrial);
%     
%     % set up classifier
%     % cross valiation tests
%     errTest = zeros(nTest,1);
%     for i=1:nTest
%         ii = randperm(nTrial);
%         iTest = ii(1:nOut);
%         iT = randperm(nTrial);
%         xx = x(iT,:);
%         yy = y(iT,:);
%         xTest = xx(iTest,:);
%         yTest = yy(iTest);
%         xx(iTest,:) = [];
%         yy(iTest,:) = [];
%         svmWaterF{m} = fitclinear(xx,yy);
%         errTest(i)=100*sum((yTest.*(xTest*svmWaterF{m}.Beta+svmWaterF{m}.Bias)<0))/nOut;
%     end
%     eTest(jj) = mean(errTest);
%     clear y_info y_rand
% end
% 
% decodeErrorWaterF(m,:)=100-eTest;
% 
% end
% 
% SEM = std(decodeErrorWaterF)/sqrt(length(decodeErrorWaterF));               % Standard Error
% ts = tinv([0.025  0.975],length(decodeErrorWaterF)-1);      % T-Score
% interval(1,:) = ts(1)*SEM;
% interval(2,:) = ts(2)*SEM;
% preError=mean(decodeErrorWaterF(:,5:8),2);
% postError=mean(decodeErrorWaterF(:,9:12),2);
% pDecode=signrank(preError,postError,'tail','left');
% 
% % DECODING PLOT
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [1 1 10 7];
%     set(fig,'PaperOrientation','landscape');
% set(fig,'renderer','painters')
% ax=nsubplot(1,1,1,1);
% for m=1:numel(okMice)
% plot(ax,t,decodeErrorWaterF(m,:),'color','b','linewidth',1,'marker','o','MarkerFaceColor','b');
% end
% plot(ax,t,mean(decodeErrorWaterF),'color','k','linewidth',4,'marker','o','MarkerFaceColor','k');
% errorbar(t,mean(decodeErrorWaterF),interval(1,:),interval(2,:),"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
% hold on;
% plot([-1 +1].*10^10,[50 50],'k','linewidth',2,'xliminclude','off')
% plot([0+PID 0+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor On
% plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor Off
% plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'color',[.8 .8 .8],'linewidth',2,'yliminclude','off') % Side Odor on
% 
% xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% xticks2 = xticks2 + PID;
% xticks(xticks2);
% xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% set(gca, 'XTickLabel', xticklabels2);
% plot([0.075 0.075], ylim, '--r');
% xlim([-0.5+PID 2])
% 
% % ylim([0 100])
% xlabel('decoding time (s)')
% ylabel('decoding error')
% hold off;
% title([strjoin(mice,' _ ') ' decoding Big Water vs Small Water at ' decodeEvent ' p=' num2str(pDecode)]);
% % saveas(fig,fullfile(output_dir,[mice{m},'_',strjoin(days{m}),'_',allconditions,'_decodingPERMOUSE_', decodeName,'_',decodeEvent]),'pdf');        
% saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_WATERBYMOUSE_' decodeEvent]),'pdf');