%% GOALS

%{
need to put data in a structure to facilitate calcs/plots of

% numTrials
% water
% numtrials of each type


% outcomes across trials per day
% % error
% licks in diff trial epochs
% % choice / pref (by side)
% leaving
% reaction time
% image time stamp

so structurce with row for each trial
fields: mouse, day, session, trial outcome,
 licks rel to trial start,image
events, port exit events/state txn

% good to preserve data in easy to understand original format and just have
script that can run reproducibly on it

load in files, record names, store date, mouse, protocol, time, ntrials as
metadata and rawevents (a.files with length of numfiles)

%}


%%
clear all; close all;
set(0,'DefaultFigureWindowStyle','docked');

%% SELECT NEW DATA

% bpod data folder
% find files
% processed data folder
% find processed files

% process any unprocessed files

% % select folder with new data file(s) to process
% pathname=uigetdir;
% files=dir([pathname,'/JB*Infoseek*.mat']);
% numFiles = size(files,1);

%%
pathname=findInfoseekData();
savepathname = fullfile(pathname, 'current_waterpp');
% savepathname=uigetdir('','Choose processed file directory');

%%
ppfiles=dir(fullfile([savepathname,'/**/JB*Infoseek*waterpp.mat']));
ppnames={ppfiles.name}';
for p=1:numel(ppnames)
    ppnamesbase{p}=ppnames{p}(1:end-12);
end
rawfiles=dir(fullfile([pathname,'/JB*/**/JB*InfoseekWaterVal*.mat']));

if numel(rawfiles)>0
rawnames={rawfiles.name}';
rawdirs={rawfiles.folder}';
rawsize=cell2mat({rawfiles.bytes});
for r=1:numel(rawnames)
    rawnamesbase{r}=rawnames{r}(1:end-4);
    if endsWith(rawnamesbase{r},'pp')
        rawnamesbase{r}=rawnamesbase{r}(1:end-3);
    end
end
files=rawnames(~ismember(rawnamesbase,ppnamesbase)&rawsize>20000);
folders=rawdirs(~ismember(rawnamesbase,ppnamesbase)&rawsize>20000);

numFiles = size(files,1);
else
    numFiles=0;
end

%%

f = 3;

for f = 1:numFiles
    
%     if exist('rawnames')
        filename = files{f};
        filepath = fullfile(folders{f},filename);
%     else
%         filename = files(f).name;
%         filepath = fullfile(files(f).folder,filename);
%     end
%     filename = files{f};
%     filepath = fullfile(folders{f},filename);    
    
    breaks = strfind(filename,'_');    
    mouse = cellstr(filename(1:breaks(1)-1));
    day = cellstr(filename(breaks(2)+1:breaks(3)-1));

    
    % Pull raw data from matfile
    load(filepath);
    
    % Session-level data    
    a.session.name = filename;
    a.session.date = filename(breaks(2)+1:breaks(3)-1);
    a.session.mouse = filename(1:breaks(1)-1);
    a.session.protocol = filename(breaks(1)+1:breaks(2)-1);
    a.session.time =filename(breaks(3)+1:strfind(filename,'.')-1);
    a.session.settings = SessionData.SettingsFile.GUI;
    a.session.eventNames = SessionData.EventNames;
    a.session.nTrials = SessionData.nTrials;
    doorProtocol = contains(a.session.protocol,'door','IgnoreCase',true);
    
    % Trial-level data
    for t = 1:SessionData.nTrials
       a.file(t,1) = f; 
       a.mouse(t,1) = mouse;
       a.day(t,1) = day;
       a.trial(t,1) = t;
       a.door(t,1) = doorProtocol;
    end
    
    if numel(SessionData.TrialSettings)~=SessionData.nTrials
        print('trial settings error ');
        filename
    end
    
    if isfield(SessionData.TrialSettings,'GUI')
       a.trialSettings = [SessionData.TrialSettings(:).GUI]';
    end
        
    a.trialSettings = [SessionData.TrialSettings(:)];
    a.trialType = SessionData.TrialTypes';
    a.startTime = SessionData.TrialStartTimestamp';
    a.endTime = SessionData.TrialEndTimestamp';
    a.outcome = SessionData.Outcomes';
    
    trialData = [];
    trialData = [SessionData.RawEvents(:).Trial];
    trialData = [trialData{:}]';
        
    % STATES
    % includes states for orig doors and timeout
    stateList = {'TimerStart',...
            'InterTrialInterval',...
            'CenterOdorPreload',...
            'StartTrial',...
            'WaitForCenter',...
            'CenterDelay',...
            'CenterOdor',...
            'CenterOdorOff',...
            'CenterPostOdorDelay',...
            'GoCue',...
            'CtrReset5',...
            'CtrReset6',...
            'Response',...
            'GracePeriod',...
            'WaitForOdorLeft',...
            'PreloadOdorLeft',...            
            'OdorLeft',...
            'OdorALeft',...
            'OdorBLeft',...
            'OdorCLeft',...
            'OdorDLeft',...
            'OdorWaterLeft',...
            'OpenCenterLeft',...
            'LeftOdorOff',...
            'RewardDelayLeft',...
            'RewardDelayWaterLeft',...
            'DoorOpenCueLeft',...
            'DoorOpenGraceLeft',...
            'LeftPortCheck',...
            'LeftBigReward',...
            'LeftSmallReward',...
            'LeftNotPresent',...
            'LeftWarning',...
            'WaitForOdorRight',...
            'PreloadOdorRight',...
            'OdorRight',...
            'OdorARight',...
            'OdorBRight',...
            'OdorCRight',...
            'OdorDRight',...
            'OdorWaterRight',...
            'OpenCenterRight',...
            'RightOdorOff',...
            'RewardDelayRight',...
            'RewardDelayWaterRight',...
            'DoorOpenCueRight',...
            'DoorOpenGraceRight',...
            'RightPortCheck',...
            'RightBigReward',...
            'RightSmallReward',...  
            'RightNotPresent',...
            'RightWarning',...
            'OutcomeDelivery',...
            'Drinking',...
            'NoChoice',...
            'Incorrect',...
            'TimeoutOdor',...
            'TimeoutRewardDelay',...
            'TimeoutPortCheck',...
            'TimeoutOutcome',...
            'TimeoutDrinking', ...
            'TimeoutGraceLeft',...
            'TimeoutGraceRight',...
            'LeavingTimeout',...
            'EndTrial'};
    a.stateList = stateList;
    
    
    % EVENTS
    % make sure saving all event names, change events to break out to
    % select list, then expand those
    % when expanding states, delete unexpanded
    eventList = {'GlobalTimer3_Start','GlobalTimer4_Start','GlobalTimer7_Start',...
        'GlobalTimer8_Start','GlobalTimer3_End','GlobalTimer4_End',...
        'GlobalTimer7_End','GlobalTimer8_End','Port1In','Port1Out',...
        'Port2In','Port2Out','Port3In','Port3Out',...
        'DIO1_LeftLick_Hi', 'DIO1_LeftLick_Lo', 'DIO1_CenterLick_Hi',...
        'DIO1_CenterLick_Lo','DIO1_RightLick_Hi', 'DIO1_RightLick_Lo',...
        'GlobalCounter5_End','GlobalCounter6_End',...
        'DIODOORS1_LeftLick_Hi', 'DIODOORS1_LeftLick_Lo', 'DIODOORS1_CenterLick_Hi',...
        'DIODOORS1_CenterLick_Lo','DIODOORS1_RightLick_Hi', 'DIODOORS1_RightLick_Lo',...
        'BNC1High','BNC1Low','HiFi1_1'};
    
    for t = 1:SessionData.nTrials
        for s = 1:numel(stateList)
            if isfield(trialData(t).States,(stateList{s}))
%                 a.(stateList{s}){t,1} = num2cell(SessionData.RawEvents.Trial{1,t}.States.(stateList{s}));
                a.(stateList{s}){t,1} = trialData(t).States.(stateList{s});
            else
%                 a.(stateList{s}){t,1} = 0;
                a.(stateList{s}){t,1} = [NaN];
            end
        end

        for e = 1:numel(eventList)
            if isfield(trialData(t).Events,(eventList{e}))
%                 a.(eventList{e}){t,1} = num2cell(SessionData.RawEvents.Trial{1,t}.Events.(eventList{e}));
                a.(eventList{e}){t,1} = trialData(t).Events.(eventList{e});
            else
%                a.(eventList{e}){t,1} = [0,0];
               a.(eventList{e}){t,1} = [NaN];
            end
        end
    end
    
    % EXPAND STATES AND EVENTS
    for s = 1:numel(a.stateList)
        statename = a.stateList{s};
        state = a.(a.stateList{s});
        maxLength = max(cellfun(@numel,state));
%         result=cellfun(@(x) [cell2mat(reshape(x,1,[])),NaN(1,maxLength-numel(x))],state,'UniformOutput',false);
%         result=cellfun(@(x) cell2mat([reshape(x,1,[]),NaN(1,maxLength-numel(x))]),state,'UniformOutput',true);
        result=cellfun(@(x) [reshape(x,1,[]),NaN(1,maxLength-numel(x))],state,'UniformOutput',false);
        result2=cellfun(@sort,result,'UniformOutput',false);
        result3=vertcat(result2{:});        
        state = [];
%         a.(statename) = single(cell2mat(result2));
%         a.(statename) = single(result2);
        a.(statename) = result3;
        result = [];
        result2 = []; result3 = [];
    end    
    
    for e = 1:numel(eventList)
        eventname = eventList{e};
        event = a.(eventList{e});
        maxLength = max(cellfun(@numel,event));               
%         result=cellfun(@(x) [cell2mat(reshape(x,1,[])),NaN(1,maxLength-numel(x))],event,'UniformOutput',false);
        result=cellfun(@(x) [reshape(x,1,[]),NaN(1,maxLength-numel(x))],event,'UniformOutput',false);
        result2=cellfun(@sort,result,'UniformOutput',false);
        result3=vertcat(result2{:});        
        event = [];
%         a.(eventname) = single(result2);
        a.(eventname) = result3;
        result = [];
        result2 = []; result3 = [];
    end
    
    % TRIALCT
    a.trialCt = numel(a.trialType);
    
    % INFOSIDE
    a.infoSide = [a.trialSettings.InfoSide]';
    a.bigSide = [a.trialSettings.BigSide]';
    a.trialTypes = [a.trialSettings.TrialTypes]';
    
    % CHOICE AND CHOICE TIME

    % choice is waitforodorleft,waitforodorright,incorrect,nochoice

    a.choice = NaN(a.trialCt,1);

    a.leftChoice = a.WaitForOdorLeft(:,1);
    a.rightChoice = a.WaitForOdorRight(:,1);
    a.incorrectChoice = a.Incorrect(:,1);
    a.noChoice = a.NoChoice(:,1);
    a.incorrect = ~isnan(a.incorrectChoice);

    % CORRECT = CHOSE CORRECTLY (includes NP but not no choice or incorrect)
    a.correct = ~isnan(a.leftChoice)|~isnan(a.rightChoice); % doesn't include no choice or incorrect

    % time of choice
    a.choice(~isnan(a.leftChoice)) = a.leftChoice(~isnan(a.leftChoice));
    a.choice(~isnan(a.rightChoice)) = a.rightChoice(~isnan(a.rightChoice));
    a.choice(~isnan(a.incorrectChoice)) = a.incorrectChoice(~isnan(a.incorrectChoice));
    a.choice(~isnan(a.noChoice)) = a.noChoice(~isnan(a.noChoice));
    
    a.choiceTrials = a.trialTypes==5 & a.trialType == 1;
    
    % INFO
    a.info = NaN(a.trialCt,1);
    a.info((a.infoSide == 0) & ~isnan(a.leftChoice) & a.trialType == 2) = 1;
    a.info((a.infoSide == 0) & ~isnan(a.rightChoice) & a.trialType == 3) = 0;
    a.info((a.infoSide == 1) & ~isnan(a.rightChoice) & a.trialType == 2) = 1;
    a.info((a.infoSide == 1) & ~isnan(a.leftChoice) & a.trialType == 3) = 0;
    a.info((a.trialType == 2) & ~isnan(a.incorrectChoice) & a.trialType == 3) = 0;
    a.info((a.trialType == 3) & ~isnan(a.incorrectChoice) & a.trialType == 2) = 1;
    
    % BIG
    a.big = NaN(a.trialCt,1);
    a.big((a.bigSide == 0) & ~isnan(a.leftChoice) & a.trialType == 4) = 1;
    a.big((a.bigSide == 0) & ~isnan(a.rightChoice) & a.trialType == 1) = 0;
    a.big((a.bigSide == 1) & ~isnan(a.rightChoice) & a.trialType == 4) = 1;
    a.big((a.bigSide == 1) & ~isnan(a.leftChoice) & a.trialType == 1) = 0;
    a.big((a.trialType == 1) & ~isnan(a.incorrectChoice) & a.trialType == 1) = 0;
    a.big((a.trialType == 4) & ~isnan(a.incorrectChoice) & a.trialType == 4) = 1;    
    
    % REWARD PARAMS

    a.infoBigDrops = [a.trialSettings.InfoBigDrops]';
    a.infoSmallDrops = [a.trialSettings.InfoSmallDrops]';
    a.randBigDrops = [a.trialSettings.RandBigDrops]';
    a.randSmallDrops = [a.trialSettings.RandSmallDrops]';
    a.infoProb = [a.trialSettings.InfoRewardProb]';
    a.randProb = [a.trialSettings.RandRewardProb]';
    a.bigDrops = [a.trialSettings.BigDrops]';
    a.smallDrops = [a.trialSettings.SmallDrops]';
    a.rewardParams = [a.infoBigDrops a.infoSmallDrops a.randBigDrops...
    a.randSmallDrops a.infoProb a.randProb a.bigDrops a.smallDrops];

    a.odorDelay = [a.trialSettings.OdorDelay]';
    a.rewardDelay = [a.trialSettings.RewardDelay]';
    a.odorTime = [a.trialSettings.OdorTime]';
    a.signalTime = [a.trialSettings.Signal]';
    
    % SIDE ODOR
    
    a.odor2 = [a.OdorALeft(:,1) a.OdorBLeft(:,1) a.OdorCLeft(:,1) a.OdorDLeft(:,1)...
        a.OdorARight(:,1) a.OdorBRight(:,1) a.OdorCRight(:,1) a.OdorDRight(:,1)...
        a.TimeoutOdor(:,1) a.OdorWaterLeft(:,1) a.OdorWaterRight(:,1)];
%     if sum(sum(~isnan(a.odor2),2)==0)>0
%        a.odor2=[a.OdorLeft(:,1) a.OdorRight(:,1) a.TimeoutOdor(:,1)];
%     end
    odor2tp = a.odor2';
    a.odor2On=NaN(a.trialCt,1);
%     a.odor2On = odor2tp(~isnan(odor2tp));
    for t=1:a.trialCt
        if sum(~isnan(a.odor2(t,:)))>0
        a.odor2On(t,1)=a.odor2(t,~isnan(a.odor2(t,:)));
        end
    end

    a.odorAtrials = (~isnan(a.leftChoice) & ~isnan(a.OdorALeft(:,1))) | (~isnan(a.rightChoice) & ~isnan(a.OdorARight(:,1)));
    a.odorBtrials = (~isnan(a.leftChoice) & ~isnan(a.OdorBLeft(:,1))) | (~isnan(a.rightChoice) & ~isnan(a.OdorBRight(:,1)));
    a.odorCtrials = (~isnan(a.leftChoice) & ~isnan(a.OdorCLeft(:,1))) | (~isnan(a.rightChoice) & ~isnan(a.OdorCRight(:,1)));
    a.odorDtrials = (~isnan(a.leftChoice) & ~isnan(a.OdorDLeft(:,1))) | (~isnan(a.rightChoice) & ~isnan(a.OdorDRight(:,1)));
    a.odorWatertrials = (~isnan(a.leftChoice) & ~isnan(a.OdorWaterLeft(:,1))) | (~isnan(a.rightChoice) & ~isnan(a.OdorWaterRight(:,1)));

    a.odor2type = NaN(a.trialCt,1);
    a.odor2type(a.odorAtrials==1)=1;
    a.odor2type(a.odorBtrials==1)=2;
    a.odor2type(a.odorCtrials==1)=3;
    a.odor2type(a.odorDtrials==1)=4;
    a.odor2type(a.odorWatertrials==1)=5;
    
    % TONE ON
    a.tone=[a.LeftWarning(:,1) a.RightWarning(:,1)];
    a.toneOn=NaN(a.trialCt,1);
    if isfield(a.trialSettings,'Signal')
        for t=1:a.trialCt
            if sum(~isnan(a.tone(t,:)))>0
                a.toneOn(t,1)=a.tone(t,~isnan(a.tone(t,:)));
            end
        end
    end

    % OUTCOME TIME

    a.outcomeTime = NaN(size(a.trial));
    a.outcomeTime(~isnan(a.OutcomeDelivery(:,2))) = a.OutcomeDelivery(~isnan(a.OutcomeDelivery(:,2)),2);
    a.outcomeTime(~isnan(a.TimeoutOutcome(:,2))) = a.TimeoutOutcome(~isnan(a.TimeoutOutcome(:,2)),2);

    % CENTER ENTRIES AND EXITS

    exitDiff=a.Port2Out-a.GoCue(:,1);
    exitDiff(exitDiff<0)=inf;
    [~,indA]=min(exitDiff,[],2);
    indB=sub2ind(size(a.Port2Out),(1:size(a.Port2Out,1))',indA);
    a.centerExitGo = a.Port2Out(indB);
    clear exitDiff indA indB
   
    
    exitDiffFirst = a.Port2Out - a.CenterOdor(:,1);
    exitDiffFirst(exitDiffFirst<0)=inf;
    [~,indA]=min(exitDiffFirst,[],2);
    indB=sub2ind(size(a.Port2Out),(1:size(a.Port2Out,1))',indA);
    a.centerExitFirst = a.Port2Out(indB);    

    % SIDE LEAVING

    %{
    diff between port1andport3 out and odor2on
    Only relevant for trials with an odor2 presentation?

    %}

    a.odor2LeavingTime = NaN(a.trialCt,1);
    odor2trials = find(isnan(a.TimeoutOdor(:,1)));

    for tt = 1:numel(odor2trials)
       t=odor2trials(tt);
       odor2time=a.odor2On(t);
       if a.odor2type(t)<3
          if a.infoSide(t)==0
              portOut = a.Port1Out(t,:);
          else
              portOut = a.Port3Out(t,:);
          end
       else
          if a.infoSide(t)==0
              portOut = a.Port3Out(t,:);
          else
              portOut = a.Port1Out(t,:);
          end       
       end
       exitDiff = portOut-odor2time;
       if sum(exitDiff>0)>0
           exitDiff(exitDiff<0)=inf;
           [~,idx] = min(exitDiff);
           a.odor2LeavingTime(t) = portOut(idx);
       end
    end

    % REACTION TIME AND TRIAL LENGTH

    % IN SECONDS
    a.rxn = a.choice-a.GoCue(:,1);
    a.rxnSpeed = 1./a.rxn;
    a.goodRxn = a.rxn<8000 & a.rxn>100;

    a.trialLengthTotal = a.endTime - a.startTime;
    a.trialLength = a.endTime - (a.GoCue(:,1) + a.startTime);
    a.trialLengthCenterEntry = a.endTime - (a.CenterDelay(:,1) + a.startTime);
    
    % INITIATION TIME
%     a.initTime = a.CenterDelay(:,1);

    % TRIAL CHOICE TYPES (includes NP but not no choice or incorrect)

    a.choiceTypeNames = {'Info','Rand','Big','Small'};
    a.choiceTypeCts = [sum(a.trialType == 2) sum(a.trialType == 3) sum(a.trialType == 4) sum(a.trialType == 1)];
    a.infoForced = a.trialType == 2 & a.correct == 1;
    a.randForced = a.trialType == 3 & a.correct == 1;
    a.bigForced = a.trialType == 4 & a.correct == 1 & a.big == 1;
    a.smallForced = a.trialType == 1 & a.correct == 1 & a.big == 0;
    

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ALL CORRECT TRIALS (INCLUDES NOT PRESENT BUT NOT NO CHOICE OR INCORRECT)
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

    a.infoBig = ismember(a.outcome,infoBig);
    a.infoSmall = ismember(a.outcome,infoSmall);
    a.randBig = ismember(a.outcome,randBig);
    a.randSmall = ismember(a.outcome,randSmall);
    a.bigWater = ismember(a.outcome,bigWater);
    a.smallWater = ismember(a.outcome,smallWater);

    a.typeNames = {'Info Water','Info None','Rand Water','Rand None','Big Water','Small Water'};
    a.typeSizes = [sum(a.infoBig) sum(a.infoSmall) sum(a.randBig) sum(a.randSmall) sum(a.bigWater) sum(a.smallWater)];

    a.infoCorrTrials = a.info == 1 & a.correct == 1;
    a.randCorrTrials = a.info == 0 & a.correct == 1;
    a.bigCorrTrials = a.big ==1 & a.correct ==1;
    a.smallCorrTrials = a.big == 0 & a.correct == 1;
    
    a.infoCorrCodes = [6 8 9];
    a.infoIncorrCodes = [5 7];
    a.randCorrCodes = [12 14];
    a.randIncorrCodes = [11 13 15 16];
    a.bigCorrCodes = [18];
    a.bigIncorrCodes = [17 19 20];
    a.smallCorrCodes = [2];
    a.smallIncorrCodes = [1 3 4];
    
    a.infoCorr = ismember(a.outcome,a.infoCorrCodes);
    a.infoIncorr = ismember(a.outcome,a.infoIncorrCodes);
    a.randCorr = ismember(a.outcome,a.randCorrCodes);
    a.randIncorr = ismember(a.outcome,a.randIncorrCodes);
    a.bigCorr = ismember(a.outcome,a.bigCorrCodes);
    a.bigIncorr = ismember(a.outcome,a.bigIncorrCodes);
    a.smallCorr = ismember(a.outcome,a.smallCorrCodes);
    a.smallIncorr = ismember(a.outcome,a.smallIncorrCodes);    

    a.choiceCorrTypeNames = {'Info','Rand','Big','Small'};
    a.choiceTypeCtsCorr = [sum(a.infoCorr) sum(a.randCorr) sum(a.bigCorr) sum(a.smallCorr)];

    % NOT PRESENT

    a.infoNP = ismember(a.outcome,[12 14]);
    a.randNP = ismember(a.outcome,[18 20]);
    a.bigNP = ismember(a.outcome,[3 5]);
    a.smallNP = ismember(a.outcome,[7 9]);
    a.notPresent = ismember(a.outcome,[3 5 7 9 12 14 18 20]);

    % ERRORTYPES
    a.errorTypes = NaN(numel(a.file),1);

    a.errorTypes(ismember(a.outcome,[2 6 8 9 12 14 18]))= 1; % correct
    a.errorTypes(ismember(a.outcome,[1,5,11,17]))= 2; % no choice
    a.errorTypes(ismember(a.outcome,[4,10,16,20]))= 3; % incorrect
    a.errorTypes(ismember(a.outcome,[3,7,13,15,19]))= 4; % not present

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % TRIAL INITIATION
    
    a.centerEntryCount = sum(~isnan(a.CenterOdor),2)/2;
    a.completeInitiation = a.centerEntryCount == 1;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % REWARD

    dropSize = 4; % microliters per drop

    a.infoBigReward = [a.trialSettings.InfoBigDrops]' * 4;
    a.infoSmallReward = [a.trialSettings.InfoSmallDrops]' * 4;
    a.randBigReward = [a.trialSettings.RandBigDrops]' * 4;
    a.randSmallReward = [a.trialSettings.RandSmallDrops]' * 4;
    a.bigReward = [a.trialSettings.BigDrops]' * 4;
    a.smallReward = [a.trialSettings.SmallDrops]' * 4;

    a.leftDrops = a.GlobalTimer3_End - a.GlobalTimer3_Start;
    a.leftRewardDrops = NaN(size(a.leftDrops));
    a.leftRewardDrops(a.leftDrops>0.01) = 1;
    a.leftReward = nansum(a.leftRewardDrops,2)*dropSize;
    a.rightDrops = a.GlobalTimer4_End - a.GlobalTimer4_Start;
    a.rightRewardDrops = NaN(size(a.rightDrops));
    a.rightRewardDrops(a.rightDrops>0.01) = 1;
    a.rightReward = nansum(a.rightRewardDrops,2)*dropSize;
    a.reward = nansum([a.leftReward, a.rightReward],2);
    
    % PORT OCCUPANCY

    win = 0.050; % bins in ms
    bins = [-1:win:15];
    a.bins=bins;
    a.win = win;
    portInNames = {'Port1In','Port2In','Port3In'};
    portOutNames = {'Port1Out','Port2Out','Port3Out'};
    portMeanNames = {'meanPort1Dwell','meanPort2Dwell','meanPort3Dwell'};
    portDwellNames = {'port1Dwell','port2Dwell','port3Dwell'};
    portNames = {'Port1','Port2','Port3'};
    for p = 1:3
        inCounts = [];outCounts=[];moreOuts=[];moreIns=[];
        portInname = portInNames{p}; portOutname = portOutNames{p}; portMeanName = portMeanNames{p};
        portDwellName = portDwellNames{p};

        % if expanded array has different max events
        if size(a.(portOutname),2)~=size(a.(portInname),2)
           if  size(a.(portOutname),2)>size(a.(portInname),2)
              a.(portInname)(:,end+1) = NaN; 
           else
               a.(portOutname)(:,end+1) = NaN;
           end
        end
        a.(portInname)(:,end+1) = NaN;
        a.(portOutname)(:,end+1) = NaN;

        %already In
        alreadyIn = find(a.(portOutname)(:,1)-a.(portInname)(:,1)<0);
        for i = 1:numel(alreadyIn)
           a.(portInname)(alreadyIn(i),2:end) = a.(portInname)(alreadyIn(i),1:end-1);
           a.(portInname)(alreadyIn(i),1) = 0;
        end

        % no exit
        inCounts = sum(~isnan(a.(portInname)),2);
        outCounts = sum(~isnan(a.(portOutname)),2);
        moreIns = find((outCounts-inCounts)<0);
    %     a.(portOutname)(moreOuts,1:end-1) = a.(portOutname)(moreOuts,2:end); % if more outs,
        for m = 1:numel(moreIns)
            noExit = outCounts(moreIns(m))+1; 
            a.(portOutname)(moreIns(m),noExit) = a.endTime(moreIns(m)) - a.startTime(moreIns(m));
        end    

        % already in but nothing to subtract
        inCounts = sum(~isnan(a.(portInname)),2);
        outCounts = sum(~isnan(a.(portOutname)),2);
        moreOuts = find((outCounts-inCounts)>0); % extra leaving because mouse was already in port at start
        for m = 1:numel(moreOuts)
            a.(portInname)(moreOuts(m),inCounts(moreOuts(m))+1) = 0;
        end

        noMatch = ~(a.(portOutname)>a.(portInname));
        noMatch(and(isnan(a.(portOutname)),isnan(a.(portInname))))=0;

        a.(portDwellName) = (a.(portOutname)(:)) - (a.(portInname)(:));
        a.(portMeanName) = mean((a.(portOutname)(:)) - (a.(portInname)(:)),'omitnan');

        a.(portNames{p}) = zeros(numel(a.file),numel(bins));

        % NEED TO CHANGE THESE TIMES TO BE RELATIVE TO GO CUE!
        for t = 1:numel(a.file)
           entries = a.(portInname)(t,~isnan(a.(portInname)(t,:)))-a.GoCue(t,2);
           exits = a.(portOutname)(t,~isnan(a.(portOutname)(t,:)))-a.GoCue(t,2);
           for e = 1:numel(exits)
               binIn = find(bins-entries(e)>0,1);
               binOut = find(bins-exits(e)>0,1)-1;
               a.(portNames{p})(t,(binIn:binOut))=1;
           end
        end        
    end

    %% PORTS BY INFO VS RANDOM

    a.infoPort = NaN(size(a.Port2));
    a.randPort = NaN(size(a.Port2));
    infoLeft = a.infoSide == 0;
    infoRight = a.infoSide == 1;

    a.infoPort(infoLeft,:) = a.Port1(infoLeft,:);
    a.infoPort(infoRight,:) = a.Port3(infoRight,:);
    a.randPort(infoLeft,:) = a.Port3(infoLeft,:);
    a.randPort(infoRight,:) = a.Port1(infoRight,:);    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [sessionpath,name,ext]=fileparts(filepath);

%     savedir = fullfile(pathname, 'current_pp');
    savedir = savepathname;

%     if exist(savedir)
%         savepath=savedir;
%     else
%         mkdir(savedir);
%         savepath=savedir;
%     end

    savename=fullfile(savedir,[name '_waterpp' ext]);    
    save(savename,'-struct','a','-v7.3');
    clearvars -except pathname savepathname files numFiles f folders;
    
end % end for each file
