%% InfoseekNeuralAnalysis

% Analysis of behavior-aligned neural data for multiple mice across
% multiple sessions, with ROIs registered across sessions within an animal


%% SETUP

clear; close all;

rng('shuffle')

set(0,'DefaultFigureWindowStyle','docked'); % plot in docked window

%% DATA FOLDER

datapath=uigetdir('','Choose data directory');

% plotfolder
if exist(fullfile(datapath,'plots'))
    plotfolder=fullfile(datapath,'plots');
else
    mkdir(fullfile(datapath,'plots'))
    plotfolder=fullfile(datapath,'plots');
end

output_dir = plotfolder;

%% LOAD PARAMS

params=load(fullfile(datapath,'InfoseekNeuroAnalysisParams.mat'));

%% SET SESSIONS TO LOAD

% Main dataset
mice = {'JB413','JB424','JB425','JB426','JB432','JB433','JB434'};
days = {{'20211123','20211124','20211220','20211223'},...
    {'20220210','20220211','20220223','20220224'},...
    {'20220203','20220207','20220217','20220218'},...
    {'20220302','20220303','20220316','20220317'},...
    {'20220526','20220527','20220613','20220614'},...
    {'20220526','20220527','20220608','20220609'},...
    {'20220526','20220527','20220606','20220607'}};
okMice = [1 2 3 4 5 6 7];

alldays={};
for m=1:numel(mice)
    alldays=[alldays days{m}];
end
alldays=strjoin(alldays);

%% PULL IN DATA FOR EACH MOUSE

files=dir('random');
for m=1:numel(mice)
   regfname=dir(fullfile(datapath,[mice{m} '_' num2str(numel(days{m})) 'days*_reg.mat']));
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
    
    c.C_odor1Info = a.C_odor1(:,:,a.imageTrialType==2 & a.imagingPrevCorrect == 1);
    c.C_odor1Rand = a.C_odor1(:,:,a.imageTrialType==3 & a.imagingPrevCorrect == 1);
    c.C_odor1Choice = a.C_odor1(:,:,a.imageTrialType==1 & a.imagingPrevCorrect == 1);
    
    c.C_odor1InfoForced = a.C_odor1(:,:,a.imagingChoice==1 & a.imagingPrevCorrect == 1);
    c.C_odor1InfoChoice = a.C_odor1(:,:,a.imagingChoice==2 & a.imagingPrevCorrect == 1);
    c.C_odor1RandForced = a.C_odor1(:,:,a.imagingChoice==3 & a.imagingPrevCorrect == 1);
    c.C_odor1RandChoice = a.C_odor1(:,:,a.imagingChoice==4 & a.imagingPrevCorrect == 1);

    c.C_odor1allInfo = a.C_odor1All(:,:,a.imageTrialType==2 & a.imagingPrevCorrect == 1);
    c.C_odor1allRand = a.C_odor1All(:,:,a.imageTrialType==3 & a.imagingPrevCorrect == 1);
    c.C_odor1allChoice = a.C_odor1All(:,:,a.imageTrialType==1 & a.imagingPrevCorrect == 1);

    c.C_odor1AllInfoForced = a.C_odor1All(:,:,a.imagingChoice==1 & a.imagingPrevCorrect == 1);
    c.C_odor1AllInfoChoice = a.C_odor1All(:,:,a.imagingChoice==2 & a.imagingPrevCorrect == 1);
    c.C_odor1AllRandForced = a.C_odor1All(:,:,a.imagingChoice==3 & a.imagingPrevCorrect == 1);
    c.C_odor1AllRandChoice = a.C_odor1All(:,:,a.imagingChoice==4 & a.imagingPrevCorrect == 1);

    c.C_odor1First=a.C_odor1First;
    c.C_odor1InfoFirst = a.C_odor1First(:,:,a.imageTrialType==2 & a.imagingPrevCorrect == 1);
    c.C_odor1RandFirst = a.C_odor1First(:,:,a.imageTrialType==3 & a.imagingPrevCorrect == 1);
    c.C_odor1ChoiceFirst = a.C_odor1First(:,:,a.imageTrialType==1 & a.imagingPrevCorrect == 1);

    c.C_odor1FirstInfoForced = a.C_odor1First(:,:,a.imagingChoice==1 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstInfoChoice = a.C_odor1First(:,:,a.imagingChoice==2 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstRandForced = a.C_odor1First(:,:,a.imagingChoice==3 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstRandChoice = a.C_odor1First(:,:,a.imagingChoice==4 & a.imagingPrevCorrect == 1);

    c.C_odor1FirstInfoForcedBig = a.C_odor1First(:,:,a.imagingOutcome == 11 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstInfoForcedSmall = a.C_odor1First(:,:, a.imagingPrevCorrect == 1 & (a.imagingOutcome == 13 | a.imagingOutcome == 14));
    c.C_odor1FirstRandForcedBig = a.C_odor1First(:,:,a.imagingOutcome == 17 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstRandForcedSmall = a.C_odor1First(:,:,a.imagingOutcome == 19 & a.imagingPrevCorrect == 1);

    left = a.infoSide==0 & a.imagingChoice==1 | a.infoSide==0 & a.imagingChoice==2 | a.infoSide==1 & a.imagingChoice==3 | a.infoSide==1 & a.imagingChoice==4; % choice AND forced
    right = a.infoSide==0 & a.imagingChoice==3 | a.infoSide==0 & a.imagingChoice==4 | a.infoSide==1 & a.imagingChoice==1 | a.infoSide==1 & a.imagingChoice==2;
    c.C_odor1FirstLeft = a.C_odor1First(:,:,left==1 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstRight = a.C_odor1First(:,:,right==1 & a.imagingPrevCorrect == 1);
    
    leftForced = a.infoSide==0 & a.imagingChoice==1 |  a.infoSide==1 & a.imagingChoice==3;
    rightForced = a.infoSide==0 & a.imagingChoice==3 | a.infoSide==1 & a.imagingChoice==1;
    c.C_odor1FirstLeftForced = a.C_odor1First(:,:,leftForced==1 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstRightForced = a.C_odor1First(:,:,rightForced==1 & a.imagingPrevCorrect == 1);    

    c.C_odor1FirstInfoLeft=a.C_odor1First(:,:,a.infoSide==0&a.info==1&a.imagingCorr==1 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstInfoRight=a.C_odor1First(:,:,a.infoSide==1&a.info==1&a.imagingCorr==1 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstRandRight=a.C_odor1First(:,:,a.infoSide==0&a.info==0&a.imagingCorr==1 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstRandLeft=a.C_odor1First(:,:,a.infoSide==1&a.info==0&a.imagingCorr==1 & a.imagingPrevCorrect == 1);
    
    c.C_odor1FirstInfoForcedLeft=a.C_odor1First(:,:,a.infoSide==0&a.imagingChoice==1 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstInfoForcedRight=a.C_odor1First(:,:,a.infoSide==1&a.imagingChoice==1 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstRandForcedRight=a.C_odor1First(:,:,a.infoSide==0&a.imagingChoice==3 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstRandForcedLeft=a.C_odor1First(:,:,a.infoSide==1&a.imagingChoice==3 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstInfoChoiceLeft=a.C_odor1First(:,:,a.infoSide==0&a.imagingChoice==2 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstInfoChoiceRight=a.C_odor1First(:,:,a.infoSide==1&a.imagingChoice==2 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstRandChoiceRight=a.C_odor1First(:,:,a.infoSide==0&a.imagingChoice==4 & a.imagingPrevCorrect == 1);
    c.C_odor1FirstRandChoiceLeft=a.C_odor1First(:,:,a.infoSide==1&a.imagingChoice==4 & a.imagingPrevCorrect == 1); 
     
    centerEntryCount=a.centerEntryCount(a.imagingTrials==1);
    c.C_odor1OnlyInfoForced = a.C_odor1(:,:,a.imagingChoice==1 & centerEntryCount==1 & a.imagingPrevCorrect == 1);
    c.C_odor1OnlyInfoChoice = a.C_odor1(:,:,a.imagingChoice==2 & centerEntryCount==1 & a.imagingPrevCorrect == 1);
    c.C_odor1OnlyRandForced = a.C_odor1(:,:,a.imagingChoice==3 & centerEntryCount==1 & a.imagingPrevCorrect == 1);
    c.C_odor1OnlyRandChoice = a.C_odor1(:,:,a.imagingChoice==4 & centerEntryCount==1 & a.imagingPrevCorrect == 1);

    c.C_centerExitInfo = a.C_centerExit(:,:,a.imageTrialType==2 & a.imagingPrevCorrect == 1);
    c.C_centerExitRand = a.C_centerExit(:,:,a.imageTrialType==3 & a.imagingPrevCorrect == 1);
    c.C_centerExitChoice = a.C_centerExit(:,:,a.imageTrialType==1 & a.imagingPrevCorrect == 1);

    c.C_centerExitInfoForced = a.C_centerExit(:,:,a.imagingChoice==1 & a.imagingPrevCorrect == 1);
    c.C_centerExitInfoChoice = a.C_centerExit(:,:,a.imagingChoice==2 & a.imagingPrevCorrect == 1);
    c.C_centerExitRandForced = a.C_centerExit(:,:,a.imagingChoice==3 & a.imagingPrevCorrect == 1);
    c.C_centerExitRandChoice = a.C_centerExit(:,:,a.imagingChoice==4 & a.imagingPrevCorrect == 1);

    c.C_sideEntryInfo = a.C_sideEntry(:,:,a.imageTrialType==2 & a.imagingPrevCorrect == 1);
    c.C_sideEntryRand = a.C_sideEntry(:,:,a.imageTrialType==3 & a.imagingPrevCorrect == 1);
    c.C_sideEntryChoice = a.C_sideEntry(:,:,a.imageTrialType==1 & a.imagingPrevCorrect == 1);

    c.C_sideEntryInfoForced = a.C_sideEntry(:,:,a.imagingChoice==1 & a.imagingPrevCorrect == 1);
    c.C_sideEntryInfoChoice = a.C_sideEntry(:,:,a.imagingChoice==2 & a.imagingPrevCorrect == 1);
    c.C_sideEntryRandForced = a.C_sideEntry(:,:,a.imagingChoice==3 & a.imagingPrevCorrect == 1);
    c.C_sideEntryRandChoice = a.C_sideEntry(:,:,a.imagingChoice==4 & a.imagingPrevCorrect == 1);

    c.C_odor2A = a.C_odor2(:,:,a.imagingOdor2 == 1 & a.imagingPrevCorrect == 1 & a.imagingChoice==1);
    c.C_odor2B = a.C_odor2(:,:,a.imagingOdor2 == 2 & a.imagingPrevCorrect == 1 & a.imagingChoice==1);
    c.C_odor2C = a.C_odor2(:,:,a.imagingOdor2 == 3 & a.imagingPrevCorrect == 1 & a.imagingChoice==3);
    c.C_odor2D = a.C_odor2(:,:,a.imagingOdor2 == 4 & a.imagingPrevCorrect == 1 & a.imagingChoice==3);
    c.C_odor2info = a.C_odor2(:,:,(a.imagingOdor2 == 1 | a.imagingOdor2 == 2) & a.imagingPrevCorrect == 1 & a.imagingChoice==1);
    c.C_odor2rand = a.C_odor2(:,:,(a.imagingOdor2 == 3 | a.imagingOdor2 == 4) & a.imagingPrevCorrect == 1 & a.imagingChoice==3);
    c.C_odor2AC = a.C_odor2(:,:,(a.imagingOdor2 == 1 | a.imagingOdor2 == 3) & a.imagingPrevCorrect == 1 & a.imagingChoice==1);
    c.C_odor2BD = a.C_odor2(:,:,(a.imagingOdor2 == 2 | a.imagingOdor2 == 4) & a.imagingPrevCorrect == 1 & a.imagingChoice==1);

    c.C_odor2BStay = a.C_odor2(:,:,(a.imagingOutcome == 13 | a.imagingOutcome == 4) & a.imagingPrevCorrect == 1);
    c.C_odor2BLeave = a.C_odor2(:,:,(a.imagingOutcome == 14 | a.imagingOutcome == 5) & a.imagingPrevCorrect == 1);

    c.C_sideExitA = a.C_sideExit(:,:,a.imagingOdor2 == 1 & a.imagingPrevCorrect == 1 & a.imagingChoice==1);
    c.C_sideExitB = a.C_sideExit(:,:,a.imagingOdor2 == 2 & a.imagingPrevCorrect == 1 & a.imagingChoice==1);
    c.C_sideExitC = a.C_sideExit(:,:,a.imagingOdor2 == 3 & a.imagingPrevCorrect == 1 & a.imagingChoice==3);
    c.C_sideExitD = a.C_sideExit(:,:,a.imagingOdor2 == 4 & a.imagingPrevCorrect == 1 & a.imagingChoice==3);

    c.C_outcomeInfoBig = a.C_outcome(:,:,a.imagingOutcome == 11 | a.imagingOutcome == 2);
    c.C_outcomeInfoSmall = a.C_outcome(:,:,a.imagingOutcome == 13 | a.imagingOutcome == 4 | a.imagingOutcome == 5 | a.imagingOutcome == 14);
    c.C_outcomeRandBig = a.C_outcome(:,:,a.imagingOutcome == 17 | a.imagingOutcome == 6);
    c.C_outcomeRandSmall = a.C_outcome(:,:,a.imagingOutcome == 19 | a.imagingOutcome == 8);
    c.C_outcomeBig = a.C_outcome(:,:,a.imagingOutcome == 2 | a.imagingOutcome == 6 | a.imagingOutcome == 11| a.imagingOutcome == 17);
    c.C_outcomeSmall = a.C_outcome(:,:,a.imagingOutcome == 4 | a.imagingOutcome == 8 | a.imagingOutcome == 13 | a.imagingOutcome == 14 | a.imagingOutcome == 19 | a.imagingOutcome == 5);

%  UNCOMMENT THIS SECTION TO ANALYZE FULL-TRIAL ACTIVITY. TAKES LARGE AMOUNTS OF MEMORY    
%     c.C_trial=a.C_trial;
%     c.C_trialInfo=a.C_trial(:,:, a.imagingPrevCorrect == 1 & (a.imagingOutcome == 11 | a.imagingOutcome == 13 | a.imagingOutcome == 14));
%     c.C_trialRand=a.C_trial(:,:, a.imagingPrevCorrect == 1 & (a.imagingOutcome == 17 | a.imagingOutcome == 19));
%     c.C_trialInfoForcedBig = a.C_trial(:,:,a.imagingOutcome == 11 & a.imagingPrevCorrect == 1);
%     c.C_trialInfoForcedSmall = a.C_trial(:,:, a.imagingPrevCorrect == 1 & (a.imagingOutcome == 13 | a.imagingOutcome == 14));
%     c.C_trialRandForcedBig = a.C_trial(:,:,a.imagingOutcome == 17 & a.imagingPrevCorrect == 1);
%     c.C_trialRandForcedSmall = a.C_trial(:,:,a.imagingOutcome == 19 & a.imagingPrevCorrect == 1);
%     c.C_trialBig=a.C_trial(:,:, a.imagingPrevCorrect == 1 & (a.imagingOutcome == 2 | a.imagingOutcome == 6 | a.imagingOutcome == 11| a.imagingOutcome == 17));
%     c.C_trialSmall=a.C_trial(:,:, a.imagingPrevCorrect == 1 & (a.imagingOutcome == 4 | a.imagingOutcome == 8 | a.imagingOutcome == 13 | a.imagingOutcome == 14 | a.imagingOutcome == 19 | a.imagingOutcome == 5));
%     
%     c.C_trialLeft=a.C_trial(:,:,(a.infoSide==0 & a.imagingPrevCorrect == 1 & (a.imagingOutcome==11 | a.imagingOutcome==13 | a.imagingOutcome==14)) | (a.infoSide == 1 & a.imagingPrevCorrect == 1& (a.imagingOutcome==17 | a.imagingOutcome==19)));
%     c.C_trialRight=a.C_trial(:,:,(a.infoSide==1 & a.imagingPrevCorrect == 1& (a.imagingOutcome==11 | a.imagingOutcome==13 | a.imagingOutcome==14)) | (a.infoSide == 0 & a.imagingPrevCorrect == 1& (a.imagingOutcome==17 | a.imagingOutcome==19)));
% 
%     c.C_trialInfoPrevInfo = a.C_trial(:,:, (a.imagingPrevOutcome == 11 | a.imagingPrevOutcome == 13 | a.imagingPrevOutcome == 14) & (a.imagingOutcome == 11 | a.imagingOutcome == 13 | a.imagingOutcome == 14));
%     c.C_trialInfoPrevRand = a.C_trial(:,:, (a.imagingPrevOutcome == 17 | a.imagingPrevOutcome == 19) & (a.imagingOutcome == 11 | a.imagingOutcome == 13 | a.imagingOutcome == 14));
%     c.C_trialRandPrevInfo =a.C_trial(:,:, (a.imagingPrevOutcome == 11 | a.imagingPrevOutcome == 13 | a.imagingPrevOutcome == 14) & (a.imagingOutcome == 17 | a.imagingOutcome == 19));
%     c.C_trialRandPrevRand =a.C_trial(:,:, (a.imagingPrevOutcome == 17 | a.imagingPrevOutcome == 19) & (a.imagingOutcome == 17 | a.imagingOutcome == 19));
%     
%     c.C_trialRandForcedC = a.C_trial(:,:,a.imagingOdor2 == 3 & a.imagingChoice==3 & a.imagingPrevCorrect == 1);
%     c.C_trialRandForcedD = a.C_trial(:,:,a.imagingOdor2 == 4 & a.imagingChoice==3 & a.imagingPrevCorrect == 1);

   
    % BASELINES

    % used to limit baseline to appropriate trial types
    % for both a.baseline and a.C_events of appropriate event with a.tpre
    % time just before event on appropriate trials

    c.baseline = cell(numel(c.C_events),1);
    for i = 1:numel(c.C_events)
        c.baseline{i,1}=c.C_events{i};
    end

    c.baselineTypes = cell(4,1); % size of namesfirst, 1 for each event with conditional activity
    c.baselineTypes{1}(a.imagingPrevCorrect == 1,1:4) = 1;
    c.baselineTypes{2}(a.imagingPrevCorrect == 1,1:4) = 1;
    c.baselineTypes{1}(1:sum(a.imagingTrials,1),1:4) = 1; % all trials for center odors
    c.baselineTypes{2}(1:sum(a.imagingTrials,1),1:4) = 1; % all trials for center odors
    c.baselineTypes{3}(1:sum(a.imagingTrials,1),4) = 0; % for side odors
    c.baselineTypes{3}((a.imagingChoice == 1 | a.imagingChoice == 2),1) = 1; %info for info big
    c.baselineTypes{3}((a.imagingChoice == 1 | a.imagingChoice == 2),2) = 1; %info for info small
    c.baselineTypes{3}((a.imagingChoice == 3 | a.imagingChoice == 4),3) = 1; %rand for rand big
    c.baselineTypes{3}((a.imagingChoice == 3 | a.imagingChoice == 4),4) = 1; %rand for rand small
    c.baselineTypes{4}((a.imagingOutcome == 11 | a.imagingOutcome == 2),1) = 1; %info big for info big
    c.baselineTypes{4}((a.imagingOutcome == 13 | a.imagingOutcome == 4 | a.imagingOutcome == 5 | a.imagingOutcome == 14),2) = 1; % info small for info small
    c.baselineTypes{4}((a.imagingChoice == 3 | a.imagingChoice == 4),3) = 1; %rand for rand big
    c.baselineTypes{4}((a.imagingChoice == 3 | a.imagingChoice == 4),4) = 1; % rand for rand small

    a.nameEventsFirst = [9,9,6,7];
    c.baselineCond = cell(4,1);
    for cd = 1:4
       e = a.nameEventsFirst(cd);
       for ci = 1:4
           c.baselineCond{cd}{ci} = c.baseline{e}(:,:,c.baselineTypes{cd}(:,ci)==1);
       end
    end

    c=rmfield(c,'baselineTypes');
    c.day=a.day;
    c.rxn=a.rxn;
    c.imageTrialType=a.imageTrialType;
    c.imagingOutcome=a.imagingOutcome;
    c.imagingChoice=a.imagingChoice;
    c.imagingPrevOutcome=a.imagingPrevOutcome;
    c.imagingPrevCorrect=a.imagingPrevCorrect;
    c.infoSide=a.infoSide;
   
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
                        for ci=1:numel(c.(vars{i}){1})
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
clear z;

a.neuronCt=size(a.C_odor1Info,1);

%% CONDITION NAMES

a.namesFirst = {{'C_odor1FirstInfoLeft','C_odor1FirstInfoRight',...
    'C_odor1FirstRandLeft','C_odor1FirstRandRight'};
    {'C_odor1FirstInfoForced','C_odor1FirstInfoChoice',...
    'C_odor1FirstRandForced','C_odor1FirstRandChoice'};...
    {'C_odor2A','C_odor2B','C_odor2C','C_odor2D'};... 
    {'C_outcomeInfoBig','C_outcomeInfoSmall','C_outcomeRandBig',...
    'C_outcomeRandSmall'};};
a.nameEventsFirst = [9,9,6,7];

% to additionally analyze choice trials separated by right and left
% a.namesFirst = {{'C_odor1FirstInfoForcedLeft','C_odor1FirstInfoForcedRight',...
%     'C_odor1FirstRandForcedLeft','C_odor1FirstRandForcedRight'};
%     {'C_odor1FirstInfoForced','C_odor1FirstInfoChoice',...
%     'C_odor1FirstRandForced','C_odor1FirstRandChoice'};...
%     {'C_odor2A','C_odor2B','C_odor2C','C_odor2D'};... 
%     {'C_outcomeInfoBig','C_outcomeInfoSmall','C_outcomeRandBig',...
%     'C_outcomeRandSmall'};...
%     {'C_odor1FirstInfoChoiceLeft',... %17,18
%     'C_odor1FirstInfoChoiceRight',...
%     'C_odor1FirstRandChoiceLeft',...
%     'C_odor1FirstRandChoiceRight'}};
% a.nameEventsFirst = [9,9,6,7,9];

a.compNamesFirst = {{'C_odor1FirstLeftForced','C_odor1FirstRightForced'};... %1
    {'C_odor1Info','C_odor1Rand'};... %2 % these were forced but not nec. correct, used for earlier data
    {'C_odor2A','C_odor2B'};... %3
    {'C_odor2C','C_odor2D'};... %4
    {'C_odor2info','C_odor2rand'};... %5
    {'C_outcomeInfoBig','C_outcomeInfoSmall'};... %6
    {'C_outcomeRandBig','C_outcomeRandSmall'};... %7
    {'C_odor2B','C_odor2C'};... %8
    {'C_odor2A','C_odor2D'};...
    {'C_odor2AC','C_odor2BD'}}; %10
a.compEventsFirst = [9,9,6,6,6,7,7,6,6,6];

% To include additional comparison of info choice vs. rand forced trials
% (for decoding)
% a.compNamesFirst = {{'C_odor1FirstLeftForced','C_odor1FirstRightForced'};... %1
%     {'C_odor1FirstInfoForced','C_odor1FirstRandForced'};... %2 % these were forced but not nec. correct
%     {'C_odor2A','C_odor2B'};... %3
%     {'C_odor2C','C_odor2D'};... %4
%     {'C_odor2info','C_odor2rand'};... %5
%     {'C_outcomeInfoBig','C_outcomeInfoSmall'};... %6
%     {'C_outcomeRandBig','C_outcomeRandSmall'};... %7
%     {'C_odor2B','C_odor2C'};... %8
%     {'C_odor2A','C_odor2D'};... %9
%     {'C_odor2AC','C_odor2BD'};...%10
%     {'C_odor1FirstInfoChoice','C_odor1FirstRandForced'};... %11
%     {'C_odor1Info','C_odor1Rand'}}; %12
% a.compEventsFirst = [9,9,6,6,6,7,7,6,6,6,9,9];

a.trialCompNames={{'C_trialInfo','C_trialRand'};...
    {'C_trialBig','C_trialSmall'};...
    {'C_trialInfoForcedBig','C_trialInfoForcedSmall'};...
    {'C_trialRandForcedD','C_trialRandForcedC'};...
    {'C_trialRandForcedBig','C_trialRandForcedSmall'};...
    {'C_trialLeft','C_trialRight'}};
a.trialCompEvents=[11,11,11,11,11,11];

%% TIMES

framesAroundEvent = params.intervals./1000*params.Fs;
PID=0.075; % actual measured mean time for odor onset at mouse's nose position after recorded valve opening

% time (in sec relative to event) at each moment in the trial
for e = 1:numel(params.events)
    a.t{e}=((1:2*framesAroundEvent(e))-framesAroundEvent(e))*(1/params.Fs);
    a.okt{e} = params.resp_win(1) <= a.t{e} & a.t{e} <= params.resp_win(2);
    a.tRespEarly{e} = params.earlyResp(1) <= a.t{e} & a.t{e} <= params.earlyResp(2);
    a.tRespLate{e} = params.lateResp(1) <= a.t{e} & a.t{e} <= params.lateResp(2);
    a.tpre{e} = params.pre_win(1) <= a.t{e} & a.t{e} <= params.pre_win(2);
    a.tpreEarly{e} = params.earlyPre(1) <= a.t{e} & a.t{e} <= params.earlyPre(2);
    a.tpreLate{e} = params.latePre(1) <= a.t{e} & a.t{e} <= params.latePre(2);
    a.tpt{e} = a.t{e}+0.075;
end


%% SIGNIFICANCE CUTOFFS

a.pcrit = 0.05; % alpha cutoff
a.ROCcrit = 0.1;
a.maxcrit = 0.2;
a.diffcrit=0.1;
a.minFrames = 5;


%% ACTIVITY BY CONDITION - DO CELLS RESPOND IN A TRIAL CONDITION CONDITION

disp('Calculating conditional responses');

% RESPONSE TO EVENT WITHIN EACH CONDITION (PRE/BASELINE vs POST)

for cd = 1:numel(a.namesFirst)
   cname = a.namesFirst{cd};
   e = a.nameEventsFirst(cd);
   cy = cellfun(@(z) a.(z),cname,'uniform',0);
   t=a.t{e};
   okt=a.okt{e};   
   
   a.C_condBasePostP{cd}=cell(a.neuronCt,numel(cname));

   for ci = 1:numel(cname)
       y = cy{ci};
       if ~isempty(y)
           % mean across time (vals for each trial for each cell)
           ybaseline = squeeze(mean(a.baselineCond{cd}{ci}(:,a.tpre{e},:),2,'omitnan')); 
           ypost = squeeze(mean(y(:,a.okt{e},:),2,'omitnan'));
           % mean across trials act pre/post for each cell
           a.baseAct{cd}{ci} = mean(ybaseline,2,'omitnan'); %cross trials
           a.postAct{cd}{ci} = mean(ypost,2,'omitnan');
           % within condition for each cell compare distributions between pre/post activity (mean for each trial)
           % find maximum value in 1.2s before event on each trial
           [maxval,maxidx]=max(y(:,16:39,:),[],2,'omitnan');
           maxval=squeeze(maxval);maxidx=squeeze(maxidx);
           basetimes=t(okt);
           ybaselineExp=[];
           for i=1:numel(basetimes)
               ybaselineExp(:,i,:)=maxval.*0.5.^((basetimes(i)-t(maxidx+16))/0.4);
           end
           ybaselineExp=squeeze(mean(ybaselineExp,2,'omitnan')); %across time

            % if observed baseline is more than maxcrit above the
            % exponential decay from max, use observed baseline?
           badidx=(ybaseline-ybaselineExp)>a.maxcrit;
           ybase=ybaselineExp;
            ybase(badidx)=ybaseline(badidx); 
           
           for u = 1:a.neuronCt
               if sum(~isnan(ypost(u,:)))>0
              a.C_condBasePostP{cd}{u,ci} = ranksum(ybaseline(u,:),ypost(u,:));
              a.C_condBasePostPExp{cd}{u,ci} = ranksum(ybaselineExp(u,:),ypost(u,:));
              a.C_condBasePostPS{cd}{u,ci} = ranksum(ybase(u,:),ypost(u,:));
               else
                a.C_condBasePostP{cd}{u,ci} = NaN;
                a.C_condBasePostPExp{cd}{u,ci} = NaN;
                a.C_condBasePostPS{cd}{u,ci} = NaN;
               end
           end

           ymean=mean(y,3,'omitnan');
           maxresp = max(ymean(:,a.okt{e}),[],2);
            a.C_condBasePostRSActive{cd}{ci} = cell2mat(a.C_condBasePostP{cd}(:,ci))<a.pcrit&abs(a.postAct{cd}{ci}-a.baseAct{cd}{ci})>a.maxcrit;
            a.C_condBasePostRSActiveExp{cd}{ci} = cell2mat(a.C_condBasePostPS{cd}(:,ci))<a.pcrit&abs(a.postAct{cd}{ci}-a.baseAct{cd}{ci})>a.maxcrit;
            a.C_condBasePostRSActiveExpPos{cd}{ci} = cell2mat(a.C_condBasePostPS{cd}(:,ci))<a.pcrit&a.postAct{cd}{ci}-a.baseAct{cd}{ci}>0.1;
            a.C_condBasePostpercent{cd}{ci} = sum(cell2mat(a.C_condBasePostP{cd}(:,ci))<a.pcrit)/a.neuronCt;
       end
   end
end

%% SHUFFLE ACTIVITY 

disp('Shuffling conditional activity');

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
        
        a.shuffleDiffMean{cd}(j,:)=mean(squeeze(a.shuffleDiff{cd}(:,:,j)));
        a.shuffleDiffPostMean{cd}(j,1)=mean(a.shuffleDiffPost{cd}(:,j));
        a.shuffleDiffPreMean{cd}(j,1)=mean(a.shuffleDiffPre{cd}(:,j));
        
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

%% DIFFERENTIAL ACTIVITY CODING INDICES (PER E.B.-M.)

disp('Calculating index for each event');

for cd = 1:size(a.compNamesFirst)
    cname = a.compNamesFirst{cd};
    e = a.compEventsFirst(cd);
    cy = cellfun(@(z) a.(z),cname,'uniform',0);    
    y1 = cy{1};
    y2 = cy{2};
    
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
    a.activityDifferenceEBM{cd} = (sign(activityDifference1).*activityDifference2+sign(activityDifference2).*activityDifference1).*0.5;
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

%% MOVEMENT (ENTRY AND EXIT OF PORTS)

% infoExit = mean(a.C_centerExitInfoForced,3,'omitnan'); % mean across trials in cond 1
% randExit = mean(a.C_centerExitRandForced,3,'omitnan');
% a.activityTimeDiffCenterExit = abs(infoExit-randExit);
% 
% infoEntry = mean(a.C_sideEntryInfoForced,3,'omitnan');
% randEntry = mean(a.C_sideEntryRandForced,3,'omitnan');
% a.activityTimeDiffSideEntry = abs(infoEntry-randEntry);


y1 = a.C_centerExitInfoForced;
y2 = a.C_centerExitRandForced;

y11=y1(:,:,1:2:end);
y12=y1(:,:,2:2:end);

y21=y2(:,:,1:2:end);
y22=y2(:,:,2:2:end);    

y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
y1mean2 = mean(y12,3,'omitnan');
y2mean1 = mean(y21,3,'omitnan');
y2mean2 = mean(y22,3,'omitnan');

activityDifference1 = y1mean1-y2mean1; % difference on odd trials
activityDifference2 = y1mean2-y2mean2;
a.activityTimeDiffCenterExit = (sign(activityDifference1).*activityDifference2+sign(activityDifference2).*activityDifference1).*0.5;

y1 = a.C_sideEntryInfoForced;
y2 = a.C_sideEntryRandForced;

y11=y1(:,:,1:2:end);
y12=y1(:,:,2:2:end);

y21=y2(:,:,1:2:end);
y22=y2(:,:,2:2:end);    

y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
y1mean2 = mean(y12,3,'omitnan');
y2mean1 = mean(y21,3,'omitnan');
y2mean2 = mean(y22,3,'omitnan');

activityDifference1 = y1mean1-y2mean1; % difference on odd trials
activityDifference2 = y1mean2-y2mean2;
a.activityTimeDiffSideEntry = (sign(activityDifference1).*activityDifference2+sign(activityDifference2).*activityDifference1).*0.5;


%% UNCOMMENT BELOW TO ANALYZE FULL-TRIAL ACTIVITY. TAKES LARGE AMOUNTS OF MEMORY

% clear cy yy y1 yy1 y2 yy2 y11 y12 y y21 y22 s1 y1shuffle s2 y2shuffle...
%     timeBaseline randActivity shuffleDiff badidx maxidx y1mean y2mean...
%     y1meanPost y1meanPre y2meanPost y2meanPre Activity_1 Activity_2 shuffle...
%     cy y1mean1 y1mean2 y2mean1 y2mean2 activityDifference1 activityDifference2...
%     activityDifferenceTrial1 activityDifferenceTrial2 maxval ybase...
%     ybaseline ybaselineExp ypost ymean randActivity
% 

% % SHUFFLE FULL TRIAL ACTIVITY
% 
% disp('Shuffle full trial');
% 
% mouseCells=histc(a.mouse(:),unique(a.mouse));
% mouseCellCts=[0; cumsum(mouseCells)];
% 
% for cd = 1:size(a.trialCompNames)
%     cname = a.trialCompNames{cd};
%     e = a.trialCompEvents(cd);
%     cy = cellfun(@(z) a.(z),cname,'uniform',0);    
%     y1 = cy{1}; % all mice all activity for condition 1
%     y2 = cy{2};
%     n1=sum(~isnan(y1(cumsum(mouseCells),1,:)),3); % number of non-NaN trials per mouse
%     n2=sum(~isnan(y2(cumsum(mouseCells),1,:)),3);
%     clear ii;
%     for m=1:numel(mice)
%         yy1{m}=y1(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:n1(m)); % that mouse's activity (noNaN) for condition 1
%         yy2{m}=y2(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:n2(m));
%         yy{m}=cat(3,yy1{m},yy2{m}); % stack condition 1 and condition 2 for that mouse
%         ii{m}(1:n1(m),1)=1; % label for condition 1 trials for that mouse
%         ii{m}(n1(m)+1:n1(m)+n2(m),1)=2; % label for condition 2 trials for that mouse       
%     end
%     
%     clear yy1 yy2 y1 y2 cy
%     
%     for j=1:1000
%         for m=1:numel(mice) 
%             shuffle = ii{m}(randperm(size(ii{m},1))'); % shuffle whether trials are condition 1 or condition 2
%             y1shuffle=yy{m}(:,:,shuffle==1); % take a random subset to be condition 1 of condition 1 size
%             s1=NaN(size(y1shuffle,1),size(y1shuffle,2),max(n1)); % fill with NaN for matched size
%             s1(:,:,1:size(y1shuffle,3))=y1shuffle;
%             y2shuffle=yy{m}(:,:,shuffle==2);
%             s2=NaN(size(y2shuffle,1),size(y2shuffle,2),max(n2));
%             s2(:,:,1:size(y2shuffle,3))=y2shuffle;
%             if m==1 % concatenate mice back together
%                y1=s1;
%                y2=s2;
%             else
%                 y1=cat(1,y1,s1);
%                 y2=cat(1,y2,s2);
%             end
%         end
%         
%         clear s1 s2 y1shuffle y2shuffle
%         
%         y1mean = mean(y1,3,'omitnan'); % mean across trials in cond 1
%         y2mean = mean(y2,3,'omitnan');        
%         a.shuffleDiffTrial{cd}(:,:,j)=abs(y1mean-y2mean);
%         clear y1mean y2mean
%         
%         y11=y1(:,:,1:2:end);
%         y12=y1(:,:,2:2:end);
% 
%         y21=y2(:,:,1:2:end);
%         y22=y2(:,:,2:2:end);
%         
%         clear y1 y2
%         
%         y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
%         y1mean2 = mean(y12,3,'omitnan');
%         y2mean1 = mean(y21,3,'omitnan');
%         y2mean2 = mean(y22,3,'omitnan');
%         
%         clear y11 y12 y21 y22
%         
%         activityDifferenceTrial1 = y1mean1-y2mean1;
%         activityDifferenceTrial2 = y1mean2-y2mean2;
%         
%         clear y1mean1 y1mean2 y2mean1 y2mean2       
%         
%         a.activityDifferenceTrialEBMShuffle{cd}(:,:,j) = (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;
%         
%         clear activityDifferenceTrial1 activityDifferenceTrial2
%         
%     end
% end
% 
% % ACTIVITY BETWEEN CONDITIONS (DIFFERENTIAL) - WHOLE TRIAL
% 
% disp('Calculating whole-trial activity difference');
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
%     if ~isempty(y1) && ~isempty(y2)   
% 
%         % DIFFERENCE AND ABSOLUTE DIFFERENCE
%         a.activityTimeDiffTrial{cd} = y1mean-y2mean;
%         a.absActivityTimeDiffTrial{cd} = abs(y1mean-y2mean);
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
%         end
% %         a.pcellsRSTrial{cd,:} = sum(a.RSpvalsTrial{cd,1}<a.pcrit&a.absActivityPostDiffTrial{cd}>a.diffcrit)/a.neuronCt;
%             % MEAN ROCS   
% 
%     % mean ROC for pop over time
%     
%     else
%         a.activityTimeDiffTrial{cd} = NaN;
%         a.absActivityTimeDiffTrial{cd} = NaN;
%         a.RSpvalsTrial{cd,1} = NaN(a.neuronCt,80);
%         a.pcellsRSTrial{cd,:} = NaN;
%     end
% 
% end
% 
% % WHOLE TRIAL ACTIVITY DIFFERENCES
% 
% disp('Calculating whole-trial indices');
% 
% for cd = 1:size(a.trialCompNames)
%     cname = a.trialCompNames{cd};
%     e = a.trialCompEvents(cd);
%     cy = cellfun(@(z) a.(z),cname,'uniform',0);    
%     y1 = cy{1};
%     y2 = cy{2};
%     
%     clear cy;
%     
%     y11=y1(:,:,1:2:end);
%     y12=y1(:,:,2:2:end);
%     
%     y21=y2(:,:,1:2:end);
%     y22=y2(:,:,2:2:end);    
%     
%     y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
%     y1mean2 = mean(y12,3,'omitnan');
%     y2mean1 = mean(y21,3,'omitnan');
%     y2mean2 = mean(y22,3,'omitnan');
%     
%     activityDifferenceTrial1 = y1mean1-y2mean1;
%     activityDifferenceTrial2 = y1mean2-y2mean2;
%     a.activityDifferenceTrialEBM{cd} = (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;
%     
%     for t=1:size(activityDifferenceTrial1,2)
%         a.activityDifferenceTrialEBMSig{cd}(:,t) = signrank(a.activityDifferenceTrialEBM{cd}(:,t));
%     end
% end






