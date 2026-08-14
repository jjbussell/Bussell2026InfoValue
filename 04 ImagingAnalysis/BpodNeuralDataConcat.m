%% InfoseekNeuralAnalysis

%


%% TO PULL MULTI- or SINGLE-MOUSE, MULTI-SESSION DATA IN AND ANALYZE

clear all; close all;

rng('shuffle')

set(0,'DefaultFigureWindowStyle','docked'); % plot in docked window

%% DATA FOLDER

datapath=uigetdir('','Choose data directory');
% datapath = 'D:\Bussell Dropbox\Jennifer Bussell\BpodInfoseek\Analysis\CombinedPipeline';

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

%% LOAD DATASET INFO (SESSION TABLE)
% load(fullfile(datapath,['BpodInfoseekSessions_',params.dataset{1},'.mat']));

%% SET SESSIONS TO LOAD

% mice = {'JB413','JB426'};
% days = {{'20211123','20211124','20211220','20211223'},{'20220302','20220303','20220316','20220317'}};
% okMice=[1 2];
mice = {'JB413','JB424','JB425','JB426','JB432','JB433','JB434'};
days = {{'20211123','20211124','20211220','20211223'},...
    {'20220210','20220211','20220223','20220224'},...
    {'20220203','20220207','20220217','20220218'},...
    {'20220302','20220303','20220316','20220317'},...
    {'20220526','20220527','20220613','20220614'},...
    {'20220526','20220527','20220608','20220609'},...
    {'20220526','20220527','20220606','20220607'}};
okMice = [1 2 3 4 5 6 7];
% mice = {'JB426'};
% days = {{'20220302','20220303','20220316','20220317'},{1}};
% 
% mice = {'JB506','JB507'};
% days = {{'20241122','20241125','20241205','20241206'},{'20241122','20241125','20241205','20241206'},{1}};
% okMice=[1 2];

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
    
%     preCIB=a.imagingPrevOutcome==2;
%     preCIS=a.imagingPrevOutcome==4|5;
%     preCNB=a.imagingPrevOutcome==6;
%     preCNS=a.imagingPrevOutcome==8|9;
% 
%     c.C_odor1preCIB{1}=a.C_odor1First(:,:,preCIB&a.imagingChoice==1);
%     c.C_odor1preCIB{2}=a.C_odor1First(:,:,preCIB&a.imagingChoice==2);
%     c.C_odor1preCIB{3}=a.C_odor1First(:,:,preCIB&a.imagingChoice==3);
%     c.C_odor1preCIB{4}=a.C_odor1First(:,:,preCIB&a.imagingChoice==4);
%     c.C_odor1preCIS{1}=a.C_odor1First(:,:,preCIS&a.imagingChoice==1);
%     c.C_odor1preCIS{2}=a.C_odor1First(:,:,preCIS&a.imagingChoice==2);
%     c.C_odor1preCIS{3}=a.C_odor1First(:,:,preCIS&a.imagingChoice==3);
%     c.C_odor1preCIS{4}=a.C_odor1First(:,:,preCIS&a.imagingChoice==4);
%     c.C_odor1preCNB{1}=a.C_odor1First(:,:,preCNB&a.imagingChoice==1);
%     c.C_odor1preCNB{2}=a.C_odor1First(:,:,preCNB&a.imagingChoice==2);
%     c.C_odor1preCNB{3}=a.C_odor1First(:,:,preCNB&a.imagingChoice==3);
%     c.C_odor1preCNB{4}=a.C_odor1First(:,:,preCNB&a.imagingChoice==4);
%     c.C_odor1preCNS{1}=a.C_odor1First(:,:,preCNS&a.imagingChoice==1);
%     c.C_odor1preCNS{2}=a.C_odor1First(:,:,preCNS&a.imagingChoice==2);
%     c.C_odor1preCNS{3}=a.C_odor1First(:,:,preCNS&a.imagingChoice==3);
%     c.C_odor1preCNS{4}=a.C_odor1First(:,:,preCNS&a.imagingChoice==4);     
     
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

    
    c.C_trial=a.C_trial;
    c.C_trialInfo=a.C_trial(:,:, a.imagingPrevCorrect == 1 & (a.imagingOutcome == 11 | a.imagingOutcome == 13 | a.imagingOutcome == 14));
    c.C_trialRand=a.C_trial(:,:, a.imagingPrevCorrect == 1 & (a.imagingOutcome == 17 | a.imagingOutcome == 19));
    c.C_trialInfoForcedBig = a.C_trial(:,:,a.imagingOutcome == 11 & a.imagingPrevCorrect == 1);
    c.C_trialInfoForcedSmall = a.C_trial(:,:, a.imagingPrevCorrect == 1 & (a.imagingOutcome == 13 | a.imagingOutcome == 14));
    c.C_trialRandForcedBig = a.C_trial(:,:,a.imagingOutcome == 17 & a.imagingPrevCorrect == 1);
    c.C_trialRandForcedSmall = a.C_trial(:,:,a.imagingOutcome == 19 & a.imagingPrevCorrect == 1);
    c.C_trialBig=a.C_trial(:,:, a.imagingPrevCorrect == 1 & (a.imagingOutcome == 2 | a.imagingOutcome == 6 | a.imagingOutcome == 11| a.imagingOutcome == 17));
    c.C_trialSmall=a.C_trial(:,:, a.imagingPrevCorrect == 1 & (a.imagingOutcome == 4 | a.imagingOutcome == 8 | a.imagingOutcome == 13 | a.imagingOutcome == 14 | a.imagingOutcome == 19 | a.imagingOutcome == 5));
    
    c.C_trialLeft=a.C_trial(:,:,(a.infoSide==0 & a.imagingPrevCorrect == 1 & (a.imagingOutcome==11 | a.imagingOutcome==13 | a.imagingOutcome==14)) | (a.infoSide == 1 & a.imagingPrevCorrect == 1& (a.imagingOutcome==17 | a.imagingOutcome==19)));
    c.C_trialRight=a.C_trial(:,:,(a.infoSide==1 & a.imagingPrevCorrect == 1& (a.imagingOutcome==11 | a.imagingOutcome==13 | a.imagingOutcome==14)) | (a.infoSide == 0 & a.imagingPrevCorrect == 1& (a.imagingOutcome==17 | a.imagingOutcome==19)));

    c.C_trialInfoPrevInfo = a.C_trial(:,:, (a.imagingPrevOutcome == 11 | a.imagingPrevOutcome == 13 | a.imagingPrevOutcome == 14) & (a.imagingOutcome == 11 | a.imagingOutcome == 13 | a.imagingOutcome == 14));
    c.C_trialInfoPrevRand = a.C_trial(:,:, (a.imagingPrevOutcome == 17 | a.imagingPrevOutcome == 19) & (a.imagingOutcome == 11 | a.imagingOutcome == 13 | a.imagingOutcome == 14));
    c.C_trialRandPrevInfo =a.C_trial(:,:, (a.imagingPrevOutcome == 11 | a.imagingPrevOutcome == 13 | a.imagingPrevOutcome == 14) & (a.imagingOutcome == 17 | a.imagingOutcome == 19));
    c.C_trialRandPrevRand =a.C_trial(:,:, (a.imagingPrevOutcome == 17 | a.imagingPrevOutcome == 19) & (a.imagingOutcome == 17 | a.imagingOutcome == 19));
    
%     c.C_trialInfoForcedBigLeft = a.C_trial(:,:,a.imagingOutcome == 11&a.infoSide==0);
%     c.C_trialInfoForcedSmallLeft = a.C_trial(:,:,a.infoSide==0& a.imagingOutcome == 13 | a.imagingOutcome == 14);
%     c.C_trialRandForcedBigLeft = a.C_trial(:,:,a.imagingOutcome == 17&a.infoSide==1);
%     c.C_trialRandForcedSmallLeft = a.C_trial(:,:,a.imagingOutcome == 19&a.infoSide==1);
%     c.C_trialInfoForcedBigRight = a.C_trial(:,:,a.imagingOutcome == 11&a.infoSide==1);
%     c.C_trialInfoForcedSmallRight = a.C_trial(:,:,a.infoSide==1& a.imagingOutcome == 13 | a.imagingOutcome == 14);
%     c.C_trialRandForcedBigRight = a.C_trial(:,:,a.imagingOutcome == 17&a.infoSide==0);
%     c.C_trialRandForcedSmallRight = a.C_trial(:,:,a.imagingOutcome == 19&a.infoSide==0); 
    
    c.C_trialRandForcedC = a.C_trial(:,:,a.imagingOdor2 == 3 & a.imagingChoice==3 & a.imagingPrevCorrect == 1);
    c.C_trialRandForcedD = a.C_trial(:,:,a.imagingOdor2 == 4 & a.imagingChoice==3 & a.imagingPrevCorrect == 1);

%     c.C_trialInfoChoiceBig = a.C_trial(:,:,a.imagingOutcome == 2);
%     c.C_trialInfoChoiceSmall = a.C_trial(:,:,a.imagingOutcome == 4 | a.imagingOutcome == 5);
%     c.C_trialRandChoiceBig = a.C_trial(:,:,a.imagingOutcome == 6);
%     c.C_trialRandChoiceSmall = a.C_trial(:,:,a.imagingOutcome == 8);

%     c.C_InfoForcedBig = a.C_odor1(:,:,a.imagingOutcome == 11);
%     c.C_InfoForcedSmall = a.C_odor1(:,:,a.imagingOutcome == 13 | a.imagingOutcome == 14);
%     c.C_RandForcedBig = a.C_odor1(:,:,a.imagingOutcome == 17);
%     c.C_RandForcedSmall = a.C_odor1(:,:,a.imagingOutcome == 19);
% 
%     c.C_InfoChoiceBig = a.C_odor1(:,:,a.imagingOutcome == 2);
%     c.C_InfoChoiceSmall = a.C_odor1(:,:,a.imagingOutcome == 4 | a.imagingOutcome == 5);
%     c.C_RandChoiceBig = a.C_odor1(:,:,a.imagingOutcome == 6);
%     c.C_RandChoiceSmall = a.C_odor1(:,:,a.imagingOutcome == 8);
    
    % BASELINES

    % used to limit baseline to appropriate trial types
    % for both a.baseline and a.C_events of appropriate event with a.tpre
    % time just before event on appropriate trials OR

    c.baseline = cell(numel(c.C_events),1);
    for i = 1:numel(c.C_events)
        c.baseline{i,1}=c.C_events{i};
    end
%     c.baseline{6,1}=a.C_odor2;
%     c.baseline{11,1}=a.C_trial;
%     c.baseline{12,1}=a.C_odor2;
%     c.baseline{7,1}=a.C_outcome;

    c.baselineTypes = cell(4,1); % size of namesfirst, 1 for each event with conditional activity
    c.baselineTypes{1}(a.imagingPrevCorrect == 1,1:4) = 1;
    c.baselineTypes{2}(a.imagingPrevCorrect == 1,1:4) = 1;
%     c.baselineTypes{1}(1:sum(a.imagingTrials,1),1:4) = 1; % all trials for center odors
%     c.baselineTypes{2}(1:sum(a.imagingTrials,1),1:4) = 1; % all trials for center odors
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

%     c.compBaselineTypes = cell(8,1); % size of compNamesFirst, 1 for each comparison of differential activity on those different trials, during the baseline period
%     for i = 1:8
%         c.compBaselineTypes{i}=zeros(sum(a.imagingTrials==1),2);
%     end
%     c.compBaselineTypes{1}(a.infoSide==0&a.info==1&a.imagingCorr==1&a.imageTrialType==2,1) = 1; % info left
%     c.compBaselineTypes{1}(a.infoSide==0&a.info==0&a.imagingCorr==1&a.imageTrialType==3,2) = 1; % rand left
%     c.compBaselineTypes{2}(a.infoSide==1&a.info==1&a.imagingCorr==1&a.imageTrialType==2,1) = 1; % info right
%     c.compBaselineTypes{2}(a.infoSide==1&a.info==0&a.imagingCorr==1&a.imageTrialType==3,2) = 1; % rand right
%     c.compBaselineTypes{3}(a.imagingChoice == 1 | a.imagingChoice == 2,1) = 1; % info
%     c.compBaselineTypes{3}(a.imagingChoice == 3 | a.imagingChoice == 4,2) = 1; % rand
%     c.compBaselineTypes{4}(a.imagingOdor2 == 1,1) = 1; % info big
%     c.compBaselineTypes{4}(a.imagingOdor2 == 2,2) = 1;
%     c.compBaselineTypes{5}(a.imagingOdor2 == 3,1) = 1;
%     c.compBaselineTypes{5}(a.imagingOdor2 == 4,2) = 1;% rand C
%     c.compBaselineTypes{6}(a.imagingChoice == 1 | a.imagingChoice == 2,1) = 1; % info
%     c.compBaselineTypes{6}(a.imagingChoice == 3 | a.imagingChoice == 4,2) = 1; % rand
%     c.compBaselineTypes{7}(a.imagingOutcome == 11 | a.imagingOutcome == 2,1) = 1; % info big
%     c.compBaselineTypes{7}(a.imagingOutcome == 13 | a.imagingOutcome == 4 | a.imagingOutcome == 5 | a.imagingOutcome == 14,2) = 1;
%     c.compBaselineTypes{8}(a.imagingOutcome == 17 | a.imagingOutcome == 6,1) = 1; % rand for rand outcomes
%     c.compBaselineTypes{8}(a.imagingOutcome == 19 | a.imagingOutcome == 8,2) = 1; % rand for rand outcomes
% 
%     a.compEventsFirst = [9,9,9,6,6,6,7,7];
%     for cd = 1:8
%         e = a.compEventsFirst(cd);
%         for i = 1:2
%             c.baselineComp{cd,1} = c.baseline{e}(:,:,c.compBaselineTypes{cd}(:,1)==1);
%         end
%     end
    
    c=rmfield(c,'baselineTypes');
%     c=rmfield(c,'compBaselineTypes');
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

%% CONDITION NAMES - put in params

a.namesFirst = {{'C_odor1FirstInfoLeft','C_odor1FirstInfoRight',...
    'C_odor1FirstRandLeft','C_odor1FirstRandRight'};
    {'C_odor1FirstInfoForced','C_odor1FirstInfoChoice',...
    'C_odor1FirstRandForced','C_odor1FirstRandChoice'};...
    {'C_odor2A','C_odor2B','C_odor2C','C_odor2D'};... 
    {'C_outcomeInfoBig','C_outcomeInfoSmall','C_outcomeRandBig',...
    'C_outcomeRandSmall'};};
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
a.nameEventsFirst = [9,9,6,7];
a.compNamesFirst = {{'C_odor1FirstLeftForced','C_odor1FirstRightForced'};... %1
    {'C_odor1FirstInfoForced','C_odor1FirstRandForced'};... %2 % these were forced but not nec. correct
    {'C_odor2A','C_odor2B'};... %3
    {'C_odor2C','C_odor2D'};... %4
    {'C_odor2info','C_odor2rand'};... %5
    {'C_outcomeInfoBig','C_outcomeInfoSmall'};... %6
    {'C_outcomeRandBig','C_outcomeRandSmall'};... %7
    {'C_odor2B','C_odor2C'};... %8
    {'C_odor2A','C_odor2D'};... %9
    {'C_odor2AC','C_odor2BD'};...%10
    {'C_odor1FirstInfoChoice','C_odor1FirstRandForced'};... %11
    {'C_odor1Info','C_odor1Rand'}}; %12
% a.compNamesFirst = {{'C_odor1FirstLeftForced','C_odor1FirstRightForced'};... %1
%     {'C_odor1Info','C_odor1Rand'};... %2 % these were forced but not nec. correct, used for earlier data
%     {'C_odor2A','C_odor2B'};... %3
%     {'C_odor2C','C_odor2D'};... %4
%     {'C_odor2info','C_odor2rand'};... %5
%     {'C_outcomeInfoBig','C_outcomeInfoSmall'};... %6
%     {'C_outcomeRandBig','C_outcomeRandSmall'};... %7
%     {'C_odor2B','C_odor2C'};... %8
%     {'C_odor2A','C_odor2D'};...
%     {'C_odor2AC','C_odor2BD'}}; %10
% a.compEventsFirst = [9,9,6,6,6,7,7,6,6,6];
a.compEventsFirst = [9,9,6,6,6,7,7,6,6,6,9,9];

a.trialCompNames={{'C_trialInfo','C_trialRand'};...
    {'C_trialBig','C_trialSmall'};...
    {'C_trialInfoForcedBig','C_trialInfoForcedSmall'};...
    {'C_trialRandForcedD','C_trialRandForcedC'};...
    {'C_trialRandForcedBig','C_trialRandForcedSmall'};...
    {'C_trialLeft','C_trialRight'}};
a.trialCompEvents=[11,11,11,11,11,11];

a.grey = [.8 .8 .8];
a.purple = [121 32 196] ./ 255;
a.lightPurple = [204 204 255] ./ 255;
a.orange = [251 139 6] ./ 255;
a.lightOrange = [255 204 153] ./ 255;
a.cornflower = [100 149 237] ./ 255;
a.teal = [0 128 128] ./ 255;
a.darkcyan = [0 139 139] ./ 255;

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
    a.tpt{e} = a.t{e}+0.075;
end

%% ACTIVITY BY EVENT
% RANKSUM and ROC for each cell for mean response pre and post within each event

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

%% CONDITIONAL RESPONSE OVER TIME (PER FRAME)
% disp('Calculating rank-sum for each condition vs baseline over time');
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
            % if observed baseline is more than maxcrit above the
            % exponential decay from max, use observed baseline?
            badidx=(ybaseline-ybaselineExp)>a.maxcrit;
           ybase=ybaselineExp;
%            ybase(badidx,:)=ybaseline(badidx,:);
            ybase(badidx)=ybaseline(badidx); 
           
           for u = 1:a.neuronCt
               if sum(~isnan(ypost(u,:)))>0
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
               else
                a.C_condBasePostP{cd}{u,ci} = NaN;
                a.C_condBasePostPExp{cd}{u,ci} = NaN;
                a.C_condBasePostPS{cd}{u,ci} = NaN;
               end
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

%% ACTIVITY BETWEEN CONDITIONS (DIFFERENTIAL) - DIFFERENT BETWEEN CONDITIONS
% 
% disp('Calculating differential responses (ROCs)');
% 
% % RESPONSE ACROSS CONDITIONS MEAN AND OVER TIME
% 
% %  population ROC (distrib of avg cell response to condition)
% 
% 
% for cd = 1:size(a.compNamesFirst)
%     cname = a.compNamesFirst{cd};
%     e = a.compEventsFirst(cd);
%     cy = cellfun(@(z) a.(z),cname,'uniform',0);    
%     y1 = cy{1};
%     y2 = cy{2};
%     
%     y1mean = mean(y1,3,'omitnan'); % mean across trials in cond 1
%     y2mean = mean(y2,3,'omitnan');
%     
%     y1meanPost = mean(y1mean(:,a.okt{e}),2,'omitnan');
%     y1meanPre = mean(y1mean(:,a.tpre{e}),2,'omitnan');
%     y2meanPost = mean(y2mean(:,a.okt{e}),2,'omitnan');
%     y2meanPre = mean(y2mean(:,a.tpre{e}),2,'omitnan');
%     
%     if ~isempty(y1) & ~isempty(y2)
%     
%         % ROC and pval that population differentiates conditions across time
% %         [a.rocsPop{cd,1},a.ROCPopPvals{cd,1}] = rocarea3(y2mean,y1mean);
% 
%         % ROC and pval that population differentiates conditions
% %         [a.rocPopPost{cd,1},a.rocPopPostpval{cd,1}] = rocarea3(y2meanPost,y1meanPost);
% %         [a.rocPopPre{cd,1},a.rocPopPrepval{cd,1}] = rocarea3(y2meanPre,y1meanPre);    
% 
%         % DIFFERENCE AND ABSOLUTE DIFFERENCE
%         a.activityTimeDiff{cd} = y1mean-y2mean;
%         a.absActivityTimeDiff{cd} = abs(y1mean-y2mean);
%         a.activityPostDiff{cd} = y1meanPost-y2meanPost;
%         a.absActivityPostDiff{cd} = abs(y1meanPost-y2meanPost);
%         a.activityPreDiff{cd} = y1meanPre-y2meanPre;
%         a.absActivityPreDiff{cd} = abs(y1meanPre-y2meanPre);
%         a.absActivityPopDiff{cd} = mean(a.absActivityTimeDiff{cd});
%         
%         for t=1:size(y1mean,2)
%             a.popSR{cd}(1,t)=signrank(y1mean(:,t),y2mean(:,t));
%         end
%         
%         % ARE THESE CORRECT?
%         a.pNeuronsPost{cd} = zeros(a.neuronCt,1);
%         a.pNeuronsPre{cd} = zeros(a.neuronCt,1);
%         a.pNeuronsTime{cd} = zeros(a.neuronCt,size(a.absActivityTimeDiff{cd},2));
%         for i=1:a.neuronCt
%             a.pNeuronsPost{cd}(i) = 100*sum((a.shuffleDiffPost{cd}(:)>a.absActivityPostDiff{cd}(i))) ...
%                 /length(a.shuffleDiffPost{cd}(:));
%             a.pNeuronsPre{cd}(i) = 100*sum((a.shuffleDiffPre{cd}(:)>a.absActivityPreDiff{cd}(i))) ...
%                 /length(a.shuffleDiffPre{cd}(:));            
%             for t=1:size(a.absActivityTimeDiff{cd},2)
%                 randActivity =squeeze(a.shuffleDiff{cd}(:,t,:))';
%                 a.pNeuronsTime{cd}(i,t) = 100*sum((randActivity(:)>a.absActivityTimeDiff{cd}(i,t))) ...
%                     /length(randActivity(:));                
%             end
%         end
%         a.nSigPost{cd}=sum(a.pNeuronsPost{cd}<(a.pcrit*100)&a.absActivityPostDiff{cd}>a.diffcrit)/a.neuronCt;
%         a.nSigPre{cd}=sum(a.pNeuronsPre{cd}<(a.pcrit*100)&a.absActivityPreDiff{cd}>a.diffcrit)/a.neuronCt;
%         a.nSigTime{cd}=sum(a.pNeuronsTime{cd}<(a.pcrit*100)&a.absActivityTimeDiff{cd}>a.diffcrit)/a.neuronCt;
%         
%         a.absActDiffPopSig{cd} = sum(a.shuffleDiffMean{cd}>a.absActivityPopDiff{cd})/size(a.shuffleDiffMean{cd},1);
%         a.absActDiffPrePopSig{cd} = sum(a.shuffleDiffPreMean{cd}>mean(a.absActivityPreDiff{cd}))/size(a.shuffleDiffPreMean{cd},1);
%         a.absActDiffPostPopSig{cd} = sum(a.shuffleDiffPostMean{cd}>mean(a.absActivityPostDiff{cd}))/size(a.shuffleDiffPostMean{cd},1);
% 
%         % RANK-SUM & ROCs between conditions
%         for u = 1:a.neuronCt
%             Activity_1 = squeeze(cy{1}(u,:,:))';
%             Activity_2 = squeeze(cy{2}(u,:,:))';
% %             Baseline_1 = squeeze(a.baselineComp{cd}(u,a.tpre{e},:))';
% %             Baseline_2 = squeeze(a.baselineComp{cd}(u,a.tpre{e},:))';
% 
%             % rank-sum p-val that cell differentiates conditions across time
%             for t = 1:size(Activity_1,2)
%                a.RSpvals{cd,1}(u,t) = ranksum(Activity_1(:,t),Activity_2(:,t));
%             end
% 
%             a.RSpvalsmean{cd,1}(u,1) = ranksum(mean(Activity_2(:,a.okt{e}),2,'omitnan'),mean(Activity_1(:,a.okt{e}),2,'omitnan'));
%             a.RSpvalsmeanPre{cd,1}(u,1) = ranksum(mean(Activity_2(:,a.tpre{e}),2,'omitnan'),mean(Activity_1(:,a.tpre{e}),2,'omitnan'));
% %             a.RSpvalsmeanBase{cd,1}(u,1) = ranksum(mean(Baseline_2,2,'omitnan'),mean(Baseline_1,2,'omitnan'));
% 
%             % ROC and pval that cell differentiates conditions across time
% %             [a.rocs{cd,1}(u,:),a.ROCpvals{cd,1}(u,:)] = rocarea3(Activity_2,Activity_1);
%             
%             % ROC and pval that cell differentiates conditions pre and post
%             % event (mean response)
% %             [a.rocsmean{cd,1}(u,1),a.ROCpvalsmean{cd,1}(u,1)] = rocarea3(mean(Activity_2(:,a.okt{e}),2,'omitnan'),mean(Activity_1(:,a.okt{e}),2,'omitnan'));
% %             [a.rocsmeanEarly{cd,1}(u,1),a.ROCpvalsmeanEarly{cd,1}(u,1)] = rocarea3(mean(Activity_2(:,a.tRespEarly{e}),2,'omitnan'),mean(Activity_1(:,a.tRespEarly{e}),2,'omitnan'));
% %             [a.rocsmeanLate{cd,1}(u,1),a.ROCpvalsmeanLate{cd,1}(u,1)] = rocarea3(mean(Activity_2(:,a.tRespLate{e}),2,'omitnan'),mean(Activity_1(:,a.tRespLate{e}),2,'omitnan'));
% %             [a.rocsmeanbase{cd,1}(u,1),a.ROCpvalsbasemean{cd,1}(u,1)] = rocarea3(mean(Baseline_2,2),mean(Baseline_1,2,'omitnan'));
% %             [a.rocsmeanPre{cd,1}(u,1),a.ROCpvalsmeanPre{cd,1}(u,1)] = rocarea3(mean(Activity_2(:,a.tpre{e}),2,'omitnan'),mean(Activity_1(:,a.tpre{e}),2,'omitnan'));
% %             [a.rocsmeanPreEarly{cd,1}(u,1),a.ROCpvalsmeanPreEarly{cd,1}(u,1)] = rocarea3(mean(Activity_2(:,a.tpreEarly{e}),2,'omitnan'),mean(Activity_1(:,a.tpreEarly{e}),2,'omitnan'));
% %             [a.rocsmeanPreLate{cd,1}(u,1),a.ROCpvalsmeanPreLate{cd,1}(u,1)] = rocarea3(mean(Activity_2(:,a.tpreLate{e}),2,'omitnan'),mean(Activity_1(:,a.tpreLate{e}),2,'omitnan'));
%         end
% 
% %         a.pcellsROC{cd,:} = sum(a.ROCpvals{cd,1}<a.pcrit)/a.neuronCt;
% %         a.pcellsmeanROC{cd,:} = sum(a.ROCpvalsmean{cd,1}<a.pcrit)/a.neuronCt;
% %         a.pcellsmeanROCEarly{cd,:} = sum(a.ROCpvalsmeanEarly{cd,1}<a.pcrit)/a.neuronCt;
% %         a.pcellsmeanROCLate{cd,:} = sum(a.ROCpvalsmeanLate{cd,1}<a.pcrit)/a.neuronCt;
% %         a.pcellsmeanpreROC{cd,:} = sum(a.ROCpvalsmeanPre{cd,1}<a.pcrit)/a.neuronCt;
% %         a.pcellsmeanbaseROC{cd,:} = sum(a.ROCpvalsbasemean{cd,1}<a.pcrit)/a.neuronCt;
% %         a.pcellsmeanpreROCEarly{cd,:} = sum(a.ROCpvalsmeanPreEarly{cd,1}<a.pcrit)/a.neuronCt;
% %         a.pcellsmeanpreROCLate{cd,:} = sum(a.ROCpvalsmeanPreLate{cd,1}<a.pcrit)/a.neuronCt;
%         a.pcellsRS{cd,:} = sum(a.RSpvals{cd,1}<a.pcrit&a.absActivityPostDiff{cd}>a.diffcrit)/a.neuronCt;
%         a.pcellsmeanRS{cd,:} = sum(a.RSpvalsmean{cd,1}<a.pcrit&a.absActivityPostDiff{cd}>a.diffcrit)/a.neuronCt;
%         a.pcellsmeanpreRS{cd,:} = sum(a.RSpvalsmeanPre{cd,1}<a.pcrit&a.absActivityPreDiff{cd}>a.diffcrit)/a.neuronCt;
% %         a.pcellsmeanBaseRS{cd,:} = sum(a.RSpvalsmeanBase{cd,1}<a.pcrit&a.absActivityBaseDiff{cd}>a.diffcrit)/a.neuronCt;
% %         a.sigcells{cd,:} = a.ROCpvalsmean{cd,1}<a.pcrit;
%             % MEAN ROCS
%          
%         a.C_condRSdifferent{cd}=a.RSpvalsmean{cd,1}<a.pcrit&a.absActivityPostDiff{cd}>a.diffcrit;
%         a.C_condShuffleDifferent{cd}=a.pNeuronsPost{cd}<(a.pcrit*100)&a.absActivityPostDiff{cd}>a.diffcrit;     
%             
% %         a.C_condRSdifferent{cd}=a.RSpvalsmean{cd,1}<a.pcrit&a.absActivityPostDiff{cd}>a.maxcrit;
% %         a.C_condROCdifferent{cd}=a.ROCpvalsmean{cd,1}<a.pcrit&abs(a.rocsmean{cd}-0.5)>a.ROCcrit;
% %         a.C_condShuffleDifferent{cd}=a.pNeuronsPost{cd}<(a.pcrit*100)&a.absActivityPostDiff{cd}>a.maxcrit;
% 
%     % mean ROC for pop over time
% %     a.rocsPopMean{cd,1} = mean(abs(a.rocs{cd}-0.5),1);
%     
%     else
% %         a.rocsPop{cd,1} = NaN;
% %         a.ROCPopPvals{cd,1} = NaN;
% %         a.rocPopPost{cd,1} = NaN;
% %         a.rocPopPostpval{cd,1} = NaN;
% %         a.rocPopPre{cd,1} = NaN;
% %         a.rocPopPrepval{cd,1} = NaN;
%         a.activityTimeDiff{cd} = NaN;
%         a.absActivityTimeDiff{cd} = NaN;
%         a.RSpvals{cd,1} = NaN(a.neuronCt,80);
%         a.RSpvalsmean{cd,1} = NaN(a.neuronCt,1);
%         a.RSpvalsmeanPre{cd,1} = NaN(a.neuronCt,1);
% %         a.rocs{cd,1} = NaN(a.neuronCt,80);
% %         a.ROCpvals{cd,1} = NaN(a.neuronCt,80);
% %         a.rocsmean{cd,1} = NaN(a.neuronCt,1);
% %         a.ROCpvalsmean{cd,1} = NaN(a.neuronCt,1);
% %         a.ROCpvalsbasemean{cd,1} = NaN(a.neuronCt,1);
% %         a.rocsmeanEarly{cd,1} = NaN(a.neuronCt,1);
% %         a.ROCpvalsmeanEarly{cd,1} = NaN(a.neuronCt,1);
% %         a.rocsmeanLate{cd,1} = NaN(a.neuronCt,1);
% %         a.ROCpvalsmeanLate{cd,1} = NaN(a.neuronCt,1);
% %         a.rocsmeanPre{cd,1} = NaN(a.neuronCt,1);
% %         a.rocsmeanbase{cd,1} = NaN(a.neuronCt,1);
% %         a.ROCpvalsmeanPre{cd,1} = NaN(a.neuronCt,1);
% %         a.rocsmeanPreEarly{cd,1} = NaN(a.neuronCt,1);
% %         a.ROCpvalsmeanPreEarly{cd,1} = NaN(a.neuronCt,1);
% %         a.rocsmeanPreLate{cd,1} = NaN(a.neuronCt,1);
% %         a.ROCpvalsmeanPreLate{cd,1} = NaN(a.neuronCt,1);
% %         a.pcellsROC{cd,:} = NaN;
% %         a.pcellsmeanROC{cd,:} = NaN;
% %         a.pcellsmeanROCEarly{cd,:} = NaN;
% %         a.pcellsmeanROCLate{cd,:} = NaN;
% %         a.pcellsmeanpreROC{cd,:} = NaN;
% %         a.pcellsmeanprebaseROC{cd,:} = NaN;
% %         a.pcellsmeanpreROCEarly{cd,:} = NaN;
% %         a.pcellsmeanpreROCLate{cd,:} = NaN;
%         a.pcellsRS{cd,:} = NaN;
%         a.pcellsmeanRS{cd,:} = NaN;
%         a.pcellsmeanpreRS{cd,:} = NaN;
% %         a.pcellsmeanpreBaseRS{cd,:} = NaN;
% %         a.sigcells{cd,:} = NaN;
% %         a.rocsPopMean{cd,1} = NaN;
%     end
% 
% end
% 
% % %%
% % a.ROCpercent = [a.pcellsmeanROC(1);a.pcellsmeanROCEarly(1);...
% %     a.pcellsmeanROCLate(1);a.pcellsmeanROC(2:end)];
% % % a.ROCpercentPre = [a.pcellsmeanpreROC(1);a.pcellsmeanpreROCEarly(1);...
% % %     a.pcellsmeanpreROCLate(1);a.pcellsmeanpreROC(2:end)];
% % a.rocsmeanEarlyLate = [a.rocsmean(1);a.rocsmeanEarly(1);a.rocsmeanLate(1);...
% %     a.rocsmean(2:end)];
% % a.ROCpvalsmeanEarlyLate = [a.ROCpvalsmean(1);a.ROCpvalsmeanEarly(1);a.ROCpvalsmeanLate(1);...
% %     a.ROCpvalsmean(2:end)];

% SIGNIFICANT DIFFERENCE (non-cross-validated)



%% ETHAN BALANCED DIFFERENCE

disp('Calculating EBM index for each event');

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

display('done with EBM')
%% MOVEMENT STUFF

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



%%
clear cy yy y1 yy1 y2 yy2 y11 y12 y y21 y22 s1 y1shuffle s2 y2shuffle...
    timeBaseline randActivity shuffleDiff badidx maxidx y1mean y2mean...
    y1meanPost y1meanPre y2meanPost y2meanPre Activity_1 Activity_2 shuffle...
    cy y1mean1 y1mean2 y2mean1 y2mean2 activityDifference1 activityDifference2...
    activityDifferenceTrial1 activityDifferenceTrial2 maxval ybase...
    ybaseline ybaselineExp ypost ymean randActivity

%% SHUFFLE FULL TRIAL ACTIVITY

disp('Shuffle full trial');

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
    
    clear yy1 yy2 y1 y2 cy
    
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
        
        clear s1 s2 y1shuffle y2shuffle
        
        y1mean = mean(y1,3,'omitnan'); % mean across trials in cond 1
        y2mean = mean(y2,3,'omitnan');        
        a.shuffleDiffTrial{cd}(:,:,j)=abs(y1mean-y2mean);
        clear y1mean y2mean
        
        y11=y1(:,:,1:2:end);
        y12=y1(:,:,2:2:end);

        y21=y2(:,:,1:2:end);
        y22=y2(:,:,2:2:end);
        
        clear y1 y2
        
        y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
        y1mean2 = mean(y12,3,'omitnan');
        y2mean1 = mean(y21,3,'omitnan');
        y2mean2 = mean(y22,3,'omitnan');
        
        clear y11 y12 y21 y22
        
        activityDifferenceTrial1 = y1mean1-y2mean1;
        activityDifferenceTrial2 = y1mean2-y2mean2;
        
        clear y1mean1 y1mean2 y2mean1 y2mean2       
        
        a.activityDifferenceTrialEBMShuffle{cd}(:,:,j) = (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;
        
        clear activityDifferenceTrial1 activityDifferenceTrial2
        
    end
end

%% ACTIVITY BETWEEN CONDITIONS (DIFFERENTIAL) - WHOLE TRIAL

disp('Calculating whole-trial activity difference');

% RESPONSE ACROSS CONDITIONS MEAN AND OVER TIME

%  population ROC (distrib of avg cell response to condition)


for cd = 1:size(a.trialCompNames)
    cname = a.trialCompNames{cd};
    e = a.trialCompEvents(cd);
    cy = cellfun(@(z) a.(z),cname,'uniform',0);    
    y1 = cy{1};
    y2 = cy{2};
    
    y1mean = mean(y1,3,'omitnan'); % mean across trials in cond 1
    y2mean = mean(y2,3,'omitnan');
    
    if ~isempty(y1) & ~isempty(y2)   

        % DIFFERENCE AND ABSOLUTE DIFFERENCE
        a.activityTimeDiffTrial{cd} = y1mean-y2mean;
        a.absActivityTimeDiffTrial{cd} = abs(y1mean-y2mean);
        
%         % ARE THESE CORRECT?
%         a.pNeuronsTimeTrial{cd} = zeros(a.neuronCt,size(a.absActivityTimeDiffTrial{cd},2));
%         for i=1:a.neuronCt          
%             for t=1:size(a.absActivityTimeDiffTrial{cd},2)
%                 randActivity =squeeze(a.shuffleDiffTrial{cd}(:,t,:))';
%                 a.pNeuronsTimeTrial{cd}(i,t) = 100*sum((randActivity(:)>a.absActivityTimeDiffTrial{cd}(i,t))) ...
%                     /length(randActivity(:));                
%             end
%         end
%         a.nSigTimeTrial{cd}=sum(a.pNeuronsTimeTrial{cd}<(a.pcrit*100)&a.absActivityTimeDiffTrial{cd}>a.diffcrit)/a.neuronCt;

        % RANK-SUM & ROCs between conditions
        for u = 1:a.neuronCt
            Activity_1 = squeeze(cy{1}(u,:,:))';
            Activity_2 = squeeze(cy{2}(u,:,:))';

            % rank-sum p-val that cell differentiates conditions across time
            for t = 1:size(Activity_1,2)
               a.RSpvalsTrial{cd,1}(u,t) = ranksum(Activity_1(:,t),Activity_2(:,t));
            end
        end
%         a.pcellsRSTrial{cd,:} = sum(a.RSpvalsTrial{cd,1}<a.pcrit&a.absActivityPostDiffTrial{cd}>a.diffcrit)/a.neuronCt;
            % MEAN ROCS   

    % mean ROC for pop over time
    
    else
        a.activityTimeDiffTrial{cd} = NaN;
        a.absActivityTimeDiffTrial{cd} = NaN;
        a.RSpvalsTrial{cd,1} = NaN(a.neuronCt,80);
        a.pcellsRSTrial{cd,:} = NaN;
    end

end

%% WHOLE TRIAL EBM BALANCED DIFF

disp('Calculating whole-trial EBM');

for cd = 1:size(a.trialCompNames)
    cname = a.trialCompNames{cd};
    e = a.trialCompEvents(cd);
    cy = cellfun(@(z) a.(z),cname,'uniform',0);    
    y1 = cy{1};
    y2 = cy{2};
    
    clear cy;
    
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

% 
% %% SEPARATE ACTIVITY BY MOUSE FOR PCA SHUFFLE
% 
iStart = 40;
iStop = 56;
% N=size(a.C_odor1Info,1);
% % nIL=size(a.C_odor1FirstInfoLeft,3);
% % nIR=size(a.C_odor1FirstInfoRight,3);
% % nNL=size(a.C_odor1FirstRandLeft,3);
% % nNR=size(a.C_odor1FirstRandRight,3);
% 
% % reconstruct activity for each mouse - make function!
% mouseCells=histc(a.mouse(:),unique(a.mouse));
% mouseCellCts=[0; cumsum(mouseCells)];
% nmIR=sum(~isnan(a.C_odor1FirstInfoRight(cumsum(mouseCells),1,:)),3);
% nmIL=sum(~isnan(a.C_odor1FirstInfoLeft(cumsum(mouseCells),1,:)),3);
% nmNL=sum(~isnan(a.C_odor1FirstRandLeft(cumsum(mouseCells),1,:)),3);
% nmNR=sum(~isnan(a.C_odor1FirstRandRight(cumsum(mouseCells),1,:)),3);
% 
% nmA=sum(~isnan(a.C_odor2A(cumsum(mouseCells),1,:)),3);
% nmB=sum(~isnan(a.C_odor2B(cumsum(mouseCells),1,:)),3);
% nmC=sum(~isnan(a.C_odor2C(cumsum(mouseCells),1,:)),3);
% nmD=sum(~isnan(a.C_odor2D(cumsum(mouseCells),1,:)),3);
% 
% % doesn't include NaNs!!
% for m=1:numel(mice)
%    IR{m}=a.C_odor1FirstInfoRight(mouseCellCts(m)+1:mouseCellCts(m+1),iStart:iStop,1:nmIR(m)); 
%    IL{m}=a.C_odor1FirstInfoLeft(mouseCellCts(m)+1:mouseCellCts(m+1),iStart:iStop,1:nmIL(m));
%    NR{m}=a.C_odor1FirstRandRight(mouseCellCts(m)+1:mouseCellCts(m+1),iStart:iStop,1:nmNR(m));
%    NL{m}=a.C_odor1FirstRandLeft(mouseCellCts(m)+1:mouseCellCts(m+1),iStart:iStop,1:nmNL(m));
%    Aact{m}=a.C_odor2A(mouseCellCts(m)+1:mouseCellCts(m+1),iStart:iStop,1:nmA(m));
%    Bact{m}=a.C_odor2B(mouseCellCts(m)+1:mouseCellCts(m+1),iStart:iStop,1:nmB(m)); 
%    Cact{m}=a.C_odor2C(mouseCellCts(m)+1:mouseCellCts(m+1),iStart:iStop,1:nmC(m)); 
%    Dact{m}=a.C_odor2D(mouseCellCts(m)+1:mouseCellCts(m+1),iStart:iStop,1:nmD(m)); 
%    mAct{m}=cat(3,IR{m},IL{m},NR{m},NL{m});
%    mActAB{m}=cat(3,Aact{m},Bact{m});
%    mActCD{m}=cat(3,Cact{m},Dact{m});
%    iIR{m}(1:nmIR(m),1)=1;
%    iIL{m}(1:nmIL(m),1)=2;
%    iNR{m}(1:nmNR(m),1)=3;
%    iNL{m}(1:nmNL(m),1)=4;
%    ii{m}=[iIR{m};iIL{m};iNR{m};iNL{m}];
%    mxT(m)=numel(ii{m});
%    iA{m}(1:nmA(m),1)=1;
%    iB{m}(1:nmB(m),1)=2;
%    iC{m}(1:nmC(m),1)=1;
%    iD{m}(1:nmD(m),1)=2;
%    iiAB{m}=[iA{m};iB{m};];
%    iiCD{m}=[iC{m};iD{m}];
%    mxTAB(m)=numel(iiAB{m});
%    mxTCD(m)=numel(iiCD{m});
% end
% 
% mxT=max(mxT);
% mxTAB=max(mxTAB);
% mxTCD=max(mxTCD);
% 
% % can use above for decoding!!
% %% SHUFFLE for stats
% 
% nRuns = 100;
% randPCArea = zeros(nRuns,1);
% randPCAreaLR = zeros(nRuns,1);
% randPCAreaAB = zeros(nRuns,1);
% randPCAreaCD = zeros(nRuns,1);
% randNeuronAreas = zeros(nRuns,N);
% randNeuronAreasLR = zeros(nRuns,N);
% randNeuronAreasAB = zeros(nRuns,N);
% randNeuronAreasCD = zeros(nRuns,N);
% for j=1:nRuns
%     for m=1:numel(mice)
%         % shuffle all trials (all types)
%         iShuffle{m}=ii{m}(randperm(size(ii{m},1)));
%         iShuffleAB{m}=iiAB{m}(randperm(size(iiAB{m},1)));
%         iShuffleCD{m}=iiCD{m}(randperm(size(iiCD{m},1)));
%         for i=1:4
%             rs{i} = mAct{m}(:,:,iShuffle{m}==i);
%             s{i}=NaN(size(rs{i},1),size(rs{i},2),mxT);
%             s{i}(:,:,1:size(rs{i},3))=rs{i};     
%             if m==1
%                suffleR{i} = s{i};
%             else
%                suffleR{i} = cat(1,suffleR{i},s{i});
%             end
%         end
%         for i=1:2
%             rsAB{i} = mActAB{m}(:,:,iShuffleAB{m}==i);
%             sAB{i}=NaN(size(rsAB{i},1),size(rsAB{i},2),mxTAB);
%             sAB{i}(:,:,1:size(rsAB{i},3))=rsAB{i};
%             rsCD{i} = mActCD{m}(:,:,iShuffleCD{m}==i);
%             sCD{i}=NaN(size(rsCD{i},1),size(rsCD{i},2),mxTCD);
%             sCD{i}(:,:,1:size(rsCD{i},3))=rsCD{i};            
%             if m==1
%                suffleRAB{i} = sAB{i};
%                suffleRCD{i} = sCD{i};
%             else
%                suffleRAB{i} = cat(1,suffleRAB{i},sAB{i});
%                suffleRCD{i} = cat(1,suffleRCD{i},sCD{i});
%             end           
%         end        
%     end
% 
% %     data{j}=suffleR;
%     
%     rsIR = squeeze(mean(suffleR{1},3,'omitnan'));
%     rsIL = squeeze(mean(suffleR{2},3,'omitnan'));
%     rsNR = squeeze(mean(suffleR{3},3,'omitnan'));
%     rsNL = squeeze(mean(suffleR{4},3,'omitnan'));
%     
%     rsIR = rsIR - rsIR(:,1);
%     rsIL = rsIL - rsIL(:,1);
%     rsNL = rsNL - rsNL(:,1);
%     rsNR = rsNR - rsNR(:,1);
% 
%     rsI = rsIR+rsIL;
%     rsN = rsNR+rsNL;
% %     rI = rI - mean(rI,2);
% %     rN = rN - mean(rN,2);
% 
%     rsIN = rsI-rsN; % neurons x time (selected interval)
% 
%     [UsIN SsIN VsIN] = svd(rsIN);
%     LsIN = diag(SsIN).^2;
%     LsIN = 100*LsIN/sum(LsIN);
% 
%     randPCArea(j) = abs(mean(UsIN(:,1)'*rsIN));
%     randNeuronAreas(j,:) = abs(mean(rsIN,2));
%     
%     rsL=rsIL+rsNL;
%     rsR=rsIR+rsNR;
%     rsLR = rsL-rsR;
%     
%     [UsLR SsLR VsLR] = svd(rsLR);
%     LsLR = diag(SsLR).^2;
%     LsLR = 100*LsLR/sum(LsLR);
% 
%     randPCAreaLR(j) = abs(mean(UsLR(:,1)'*rsLR));
%     randNeuronAreasLR(j,:) = abs(mean(rsLR,2));    
%     
%     rsA = squeeze(mean(suffleRAB{1},3,'omitnan'));
%     rsB = squeeze(mean(suffleRAB{2},3,'omitnan'));
%     rsC = squeeze(mean(suffleRCD{1},3,'omitnan'));
%     rsD = squeeze(mean(suffleRCD{2},3,'omitnan'));
%     
%     rsA=rsA-rsA(:,1);
%     rsB=rsB-rsB(:,1);
%     rsC=rsC-rsC(:,1);
%     rsD=rsD-rsD(:,1);
%     rsA_B = rsA-rsB;
%     rsC_D = rsC-rsD;
%     
%     [UsAB SsAB VsAB] = svd(rsA_B);
%     LsAB = diag(SsAB).^2;
%     LsAB = 100*LsAB/sum(LsAB);
% 
%     randPCAreaAB(j) = abs(mean(UsAB(:,1)'*rsA_B));
%     randNeuronAreasAB(j,:) = abs(mean(rsA_B,2));
% 
%     [UsCD SsCD VsCD] = svd(rsC_D);
%     LsCD = diag(SsCD).^2;
%     LsCD = 100*LsCD/sum(LsCD);
% 
%     randPCAreaCD(j) = abs(mean(UsCD(:,1)'*rsC_D));
%     randNeuronAreasCD(j,:) = abs(mean(rsC_D,2));  
%  
% end
% 
% %% PCA
% 
% rIL = mean(a.C_odor1FirstInfoLeft(:,iStart:iStop,:),3,'omitnan');
% rIR = mean(a.C_odor1FirstInfoRight(:,iStart:iStop,:),3,'omitnan');
% rNL = mean(a.C_odor1FirstRandLeft(:,iStart:iStop,:),3,'omitnan');
% rNR = mean(a.C_odor1FirstRandRight(:,iStart:iStop,:),3,'omitnan');
% 
% rIR = rIR - rIR(:,1);
% rIL = rIL - rIL(:,1);
% rNL = rNL - rNL(:,1);
% rNR = rNR - rNR(:,1);
% 
% rI = rIL+rIR;
% rN = rNL+rNR;
% % rI = rI - mean(rI,2);
% % rN = rN - mean(rN,2);
% rIN = rI-rN;
% 
% rL=rIL+rNL;
% rR=rIR+rNR;
% % rL = rL - mean(rL,2);
% % rR = rR - mean(rR,2);
% rLR = rL-rR;
% 
% [UIN SIN VIN] = svd(rIN);
% LIN = diag(SIN).^2;
% LIN = 100*LIN/sum(LIN);
% percentVarInfo = 100*(var(rI'*UIN(:,1))+var(rN'*UIN(:,1)))/ ...
%                     (sum(var(rI'))+sum(var(rN')));
% 
% [UINSort iINSort] = sort(UIN(:,1),'descend');
% 
% PCArea = abs(mean(UIN(:,1)'*rIN));
% sNeuronAreas = mean(rIN,2);
% NeuronAreas = abs(sNeuronAreas);
% [ASort iASort] = sort(NeuronAreas,'descend');
% [sASort isASort] = sort(sNeuronAreas,'descend');
% 
% pPC = 100*sum(randPCArea>PCArea)/nRuns;
% pNeurons = zeros(N,1);
% for i=1:N
%     pNeurons(i) = 100*sum((randNeuronAreas(:)>NeuronAreas(i))) ...
%         /length(randNeuronAreas(:));
% end
% nSig  = sum(pNeurons<5)'
% a.PCAinfocells=pNeurons<5;
% a.UIN=UIN;
% a.LIN=LIN;
% a.neuronAreas=NeuronAreas;
% 
% % save('pStats','nSig','pPC', 'pNeurons');
% 
% [ULR SLR VLR] = svd(rLR);
% LLR = diag(SLR).^2;
% LLR = 100*LLR/sum(LLR);
% [ULRSort iLRSort] = sort(ULR(:,1),'descend');
% % [sLRSort,isLRSort] = sort(mean(rLR,2),'descend');
% percentVarLeftRight = 100*(var(rL'*ULR(:,1))+var(rR'*ULR(:,1)))/ ...
%                     (sum(var(rL'))+sum(var(rR')));
% 
% PCAreaLR = abs(mean(ULR(:,1)'*rLR));
% sNeuronAreasLR = mean(rLR,2);
% NeuronAreasLR = abs(sNeuronAreasLR);
% [ASortLR iASortLR] = sort(NeuronAreasLR,'descend');
% [sASortLR isASortLR] = sort(sNeuronAreasLR,'descend');
% 
% pPCLR = 100*sum(randPCAreaLR>PCAreaLR)/nRuns
% pNeuronsLR = zeros(N,1);
% for i=1:N
%     pNeuronsLR(i) = 100*sum((randNeuronAreasLR(:)>NeuronAreasLR(i))) ...
%         /length(randNeuronAreasLR(:));
% end
% nSigLR  = sum(pNeuronsLR<5)'
% 
% % save('pStats','nSig','pPC', 'pNeurons');
% 
% %%
% 
% rIvar = rI - mean(rI,2);
% rNvar = rN - mean(rN,2);
% rINvar = rIvar-rNvar;
% [UINvar SINvar VINvar] = svd(rINvar);
% percentVarInfo = 100*(var(rIvar'*UINvar(:,1))+var(rNvar'*UINvar(:,1)))/ ...
%                     (sum(var(rIvar'))+sum(var(rNvar')))
% 
% rLvar = rL - mean(rL,2);
% rRvar = rR - mean(rR,2);
% rLRvar = rLvar-rRvar;
% [ULRvar SLRvar VLRvar] = svd(rLRvar);
% percentVarLeftRight = 100*(var(rLvar'*ULRvar(:,1))+var(rRvar'*ULRvar(:,1)))/ ...
%                     (sum(var(rLvar'))+sum(var(rRvar')))
% 
% % %% DECODING
% % 
% % %mAct is concatenated activity for each mouse
% % % ii is 1-4 code for trial type
% % 
% % % xIL=squeeze(mean(a.C_odor1FirstInfoLeft(:,iStart:iStop,:),2))'; % trials by cells, mean over time
% % % xIR=squeeze(mean(a.C_odor1FirstInfoRight(:,iStart:iStop,:),2))';
% % % xNL=squeeze(mean(a.C_odor1FirstRandLeft(:,iStart:iStop,:),2))';
% % % xNR=squeeze(mean(a.C_odor1FirstRandRight(:,iStart:iStop,:),2))';
% % 
% % minIR=min(nmIR(okMice));
% % minIL=min(nmIL(okMice));
% % minNL=min(nmNL(okMice));
% % minNR=min(nmNR(okMice));
% % % minIR=nmIR;
% % % minIL=nmIL;
% % % minNL=nmNL;
% % % minNR=nmNR;
% % 
% % xIL=[];xIR=[];xNL=[];xNR=[];
% % ms=okMice;
% % for mm=1:numel(okMice)
% %     m=ms(mm);
% % rnIL=randperm(nmIL(m)); % random list of trials of this type for this mouse
% % xIL=cat(1,xIL,squeeze(mean(IL{m}(:,:,rnIL(1:minIL)),2)));
% % rnIR=randperm(nmIR(m));
% % xIR=cat(1,xIR,squeeze(mean(IR{m}(:,:,rnIR(1:minIR)),2)));
% % rnNL=randperm(nmNL(m));
% % xNL=cat(1,xNL,squeeze(mean(NL{m}(:,:,rnNL(1:minNL)),2)));
% % rnNR=randperm(nmNR(m));
% % xNR=cat(1,xNR,squeeze(mean(NR{m}(:,:,rnNR(1:minNR)),2)));
% % end
% % 
% % xIL=xIL'; xIR=xIR'; xNL=xNL'; xNR=xNR';
% % 
% % yIL=ones(size(xIL,1),1).*1;
% % yIR=ones(size(xIR,1),1).*1;
% % yNL=ones(size(xNL,1),1).*-1;
% % yNR=ones(size(xNR,1),1).*-1;
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
% % 
% % % define weights and sort
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
% % % correlations = [corr(UIN(:,1),ULR(:,1)) corr(UIN(a.mouse~=2,1),wDecode)...
% % %     corr(ULR(a.mouse~=2,1),wDecode) corr(UIN(:,1),mean(rIN,2))]
% %


%% DECODING OVER TIME

% 
% 
% 
% mouseCells=histc(a.mouse(:),unique(a.mouse));
% mouseCellCts=[0; cumsum(mouseCells)];
% nmIR=sum(~isnan(a.C_odor1FirstInfoRight(cumsum(mouseCells),1,:)),3);
% nmIL=sum(~isnan(a.C_odor1FirstInfoLeft(cumsum(mouseCells),1,:)),3);
% nmNL=sum(~isnan(a.C_odor1FirstRandLeft(cumsum(mouseCells),1,:)),3);
% nmNR=sum(~isnan(a.C_odor1FirstRandRight(cumsum(mouseCells),1,:)),3);
% 
% minIR=min(nmIR(okMice));
% minIL=min(nmIL(okMice));
% minNL=min(nmNL(okMice));
% minNR=min(nmNR(okMice));
% 
% 
% decodeEvent='Center Odor First';
% e=3;
% 
% nTest = 100;
% i1List = 1:5:76;
% eTest = zeros(length(i1List),1);
% 
% t=a.t{e}(i1List+2);
% 
% % randomize trial order within each type within each mouse,
% % then concatenate across mice (only minimum number of that trial type
% % across all mice)
% m=1;
% xIL=[];xIR=[];xNL=[];xNR=[];
% ms=okMice;
% for mm=1:numel(okMice)
%     m=ms(mm);
%     mIL=a.C_odor1FirstInfoLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIL(m));
%     rnIL=randperm(nmIL(m));
%     xIL=cat(1,xIL,mIL(:,:,rnIL(1:minIL)));
%     mIR=a.C_odor1FirstInfoRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
%     rnIR=randperm(nmIR(m));
%     xIR=cat(1,xIR,mIR(:,:,rnIR(1:minIR)));
%     mNL=a.C_odor1FirstRandLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
%     rnNL=randperm(nmNL(m));
%     xNL=cat(1,xNL,mNL(:,:,rnNL(1:minNL)));
%     mNR=a.C_odor1FirstRandRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
%     rnNR=randperm(nmNR(m));
%     xNR=cat(1,xNR,mNR(:,:,rnNR(1:minNR)));    
% end
% 
% decode=1;
% i1=50;
% i2=54;
% % for decode=1:2
%     for jj=1:length(i1List)
%         i1 = i1List(jj);
%         i2 = i1+4;
%         xILt=squeeze(mean(xIL(:,i1:i2,:),2))'; % mean across time period, trials x cells
%         xIRt=squeeze(mean(xIR(:,i1:i2,:),2))';
%         xNLt=squeeze(mean(xNL(:,i1:i2,:),2))';
%         xNRt=squeeze(mean(xNR(:,i1:i2,:),2))';
%         
%         x=cat(1,xILt,xIRt,xNLt,xNRt); % all types together
% 
%         nTrial = size(x,1);
%         nOut = round(0.2*nTrial);
%         
%         if decode == 1
%             decodeName='Info';
%             yIL=ones(size(xILt,1),1).*1;
%             yIR=ones(size(xIRt,1),1).*1;
%             yNL=ones(size(xNLt,1),1).*-1;
%             yNR=ones(size(xNRt,1),1).*-1;   
%         else
%             decodeName='Side';
%             yIL=ones(size(xILt,1),1).*1;
%             yIR=ones(size(xIRt,1),1).*-1;
%             yNL=ones(size(xNLt,1),1).*1;
%             yNR=ones(size(xNRt,1),1).*-1;            
%         end
%         
%         y=cat(1,yIL,yIR,yNL,yNR);
% %         y=y(randperm(nTrial));
%                
% %         set up classifier
% %         cross valiation tests
%         errTest = zeros(nTest,1);
%         for i=1:nTest
%             ip = randperm(nTrial);
%             iTest = ip(1:nOut);
%             iT = randperm(nTrial);
%             xx = x(iT,:);
%             yy = y(iT,:);
%             xTest = xx(iTest,:);
%             yTest = yy(iTest);
%             xx(iTest,:) = [];
%             yy(iTest,:) = [];
%             svmTest = fitclinear(xx,yy);
%             errTest(i)=100*sum((yTest.*(xTest*svmTest.Beta+svmTest.Bias)<0))/nOut;
%         end
% %         testErrors{jj}=errTest;
%         error{decode}(:,jj)=errTest;
%         eTest(decode,jj) = mean(errTest);
%         eTestSEM(decode,jj) = sem(errTest);
%         decodeweights{decode}(:,jj)=svmTest.Beta;        
%     end    
% %     if decode==1
% %         [weightsSorted(:,decode),cellsByWeights(:,decode)]=sort(weights{decode}(:,11),'descend');
% %     end
%     
% % PLOTTING
% 
%     figure();
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [1 1 10 7];
%         set(fig,'PaperOrientation','landscape');
%     set(fig,'renderer','painters');
%     ax=nsubplot(1,1,1,1);
%     plot(ax,t,eTest(decode,:));
%     hold on;
%     plot([-1 +1].*10^10,[50 50],'k','linewidth',2,'xliminclude','off')
%     plot([0 0],[0 55],'r','linewidth',2) % Center Odor On
%     plot([0.2 0.2],[0 55],'r','linewidth',2) % Center Odor Off
%     plot([1.45 1.45],[0 55],'color',[.8 .8 .8],'linewidth',2) % Side Odor on
%     hold off;
% %     xlim([0 80])
%     ylim([0 55])
%     xlabel('decoding time (s)')
%     ylabel('decoding error')
%     title([strjoin(mice,' _ ') ' decoding ' decodeName ' at ' decodeEvent]);
%     saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_' decodeName '_' decodeEvent]),'pdf');

% end
% % 
% % %% DECODING INFO FORCED v NO INFO FORCED OVERALL (uses unbalanced trials)
% % 
% % decodeEvent='Center Odor First';
% % e=3;
% % 
% % nTest = 100;
% % i1List = 1:5:76;
% % eTest = zeros(length(i1List),1);
% % 
% % t=a.t{e}(i1List+2);
% % 
% % nmIR=sum(~isnan(a.C_odor1FirstInfoForcedRight(cumsum(mouseCells),1,:)),3);
% % nmIL=sum(~isnan(a.C_odor1FirstInfoForcedLeft(cumsum(mouseCells),1,:)),3);
% % nmNL=sum(~isnan(a.C_odor1FirstRandForcedLeft(cumsum(mouseCells),1,:)),3);
% % nmNR=sum(~isnan(a.C_odor1FirstRandForcedRight(cumsum(mouseCells),1,:)),3);
% % minIR=min(nmIR(okMice));
% % minIL=min(nmIL(okMice));
% % minNL=min(nmNL(okMice));
% % minNR=min(nmNR(okMice));
% % 
% % % randomize trial order within each type within each mouse,
% % % then concatenate across mice (only minimum number of that trial type
% % % across all mice)
% % m=1;
% % xIL=[];xIR=[];xNL=[];xNR=[];
% % ms=okMice;
% % for mm=1:numel(okMice)
% %     m=ms(mm);
% %     mIL=a.C_odor1FirstInfoForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIL(m));
% %     rnIL=randperm(nmIL(m));
% %     xIL=cat(1,xIL,mIL(:,:,rnIL(1:minIL)));
% %     mIR=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
% %     rnIR=randperm(nmIR(m));
% %     xIR=cat(1,xIR,mIR(:,:,rnIR(1:minIR)));
% %     mNL=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
% %     rnNL=randperm(nmNL(m));
% %     xNL=cat(1,xNL,mNL(:,:,rnNL(1:minNL)));
% %     mNR=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
% %     rnNR=randperm(nmNR(m));
% %     xNR=cat(1,xNR,mNR(:,:,rnNR(1:minNR)));    
% % end
% % 
% % decode=1;
% % 
% % 
% % i1=50;
% % i2=54;
% % for decode=1:2
% %     for jj=1:length(i1List)
% %         i1 = i1List(jj);
% %         i2 = i1+4;
% %         xILt=squeeze(mean(xIL(:,i1:i2,:),2))'; % mean across time period, trials x cells
% %         xIRt=squeeze(mean(xIR(:,i1:i2,:),2))';
% %         xNLt=squeeze(mean(xNL(:,i1:i2,:),2))';
% %         xNRt=squeeze(mean(xNR(:,i1:i2,:),2))';
% %         
% %         x=cat(1,xILt,xIRt,xNLt,xNRt); % all types together
% % 
% %         nTrial = size(x,1);
% %         nOut = round(0.2*nTrial);
% %         
% %         if decode == 1
% %             decodeName='Info Forced';
% %             yIL=ones(size(xILt,1),1).*1;
% %             yIR=ones(size(xIRt,1),1).*1;
% %             yNL=ones(size(xNLt,1),1).*-1;
% %             yNR=ones(size(xNRt,1),1).*-1;   
% %         else
% %             decodeName='Side Forced';
% %             yIL=ones(size(xILt,1),1).*1;
% %             yIR=ones(size(xIRt,1),1).*-1;
% %             yNL=ones(size(xNLt,1),1).*1;
% %             yNR=ones(size(xNRt,1),1).*-1;            
% %         end
% %         
% %         y=cat(1,yIL,yIR,yNL,yNR);
% % %         y=y(randperm(nTrial));
% %                
% % %         set up classifier
% % %         cross valiation tests
% %         errTest = zeros(nTest,1);
% %         for i=1:nTest
% %             ip = randperm(nTrial);
% %             iTest = ip(1:nOut);
% %             iT = randperm(nTrial);
% %             xx = x(iT,:);
% %             yy = y(iT,:);
% %             xTest = xx(iTest,:);
% %             yTest = yy(iTest);
% %             xx(iTest,:) = [];
% %             yy(iTest,:) = [];
% %             svmTest = fitclinear(xx,yy);
% %             errTest(i)=100*sum((yTest.*(xTest*svmTest.Beta+svmTest.Bias)<0))/nOut;
% %         end
% %         
% %         error{decode}(:,jj)=100-errTest;
% %         eTest(decode,jj) = mean(100-errTest);
% %         decodeweights{decode}(:,jj)=svmTest.Beta; 
% %     end    
% % %     if decode==1
% % %         [weightsSorted(:,decode),cellsByWeights(:,decode)]=sort(weights{decode}(:,11),'descend');
% % %     end
% % 
% %     SEM = std(error{decode})/sqrt(length(error{decode}));               % Standard Error
% %     ts = tinv([0.025  0.975],length(error{decode})-1);      % T-Score
% %     interval(1,:) = ts(1)*SEM;
% %     interval(2,:) = ts(2)*SEM;
% %     preError(decode,:)=mean(error{decode}(:,5:8),2);
% %     postError(decode,:)=mean(error{decode}(:,9:12),2);
% %     pDecode(decode)=signrank(preError(decode,:),postError(decode,:),'tail','left');
% %     
% % % PLOTTING
% % 
% %     figure();
% %     fig = gcf;
% %     fig.PaperUnits = 'inches';
% %     fig.PaperPosition = [1 1 10 7];
% %         set(fig,'PaperOrientation','landscape');
% %     set(fig,'renderer','painters');
% %     ax=nsubplot(1,1,1,1);
% %     plot(ax,t,eTest(decode,:));
% %     errorbar(t,eTest(decode,:),interval(1,:),interval(2,:),"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
% %     hold on;
% %     plot([-1 +1].*10^10,[50 50],'k','linewidth',2,'xliminclude','off')
% %     plot([0+PID 0+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor On
% %     plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor Off
% %     plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'color',[.8 .8 .8],'linewidth',2,'yliminclude','off') % Side Odor on
% % 
% %     xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% %     xticks2 = xticks2 + PID;
% %     xticks(xticks2);
% %     xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% %     set(gca, 'XTickLabel', xticklabels2);
% %     plot([0.075 0.075], ylim, '--r');
% %     xlim([-0.5+PID 2])
% % 
% %     % ylim([0 100])
% %     xlabel('decoding time (s)')
% %     ylabel('decoding error')
% %     hold off;
% %     ylabel('decoding error')
% %     title([strjoin(mice,' _ ') ' decoding ' decodeName ' at ' decodeEvent ' p=' num2str(pDecode(decode))]);
% %     saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_' decodeName '_' decodeEvent]),'pdf');
% % 
% % end
% % 
% % %% DECODING INFO CHOICE VS NO INFO CHOICE
% % 
% % % uses matrix trials x cells
% % 
% % % PARAMS
% % event = 'C_odor1First'; % to decode around first presentation of center odor
% % decodeEvent='Center Odor First';
% % decode=1;
% % decodeName='Info';
% % e=3;
% % nOut= 20;
% % nTest = 100;
% % i1List = 1:5:76;
% % t=a.t{e}(i1List+2);
% % eTest = zeros(length(i1List),1);
% % i1=50;
% % i2=54;
% % 
% % for m=1:numel(mice)
% % 
% % for jj=1:length(i1List)
% %     i1 = i1List(jj);
% %     i2 = i1+4;
% %     % trials x cells
% %     x_info=squeeze(mean(a.C_odor1FirstInfoChoice(a.mouse==m,i1:i2,:),2))';
% %     x_info=x_info(~isnan(x_info(:,1)),:);
% %     x_rand=squeeze(mean(a.C_odor1FirstRandChoice(a.mouse==m,i1:i2,:),2))';
% %     x_rand=x_rand(~isnan(x_rand(:,1)),:);
% %     x_size=min([size(x_info,1) size(x_rand,1)]); 
% %     xx1=randperm(size(x_info,1));
% %     xx2=randperm(size(x_rand,1));
% %     x_info=x_info(xx1,:);
% %     x_rand=x_rand(xx2,:);
% %     x_info=x_info(1:x_size,:);
% %     x_rand=x_rand(1:x_size,:);
% %     
% %     x=[x_info; x_rand];
% % 
% %     y_info=ones(size(x_info,1),1);
% %     y_rand=ones(size(x_rand,1),1)*-1;
% %     y=[y_info;y_rand];
% % 
% %     nTrial = size(x,1);
% %     nRand=size(x_rand,1);
% %     
% %     nOut=round(0.2*nTrial);
% %     
% %     % set up classifier
% %     % cross valiation tests
% %     errTest = zeros(nTest,1);
% %     for i=1:nTest
% %         ii = randperm(nTrial);
% %         iTest = ii(1:nOut);
% %         iT = randperm(nTrial);
% %         xx = x(iT,:);
% %         yy = y(iT,:);
% %         xTest = xx(iTest,:);
% %         yTest = yy(iTest);
% %         xx(iTest,:) = [];
% %         yy(iTest,:) = [];
% %         svmInfo = fitclinear(xx,yy);
% %         errTest(i)=100*sum((yTest.*(xTest*svmInfo.Beta+svmInfo.Bias)<0))/nOut;
% %     end
% %     eTest(jj) = mean(errTest);
% %     clear y_info y_rand
% % end
% % 
% % 
% % % DECODING PLOT
% % 
% % figure();
% % fig = gcf;
% % fig.PaperUnits = 'inches';
% % fig.PaperPosition = [1 1 10 7];
% %     set(fig,'PaperOrientation','landscape');
% % set(fig,'renderer','painters')
% % ax=nsubplot(1,1,1,1);
% % plot(ax,t,eTest,'color','b','linewidth',3,'marker','o','MarkerFaceColor','b');
% % hold on;
% % plot([-1 +1].*10^10,[50 50],'k','linewidth',2,'xliminclude','off')
% % plot([0 0],[0 55],'k','linewidth',2) % Center Odor On
% % plot([0.2 0.2],[0 55],'k','linewidth',2) % Center Odor Off
% % plot([1.45 1.45],[0 55],'color',[.8 .8 .8],'linewidth',2) % Side Odor on
% % hold off;
% % %     xlim([0 80])
% % % ylim([0 100])
% % xlabel('decoding time (s)')
% % ylabel('decoding error')
% % title([mice{m} ' ' strjoin(days{m}) ' decoding Choice at ' decodeEvent 'No Info n=' num2str(nRand)]);
% % % saveas(fig,fullfile(output_dir,[mice{m},'_',strjoin(days{m}),'_',allconditions,'_decoding_', decodeName,'_',decodeEvent]),'pdf');        
% % saveas(fig,fullfile(plotfolder,[mice{m} '_decoding_CHOICE_' decodeEvent]),'pdf');
% % 
% % end
% % 
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
%     x_info=squeeze(mean(a.C_odor1FirstInfoForced(a.mouse==m,i1:i2,:),2,'omitnan'))';
%     x_info=x_info(~isnan(x_info(:,1)),:);
%     x_rand=squeeze(mean(a.C_odor1FirstRandForced(a.mouse==m,i1:i2,:),2,'omitnan'))';
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
% saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_FORCEDBYMOUSE_' decodeEvent]),'pdf');
% 
% 
% 
% %% DECODING INFO FORCED AND CHOICE VS NO INFO FORCED AND CHOICE BY MOUSE
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
%     xx_info=cat(3,a.C_odor1FirstInfoForced(a.mouse==m,i1:i2,:),a.C_odor1FirstInfoChoice(a.mouse==m,i1:i2,:));
%     x_info=squeeze(mean(xx_info,2,'omitnan'))';
%     x_info=x_info(~isnan(x_info(:,1)),:);
%     xx_rand=cat(3,a.C_odor1FirstRandForced(a.mouse==m,i1:i2,:),a.C_odor1FirstRandChoice(a.mouse==m,i1:i2,:));
%     x_rand=squeeze(mean(xx_rand,2,'omitnan'))';
%     x_rand=x_rand(~isnan(x_rand(:,1)),:);
%     
%     x_size=min([size(x_info,1) size(x_rand,1)]);
%     
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
%         svmInfoFC = fitclinear(xx,yy);
%         errTest(i)=100*sum((yTest.*(xTest*svmInfoFC.Beta+svmInfoFC.Bias)<0))/nOut;
%     end
%     eTest(jj) = mean(errTest);
%     clear y_info y_rand
% end
% 
% decodeErrorFC(m,:)=100-eTest;
% 
% end
% 
% 
% % decodeError=100-decodeError;
% 
% % decodeError=decodeErrorLoss;
% % decodeErrorLoss=decodeError;
% % decodeError=1-decodeError;
% 
% SEM = std(decodeErrorFC)/sqrt(length(decodeErrorFC));               % Standard Error
% ts = tinv([0.025  0.975],length(decodeErrorFC)-1);      % T-Score
% interval(1,:) = ts(1)*SEM;
% interval(2,:) = ts(2)*SEM;
% preError=mean(decodeErrorFC(:,5:8),2);
% postError=mean(decodeErrorFC(:,9:12),2);
% pDecode=signrank(preError,postError,'tail','left');
% 
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
% hold on;
% for m=1:numel(okMice)
% plot(ax,t,decodeErrorFC(m,:),'color','b','linewidth',1,'marker','o','MarkerFaceColor','b');
% end
% plot(ax,t,mean(decodeErrorFC),'color','k','linewidth',4,'marker','o','MarkerFaceColor','k');
% errorbar(t,mean(decodeErrorFC),interval(1,:),interval(2,:),"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
% plot([-1 +1].*10^10,[50 50],'color',[.8 .8 .8],'linewidth',2,'xliminclude','off') 
% 
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
% hold off;
% %     xlim([0 80])
% % ylim([0 100])
% xlabel('decoding time (s)')
% ylabel('decoding error')
% title([strjoin(mice,' _ ') ' decoding Forced/Choice Info vs Forced/Choice No Info at ' decodeEvent ' p=' num2str(pDecode)]);
% % saveas(fig,fullfile(output_dir,[mice{m},'_',strjoin(days{m}),'_',allconditions,'_decodingPERMOUSE_', decodeName,'_',decodeEvent]),'pdf');        
% saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_FORCEDANDCHOICEBYMOUSE_' decodeEvent]),'pdf');
% 
% %% DECODING INFO CHOICE VS NO INFO CHOICE BY MOUSE
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
%     x_info=squeeze(mean(a.C_odor1FirstInfoChoice(a.mouse==m,i1:i2,:),2,'omitnan'))';
%     x_info=x_info(~isnan(x_info(:,1)),:);
%     x_rand=squeeze(mean(a.C_odor1FirstRandChoice(a.mouse==m,i1:i2,:),2,'omitnan'))';
%     x_rand=x_rand(~isnan(x_rand(:,1)),:);
%     x_size=min([size(x_info,1) size(x_rand,1)]);
%     
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
%         svmInfoC = fitclinear(xx,yy);
%         errTest(i)=100*sum((yTest.*(xTest*svmInfoC.Beta+svmInfoC.Bias)<0))/nOut;
%     end
% % uses matrix trials x cells
% 
% % PARAMS
% event = 'C_odor2'; % to decode around first presentation of center odor
% decodeEvent='Side Odor Info v Rand';
% decode=1;
% decodeName='Odor2';
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
%     x_info=squeeze(mean(a.C_odor2info(a.mouse==m,i1:i2,:),2,'omitnan'))';
%     x_info=x_info(~isnan(x_info(:,1)),:);
%     x_rand=squeeze(mean(a.C_odor2rand(a.mouse==m,i1:i2,:),2,'omitnan'))';
%     x_rand=x_rand(~isnan(x_rand(:,1)),:);
%     
%     x_size=min([size(x_info,1) size(x_rand,1)]);
%     
%     xx1=randperm(size(x_info,1));
%     xx2=randperm(size(x_rand,1));
%     x_info=x_info(xx1,:);
%     x_rand=x_rand(xx2,:);
%     x_info=x_info(1:x_size,:);
%     x_rand=x_rand(1:x_size,:);
%     
%     x=[x_info; x_rand];    
% 
%     y_info=ones(x_size,1);
%     y_rand=ones(x_size,1)*-1;
%     y=[y_info;y_rand];
% 
%     nTrial = size(x,1);
%     nRand=size(x_rand,1);
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
%         svmInfo2 = fitclinear(xx,yy);
%         errTest(i)=100*sum((yTest.*(xTest*svmInfo2.Beta+svmInfo2.Bias)<0))/nOut;
%     end
%     eTest(jj) = mean(errTest);
%     clear y_info y_rand
% end
% 
% decodeErrorABCD(m,:)=100-eTest;
% 
% end
% 
% % decodeError=100-decodeError;
% 
% SEM = std(decodeErrorABCD)/sqrt(length(decodeErrorABCD));               % Standard Error
% ts = tinv([0.025  0.975],length(decodeErrorABCD)-1);      % T-Score
% interval(1,:) = ts(1)*SEM;
% interval(2,:) = ts(2)*SEM;
% preError=mean(decodeErrorABCD(:,5:8),2);
% postError=mean(decodeErrorABCD(:,9:12),2);
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
% hold on;
% for m=1:numel(okMice)
% plot(ax,t,decodeErrorABCD(m,:),'color','b','linewidth',1,'marker','o','MarkerFaceColor','b');
% end
% plot(ax,t,mean(decodeErrorABCD),'color','k','linewidth',4,'marker','o','MarkerFaceColor','k');
% errorbar(t,mean(decodeErrorABCD),interval(1,:),interval(2,:),"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
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
% hold off;
% %     xlim([0 80])
% % ylim([0 100])
% xlabel('decoding time (s)')
% ylabel('decoding accuracy')
% title([strjoin(mice,' _ ') ' decoding Info AB vs No Info CD at ' decodeEvent ' p=' num2str(pDecode)]);
% % saveas(fig,fullfile(output_dir,[mice{m},'_',strjoin(days{m}),'_',allconditions,'_decodingPERMOUSE_', decodeName,'_',decodeEvent]),'pdf');        
% saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_ABvCDBYMOUSE_' decodeEvent]),'pdf');
% 
% % %% DECODING INFO VS No INFO SIDE ODOR BY MOUSE ORIGINAL DECODER
% % 
% % % uses matrix trials x cells
% % 
% % % PARAMS
% % event = 'C_odor2'; % to decode around first presentation of center odor
% % decodeEvent='Side Odor Info v Rand';
% % decode=1;
% % decodeName='Odor2';
% % e=3;
% % nOut= 20;
% % nTest = 100;
% % i1List = 1:5:76;
% % t=a.t{e}(i1List+2);
% % eTest = zeros(length(i1List),1);
% % i1=50;
% % i2=54;
% % 
% % for m=1:numel(mice)
% % 
% % for jj=1:length(i1List)
% %     i1 = i1List(jj);
% %     i2 = i1+4;
% %     % trials x cells
% % %     xx_info=cat(3,a.C_odor1FirstInfoForced(a.mouse==m,i1:i2,:),a.C_odor1FirstInfoChoice(a.mouse==m,i1:i2,:));
% %     x_info=squeeze(mean(a.C_odor2info(a.mouse==m,i1:i2,:),2,'omitnan'))';
% %     x_info=x_info(~isnan(x_info(:,1)),:);
% %     x_rand=squeeze(mean(a.C_odor2rand(a.mouse==m,i1:i2,:),2,'omitnan'))';
% %     x_rand=x_rand(~isnan(x_rand(:,1)),:);
% %     
% %     x_size=min([size(x_info,1) size(x_rand,1)]);
% %     
% %     xx1=randperm(size(x_info,1));
% %     xx2=randperm(size(x_rand,1));
% %     x_info=x_info(xx1,:);
% %     x_rand=x_rand(xx2,:);
% %     x_info=x_info(1:x_size,:);
% %     x_rand=x_rand(1:x_size,:);
% %     
% %     x=[x_info; x_rand];    
% % 
% %     y_info=ones(x_size,1);
% %     y_rand=ones(x_size,1)*-1;
% %     y=[y_info;y_rand];
% % 
% %     nTrial = size(x,1);
% %     nRand=size(x_rand,1);
% %     
% %     % set up classifier
% %     % cross valiation tests
% %     errTest = zeros(nTest,1);
% %     for i=1:nTest
% %         ii = randperm(nTrial);
% %         iTest = ii(1:nOut);
% %         iT = randperm(nTrial);
% %         xx = x(iT,:);
% %         yy = y(iT,:);
% %         xTest = xx(iTest,:);
% %         yTest = yy(iTest);
% %         xx(iTest,:) = [];
% %         yy(iTest,:) = [];
% % %         svmInfoF{m} = fitclinear(xx,yy);
% %         errTest(i)=100*sum((yTest.*(xTest*svmInfoF{m}.Beta+svmInfoF{m}.Bias)<0))/nOut;
% %     end
% %     eTest(jj) = mean(errTest);
% %     clear y_info y_rand
% % end
% % 
% % decodeErrorABCD(m,:)=100-eTest;
% % 
% % end
% % 
% % % decodeError=100-decodeError;
% % 
% % SEM = std(decodeErrorABCD)/sqrt(length(decodeErrorABCD));               % Standard Error
% % ts = tinv([0.025  0.975],length(decodeErrorABCD)-1);      % T-Score
% % interval(1,:) = ts(1)*SEM;
% % interval(2,:) = ts(2)*SEM;
% % preError=mean(decodeErrorABCD(:,5:8),2);
% % postError=mean(decodeErrorABCD(:,9:12),2);
% % pDecode=signrank(preError,postError,'tail','left');
% % 
% % % DECODING PLOT
% % 
% % figure();
% % fig = gcf;
% % fig.PaperUnits = 'inches';
% % fig.PaperPosition = [1 1 10 7];
% %     set(fig,'PaperOrientation','landscape');
% % set(fig,'renderer','painters')
% % ax=nsubplot(1,1,1,1);
% % hold on;
% % for m=1:numel(okMice)
% % plot(ax,t,decodeErrorABCD(m,:),'color','b','linewidth',1,'marker','o','MarkerFaceColor','b');
% % end
% % plot(ax,t,mean(decodeErrorABCD),'color','k','linewidth',4,'marker','o','MarkerFaceColor','k');
% % errorbar(t,mean(decodeErrorABCD),interval(1,:),interval(2,:),"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
% % plot([0+PID 0+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor On
% % plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor Off
% % plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'color',[.8 .8 .8],'linewidth',2,'yliminclude','off') % Side Odor on
% % 
% % xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% % xticks2 = xticks2 + PID;
% % xticks(xticks2);
% % xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% % set(gca, 'XTickLabel', xticklabels2);
% % plot([0.075 0.075], ylim, '--r');
% % xlim([-0.5+PID 2])
% % hold off;
% % %     xlim([0 80])
% % % ylim([0 100])
% % xlabel('decoding time (s)')
% % ylabel('decoding accuracy')
% % title([strjoin(mice,' _ ') ' decoding Info AB vs No Info CD at ' decodeEvent ' p=' num2str(pDecode)]);
% % % saveas(fig,fullfile(output_dir,[mice{m},'_',strjoin(days{m}),'_',allconditions,'_decodingPERMOUSE_', decodeName,'_',decodeEvent]),'pdf');        
% % saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_ABvCDBYMOUSE_ORIGDECODER_' decodeEvent]),'pdf');
% % 
% % 
% % %%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % %% SIDE ODOR PCA
% % %%%%%%%%%%%%%%%%%%%%%
% % 
% % iStart = 40;
% % iStop = 56;
% % 
% % % a_idx=find(a.imagingCorr==1&a.imagingOdor2==1&a.imageTrialType~=1);
% % % b_idx=find(a.imagingCorr==1&a.imagingOdor2==2&a.imageTrialType~=1);
% % % minTrials = min([numel(a_idx),numel(b_idx)]);
% % % a_idx=a_idx(randperm(minTrials));
% % % b_idx=b_idx(randperm(minTrials));
% % % xab=a.(event)(:,iStart:iStop,[a_idx; b_idx]);
% % % odor2ab=a.imagingOdor2([a_idx; b_idx]);
% % % 
% % % Nab=size(xab,1);
% % 
% % % rA = mean(xab(:,:,odor2ab==1),3); % side odor A
% % % rB = mean(xab(:,:,odor2ab==2),3); % side odor B
% % % rA = mean(a.(event)(:,iStart:iStop,a.imagingCorr==1&a.imagingOdor2==1&a.imageTrialType==2),3);
% % % rB = mean(a.(event)(:,iStart:iStop,a.imagingCorr==1&a.imagingOdor2==2&a.imageTrialType==2),3);
% % 
% % rA = mean(a.C_odor2A(:,iStart:iStop,:),3,'omitnan');
% % rB = mean(a.C_odor2B(:,iStart:iStop,:),3,'omitnan');
% % 
% % rA=rA-rA(:,1);
% % rB=rB-rB(:,1);
% % 
% % rAB = rA-rB;
% % 
% % % c_idx=find(a.imagingCorr==1&a.imagingOdor2==4&a.imageTrialType~=1);
% % % d_idx=find(a.imagingCorr==1&a.imagingOdor2==3&a.imageTrialType~=1);
% % % minTrialsCD = min([numel(c_idx),numel(d_idx)]);
% % % c_idx=c_idx(randperm(minTrialsCD));
% % % d_idx=d_idx(randperm(minTrialsCD));
% % % xcd=a.(event)(:,iStart:iStop,[c_idx; d_idx]);
% % % odor2cd=a.imagingOdor2([c_idx; d_idx]);
% % % 
% % % rC = mean(xcd(:,:,odor2cd==4),3); % side odor C
% % % rD = mean(xcd(:,:,odor2cd==3),3); % side odor D
% % 
% % rC = mean(a.C_odor2C(:,iStart:iStop,:),3,'omitnan');
% % rD = mean(a.C_odor2D(:,iStart:iStop,:),3,'omitnan');
% % 
% % rC=rC-rC(:,1);
% % rD=rD-rD(:,1);
% % 
% % rCD = rC-rD;
% % 
% % [UAB SAB VAB] = svd(rAB);
% % LAB = diag(SAB).^2;
% % LAB = 100*LAB/sum(LAB);
% % [UABSort iABSort] = sort(UAB(:,1),'descend');
% % 
% % [UCD SCD VCD] = svd(rCD);
% % LCD = diag(SCD).^2;
% % LCD = 100*LCD/sum(LCD);
% % [UCDSort iCDSort] = sort(UCD(:,1),'descend');
% % 
% % PCAreaAB = abs(mean(UAB(:,1)'*rAB));
% % sNeuronAreasAB = mean(rAB,2);
% % NeuronAreasAB = abs(sNeuronAreasAB);
% % [ASortAB iASortAB] = sort(NeuronAreasAB,'descend');
% % [sASortAB isASortAB] = sort(sNeuronAreasAB,'descend');
% % 
% % pPCAB = 100*sum(randPCAreaAB>PCAreaAB)/nRuns
% % pNeuronsAB = zeros(N,1);
% % for i=1:N
% %     pNeuronsAB(i) = 100*sum((randNeuronAreasAB(:)>NeuronAreasAB(i))) ...
% %         /length(randNeuronAreasAB(:));
% % end
% % nSigAB  = sum(pNeuronsAB<5)'
% % 
% % PCAreaCD = abs(mean(UCD(:,1)'*rCD));
% % sNeuronAreasCD = mean(rCD,2);
% % NeuronAreasCD = abs(sNeuronAreasCD);
% % [ASortCD iASortCD] = sort(NeuronAreasCD,'descend');
% % [sASortCD isASortCD] = sort(sNeuronAreasCD,'descend');
% % 
% % pPCCD = 100*sum(randPCAreaCD>PCAreaCD)/nRuns
% % pNeuronsCD = zeros(N,1);
% % for i=1:N
% %     pNeuronsCD(i) = 100*sum((randNeuronAreasCD(:)>NeuronAreasCD(i))) ...
% %         /length(randNeuronAreasCD(:));
% % end
% % nSigCD  = sum(pNeuronsCD<5)'
% % 
% % save('pStats','nSig','pPC', 'pNeurons','nSigLR','pPCLR', 'pNeuronsLR','nSigAB','nSigCD','pPCAB', 'pNeuronsAB','pPCCD', 'pNeuronsCD');
% % 
% % %%
% % 
% % rAvar = rA - mean(rA,2);
% % rBvar = rB - mean(rB,2);
% % rABvar = rAvar-rBvar;
% % [UABvar SABvar VABvar] = svd(rABvar);
% % percentVarAB = 100*(var(rAvar'*UABvar(:,1))+var(rBvar'*UABvar(:,1)))/ ...
% %                     (sum(var(rAvar'))+sum(var(rBvar')))
% % 
% % rCvar = rC - mean(rC,2);
% % rDvar = rD - mean(rD,2);
% % rCDvar = rCvar-rDvar;
% % [UCDvar SCDvar VCDvar] = svd(rCDvar);
% % percentVarCD = 100*(var(rCvar'*UCDvar(:,1))+var(rDvar'*UCDvar(:,1)))/ ...
% %                     (sum(var(rCvar'))+sum(var(rDvar')))
% % 
% % 
% % %% DECODING SIDE ODORS
% % 
% % decodeEvent='Side Odor';
% % e=6;
% % 
% % nTest = 100;
% % i1List = 1:5:76;
% % eTest = zeros(length(i1List),1);
% % 
% % t=a.t{e}(i1List+2);
% % 
% % minA=min(nmA(okMice));
% % minB=min(nmB(okMice));
% % minC=min(nmC(okMice));
% % minD=min(nmD(okMice));
% % 
% % m=1;
% % xA=[];xB=[];xC=[];xD=[];
% % ms=okMice;
% % for mm=1:numel(okMice)
% %     m=ms(mm);
% %     mA=a.C_odor2A(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmA(m));
% %     rnA=randperm(nmA(m));
% %     xA=cat(1,xA,mA(:,:,rnA(1:minA)));
% %     mB=a.C_odor2B(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmB(m));
% %     rnB=randperm(nmB(m));
% %     xB=cat(1,xB,mB(:,:,rnB(1:minB)));
% %     mC=a.C_odor2C(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmC(m));
% %     rnC=randperm(nmC(m));
% %     xC=cat(1,xC,mC(:,:,rnC(1:minC)));
% %     mD=a.C_odor2D(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmD(m));
% %     rnD=randperm(nmD(m));
% %     xD=cat(1,xD,mD(:,:,rnD(1:minD)));    
% % end
% % 
% % %%
% % decode=2;
% % for decode = 1:2
% % 
% % i1=50;
% % i2=54;
% %     for jj=1:length(i1List)
% %         i1 = i1List(jj);
% %         i2 = i1+4;
% %         xAt=squeeze(mean(xA(:,i1:i2,:),2))'; % trials by cells?
% %         xBt=squeeze(mean(xB(:,i1:i2,:),2))';
% %         xCt=squeeze(mean(xC(:,i1:i2,:),2))';
% %         xDt=squeeze(mean(xD(:,i1:i2,:),2))';
% %          
% %         if decode == 1
% %             decodeName='AB';
% %             ixB=randperm(size(xBt,1));
% %             xBt=xBt(ixB(1:size(xAt,1)),:);
% %             x=[xAt;xBt];
% %             nTrial = size(x,1);
% %             nOut = round(0.2*nTrial);
% %             y1=ones(size(xAt,1),1).*1;
% %             y2=ones(size(xBt,1),1).*-1;   
% %         else
% %             decodeName='CD';
% %             ixC=randperm(size(xCt,1));
% %             xCt=xCt(ixC(1:size(xDt,1)),:);
% %             x=[xCt;xDt];
% %             nTrial = size(x,1);
% %             nOut = round(0.2*nTrial);
% %             y1=ones(size(xCt,1),1).*1;
% %             y2=ones(size(xDt,1),1).*-1;            
% %         end
% %         
% %         y=cat(1,y1,y2);
% %                
% % %         set up classifier
% % %         cross valiation tests
% %         errTest = zeros(nTest,1);
% %         for i=1:nTest
% %             ip = randperm(nTrial);
% %             iTest = ip(1:nOut);
% %             iT = randperm(nTrial);
% %             xx = x(iT,:);
% %             yy = y(iT,:);
% %             xTest = xx(iTest,:);
% %             yTest = yy(iTest);
% %             xx(iTest,:) = [];
% %             yy(iTest,:) = [];
% %             svmTest = fitclinear(xx,yy);
% %             errTest(i)=100*sum((yTest.*(xTest*svmTest.Beta+svmTest.Bias)<0))/nOut;
% %         end
% %         testErrors{jj}=errTest;
% %         eTest(jj) = mean(errTest);
% %         decodeweights{decode}(:,jj)=svmTest.Beta;        
% %     end    
% % %     if decode==1
% % %         [weightsSorted(:,decode),cellsByWeights(:,decode)]=sort(weights{decode}(:,11),'descend');
% % %     end
% %     
% % % PLOTTING
% % 
% %     figure();
% %     fig = gcf;
% %     fig.PaperUnits = 'inches';
% %     fig.PaperPosition = [1 1 10 7];
% %         set(fig,'PaperOrientation','landscape');
% %     set(fig,'renderer','painters');
% %     ax=nsubplot(1,1,1,1);
% %     plot(ax,t,eTest);
% %     hold on;
% %     plot([-1 +1].*10^10,[50 50],'k','linewidth',2,'xliminclude','off')
% %     plot([0 0],[0 55],'r','linewidth',2) % Center Odor On
% %     plot([0.2 0.2],[0 55],'r','linewidth',2) % Center Odor Off
% %     plot([1.45 1.45],[0 55],'color',[.8 .8 .8],'linewidth',2) % Side Odor on
% %     hold off;
% % %     xlim([0 80])
% %     ylim([0 55])
% %     xlabel('decoding time (s)')
% %     ylabel('decoding error')
% %     title([strjoin(mice,' _ ') ' decoding ' decodeName ' at ' decodeEvent]);
% %     saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_' decodeName '_' decodeEvent]),'pdf');
% % 
% % end
% % %% FIGURE 10 CORRELATIONS
% % 
% % [INABPCcorr, INABPCp] =corr(UIN(:,1),UAB(:,1));
% % [ABCDPCcorr, ABCDPCp]=corr(UAB(:,1),UCD(:,1));
% % 
% % figure()
% % fig=gcf;
% % fig.PaperUnits = 'inches';
% % fig.PaperPosition = [0 0 11 8.5];
% % set(fig,'PaperOrientation','landscape');
% % ax1=nsubplot(1,2,1,1);
% % plot(UAB(:,1),UIN(:,1),'bo','linewidth',1)
% % plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% % plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% % xlabel('A-B Weight')
% % ylabel('Info-NoInfo Weight')
% % xlim([-0.5 0.5])
% % ylim([-0.5 0.5])
% % axis square
% % 
% % title(['Correlation = ' num2str(INABPCcorr) ' p = ' num2str(INABPCp)])
% % 
% % ax2=nsubplot(1,2,1,2);
% % plot(UAB(:,1),UCD(:,1),'bo','linewidth',1)
% % plot(ax2,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% % plot(ax2,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% % xlabel('A-B Weight')
% % ylabel('C-D Weight')
% % xlim([-0.5 0.5])
% % ylim([-0.5 0.5])
% % title(['Correlation = ' num2str(ABCDPCcorr) ' p = ' num2str(ABCDPCp)])
% % axis square
% % 
% % ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% % text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% % saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_Side_correlations']),'pdf');
% % 
% % %% FIGURE 11 CORRELATIONS
% % 
% % % sNeuronAreas = mean difference for each cell
% % % pNeurons<5 = diff significant
% % 
% % [INLRcorr, INLRp] = corr(NeuronAreas,NeuronAreasLR)
% % [sINLRcorr, sINLRp] = corr(sNeuronAreas,sNeuronAreasLR)
% % [INABcorr, INABp] = corr(sNeuronAreas,sNeuronAreasAB)
% % [ABCDcorr, ABCDp] = corr(sNeuronAreasAB,-1*sNeuronAreasCD)
% % 
% % 
% % figure()
% % fig=gcf;
% % fig.PaperUnits = 'inches';
% % fig.PaperPosition = [0 0 11 8.5];
% % set(fig,'PaperOrientation','landscape');
% % 
% % INLRsig=cell(size(pNeurons,1),1);
% % INLRsig(:)={'NS'};
% % INLRsig(pNeurons<5)={'Info Sig'};
% % INLRsig(pNeuronsLR<5)={'Side Sig'};
% % INLRsig(pNeurons<5&pNeuronsLR<5)={'Both Sig'};
% % 
% % ax1=nsubplot(1,4,1,1);
% % gscatter(NeuronAreas(:,1),NeuronAreasLR(:,1),INLRsig,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% % % plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% % % plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% % xlabel('abs Info-NoInfo')
% % ylabel('abs Left-Right')
% % % xlim([-2 2])
% % ylim([0 2])
% % axis square
% % 
% % title(['Correlation = ' num2str(INLRcorr) ' p = ' num2str(INLRp)])
% % 
% % INABsig=cell(size(pNeurons,1),1);
% % INABsig(:)={'NS'};
% % INABsig(pNeurons<5)={'Info Sig'};
% % INABsig(pNeuronsAB<5)={'AB Sig'};
% % INABsig(pNeurons<5&pNeuronsAB<5)={'Both Sig'};
% % 
% % ax2=nsubplot(1,4,1,2);
% % gscatter(sNeuronAreas(:,1),sNeuronAreasAB(:,1),INABsig,[0.8 0.8 0.8;0 1 0;0 0 1;1 0 0;],'.',15)
% % plot(ax2,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% % plot(ax2,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% % xlabel('Info-No Info')
% % ylabel('A-B')
% % xlim([-2 2])
% % ylim([-2 2])
% % title(['Correlation = ' num2str(INABcorr) ' p = ' num2str(INABp)])
% % axis square
% % 
% % ABCDsig=cell(size(pNeurons,1),1);
% % ABCDsig(:)={'NS'};
% % ABCDsig(pNeuronsAB<5)={'AB Sig'};
% % ABCDsig(pNeuronsCD<5)={'CD Sig'};
% % ABCDsig(pNeuronsAB<5&pNeuronsCD<5)={'Both Sig'};
% % 
% % ax3=nsubplot(1,4,1,3);
% % gscatter(sNeuronAreasAB(:,1),sNeuronAreasCD(:,1)*-1,ABCDsig,[0.8 0.8 0.8;0 1 0;0 0 1;1 0 0;],'.',15)
% % plot(ax3,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% % plot(ax3,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% % xlabel('A-B')
% % ylabel('D-C')
% % xlim([-2 2])
% % ylim([-2 2])
% % title(['Correlation = ' num2str(ABCDcorr) ' p = ' num2str(ABCDp)])
% % axis square
% % 
% % sINLRsig=cell(size(pNeurons,1),1);
% % sINLRsig(:)={'NS'};
% % sINLRsig(pNeurons<5)={'Info Sig'};
% % sINLRsig(pNeuronsLR<5)={'Side Sig'};
% % sINLRsig(pNeurons<5&pNeuronsLR<5)={'Both Sig'};
% % 
% % ax4=nsubplot(1,4,1,4);
% % gscatter(sNeuronAreas(:,1),sNeuronAreasLR(:,1),sINLRsig,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% % plot(ax4,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% % plot(ax4,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% % xlabel('Info-NoInfo')
% % ylabel('Left-Right')
% % xlim([-2 2])
% % ylim([-2 2])
% % axis square
% % 
% % title(['Correlation = ' num2str(sINLRcorr) ' p = ' num2str(sINLRp)])
% % 
% % ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% % text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% % saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_SigCell_correlations']),'pdf');
% % 
% % %% SHUFFLE TRIAL TYPES WITHIN EACH EVENT AND CALC SIG CELLS AND PCs
% % 
% % %% CURRENT ANALYSES (PCA, decoding, heatmaps, pop mean activity)
% % 
% % %% DESIRED
% % 
% % % wrap conditions around the whole thing?? do this for each condition?
% % 
% % % only learning comparisons don't concat across mice? because can't pull
% % % conditions (days) back out from conditional activity without a vector each time
% % % (can do this separately)
% % 
% % % need to add A vs C, B vs D, delay activity (decoding time), plots for
% % % leaving, power/pop
% % 
% % %% PCA UNBIASED AND TRAJECTORIES??
% % %% POPULATION DISTANCE BETWEEN CONDITIONS?
% % %% DEMIXED PCA
% % 
% % % need for all mice (concat) mean across iStart:iStop by trial type (I,N,L,R) within
% % % condition(s)
% % 
% % % FOR SIGNIFICANT COEFFICIENTS
% % 
% % %% DECODING
% % 
% % % need cells x mean across i1:i2 x relevant trial types (within condition), shuffle the trial
% % % types
% % 
% % % trials x cells
% % 
% % %% LARRY SIG CELLS
% % 
% % % take mean Info-mean No Info for each cell. Sig if absdiff>mean diff 1000
% % % shuffles
% % 
% % % The rest of the analysis does not rely either on PCA or on decoding.  I just average the rI and rN data over time and, for each neuron, compute the absolute value of the difference in these temporal means.  In other words, this is just a simple measure of how different the responses are on the two types of trials.  The individual neuron plots below are rI and rN for the neurons with the 15 biggest mean differences.
% % % 
% % % To get a p value, I randomly scrambled the data across trials and repeated the above analysis.  I did this either 1000 or 10000 times to get a large scrambled data set.  I then computed the info minus no info differences in the time averages of the scrambled data.  For each neuron, the p value is the percent of times in the scrambled data that the mean difference is larger (in absolute value) than it was for that cell in the real data.
% % 
% % %% ORIGINAL
% % 
% % % conditional activitity and set up conditions (names). include
% % % entries/exits.
% % % times (ypre ypost)
% % % baselines
% % 
% % % SIG RESPONSE TO EVENT/CONDITION = ROC or ranksum on time-averaged all
% % % trials within cell
% % 
% % % smoothed over time same as above but within each frame t
% % 
% % % active cell, first frame active, # frames active: min p, min ROC, min
% % % frames
% % 
% % % heatmaps, pop means, abs diff, % cells over time and before/after
% % 
% % 
% % %% CORRELATE RT with CENTER ODOR ACTIVITY
% % 
% % y1=a.C_odor1FirstInfoForced;
% % e=3;
% % ypost1 = squeeze(mean(y1(:,a.okt{e},:),2,'omitnan'));
% % yactI=[];
% % y2=a.C_odor1FirstRandForced;
% % ypost2 = squeeze(mean(y2(:,a.okt{e},:),2,'omitnan'));
% % yactNI=[];
% % for m=1:max(a.mouse)
% %    ym1=ypost1(a.mouse==m,:);
% %    ym1=ypost1(a.mouse==m,:);
% %    ym1=mean(ypost1(a.mouse==m,:));
% %    ym1=ym1(~isnan(ym1))';
% %    yactI=[yactI; ym1];
% %    ym2=ypost2(a.mouse==m,:);
% %    ym2=ypost2(a.mouse==m,:);
% %    ym2=mean(ypost2(a.mouse==m,:));
% %    ym2=ym2(~isnan(ym2))';
% %    yactNI=[yactNI; ym2];   
% % end
% % 
% % [r2I,pI]=corr(yactI,a.rxn(a.imagingChoice==1))
% % [r2NI,pNI]=corr(yactNI,a.rxn(a.imagingChoice==3))
% % 
% % %%
% % figure()
% % fig=gcf;
% % fig.PaperUnits = 'inches';
% % fig.PaperPosition = [0 0 11 8.5];
% % set(fig,'PaperOrientation','landscape');
% % ax1=nsubplot(1,2,1,1);
% % scatter(a.rxn(a.imagingChoice==1),yactI)
% % % plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% % % plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% % xlabel('Reaction Time')
% % ylabel('Mean Population Activity')
% % xlim([0.2 1.2])
% % ylim([0 1])
% % axis square
% % title(['Information Forced, Correlation = ' num2str(r2I) ' p = ' num2str(pI)])
% % 
% % ax1=nsubplot(1,2,1,2);
% % scatter(a.rxn(a.imagingChoice==3),yactNI)
% % % plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% % % plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% % xlabel('Reaction Time')
% % ylabel('Mean Population Activity')
% % xlim([0.2 1.2])
% % ylim([0 1])
% % axis square
% % 
% % title(['No Information Forced, Correlation = ' num2str(r2NI) ' p = ' num2str(pNI)])
% % 
% % saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_RxnCorrelation']),'pdf');
% %     eTest(jj) = mean(errTest);
% %     clear y_info y_rand
% % end
% % 
% % decodeErrorC(m,:)=100-eTest;
% % numChoice(m,1)=x_size;
% % 
% % end
% % 
% % % decodeError=100-decodeError;
% % % decodeError=decodeErrorLoss;
% % % decodeErrorLoss=decodeError;
% % % decodeError=1-decodeError;
% % 
% % SEM = std(decodeErrorC)/sqrt(length(decodeErrorC));               % Standard Error
% % ts = tinv([0.025  0.975],length(decodeErrorC)-1);      % T-Score
% % interval(1,:) = ts(1)*SEM;
% % interval(2,:) = ts(2)*SEM; 
% % preError=mean(decodeErrorC(:,5:8),2);
% % postError=mean(decodeErrorC(:,9:12),2);
% % pDecode=signrank(preError,postError,'tail','left');
% % 
% % % DECODING PLOT
% % 
% % figure();
% % fig = gcf;
% % fig.PaperUnits = 'inches';
% % fig.PaperPosition = [1 1 10 7];
% %     set(fig,'PaperOrientation','landscape');
% % set(fig,'renderer','painters')
% % ax=nsubplot(1,1,1,1);
% % hold on;
% % h_for_legend=[];
% % for m=1:numel(okMice)
% % h_for_legend(end+1)=plot(ax,t,decodeErrorC(m,:),'linewidth',2,'marker','o','MarkerFaceColor',[.8 .8 .8]);
% % decodeleg{m,1}=[mice{m} ' n=' num2str(numChoice(m,1))];
% % end
% % plot(ax,t,mean(decodeErrorC),'color',a.purple,'linewidth',4,'marker','o','MarkerFaceColor','k');
% % errorbar(t,mean(decodeErrorC),interval(1,:),interval(2,:),"ok","MarkerSize",5,'MarkerFaceColor',a.purple,"CapSize",20,'LineWidth',4,'Color',a.purple)
% % plot([0+PID 0+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor On
% % plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor Off
% % plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'color',[.8 .8 .8],'linewidth',2,'yliminclude','off') % Side Odor on
% % plot([-1 +1].*10^10,[50 50],'color',[.8 .8 .8],'linewidth',2,'xliminclude','off') 
% % xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% % xticks2 = xticks2 + PID;
% % xticks(xticks2);
% % xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% % set(gca, 'XTickLabel', xticklabels2);
% % xlim([-0.5+PID 2])
% % hold off;
% % %     xlim([0 80])
% % % ylim([40 100])
% % xlabel('decoding time (s)')
% % ylabel('decoding accuracy')
% % leg = legend(h_for_legend,decodeleg,'Orientation','horizontal','Location','southoutside','Box','off');
% % leg.FontSize = 6;
% % title([strjoin(mice,' _ ') ' decoding Choice Info vs Choice No Info at ' decodeEvent ' p=' num2str(pDecode)]);
% % % saveas(fig,fullfile(output_dir,[mice{m},'_',strjoin(days{m}),'_',allconditions,'_decodingPERMOUSE_', decodeName,'_',decodeEvent]),'pdf');        
% % saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_CHOICEBYMOUSE_' decodeEvent]),'pdf');
% % 
% % %% DECODING INFO VS No INFO SIDE ODOR BY MOUSE NEW DECODER
% % 
% % % uses matrix trials x cells
% % 
% % % PARAMS
% % event = 'C_odor2'; % to decode around first presentation of center odor
% % decodeEvent='Side Odor Info v Rand';
% % decode=1;
% % decodeName='Odor2';
% % e=3;
% % nOut= 20;
% % nTest = 100;
% % i1List = 1:5:76;
% % t=a.t{e}(i1List+2);
% % eTest = zeros(length(i1List),1);
% % i1=50;
% % i2=54;
% % 
% % for m=1:numel(mice)
% % 
% % for jj=1:length(i1List)
% %     i1 = i1List(jj);
% %     i2 = i1+4;
% %     % trials x cells
% % %     xx_info=cat(3,a.C_odor1FirstInfoForced(a.mouse==m,i1:i2,:),a.C_odor1FirstInfoChoice(a.mouse==m,i1:i2,:));
% %     x_info=squeeze(mean(a.C_odor2info(a.mouse==m,i1:i2,:),2,'omitnan'))';
% %     x_info=x_info(~isnan(x_info(:,1)),:);
% %     x_rand=squeeze(mean(a.C_odor2rand(a.mouse==m,i1:i2,:),2,'omitnan'))';
% %     x_rand=x_rand(~isnan(x_rand(:,1)),:);
% %     
% %     x_size=min([size(x_info,1) size(x_rand,1)]);
% %     
% %     xx1=randperm(size(x_info,1));
% %     xx2=randperm(size(x_rand,1));
% %     x_info=x_info(xx1,:);
% %     x_rand=x_rand(xx2,:);
% %     x_info=x_info(1:x_size,:);
% %     x_rand=x_rand(1:x_size,:);
% %     
% %     x=[x_info; x_rand];    
% % 
% %     y_info=ones(x_size,1);
% %     y_rand=ones(x_size,1)*-1;
% %     y=[y_info;y_rand];
% % 
% %     nTrial = size(x,1);
% %     nRand=size(x_rand,1);
% %     
% %     % set up classifier
% %     % cross valiation tests
% %     errTest = zeros(nTest,1);
% %     for i=1:nTest
% %         ii = randperm(nTrial);
% %         iTest = ii(1:nOut);
% %         iT = randperm(nTrial);
% %         xx = x(iT,:);
% %         yy = y(iT,:);
% %         xTest = xx(iTest,:);
% %         yTest = yy(iTest);
% %         xx(iTest,:) = [];
% %         yy(iTest,:) = [];
% %         svmInfo2 = fitclinear(xx,yy);
% %         errTest(i)=100*sum((yTest.*(xTest*svmInfo2.Beta+svmInfo2.Bias)<0))/nOut;
% %     end
% %     eTest(jj) = mean(errTest);
% %     clear y_info y_rand
% % end
% % 
% % decodeErrorABCD(m,:)=100-eTest;
% % 
% % end
% % 
% % % decodeError=100-decodeError;
% % 
% % SEM = std(decodeErrorABCD)/sqrt(length(decodeErrorABCD));               % Standard Error
% % ts = tinv([0.025  0.975],length(decodeErrorABCD)-1);      % T-Score
% % interval(1,:) = ts(1)*SEM;
% % interval(2,:) = ts(2)*SEM;
% % preError=mean(decodeErrorABCD(:,5:8),2);
% % postError=mean(decodeErrorABCD(:,9:12),2);
% % pDecode=signrank(preError,postError,'tail','left');
% % 
% % % DECODING PLOT
% % 
% % figure();
% % fig = gcf;
% % fig.PaperUnits = 'inches';
% % fig.PaperPosition = [1 1 10 7];
% %     set(fig,'PaperOrientation','landscape');
% % set(fig,'renderer','painters')
% % ax=nsubplot(1,1,1,1);
% % hold on;
% % for m=1:numel(okMice)
% % plot(ax,t,decodeErrorABCD(m,:),'color','b','linewidth',1,'marker','o','MarkerFaceColor','b');
% % end
% % plot(ax,t,mean(decodeErrorABCD),'color','k','linewidth',4,'marker','o','MarkerFaceColor','k');
% % errorbar(t,mean(decodeErrorABCD),interval(1,:),interval(2,:),"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
% % plot([0+PID 0+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor On
% % plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor Off
% % plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'color',[.8 .8 .8],'linewidth',2,'yliminclude','off') % Side Odor on
% % 
% % xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% % xticks2 = xticks2 + PID;
% % xticks(xticks2);
% % xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% % set(gca, 'XTickLabel', xticklabels2);
% % plot([0.075 0.075], ylim, '--r');
% % xlim([-0.5+PID 2])
% % hold off;
% % %     xlim([0 80])
% % % ylim([0 100])
% % xlabel('decoding time (s)')
% % ylabel('decoding accuracy')
% % title([strjoin(mice,' _ ') ' decoding Info AB vs No Info CD at ' decodeEvent ' p=' num2str(pDecode)]);
% % % saveas(fig,fullfile(output_dir,[mice{m},'_',strjoin(days{m}),'_',allconditions,'_decodingPERMOUSE_', decodeName,'_',decodeEvent]),'pdf');        
% % saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_ABvCDBYMOUSE_' decodeEvent]),'pdf');
% % 
% % %% DECODING INFO VS No INFO SIDE ODOR BY MOUSE ORIGINAL DECODER
% % 
% % % uses matrix trials x cells
% % 
% % % PARAMS
% % event = 'C_odor2'; % to decode around first presentation of center odor
% % decodeEvent='Side Odor Info v Rand';
% % decode=1;
% % decodeName='Odor2';
% % e=3;
% % nOut= 20;
% % nTest = 100;
% % i1List = 1:5:76;
% % t=a.t{e}(i1List+2);
% % eTest = zeros(length(i1List),1);
% % i1=50;
% % i2=54;
% % 
% % for m=1:numel(mice)
% % 
% % for jj=1:length(i1List)
% %     i1 = i1List(jj);
% %     i2 = i1+4;
% %     % trials x cells
% % %     xx_info=cat(3,a.C_odor1FirstInfoForced(a.mouse==m,i1:i2,:),a.C_odor1FirstInfoChoice(a.mouse==m,i1:i2,:));
% %     x_info=squeeze(mean(a.C_odor2info(a.mouse==m,i1:i2,:),2,'omitnan'))';
% %     x_info=x_info(~isnan(x_info(:,1)),:);
% %     x_rand=squeeze(mean(a.C_odor2rand(a.mouse==m,i1:i2,:),2,'omitnan'))';
% %     x_rand=x_rand(~isnan(x_rand(:,1)),:);
% %     
% %     x_size=min([size(x_info,1) size(x_rand,1)]);
% %     
% %     xx1=randperm(size(x_info,1));
% %     xx2=randperm(size(x_rand,1));
% %     x_info=x_info(xx1,:);
% %     x_rand=x_rand(xx2,:);
% %     x_info=x_info(1:x_size,:);
% %     x_rand=x_rand(1:x_size,:);
% %     
% %     x=[x_info; x_rand];    
% % 
% %     y_info=ones(x_size,1);
% %     y_rand=ones(x_size,1)*-1;
% %     y=[y_info;y_rand];
% % 
% %     nTrial = size(x,1);
% %     nRand=size(x_rand,1);
% %     
% %     % set up classifier
% %     % cross valiation tests
% %     errTest = zeros(nTest,1);
% %     for i=1:nTest
% %         ii = randperm(nTrial);
% %         iTest = ii(1:nOut);
% %         iT = randperm(nTrial);
% %         xx = x(iT,:);
% %         yy = y(iT,:);
% %         xTest = xx(iTest,:);
% %         yTest = yy(iTest);
% %         xx(iTest,:) = [];
% %         yy(iTest,:) = [];
% % %         svmInfoF{m} = fitclinear(xx,yy);
% %         errTest(i)=100*sum((yTest.*(xTest*svmInfoF{m}.Beta+svmInfoF{m}.Bias)<0))/nOut;
% %     end
% %     eTest(jj) = mean(errTest);
% %     clear y_info y_rand
% % end
% % 
% % decodeErrorABCD(m,:)=100-eTest;
% % 
% % end
% % 
% % % decodeError=100-decodeError;
% % 
% % SEM = std(decodeErrorABCD)/sqrt(length(decodeErrorABCD));               % Standard Error
% % ts = tinv([0.025  0.975],length(decodeErrorABCD)-1);      % T-Score
% % interval(1,:) = ts(1)*SEM;
% % interval(2,:) = ts(2)*SEM;
% % preError=mean(decodeErrorABCD(:,5:8),2);
% % postError=mean(decodeErrorABCD(:,9:12),2);
% % pDecode=signrank(preError,postError,'tail','left');
% % 
% % % DECODING PLOT
% % 
% % figure();
% % fig = gcf;
% % fig.PaperUnits = 'inches';
% % fig.PaperPosition = [1 1 10 7];
% %     set(fig,'PaperOrientation','landscape');
% % set(fig,'renderer','painters')
% % ax=nsubplot(1,1,1,1);
% % hold on;
% % for m=1:numel(okMice)
% % plot(ax,t,decodeErrorABCD(m,:),'color','b','linewidth',1,'marker','o','MarkerFaceColor','b');
% % end
% % plot(ax,t,mean(decodeErrorABCD),'color','k','linewidth',4,'marker','o','MarkerFaceColor','k');
% % errorbar(t,mean(decodeErrorABCD),interval(1,:),interval(2,:),"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
% % plot([0+PID 0+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor On
% % plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'k','linewidth',2,'yliminclude','off') % Center Odor Off
% % plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'color',[.8 .8 .8],'linewidth',2,'yliminclude','off') % Side Odor on
% % 
% % xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% % xticks2 = xticks2 + PID;
% % xticks(xticks2);
% % xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% % set(gca, 'XTickLabel', xticklabels2);
% % plot([0.075 0.075], ylim, '--r');
% % xlim([-0.5+PID 2])
% % hold off;
% % %     xlim([0 80])
% % % ylim([0 100])
% % xlabel('decoding time (s)')
% % ylabel('decoding accuracy')
% % title([strjoin(mice,' _ ') ' decoding Info AB vs No Info CD at ' decodeEvent ' p=' num2str(pDecode)]);
% % % saveas(fig,fullfile(output_dir,[mice{m},'_',strjoin(days{m}),'_',allconditions,'_decodingPERMOUSE_', decodeName,'_',decodeEvent]),'pdf');        
% % saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_ABvCDBYMOUSE_ORIGDECODER_' decodeEvent]),'pdf');
% % 
% % 
% % %%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% % %% SIDE ODOR PCA
% % %%%%%%%%%%%%%%%%%%%%%
% % 
% % iStart = 40;
% % iStop = 56;
% % 
% % % a_idx=find(a.imagingCorr==1&a.imagingOdor2==1&a.imageTrialType~=1);
% % % b_idx=find(a.imagingCorr==1&a.imagingOdor2==2&a.imageTrialType~=1);
% % % minTrials = min([numel(a_idx),numel(b_idx)]);
% % % a_idx=a_idx(randperm(minTrials));
% % % b_idx=b_idx(randperm(minTrials));
% % % xab=a.(event)(:,iStart:iStop,[a_idx; b_idx]);
% % % odor2ab=a.imagingOdor2([a_idx; b_idx]);
% % % 
% % % Nab=size(xab,1);
% % 
% % % rA = mean(xab(:,:,odor2ab==1),3); % side odor A
% % % rB = mean(xab(:,:,odor2ab==2),3); % side odor B
% % % rA = mean(a.(event)(:,iStart:iStop,a.imagingCorr==1&a.imagingOdor2==1&a.imageTrialType==2),3);
% % % rB = mean(a.(event)(:,iStart:iStop,a.imagingCorr==1&a.imagingOdor2==2&a.imageTrialType==2),3);
% % 
% % rA = mean(a.C_odor2A(:,iStart:iStop,:),3,'omitnan');
% % rB = mean(a.C_odor2B(:,iStart:iStop,:),3,'omitnan');
% % 
% % rA=rA-rA(:,1);
% % rB=rB-rB(:,1);
% % 
% % rAB = rA-rB;
% % 
% % % c_idx=find(a.imagingCorr==1&a.imagingOdor2==4&a.imageTrialType~=1);
% % % d_idx=find(a.imagingCorr==1&a.imagingOdor2==3&a.imageTrialType~=1);
% % % minTrialsCD = min([numel(c_idx),numel(d_idx)]);
% % % c_idx=c_idx(randperm(minTrialsCD));
% % % d_idx=d_idx(randperm(minTrialsCD));
% % % xcd=a.(event)(:,iStart:iStop,[c_idx; d_idx]);
% % % odor2cd=a.imagingOdor2([c_idx; d_idx]);
% % % 
% % % rC = mean(xcd(:,:,odor2cd==4),3); % side odor C
% % % rD = mean(xcd(:,:,odor2cd==3),3); % side odor D
% % 
% % rC = mean(a.C_odor2C(:,iStart:iStop,:),3,'omitnan');
% % rD = mean(a.C_odor2D(:,iStart:iStop,:),3,'omitnan');
% % 
% % rC=rC-rC(:,1);
% % rD=rD-rD(:,1);
% % 
% % rCD = rC-rD;
% % 
% % [UAB SAB VAB] = svd(rAB);
% % LAB = diag(SAB).^2;
% % LAB = 100*LAB/sum(LAB);
% % [UABSort iABSort] = sort(UAB(:,1),'descend');
% % 
% % [UCD SCD VCD] = svd(rCD);
% % LCD = diag(SCD).^2;
% % LCD = 100*LCD/sum(LCD);
% % [UCDSort iCDSort] = sort(UCD(:,1),'descend');
% % 
% % PCAreaAB = abs(mean(UAB(:,1)'*rAB));
% % sNeuronAreasAB = mean(rAB,2);
% % NeuronAreasAB = abs(sNeuronAreasAB);
% % [ASortAB iASortAB] = sort(NeuronAreasAB,'descend');
% % [sASortAB isASortAB] = sort(sNeuronAreasAB,'descend');
% % 
% % pPCAB = 100*sum(randPCAreaAB>PCAreaAB)/nRuns
% % pNeuronsAB = zeros(N,1);
% % for i=1:N
% %     pNeuronsAB(i) = 100*sum((randNeuronAreasAB(:)>NeuronAreasAB(i))) ...
% %         /length(randNeuronAreasAB(:));
% % end
% % nSigAB  = sum(pNeuronsAB<5)'
% % 
% % PCAreaCD = abs(mean(UCD(:,1)'*rCD));
% % sNeuronAreasCD = mean(rCD,2);
% % NeuronAreasCD = abs(sNeuronAreasCD);
% % [ASortCD iASortCD] = sort(NeuronAreasCD,'descend');
% % [sASortCD isASortCD] = sort(sNeuronAreasCD,'descend');
% % 
% % pPCCD = 100*sum(randPCAreaCD>PCAreaCD)/nRuns
% % pNeuronsCD = zeros(N,1);
% % for i=1:N
% %     pNeuronsCD(i) = 100*sum((randNeuronAreasCD(:)>NeuronAreasCD(i))) ...
% %         /length(randNeuronAreasCD(:));
% % end
% % nSigCD  = sum(pNeuronsCD<5)'
% % 
% % save('pStats','nSig','pPC', 'pNeurons','nSigLR','pPCLR', 'pNeuronsLR','nSigAB','nSigCD','pPCAB', 'pNeuronsAB','pPCCD', 'pNeuronsCD');
% % 
% % %%
% % 
% % rAvar = rA - mean(rA,2);
% % rBvar = rB - mean(rB,2);
% % rABvar = rAvar-rBvar;
% % [UABvar SABvar VABvar] = svd(rABvar);
% % percentVarAB = 100*(var(rAvar'*UABvar(:,1))+var(rBvar'*UABvar(:,1)))/ ...
% %                     (sum(var(rAvar'))+sum(var(rBvar')))
% % 
% % rCvar = rC - mean(rC,2);
% % rDvar = rD - mean(rD,2);
% % rCDvar = rCvar-rDvar;
% % [UCDvar SCDvar VCDvar] = svd(rCDvar);
% % percentVarCD = 100*(var(rCvar'*UCDvar(:,1))+var(rDvar'*UCDvar(:,1)))/ ...
% %                     (sum(var(rCvar'))+sum(var(rDvar')))
% % 
% % 
% % %% DECODING SIDE ODORS
% % 
% % decodeEvent='Side Odor';
% % e=6;
% % 
% % nTest = 100;
% % i1List = 1:5:76;
% % eTest = zeros(length(i1List),1);
% % 
% % t=a.t{e}(i1List+2);
% % 
% % minA=min(nmA(okMice));
% % minB=min(nmB(okMice));
% % minC=min(nmC(okMice));
% % minD=min(nmD(okMice));
% % 
% % m=1;
% % xA=[];xB=[];xC=[];xD=[];
% % ms=okMice;
% % for mm=1:numel(okMice)
% %     m=ms(mm);
% %     mA=a.C_odor2A(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmA(m));
% %     rnA=randperm(nmA(m));
% %     xA=cat(1,xA,mA(:,:,rnA(1:minA)));
% %     mB=a.C_odor2B(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmB(m));
% %     rnB=randperm(nmB(m));
% %     xB=cat(1,xB,mB(:,:,rnB(1:minB)));
% %     mC=a.C_odor2C(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmC(m));
% %     rnC=randperm(nmC(m));
% %     xC=cat(1,xC,mC(:,:,rnC(1:minC)));
% %     mD=a.C_odor2D(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmD(m));
% %     rnD=randperm(nmD(m));
% %     xD=cat(1,xD,mD(:,:,rnD(1:minD)));    
% % end
% % 
% % %%
% % decode=2;
% % for decode = 1:2
% % 
% % i1=50;
% % i2=54;
% %     for jj=1:length(i1List)
% %         i1 = i1List(jj);
% %         i2 = i1+4;
% %         xAt=squeeze(mean(xA(:,i1:i2,:),2))'; % trials by cells?
% %         xBt=squeeze(mean(xB(:,i1:i2,:),2))';
% %         xCt=squeeze(mean(xC(:,i1:i2,:),2))';
% %         xDt=squeeze(mean(xD(:,i1:i2,:),2))';
% %          
% %         if decode == 1
% %             decodeName='AB';
% %             ixB=randperm(size(xBt,1));
% %             xBt=xBt(ixB(1:size(xAt,1)),:);
% %             x=[xAt;xBt];
% %             nTrial = size(x,1);
% %             nOut = round(0.2*nTrial);
% %             y1=ones(size(xAt,1),1).*1;
% %             y2=ones(size(xBt,1),1).*-1;   
% %         else
% %             decodeName='CD';
% %             ixC=randperm(size(xCt,1));
% %             xCt=xCt(ixC(1:size(xDt,1)),:);
% %             x=[xCt;xDt];
% %             nTrial = size(x,1);
% %             nOut = round(0.2*nTrial);
% %             y1=ones(size(xCt,1),1).*1;
% %             y2=ones(size(xDt,1),1).*-1;            
% %         end
% %         
% %         y=cat(1,y1,y2);
% %                
% % %         set up classifier
% % %         cross valiation tests
% %         errTest = zeros(nTest,1);
% %         for i=1:nTest
% %             ip = randperm(nTrial);
% %             iTest = ip(1:nOut);
% %             iT = randperm(nTrial);
% %             xx = x(iT,:);
% %             yy = y(iT,:);
% %             xTest = xx(iTest,:);
% %             yTest = yy(iTest);
% %             xx(iTest,:) = [];
% %             yy(iTest,:) = [];
% %             svmTest = fitclinear(xx,yy);
% %             errTest(i)=100*sum((yTest.*(xTest*svmTest.Beta+svmTest.Bias)<0))/nOut;
% %         end
% %         testErrors{jj}=errTest;
% %         eTest(jj) = mean(errTest);
% %         decodeweights{decode}(:,jj)=svmTest.Beta;        
% %     end    
% % %     if decode==1
% % %         [weightsSorted(:,decode),cellsByWeights(:,decode)]=sort(weights{decode}(:,11),'descend');
% % %     end
% %     
% % % PLOTTING
% % 
% %     figure();
% %     fig = gcf;
% %     fig.PaperUnits = 'inches';
% %     fig.PaperPosition = [1 1 10 7];
% %         set(fig,'PaperOrientation','landscape');
% %     set(fig,'renderer','painters');
% %     ax=nsubplot(1,1,1,1);
% %     plot(ax,t,eTest);
% %     hold on;
% %     plot([-1 +1].*10^10,[50 50],'k','linewidth',2,'xliminclude','off')
% %     plot([0 0],[0 55],'r','linewidth',2) % Center Odor On
% %     plot([0.2 0.2],[0 55],'r','linewidth',2) % Center Odor Off
% %     plot([1.45 1.45],[0 55],'color',[.8 .8 .8],'linewidth',2) % Side Odor on
% %     hold off;
% % %     xlim([0 80])
% %     ylim([0 55])
% %     xlabel('decoding time (s)')
% %     ylabel('decoding error')
% %     title([strjoin(mice,' _ ') ' decoding ' decodeName ' at ' decodeEvent]);
% %     saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_decoding_' decodeName '_' decodeEvent]),'pdf');
% % 
% % end
% % %% FIGURE 10 CORRELATIONS
% % 
% % [INABPCcorr, INABPCp] =corr(UIN(:,1),UAB(:,1));
% % [ABCDPCcorr, ABCDPCp]=corr(UAB(:,1),UCD(:,1));
% % 
% % figure()
% % fig=gcf;
% % fig.PaperUnits = 'inches';
% % fig.PaperPosition = [0 0 11 8.5];
% % set(fig,'PaperOrientation','landscape');
% % ax1=nsubplot(1,2,1,1);
% % plot(UAB(:,1),UIN(:,1),'bo','linewidth',1)
% % plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% % plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% % xlabel('A-B Weight')
% % ylabel('Info-NoInfo Weight')
% % xlim([-0.5 0.5])
% % ylim([-0.5 0.5])
% % axis square
% % 
% % title(['Correlation = ' num2str(INABPCcorr) ' p = ' num2str(INABPCp)])
% % 
% % ax2=nsubplot(1,2,1,2);
% % plot(UAB(:,1),UCD(:,1),'bo','linewidth',1)
% % plot(ax2,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% % plot(ax2,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% % xlabel('A-B Weight')
% % ylabel('C-D Weight')
% % xlim([-0.5 0.5])
% % ylim([-0.5 0.5])
% % title(['Correlation = ' num2str(ABCDPCcorr) ' p = ' num2str(ABCDPCp)])
% % axis square
% % 
% % ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% % text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% % saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_Side_correlations']),'pdf');
% % 
% % %% FIGURE 11 CORRELATIONS
% % 
% % % sNeuronAreas = mean difference for each cell
% % % pNeurons<5 = diff significant
% % 
% % [INLRcorr, INLRp] = corr(NeuronAreas,NeuronAreasLR)
% % [sINLRcorr, sINLRp] = corr(sNeuronAreas,sNeuronAreasLR)
% % [INABcorr, INABp] = corr(sNeuronAreas,sNeuronAreasAB)
% % [ABCDcorr, ABCDp] = corr(sNeuronAreasAB,-1*sNeuronAreasCD)
% % 
% % 
% % figure()
% % fig=gcf;
% % fig.PaperUnits = 'inches';
% % fig.PaperPosition = [0 0 11 8.5];
% % set(fig,'PaperOrientation','landscape');
% % 
% % INLRsig=cell(size(pNeurons,1),1);
% % INLRsig(:)={'NS'};
% % INLRsig(pNeurons<5)={'Info Sig'};
% % INLRsig(pNeuronsLR<5)={'Side Sig'};
% % INLRsig(pNeurons<5&pNeuronsLR<5)={'Both Sig'};
% % 
% % ax1=nsubplot(1,4,1,1);
% % gscatter(NeuronAreas(:,1),NeuronAreasLR(:,1),INLRsig,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% % % plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% % % plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% % xlabel('abs Info-NoInfo')
% % ylabel('abs Left-Right')
% % % xlim([-2 2])
% % ylim([0 2])
% % axis square
% % 
% % title(['Correlation = ' num2str(INLRcorr) ' p = ' num2str(INLRp)])
% % 
% % INABsig=cell(size(pNeurons,1),1);
% % INABsig(:)={'NS'};
% % INABsig(pNeurons<5)={'Info Sig'};
% % INABsig(pNeuronsAB<5)={'AB Sig'};
% % INABsig(pNeurons<5&pNeuronsAB<5)={'Both Sig'};
% % 
% % ax2=nsubplot(1,4,1,2);
% % gscatter(sNeuronAreas(:,1),sNeuronAreasAB(:,1),INABsig,[0.8 0.8 0.8;0 1 0;0 0 1;1 0 0;],'.',15)
% % plot(ax2,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% % plot(ax2,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% % xlabel('Info-No Info')
% % ylabel('A-B')
% % xlim([-2 2])
% % ylim([-2 2])
% % title(['Correlation = ' num2str(INABcorr) ' p = ' num2str(INABp)])
% % axis square
% % 
% % ABCDsig=cell(size(pNeurons,1),1);
% % ABCDsig(:)={'NS'};
% % ABCDsig(pNeuronsAB<5)={'AB Sig'};
% % ABCDsig(pNeuronsCD<5)={'CD Sig'};
% % ABCDsig(pNeuronsAB<5&pNeuronsCD<5)={'Both Sig'};
% % 
% % ax3=nsubplot(1,4,1,3);
% % gscatter(sNeuronAreasAB(:,1),sNeuronAreasCD(:,1)*-1,ABCDsig,[0.8 0.8 0.8;0 1 0;0 0 1;1 0 0;],'.',15)
% % plot(ax3,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% % plot(ax3,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% % xlabel('A-B')
% % ylabel('D-C')
% % xlim([-2 2])
% % ylim([-2 2])
% % title(['Correlation = ' num2str(ABCDcorr) ' p = ' num2str(ABCDp)])
% % axis square
% % 
% % sINLRsig=cell(size(pNeurons,1),1);
% % sINLRsig(:)={'NS'};
% % sINLRsig(pNeurons<5)={'Info Sig'};
% % sINLRsig(pNeuronsLR<5)={'Side Sig'};
% % sINLRsig(pNeurons<5&pNeuronsLR<5)={'Both Sig'};
% % 
% % ax4=nsubplot(1,4,1,4);
% % gscatter(sNeuronAreas(:,1),sNeuronAreasLR(:,1),sINLRsig,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% % plot(ax4,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% % plot(ax4,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% % xlabel('Info-NoInfo')
% % ylabel('Left-Right')
% % xlim([-2 2])
% % ylim([-2 2])
% % axis square
% % 
% % title(['Correlation = ' num2str(sINLRcorr) ' p = ' num2str(sINLRp)])
% % 
% % ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% % text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% % saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_SigCell_correlations']),'pdf');
% % 
% % %% SHUFFLE TRIAL TYPES WITHIN EACH EVENT AND CALC SIG CELLS AND PCs
% % 
% % %% CURRENT ANALYSES (PCA, decoding, heatmaps, pop mean activity)
% % 
% % %% DESIRED
% % 
% % % wrap conditions around the whole thing?? do this for each condition?
% % 
% % % only learning comparisons don't concat across mice? because can't pull
% % % conditions (days) back out from conditional activity without a vector each time
% % % (can do this separately)
% % 
% % % need to add A vs C, B vs D, delay activity (decoding time), plots for
% % % leaving, power/pop
% % 
% % %% PCA UNBIASED AND TRAJECTORIES??
% % %% POPULATION DISTANCE BETWEEN CONDITIONS?
% % %% DEMIXED PCA
% % 
% % % need for all mice (concat) mean across iStart:iStop by trial type (I,N,L,R) within
% % % condition(s)
% % 
% % % FOR SIGNIFICANT COEFFICIENTS
% % 
% % %% DECODING
% % 
% % % need cells x mean across i1:i2 x relevant trial types (within condition), shuffle the trial
% % % types
% % 
% % % trials x cells
% % 
% % %% LARRY SIG CELLS
% % 
% % % take mean Info-mean No Info for each cell. Sig if absdiff>mean diff 1000
% % % shuffles
% % 
% % % The rest of the analysis does not rely either on PCA or on decoding.  I just average the rI and rN data over time and, for each neuron, compute the absolute value of the difference in these temporal means.  In other words, this is just a simple measure of how different the responses are on the two types of trials.  The individual neuron plots below are rI and rN for the neurons with the 15 biggest mean differences.
% % % 
% % % To get a p value, I randomly scrambled the data across trials and repeated the above analysis.  I did this either 1000 or 10000 times to get a large scrambled data set.  I then computed the info minus no info differences in the time averages of the scrambled data.  For each neuron, the p value is the percent of times in the scrambled data that the mean difference is larger (in absolute value) than it was for that cell in the real data.
% % 
% % %% ORIGINAL
% % 
% % % conditional activitity and set up conditions (names). include
% % % entries/exits.
% % % times (ypre ypost)
% % % baselines
% % 
% % % SIG RESPONSE TO EVENT/CONDITION = ROC or ranksum on time-averaged all
% % % trials within cell
% % 
% % % smoothed over time same as above but within each frame t
% % 
% % % active cell, first frame active, # frames active: min p, min ROC, min
% % % frames
% % 
% % % heatmaps, pop means, abs diff, % cells over time and before/after
% 
% 
%% CORRELATE RT with CENTER ODOR ACTIVITY

mouseCells=histc(a.mouse(:),unique(a.mouse));
mouseCellCts=[0; cumsum(mouseCells)];
trialsM=sum(~isnan(a.C_events{3}(cumsum(mouseCells),1,:)),3);
trialCts=[0;cumsum(trialsM)];

y1=a.C_odor1FirstInfoForced;
e=3;
ypost1 = squeeze(mean(y1(:,a.okt{e},:),2,'omitnan'));
yactI=[];
y2=a.C_odor1FirstRandForced;
ypost2 = squeeze(mean(y2(:,a.okt{e},:),2,'omitnan'));
yactNI=[];
rxnI=[];
rxnN=[];
for m=1:max(a.mouse)
%    ym1=ypost1(a.mouse==m,:);
   ym1=mean(ypost1(a.mouse==m,:));
   ym1=ym1(~isnan(ym1))';
   yactI=[yactI; ym1];
%    ym2=ypost2(a.mouse==m,:);
%    ym2=ypost2(a.mouse==m,:);
   ym2=mean(ypost2(a.mouse==m,:));
   ym2=ym2(~isnan(ym2))';
   yactNI=[yactNI; ym2];
   rxnIM=a.rxn(trialCts(m)+1:trialCts(m+1));
   rxnNM=a.rxn(trialCts(m)+1:trialCts(m+1));
   mouseChoice=a.imagingChoice(trialCts(m)+1:trialCts(m+1));
   mousePrevCorr=a.imagingPrevCorrect(trialCts(m)+1:trialCts(m+1));
   mouseInfoRxn=rxnIM(mouseChoice==1&mousePrevCorr==1);
   mouseRandRxn=rxnNM(mouseChoice==3&mousePrevCorr==1);
   rxnI=[rxnI; mouseInfoRxn];
   rxnN=[rxnN; mouseRandRxn];
end

[r2I,pI]=corr(yactI,rxnI)

% [r2I,pI]=corr(yactI,a.rxn(a.imagingChoice==1 & a.imagingPrevCorrect == 1))
[r2NI,pNI]=corr(yactNI,rxnN)

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
scatter(rxnI,yactI)
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Reaction Time')
ylabel('Mean Population Activity')
xlim([0.2 1.2])
ylim([0 1])
axis square
title(['Information Forced, Correlation = ' num2str(r2I) ' p = ' num2str(pI)])

ax1=nsubplot(1,2,1,2);
scatter(rxnN,yactNI)
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Reaction Time')
ylabel('Mean Population Activity')
xlim([0.2 1.2])
ylim([0 1])
axis square

title(['No Information Forced, Correlation = ' num2str(r2NI) ' p = ' num2str(pNI)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_RxnCorrelation']),'pdf');

%%
y1=a.C_odor1FirstInfoForced;
e=3;
ypost1 = squeeze(mean(y1(:,a.okt{e},:),2,'omitnan'));
yactI=[];
y2=a.C_odor1FirstRandForced;
ypost2 = squeeze(mean(y2(:,a.okt{e},:),2,'omitnan'));
yactNI=[];
for m=1:max(a.mouse)
%    ym1=ypost1(a.mouse==m,:);
   ym1=mean(ypost1(a.mouse==m & a.differentCellsEBM(:,12)==1 ,:));
   ym1=ym1(~isnan(ym1))';
   yactI=[yactI; ym1];
%    ym2=ypost2(a.mouse==m,:);
%    ym2=ypost2(a.mouse==m,:);
   ym2=mean(ypost2(a.mouse==m & a.differentCellsEBM(:,12)==1,:));
   ym2=ym2(~isnan(ym2))';
   yactNI=[yactNI; ym2];   
end

[r2I,pI]=corr(yactI,a.rxn(a.imagingChoice==1 & a.imagingPrevCorrect == 1))
[r2NI,pNI]=corr(yactNI,a.rxn(a.imagingChoice==3 & a.imagingPrevCorrect == 1))

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
scatter(a.rxn(a.imagingChoice==1 & a.imagingPrevCorrect == 1),yactI)
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Reaction Time')
ylabel('Mean Population Activity for Info Coding Cells')
xlim([0.2 1.5])
ylim([0 2])
axis square
title(['Information Forced, Correlation = ' num2str(r2I) ' p = ' num2str(pI)])

ax1=nsubplot(1,2,1,2);
scatter(a.rxn(a.imagingChoice==3 & a.imagingPrevCorrect == 1),yactNI)
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Reaction Time')
ylabel('Mean Population Activity  for Info Coding Cells')
xlim([0.2 1.5])
ylim([0 2])
axis square

title(['No Information Forced, Correlation = ' num2str(r2NI) ' p = ' num2str(pNI)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_RxnCorrelationInfoCells']),'pdf');

%%
y1=a.C_odor1FirstInfoForced;
e=3;
ypost1 = squeeze(mean(y1(:,a.okt{e},:),2,'omitnan'));
yactI=[];
y2=a.C_odor1FirstRandForced;
ypost2 = squeeze(mean(y2(:,a.okt{e},:),2,'omitnan'));
yactNI=[];
for m=1:max(a.mouse)
%    ym1=ypost1(a.mouse==m,:);
   ym1=mean(ypost1(a.mouse==m & a.differentCellsEBM(:,2)==1 ,:));
   ym1=ym1(~isnan(ym1))';
   yactI=[yactI; ym1];
%    ym2=ypost2(a.mouse==m,:);
%    ym2=ypost2(a.mouse==m,:);
   ym2=mean(ypost2(a.mouse==m & a.differentCellsEBM(:,2)==1,:));
   ym2=ym2(~isnan(ym2))';
   yactNI=[yactNI; ym2];   
end

[r2I,pI]=corr(yactI,a.rxn(a.imagingChoice==1 & a.imagingPrevCorrect == 1),'Type','Spearman')
[r2NI,pNI]=corr(yactNI,a.rxn(a.imagingChoice==3 & a.imagingPrevCorrect == 1),'Type','Spearman')

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
scatter(a.rxn(a.imagingChoice==1 & a.imagingPrevCorrect == 1),yactI)
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Reaction Time')
ylabel('Mean Population Activity for Info Coding Cells')
xlim([0.2 1.5])
ylim([0 2])
axis square
title(['Information Forced, Correlation = ' num2str(r2I) ' p = ' num2str(pI)])

ax1=nsubplot(1,2,1,2);
scatter(a.rxn(a.imagingChoice==3 & a.imagingPrevCorrect == 1),yactNI)
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Reaction Time')
ylabel('Mean Population Activity  for Info Coding Cells')
xlim([0.2 1.5])
ylim([0 2])
axis square

title(['No Information Forced, Correlation = ' num2str(r2NI) ' p = ' num2str(pNI)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_RxnCorrelationInfoCellsSpearman']),'pdf');

%% Mixture of Gaussians Model

y1=a.C_odor1FirstInfoForced;
e=3;
ypost1 = squeeze(mean(y1(:,a.okt{e},:),2,'omitnan'));
yactI=[];
y2=a.C_odor1FirstRandForced;
ypost2 = squeeze(mean(y2(:,a.okt{e},:),2,'omitnan'));
yactNI=[];
for m=1:max(a.mouse)
%    ym1=ypost1(a.mouse==m,:);
   ym1=mean(ypost1(a.mouse==m & a.differentCellsEBM(:,2)==1 ,:));
   ym1=ym1(~isnan(ym1))';
   yactI=[yactI; ym1];
%    ym2=ypost2(a.mouse==m,:);
%    ym2=ypost2(a.mouse==m,:);
   ym2=mean(ypost2(a.mouse==m & a.differentCellsEBM(:,2)==1,:));
   ym2=ym2(~isnan(ym2))';
   yactNI=[yactNI; ym2];   
end


X=[a.rxn(a.imagingChoice==1 & a.imagingPrevCorrect == 1) yactI];
size(X)

AIC = zeros(1,6);
BIC = zeros(1,6);
GMModels = cell(1,6);
options = statset('MaxIter',500);
for k = 1:6
GMModels{k} = fitgmdist(X,k);
AIC(k)= GMModels{k}.AIC;
BIC(k)= GMModels{k}.BIC;
end
[minBIC,numComponents] = min(BIC);
numComponents

% numComponents = 2; % Adjust based on your data
% gmModel = fitgmdist(X, numComponents);
gmModel=GMModels{numComponents};
% Predict cluster assignments
clusterIdx = cluster(gmModel, X);
% Plot scatter data colored by cluster
scatter(X(:,1), X(:,2), 20, clusterIdx, 'filled');
hold on;
% Overlay Gaussian contours
f = @(x,y) pdf(gmModel, [x y]); % GMM density function
fsurf(f, [min(X(:,1)), max(X(:,1)), min(X(:,2)), max(X(:,2))]);
hold off;
colorbar;
xlabel('X-axis');
ylabel('Y-axis');
title('Gaussian Mixture Model Fit');

gmModel=GMModels{2};
clusterIdx = cluster(gmModel, X);


[r2I1,pI1]=corr(X(clusterIdx==1,2),X(clusterIdx==1,1))
[r2I2,pI2]=corr(X(clusterIdx==2,2),X(clusterIdx==2,1))

[r2I,pI]=corr(yactI,a.rxn(a.imagingChoice==1 & a.imagingPrevCorrect == 1),'Type','Spearman')
% [r2NI,pNI]=corr(yactNI,a.rxn(a.imagingChoice==3 & a.imagingPrevCorrect == 1),'Type','Spearman')

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
scatter(a.rxn(a.imagingChoice==1 & a.imagingPrevCorrect == 1),yactI)
hold on;
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
clusterIdx = cluster(gmModel, X);
% Plot scatter data colored by cluster
scatter(X(:,1), X(:,2), 20, clusterIdx, 'filled');
xlabel('Reaction Time')
ylabel('Mean Population Activity for Info Coding Cells')
xlim([0.2 1.5])
ylim([0 2])
axis square
legend
title(['Information Forced, Correlation = ' num2str(r2I) ' p = ' num2str(pI)])

% ax1=nsubplot(1,2,1,2);
% scatter(a.rxn(a.imagingChoice==3 & a.imagingPrevCorrect == 1),yactNI)
% % plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% % plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% xlabel('Reaction Time')
% ylabel('Mean Population Activity  for Info Coding Cells')
% xlim([0.2 1.5])
% ylim([0 2])
% axis square
% 
% title(['No Information Forced, Correlation = ' num2str(r2NI) ' p = ' num2str(pNI)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_RxnCorrelationInfoCellsGMM']),'pdf');

%% GLM


% Assume these are already loaded or constructed:
% info: [nTrials × 1] binary vector (0 or 1)
% side: [nTrials × 1] categorical or string array ('left', 'right')
% rt:   [nTrials × 1] reaction time vector
% Y:    [nTrials × nNeurons] calcium responses

% y1=a.C_odor1FirstInfoForced;
% e=3;
% ypost1 = squeeze(mean(y1(:,a.okt{e},:),2,'omitnan'));
% y2=a.C_odor1FirstRandForced;
% ypost2 = squeeze(mean(y2(:,a.okt{e},:),2,'omitnan'));
% y=cat(2,ypost1,ypost2)';

mouseCells=histc(a.mouse(:),unique(a.mouse));
mouseCellCts=[0; cumsum(mouseCells)];
trialsM=sum(~isnan(a.C_events{3}(cumsum(mouseCells),1,:)),3);
trialCts=[0;cumsum(trialsM)];

allbetas=[];
allpvals=[];
allRsq=[];

for mm=1:numel(okMice)
        m=okMice(mm);
        mouseChoice=a.imagingChoice(trialCts(m)+1:trialCts(m+1));
        mousePrevCorr=a.imagingPrevCorrect(trialCts(m)+1:trialCts(m+1));
        mouseRxn=a.imagingPrevCorrect(trialCts(m)+1:trialCts(m+1));
        mouseSide=a.infoSide(trialCts(m)+1:trialCts(m+1));
%         mouseInfo=squeeze(mean(a.C_odor1FirstInfoForced(a.mouse==m,a.okt{e},:),2));  
        mouseAct=squeeze(mean(a.C_events{9}(a.mouse==m,a.okt{e},1:trialsM(m)),2));
        
        infoRxn=mouseRxn(mouseChoice==1 & mousePrevCorr==1);
        infoSide=mouseSide(mouseChoice==1 & mousePrevCorr==1);
        infoAct=mouseAct(:,mouseChoice==1 & mousePrevCorr==1);
        
        randRxn=mouseRxn(mouseChoice==3 & mousePrevCorr==1);
        randSide=mouseSide(mouseChoice==3 & mousePrevCorr==1);
        randAct=mouseAct(:,mouseChoice==3 & mousePrevCorr==1);
        
        Y=cat(2,infoAct,randAct)';
        infoCt=ones(size(infoAct,2),1);
        randCt=zeros(size(randAct,2),1);
        info=[infoCt; randCt];
        rxn=[infoRxn; randRxn];
        side=[infoSide; randSide];

    % Combine predictors into a design matrix
    X = [info, side, rxn]; % [nTrials × 3]

    % Add intercept (optional if you use fitglm with default settings)
    % X = [ones(size(X,1),1), X];

    % Initialize outputs
    nNeurons = size(Y, 2);
    betas = NaN(nNeurons, size(X,2));       % coefficients for each predictor
    pvals = NaN(nNeurons, size(X,2));       % p-values for each coefficient
    Rsq   = NaN(nNeurons, 1);               % model R-squared for each neuron

    % Fit GLM to each neuron
    for i = 1:nNeurons
        y = Y(:, i);
        mdl = fitglm(X, y, 'linear'); % or 'normal' family if appropriate

        betas(i, :) = mdl.Coefficients.Estimate(2:end); % skip intercept
        pvals(i, :) = mdl.Coefficients.pValue(2:end);   % skip intercept
        Rsq(i) = mdl.Rsquared.Ordinary;
    end
    allbetas=[allbetas;betas];
    allpvals=[allpvals;pvals];
    allRsq=[allRsq;Rsq];
    
end

% Display summary stats
fprintf('Mean R^2 across neurons: %.3f\n', mean(Rsq, 'omitnan'));
fprintf('Number of neurons with p < 0.05 for information: %d\n', sum(pvals(:,1) < 0.05));
fprintf('Number of neurons with p < 0.05 for side: %d\n', sum(pvals(:,2) < 0.05));
fprintf('Number of neurons with p < 0.05 for rxn: %d\n', sum(pvals(:,3) < 0.05));