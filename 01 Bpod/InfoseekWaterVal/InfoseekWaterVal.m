
%{
----------------------------------------------------------------------------
InfoseekWaterVal — Protocol for task with 4 center ports odors to compare information and water value
----------------------------------------------------------------------------

Runs four forced-choice trial types cued by odor at the center port: information, no information (random),
high water value (big), low water value (small). Usually, the same side (left/right) is assigned to information
and small.

TASK STRUCTURE (per trial):
  1. Mouse pokes center port → receives an odor cueing the forced side
     for this trial (info, rand, big, small)
  2. Mouse pokes the cued side port
  3. Side port delivers a second odor (only on information or random trials)
  4. After a delay (with an auditory warning tone predicting reward size),
     water reward is delivered at the same port
     (mouse must be present in port only at outcome time to receive reward)

TRIAL TYPES (set by S.GUI.TrialTypes):
  1 = Small       — center odor = SmallOdor
  2 = Info Forced — center odor = InfoOdor
  3 = Rand Forced — center odor = RandOdor
  4 = Big         — center odor = BigOdor

SIDE ASSIGNMENT:
  S.GUI.InfoSide (0/1): 0 = Info odors (A/B) go LEFT, Rand odors (C/D) go RIGHT
                         1 = Info odors (A/B) go RIGHT, Rand odors (C/D) go LEFT
  S.GUI.BigSide  (0/1): 0 = Big water trials go LEFT, Small water trials go RIGHT
                         1 = Big water trials go RIGHT, Small water trials go LEFT
  Info and small water normally set to the same side.

HARDWARE:
  ValveModule1   — control mineral oil (center / left / right)
  ValveModule2/3 — odor valves (8 positions each)
  DIOmodule (Teensy) — buzzer, latch valves (flip side port odors from left to right)
  HiFi module (H) — go-cue tone and reward-predictive tones (sounds 1-3 loaded at start)
  BNC1/2 — sync signals to DAQ/miniscope/tracking camera via GlobalTimers 7/8

REWARD DROPS:
  Drops are delivered via looping GlobalTimers (3 = left valve, 4 = right).
  Drop counts controlled by S.GUI.Info/Rand Big/SmallDrops and S.GUI.Big/SmallDrops.

OUTCOME CODES (BpodSystem.Data.Outcomes):
   1 = Small no-choice     5 = Info no-choice   11 = Rand no-choice   17 = Big no-choice
   2 = Small correct       6 = Info big         12 = Rand big         18 = Big correct
   3 = Small NP            7 = Info big NP      13 = Rand big NP      19 = Big NP
   4 = Small incorrect     8 = Info small       14 = Rand small       20 = Big incorrect
                            9 = Info small NP   15 = Rand small NP
                           10 = Info incorrect  16 = Rand incorrect
----------------------------------------------------------------------------

Three valve control modules control airflow in the custom dilution
olfactometer.

One Teensy 3.2 connected as a module with the Bpod Teensy Shield controls
a buzzer (not used when Hifi tones in use) and latch valves via 2 H-bridges.

%}
function InfoseekWaterVal

    global BpodSystem
    
    %% Assert HiFi module is present + USB-paired (via USB button on console GUI)
    BpodSystem.assertModule('HiFi', 1); % The second argument (1) indicates that the HiFi module must be paired with its USB serial port
    
    % Create an instance of the HiFi module
    H = BpodHiFi(BpodSystem.ModuleUSB.HiFi1); % The argument is the name of the HiFi module's USB serial port (e.g. COM3)
    
    %% Create trial manager object
    TrialManager = TrialManagerObject;
    
    %% Define parameters
    
    S = BpodSystem.ProtocolSettings; % Load settings chosen in launch manager into current workspace as a struct called S
    if isempty(fieldnames(S))  % No saved settings — populate with defaults
        % Session structure
        S.GUI.SessionTrials = 1000;
        S.GUI.TrialTypes = 2;   % 1=Small, 2=Info, 3=Rand, 4=Big, 5-8=mixes (see SetTrialTypes)
        S.GUI.InfoSide = 0;     % 0=info→left/rand→right, 1=info→right/rand→left
        S.GUI.BigSide = 0;      % 0=big→left/small→right, 1=big→right/small→left

        % Center-port odor valve indices (positions on ValveModule2/3)
        S.GUI.InfoOdor = 2;
        S.GUI.RandOdor = 0;
        S.GUI.BigOdor = 3;
        S.GUI.SmallOdor = 1;

        % Side-port odor valve indices
        S.GUI.OdorA = 3; % Info big
        S.GUI.OdorB = 2; % Info small
        S.GUI.OdorC = 0; % Rand big
        S.GUI.OdorD = 1; % Rand small

        % Timing (seconds)
        S.GUI.CenterDelay = 0;    % delay after center poke before odor onset
        S.GUI.CenterOdorTime = 0.2;  % duration of center-port odor (s)
        S.GUI.StartDelay = 0;     % delay after center odor before go cue
        S.GUI.OdorDelay = 0;      % delay after go cue before side odor onset
        S.GUI.OdorTime = 0;       % duration of side-port odor (s)
        S.GUI.RewardDelay = 0.5;  % delay from odor offset to reward delivery (s)
        S.GUI.Signal = 0.2;       % fraction of RewardDelay spent as an audible/light warning before reward
        S.GUI.GracePeriod = 100000000; % additional time (s) to wait for response after go cue on top of OdorDelay; odor then delivered immediately upon correct side port entry
        S.GUI.Interval = 1;       % inter-trial interval (s)

        % Reward drops (number of valve open/close cycles per reward)
        S.GUI.InfoBigDrops = 1;
        S.GUI.InfoSmallDrops = 1;
        S.GUI.RandBigDrops = 1;
        S.GUI.RandSmallDrops = 1;
        S.GUI.BigDrops = 8;
        S.GUI.SmallDrops = 2;

        % Reward probability (fraction of trials that give big reward; rest give small)
        S.GUI.InfoRewardProb = 1;
        S.GUI.RandRewardProb = 1;

        BpodSystem.ProtocolSettings = S;
        SaveProtocolSettings(BpodSystem.ProtocolSettings);
    end
    
    %% Set Latch Valves
    SetLatchValves(S);
    
    %% Set up trial types and rewards
    
    S.TrialTypes = [];
    S.RewardTypes = [];
    S.RandOdorTypes = [];
    S = SetTrialTypes(S,1); % Sets S.TrialTypes from trial 1 to maxTrials
    S = SetRewardTypes(S,1); % Sets S.RewardTypes, S.RandOdorTypes from trial 1 to maxTrials
    
    %% SET INITIAL TYPE COUNTS
    
    BpodSystem.Data.TrialCounts = [0,0,0,0];
    BpodSystem.Data.PlotOutcomes = [];
    
    %% SAVE EVENT NAMES AND NUMBER
    
    BpodSystem.Data.TrialTypes = []; % The trial type of each trial completed will be added here.
    BpodSystem.Data.Outcomes = [];
    
    BpodSystem.Data.OrigTrialTypes = S.TrialTypes; % take out if working?
    BpodSystem.Data.OrigRewardTypes = S.RewardTypes; % take out if working?
    BpodSystem.Data.EventNames = BpodSystem.StateMachineInfo.EventNames;
    SaveBpodSessionData;
    
    %% Initialize plots
    
    BpodSystem.ProtocolFigures.TrialTypePlotFig = figure('Position', [50 640 1000 250],'name','Trial Type','numbertitle','off', 'MenuBar', 'none');
    BpodSystem.GUIHandles.TrialTypePlot = axes('OuterPosition', [0 0 1 1]);
    TrialTypePlotInfoWater(BpodSystem.GUIHandles.TrialTypePlot,'init',S.TrialTypes,min([S.GUI.SessionTrials 40])); % trial choice types  
    % EventsPlot('init', getStateColors(S.GUI.InfoSide)); % events within trial
    
    BpodSystem.ProtocolFigures.OutcomePlotFig = figure('Position', [50 100 600 400],'name','TrialOutcomes','numbertitle','off', 'MenuBar', 'none');
    BpodSystem.GUIHandles.OutcomePlot = axes('OuterPosition', [0 0 1 1]);
    InfoWaterOutcomesPlot(BpodSystem.GUIHandles.OutcomePlot,'init');
    
    BpodNotebook('init');
    InfoParameterGUI('init', S); % Initialize parameter GUI plugin
    TotalRewardDisplayInfo('init');
    
    %% INITIALIZE SERIAL MESSAGES / DIO
    
    ResetSerialMessages();
    
    buzzer1 = [254 1];
    buzzer2 = [253 1];
    
    modules = BpodSystem.Modules.Name;
    DIOmodule = [modules(strncmp('DIO',modules,3))];
    DIOmodule = DIOmodule{1};
    
    % Set serial messages for Teensy module to control box, communicate with
    % DAQ/miniscope
    LoadSerialMessages(DIOmodule, {buzzer1, buzzer2,...
        [22 1],[22 0],[23 1], [23 0]});
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ODOR CONTROL SERIAL MESSAGES
    LoadSerialMessages('ValveModule1',{[1 2],[3 4],[5 6]}); % control by port
    
    
    %% Define sounds and send to sound module
    sf = 192000; % Use max supported sampling rate
    H.SamplingRate = sf;
    
    noRewardFreq=500;
    rewardFreq=2000;
    toneDuration=0.5;
    
    rewardSound = GenerateSineWave(sf, noRewardFreq, toneDuration)*.9; 
                                 % Sampling freq (hz), Sine frequency (hz), duration (s)
    noRewardSound = GenerateSineWave(sf, rewardFreq, toneDuration)*.9;
    
    goSound = GenerateSineWave(sf, 1200, 0.05)*.9;
    
    % Setup HiFi module
    % H.HeadphoneAmpEnabled = true; H.HeadphoneAmpGain = 10; % Ignored if using HD version of the HiFi module
    H.DigitalAttenuation_dB = -50; % Set a negative value here if necessary for digital volume control.
    H.load(1, rewardSound);
    H.load(2, noRewardSound);
    H.load(3, goSound);
    
    
    % Define 1ms linear ramp envelope of amplitude coefficients, to apply at sound onset + in reverse at sound offset
    envelope = 1/(sf*0.001):1/(sf*0.001):1; 
    H.AMenvelope = envelope;
    
    
    %% INITIALIZE STATE MACHINE
    
    [sma,S,nextRewardLeft,nextRewardRight] = PrepareStateMachine(S, 1, []); % Prepare state machine for trial 1 with empty "current events" variable
    
    TrialManager.startTrial(sma); % Sends & starts running first trial's state machine. A MATLAB timer object updates the 
                                  % console UI, while code below proceeds in parallel.
    RewardLeft = nextRewardLeft; RewardRight = nextRewardRight;
    
    %% MAIN TRIAL LOOP
    
    for currentTrial = 1:S.GUI.SessionTrials
        currentS = S;
        currentTrialEvents = TrialManager.getCurrentEvents({'WaitForOdorLeft','WaitForOdorRight','NoChoice','Incorrect'}); % Hangs here until Bpod enters one of the listed trigger states, then returns current trial's states visited + events captured to this point                       
        if BpodSystem.Status.BeingUsed == 0
            TurnOffAllOdors();
        return; end % If user hit console "stop" button, end session
        [sma, S, nextRewardLeft,nextRewardRight] = PrepareStateMachine(S, currentTrial+1, currentTrialEvents); % Prepare next state machine.
        SendStateMachine(sma, 'RunASAP'); % send the next trial's state machine while the current trial is ongoing
        RawEvents = TrialManager.getTrialData; % Hangs here until trial is over, then retrieves full trial's raw data
        if BpodSystem.Status.BeingUsed == 0
            TurnOffAllOdors();
            return; end % If user hit console "stop" button, end session 
        HandlePauseCondition; % Checks to see if the protocol is paused. If so, waits until user resumes.
        TrialManager.startTrial(); % Start processing the next trial's events
        if ~isempty(fieldnames(RawEvents)) % If trial data was returned from last trial, update plots and save data
            BpodSystem.Data = AddTrialEvents(BpodSystem.Data,RawEvents); % Computes trial events from raw data
            [rewardAmount,outcome] = UpdateOutcome(currentTrial,currentS,RewardLeft,RewardRight);
            BpodSystem.Data.TrialSettings(currentTrial) = currentS.GUI; % Adds the settings used for the current trial to the Data struct (to be saved after the trial ends)
            BpodSystem.Data.TrialTypes(currentTrial) = currentS.TrialTypes(currentTrial); % Adds the trial type of the current trial to data
            BpodSystem.Data.Outcomes(currentTrial) = outcome;
            BpodSystem.Data = BpodNotebook('sync', BpodSystem.Data); % Sync with Bpod notebook plugin
            TotalRewardDisplayInfo('add',rewardAmount);
            RewardLeft = nextRewardLeft; RewardRight = nextRewardRight;
            TrialTypePlotInfoWater(BpodSystem.GUIHandles.TrialTypePlot,'update',currentTrial,S.TrialTypes);
            InfoWaterOutcomesPlot(BpodSystem.GUIHandles.OutcomePlot,'update');
            tic
            SaveBpodSessionData;
            toc
        end
    
    end

end % end of protocol main function


%% PREPARE STATE MACHINE

function [sma, S, RewardLeft, RewardRight] = PrepareStateMachine(S, nextTrial, currentTrialEvents)
% Build state machine for nextTrial.
% currentTrialEvents: events captured so far from the current (running) trial,
%   used to detect early port entry and extend trial type arrays if needed.
% Returns updated S, and the reward valve timer counts for left/right.

    global BpodSystem;
    
    modules = BpodSystem.Modules.Name;
    DIOmodule = [modules(strncmp('DIO',modules,3))];
    DIOmodule = DIOmodule{1};
    
    lastS = S;
    S = InfoParameterGUI('sync', S); % Sync parameters with BpodParameterGUI plugin
    
    
    if S.GUI.TrialTypes ~= lastS.GUI.TrialTypes
       S = SetTrialTypes(S,nextTrial);
    end
    
    if (S.GUI.InfoRewardProb ~= lastS.GUI.InfoRewardProb || S.GUI.RandRewardProb ~= lastS.GUI.RandRewardProb)
        S = SetRewardTypes(S,nextTrial);
    end
    
    if (S.GUI.InfoSide ~= lastS.GUI.InfoSide)
       SetLatchValves(S);
    end
    
    % DETERMINE TRIAL TYPE
    if nextTrial>1
        previousStates = currentTrialEvents.StatesVisited;
        if sum(contains(previousStates,'NoChoice') | contains(previousStates,'Incorrect'))>0
            S = UpdateTrialTypes(nextTrial,S);
        end
    end
    
    nextTrialType = S.TrialTypes(nextTrial);
    
    infoSide = S.GUI.InfoSide;
    TrialCounts = BpodSystem.Data.TrialCounts;
    bigSide = S.GUI.BigSide;
    
    % Determine trial-specific state matrix fields
    % Set trialParams (reward and odor)
    switch nextTrialType
        case 1 % SMALL
            ThisCenterOdor = S.GUI.SmallOdor;
            LeftSideOdor = 0;
            RightSideOdor = 0;
            if bigSide == 0 % BIG LEFT
                ChooseLeft = 'Incorrect'; ChooseRight = 'WaitForOdorRight';
                RewardLeft = 0; RewardRight = 1;
                OutcomeStateLeft = 'TimeoutOutcome';
                LeftRewardDrops = 0;
                SideOdorStateLeft = 'TimeoutOdor';
                SideOdorStateRight = 'OdorWaterRight';
                SideOdorOffActionRight = [];
                SideOdorOffActionLeft = [];
                ToneCmd =[];
                OutcomeStateRight = 'RightSmallReward';
                RightRewardDrops = S.GUI.SmallDrops;
            else
                ChooseLeft = 'WaitForOdorLeft'; ChooseRight = 'Incorrect';
                RewardLeft = 1; RewardRight = 0;
                OutcomeStateRight = 'TimeoutOutcome';
                RightRewardDrops = 0;
                SideOdorStateRight = 'TimeoutOdor';
                SideOdorStateLeft = 'OdorWaterLeft';
                SideOdorOffActionRight = [];
                SideOdorOffActionLeft = [];
                ToneCmd =[];
                OutcomeStateLeft = 'LeftSmallReward';
                LeftRewardDrops = S.GUI.SmallDrops;           
            end
                 
        case 2 % INFO FORCED
            ThisCenterOdor = S.GUI.InfoOdor;
            if infoSide == 0
                % info on left
                RewardLeft = S.RewardTypes(TrialCounts(2)+1,1); RewardRight = 0;
                ChooseLeft = 'WaitForOdorLeft'; ChooseRight = 'Incorrect';
                RightSideOdor = 0;
                if RewardLeft == 1
                    OutcomeStateLeft = 'LeftBigReward';
                    LeftRewardDrops = S.GUI.InfoBigDrops;
                    LeftSideOdor = S.GUI.OdorA;
                    SideOdorStateLeft = 'OdorALeft'; 
                    ToneCmd = {'HiFi1', ['P' 0]};
                else
                    OutcomeStateLeft = 'LeftSmallReward';
                    LeftRewardDrops = S.GUI.InfoSmallDrops;
                    LeftSideOdor = S.GUI.OdorB;
                    SideOdorStateLeft = 'OdorBLeft';
                    ToneCmd = {'HiFi1', ['P' 1]};
                end
                SideOdorOffActionLeft = RunOdor(LeftSideOdor,1);
                SideOdorOffActionRight =[];
                OutcomeStateRight = 'TimeoutOutcome';
                RightRewardDrops = 0;
                SideOdorStateRight = 'TimeoutOdor';
            else
                RewardLeft = 0; RewardRight = S.RewardTypes(TrialCounts(2)+1,1);
                ChooseLeft = 'Incorrect'; ChooseRight = 'WaitForOdorRight';
                LeftSideOdor = 0;
                if RewardRight == 1
                    OutcomeStateRight = 'RightBigReward';
                    RightRewardDrops = S.GUI.InfoBigDrops;
                    RightSideOdor = S.GUI.OdorA;
                    SideOdorStateRight = 'OdorARight';
                    ToneCmd = {'HiFi1', ['P' 0]};
                else
                    OutcomeStateRight = 'RightSmallReward';
                    RightRewardDrops = S.GUI.InfoSmallDrops;
                    RightSideOdor = S.GUI.OdorB;
                    SideOdorStateRight = 'OdorBRight';
                    ToneCmd = {'HiFi1', ['P' 1]};
                end
                SideOdorOffActionRight = RunOdor(RightSideOdor,2);
                SideOdorOffActionLeft =[];
                OutcomeStateLeft = 'TimeoutOutcome';
                LeftRewardDrops = 0;
                SideOdorStateLeft = 'TimeoutOdor';
            end
        case 3 % RAND FORCED
            ThisCenterOdor = S.GUI.RandOdor;
            if infoSide == 0 % INFO ON LEFT
                RewardLeft = 0; RewardRight = S.RewardTypes(TrialCounts(3)+1,2);
                ChooseLeft = 'Incorrect'; ChooseRight = 'WaitForOdorRight';
                RightSideOdorFlag = S.RandOdorTypes(TrialCounts(3)+1,1);
                if RightSideOdorFlag == 0
                    RightSideOdor = S.GUI.OdorC;
                    SideOdorStateRight = 'OdorCRight';
                else
                    RightSideOdor = S.GUI.OdorD;
                    SideOdorStateRight = 'OdorDRight';
                end            
                LeftSideOdor = 0;
                SideOdorOffActionRight = RunOdor(RightSideOdor,2);
                SideOdorOffActionLeft =[];
                if RewardRight == 1
                    OutcomeStateRight = 'RightBigReward';
                    RightRewardDrops = S.GUI.RandBigDrops;
                    ToneCmd = {'HiFi1', ['P' 0]};
                else
                    OutcomeStateRight = 'RightSmallReward';
                    RightRewardDrops = S.GUI.RandSmallDrops;
                    ToneCmd = {'HiFi1', ['P' 1]};
                end
                OutcomeStateLeft = 'TimeoutOutcome';
                LeftRewardDrops = 0;
                SideOdorStateLeft = 'TimeoutOdor';
            else
                RewardLeft = S.RewardTypes(TrialCounts(3)+1,2); RewardRight = 0;
                ChooseLeft = 'WaitForOdorLeft'; ChooseRight = 'Incorrect';
                LeftSideOdorFlag = S.RandOdorTypes(TrialCounts(3)+1,1);
                if LeftSideOdorFlag == 0
                    LeftSideOdor = S.GUI.OdorC;
                    SideOdorStateLeft = 'OdorCLeft';
                else
                    LeftSideOdor = S.GUI.OdorD;
                    SideOdorStateLeft = 'OdorDLeft';
                end             
                RightSideOdor = 0;
                SideOdorOffActionLeft = RunOdor(LeftSideOdor,1);
                SideOdorOffActionRight =[];
                if RewardLeft == 1
                    OutcomeStateLeft = 'LeftBigReward';
                    LeftRewardDrops = S.GUI.RandBigDrops;
                    ToneCmd = {'HiFi1', ['P' 0]};
                else
                    OutcomeStateLeft = 'LeftSmallReward';
                    LeftRewardDrops = S.GUI.RandSmallDrops;
                    ToneCmd = {'HiFi1', ['P' 1]};
                end
                OutcomeStateRight = 'TimeoutOutcome';
                RightRewardDrops = 0;
                SideOdorStateRight = 'TimeoutOdor';
            end
        case 4 % BIG
            ThisCenterOdor = S.GUI.BigOdor;
            LeftSideOdor = 0;
            RightSideOdor = 0;            
            if bigSide == 0 % BIG LEFT
                ChooseLeft = 'WaitForOdorLeft'; ChooseRight = 'Incorrect';
                RewardLeft = 1; RewardRight = 0;
                OutcomeStateRight = 'TimeoutOutcome';
                RightRewardDrops = 0;
                SideOdorStateRight = 'TimeoutOdor';
                SideOdorStateLeft = 'OdorWaterLeft';
                SideOdorOffActionLeft = [];
                SideOdorOffActionRight =[];
                ToneCmd =[];
                OutcomeStateLeft = 'LeftBigReward';
                LeftRewardDrops = S.GUI.BigDrops;
            else
                ChooseLeft = 'Incorrect'; ChooseRight = 'WaitForOdorRight';
                RewardLeft = 0; RewardRight = 1;
                OutcomeStateLeft = 'TimeoutOutcome';
                LeftRewardDrops = 0;
                SideOdorStateLeft = 'TimeoutOdor';
                SideOdorStateRight = 'OdorWaterRight';
                SideOdorOffActionRight = [];
                SideOdorOffActionLeft =[];
                ToneCmd =[];
                OutcomeStateRight = 'RightBigReward';
                RightRewardDrops = S.GUI.BigDrops;
            end
    end
    
    % Water parameters
    R = GetValveTimes(4, [1 3]);
    % R = [0.100 0.100];
    LeftValveTime = R(1); RightValveTime = R(2); % Update reward amounts
    MaxValveTime = max(R);
    maxDrops = max([S.GUI.InfoBigDrops,S.GUI.InfoSmallDrops,S.GUI.RandBigDrops,S.GUI.RandSmallDrops,S.GUI.SmallDrops,S.GUI.BigDrops]);
    RewardPauseTime = 0.05;
    
    % Time for reward lights
    WarningTime = ceil(S.GUI.Signal*S.GUI.RewardDelay);
    DelayTime = S.GUI.RewardDelay - WarningTime;
    
    sma = NewStateMatrix(); % Assemble state matrix
    
    sma = SetCondition(sma, 1, 'Port1', 1); % Condition 1: Port 1 high (is in) (left)
    sma = SetCondition(sma, 2, 'Port2', 1); % Condition 2: Port 2 high (is in) (center)
    sma = SetCondition(sma, 3, 'Port3', 1); % Condition 3: Port 3 high (is in) (right)
    sma = SetCondition(sma, 4, 'Port1', 0); % Condition 4: Port 1 low (is out) (left)
    sma = SetCondition(sma, 5, 'Port2', 0); % Condition 5: Port 2 low (is out) (center)
    sma = SetCondition(sma, 6, 'Port3', 0); % Condition 6: Port 3 low (is out) (right)
    
    % TIMERS
    sma = SetCondition(sma, 7, 'GlobalTimer1', 0);
    
    % sma = SetGlobalTimer(sma, 'TimerID', 1, 'Duration', S.GUI.OdorDelay+0.05); % ODOR DELAY + GO CUE
    sma = SetGlobalTimer(sma, 'TimerID', 1, 'Duration', S.GUI.OdorDelay+0.05,...
        'OnsetDelay', 0, 'Channel', 'SoftCode', 'OnMessage', 0, 'OffMessage', 0,...
        'Loop', 0, 'SendEvents', 1, 'LoopInterval', 0,'OnsetTrigger','010000'); %also turn on timer 5
    
    % TIMER 2 FOR MAX REWARD
    if maxDrops > 1
        sma = SetGlobalTimer(sma, 'TimerID', 2, 'Duration', MaxValveTime,...
            'OnsetDelay', 0, 'Channel', 'SoftCode', 'OnMessage',0, 'OffMessage', 0,...
            'Loop', maxDrops, 'SendEvents', 1, 'LoopInterval', RewardPauseTime); % timer to stay in reward state
    else
        sma = SetGlobalTimer(sma, 'TimerID', 2, 'Duration', MaxValveTime,...
            'OnsetDelay', 0, 'Channel', 'SoftCode', 'OnMessage', 0, 'OffMessage', 0,...
            'Loop', 0, 'SendEvents', 1, 'LoopInterval', 0); % timer to stay in reward state    
    end
    sma = SetGlobalCounter(sma, 2, 'GlobalTimer2_End', maxDrops);
    
    % reward states all wait for timers to end
    % set multiple timers for each outcome--one for drops, one for blanks
    % get rid of reward states
    
    % Timers for delivering reward drops
    if LeftRewardDrops > 1
       sma = SetGlobalTimer(sma,'TimerID',3,'Duration',LeftValveTime,'OnsetDelay',0,...
           'Channel', 'Valve1', 'OnMessage', 1, 'OffMessage', 0, 'Loop',...
           LeftRewardDrops, 'SendEvents', 1, 'LoopInterval', RewardPauseTime,'OnsetTrigger', '10');
       sma = SetGlobalCounter(sma, 3, 'GlobalTimer3_End', LeftRewardDrops);
    elseif LeftRewardDrops == 1
       sma = SetGlobalTimer(sma,'TimerID',3,'Duration',LeftValveTime,'OnsetDelay',0,...
           'Channel','Valve1','OnMessage', 1, 'OffMessage', 0, 'Loop', 0, 'SendEvents', 1,'LoopInterval',0,'OnsetTrigger', '10');
       sma = SetGlobalCounter(sma, 3, 'GlobalTimer3_End', 1);
    else
       sma = SetGlobalTimer(sma,'TimerID',3,'Duration',0,'OnsetDelay',0,...
           'Channel','Valve1','OnMessage', 0, 'OffMessage', 0, 'Loop', 0, 'SendEvents', 1,'LoopInterval',0,'OnsetTrigger', '10');
       sma = SetGlobalCounter(sma, 3, 'GlobalTimer3_End', 1);
    end
    
    if RightRewardDrops > 1
        sma = SetGlobalTimer(sma,'TimerID',4,'Duration', RightValveTime,'OnsetDelay',0,...
            'Channel', 'Valve3', 'OnMessage', 1, 'OffMessage', 0, 'Loop',...
            RightRewardDrops, 'SendEvents', 1, 'LoopInterval', RewardPauseTime,'OnsetTrigger', '10');
        sma = SetGlobalCounter(sma, 4, 'GlobalTimer4_End', RightRewardDrops);
    elseif RightRewardDrops == 1
        sma = SetGlobalTimer(sma,'TimerID',4,'Duration',RightValveTime,'OnsetDelay',0,...
            'Channel', 'Valve3', 'OnMessage', 1, 'OffMessage', 0, 'Loop', 0, 'SendEvents', 1,'LoopInterval',0,'OnsetTrigger', '10');
        sma = SetGlobalCounter(sma, 4, 'GlobalTimer4_End', 1);
    else
        sma = SetGlobalTimer(sma,'TimerID',4,'Duration',0,'OnsetDelay',0,...
            'Channel', 'Valve3', 'OnMessage', 0, 'OffMessage', 0, 'Loop', 0, 'SendEvents', 1,'LoopInterval',0,'OnsetTrigger', '10');
        sma = SetGlobalCounter(sma, 4, 'GlobalTimer4_End', 1);
    end
    
    sma = SetGlobalTimer(sma, 'TimerID', 7,... 
        'Duration',0.01, 'OnsetDelay', 0,...
        'Channel', 'BNC1', 'OnMessage', 1,... 
        'OffMessage', 0, 'Loop', 1,...
        'SendEvents', 1, 'LoopInterval', 0.1);
    
    % sma = SetGlobalTimer(sma, 'TimerID', 8,... 
    %     'Duration',0.1, 'OnsetDelay', 0,...
    %     'Channel', 'BNC2', 'OnMessage', 1,... 
    %     'OffMessage', 0, 'Loop', 0,...
    %     'SendEvents', 1);
    
    sma = SetGlobalTimer(sma, 'TimerID', 8, 'Duration', 0.01, 'OnsetDelay', 0,...
                         'Channel', 'BNC2', 'OnLevel', 1, 'OffLevel', 0,...
                         'Loop', 1, 'SendGlobalTimerEvents', 1, 'LoopInterval', 0.04);
            
    % STATES
    sma = AddState(sma, 'Name', 'TimerStart', ...
        'Timer', 0,...
        'StateChangeConditions', {'Tup', 'InterTrialInterval'},...
        'OutputActions', {'GlobalTimerTrig',7,'HiFi1','*'});
    sma = AddState(sma, 'Name', 'InterTrialInterval', ...
        'Timer', S.GUI.Interval,...
        'StateChangeConditions', {'Tup', 'StartTrial'},...
        'OutputActions', {'GlobalTimerTrig',8});
    sma = AddState(sma, 'Name', 'StartTrial', ...
        'Timer', 0,...
        'StateChangeConditions', {'Tup', 'WaitForCenter'},...
        'OutputActions', {});
    sma = AddState(sma, 'Name', 'WaitForCenter', ...
        'Timer', 0,...
        'StateChangeConditions', {'Port2In', 'CenterDelay','Condition2','CenterDelay'},... % test how these are different!
        'OutputActions', {'PWM2',50}); % port light on
    sma = AddState(sma, 'Name', 'CenterDelay', ...
        'Timer', S.GUI.CenterDelay,...
        'StateChangeConditions', {'Tup', 'CenterOdor','Port2Out','WaitForCenter'},...
        'OutputActions', {'PWM2',50});
    sma = AddState(sma, 'Name', 'CenterOdor', ...
        'Timer', S.GUI.CenterOdorTime,...
        'StateChangeConditions', {'Port2Out', 'CenterOdorOff', 'Tup', 'CenterPostOdorDelay'},...
        'OutputActions',[{DIOmodule,3,'PWM2',50},RunOdor(ThisCenterOdor,0)]);
    sma = AddState(sma, 'Name', 'CenterOdorOff',...
        'Timer', 0,...
        'StateChangeConditions', {'Tup','WaitForCenter'},...
        'OutputActions', [{DIOmodule,4,'PWM2',50},RunOdor(ThisCenterOdor,0)]);
    sma = AddState(sma, 'Name', 'CenterPostOdorDelay', ...
        'Timer', S.GUI.StartDelay,...
        'StateChangeConditions', {'Port2Out','WaitForCenter','Tup','GoCue'},... % is that right?
        'OutputActions', [{DIOmodule,4,'PWM2',50},RunOdor(ThisCenterOdor,0)]);
    sma = AddState(sma, 'Name', 'GoCue', ...
        'Timer', 0.05,...
        'StateChangeConditions', {'Tup','Response'},...
        'OutputActions', {'GlobalTimerTrig',1,'HiFi1', ['P' 2]});
    
    % RESPONSE (CHOICE) --> MAKE SURE STAY IN SIDE FOR AT LEAST A SMALL TIME TO INDICATE CHOICE?
    sma = AddState(sma, 'Name', 'Response', ...
        'Timer', S.GUI.OdorDelay,...
        'StateChangeConditions', {'Tup','GracePeriod','Port1In',ChooseLeft,'Port3In',ChooseRight},...
        'OutputActions', {});
    
    sma = AddState(sma, 'Name', 'GracePeriod',...
        'Timer', S.GUI.GracePeriod,...
        'StateChangeConditions', {'Tup','NoChoice','Port1In',ChooseLeft,'Port3In',ChooseRight},...
        'OutputActions', {});    
    
    % AFTER CHOICE
    
    % LEFT
    sma = AddState(sma, 'Name', 'WaitForOdorLeft', ...
        'Timer', 0,...
        'StateChangeConditions', {'GlobalTimer1_End',SideOdorStateLeft,'Condition7',SideOdorStateLeft},...
        'OutputActions', {});
    sma = AddState(sma, 'Name', 'OdorALeft', ...
        'Timer', S.GUI.OdorTime,...
        'StateChangeConditions', {'Tup','RewardDelayLeft'},...
        'OutputActions', [{DIOmodule,5}, RunOdor(LeftSideOdor,1)]);
    sma = AddState(sma, 'Name', 'OdorBLeft', ...
        'Timer', S.GUI.OdorTime,...
        'StateChangeConditions', {'Tup','RewardDelayLeft'},...
        'OutputActions', [{DIOmodule,5}, RunOdor(LeftSideOdor,1)]);
    sma = AddState(sma, 'Name', 'OdorCLeft', ...
        'Timer', S.GUI.OdorTime,...
        'StateChangeConditions', {'Tup','RewardDelayLeft'},...
        'OutputActions', [{DIOmodule,5}, RunOdor(LeftSideOdor,1)]);
    sma = AddState(sma, 'Name', 'OdorDLeft', ...
        'Timer', S.GUI.OdorTime,...
        'StateChangeConditions', {'Tup','RewardDelayLeft'},...
        'OutputActions', [{DIOmodule,5}, RunOdor(LeftSideOdor,1)]);
    sma = AddState(sma, 'Name', 'OdorWaterLeft', ...
        'Timer', S.GUI.OdorTime,...
        'StateChangeConditions', {'Tup','RewardDelayWaterLeft'},...
        'OutputActions', {DIOmodule,5});
    sma = AddState(sma, 'Name', 'RewardDelayWaterLeft', ...
        'Timer', DelayTime,...
        'StateChangeConditions', {'Tup','LeftWarning'},...
        'OutputActions', {DIOmodule,6});    
    sma = AddState(sma, 'Name', 'RewardDelayLeft', ...
        'Timer', DelayTime,...
        'StateChangeConditions', {'Tup','LeftWarning'},...
        'OutputActions', [{DIOmodule,6}, RunOdor(LeftSideOdor,1)]);
    
    % LEFT REWARD
    sma = AddState(sma, 'Name', 'LeftWarning', ...
        'Timer', WarningTime,...
        'StateChangeConditions', {'Tup','LeftPortCheck'},...
        'OutputActions', [{'PWM1',50},ToneCmd]); 
    sma = AddState(sma, 'Name', 'LeftPortCheck',...
        'Timer',0,...
        'StateChangeConditions',{'Condition4','LeftNotPresent','Condition1',OutcomeStateLeft},...
        'OutputActions',{});
    sma = AddState(sma, 'Name', 'LeftBigReward', ...
        'Timer', 0,...
        'StateChangeConditions', {'Tup','OutcomeDelivery','Condition4','LeftNotPresent'},...
        'OutputActions', {'GlobalTimerTrig', 3}); %, 'GlobalTimerTrig', 3
    sma = AddState(sma, 'Name', 'LeftSmallReward', ...
        'Timer', 0,...
        'StateChangeConditions', {'Tup','OutcomeDelivery','Condition4','LeftNotPresent'},...
        'OutputActions', {'GlobalTimerTrig', 3}); %, 'GlobalTimerTrig', 3
    sma = AddState(sma, 'Name', 'LeftNotPresent', ...
        'Timer', 0,...
        'StateChangeConditions', {'Tup','OutcomeDelivery'},...
        'OutputActions', {'GlobalTimerTrig', 2});
    
    
    % CHOOSE RIGHT
    sma = AddState(sma, 'Name', 'WaitForOdorRight', ...
        'Timer', 0,...
        'StateChangeConditions', {'GlobalTimer1_End',SideOdorStateRight,'Condition7',SideOdorStateRight},...
        'OutputActions', {});
    sma = AddState(sma, 'Name', 'OdorARight', ...
        'Timer', S.GUI.OdorTime,...
        'StateChangeConditions', {'Tup','RewardDelayRight'},...
        'OutputActions', [{DIOmodule,5}, RunOdor(RightSideOdor,2)]);
    sma = AddState(sma, 'Name', 'OdorBRight', ...
        'Timer', S.GUI.OdorTime,...
        'StateChangeConditions', {'Tup','RewardDelayRight'},...
        'OutputActions', [{DIOmodule,5}, RunOdor(RightSideOdor,2)]);
    sma = AddState(sma, 'Name', 'OdorCRight', ...
        'Timer', S.GUI.OdorTime,...
        'StateChangeConditions', {'Tup','RewardDelayRight'},...
        'OutputActions', [{DIOmodule,5}, RunOdor(RightSideOdor,2)]);
    sma = AddState(sma, 'Name', 'OdorDRight', ...
        'Timer', S.GUI.OdorTime,...
        'StateChangeConditions', {'Tup','RewardDelayRight'},...
        'OutputActions', [{DIOmodule,5}, RunOdor(RightSideOdor,2)]);
    sma = AddState(sma, 'Name', 'OdorWaterRight', ...
        'Timer', S.GUI.OdorTime,...
        'StateChangeConditions', {'Tup','RewardDelayWaterRight'},...
        'OutputActions', {DIOmodule,5});
    sma = AddState(sma, 'Name', 'RewardDelayWaterRight', ...
        'Timer', DelayTime,...
        'StateChangeConditions', {'Tup','RightWarning'},...
        'OutputActions', {DIOmodule,6});
    sma = AddState(sma, 'Name', 'RewardDelayRight', ...
        'Timer', DelayTime,...
        'StateChangeConditions', {'Tup','RightWarning'},...
        'OutputActions', [{DIOmodule,6}, RunOdor(RightSideOdor,2)]);
    
    % RIGHT REWARD
    sma = AddState(sma, 'Name', 'RightWarning', ...
        'Timer', WarningTime,...
        'StateChangeConditions', {'Tup','RightPortCheck'},...
        'OutputActions', [{'PWM3',50},ToneCmd]); 
    sma = AddState(sma, 'Name', 'RightPortCheck',...
        'Timer',0,...
        'StateChangeConditions',{'Condition6','RightNotPresent','Condition3',OutcomeStateRight},...
        'OutputActions',{});
    sma = AddState(sma, 'Name', 'RightBigReward', ...
        'Timer', 0,...
        'StateChangeConditions', {'Tup','OutcomeDelivery','Condition6','RightNotPresent'},...
        'OutputActions', {'GlobalTimerTrig', 4}); %, 'GlobalTimerTrig', 4
    sma = AddState(sma, 'Name', 'RightSmallReward', ...
        'Timer', 0,...
        'StateChangeConditions', {'Tup','OutcomeDelivery','Condition6','RightNotPresent'},...
        'OutputActions', {'GlobalTimerTrig', 4}); %, 'GlobalTimerTrig', 4
    sma = AddState(sma, 'Name', 'RightNotPresent', ...
        'Timer', 0,...
        'StateChangeConditions', {'Tup','OutcomeDelivery'},...
        'OutputActions', {'GlobalTimerTrig', 2});
    
    % Waits for max drops time
    sma = AddState(sma, 'Name','OutcomeDelivery','Timer',0,...
        'StateChangeConditions',{'GlobalCounter2_End','EndTrial'},...
        'OutputActions',{});
    
    % if no choice during response
    sma = AddState(sma, 'Name', 'NoChoice', ...
        'Timer', 0,...
        'StateChangeConditions', {'GlobalTimer1_End', 'TimeoutOdor', 'Condition7', 'TimeoutOdor'},...
        'OutputActions', {});
    
    % For incorrect choices (left/right on forced trials)
    sma = AddState(sma, 'Name', 'Incorrect', ...
        'Timer', 0,...
        'StateChangeConditions', {'GlobalTimer1_End','TimeoutOdor','Condition7', 'TimeoutOdor'},...
        'OutputActions', {});
    
    sma = AddState(sma, 'Name', 'TimeoutOdor', ...
        'Timer', S.GUI.OdorTime,...
        'StateChangeConditions', {'Tup','TimeoutRewardDelay'},...
        'OutputActions', {});
    sma = AddState(sma, 'Name', 'TimeoutRewardDelay', ...
        'Timer', S.GUI.RewardDelay,...
        'StateChangeConditions', {'Tup','TimeoutPortCheck'},...
        'OutputActions', {});
    sma = AddState(sma, 'Name', 'TimeoutPortCheck', ...
        'Timer', 0,...
        'StateChangeConditions', {'Tup','TimeoutOutcome'},...
        'OutputActions', {});
    sma = AddState(sma, 'Name', 'TimeoutOutcome', ...
        'Timer', 0,...
        'StateChangeConditions', {'GlobalCounter2_End','EndTrial'},...
        'OutputActions', {'GlobalTimerTrig', 2});
    
    sma = AddState(sma, 'Name', 'EndTrial', ...
        'Timer', 1,...
        'StateChangeConditions', {'Tup', '>exit'},...
        'OutputActions', {'GlobalTimerCancel',2});
end

%% TRIAL TYPES

function S = UpdateTrialTypes(i,S)
% Insert a repeat of trial i-1 at position i, shifting everything else forward.
% Called when a mouse enters a side port before odor delivery, to re-present
% the current trial type before advancing.
    TrialTypes = S.TrialTypes;
    S.TrialTypes = [TrialTypes(1:i-1); TrialTypes(i-1); TrialTypes(i:end-1)];
    S.RewardTypes = [S.RewardTypes(1:i-1,:); S.RewardTypes(i-1,:); S.RewardTypes(i:end-1,:)];
    S.RandOdorTypes = [S.RandOdorTypes(1:i-1); S.RandOdorTypes(i-1); S.RandOdorTypes(i:end-1)];
end

function S = SetTrialTypes(S,currentTrial)
% Build S.TrialTypes array from currentTrial to SessionTrials.
% Trial types (1=Small, 2=Info, 3=Rand, 4=Big) are shuffled in blocks of blockSize
% according to the percentages set by S.GUI.TrialTypes.

    global BpodSystem;

    %% Define trial choice types

    maxTrials = S.GUI.SessionTrials;

    typesAvailable = S.GUI.TrialTypes;

    blockSize = 12;
    blockToShuffle = zeros(blockSize,1);
    typeBlockSize = 8;
    bigPercent = 0; smallPercent = 0; infoPercent = 0; randPercent = 0;

    switch typesAvailable 
        case 1
            smallPercent = 1; bigPercent = 0; infoPercent = 0; randPercent = 0;
            blockToShuffle = [1 1 1 1 1 1 1 1 1 1 1 1];
        case 2
            smallPercent = 0; bigPercent = 0;  infoPercent = 1; randPercent = 0;
            blockToShuffle = [2 2 2 2 2 2 2 2 2 2 2 2];
        case 3
            smallPercent = 0; bigPercent = 0;  infoPercent = 0; randPercent = 1;
            blockToShuffle = [3 3 3 3 3 3 3 3 3 3 3 3];
        case 4
            smallPercent = 0; bigPercent = 1;  infoPercent = 0; randPercent = 0;
            blockToShuffle = [4 4 4 4 4 4 4 4 4 4 4 4];
        case 5
            smallPercent = 0.25; bigPercent = 0.25;  infoPercent = 0.25; randPercent = 0.25; 
            blockToShuffle = [1 1 1 2 2 2 3 3 3 4 4 4];
        case 6
            smallPercent = 0.5; bigPercent = 0.5;  infoPercent = 0; randPercent = 0;
            blockToShuffle = [1 1 1 1 1 1 4 4 4 4 4 4];
        case 7
            smallPercent = 0.5; bigPercent = 0;  infoPercent = 0.5; randPercent = 0;
            blockToShuffle = [1 1 1 1 1 1 2 2 2 2 2 2];
        case 8
            smallPercent = 0; bigPercent = 0.5;  infoPercent = 0; randPercent = 0.5;
            blockToShuffle = [4 4 4 4 4 4 3 3 3 3 3 3];
    end

    blocks = ceil(maxTrials/blockSize);
    TrialTypes = zeros(blocks*blockSize,1);

    block=blockToShuffle;

    for n = 1:blocks
        for m = 1:blockSize
            i = randi(blockSize);
            temp = block(m);
            block(m) = block(i);
            block(i) = temp;
        end
        if n == 1
           TrialTypes(1:blockSize) = block; 
        else
            TrialTypes((n-1)*blockSize+1:n*blockSize) = block;
        end
    end

%     TrialTypes = [2; 2; 3; 3; 2; 2; 3; 3; TrialTypes];
    TrialTypes=TrialTypes(1:maxTrials);
    if currentTrial==1
        S.TrialTypes = TrialTypes;
    else
        S.TrialTypes = [S.TrialTypes(1:currentTrial-1); TrialTypes(1:end-currentTrial+1)];
        TrialTypePlotInfoWater(BpodSystem.GUIHandles.TrialTypePlot,'update',currentTrial,S.TrialTypes);
    end
    

end

function S = SetRewardTypes(S,currentTrial)
% Build S.RewardTypes (Nx2 matrix) and S.RandOdorTypes (Nx1) from currentTrial to SessionTrials.
% Columns of RewardTypes: [InfoForced, RandForced] — each column holds a shuffled
% list of 1s (big) and 0s (small) per block, giving the reward size for each
% successive Info or Rand forced trial.

    maxTrials = S.GUI.SessionTrials;
    typeBlockSize = 8;    
    
    %% SET REWARD BLOCKS

    infoBigCount = round(S.GUI.InfoRewardProb*typeBlockSize);
    randBigCount = round(S.GUI.RandRewardProb*typeBlockSize);

    infoBlockShuffle = zeros(typeBlockSize,1);
    randBlockShuffle = zeros(typeBlockSize,1);
    randOdorBlockShuffle = zeros(typeBlockSize,1);

    infoBlockShuffle(1:infoBigCount) = 1;
    randBlockShuffle(1:randBigCount) = 1;
    
    if S.GUI.RandRewardProb == 0 | S.GUI.RandRewardProb == 1
        randOdorBigCount = ceil(typeBlockSize/2);
    else
        randOdorBigCount = randBigCount;
    end
    randOdorBlockShuffle(1:randOdorBigCount) = 1;

    typeBlockCount = ceil(maxTrials/typeBlockSize);
    RewardTypes = zeros(typeBlockCount*typeBlockSize,2);
    RandOdorTypes = zeros(typeBlockCount*typeBlockSize,1);

    infoBlock = infoBlockShuffle;
    randBlock = randBlockShuffle;
    randOdorBlock = randOdorBlockShuffle;

    % info forced
    for n = 1:typeBlockCount
        for m = 1:typeBlockSize
            i = randi(typeBlockSize);
            temp = infoBlock(m);
            infoBlock(m) = infoBlock(i);
            infoBlock(i) = temp;
        end
        if n == 1
           RewardTypes(1:typeBlockSize,1) = infoBlock'; 
        else
            RewardTypes((n-1)*typeBlockSize+1:n*typeBlockSize,1) = infoBlock';
        end
    end

    % rand forced
    for n = 1:typeBlockCount
        for m = 1:typeBlockSize
            i = randi(typeBlockSize);
            temp = randBlock(m);
            randBlock(m) = randBlock(i);
            randBlock(i) = temp;
        end
        if n == 1
           RewardTypes(1:typeBlockSize,2) = randBlock'; 
        else
            RewardTypes((n-1)*typeBlockSize+1:n*typeBlockSize,2) = randBlock';
        end
    end

    % rand odors
    for n = 1:typeBlockCount
        for m = 1:typeBlockSize
            i = randi(typeBlockSize);
            temp = randOdorBlock(m);
            randOdorBlock(m) = randOdorBlock(i);
            randOdorBlock(i) = temp;
        end
        if n == 1
           RandOdorTypes(1:typeBlockSize) = randOdorBlock'; 
        else
            RandOdorTypes((n-1)*typeBlockSize+1:n*typeBlockSize) = randOdorBlock';
        end
    end

    % Trial types (rewards) to pull from
    RewardTypes = RewardTypes(1:maxTrials,:);

    % Rand Odors to pull from
    % RandOdorTypes = repmat(RandOdorTypes,1,4);
    RandOdorTypes = RandOdorTypes(1:maxTrials);

    if currentTrial == 1
        S.RandOdorTypes = RandOdorTypes;
        S.RewardTypes = RewardTypes;
    else
        S.RandOdorTypes = [S.RandOdorTypes(1:currentTrial); RandOdorTypes(1:end-currentTrial)];
        S.RewardTypes = [S.RewardTypes(1:currentTrial,:); RewardTypes(1:end-currentTrial,:)];
    end
end

%% ODOR CONTROL

function OdorOutputActions = RunOdor(odorID,port)
% Return the {module, valve} output action pairs needed to route odorID through port.
% port: 0=center, 1=left, 2=right
% odorID: 0-3 maps to physical valve positions on ValveModule2/3
    switch port
        case 0
            cmd1 = {'ValveModule1',1}; % center control  
            switch odorID
                case 0
                    cmd2 = {'ValveModule2',1};
                    cmd3 = {'ValveModule3',1};
                case 1
                    cmd2 = {'ValveModule2',2};
                    cmd3 = {'ValveModule3',2};
                case 2
                    cmd2 = {'ValveModule2',3};
                    cmd3 = {'ValveModule3',3};                    
                case 3
                    cmd2 = {'ValveModule2',4};
                    cmd3 = {'ValveModule3',4};                    
            end
        case 1 % LEFT
            cmd1 = {'ValveModule1',2}; % left control
            switch odorID
                case 0
                    cmd2 = {'ValveModule2',5};
                    cmd3 = {'ValveModule3',5};
                case 1
                    cmd2 = {'ValveModule2',6};
                    cmd3 = {'ValveModule3',6};
                case 2
                    cmd2 = {'ValveModule2',7};
                    cmd3 = {'ValveModule3',7};                    
                case 3
                    cmd2 = {'ValveModule2',8};
                    cmd3 = {'ValveModule3',8};                    
            end            
        case 2 % RIGHT
            cmd1 = {'ValveModule1',3}; % right control
            switch odorID
                case 0
                    cmd2 = {'ValveModule2',5};
                    cmd3 = {'ValveModule3',5};
                case 1
                    cmd2 = {'ValveModule2',6};
                    cmd3 = {'ValveModule3',6};
                case 2
                    cmd2 = {'ValveModule2',7};
                    cmd3 = {'ValveModule3',7};                    
                case 3
                    cmd2 = {'ValveModule2',8};
                    cmd3 = {'ValveModule3',8};
            end
    end
    OdorOutputActions = [cmd1,cmd2,cmd3];
end

function TurnOffAllOdors()
% Close all 8 positions on all three valve modules. Called on session end or abort.
    for v = 1:8
        ModuleWrite('ValveModule1',['C' v]);
        ModuleWrite('ValveModule2',['C' v]);
        ModuleWrite('ValveModule3',['C' v]);
    end 
end

%% SET ODOR SIDES (LATCH VALVES)
function SetLatchValves(S)
% Configure DIOmodule connections to H-bridge powering of Lee Company latch valves to route odors to the correct ports
% based on S.GUI.InfoSide (0=info→left, 1=info→right).
    global BpodSystem
    
    infoSide = S.GUI.InfoSide;
modules = BpodSystem.Modules.Name;
% latchValves = [16 15 14 11 10 9 8 7]; % evens to left!
latchModule = [modules(strncmp('DIO',modules,3))];
latchModule = latchModule{1};

% now, latch odds to the left. for 0, 1, 2, 3
latchValves = [7 8 9 10 11 14 15 16]; % evens to left! odor 0 left, odor 0 right, odor 1 left,

    if infoSide == 0 % SEND INFO ODORS TO LEFT (A,B)    
        odorApin = latchValves((S.GUI.OdorA+1)*2-1);
        odorBpin = latchValves((S.GUI.OdorB+1)*2-1);
        odorCpin = latchValves((S.GUI.OdorC+1)*2);
        odorDpin = latchValves((S.GUI.OdorD+1)*2);
    else
        odorApin = latchValves((S.GUI.OdorA+1)*2);
        odorBpin = latchValves((S.GUI.OdorB+1)*2);
        odorCpin = latchValves((S.GUI.OdorC+1)*2-1);
        odorDpin = latchValves((S.GUI.OdorD+1)*2-1);    
    end

    pins = [odorApin odorBpin odorCpin odorDpin];

    for i = 1:4
        ModuleWrite(latchModule,[pins(i) 1]);
        pause(100/1000);
        ModuleWrite(latchModule,[pins(i) 0]);
        pause(100/1000);
    end
    
%     BpodSystem.GUIHandles.EventsPlot.StateColors = getStateColors(infoSide);
%     EventsPlot('init', getStateColors(infoSide));
end

%% OUTCOME

function [rewardAmount, Outcome] = UpdateOutcome(currentTrial,S,RewardLeft,RewardRight)
% Determine outcome code and reward amount from the completed trial's raw events.
% RewardLeft/RewardRight: reward size (big=1, small=0) pre-computed for this trial
% (only meaningful for Info/Rand forced trials; Small/Big trials have a fixed size).
% Outcome codes are defined in the file header.
% Updates BpodSystem.Data.TrialCounts and .PlotOutcomes in place.

    global BpodSystem
    % BpodSystem.Data.RawEvents(currentTrial)
    TrialData = BpodSystem.Data.RawEvents.Trial{currentTrial};
    TrialCounts = BpodSystem.Data.TrialCounts;
    PlotOutcomes = BpodSystem.Data.PlotOutcomes;
    
    trialType = S.TrialTypes(currentTrial);
    infoSide = S.GUI.InfoSide;
    bigSide = S.GUI.BigSide;
    infoBigReward = S.GUI.InfoBigDrops*4;
    infoSmallReward = S.GUI.InfoSmallDrops*4;
    randBigReward = S.GUI.RandBigDrops*4;
    randSmallReward = S.GUI.RandSmallDrops*4;
    bigReward = S.GUI.BigDrops*4;
    smallReward = S.GUI.SmallDrops*4;
    rewardAmount = 0;
    x = currentTrial;
    newTrialCounts = TrialCounts;
    newPlotOutcomes = PlotOutcomes;
    
    % Plot outcomes: 2 = no choice, incorrect, info correct, rand correct,
    % not present
    
    % change to no choice, incorrect, info correct big info correct small
    % rand correct big/ not present info big not present info small
    
        switch trialType
            case 1
                if bigSide == 0
                    if ~isnan(TrialData.States.NoChoice(1))
                        newPlotOutcomes(x) = 14;
                        Outcome = 1; % small no choice
                    elseif ~isnan(TrialData.States.WaitForOdorRight(1))
                        newTrialCounts(1) = TrialCounts(1) + 1; % small
                        if ~isnan(TrialData.States.RightSmallReward(1))
                            Outcome = 2; % small correct
                            rewardAmount = smallReward;
                            newPlotOutcomes(x) = 10;
                        else
                            newPlotOutcomes(x) = 12;
                            Outcome = 3; % small NP
                        end
                    else
                        Outcome = 4; % small incorrect
                        newPlotOutcomes(x) = 13;
                    end
                else
                    if ~isnan(TrialData.States.NoChoice(1))
                        newPlotOutcomes(x) = 14;
                        Outcome = 1; % small no choice
                    elseif ~isnan(TrialData.States.WaitForOdorLeft(1))
                        newTrialCounts(1) = TrialCounts(1) + 1; % small
                        if ~isnan(TrialData.States.LeftSmallReward(1))
                            Outcome = 2; % small correct
                            rewardAmount = smallReward;
                            newPlotOutcomes(x) = 10;
                        else
                            newPlotOutcomes(x) = 12;
                            Outcome = 3; % small NP
                        end
                    else
                        Outcome = 4; % small incorrect
                        newPlotOutcomes(x) = 13;
                    end
                end
                
            case 2 % INFO
                    if ~isnan(TrialData.States.NoChoice(1))
                        newPlotOutcomes(x) = 14;
                        Outcome = 5; % info no choice
                    elseif infoSide==0 & ~isnan(TrialData.States.WaitForOdorLeft(1))
                        newTrialCounts(2) = TrialCounts(2) + 1; % infoforced
                        if RewardLeft == 1
                            if ~isnan(TrialData.States.LeftBigReward(1))
                                Outcome = 6; % info big
                                rewardAmount = infoBigReward;
                                newPlotOutcomes(x) = 1;
                            else
                                newPlotOutcomes(x) = 5;
                                Outcome = 7; % info big NP
                            end
                        else
                            if ~isnan(TrialData.States.LeftSmallReward(1))
                                Outcome = 8; % info small
                                rewardAmount = infoSmallReward;
                                newPlotOutcomes(x) = 2;
                            else
                                newPlotOutcomes(x) = 6;
                                Outcome = 9; % info small NP
                            end
                        end
                    elseif infoSide==1 & ~isnan(TrialData.States.WaitForOdorRight(1))
                        newTrialCounts(2) = TrialCounts(2) + 1; % infoforced
                        if RewardRight == 1
                            if ~isnan(TrialData.States.RightBigReward(1))
                                Outcome = 6; % info big
                                rewardAmount = infoBigReward;
                                newPlotOutcomes(x) = 1;
                            else
                                newPlotOutcomes(x) = 5;
                                Outcome = 7; % info big NP
                            end
                        else
                            if ~isnan(TrialData.States.RightSmallReward(1))
                                Outcome = 8; % info small
                                rewardAmount = infoSmallReward;
                                newPlotOutcomes(x) = 2;
                            else
                                newPlotOutcomes(x) = 6;
                                Outcome = 9; % info small NP
                            end
                        end
                    else
                        newTrialCounts(2) = TrialCounts(2) + 1; % infoforced
                        newPlotOutcomes(x) = 13;
                        Outcome = 10; % info incorrect
                    end
                
            case 3 %NO INFO
                    if ~isnan(TrialData.States.NoChoice(1))
                        newPlotOutcomes(x) = 14;
                        Outcome = 11; % rand no choice
                    elseif infoSide==0 & ~isnan(TrialData.States.WaitForOdorRight(1))
                        newTrialCounts(3) = TrialCounts(3) + 1; % randforced
                        if RewardRight == 1
                            if ~isnan(TrialData.States.RightBigReward(1))
                                Outcome = 12; % rand big
                                rewardAmount = randBigReward;
                                newPlotOutcomes(x) = 3;
                            else
                                newPlotOutcomes(x) = 7;
                                Outcome = 13; % rand big NP
                            end
                        else
                            if ~isnan(TrialData.States.RightSmallReward(1))
                                Outcome = 14; % rand small
                                rewardAmount = randSmallReward;
                                newPlotOutcomes(x) = 4;
                            else
                                newPlotOutcomes(x) = 8;
                                Outcome = 15; % rand small NP
                            end
                        end
                    elseif infoSide==1 & ~isnan(TrialData.States.WaitForOdorLeft(1))
                        newTrialCounts(3) = TrialCounts(3) + 1; % randforced
                        if RewardLeft == 1
                            if ~isnan(TrialData.States.LeftBigReward(1))
                                Outcome = 12; % rand big
                                rewardAmount = randBigReward;
                                newPlotOutcomes(x) = 3;
                            else
                                newPlotOutcomes(x) = 7;
                                Outcome = 13; % rand big NP
                            end
                        else
                            if ~isnan(TrialData.States.LeftSmallReward(1))
                                Outcome = 14; % rand small
                                rewardAmount = randSmallReward;
                                newPlotOutcomes(x) = 4;
                            else
                                newPlotOutcomes(x) = 8;
                                Outcome = 15; % rand small NP
                            end
                        end
                    else
                        newTrialCounts(3) = TrialCounts(3) + 1; % rand forced
                        newPlotOutcomes(x) = 13;
                        Outcome = 16; % rand incorrect
                    end

                case 4 % BIG WATER
                    if bigSide == 0
                        if ~isnan(TrialData.States.NoChoice(1))
                            newPlotOutcomes(x) = 14;
                            Outcome = 17; % big no choice
                        elseif ~isnan(TrialData.States.WaitForOdorLeft(1))
                            newTrialCounts(4) = TrialCounts(4) + 1; % big
                            if ~isnan(TrialData.States.LeftBigReward(1))
                                Outcome = 18; % big correct
                                rewardAmount = bigReward;
                                newPlotOutcomes(x) = 9;
                            else
                                newPlotOutcomes(x) = 11;
                                Outcome = 19; % big NP
                            end
                        else
                            Outcome = 20; % big incorrect
                            newPlotOutcomes(x) = 13;
                        end
                    else
                        if ~isnan(TrialData.States.NoChoice(1))
                            newPlotOutcomes(x) = 14;
                            Outcome = 17; % big no choice
                        elseif ~isnan(TrialData.States.WaitForOdorRight(1))
                            newTrialCounts(4) = TrialCounts(4) + 1; % big
                            if ~isnan(TrialData.States.RightBigReward(1))
                                Outcome = 18; % big correct
                                rewardAmount = bigReward;
                                newPlotOutcomes(x) = 9;
                            else
                                newPlotOutcomes(x) = 11;
                                Outcome = 19; % big NP
                            end
                        else
                            Outcome = 20; % big incorrect
                            newPlotOutcomes(x) = 13;
                        end
                    end
        end
    BpodSystem.Data.TrialCounts = newTrialCounts;
    BpodSystem.Data.PlotOutcomes = newPlotOutcomes;
end

        
