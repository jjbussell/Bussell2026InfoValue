%% BehaviorAnalysisAll

% Loads concatenated behavior data file(s) and performs statistical
% analyses including determining preference for information, reaction time,
% correct trial choices and identifies information side location reversals
% training periods and computes per-training-day behavioral measures


%% LOADING DATA FILES

a1=a; clear a; % to begin from already in memory bpod data file


% Uncomment if using all three data files. Loads the three data files if needed
% a1=load('behaviorMiceBpodPorts6.mat');
% a2=load('behaviorMicePreBpodPorts6_JB334_JB339.mat');
% a3=load('behaviorMicePreBpodPorts6.mat');
% 
a1.sessions2.name={a1.sessions(:).name}';
a1.sessions2.date={a1.sessions(:).date}';
a1.sessions2.mouse={a1.sessions(:).mouse}';

a1.sessions=a1.sessions2;

% uncomment if all three data files in use 
% a2.sessionname=a2.sessions.name;
% a2.sessiondate=a2.sessions.date;
% a2.sessionmouse=a2.sessions.mouse;
% 
% a3.sessionname=a3.sessions.name;
% a3.sessiondate=a3.sessions.date;
% a3.sessionmouse=a3.sessions.mouse;


% some cleanup to be sure all files compatible
% % DELETE SESSIONS2, a no longer used field
a1=rmfield(a1,'sessions2');
% 
a1.earlyInfoLicks = a1.earlyInfoLicks(a1.correct==1);
a1.anticipatoryInfoLicks = a1.anticipatoryInfoLicks(a1.correct==1);
a1.waterInfoLicks = a1.waterInfoLicks(a1.correct==1);
a1.earlyRandLicks = a1.earlyRandLicks(a1.correct==1);
a1.anticipatoryRandLicks = a1.anticipatoryRandLicks(a1.correct==1);
a1.waterRandLicks = a1.waterRandLicks(a1.correct==1);

a1.odorAtrials = a1.odorAtrials(a1.correct==1);
a1.odorBtrials = a1.odorBtrials(a1.correct==1);
a1.odorCtrials = a1.odorCtrials(a1.correct==1);
a1.odorDtrials = a1.odorDtrials(a1.correct==1);
a1.trialLength = a1.trialLength(a1.correct==1);
a1.trialStart = a1.StartTrial(:,1);
a1=rmfield(a1,'StartTrial');

a1.odor2LeavingTime = a1.odor2LeavingTime-a1.odor2On;
a1.odor2LeavingTime(:,[2 3]) = [a1.file a1.trial];

% uncomment if using all three data files 
% a2.earlyInfoLicks = NaN(size(a2.earlyLicks));
% a2.anticipatoryInfoLicks = NaN(size(a2.earlyLicks));
% a2.waterInfoLicks = NaN(size(a2.earlyLicks));
% a2.earlyRandLicks = NaN(size(a2.earlyLicks));
% a2.anticipatoryRandLicks = NaN(size(a2.earlyLicks));
% a2.waterRandLicks = NaN(size(a2.earlyLicks));
% a2.infoCorr=a2.info(a2.correct==1);
% 
% a2.earlyInfoLicks(a2.infoCorr==1,1) = a2.earlyLicks(a2.infoCorr==1,1);
% a2.anticipatoryInfoLicks(a2.infoCorr==1,1) = a2.anticipatoryLicks(a2.infoCorr==1,1);
% a2.waterInfoLicks(a2.infoCorr==1,1) = a2.waterLicks(a2.infoCorr==1,1);
% a2.earlyRandLicks(a2.infoCorr==0,1) = a2.earlyLicks(a2.infoCorr==0,1);
% a2.anticipatoryRandLicks(a2.infoCorr==0,1) = a2.anticipatoryLicks(a2.infoCorr==0,1);
% a2.waterRandLicks(a2.infoCorr==0,1) = a2.waterLicks(a2.infoCorr==0,1);
% 
% a3.earlyInfoLicks = NaN(size(a3.earlyLicks));
% a3.anticipatoryInfoLicks = NaN(size(a3.earlyLicks));
% a3.waterInfoLicks = NaN(size(a3.earlyLicks));
% a3.earlyRandLicks = NaN(size(a3.earlyLicks));
% a3.anticipatoryRandLicks = NaN(size(a3.earlyLicks));
% a3.waterRandLicks = NaN(size(a3.earlyLicks));
% a3.infoCorr=a3.info(a3.correct==1);
% 
% a3.earlyInfoLicks(a3.infoCorr==1,1) = a3.earlyLicks(a3.infoCorr==1,1);
% a3.anticipatoryInfoLicks(a3.infoCorr==1,1) = a3.anticipatoryLicks(a3.infoCorr==1,1);
% a3.waterInfoLicks(a3.infoCorr==1,1) = a3.waterLicks(a3.infoCorr==1,1);
% a3.earlyRandLicks(a3.infoCorr==0,1) = a3.earlyLicks(a3.infoCorr==0,1);
% a3.anticipatoryRandLicks(a3.infoCorr==0,1) = a3.anticipatoryLicks(a3.infoCorr==0,1);
% a3.waterRandLicks(a3.infoCorr==0,1) = a3.waterLicks(a3.infoCorr==0,1);
% 
% a2.rewardParams = [a2.infoBigDrops a2.infoSmallDrops a2.randBigDrops...
% a2.randSmallDrops a2.infoProb a2.randProb];
% 
% a3.rewardParams = [a3.infoBigDrops a3.infoSmallDrops a3.randBigDrops...
% a3.randSmallDrops a3.infoProb a3.randProb];
% 
% a2.centerEntryFirst=a2.firstCenterEntry;
% a3.centerEntryFirst=a3.firstCenterEntry;
% 
% 
% a2.file=a2.file+max(a1.file);
% a3.file=a3.file+(max(a1.file)+max(a2.file));
% 

%% return to the 'a' data structre

a=a1;


%% To save all three files together now to have ready to use in this script

% vars=fields(a1);
% %%
% for i=1:numel(vars)
%     a.(vars{i})=cat(1,a.(vars{i}),a2.(vars{i}));
% end
% 
% for i=1:numel(vars)
%     a.(vars{i})=cat(1,a.(vars{i}),a3.(vars{i}));
% end
% 
% save(fullfile(datapath,'infoSeekData_ALLBEHAVIOR6.mat'),'-struct','a','-v7.3');
% 
% clear a1 a2 a3;
clear a1 % comment this and uncomment above if using all three data files
% 
% % a=load('infoSeekData_ALLBEHAVIOR6.mat'); % to load all of the data
% together with this loading step already completed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ANALYSIS OF ALL MICE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TRIAL TYPES

a.trialCt = numel(a.trialType);

% TRIAL CHOICE TYPES (includes NP but not no choice or incorrect)

a.choiceTypeNames = {'InfoForced','RandForced','Choice'};
a.choiceTypeCts = [sum(a.trialType == 2) sum(a.trialType == 3) sum(a.trialType == 1)];
a.infoForced = a.trialType == 2 & a.correct == 1;
a.randForced = a.trialType == 3 & a.correct == 1;
a.infoChoice = a.trialType == 1 & a.correct == 1 & a.info == 1;
a.randChoice = a.trialType == 1 & a.correct == 1 & a.info == 0;

% ALL CORRECT TRIALS (INCLUDES NOT PRESENT BUT NOT NO CHOICE OR INCORRECT)

infoBig = [2,3,11,12];
infoSmall = [4,5,13,14];
randBig = [6,7,17,18];
randSmall = [8,9,19,20];

a.infoBig = ismember(a.outcome,infoBig);
a.infoSmall = ismember(a.outcome,infoSmall);
a.randBig = ismember(a.outcome,randBig);
a.randSmall = ismember(a.outcome,randSmall);
a.infoBigCorr = a.infoBig(a.correct);
a.infoSmallCorr = a.infoSmall(a.correct);
a.randBigCorr = a.randBig(a.correct);
a.randSmallCorr = a.randSmall(a.correct);
% 
a.rewardCorr=a.reward(a.correct==1); %these are the same! no, different length

a.typeNames = {'Info Water','Info None','Rand Water','Rand None'};
a.typeSizes = [sum(a.infoBig) sum(a.infoSmall) sum(a.randBig) sum(a.randSmall)];

% a.choiceCorrTrials = a.trialType == 1 & a.correct == 1 & a.trialTypes == 5;
% a.forcedCorrTrials = a.trialType ~= 1 & a.correct == 1;
a.infoCorrTrials = a.info == 1 & a.correct == 1;
a.randCorrTrials = a.info == 0 & a.correct == 1;
a.infoCorr = a.info(a.correct == 1);

 % ERRORS
 
 a.errorLabels = {'Correct','No Choice','Incorrect Choice','Not Present','Leaving Timeout'};

% a.centerEntryCount = sum(~isnan(a.CenterOdor),2)/2;
% a.completeInitiation = a.centerEntryCount == 1;

% doesn't include NP (NP info small is not an error)-->NOW IT DOES!
% NP info small is outcome 5 and 14
% how to check if timeout or not?!?

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

a.infoForcedCorrect = a.infoForcedCorr(a.correct==1);
a.infoChoiceCorrect = a.infoChoiceCorr(a.correct==1);
a.randForcedCorrect = a.randForcedCorr(a.correct==1);
a.randChoiceCorrect = a.randChoiceCorr(a.correct==1);

a.choiceCorrTypeNames = {'InfoForced','RandForced','InfoChoice',...
    'RandChoice'};
a.choiceTypeCtsCorr = [sum(a.infoForcedCorr) sum(a.randForcedCorr) sum(a.infoChoiceCorr) sum(a.randChoiceCorr)];

% NOT PRESENT

% a.infoForcedNP = ismember(a.outcome,[12 14]);
% a.randForcedNP = ismember(a.outcome,[18 20]);
% a.choiceInfoNP = ismember(a.outcome,[3 5]);
% a.choiceRandNP = ismember(a.outcome,[7 9]);
% a.notPresent = ismember(a.outcome,[3 5 7 9 12 14 18 20]);

% ERRORTYPES
a.errorTypes = NaN(numel(a.file),1);

a.errorTypes(ismember(a.outcome,[2,4,6,8,11,13,17,19]))= 1; % correct
a.errorTypes(ismember(a.outcome,[1,10,16]))= 2; % no choice
a.errorTypes(ismember(a.outcome,[15,21]))= 3; % incorrect
a.errorTypes(ismember(a.outcome,[3,5,7,9,12,14,18,20]))= 4; % not present
%     a.errorTypes(a.timeout==1)= 5; % timeout


% REACTION SPEED
a.rxnSpeed = 1./a.rxn;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% MICE AND DAYS

a.mouseList = unique(a.mouse);
a.mouseCt = numel(a.mouseList);
a.mouseDay=NaN(size(a.file));

for m = 1:a.mouseCt
   a.mice(:,m) = strcmp(a.mouse,a.mouseList(m)) == 1;
   a.mouseDays{m} = unique(a.day(a.mice(:,m)==1)); % sorts
   a.mouseDayCt(m) = size(a.mouseDays{m},1);
   mouseFirstDay = find(strcmp(a.mouse,a.mouseList{m})& strcmp(a.day,a.mouseDays{m}(1)),1);
   a.initinfoside(m,1) = a.infoSide(mouseFirstDay);
   a.mouseTrialTypes{m}=unique(a.trialTypes(a.mice(:,m)==1));
end

for t = 1:numel(a.file)
    a.mouseDay(t,1)=find(strcmp(a.day(t,1),a.mouseDays{find(a.mice(t,:))})); %#ok<FNDSB>
end

a.mouseNums = arrayfun(@(X)  find(a.mice(X,:),1,'last'), 1:size(a.mice,1))';
a.mouseNumsCorr = a.mouseNums(a.correct==1);

%% INITIAL INFO SIDE

% infoSide = 0, info left

a.initinfoside_info = -ones(a.trialCt,1); % initinfoside_info all trials by info-ness. 1 if initinfoside, -1 if reversed
a.initinfoside_side = ones(a.trialCt,1); % initinfoside_side all trials

for m = 1:a.mouseCt
    ok = a.mice(:,m) == 1;
    a.initinfoside_info(a.infoSide == a.initinfoside(m) & ok == 1) = 1;
end

%choice_all includes info-ness of incorrect choices, NaN only on no choice
a.choice_all = a.info;
% reverseFlag = a.initinfoside_info == -1 & a.correct==1;
reverseFlag = a.initinfoside_info == -1 & a.errorTypes~=2;
a.choice_all(reverseFlag& ~isnan(a.choice_all)) = ~a.choice_all(reverseFlag & ~isnan(a.choice_all));

%% TRAINING DAYS

a.training=zeros(size(a.file));
a.training(a.odorTime>0&a.trialTypes==4)=1; % after sides different
a.training(a.odorTime==0&a.trialTypes==4)=2; % before sides different

for m=1:a.mouseCt
   a.trainingDays{m,1}=unique(a.mouseDay(a.mouseNums==m&a.training==1));
   a.trainingDays{m,2}=unique(a.mouseDay(a.mouseNums==m&a.training==2));
end

%% REVERSAL

a.reverseDay = cell(a.mouseCt,3);
a.reverse = zeros(numel(a.file),1);
a.firstChoiceDay=zeros(a.mouseCt,1);
a.choiceMice = zeros(a.mouseCt,1);
a.reverseMice = zeros(a.mouseCt,1);
a.reverseTypes = [1 -1 2 -2];
for m = 1:a.mouseCt
    ok = a.mice(:,m)==1 ; 
    mouseTrials = find(ok);
    mouseTrialTypes = a.trialTypes(ok);
    mouseFile = a.file(ok);
%     mouseParams = [a.rewardParams(ok,:) a.rewardDelay(ok)];
%     mouseParams = a.rewardParams(ok,:);
    mouseParams = a.rewardParams(ok,[1 3]);
    if sum(mouseTrialTypes == 5) > 0
        a.choiceMice(m,1) = 1;
        [sortedMouseDays, a.mouseDayIdx{1,m}] = sort(a.mouseDay(ok));
        mouseDayIdx = a.mouseDayIdx{1,m}; % idx into mouse's unsorted trials to sort by day
        mouseTrialsIdx = mouseTrials(mouseDayIdx); % idx into all trials of mouse's sorted trials, same as above?!?
        sortedMouseTrialTypes = mouseTrialTypes(mouseDayIdx);
        firstChoiceIdx = find(sortedMouseTrialTypes == 5,1,'First'); % idx into sorted -- for mouseTrialsIdx b/c it's sorted
        lastChoiceIdx = find(sortedMouseTrialTypes == 5,1,'Last');        
        a.firstChoiceDay(m,1) = sortedMouseDays(firstChoiceIdx);
       
        mouseInfoside = a.infoSide(ok);
        sortedMouseInfoside = mouseInfoside(mouseDayIdx);
        mouseInfoSideDiff=diff(sortedMouseInfoside);
        reversesIdx = find(mouseInfoSideDiff ~= 0);
        if ~isempty(reversesIdx)
            if any(reversesIdx>firstChoiceIdx)
                reversesIdx=reversesIdx(reversesIdx>firstChoiceIdx);
                a.reverseMice(m,1) = 1;
                sortedMouseParams = mouseParams(mouseDayIdx,:);
%                 sortedMouseParams = sortedMouseParams(firstChoiceIdx:end,:);
                [paramChanges,~] = find(diff(sortedMouseParams,1,1));
                sortParamChanges=sort(paramChanges);
                paramChange = sortParamChanges(find(sortParamChanges>firstChoiceIdx,1));
%                 [paramChange,~] = find(diff(sortedMouseParams,1,1),1,'first');
                if ~isempty(paramChange) & paramChange>reversesIdx(1) 
%                     lastRevTrial = paramChange+firstChoiceIdx; % into sorted trials, but only from first choice?
                    lastRevTrial = paramChange;
                    reversesIdx(reversesIdx>lastRevTrial)=[];
                else
                    lastRevTrial = numel(mouseTrials);
                end
                reverses = mouseDayIdx(reversesIdx); % idx in unsorted mouse trials            
                for r = 1:numel(reverses)
                   a.reverseDay{m,r} = sortedMouseDays(reversesIdx(r))+1; % day of reverse 
                end
                if sortedMouseTrialTypes(lastRevTrial)==5
                    a.lastParamDay(m,1) = sortedMouseDays(lastRevTrial);
                else
                    a.lastParamDay(m,1) = sortedMouseDays(lastRevTrial)-1;
                end
                if numel(reverses)>1
                    for r = 1:numel(reverses)-1
                        if r==1
                            a.reverse(mouseTrialsIdx(firstChoiceIdx:reversesIdx(1))) = 1;
                            a.reverse(mouseTrialsIdx(reversesIdx(1)+1:reversesIdx(2))) = -1;
                        elseif r>1 & r<numel(reverses)-2 %#ok<AND2>
                            a.reverse(mouseTrialsIdx(reversesIdx(r)+1:reversesIdx(r+1))) = r;
                            a.reverse(mouseTrialsIdx(reversesIdx(r+1)+1:reversesIdx(r+2))) = -r;
                        else
                            a.reverse(mouseTrialsIdx(reversesIdx(r)+1:reversesIdx(r+1))) = r;
                            a.reverse(mouseTrialsIdx(reversesIdx(r+1)+1:lastRevTrial)) = -r;
                        end
                    end
                else
                    a.reverse(mouseTrialsIdx(firstChoiceIdx:reversesIdx(1))) = 1;
                    a.reverse(mouseTrialsIdx(reversesIdx(1)+1:lastRevTrial)) = -1;
                end
            else
                a.reverse(mouseTrialsIdx(firstChoiceIdx:lastChoiceIdx)) = 1;               
            end
        else
            a.reverse(mouseTrialsIdx(firstChoiceIdx:lastChoiceIdx)) = 1;            
        end
    end
end
a.reverseCorr=a.reverse(a.correct==1);

%% MOUSE CATEGORIES

a.choiceMice = find(a.choiceMice);
a.choiceMiceList = a.mouseList(a.choiceMice);
a.choiceMouseCt = numel(a.choiceMice);

a.reverseMice = find(a.reverseMice);
a.reverseMiceList  = a.mouseList(a.reverseMice);


%% DAYS AROUND FIRST REVERSAL


a.reverseAround=NaN(numel(a.mouseList),6);
for m=1:numel(a.mouseList)
   if ismember(m,a.reverseMice)
        mm=find(a.reverseMice==m);
        dd=a.reverseDay{m,1};
        a.reverseAround(m,:) = (dd-3:dd+2);
   else
      a.reverseAround(m,1:3) = (a.mouseDayCt(m)-2:a.mouseDayCt(m)); 
   end
end

%% DAYS AROUND FIRST REVERSAL (last 2 before, last 2 after)

% 2 days before reversal, last 2 days after reversal
a.reversalDays = NaN(numel(a.mouseList),4);
for m=1:numel(a.mouseList)
   if ismember(m,a.reverseMice)
        mm=find(a.reverseMice==m);
        a.reversalDays(m,1) = a.reverseDay{m,1}-2; % 2 days prior to 1st reversal
        a.reversalDays(m,2) = a.reverseDay{m,1}-1;
        if ~isempty(a.reverseDay{m,2})
            a.reversalDays(m,3) = a.reverseDay{m,2}-2;
            a.reversalDays(m,4) = a.reverseDay{m,2}-1;
        else
            a.reversalDays(m,3) = a.lastParamDay(m)-1;
            a.reversalDays(m,4) = a.lastParamDay(m);
        end       
   else
       a.reversalDays(m,1:2) = (a.mouseDayCt(m)-1:a.mouseDayCt(m)); 
   end
end

%% DAY SUMMARY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a.miceCorr=a.mice(a.correct==1,:);
a.mouseDayCorr=a.mouseDay(a.correct==1);

for m = 1:a.mouseCt
    for d = 1:a.mouseDayCt(m)
        ok = a.mouseDay == d & a.mice(:,m) == 1 & a.correct == 1;
        okAll = a.mouseDay == d & a.mice(:,m) == 1;
        okCorr = a.mouseDayCorr == d & a.miceCorr(:,m) == 1;
        
        a.Alicks(m,d) = sum(a.anticipatoryInfoLicks(a.odorAtrials & okCorr)); % anticipateLickCt
        a.Blicks(m,d) = sum(a.anticipatoryInfoLicks(a.odorBtrials & okCorr));
        a.Clicks(m,d) = sum(a.anticipatoryRandLicks(a.odorCtrials & okCorr));
        a.Dlicks(m,d) = sum(a.anticipatoryRandLicks(a.odorDtrials & okCorr));       
                
        a.AlicksEarly(m,d) = sum(a.earlyInfoLicks(a.odorAtrials & okCorr));
        a.BlicksEarly(m,d) = sum(a.earlyInfoLicks(a.odorBtrials & okCorr));
        a.ClicksEarly(m,d) = sum(a.earlyRandLicks(a.odorCtrials & okCorr));
        a.DlicksEarly(m,d) = sum(a.earlyRandLicks(a.odorDtrials & okCorr));
        a.randBigLicksEarly(m,d) = sum(a.earlyRandLicks(a.randBigCorr & okCorr));
        a.randSmallLicksEarly(m,d) = sum(a.earlyRandLicks(a.randSmallCorr & okCorr));
        
        a.AlicksWater(m,d) = sum(a.waterInfoLicks(a.odorAtrials & okCorr));
        a.BlicksWater(m,d) = sum(a.waterInfoLicks(a.odorBtrials & okCorr));
        a.ClicksWater(m,d) = sum(a.waterRandLicks(a.odorCtrials & okCorr));
        a.DlicksWater(m,d) = sum(a.waterRandLicks(a.odorDtrials & okCorr));
        a.randBigLicksWater(m,d) = sum(a.waterRandLicks(a.randBigCorr & okCorr));
        a.randSmallLicksWater(m,d) = sum(a.waterRandLicks(a.randSmallCorr & okCorr));
        
        a.lickIdxInfo(m,d) = a.Alicks(m,d)/(a.Alicks(m,d)+a.Blicks(m,d));
        a.lickIdxRand(m,d) = a.Dlicks(m,d)/(a.Clicks(m,d)+a.Dlicks(m,d));
        
        a.lickIndex(m,d) = (a.Alicks(m,d) + a.Blicks(m,d))/(a.Clicks(m,d) + a.Dlicks(m,d));
        
        a.earlyLickIndex(m,d) = (a.AlicksEarly(m,d) + a.BlicksEarly(m,d))/(a.AlicksEarly(m,d) + a.BlicksEarly(m,d) + a.ClicksEarly(m,d) + a.DlicksEarly(m,d));
        
        % DAY SUMMARY
        a.daySummary.mouse{m,d} = m;
        a.daySummary.day{m,d} = d;
        a.daySummary.outcome{m,d} = a.outcome(okAll == 1);    
        a.daySummary.infoForced{m,d} = sum(a.infoForcedCorr(ok));
        a.daySummary.infoChoice{m,d} = sum(a.infoChoiceCorr(ok));
        a.daySummary.randForced{m,d} = sum(a.randForcedCorr(ok));
        a.daySummary.randChoice{m,d} = sum(a.randChoiceCorr(ok));
        a.daySummary.infoBig{m,d} = sum(a.infoBig(ok));
        a.daySummary.infoSmall{m,d} = sum(a.infoSmall(ok));
        a.daySummary.randBig{m,d} = sum(a.randBig(ok));
        a.daySummary.randSmall{m,d} = sum(a.randSmall(ok));
        
        a.daySummary.errors{m,d} = a.errorTypes(okAll == 1);
        
        a.daySummary.trialCt{m,d} = sum(okAll);
        a.daySummary.totalCorrectTrials{m,d} = sum(a.correct(okAll));
        a.daySummary.totalWater{m,d} = sum(a.reward(okAll));
        [a.daySummary.percentInfo{m,d},a.daySummary.percentInfoCI{m,d}] = binofit(sum(a.info(ok & a.trialType == 1 & a.trialTypes == 5)),sum(ok & a.trialType == 1 & a.trialTypes == 5)); % nanmean(a.info(ok & a.trialType == 1 & a.trialTypes == 5));
        a.daySummary.percentIIS{m,d} =  binofit(sum(a.choice_all(ok & a.trialType == 1 & a.trialTypes == 5)),sum(ok & a.trialType == 1 & a.trialTypes == 5)); %nanmean(a.choice_all(ok & a.trialType == 1 & a.trialTypes == 5));
        
        okTrials = find(ok & a.trialType == 1 & a.trialTypes == 5);
        earlyTrials = okTrials(1:round(0.33*numel(okTrials)));
        lateTrials = okTrials(numel(okTrials)-round(0.33*numel(okTrials))+1:numel(okTrials));
        a.daySummary.percentInfoEarly{m,d} = binofit(sum(a.info(earlyTrials)),numel(earlyTrials));
        a.daySummary.percentInfoLate{m,d} = binofit(sum(a.info(lateTrials)),numel(lateTrials));
                
        a.daySummary.rxnInfoForced{m,d} = mean(a.rxn(a.infoForcedCorr & ok),'omitnan');
        a.daySummary.rxnInfoChoice{m,d} = mean(a.rxn(a.infoChoiceCorr & ok),'omitnan');
        a.daySummary.rxnRandForced{m,d} = mean(a.rxn(a.randForcedCorr & ok),'omitnan');
        a.daySummary.rxnRandChoice{m,d} = mean(a.rxn(a.randChoiceCorr & ok),'omitnan');
        
        a.daySummary.rxnSpeedIdx{m,d} = (mean(a.rxnSpeed(ok & a.infoCorrTrials == 1),'omitnan') - mean(a.rxnSpeed(ok & a.randCorrTrials),'omitnan'))/(mean(a.rxnSpeed(ok & a.infoCorrTrials),'omitnan') + mean(a.rxnSpeed(ok & a.randCorrTrials),'omitnan'));        

        a.daySummary.infoBigLicks{m,d} = a.Alicks(m,d)/sum(a.odorAtrials & okCorr);
        a.daySummary.infoSmallLicks{m,d} = a.Blicks(m,d)/sum(a.odorBtrials & okCorr);
        a.daySummary.randCLicks{m,d} = a.Clicks(m,d)/sum(a.odorCtrials & okCorr);
        a.daySummary.randDLicks{m,d} = a.Dlicks(m,d)/sum(a.odorDtrials & okCorr);
        a.daySummary.earlyLickIdx{m,d} = a.earlyLickIndex(m,d);
        a.daySummary.lickIdx{m,d} = a.lickIndex(m,d);
        a.daySummary.infoLicksEarly{m,d} = sum(a.earlyInfoLicks(okCorr),'omitnan')/sum(a.infoCorr==1 & okCorr,'omitnan');
        a.daySummary.randLicksEarly{m,d} = sum(a.earlyRandLicks(okCorr),'omitnan')/sum(a.infoCorr==0 & okCorr,'omitnan');
        a.daySummary.infoBigLicksEarly{m,d} = a.AlicksEarly(m,d)/sum(a.odorAtrials & okCorr);
        a.daySummary.infoSmallLicksEarly{m,d} = a.BlicksEarly(m,d)/sum(a.odorBtrials & okCorr);
        a.daySummary.randCLicksEarly{m,d} = a.ClicksEarly(m,d)/sum(a.odorCtrials & okCorr);
        a.daySummary.randDLicksEarly{m,d} = a.DlicksEarly(m,d)/sum(a.odorDtrials & okCorr);
        a.daySummary.randBigLicksEarly{m,d} = a.randBigLicksEarly(m,d)/sum(a.randBigCorr & okCorr);
        a.daySummary.randSmallLicksEarly{m,d} = a.randSmallLicksEarly(m,d)/sum(a.randSmallCorr & okCorr);                
        a.daySummary.infoBigLicksWater{m,d} = a.AlicksWater(m,d)/sum(a.odorAtrials & okCorr);
        a.daySummary.infoSmallLicksWater{m,d} = a.BlicksWater(m,d)/sum(a.odorBtrials & okCorr);
        a.daySummary.randCLicksWater{m,d} = a.ClicksWater(m,d)/sum(a.odorCtrials & okCorr);
        a.daySummary.randBigLicksWater{m,d} = a.randBigLicksWater(m,d)/sum(a.randBigCorr & okCorr);
        a.daySummary.randSmallLicksWater{m,d} = a.randSmallLicksWater(m,d)/sum(a.randSmallCorr & okCorr);
        a.daySummary.randDLicksWater{m,d} = a.DlicksWater(m,d)/sum(a.odorDtrials & okCorr);         

        a.daySummary.trialLengthInfoForced{m,d} = sum(a.trialLength(a.infoForcedCorrect == 1 & okCorr == 1),'omitnan')/sum(~isnan(a.trialLength(a.infoForcedCorrect == 1 & okCorr == 1)));
        a.daySummary.trialLengthInfoChoice{m,d} = sum(a.trialLength(a.infoChoiceCorrect == 1 & okCorr == 1),'omitnan')/sum(~isnan(a.trialLength(a.infoChoiceCorrect == 1 & okCorr == 1)));
        a.daySummary.trialLengthRandForced{m,d} = sum(a.trialLength(a.randForcedCorrect == 1 & okCorr == 1),'omitnan')/sum(~isnan(a.trialLength(a.randForcedCorrect == 1 & okCorr == 1)));
        a.daySummary.trialLengthRandChoice{m,d} = sum(a.trialLength(a.randChoiceCorrect == 1 & okCorr == 1),'omitnan')/sum(~isnan(a.trialLength(a.randChoiceCorrect == 1 & okCorr == 1)));        
        
        a.daySummary.maxDelay{m,d} = max(a.odorDelay(ok))+max(a.rewardDelay(ok));
               
        a.daySummary.ARewards{m,d} = sum(a.rewardCorr(a.odorAtrials==1 & okCorr==1),'omitnan')/sum(a.odorAtrials & okCorr,'omitnan');
        a.daySummary.BRewards{m,d} = sum(a.rewardCorr(a.odorBtrials==1 & okCorr==1),'omitnan')/sum(a.odorBtrials & okCorr,'omitnan');
        a.daySummary.CRewards{m,d} = sum(a.rewardCorr(a.odorCtrials==1 & okCorr==1),'omitnan')/sum(a.odorCtrials & okCorr,'omitnan');
        a.daySummary.DRewards{m,d} = sum(a.rewardCorr(a.odorDtrials==1 & okCorr==1),'omitnan')/sum(a.odorDtrials & okCorr,'omitnan');
        a.daySummary.randBigRewards{m,d} = sum(a.rewardCorr(a.randBigCorr==1 & okCorr==1),'omitnan')/sum(a.randBigCorr & okCorr,'omitnan');
        a.daySummary.randSmallRewards{m,d} = sum(a.rewardCorr(a.randSmallCorr==1 & okCorr==1),'omitnan')/sum(a.randSmallCorr & okCorr,'omitnan');
        
        a.daySummary.rewardRateInfoForced{m,d} = sum(a.reward(a.infoForced == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.infoForced == 1 & okAll == 1),'omitnan')/60);
        a.daySummary.rewardRateRandForced{m,d} = sum(a.reward(a.randForced == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.randForced == 1 & okAll == 1),'omitnan')/60);
        a.daySummary.rewardRateChoice{m,d} = sum(a.reward(a.trialType == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.trialType == 1 & okAll == 1),'omitnan')/60);
        a.daySummary.rewardRateInfo{m,d} = sum(a.reward(a.info == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.info == 1 & okAll == 1),'omitnan')/60);
        a.daySummary.rewardRateRand{m,d} = sum(a.reward(a.info == 0 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.info == 0 & okAll == 1),'omitnan')/60);
        a.daySummary.rewardRateIdx{m,d} = a.daySummary.rewardRateInfo{m,d}/a.daySummary.rewardRateRand{m,d};
        
        a.daySummary.rewardRateInfoForcedCorr{m,d} = sum(a.rewardCorr(a.infoForcedCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.infoForcedCorrect == 1 & okCorr == 1),'omitnan')/60);
        a.daySummary.rewardRateRandForcedCorr{m,d} = sum(a.rewardCorr(a.randForcedCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.randForcedCorrect == 1 & okCorr == 1),'omitnan')/60);
        a.daySummary.rewardRateInfoCorr{m,d} = sum(a.rewardCorr(a.infoCorr == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.infoCorr == 1 & okCorr == 1),'omitnan')/60);
        a.daySummary.rewardRateRandCorr{m,d} = sum(a.rewardCorr(a.infoCorr == 0 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.infoCorr == 0 & okCorr == 1),'omitnan')/60);
        a.daySummary.rewardRateIdxCorr{m,d} = a.daySummary.rewardRateInfoCorr{m,d}/a.daySummary.rewardRateRandCorr{m,d};

        outcomes = a.outcome(okAll ==1);
        [a.daySummary.infoForcedCorr{m,d},a.daySummary.infoForcedCorrCI{m,d}]=binofit(sum(a.correct(okAll & a.trialType == 2)),sum(okAll & a.trialType == 2)); %nanmean(a.choice_all(ok & a.trialType == 1 & a.trialTypes == 5));
        [a.daySummary.randForcedCorr{m,d},a.daySummary.randForcedCorrCI{m,d}]=binofit(sum(a.correct(okAll & a.trialType == 3)),sum(okAll & a.trialType == 3));
        [a.daySummary.choiceCorr{m,d},a.daySummary.choiceCorrCI{m,d}]=binofit(sum(a.correct(okAll & a.trialType == 1)),sum(okAll & a.trialType == 1));
%         a.daySummary.infoForcedCorr{m,d} = sum(ismember(outcomes,a.infoCorrCodes))/(sum(ismember(outcomes,a.infoCorrCodes))+sum(ismember(outcomes,a.infoIncorrCodes)));
%         a.daySummary.randForcedCorr{m,d} = sum(ismember(outcomes,a.randCorrCodes))/(sum(ismember(outcomes,a.randCorrCodes))+sum(ismember(outcomes,a.randIncorrCodes)));
%         a.daySummary.choiceInfoCorr{m,d} = sum(ismember(outcomes,a.choiceCorrCodes))/(sum(ismember(outcomes,a.choiceCorrCodes))+sum(ismember(outcomes,a.choiceIncorrCodes)));                
%         a.daySummary.choiceRandCorr{m,d} = sum(ismember(outcomes,a.choiceIncorrCodes))/(sum(ismember(outcomes,a.choiceCorrCodes))+sum(ismember(outcomes,a.choiceIncorrCodes)));        

        
        a.daySummary.infoBigNP{m,d} = sum(ismember(outcomes,[3 12]))/sum(ismember(outcomes,[2 3 11 12]));
        a.daySummary.infoSmallNP{m,d} = sum(ismember(outcomes,[5 14]))/sum(ismember(outcomes,[4 5 13 14]));
        a.daySummary.randBigNP{m,d} = sum(ismember(outcomes,[7 18]))/sum(ismember(outcomes,[6 7 17 18]));
        a.daySummary.randSmallNP{m,d} = sum(ismember(outcomes,[9 20]))/sum(ismember(outcomes,[8 9 19 20]));
        a.daySummary.leavingIDX{m,d} = sum(ismember(outcomes,[5 14]))/sum(ismember(outcomes,[5 14 9 20])); % percent of small leaving that is info 1=allinfo
        a.daySummary.leavingPercentIDX{m,d} = a.daySummary.infoSmallNP{m,d}/(a.daySummary.infoSmallNP{m,d} + a.daySummary.randSmallNP{m,d}); % info leaving relative to info + rand leaving. 1=allinfo
        
    end
end

%% BEHAVIOR MEASURES

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bydays=0;

%% DAYS BEFORE FIRST REVERSAL (PRE-REVERSE) - mean of last threes

for m=1:numel(a.mouseList)
%     if ismember(m,a.reverseMice)
    days = a.reverseAround(m,1:3);
    
    a.preRevPref(m,:)=cell2mat(a.daySummary.percentInfo(m,days));
    a.preRevPrefMean(m,:)=mean(a.preRevPref(m,:),'omitnan');
    a.preRevPrefSEM(m,:)=sem(a.preRevPref(m,:));
    a.preRevPrefEarly(m,:)=cell2mat(a.daySummary.percentInfoEarly(m,days));
    a.preRevPrefLate(m,:)=cell2mat(a.daySummary.percentInfoLate(m,days));
    a.preRevPrefEarlyMean(m,:)=mean(a.preRevPrefEarly(m,:),'omitnan');
    a.preRevPrefLateMean(m,:)=mean(a.preRevPrefLate(m,:),'omitnan');
    
    if bydays==1

        a.preRevRxnInfoForced(m,:)=cell2mat(a.daySummary.rxnInfoForced(m,days));
        a.preRevRxnRandForced(m,:)=cell2mat(a.daySummary.rxnRandForced(m,days));
        a.preRevRxnInfoChoice(m,:)=cell2mat(a.daySummary.rxnInfoChoice(m,days));
        a.preRevRxnRandChoice(m,:)=cell2mat(a.daySummary.rxnRandChoice(m,days));
        a.preRevRxnMean(m,1) = mean(a.preRevRxnInfoForced(m,:),'omitnan');
        a.preRevRxnMean(m,2) = mean(a.preRevRxnRandForced(m,:),'omitnan');
        a.preRevRxnMean(m,3) = mean(a.preRevRxnInfoChoice(m,:),'omitnan');
        a.preRevRxnMean(m,4) = mean(a.preRevRxnRandChoice(m,:),'omitnan');

        a.preRevCorrectInfo(m,:)=cell2mat(a.daySummary.infoForcedCorr(m,days));
        a.preRevCorrectRand(m,:)=cell2mat(a.daySummary.randForcedCorr(m,days));
        a.preRevCorrectMean(m,1)=mean(a.preRevCorrectInfo(m,:),'omitnan');
        a.preRevCorrectMean(m,2)=mean(a.preRevCorrectRand(m,:),'omitnan');

        a.preRevRewardRateInfo(m,:)=cell2mat(a.daySummary.rewardRateInfoForced(m,days));
        a.preRevRewardRateRand(m,:)=cell2mat(a.daySummary.rewardRateRandForced(m,days));
        a.preRevRewardRateMean(m,1)=mean(a.preRevRewardRateInfo(m,:),'omitnan');
        a.preRevRewardRateMean(m,2)=mean(a.preRevRewardRateRand(m,:),'omitnan');

        a.preRevRewardRateCorrInfo(m,:)=cell2mat(a.daySummary.rewardRateInfoForcedCorr(m,days));
        a.preRevRewardRateCorrRand(m,:)=cell2mat(a.daySummary.rewardRateRandForcedCorr(m,days));
        a.preRevRewardRateCorrMean(m,1)=mean(a.preRevRewardRateCorrInfo(m,:),'omitnan');
        a.preRevRewardRateCorrMean(m,2)=mean(a.preRevRewardRateCorrRand(m,:),'omitnan');

%         a.preRevInfoEarlyLicks(m,:)=cell2mat(a.daySummary.infoLicksEarly(m,days));
%         a.preRevRandEarlyLicks(m,:)=cell2mat(a.daySummary.randLicksEarly(m,days));
%         a.preRevEarlyLicksMean(m,1)=mean(a.preRevInfoEarlyLicks(m,:),'omitnan');
%         a.preRevEarlyLicksMean(m,2)=mean(a.preRevRandEarlyLicks(m,:),'omitnan');
% 
%         a.preRevInfoBigLicks(m,:)=cell2mat(a.daySummary.infoBigLicks(m,days));
%         a.preRevInfoSmallLicks(m,:)=cell2mat(a.daySummary.infoSmallLicks(m,days));
%         a.preRevRandCLicks(m,:)=cell2mat(a.daySummary.randCLicks(m,days));
%         a.preRevRandDLicks(m,:)=cell2mat(a.daySummary.randDLicks(m,days));
%         a.preRevLicksMean(m,1)=mean(a.preRevInfoBigLicks(m,:),'omitnan');
%         a.preRevLicksMean(m,2)=mean(a.preRevRandDLicks(m,:),'omitnan');
%         a.preRevLicksMean(m,3)=mean(a.preRevRandCLicks(m,:),'omitnan');
%         a.preRevLicksMean(m,4)=mean(a.preRevInfoSmallLicks(m,:),'omitnan');
    
    else
        
        ok = a.mouseNums==m & ismember(a.mouseDay,days) & a.correct==1;
        okAll = ismember(a.mouseDay,days) & a.mice(:,m) == 1;
        okCorr = ismember(a.mouseDayCorr,days) & a.miceCorr(:,m) == 1;
        
        [a.preRevCorrectMean(m,1),a.preRevCorrectCI(m,[1 2])] = binofit(sum(a.correct(okAll & a.trialType == 2)),sum(okAll & a.trialType == 2));
        [a.preRevCorrectMean(m,2),a.preRevCorrectCI(m,[3 4])] = binofit(sum(a.correct(okAll & a.trialType == 3)),sum(okAll & a.trialType == 3));
        
        a.preRevRxnMean(m,1) = mean(a.rxn(a.infoForcedCorr & ok),'omitnan');
        a.preRevRxnMean(m,2) = mean(a.rxn(a.randForcedCorr & ok),'omitnan');
        a.preRevRxnMean(m,3) = mean(a.rxn(a.infoChoiceCorr & ok),'omitnan');
        a.preRevRxnMean(m,4) = mean(a.rxn(a.randChoiceCorr & ok),'omitnan');
        a.preRevRxn{m,1}=a.rxn(a.infoForcedCorr & ok);
        a.preRevRxn{m,2}=a.rxn(a.randForcedCorr & ok);
        a.preRevRxn{m,3}=a.rxn(a.infoChoiceCorr & ok);
        a.preRevRxn{m,4}=a.rxn(a.randChoiceCorr & ok);        
        
        a.preRevRewardRateMean(m,1)=sum(a.reward(a.infoForced == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.infoForced == 1 & okAll == 1),'omitnan')/60);
        a.preRevRewardRateMean(m,2)=sum(a.reward(a.randForced == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.randForced == 1 & okAll == 1),'omitnan')/60);

        a.preRevRewardRateCorrMean(m,1)=sum(a.rewardCorr(a.infoForcedCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.infoForcedCorrect == 1 & okCorr == 1),'omitnan')/60);
        a.preRevRewardRateCorrMean(m,2)=sum(a.rewardCorr(a.randForcedCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.randForcedCorrect == 1 & okCorr == 1),'omitnan')/60);   
    
%         a.preRevEarlyLicksMean(m,1)=sum(a.earlyInfoLicks(okCorr),'omitnan')/sum(a.infoCorr==1 & okCorr,'omitnan');
%         a.preRevEarlyLicksMean(m,2)=sum(a.earlyRandLicks(okCorr),'omitnan')/sum(a.infoCorr==0 & okCorr,'omitnan');
% 
%         a.preRevLicksMean(m,1)=sum(a.anticipatoryInfoLicks(a.odorAtrials & okCorr))/sum(a.odorAtrials & okCorr);
%         a.preRevLicksMean(m,2)=sum(a.anticipatoryRandLicks(a.odorDtrials & okCorr))/sum(a.odorDtrials & okCorr);
%         a.preRevLicksMean(m,3)=sum(a.anticipatoryRandLicks(a.odorCtrials & okCorr))/sum(a.odorCtrials & okCorr);
%         a.preRevLicksMean(m,4)=sum(a.anticipatoryInfoLicks(a.odorBtrials & okCorr))/sum(a.odorBtrials & okCorr);
    end
%     end
end

% [a.preRevLickspval, tbl, stats] = friedman(a.preRevLicksMean, 1,'off');
% a.preRevLicksComp = multcompare(stats,'Display','off');

% can't use friedman for this since NaN for choice rand-->
% multiple signrank's
% [a.preRevRxnpval, tbl, stats] = friedman(a.preRevRxnMean, 1,'off');
% a.preRevRxnComp = multcompare(stats,'Display','off');

a.preRevRxnIdx=(a.preRevRxnMean(:,4)-a.preRevRxnMean(:,3))./a.preRevRxnMean(:,3);


%% STATS for last 2 days pre-reversal, info vs rand x days
% to ensure behavior did not meaningfully differ session-to-session

% preRevANOVA
% p1:conditions are different (info vs rand or early vs late)
% p2:condition 1 day 1 vs day 2
% p3:condition 2 day 1 vs day 2

% preRevANOVA4
% p1:conditions are different (info vs rand or early vs late)
% p2:condition 1-4 day 1 vs day 2
% p3:conditions vs each other multicomparison w bonferroni

% data=[a.preRevInfoBigLicks(idx1,:) a.preRevRandDLicks(idx1,:) a.preRevRandCLicks(idx1,:) a.preRevInfoSmallLicks(idx1,:)];
% [a.preRevLicksP1(1,1),a.preRevLicksP2(1,:),a.preRevLicksP3{1}]=preRevANOVA4(data);
% data=[a.preRevInfoBigLicks(idx2,:) a.preRevRandDLicks(idx2,:) a.preRevRandCLicks(idx2,:) a.preRevInfoSmallLicks(idx2,:)];
% [a.preRevLicksP1(2,1),a.preRevLicksP2(2,:),a.preRevLicksP3{2}]=preRevANOVA4(data);
% 
% data=[a.preRevInfoEarlyLicks(idx1,:) a.preRevRandEarlyLicks(idx1,:)];
% [a.preRevEarlyLicksP1(1,1),a.preRevEarlyLicksP2(1,1),a.preRevEarlyLicksP3(1,1)] = prerevANOVA(data);
% data=[a.preRevInfoEarlyLicks(idx2,:) a.preRevRandEarlyLicks(idx2,:)];
% [a.preRevEarlyLicksP1(2,1),a.preRevEarlyLicksP2(2,1),a.preRevEarlyLicksP3(2,1)] = prerevANOVA(data);
% 
% data=[a.preRevRewardRateCorrInfo(idx1,:) a.preRevRewardRateCorrRand(idx1,:)];
% [a.preRevRewardRateCorrP1(1,1),a.preRevRewardRateCorrP2(1,1),a.preRevRewardRateCorrP3(1,1)] = prerevANOVA(data);
% data=[a.preRevRewardRateCorrInfo(idx2,:) a.preRevRewardRateCorrRand(idx2,:)];
% [a.preRevRewardRateCorrP1(2,1),a.preRevRewardRateCorrP2(2,1),a.preRevRewardRateCorrP3(2,1)] = prerevANOVA(data);
% 
% data=[a.preRevRewardRateInfo(idx1,:) a.preRevRewardRateRand(idx1,:)];
% [a.preRevRewardRateP1(1,1),a.preRevRewardRateP2(1,1),a.preRevRewardRateP3(1,1)] = prerevANOVA(data);
% data=[a.preRevRewardRateInfo(idx2,:) a.preRevRewardRateRand(idx2,:)];
% [a.preRevRewardRateP1(2,1),a.preRevRewardRateP2(2,1),a.preRevRewardRateP3(2,1)] = prerevANOVA(data);
% 
% data=[a.preRevCorrectInfo(idx1,:) a.preRevCorrectRand(idx1,:)];
% [a.preRevCorrectP1(1,1),a.preRevCorrectP2(1,1),a.preRevCorrectP3(1,1)] = prerevANOVA(data);
% data=[a.preRevCorrectInfo(idx2,:) a.preRevCorrectRand(idx2,:)];
% [a.preRevCorrectP1(2,1),a.preRevCorrectP2(2,1),a.preRevCorrectP3(2,1)] = prerevANOVA(data);
% 
% data=[a.preRevPrefEarly(idx1,:) a.preRevPrefLate(idx1,:)];
% [a.preRevSatietyP1(1,1),a.preRevSatietyP2(1,1),a.preRevSatietyP3(1,1)] = prerevANOVA(data);
% data=[a.preRevPrefEarly(idx2,:) a.preRevPrefLate(idx2,:)];
% [a.preRevSatietyP1(2,1),a.preRevSatietyP2(2,1),a.preRevSatietyP3(2,1)] = prerevANOVA(data);
% 
% data=[a.preRevRxnInfoForced(idx1,:) a.preRevRxnRandForced(idx1,:)];
% [a.preRevRxnForced1(1,1),a.preRevRxnForcedP2(1,1),a.preRevRxnForcedP3(1,1)] = prerevANOVA(data);
% data=[a.preRevRxnInfoForced(idx2,:) a.preRevRxnRandForced(idx2,:)];
% [a.preRevRxnForced1(2,1),a.preRevRxnForcedP2(2,1),a.preRevRxnForcedP3(2,1)] = prerevANOVA(data);
% 
% data=[a.preRevRxnInfoForced(idx1,:) a.preRevRxnInfoChoice(idx1,:) a.preRevRxnRandForced(idx1,:) a.preRevRxnRandChoice(idx1,:)];
% [a.preRevRxnP1(1,1),a.preRevRxnP2(1,:),a.preRevRxnP3{1}]=preRevANOVA4(data);
% data=[a.preRevRxnInfoForced(idx2,:) a.preRevRxnInfoChoice(idx2,:) a.preRevRxnRandForced(idx2,:) a.preRevRxnRandChoice(idx2,:)];
% [a.preRevRxnP1(2,1),a.preRevRxnP2(2,:),a.preRevRxnP3{2}]=preRevANOVA4(data);
% 
% data=[mean(a.infoDwell(idx1,:),2) mean(a.randDwell(idx1,:),2) mean(a.infoDwell1sec(idx1,:),2) mean(a.randDwell1sec(idx1,:),2)];
% tbl = array2table(data, 'VariableNames', strcat('V', string(1:size(data, 2))));
% Conditions = [1 2 3 4]';
% WithinDesign = table(Conditions, 'VariableNames', {'Condition'});
% rm = fitrm(tbl, 'V1-V4 ~ 1', 'WithinDesign', WithinDesign);
% ranova_stats = ranova(rm, 'WithinModel', 'Condition');
% a.dwellP1(1,1)=ranova_stats{3,5};
% a.dwellP2{1}=multcompare(rm,'Condition','ComparisonType','bonferroni');
%     
% data=[mean(a.infoDwell(idx2,:),2) mean(a.randDwell(idx2,:),2) mean(a.infoDwell1sec(idx2,:),2) mean(a.randDwell1sec(idx2,:),2)];
% tbl = array2table(data, 'VariableNames', strcat('V', string(1:size(data, 2))));
% Conditions = [1 2 3 4]';
% WithinDesign = table(Conditions, 'VariableNames', {'Condition'});
% rm = fitrm(tbl, 'V1-V4 ~ 1', 'WithinDesign', WithinDesign);
% ranova_stats = ranova(rm, 'WithinModel', 'Condition');
% a.dwellP1(2,1)=ranova_stats{3,5};
% a.dwellP2{2}=multcompare(rm,'Condition','ComparisonType','bonferroni');

% licks=[a.preRevLicksMean(idx1rev,1);a.preRevLicksMean(idx1rev,2);a.preRevLicksMean(idx1rev,3);a.preRevLicksMean(idx1rev,4)];
% tt=[ones(size(idx1rev))*1;ones(size(idx1rev))*2;ones(size(idx1rev))*3;ones(size(idx1rev))*4];
% [a.lickp1,~,stats] =anova1(licks,tt);
% %     aov=anova(tt,licks);
% %     c1=multcompare(aov);
% a.lickc1 = multcompare(stats);

% licks=[a.preRevLicksMean(idx1rev,1) a.preRevLicksMean(idx1rev,2) a.preRevLicksMean(idx1rev,3) a.preRevLicksMean(idx1rev,4)];
% tt=[ones(size(idx1rev))*1 ones(size(idx1rev))*2 ones(size(idx1rev))*3 ones(size(idx1rev))*4];
% Types=[1 2 3 4];
% WithinDesignLicks = table(Types', 'VariableNames', {'TrialTypes'});
% lickTbl = array2table(licks, 'VariableNames', strcat('V', string(1:size(licks, 2))));
% rmLicks = fitrm(lickTbl, 'V1-V4 ~ 1', 'WithinDesign', WithinDesignLicks);
% ranova_licks = ranova(rmLicks, 'WithinModel', 'TrialTypes');
% lickMult=multcompare(rmLicks,'TrialTypes');

% 
% licks=[a.preRevLicksMean(idx2rev,1);a.preRevLicksMean(idx2rev,2);a.preRevLicksMean(idx2rev,3);a.preRevLicksMean(idx2rev,4)];
% tt=[ones(size(idx2rev))*1;ones(size(idx2rev))*2;ones(size(idx2rev))*3;ones(size(idx2rev))*4];
% [a.lickp2,~,stats] =anova1(licks,tt);
% %     aov=anova(tt,licks);
% %     c1=multcompare(aov);
% a.lickc2 = multcompare(stats);

%% PRE-REVERSAL PORT DWELL

for m=1:a.mouseCt
    days = a.reverseAround(m,1:3);

    ok=a.reverse==1 & a.trialTypes == 5 & a.correct==1 & a.mouseNums==m & ismember(a.mouseDay,days);
    a.infoDwell(m,1)= mean(mean(a.infoPort(a.infoForced & ok,54:250),2));
    a.randDwell(m,1) = mean(mean(a.randPort(a.randForced & ok,54:250),2));
    a.infoDwell1sec(m,1)= mean(mean(a.infoPort(a.infoForced & ok,54:74),2));
    a.randDwell1sec(m,1)=mean(mean(a.randPort(a.randForced & ok,54:74),2));

    a.centerDwellChoice(m,:)= mean(a.Port2(a.trialType==1 & ok,:));
    a.centerDwellInfo(m,:) = mean(a.Port2(a.trialType==2 & ok,:));
    a.centerDwellRand(m,:) = mean(a.Port2(a.trialType==3 & ok,:));

    a.infoDwellInfoBig(m,:) = mean(a.infoPort(a.infoBig==1 & ok,:));
    a.infoDwellInfoSmall(m,:) = mean(a.infoPort(a.infoSmall==1 & ok,:));
    a.infoDwellInfo(m,:) = mean(a.infoPort(a.trialType==2 & ok,:));
    a.infoDwellRandBig(m,:) = mean(a.infoPort(a.randBig==1 & ok,:));
    a.infoDwellRandSmall(m,:) = mean(a.infoPort(a.randSmall==1 & ok,:));
    a.infoDwellRand(m,:) = mean(a.infoPort(a.trialType==3 & ok,:));

    a.randDwellInfoBig(m,:) = mean(a.randPort(a.infoBig==1 & ok,:));
    a.randDwellInfoSmall(m,:) = mean(a.randPort(a.infoSmall==1 & ok,:));
    a.randDwellInfo(m,:) = mean(a.randPort(a.trialType==2 & ok,:));
    a.randDwellRandBig(m,:) = mean(a.randPort(a.randBig==1 & ok,:));
    a.randDwellRandSmall(m,:) = mean(a.randPort(a.randSmall==1 & ok,:));
    a.randDwellRand(m,:) = mean(a.randPort(a.trialType==3 & ok,:));
end

%% PREF FULL DAYS AROUND

for m=1:numel(a.mouseList)
    days = a.reverseAround(m,:);
    days=days(~isnan(days));
    if numel(cell2mat(a.daySummary.percentIIS(m,days)))<6
        days=days(1:numel(cell2mat(a.daySummary.percentIIS(m,days))));
    end
    a.reversalMultiPrefsIIS(m,1:numel(days))=cell2mat(a.daySummary.percentIIS(m,days));
    a.reversalMultiPrefs(m,1:numel(days))=cell2mat(a.daySummary.percentInfo(m,days));
end

for d=1:6
a.reversalMultiPrefsP(1,d) = signrank(a.reversalMultiPrefs(:,d)*100-50);
end

%% DAYS BEFORE AND AFTER FIRST REVERSAL

for m=1:numel(a.mouseList)
    if ismember(m,a.reverseMice)
    days = a.reversalDays(m,:);
    
    if bydays==1
        
        a.reversalPref(m,:)=cell2mat(a.daySummary.percentInfo(m,days));
        a.reversalPrefMean(m,:)=mean(a.reversalPref(m,:),'omitnan');
        a.reversalPrefSEM(m,:)=sem(a.reversalPref(m,:));
        a.reversalPrefEarly(m,:)=cell2mat(a.daySummary.percentInfoEarly(m,days));
        a.reversalPrefLate(m,:)=cell2mat(a.daySummary.percentInfoLate(m,days));
        a.reversalPrefEarlyMean(m,:)=mean(a.reversalPrefEarly(m,:),'omitnan');
        a.reversalPrefLateMean(m,:)=mean(a.reversalPrefLate(m,:),'omitnan'); 

        a.reversalRxnInfoForced(m,:)=cell2mat(a.daySummary.rxnInfoForced(m,days));
        a.reversalRxnRandForced(m,:)=cell2mat(a.daySummary.rxnRandForced(m,days));
        a.reversalRxnInfoChoice(m,:)=cell2mat(a.daySummary.rxnInfoChoice(m,days));
        a.reversalRxnRandChoice(m,:)=cell2mat(a.daySummary.rxnRandChoice(m,days));
        a.reversalRxnMean(m,1) = mean(a.reversalRxnInfoForced(m,:),'omitnan');
        a.reversalRxnMean(m,2) = mean(a.reversalRxnRandForced(m,:),'omitnan');
        a.reversalRxnMean(m,3) = mean(a.reversalRxnInfoChoice(m,:),'omitnan');
        a.reversalRxnMean(m,4) = mean(a.reversalRxnRandChoice(m,:),'omitnan');

        a.reversalCorrectInfo(m,:)=cell2mat(a.daySummary.infoForcedCorr(m,days));
        a.reversalCorrectRand(m,:)=cell2mat(a.daySummary.randForcedCorr(m,days));
        a.reversalCorrectMean(m,1)=mean(a.reversalCorrectInfo(m,:),'omitnan');
        a.reversalCorrectMean(m,2)=mean(a.reversalCorrectRand(m,:),'omitnan');

        a.reversalRewardRateInfo(m,:)=cell2mat(a.daySummary.rewardRateInfoForced(m,days));
        a.reversalRewardRateRand(m,:)=cell2mat(a.daySummary.rewardRateRandForced(m,days));
        a.reversalRewardRateMean(m,1)=mean(a.reversalRewardRateInfo(m,:),'omitnan');
        a.reversalRewardRateMean(m,2)=mean(a.reversalRewardRateRand(m,:),'omitnan');

        a.reversalRewardRateCorrInfo(m,:)=cell2mat(a.daySummary.rewardRateInfoForcedCorr(m,days));
        a.reversalRewardRateCorrRand(m,:)=cell2mat(a.daySummary.rewardRateRandForcedCorr(m,days));
        a.reversalRewardRateCorrMean(m,1)=mean(a.reversalRewardRateCorrInfo(m,:),'omitnan');
        a.reversalRewardRateCorrMean(m,2)=mean(a.reversalRewardRateCorrRand(m,:),'omitnan');

        a.reversalInfoEarlyLicks(m,:)=cell2mat(a.daySummary.infoLicksEarly(m,days));
        a.reversalRandEarlyLicks(m,:)=cell2mat(a.daySummary.randLicksEarly(m,days));
        a.reversalEarlyLicksMean(m,1)=mean(a.reversalInfoEarlyLicks(m,:),'omitnan');
        a.reversalEarlyLicksMean(m,2)=mean(a.reversalRandEarlyLicks(m,:),'omitnan');

        a.reversalInfoBigLicks(m,:)=cell2mat(a.daySummary.infoBigLicks(m,days));
        a.reversalInfoSmallLicks(m,:)=cell2mat(a.daySummary.infoSmallLicks(m,days));
        a.reversalRandCLicks(m,:)=cell2mat(a.daySummary.randCLicks(m,days));
        a.reversalRandDLicks(m,:)=cell2mat(a.daySummary.randDLicks(m,days));
        a.reversalLicksMean(m,1)=mean(a.reversalInfoBigLicks(m,:),'omitnan');
        a.reversalLicksMean(m,2)=mean(a.reversalRandDLicks(m,:),'omitnan');
        a.reversalLicksMean(m,3)=mean(a.reversalRandCLicks(m,:),'omitnan');
        a.reversalLicksMean(m,4)=mean(a.reversalInfoSmallLicks(m,:),'omitnan');
    
    else
        
        for dd=1:2
            daylist={[1,2],[3,4]};
            d=daylist{dd};
            ok = a.mouseNums==m & ismember(a.mouseDay,days(d)) & a.correct==1;
            okAll = ismember(a.mouseDay,days(d)) & a.mice(:,m) == 1;
            okCorr = ismember(a.mouseDayCorr,days(d)) & a.miceCorr(:,m) == 1;
            
            a.reversalPref(m,dd)=mean(cell2mat(a.daySummary.percentInfo(m,days(d))),'omitnan'); % mean pref across two days before, two days after reversal
            a.reversalPrefMean(m,1)=mean(a.reversalPref(m,:),'omitnan');
            a.reversalPrefSEM(m,:)=sem(a.reversalPref(m,:));
            a.reversalPrefEarly(m,dd)=mean(cell2mat(a.daySummary.percentInfoEarly(m,days(d))),'omitnan');
            a.reversalPrefLate(m,dd)=mean(cell2mat(a.daySummary.percentInfoLate(m,days(d))),'omitnan');
            a.reversalPrefEarlyMean(m,1)=mean(a.reversalPrefEarly(m,:),'omitnan');
            a.reversalPrefLateMean(m,1)=mean(a.reversalPrefLate(m,:),'omitnan');             

            a.reversalRxnInfoForced(m,dd)=mean(a.rxn(a.infoForcedCorr & ok),'omitnan');
            a.reversalRxnRandForced(m,dd)=mean(a.rxn(a.randForcedCorr & ok),'omitnan');
            a.reversalRxnInfoChoice(m,dd)=mean(a.rxn(a.infoChoiceCorr & ok),'omitnan');
            a.reversalRxnRandChoice(m,dd)=mean(a.rxn(a.randChoiceCorr & ok),'omitnan');
            a.reversalRxnMean(m,1) = mean(a.reversalRxnInfoForced(m,:),'omitnan');
            a.reversalRxnMean(m,2) = mean(a.reversalRxnRandForced(m,:),'omitnan');
            a.reversalRxnMean(m,3) = mean(a.reversalRxnInfoChoice(m,:),'omitnan');
            a.reversalRxnMean(m,4) = mean(a.reversalRxnRandChoice(m,:),'omitnan');

            a.reversalCorrectInfo(m,dd)=binofit(sum(a.correct(okAll & a.trialType == 2)),sum(okAll & a.trialType == 2));
            a.reversalCorrectRand(m,dd)=binofit(sum(a.correct(okAll & a.trialType == 3)),sum(okAll & a.trialType == 3));
            a.reversalCorrectMean(m,1)=mean(a.reversalCorrectInfo(m,:),'omitnan');
            a.reversalCorrectMean(m,2)=mean(a.reversalCorrectRand(m,:),'omitnan');

            a.reversalRewardRateInfo(m,dd)=sum(a.reward(a.infoForced == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.infoForced == 1 & okAll == 1),'omitnan')/60);
            a.reversalRewardRateRand(m,dd)=sum(a.reward(a.randForced == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.randForced == 1 & okAll == 1),'omitnan')/60);
            a.reversalRewardRateMean(m,1)=mean(a.reversalRewardRateInfo(m,:),'omitnan');
            a.reversalRewardRateMean(m,2)=mean(a.reversalRewardRateRand(m,:),'omitnan');

            a.reversalRewardRateCorrInfo(m,dd)=sum(a.rewardCorr(a.infoForcedCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.infoForcedCorrect == 1 & okCorr == 1),'omitnan')/60);
            a.reversalRewardRateCorrRand(m,dd)=sum(a.rewardCorr(a.randForcedCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.randForcedCorrect == 1 & okCorr == 1),'omitnan')/60);
            a.reversalRewardRateCorrMean(m,1)=mean(a.reversalRewardRateCorrInfo(m,:),'omitnan');
            a.reversalRewardRateCorrMean(m,2)=mean(a.reversalRewardRateCorrRand(m,:),'omitnan');

            a.reversalInfoEarlyLicks(m,dd)=sum(a.earlyInfoLicks(okCorr),'omitnan')/sum(a.infoCorr==1 & okCorr,'omitnan');
            a.reversalRandEarlyLicks(m,dd)=sum(a.earlyRandLicks(okCorr),'omitnan')/sum(a.infoCorr==0 & okCorr,'omitnan');
            a.reversalEarlyLicksMean(m,1)=mean(a.reversalInfoEarlyLicks(m,:),'omitnan');
            a.reversalEarlyLicksMean(m,2)=mean(a.reversalRandEarlyLicks(m,:),'omitnan');

            a.reversalInfoBigLicks(m,dd)=sum(a.anticipatoryInfoLicks(a.odorAtrials & okCorr))/sum(a.odorAtrials & okCorr);
            a.reversalInfoSmallLicks(m,dd)=sum(a.anticipatoryInfoLicks(a.odorBtrials & okCorr))/sum(a.odorBtrials & okCorr);
            a.reversalRandCLicks(m,dd)=sum(a.anticipatoryRandLicks(a.odorCtrials & okCorr))/sum(a.odorCtrials & okCorr);
            a.reversalRandDLicks(m,dd)=sum(a.anticipatoryRandLicks(a.odorDtrials & okCorr))/sum(a.odorDtrials & okCorr);
            a.reversalLicksMean(m,1)=mean(a.reversalInfoBigLicks(m,:),'omitnan');
            a.reversalLicksMean(m,2)=mean(a.reversalRandDLicks(m,:),'omitnan');
            a.reversalLicksMean(m,3)=mean(a.reversalRandCLicks(m,:),'omitnan');
            a.reversalLicksMean(m,4)=mean(a.reversalInfoSmallLicks(m,:),'omitnan');
        end
    end
    end
end

a.reversalRxn=[a.reversalRxnInfoForced(:,1) a.reversalRxnRandForced(:,1) a.reversalRxnInfoForced(:,2) a.reversalRxnRandForced(:,2)];
a.reversalCorrect=[a.reversalCorrectInfo(:,1) a.reversalCorrectRand(:,1) a.reversalCorrectInfo(:,2) a.reversalCorrectRand(:,2)];
a.reversalRewardRate=[a.reversalRewardRateInfo(:,1) a.reversalRewardRateRand(:,1) a.reversalRewardRateInfo(:,2) a.reversalRewardRateRand(:,2)];
a.reversalRewardRateCorr=[a.reversalRewardRateCorrInfo(:,1) a.reversalRewardRateCorrRand(:,1) a.reversalRewardRateCorrInfo(:,2) a.reversalRewardRateCorrRand(:,2)];
a.reversalEarlyLicks=[a.reversalInfoEarlyLicks(:,1) a.reversalRandEarlyLicks(:,1) a.reversalInfoEarlyLicks(:,2) a.reversalRandEarlyLicks(:,2)];
a.reversalLicks=[a.reversalInfoBigLicks(:,1) a.reversalRandDLicks(:,1) a.reversalRandCLicks(:,1) a.reversalInfoSmallLicks(:,1) a.reversalInfoBigLicks(:,2) a.reversalRandDLicks(:,2) a.reversalRandCLicks(:,2) a.reversalInfoSmallLicks(:,2)];

%% STATS for across reversal, info vs rand x 2 days before, 2 days after
% to ensure behavior did not meaningfully differ session-to-session

% revANOVA
% p1: are conditions different (info across reversal vs no info across
% reversal)
% p2: info vs rand within a day with bonferroni
% p3: day vs day within condition with bonferroni

% data=[a.reversalInfoBigLicks(idx1,:) a.reversalRandDLicks(idx1,:) a.reversalRandCLicks(idx1,:) a.reversalInfoSmallLicks(idx1,:)];
% [a.reversalLicksP1(1,1),a.reversalLicksP2{1},a.reversalLicksP3{1},a.reversalLicksP4{1}]=revANOVA4(data);
% data=[a.reversalInfoBigLicks(idx2,:) a.reversalRandDLicks(idx2,:) a.reversalRandCLicks(idx2,:) a.reversalInfoSmallLicks(idx2,:)];
% [a.reversalLicksP1(2,1),a.reversalLicksP2{2},a.reversalLicksP3{2},a.reversalLicksP4{2}]=revANOVA4(data);
% 
% data=[a.reversalInfoEarlyLicks(idx1,:) a.reversalRandEarlyLicks(idx1,:)];
% [a.reversalEarlyLicksP1(1,1),a.reversalEarlyLicksP2(1,:),a.reversalEarlyLicksP3{1}] = revANOVA(data);
% data=[a.reversalInfoEarlyLicks(idx2,:) a.reversalRandEarlyLicks(idx2,:)];
% [a.reversalEarlyLicksP1(2,1),a.reversalEarlyLicksP2(2,:),a.reversalEarlyLicksP3{2}] = revANOVA(data);
% 
% data=[a.reversalRewardRateCorrInfo(idx1,:) a.reversalRewardRateCorrRand(idx1,:)];
% [a.reversalRewardRateCorrP1(1,1),a.reversalRewardRateCorrP2(1,:),a.reversalRewardRateCorrP3{1}] = revANOVA(data);
% data=[a.reversalRewardRateCorrInfo(idx2,:) a.reversalRewardRateCorrRand(idx2,:)];
% [a.reversalRewardRateCorrP1(2,1),a.reversalRewardRateCorrP2(2,:),a.reversalRewardRateCorrP3{2}] = revANOVA(data);
% 
% data=[a.reversalRewardRateInfo(idx1,:) a.reversalRewardRateRand(idx1,:)];
% [a.reversalRewardRateP1(1,1),a.reversalRewardRateP2(1,:),a.reversalRewardRateP3{1}] = revANOVA(data);
% data=[a.reversalRewardRateInfo(idx2,:) a.reversalRewardRateRand(idx2,:)];
% [a.reversalRewardRateP1(2,1),a.reversalRewardRateP2(2,:),a.reversalRewardRateP3{2}] = revANOVA(data);
% 
% data=[a.reversalCorrectInfo(idx1,:) a.reversalCorrectInfo(idx1,:)];
% [a.reversalCorrectP1(1,1),a.reversalCorrectP2(1,:),a.reversalCorrectP3{1}] = revANOVA(data);
% data=[a.reversalCorrectInfo(idx2,:) a.reversalCorrectRand(idx2,:)];
% [a.reversalCorrectP1(2,1),a.reversalCorrectP2(2,:),a.reversalCorrectP3{2}] = revANOVA(data);
% 
% data=[a.reversalPrefEarly(idx1,:) a.reversalPrefLate(idx1,:)];
% [a.reversalSatietyP1(1,1),a.reversalSatietyP2(1,:),a.reversalSatietyP3{1}] = revANOVA(data);
% data=[a.reversalPrefEarly(idx2,:) a.reversalPrefLate(idx2,:)];
% [a.reversalSatietyP1(2,1),a.reversalSatietyP2(2,:),a.reversalSatietyP3{2}] = revANOVA(data);
% 
% data=[a.reversalRxnInfoForced(idx1,:) a.reversalRxnRandForced(idx1,:)];
% [a.reversalRxnForcedP1(1,1),a.reversalRxnForcedP2(1,:),a.reversalRxnForcedP3{1}] = revANOVA(data);
% data=[a.reversalRxnInfoForced(idx2,:) a.reversalRxnRandForced(idx2,:)];
% [a.reversalRxnForcedP1(2,1),a.reversalRxnForcedP2(2,:),a.reversalRxnForcedP3{2}] = revANOVA(data);
% 
% data=[a.reversalRxnInfoForced(idx1,:) a.reversalRxnInfoChoice(idx1,:) a.reversalRxnRandForced(idx1,:) a.reversalRxnRandChoice(idx1,:)];
% [a.reversalRxnP1(1,1),a.reversalRxnP2{1},a.reversalRxnP3{1}]=revANOVA4(data);
% data=[a.reversalRxnInfoForced(idx2,:) a.reversalRxnInfoChoice(idx2,:) a.reversalRxnRandForced(idx2,:) a.reversalRxnRandChoice(idx2,:)];
% [a.reversalRxnP1(2,1),a.reversalRxnP2{2},a.reversalRxnP3{2},a.reversalRxnP4{2}]=revANOVA4(data);

% licks=[a.reversalInfoBigLicks(idx1rev,1);a.reversalRandCLicks(idx1rev,1);a.reversalRandDLicks(idx1rev,1);a.reversalInfoSmallLicks(idx1rev,1)];
% tt=[ones(size(idx1rev))*1;ones(size(idx1rev))*2;ones(size(idx1rev))*3;ones(size(idx1rev))*4];
% [a.lickp1,~,stats] =anova1(licks,tt);
% %     aov=anova(tt,licks);
% %     c1=multcompare(aov);
% a.lickc1 = multcompare(stats);
% 
% licks=[a.reversalInfoBigLicks(idx1rev,2);a.reversalRandCLicks(idx1rev,2);a.reversalRandDLicks(idx1rev,2);a.reversalInfoSmallLicks(idx1rev,2)];
% tt=[ones(size(idx1rev))*1;ones(size(idx1rev))*2;ones(size(idx1rev))*3;ones(size(idx1rev))*4];
% [a.lickp2,~,stats] =anova1(licks,tt);
% %     aov=anova(tt,licks);
% %     c1=multcompare(aov);
% a.lickc2 = multcompare(stats);

%% DURING TRAINING 1

for m=1:numel(a.mouseList)
    days = a.trainingDays{m,1};

    a.training1Pref{m,1}=cell2mat(a.daySummary.percentInfo(m,days));

    a.training1RxnInfoForced{m,1}=cell2mat(a.daySummary.rxnInfoForced(m,days));
    a.training1RxnRandForced{m,1}=cell2mat(a.daySummary.rxnRandForced(m,days));
    a.training1MeanRxn(m,1)=mean(a.training1RxnInfoForced{m,1},'omitnan');
    a.training1MeanRxn(m,2)=mean(a.training1RxnRandForced{m,1},'omitnan');

    a.training1CorrectInfo{m,1}=cell2mat(a.daySummary.infoForcedCorr(m,days));
    a.training1CorrectRand{m,1}=cell2mat(a.daySummary.randForcedCorr(m,days));
    a.training1MeanCorrect(m,1)=mean(a.training1CorrectInfo{m,1},'omitnan');
    a.training1MeanCorrect(m,2)=mean(a.training1CorrectRand{m,1},'omitnan');

    a.training1RewardRateInfo{m,1}=cell2mat(a.daySummary.rewardRateInfoForced(m,days));
    a.training1RewardRateRand{m,1}=cell2mat(a.daySummary.rewardRateRandForced(m,days));
    a.training1MeanRewardRate(m,1)=mean(a.training1RewardRateInfo{m,1},'omitnan');
    a.training1MeanRewardRate(m,2)=mean(a.training1RewardRateRand{m,1},'omitnan');

    a.training1RewardRateCorrInfo{m,1}=cell2mat(a.daySummary.rewardRateInfoForcedCorr(m,days));
    a.training1RewardRateCorrRand{m,1}=cell2mat(a.daySummary.rewardRateRandForcedCorr(m,days));
    a.training1MeanRewardRateCorr(m,1)=mean(a.training1RewardRateCorrInfo{m,1},'omitnan');
    a.training1MeanRewardRateCorr(m,2)=mean(a.training1RewardRateCorrRand{m,1},'omitnan');
    
    a.training1InfoEarlyLicks{m,1}=cell2mat(a.daySummary.infoLicksEarly(m,days));
    a.training1RandEarlyLicks{m,1}=cell2mat(a.daySummary.randLicksEarly(m,days));
    a.trainin1MeanEarlyLicks(m,1)=mean(a.training1InfoEarlyLicks{m,1},'omitnan');
    a.trainin1MeanEarlyLicks(m,2)=mean(a.training1RandEarlyLicks{m,1},'omitnan');

    a.training1InfoBigLicks{m,1}=cell2mat(a.daySummary.infoBigLicks(m,days));
    a.training1InfoSmallLicks{m,1}=cell2mat(a.daySummary.infoSmallLicks(m,days));
    a.training1RandCLicks{m,1}=cell2mat(a.daySummary.randCLicks(m,days));
    a.training1RandDLicks{m,1}=cell2mat(a.daySummary.randDLicks(m,days));
    a.training1MeanLicks(m,1)=mean(a.training1InfoBigLicks{m,1},'omitnan');
    a.training1MeanLicks(m,2)=mean(a.training1RandCLicks{m,1},'omitnan');
    a.training1MeanLicks(m,3)=mean(a.training1RandDLicks{m,1},'omitnan');
    a.training1MeanLicks(m,4)=mean(a.training1InfoSmallLicks{m,1},'omitnan');
end

%% DURING TRAINING 2
for m=1:numel(a.mouseList)
    days = a.trainingDays{m,2};

    a.training2Pref{m,1}=cell2mat(a.daySummary.percentInfo(m,days));

    a.training2RxnInfoForced{m,1}=cell2mat(a.daySummary.rxnInfoForced(m,days));
    a.training2RxnRandForced{m,1}=cell2mat(a.daySummary.rxnRandForced(m,days));
    a.training2MeanRxn(m,1)=mean(a.training2RxnInfoForced{m,1},'omitnan');
    a.training2MeanRxn(m,2)=mean(a.training2RxnRandForced{m,1},'omitnan');

    a.training2CorrectInfo{m,1}=cell2mat(a.daySummary.infoForcedCorr(m,days));
    a.training2CorrectRand{m,1}=cell2mat(a.daySummary.randForcedCorr(m,days));
    a.training2MeanCorrect(m,1)=mean(a.training2CorrectInfo{m,1},'omitnan');
    a.training2MeanCorrect(m,2)=mean(a.training2CorrectRand{m,1},'omitnan');

    a.training2RewardRateInfo{m,1}=cell2mat(a.daySummary.rewardRateInfoForced(m,days));
    a.training2RewardRateRand{m,1}=cell2mat(a.daySummary.rewardRateRandForced(m,days));
    a.training2MeanRewardRate(m,1)=mean(a.training2RewardRateInfo{m,1},'omitnan');
    a.training2MeanRewardRate(m,2)=mean(a.training2RewardRateRand{m,1},'omitnan');

    a.training2RewardRateCorrInfo{m,1}=cell2mat(a.daySummary.rewardRateInfoForcedCorr(m,days));
    a.training2RewardRateCorrRand{m,1}=cell2mat(a.daySummary.rewardRateRandForcedCorr(m,days));
    a.training2MeanRewardRateCorr(m,1)=mean(a.training2RewardRateCorrInfo{m,1},'omitnan');
    a.training2MeanRewardRateCorr(m,2)=mean(a.training2RewardRateCorrRand{m,1},'omitnan');
    
    a.training2InfoEarlyLicks{m,1}=cell2mat(a.daySummary.infoLicksEarly(m,days));
    a.training2RandEarlyLicks{m,1}=cell2mat(a.daySummary.randLicksEarly(m,days));
    a.training2MeanEarlyLicks(m,1)=mean(a.training2InfoEarlyLicks{m,1},'omitnan');
    a.training2MeanEarlyLicks(m,2)=mean(a.training2RandEarlyLicks{m,1},'omitnan');

    a.training2InfoBigLicks{m,1}=cell2mat(a.daySummary.infoBigLicks(m,days));
    a.training2InfoSmallLicks{m,1}=cell2mat(a.daySummary.infoSmallLicks(m,days));
    a.training2RandCLicks{m,1}=cell2mat(a.daySummary.randCLicks(m,days));
    a.training2RandDLicks{m,1}=cell2mat(a.daySummary.randDLicks(m,days));
    a.training2MeanLicks(m,1)=mean(a.training2InfoBigLicks{m,1},'omitnan');
    a.training2MeanLicks(m,2)=mean(a.training2RandCLicks{m,1},'omitnan');
    a.training2MeanLicks(m,3)=mean(a.training2RandDLicks{m,1},'omitnan');
    a.training2MeanLicks(m,4)=mean(a.training2InfoSmallLicks{m,1},'omitnan');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PREFERENCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% MEAN CHOICES / STATS AND CHOICE RANGES

trialsToCount = 200;

if ~isempty(a.choiceMice)
    
    a.meanChoice = NaN(a.mouseCt,3);
    a.choiceCI = NaN(a.mouseCt,2);
    a.prefCI = NaN(a.mouseCt,2);
    a.pref = NaN(a.mouseCt,8);
    a.beta = NaN(a.mouseCt,2);
       
   for mm = 1:a.choiceMouseCt
       m = a.choiceMice(mm);
       
       ok = a.mice(:,m) == 1 & a.trialType == 1 & a.trialTypes == 5 & a.correct == 1;
       okidx = find(ok);
       [~,sortidx] = sort(a.mouseDay(ok==1));
       oksorted = okidx(sortidx);
       
       % that mouse's choice trials
       choicesIIS = a.choice_all(ok);
       choicesIIS = choicesIIS(sortidx);
       choices = a.info(ok);
       choices = choices(sortidx);
       reverses = a.reverse(ok);
       reverses = reverses(sortidx);
       
       
       a.cumInfo{m,1}=cumsum(choices(reverses==1));
       a.choices{m,1}=choices(reverses==1);

       preReverseTrials = find(reverses == 1,trialsToCount,'last');
       [a.pref(m,1),a.prefCI(m,1:2)] = binofit(sum(choicesIIS(preReverseTrials)==1),numel(choicesIIS(preReverseTrials)));
       [a.pref(m,3),a.prefCI(m,3:4)] = binofit(sum(choices(preReverseTrials)==1),numel(choices(preReverseTrials))); 
       if ismember(m,a.reverseMice)
         postReverseTrials = find(reverses == -1,trialsToCount,'last'); % during reverse
         [a.pref(m,2),a.prefRevCI(m,1:2)] = binofit(sum(choicesIIS(postReverseTrials)==1),numel(choicesIIS(postReverseTrials)));
         [a.pref(m,4),a.prefRevCI(m,3:4)] = binofit(sum(choices(postReverseTrials)==1),numel(choices(postReverseTrials)));
         if sum(reverses == 2) > 0
             reReverseTrials = find(reverses == 2,trialsToCount,'last'); % during reverse
             [a.pref(m,5),a.prefReRevCI(m,1:2)] = binofit(sum(choicesIIS(reReverseTrials)==1),numel(choicesIIS(reReverseTrials)));
             [a.pref(m,6),a.prefReRevCI(m,3:4)] = binofit(sum(choices(reReverseTrials)==1),numel(choices(reReverseTrials)));             
         end
         if sum(reverses == -2) > 0
             reverse2Trials = find(reverses == -2,trialsToCount,'last'); % during reverse
             [a.pref(m,7),a.pref2RevCI(m,1:2)] = binofit(sum(choicesIIS(reverse2Trials)==1),numel(choicesIIS(reverse2Trials)));
             [a.pref(m,8),a.pref2RevCI(m,3:4)] = binofit(sum(choices(reverse2Trials)==1),numel(choices(reverse2Trials)));
         end
         
       % FOR ALL REVERSES
       x = [a.initinfoside_side(ok & a.reverse~=0) a.initinfoside_info(ok & a.reverse~=0)];
       y = a.choice_all(ok & a.reverse~=0);
       [~,~,a.stats(m)] = glmfit(x,y,'binomial','link','logit','constant','off'); % error here
       a.beta(m,:) = a.stats(m).beta;
       a.betaP(m,:) = a.stats(m).p;
       a.betaSE(m,:) = a.stats(m).se;         
       end

       % For all, not just last 300, trials of choiceIIS
       choicePreRev = a.choice_all(ok & a.reverse == 1);
       [a.meanChoice(m,1),a.choiceCI(m,1:2)] = binofit(sum(choicePreRev==1),numel(choicePreRev));
       
       % FOR FIRST REVERSE
       if ismember(m,a.reverseMice)
           choicePostRev = a.choice_all(ok & a.reverse==-1);
           [a.meanChoice(m,2),a.choiceRevCI(m,1:2)] = binofit(sum(choicePostRev==1),numel(choicePostRev));
       end
       a.meanChoice(m,3) = m;
       
       [a.choicePreferenceAll(m,1),a.choiceCIAll(m,1:2)] = binofit(sum(a.info(ok)==1),numel(a.info(ok)));
 
   end

   % pref(:,1) for up to 300 trials, mean choice for all
%     a.meanChoice = a.meanChoice(a.meanChoice(:,3)>0,:);
%     a.choiceCI = a.choiceCI(a.choiceCI(:,1)>0,:);
       
    allOk = a.trialType == 1 & a.trialTypes == 5 & a.correct == 1;
   [a.choicePreferenceAllMice,a.choiceCIAllMice] = binofit(sum(a.info(ok)==1),numel(a.info(ok)));
   
    % Initial preference across mice, not just first 300 trials
    allChoices = a.choice_all(allOk & a.reverse == 1); % fix this
    [a.overallPref,a.overallPrefCI] = binofit(sum(allChoices == 1),numel(allChoices));
    
    [a.sortedChoice,a.sortIdx] = sortrows(a.meanChoice(~isnan(a.meanChoice(:,1)),:),1);
    a.sortedMouseList = a.choiceMiceList(a.sortIdx);
    a.sortedCI = a.choiceCI(a.sortIdx,:);
    a.icp_all = a.sortedChoice(:,1)*100;    
    a.overallP = signrank(a.icp_all-50);    
  
end

%% OVERALL CHOICES BY SIDE

if numel(a.reverseMice)>0
    for m = 1:a.mouseCt
       ok = a.mice(:,m) == 1 & a.trialType == 1 & a.trialTypes == 5 & a.reverse~= 0 & a.correct == 1; % need to match params
       a.overallChoice(m,1) = binofit(sum(a.info(ok & a.infoSide == 0)),sum(ok & a.infoSide == 0)); %mean(a.info(ok & a.infoSide == 0)); % info side = 0
       a.overallChoice(m,2) = binofit(sum(a.info(ok & a.infoSide == 1)),sum(ok & a.infoSide == 1));%mean(a.info(ok & a.infoSide == 1)); % info side = 1
       a.overallChoice(m,3) = binofit(sum(a.info(ok & a.infoSide == a.initinfoside(m,1))),sum(ok & a.infoSide == a.initinfoside(m,1)));%mean(a.info(ok & a.infoSide == a.initinfoside(m,1)));
       a.overallChoice(m,4) = binofit(sum(a.info(ok & a.infoSide ~= a.initinfoside(m,1))),sum(ok & a.infoSide ~= a.initinfoside(m,1)));%mean(a.info(ok & a.infoSide ~= a.initinfoside(m,1)));
%        [test(m,1),test2(m,1:2)] = binofit(sum(a.info(ok)),sum(ok));
       a.overallChoice(m,5) = mean(a.overallChoice(m,[1 2]),2,'omitnan');
       [a.overallChoice(m,6),a.overallCI(m,[1 2])] = binofit(sum(a.info(ok)),sum(ok));
       a.overallChoiceSEM(m) = sem(a.overallChoice(m,[1 2]));
       ts=tinv([0.025  0.975],2-1);
%        a.overallCI(m,[1 2]) = a.overallChoice(m,5)+ts*a.overallChoiceSEM(m);
    end
%  a.overallChoice(:,5) = nanmean(a.overallChoice(:,[1 2]),2);
 a.overallChoicePercent = a.overallChoice(:,5)*100;
 a.overallChoiceP = signrank(a.overallChoicePercent-50);
end

%% INCOMPLETE

for m = 1:a.mouseCt
    ok = a.mice(:,m) == 1 & ismember(a.mouseDay,a.reversalDays(m,:)) & a.correct==1;
%     ok = a.mice(:,m) == 1 & abs(a.reverse)==1 & a.correct==1;
%     ok = a.mice(:,m) == 1 & a.trialTypes==5 & a.correct==1;
    mouseOutcomes = a.outcome(ok);
    mouseInitialOutcomes = a.outcome(a.mice(:,m)==1 & a.reverse==1);
    % info choice big
    a.incomplete(m,1) =  sum(mouseOutcomes == 3)/sum(ismember(mouseOutcomes,[2 3]));
    % info choice small
    a.incomplete(m,2) =  sum(mouseOutcomes == 5)/sum(ismember(mouseOutcomes,[4 5]));
    % rand choice big
    a.incomplete(m,3) = sum(mouseOutcomes == 7)/sum(ismember(mouseOutcomes, [6 7]));
    % rand choice small
    a.incomplete(m,4) =  sum(mouseOutcomes == 9)/sum(ismember(mouseOutcomes,[8 9]));    
    % info big
    a.incomplete(m,5) =  sum(mouseOutcomes == 12)/sum(ismember(mouseOutcomes,[11 12]));    
    % info small
    a.incomplete(m,6) =  sum(mouseOutcomes == 14)/sum(ismember(mouseOutcomes,[13 14]));
    a.initialIncomplete(m,1) = sum(mouseInitialOutcomes == 14)/sum(ismember(mouseInitialOutcomes,[13 14]));
    % rand big
    a.incomplete(m,7) =  sum(mouseOutcomes == 18)/sum(ismember(mouseOutcomes,[17 18]));
    % rand small
    a.incomplete(m,8) =  sum(mouseOutcomes == 20)/sum(ismember(mouseOutcomes,[19 20]));
    
    a.incompleteInfoRand(m,1) = sum(ismember(mouseOutcomes,[3 5 12 14])) / sum(ismember(mouseOutcomes,[2 3 4 5 11 12 13 14]));
    a.incompleteInfoRand(m,2) = sum(ismember(mouseOutcomes,[7 9 18 20])) / sum(ismember(mouseOutcomes,[6 7 8 9 17 18 19 20]));
    
    a.initialIncompleteInfoRand(m,1) = sum(ismember(mouseInitialOutcomes,[3 5 12 14])) / sum(ismember(mouseInitialOutcomes,[2 3 4 5 11 12 13 14]));
    a.initialIncompleteInfoRand(m,2) = sum(ismember(mouseInitialOutcomes,[7 9 18 20])) / sum(ismember(mouseInitialOutcomes,[6 7 8 9 17 18 19 20])); 
end

a.incompleteDifference = a.incompleteInfoRand(:,1) - a.incompleteInfoRand(:,2);
a.initialIncompleteDifference = a.initialIncompleteInfoRand(:,1) - a.initialIncompleteInfoRand(:,2);


%% INCOMPLETE DURING TRAINING

for m = 1:a.mouseCt
    ok = a.mice(:,m) == 1 & a.training==2 & a.correct==1;
%     ok = a.mice(:,m) == 1 & a.trialTypes==5 & a.correct==1;
    mouseOutcomes = a.outcome(ok);
%     mouseInitialOutcomes = a.outcome(a.mice(:,m)==1 & a.reverse==1);
    % info choice big
    a.incompleteTrain(m,1) =  sum(mouseOutcomes == 3)/sum(ismember(mouseOutcomes,[2 3]));
    % info choice small
    a.incompleteTrain(m,2) =  sum(mouseOutcomes == 5)/sum(ismember(mouseOutcomes,[4 5]));
    % rand choice big
    a.incompleteTrain(m,3) = sum(mouseOutcomes == 7)/sum(ismember(mouseOutcomes, [6 7]));
    % rand choice small
    a.incompleteTrain(m,4) =  sum(mouseOutcomes == 9)/sum(ismember(mouseOutcomes,[8 9]));    
    % info big
    a.incompleteTrain(m,5) =  sum(mouseOutcomes == 12)/sum(ismember(mouseOutcomes,[11 12]));    
    % info small
    a.incompleteTrain(m,6) =  sum(mouseOutcomes == 14)/sum(ismember(mouseOutcomes,[13 14]));
%     a.initialIncomplete(m,1) = sum(mouseInitialOutcomes == 14)/sum(ismember(mouseInitialOutcomes,[13 14]));
    % rand big
    a.incompleteTrain(m,7) =  sum(mouseOutcomes == 18)/sum(ismember(mouseOutcomes,[17 18]));
    % rand small
    a.incompleteTrain(m,8) =  sum(mouseOutcomes == 20)/sum(ismember(mouseOutcomes,[19 20]));
    
%     a.incompleteInfoRand(m,1) = sum(ismember(mouseOutcomes,[3 5 12 14])) / sum(ismember(mouseOutcomes,[2 3 4 5 11 12 13 14]));
%     a.incompleteInfoRand(m,2) = sum(ismember(mouseOutcomes,[7 9 18 20])) / sum(ismember(mouseOutcomes,[6 7 8 9 17 18 19 20]));
%     
%     a.initialIncompleteInfoRand(m,1) = sum(ismember(mouseInitialOutcomes,[3 5 12 14])) / sum(ismember(mouseInitialOutcomes,[2 3 4 5 11 12 13 14]));
%     a.initialIncompleteInfoRand(m,2) = sum(ismember(mouseInitialOutcomes,[7 9 18 20])) / sum(ismember(mouseInitialOutcomes,[6 7 8 9 17 18 19 20])); 
end


%% SAVE

save(fullfile(datapath,'infoSeekData_ALLBEHAVIOR_analyzed_NEW3.mat'),'-struct','a','-v7.3');