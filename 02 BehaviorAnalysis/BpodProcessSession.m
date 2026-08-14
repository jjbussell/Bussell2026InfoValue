%% BpodProcessSession
%
% First-stage processing of raw Bpod session data for the Infoseek task.
%
% For each raw session .mat file not already processed:
%   - loads the raw SessionData produced by Bpod
%   - extracts the state-machine and event timestamps of interest for
%     every trial
%   - derives per-trial behavioral measures (choice, reaction time,
%     licking, port occupancy, reward, error type, etc.) into a single
%     struct `a`, with one row per trial
%   - saves the resulting struct to a 'current_pp' subfolder of the raw
%     data folder, named <original filename>_pp.mat
%
% Raw data is left untouched; this script can be re-run at any time and
% will only process files that don't already have a corresponding _pp
% file.

%%
clear; close all;
set(0,'DefaultFigureWindowStyle','docked');

%% SELECT NEW DATA
% Find raw session files and already-processed (_pp) files in the Bpod
% data folder, then build the list of raw files that still need
% processing (skip already-processed files and files that are too small
% to be real sessions).

%%
pathname=findInfoseekData();

ppfiles=dir(fullfile([pathname,'/**/JB*InfoseekSync*pp.mat']));
ppnames={ppfiles.name}';
for p=1:numel(ppnames)
    ppnamesbase{p}=ppnames{p}(1:end-7);
end
rawfiles=dir(fullfile([pathname,'/**/JB*InfoseekSync*.mat']));
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
%%

for f = 1:numFiles

    filename = files{f};
    filepath = fullfile(folders{f},filename);

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
        warning('Trial settings count mismatch for file: %s', filename);
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
    % Bpod state-machine states to pull out of each trial's raw data.
    % Includes states for the original door hardware and the timeout
    % variant of the task in addition to the main task states.
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
    % DAQ/lick and global-timer event channels to pull out of each
    % trial's raw data, in addition to the states above.
    eventList = {'GlobalTimer3_Start','GlobalTimer4_Start','GlobalTimer7_Start',...
        'GlobalTimer8_Start','GlobalTimer3_End','GlobalTimer4_End',...
        'GlobalTimer7_End','GlobalTimer8_End','Port1In','Port1Out',...
        'Port2In','Port2Out','Port3In','Port3Out',...
        'DIO1_LeftLick_Hi', 'DIO1_LeftLick_Lo', 'DIO1_CenterLick_Hi',...
        'DIO1_CenterLick_Lo','DIO1_RightLick_Hi', 'DIO1_RightLick_Lo',...
        'GlobalCounter5_End','GlobalCounter6_End',...
        'DIODOORS1_LeftLick_Hi', 'DIODOORS1_LeftLick_Lo', 'DIODOORS1_CenterLick_Hi',...
        'DIODOORS1_CenterLick_Lo','DIODOORS1_RightLick_Hi', 'DIODOORS1_RightLick_Lo',...
        'BNC1High','BNC1Low'};

    % For every trial, copy each listed state/event's raw timestamp(s)
    % into a.(name){trial}, or NaN if that state/event didn't occur.
    for t = 1:SessionData.nTrials
        for s = 1:numel(stateList)
            if isfield(trialData(t).States,(stateList{s}))
                a.(stateList{s}){t,1} = trialData(t).States.(stateList{s});
            else
                a.(stateList{s}){t,1} = [NaN];
            end
        end

        for e = 1:numel(eventList)
            if isfield(trialData(t).Events,(eventList{e}))
                a.(eventList{e}){t,1} = trialData(t).Events.(eventList{e});
            else
               a.(eventList{e}){t,1} = [NaN];
            end
        end
    end

    % EXPAND STATES AND EVENTS
    % Each state/event is currently a cell array with one variable-length
    % vector of timestamps per trial (a state/event can occur more than
    % once in a trial). Pad every trial's vector with NaN up to the
    % longest one for that state/event, sort, and stack into a single
    % trials x occurrences matrix so it can be indexed directly below.
    for s = 1:numel(a.stateList)
        statename = a.stateList{s};
        state = a.(a.stateList{s});
        maxLength = max(cellfun(@numel,state));
        result=cellfun(@(x) [reshape(x,1,[]),NaN(1,maxLength-numel(x))],state,'UniformOutput',false);
        result2=cellfun(@sort,result,'UniformOutput',false);
        result3=vertcat(result2{:});
        state = [];
        a.(statename) = result3;
        result = [];
        result2 = []; result3 = [];
    end

    for e = 1:numel(eventList)
        eventname = eventList{e};
        event = a.(eventList{e});
        maxLength = max(cellfun(@numel,event));
        result=cellfun(@(x) [reshape(x,1,[]),NaN(1,maxLength-numel(x))],event,'UniformOutput',false);
        result2=cellfun(@sort,result,'UniformOutput',false);
        result3=vertcat(result2{:});
        event = [];
        a.(eventname) = result3;
        result = [];
        result2 = []; result3 = [];
    end

    % TRIALCT
    a.trialCt = numel(a.trialType);

    % INFOSIDE
    a.infoSide = [a.trialSettings.InfoSide]';
    a.trialTypes = [a.trialSettings.TrialTypes]';

    % CHOICE AND CHOICE TIME
    % Choice is whichever of WaitForOdorLeft, WaitForOdorRight,
    % Incorrect, or NoChoice the trial entered; a.choice is that state's
    % entry timestamp.

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
    % Whether the mouse chose the informative side (1) or the random
    % side (0) on this trial, independent of which physical side (left
    % vs right) was informative that session.
    a.info = NaN(a.trialCt,1);
    a.info((a.infoSide == 0) & ~isnan(a.leftChoice)) = 1;
    a.info((a.infoSide == 0) & ~isnan(a.rightChoice)) = 0;
    a.info((a.infoSide == 1) & ~isnan(a.rightChoice)) = 1;
    a.info((a.infoSide == 1) & ~isnan(a.leftChoice)) = 0;
    a.info((a.trialType == 2) & ~isnan(a.incorrectChoice)) = 0;
    a.info((a.trialType == 3) & ~isnan(a.incorrectChoice)) = 1;

    % REWARD PARAMS
    % Per-trial reward settings pulled from the GUI trial settings.

    a.infoBigDrops = [a.trialSettings.InfoBigDrops]';
    a.infoSmallDrops = [a.trialSettings.InfoSmallDrops]';
    a.randBigDrops = [a.trialSettings.RandBigDrops]';
    a.randSmallDrops = [a.trialSettings.RandSmallDrops]';
    a.infoProb = [a.trialSettings.InfoRewardProb]';
    a.randProb = [a.trialSettings.RandRewardProb]';
    a.rewardParams = [a.infoBigDrops a.infoSmallDrops a.randBigDrops...
    a.randSmallDrops a.infoProb a.randProb];

    a.odorDelay = [a.trialSettings.OdorDelay]';
    a.rewardDelay = [a.trialSettings.RewardDelay]';
    a.odorTime = [a.trialSettings.OdorTime]';

    % SIDE ODOR
    % Onset time of whichever second (side-port) odor state occurred on
    % this trial, across the four possible odor identities plus timeout.

    a.odor2 = [a.OdorALeft(:,1) a.OdorBLeft(:,1) a.OdorCLeft(:,1) a.OdorDLeft(:,1)...
        a.OdorARight(:,1) a.OdorBRight(:,1) a.OdorCRight(:,1) a.OdorDRight(:,1)...
        a.TimeoutOdor(:,1)];
    odor2tp = a.odor2';
    a.odor2On=NaN(a.trialCt,1);
    for t=1:a.trialCt
        if sum(~isnan(a.odor2(t,:)))>0
        a.odor2On(t,1)=a.odor2(t,~isnan(a.odor2(t,:)));
        end
    end

    a.odorAtrials = (~isnan(a.leftChoice) & ~isnan(a.OdorALeft(:,1))) | (~isnan(a.rightChoice) & ~isnan(a.OdorARight(:,1)));
    a.odorBtrials = (~isnan(a.leftChoice) & ~isnan(a.OdorBLeft(:,1))) | (~isnan(a.rightChoice) & ~isnan(a.OdorBRight(:,1)));
    a.odorCtrials = (~isnan(a.leftChoice) & ~isnan(a.OdorCLeft(:,1))) | (~isnan(a.rightChoice) & ~isnan(a.OdorCRight(:,1)));
    a.odorDtrials = (~isnan(a.leftChoice) & ~isnan(a.OdorDLeft(:,1))) | (~isnan(a.rightChoice) & ~isnan(a.OdorDRight(:,1)));

    a.odor2type = NaN(a.trialCt,1);
    a.odor2type(a.odorAtrials==1)=1;
    a.odor2type(a.odorBtrials==1)=2;
    a.odor2type(a.odorCtrials==1)=3;
    a.odor2type(a.odorDtrials==1)=4;

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
    % Port2 (center) can log multiple in/out events per trial; find the
    % specific exit that follows the go cue (centerExitGo) and the one
    % that follows the first center-odor presentation (centerExitFirst).

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
    % For trials with a second-odor presentation, find the side-port
    % exit that follows odor2 onset (relevant to the chosen/informative
    % side port for that trial).

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

    % TRIAL CHOICE TYPES (includes NP but not no choice or incorrect)
    % trialType: 1 = free choice, 2 = forced info, 3 = forced random.

    a.choiceTypeNames = {'InfoForced','RandForced','Choice'};
    a.choiceTypeCts = [sum(a.trialType == 2) sum(a.trialType == 3) sum(a.trialType == 1)];
    a.infoForced = a.trialType == 2 & a.correct == 1;
    a.randForced = a.trialType == 3 & a.correct == 1;
    a.infoChoice = a.trialType == 1 & a.correct == 1 & a.info == 1;
    a.randChoice = a.trialType == 1 & a.correct == 1 & a.info == 0;

    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ALL CORRECT TRIALS (INCLUDES NOT PRESENT BUT NOT NO CHOICE OR INCORRECT)
    % SessionData.Outcomes codes are grouped below by info/random side and
    % big/small reward to classify each trial's result.

    infoBig = [2,3,11,12];
    infoSmall = [4,5,13,14];
    randBig = [6,7,17,18];
    randSmall = [8,9,19,20];

    a.infoBig = ismember(a.outcome,infoBig);
    a.infoSmall = ismember(a.outcome,infoSmall);
    a.randBig = ismember(a.outcome,randBig);
    a.randSmall = ismember(a.outcome,randSmall);

    a.typeNames = {'Info Water','Info None','Rand Water','Rand None'};
    a.typeSizes = [sum(a.infoBig) sum(a.infoSmall) sum(a.randBig) sum(a.randSmall)];

    a.choiceCorrTrials = a.trialType == 1 & a.correct == 1 & a.trialTypes == 5;
    a.forcedCorrTrials = a.trialType ~= 1 & a.correct == 1;
    a.infoCorrTrials = a.info == 1 & a.correct == 1;
    a.randCorrTrials = a.info == 0 & a.correct == 1;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% LEAVING TIMEOUT
    % Trials where the mouse left the side port during the grace period
    % and incurred a timeout penalty.

    a.timeoutGrace(:,1) = sum(~isnan(a.TimeoutGraceLeft),2)/2;
    a.timeoutGrace(:,2) = sum(~isnan(a.TimeoutGraceRight),2)/2;
    a.timeoutTime = NaN(a.trialCt,1);

    if sum(~isnan(a.LeavingTimeout))>0
        a.timeout = ~isnan(a.LeavingTimeout(:,1));
        a.timeoutTime(~isnan(a.timeout)) = a.LeavingTimeout(~isnan(a.timeout),2)-a.LeavingTimeout(~isnan(a.timeout),1);
    else
        a.timeout = zeros(size(a.LeavingTimeout,1),1);
    end


    for t = 1:a.trialCt
        if sum(~isnan(a.LeavingTimeout))>0
            a.timeoutParam(t,1) = a.trialSettings(t).Timeout;
        else
            a.timeoutParam(t,1) = 0;
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ERRORS
    % Outcome codes grouped into the five mutually-exclusive trial result
    % categories stored in a.errorTypes below.

    a.centerEntryCount = sum(~isnan(a.CenterOdor),2)/2;
    a.completeInitiation = a.centerEntryCount == 1;

    % doesn't include NP (NP info small is not an error)-->NOW IT DOES!
    % NP info small is outcome 5 and 14

    a.infoCorrCodes = [11 13 14];
    a.infoIncorrCodes = [10 12 15];
    a.randCorrCodes = [17 19];
    a.randIncorrCodes = [16 18 20 21];
    a.choiceCorrCodes = [2 4 5 6 8];
    a.choiceIncorrCodes = [1 3 7 9];

    a.infoForcedCorr = ismember(a.outcome,a.infoCorrCodes);
    a.infoForcedIncorr = ismember(a.outcome,a.infoIncorrCodes);
    a.randForcedCorr = ismember(a.outcome,a.randCorrCodes);
    a.randForcedIncorr = ismember(a.outcome,a.randIncorrCodes);
    a.choiceCorr = ismember(a.outcome,a.choiceCorrCodes);
    a.choiceIncorr = ismember(a.outcome,a.choiceIncorrCodes);
    a.infoChoiceCorr = ismember(a.outcome,[2 4 5]);
    a.randChoiceCorr = ismember(a.outcome,[6 7]);

    a.choiceCorrTypeNames = {'InfoForced','RandForced','InfoChoice',...
        'RandChoice'};
    a.choiceTypeCtsCorr = [sum(a.infoForcedCorr) sum(a.randForcedCorr) sum(a.infoChoiceCorr) sum(a.randChoiceCorr)];

    % NOT PRESENT

    a.infoForcedNP = ismember(a.outcome,[12 14]);
    a.randForcedNP = ismember(a.outcome,[18 20]);
    a.choiceInfoNP = ismember(a.outcome,[3 5]);
    a.choiceRandNP = ismember(a.outcome,[7 9]);
    a.notPresent = ismember(a.outcome,[3 5 7 9 12 14 18 20]);

    % ERRORTYPES
    a.errorTypes = NaN(numel(a.file),1);

    a.errorTypes(ismember(a.outcome,[2,4,6,8,11,13,17,19]))= 1; % correct
    a.errorTypes(ismember(a.outcome,[1,10,16]))= 2; % no choice
    a.errorTypes(ismember(a.outcome,[15,21]))= 3; % incorrect
    a.errorTypes(ismember(a.outcome,[3,5,7,9,12,14,18,20]))= 4; % not present
    a.errorTypes(a.timeout==1)= 5; % timeout

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % REWARD
    % Reward volume is inferred from how long the left/right reward
    % solenoid global timers ran (GlobalTimer3/4), since each timer run
    % corresponds to one reward drop of a fixed size.

    dropSize = 4; % microliters per drop

    a.infoBigReward = [a.trialSettings.InfoBigDrops]' * 4;
    a.infoSmallReward = [a.trialSettings.InfoSmallDrops]' * 4;
    a.randBigReward = [a.trialSettings.RandBigDrops]' * 4;
    a.randSmallReward = [a.trialSettings.RandSmallDrops]' * 4;

    a.leftDrops = a.GlobalTimer3_End - a.GlobalTimer3_Start;
    a.leftRewardDrops = NaN(size(a.leftDrops));
    a.leftRewardDrops(a.leftDrops>0.01) = 1;
    a.leftReward = nansum(a.leftRewardDrops,2)*dropSize;
    a.rightDrops = a.GlobalTimer4_End - a.GlobalTimer4_Start;
    a.rightRewardDrops = NaN(size(a.rightDrops));
    a.rightRewardDrops(a.rightDrops>0.01) = 1;
    a.rightReward = nansum(a.rightRewardDrops,2)*dropSize;
    a.reward = nansum([a.leftReward, a.rightReward],2);

    % LICKS
    % For each trial, reassign left/right lick timestamps into info-side
    % vs random-side licks based on infoSide, then classify licks by
    % timing relative to odor2 onset, go cue, and outcome delivery.
    % Two hardware revisions logged licks on different DIO channels
    % (DIODOORS1_* for the door rig, DIO1_* otherwise); use whichever one
    % has data.
    doorLeft=a.DIODOORS1_LeftLick_Hi;
    doorRight=a.DIODOORS1_RightLick_Hi;

    if sum(sum(~isnan(doorLeft)))|sum(sum(~isnan(doorRight)))>0
        door=1;
        a.infoLicks = NaN(size(a.infoSide,1),max([size(doorLeft,2) size(doorRight,2)]));
        a.randLicks = NaN(size(a.infoSide,1),max([size(doorLeft,2) size(doorRight,2)]));
        a.infoLicks(a.infoSide == 0,1:size(doorLeft,2)) = doorLeft(a.infoSide == 0,:);
        a.infoLicks(a.infoSide == 1,1:size(doorRight,2)) = doorRight(a.infoSide == 1,:);
        a.randLicks(a.infoSide == 1,1:size(doorLeft,2)) = doorLeft(a.infoSide == 1,:);
        a.randLicks(a.infoSide == 0,1:size(doorRight,2)) = doorRight(a.infoSide == 0,:);
    else
        door=0;
        a.infoLicks = NaN(size(a.infoSide,1),max([size(a.DIO1_LeftLick_Hi,2) size(a.DIO1_RightLick_Hi,2)]));
        a.randLicks = NaN(size(a.infoSide,1),max([size(a.DIO1_LeftLick_Hi,2) size(a.DIO1_RightLick_Hi,2)]));
        a.infoLicks(a.infoSide == 0,1:size(a.DIO1_LeftLick_Hi,2)) = a.DIO1_LeftLick_Hi(a.infoSide == 0,:);
        a.infoLicks(a.infoSide == 1,1:size(a.DIO1_RightLick_Hi,2)) = a.DIO1_RightLick_Hi(a.infoSide == 1,:);
        a.randLicks(a.infoSide == 1,1:size(a.DIO1_LeftLick_Hi,2)) = a.DIO1_LeftLick_Hi(a.infoSide == 1,:);
        a.randLicks(a.infoSide == 0,1:size(a.DIO1_RightLick_Hi,2)) = a.DIO1_RightLick_Hi(a.infoSide == 0,:);
    end

    a.infoLicks = single(a.infoLicks);
    a.randLicks = single(a.randLicks);

    doorLeft = [];
    doorRight = [];

    a.infoLicksCorr = a.infoLicks;
    a.infoLicksCorr(a.correct==0,:)=NaN;
    a.randLicksCorr = a.randLicks;
    a.randLicksCorr(a.correct==0,:)=NaN;

    a.totalInfoLicks = single(sum(~isnan(a.infoLicksCorr),2));
    a.totalRandLicks = single(sum(~isnan(a.randLicksCorr),2));

    a.earlyInfoLicks = sum(and(a.infoLicksCorr<a.odor2On,a.infoLicksCorr>a.GoCue(:,2)),2,'omitnan');
    a.anticipatoryInfoLicks = sum(and(a.infoLicksCorr>a.odor2On,a.infoLicksCorr<a.outcomeTime),2,'omitnan');
    a.waterInfoLicks = sum(a.infoLicksCorr>a.outcomeTime,2,'omitnan');
    a.tooEarlyInfoLicks = sum(a.infoLicksCorr<a.GoCue(:,2),2,'omitnan');

    a.earlyRandLicks = sum(and(a.randLicksCorr<a.odor2On,a.randLicksCorr>a.GoCue(:,2)),2,'omitnan');
    a.anticipatoryRandLicks = sum(and(a.randLicksCorr>a.odor2On,a.randLicksCorr<a.outcomeTime),2,'omitnan');
    a.waterRandLicks = sum(a.randLicksCorr>a.outcomeTime,2,'omitnan');
    a.tooEarlyRandLicks = sum(a.randLicksCorr<a.GoCue(:,2),2,'omitnan');

    a.earlyLicks = single(NaN(size(a.infoLicks,1),1));
    a.earlyLicks(a.info == 1) = a.earlyInfoLicks(a.info == 1);
    a.earlyLicks(a.info == 0) = a.earlyRandLicks(a.info == 0);

    a.anticipatoryLicks = single(NaN(size(a.infoLicks,1),1));
    a.anticipatoryLicks(a.info == 1) = a.anticipatoryInfoLicks(a.info == 1);
    a.anticipatoryLicks(a.info == 0) = a.anticipatoryRandLicks(a.info == 0);

    a.waterLicks = single(NaN(size(a.infoLicks,1),1));
    a.waterLicks(a.info == 1) = a.waterInfoLicks(a.info == 1);
    a.waterLicks(a.info == 0) = a.waterRandLicks(a.info == 0);

    % PORT OCCUPANCY
    % Build a per-trial, time-binned occupancy trace for each port
    % (1 = mouse in port), in 50 ms bins from -1 to 15 s relative to the
    % go cue. In/out event counts are first reconciled to handle two
    % edge cases: the mouse already being in the port at trial start, and
    % a port entry with no logged exit before the trial ended.

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
    % Remap left/right port occupancy traces to info-side/random-side
    % based on which physical side was informative that trial.

    a.infoPort = zeros(size(a.Port2));
    a.randPort = zeros(size(a.Port2));
    infoLeft = a.infoSide == 0;
    infoRight = a.infoSide == 1;

    a.infoPort(infoLeft,:) = a.Port1(infoLeft,:);
    a.infoPort(infoRight,:) = a.Port3(infoRight,:);
    a.randPort(infoLeft,:) = a.Port3(infoLeft,:);
    a.randPort(infoRight,:) = a.Port1(infoRight,:);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Save the processed struct next to the raw data, in a 'current_pp'
    % subfolder, with the same base filename plus a '_pp' suffix.
    [sessionpath,name,ext]=fileparts(filepath);

    savedir = fullfile(pathname, 'current_pp');

    if exist(savedir)
        savepath=savedir;
    else
        mkdir(savedir);
        savepath=savedir;
    end

    savename=fullfile(savepath,[name '_pp' ext]);
    save(savename,'-struct','a','-v7.3');
    clearvars -except pathname files numFiles f folders;

end % end for each file
