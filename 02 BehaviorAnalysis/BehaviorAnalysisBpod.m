% clear all; close all;

datapath=findInfoseekData();

a1=a;
clear a;
% a1=load('behaviorMiceBpodStay.mat');

a1.sessions2.name={a1.sessions(:).name}';
a1.sessions2.date={a1.sessions(:).date}';
a1.sessions2.mouse={a1.sessions(:).mouse}';

a1.sessions=a1.sessions2;


% DELETE SESSIONS2!!!!!
a1=rmfield(a1,'sessions2');

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

% Also need to adjust this to have file and trial number!
a1.odor2LeavingTime = a1.odor2LeavingTime-a1.odor2On;
a1.odor2LeavingTime(:,[2 3]) = [a1.file a1.trial];




%%

a=a1;
clear a1;

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
a.rewardCorr=a.reward(a.correct==1); %these are the same!

a.typeNames = {'Info Water','Info None','Rand Water','Rand None'};
a.typeSizes = [sum(a.infoBig) sum(a.infoSmall) sum(a.randBig) sum(a.randSmall)];

% a.choiceCorrTrials = a.trialType == 1 & a.correct == 1 & a.trialTypes == 5;
% a.forcedCorrTrials = a.trialType ~= 1 & a.correct == 1;
a.infoCorrTrials = a.info == 1 & a.correct == 1;
a.randCorrTrials = a.info == 0 & a.correct == 1;
a.infoCorr = a.info(a.correct == 1);

 % ERRORS

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
    a.mouseDay(t,1)=find(strcmp(a.day(t,1),a.mouseDays{find(a.mice(t,:))}));
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
                        elseif r>1 & r<numel(reverses)-2
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

% dayDates = datetime(unique(a.day),'InputFormat','yyyyMMdd');
% toDay = string(datetime(max(dayDates),'Format','yyyyMMdd'));
% a.today = a.day == toDay;
% a.currentMiceList = unique(a.mouse(a.today==1));
% a.currentMice = find(ismember(a.mouseList,a.currentMiceList));

a.choiceMiceList = a.mouseList(a.choiceMice);
a.choiceMouseCt = numel(a.choiceMice);

a.reverseMice = find(a.reverseMice);
a.reverseMiceList  = a.mouseList(a.reverseMice);

% a.timeoutMice=[];

% SILENCING MICE
% 1 = halo, 2 = YFP
% a.halo = zeros(a.mouseCt,1);
% a.halo([1 2 6 7 10 11 12])=1;
% a.halo([3 4 5 8 9])=2;


%% DAYS AROUND FIRST REVERSAL
% want: before and after first reversal 3 days to show pref and for "only pre-reverse analysis"
a.reverseAround=NaN(numel(a.reverseMice),6);
if ~isempty(a.reverseMice)
    for m=1:numel(a.reverseMice)
        mm=a.reverseMice(m);
        dd=a.reverseDay{m,1};
        a.reverseAround(m,:) = [dd-3:dd+2];
    end
end

%% DAYS AROUND FIRST REVERSAL (last 2 before, last 2 after)

% 2 days before reversal, last 2 days after reversal
if ~isempty(a.reverseMice)
    a.reversalDays = NaN(numel(a.reverseMice),4);
    for m = 1:numel(a.reverseMice)
        mm=a.reverseMice(m);
        a.reversalDays(m,1) = a.reverseDay{mm,1}-2; % 2 days prior to 1st reversal
        a.reversalDays(m,2) = a.reverseDay{mm,1}-1;
        if ~isempty(a.reverseDay{mm,2})
            a.reversalDays(m,3) = a.reverseDay{mm,2}-2;
            a.reversalDays(m,4) = a.reverseDay{mm,2}-1;
        else
            a.reversalDays(m,3) = a.lastParamDay(mm)-1;
            a.reversalDays(m,4) = a.lastParamDay(mm);
        end
    end
end




%% PREFERENCE AROUND FIRST REVERSAL, by mouse and by day NOW BAD
% 
% a.=NaN(numel(a.reverseMice),6);
% for m=1:numel(a.reverseMice)
%     mm=a.reverseMice(m);
%    dd=a.reverseDay{m,1};
%    for n=1:3
%        a.reverseAround(m,4-n) = a.daySummary.percentIIS{mm,dd-n};
%        d=4-n;
%        ok=a.trialType == 1 & a.trialTypes == 5&a.mouseDay == dd-n & a.mice(:,mm) == 1 & a.correct == 1;
%        a.choicesAround{m,d}=a.choice_all(ok);
%    end
%    for k=0:2
%        a.reverseAround(m,4+k) = a.daySummary.percentIIS{mm,dd+k};
%        d=4+k;
%        ok=a.trialType == 1 & a.trialTypes == 5&a.mouseDay == dd+k & a.mice(:,mm) == 1 & a.correct == 1;
%        a.choicesAround{m,d}=a.choice_all(ok);
%    end
% end
% 
% for d=1:size(a.choicesAround,2)
%     choices=vertcat(a.choicesAround{:,d});
%    [a.choiceAroundMean(1,d), a.choiceAroundCI(1:2,d)] = binofit(sum(choices==1),numel(choices));
% end


%%
a.infoCorrCodes = [11 13 14];
a.infoIncorrCodes = [10 12 15];
a.randCorrCodes = [17 19];
a.randIncorrCodes = [16 18 20 21];
a.choiceCorrCodes = [2 4 5 6 8];
a.choiceIncorrCodes = [1 3 7 9];

a.errorLabels = {'Correct','No Choice','Incorrect Choice','Not Present','Leaving Timeout'};

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
        
        a.daySummary.rxnSpeedIdx{m,d} = (nanmean(a.rxnSpeed(ok & a.infoCorrTrials == 1)) - nanmean(a.rxnSpeed(ok & a.randCorrTrials)))/(nanmean(a.rxnSpeed(ok & a.infoCorrTrials)) + nanmean(a.rxnSpeed(ok & a.randCorrTrials)));        

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

        a.daySummary.trialLengthInfoForced{m,d} = nansum(a.trialLength(a.infoForcedCorrect == 1 & okCorr == 1))/sum(~isnan(a.trialLength(a.infoForcedCorrect == 1 & okCorr == 1)));
        a.daySummary.trialLengthInfoChoice{m,d} = nansum(a.trialLength(a.infoChoiceCorrect == 1 & okCorr == 1))/sum(~isnan(a.trialLength(a.infoChoiceCorrect == 1 & okCorr == 1)));
        a.daySummary.trialLengthRandForced{m,d} = nansum(a.trialLength(a.randForcedCorrect == 1 & okCorr == 1))/sum(~isnan(a.trialLength(a.randForcedCorrect == 1 & okCorr == 1)));
        a.daySummary.trialLengthRandChoice{m,d} = nansum(a.trialLength(a.randChoiceCorrect == 1 & okCorr == 1))/sum(~isnan(a.trialLength(a.randChoiceCorrect == 1 & okCorr == 1)));        
        
        a.daySummary.maxDelay{m,d} = max(a.odorDelay(ok))+max(a.rewardDelay(ok));
               
        a.daySummary.ARewards{m,d} = nansum(a.rewardCorr(a.odorAtrials==1 & okCorr==1))/nansum(a.odorAtrials & okCorr);
        a.daySummary.BRewards{m,d} = nansum(a.rewardCorr(a.odorBtrials==1 & okCorr==1))/nansum(a.odorBtrials & okCorr);
        a.daySummary.CRewards{m,d} = nansum(a.rewardCorr(a.odorCtrials==1 & okCorr==1))/nansum(a.odorCtrials & okCorr);
        a.daySummary.DRewards{m,d} = nansum(a.rewardCorr(a.odorDtrials==1 & okCorr==1))/nansum(a.odorDtrials & okCorr);
        a.daySummary.randBigRewards{m,d} = nansum(a.rewardCorr(a.randBigCorr==1 & okCorr==1))/nansum(a.randBigCorr & okCorr);
        a.daySummary.randSmallRewards{m,d} = nansum(a.rewardCorr(a.randSmallCorr==1 & okCorr==1))/nansum(a.randSmallCorr & okCorr);
        
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

%% DAYS BEFORE FIRST REVERSAL - mean of last two

for m=1:numel(a.mouseList)
    days = a.reverseAround(m,2:3);

    a.preRevPref(m,:)=cell2mat(a.daySummary.percentInfo(m,days));
    a.preRevPrefMean(m,:)=mean(a.preRevPref(m,:),'omitnan');
    a.preRevPrefSEM(m,:)=sem(a.preRevPref(m,:));
    a.preRevPrefEarly(m,:)=cell2mat(a.daySummary.percentInfoEarly(m,days));
    a.preRevPrefLate(m,:)=cell2mat(a.daySummary.percentInfoLate(m,days));
    a.preRevPrefEarlyMean(m,:)=mean(a.preRevPrefEarly(m,:),'omitnan');
    a.preRevPrefLateMean(m,:)=mean(a.preRevPrefLate(m,:),'omitnan');

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

    a.preRevInfoEarlyLicks(m,:)=cell2mat(a.daySummary.infoLicksEarly(m,days));
    a.preRevRandEarlyLicks(m,:)=cell2mat(a.daySummary.randLicksEarly(m,days));
    a.preRevEarlyLicksMean(m,1)=mean(a.preRevInfoEarlyLicks(m,:),'omitnan');
    a.preRevEarlyLicksMean(m,2)=mean(a.preRevRandEarlyLicks(m,:),'omitnan');

    a.preRevInfoBigLicks(m,:)=cell2mat(a.daySummary.infoBigLicks(m,days));
    a.preRevInfoSmallLicks(m,:)=cell2mat(a.daySummary.infoSmallLicks(m,days));
    a.preRevRandCLicks(m,:)=cell2mat(a.daySummary.randCLicks(m,days));
    a.preRevRandDLicks(m,:)=cell2mat(a.daySummary.randDLicks(m,days));
    a.preRevLicksMean(m,1)=mean(a.preRevInfoBigLicks(m,:),'omitnan');
    a.preRevLicksMean(m,2)=mean(a.preRevRandDLicks(m,:),'omitnan');
    a.preRevLicksMean(m,3)=mean(a.preRevRandCLicks(m,:),'omitnan');
    a.preRevLicksMean(m,4)=mean(a.preRevInfoSmallLicks(m,:),'omitnan');

end

%% PRE-REVERSAL PORT DWELL

for m=1:a.mouseCt
    days = a.reverseAround(m,2:3);
    
    for dd=1:numel(days)
        d=days(dd);
       ok=a.reverse==1 & a.trialTypes == 5 & a.correct==1 & a.mouseNums==m & a.mouseDay==d;
       a.infoDwell(m,dd)= mean(mean(a.infoPort(a.infoForced & ok,54:250),2));
       a.randDwell(m,dd) = mean(mean(a.randPort(a.randForced & ok,54:250),2));
       a.infoDwell1sec(m,dd)= mean(mean(a.infoPort(a.infoForced & ok,54:74),2));
       a.randDwell1sec(m,dd)=mean(mean(a.randPort(a.randForced & ok,54:74),2));

       a.centerDwellChoice(m,:,dd)= mean(a.Port2(a.trialType==1 & ok,:));
       a.centerDwellInfo(m,:,dd) = mean(a.Port2(a.trialType==2 & ok,:));
       a.centerDwellRand(m,:,dd) = mean(a.Port2(a.trialType==3 & ok,:));
       a.centerDwellChoiceMean(m,:)=mean(a.centerDwellChoice(m,:,:),3);
       a.centerDwellInfoMean(m,:)=mean(a.centerDwellChoice(m,:,:),3);
       a.centerDwellRandMean(m,:)=mean(a.centerDwellChoice(m,:,:),3);

       a.infoDwellInfoBig(m,:,dd) = mean(a.infoPort(a.infoBig==1 & ok,:));
       a.infoDwellInfoSmall(m,:,dd) = mean(a.infoPort(a.infoSmall==1 & ok,:));
       a.infoDwellInfo(m,:,dd) = mean(a.infoPort(a.trialType==2 & ok,:));
       a.infoDwellRandBig(m,:,dd) = mean(a.infoPort(a.randBig==1 & ok,:));
       a.infoDwellRandSmall(m,:,dd) = mean(a.infoPort(a.randSmall==1 & ok,:));
       a.infoDwellRand(m,:,dd) = mean(a.infoPort(a.trialType==3 & ok,:));
       a.infoDwellInfoBigMean(m,:)=mean(a.infoDwellInfoBig(m,:,:),3);
       a.infoDwellInfoSmallMean(m,:)=mean(a.infoDwellInfoSmall(m,:,:),3);
       a.infoDwellInfoMean(m,:)=mean(a.infoDwellInfo(m,:,:),3);
       a.infoDwellRandBigMean(m,:)=mean(a.infoDwellRandBig(m,:,:),3);
       a.infoDwellRandSmallMean(m,:)=mean(a.infoDwellRandSmall(m,:,:),3);
       a.infoDwellRandMean(m,:)=mean(a.infoDwellRand(m,:,:),3);

       a.randDwellInfoBig(m,:,dd) = mean(a.randPort(a.infoBig==1 & ok,:));
       a.randDwellInfoSmall(m,:,dd) = mean(a.randPort(a.infoSmall==1 & ok,:));
       a.randDwellInfo(m,:,dd) = mean(a.randPort(a.trialType==2 & ok,:));
       a.randDwellRandBig(m,:,dd) = mean(a.randPort(a.randBig==1 & ok,:));
       a.randDwellRandSmall(m,:,dd) = mean(a.randPort(a.randSmall==1 & ok,:));
       a.randDwellRand(m,:,dd) = mean(a.randPort(a.trialType==3 & ok,:));
       a.randDwellInfoBigMean(m,:)=mean(a.randDwellInfoBig(m,:,:),3);
       a.randDwellInfoSmallMean(m,:)=mean(a.randDwellInfoSmall(m,:,:),3);
       a.randDwellInfoMean(m,:)=mean(a.randDwellInfo(m,:,:),3);
       a.randDwellRandBigMean(m,:)=mean(a.randDwellRandBig(m,:,:),3);
       a.randDwellRandSmallMean(m,:)=mean(a.randDwellRandSmall(m,:,:),3);
       a.randDwellRandMean(m,:)=mean(a.randDwellRand(m,:,:),3);
    end
end

%% PREF FULL DAYS AROUND

for m=1:numel(a.mouseList)
    days = a.reverseAround(m,:);
    a.reversalMultiPrefsIIS(m,:)=cell2mat(a.daySummary.percentIIS(m,days));
    a.reversalMultiPrefs(m,:)=cell2mat(a.daySummary.percentInfo(m,days));
end

for d=1:6
a.reversalMultiPrefsP(1,d) = signrank(a.reversalMultiPrefs(:,d)*100-50);
end

%% DAYS BEFORE AND AFTER FIRST REVERSAL

for m=1:numel(a.mouseList)
    days = a.reversalDays(m,:);

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

end


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

%% ANOVA STATISTICS

% data=[a.reversalRewardRateCorrInfo a.reversalRewardRateCorrRand];
% [ranova_days, ranova_conditions, ranova_both] =revANOVA(data);
% 
% data=[a.preRevRxnInfoForced a.preRevRxnRandForced];
% tbl = array2table(data, 'VariableNames', strcat('V', string(1:size(data, 2))));
% num_days = 3;
% num_conditions = 2;
% % Generate the within-subject design
% Days = repmat((1:num_days)', num_conditions, 1);
% Conditions = repelem((1:num_conditions)', num_days);
% WithinDesign = table(Days, Conditions, 'VariableNames', {'Day', 'Condition'});
% rm = fitrm(tbl, 'V1-V6 ~ 1', 'WithinDesign', WithinDesign);
% ranova_days = ranova(rm, 'WithinModel', 'Day');
% ranova_conditions = ranova(rm, 'WithinModel', 'Condition');
% ranova_both = ranova(rm, 'WithinModel', 'Condition*Day')
% 
% pValue_Days = ranova_days.pValue(3)
% pValue_Condition = ranova_conditions.pValue(3)
% pvalue_Interaction = ranova_both.pValue(y)

% data=[a.preRevRxnInfoForced];
% tbl = array2table(data, 'VariableNames', strcat('V', string(1:size(data, 2))));
% num_days = 3;
% num_conditions = 2;
% % Generate the within-subject design
% Days = repmat((1:num_days)', num_conditions, 1);
% Conditions = repelem((1:num_conditions)', num_days);
% Days=(1:num_days)';
% WithinDesign = table(Days, 'VariableNames', {'Days'});
% rm = fitrm(tbl, 'V1-V3 ~ 1', 'WithinDesign', WithinDesign);
% ranova_days = ranova(rm, 'WithinModel', 'Days');
% % ranova_conditions = ranova(rm, 'WithinModel', 'Condition');
% 
% pValue_Days = ranova_days.pValue(3)
% % pValue_Condition = ranova_conditions.pValue(3)
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
       a.overallChoice(m,5) = nanmean(a.overallChoice(m,[1 2]),2);
       [a.overallChoice(m,6),a.overallCI(m,[1 2])] = binofit(sum(a.info(ok)),sum(ok));
       a.overallChoiceSEM(m) = sem(a.overallChoice(m,[1 2]));
       ts=tinv([0.025  0.975],2-1);
%        a.overallCI(m,[1 2]) = a.overallChoice(m,5)+ts*a.overallChoiceSEM(m);
    end
%  a.overallChoice(:,5) = nanmean(a.overallChoice(:,[1 2]),2);
 a.overallChoicePercent = a.overallChoice(:,5)*100;
 a.overallChoiceP = signrank(a.overallChoicePercent-50);
end

% x = randi(50, 1, 100);                      % Create Data
% SEM = std(x)/sqrt(length(x));               % Standard Error
% ts = tinv([0.025  0.975],length(x)-1);      % T-Score
% CI = mean(x) + ts*SEM;                      % Confidence Intervals

%% DAYS AROUND REVERSES

% if ~isempty(a.reverseMice)
%     a.reversalDays = NaN(numel(a.reverseMice),4);
%     for m = 1:numel(a.reverseMice)
%         mm=a.reverseMice(m);
%         a.reversalDays(m,1) = a.reverseDay{mm,1}-1; % day prior to 1st reversal
%         if size(cell2mat(a.reverseDay(mm,:)),2) > 1
%             if ~isempty(a.reverseDay{mm,2})
%             a.reversalDays(m,2) = a.reverseDay{mm,2}-1; % day prior to second reversal
%             % last day of second reversal (either r+3/last day or last day before get
%             % ready for values)
%                 if ~isempty(a.reverseDay{mm,3})
%                     a.reversalDays(m,3) = a.reverseDay{mm,3}-1; % day prior to third reversal
%                     a.reversalDays(m,4) = a.lastParamDay(mm);
%                 else
%                     if a.reverseDay{mm,2}+3 >= a.lastParamDay(mm)
%                         a.reversalDays(m,3) = a.lastParamDay(mm);
%                     else
%                         a.reversalDays(m,3) = a.reverseDay{mm,2}+3;
%                     end
%                 end
%             end
%         end
%     end
% end

% %% BEHAVIOR ACROSS REVERSALS (PER DAY, PER REVERSAL, PER SIDE). Relative to current info side
% 
% % for per reversal and per side, use infoside,a.reverse (unless need to
% % sort and pull first 300 OR want only a single day)
% 
% % reward rate, % trials leaving
% 
% % for per day, use a.mouseDays/a.mouseDayCt and a.firstChoiceDay,
% % a.reversalDays,a.lastParamDay = max(a.reversalDays?)
% 
% % make cell array of relevant days for each mouse and then can just plot
% % these
% % a.choiceDays
% 
% if ~isempty(a.reverseMice)
%     for m = 1:numel(a.reverseMice)
%         mm=a.reverseMice(m);
%         a.choiceDays{1,:,m} = a.firstChoiceDay(mm):a.reversalDays(m,1);
%         a.choiceDays{2,:,m} = a.reversalDays(m,1)+1:a.reversalDays(m,2);
%         a.choiceDays{3,:,m} = a.reversalDays(m,2)+1:a.reversalDays(m,3);
%         a.choiceDays{4,:,m} = a.reversalDays(m,3)+1:a.reversalDays(m,4);
%         
%         choiceDays = a.choiceDays(:,:,m);
%         a.allChoiceDays{m,:} = [choiceDays{:}];
%         
%         days = a.allChoiceDays{m,:};
%         days=days(~isnan(days));
%         a.choiceDayPref{m,:} = [a.daySummary.percentInfo{mm,days}];
%         a.choiceDayEarlyPref{m,:} = [a.daySummary.percentInfoEarly{mm,days}];
%         a.choiceDayLatePref{m,:} = [a.daySummary.percentInfoLate{mm,days}];
%         a.choiceDayInfoSmallNP{m,:} = [a.daySummary.infoSmallNP{mm,days}];
%         a.choiceDayleavingPercentIDX{m,:} = [a.daySummary.leavingPercentIDX{mm,days}];
%         a.choiceDayRewardRateInfo{m,:} = [a.daySummary.rewardRateInfo{mm,days}];
%         a.choiceDayRewardRateRand{m,:} = [a.daySummary.rewardRateInfo{mm,days}];
%         a.choiceDayRewardRateIdx{m,:} = [a.daySummary.rewardRateIdx{mm,days}];
%     end
% end
% 
% %% EARLY LICKS AND REACTION SPEED BY REVERSAL
% 
% % NEED TO FINISH
% 
% % use trials to count
% 
% %%
% % RELATIVE TO CURRENT INFO SIDE
% 
% % CHANGE THIS ACROSS ALL REVERSALS
% 
% if ~isempty(a.reverseMice)
%     for m=1:a.mouseCt  
%         ok1 = a.mice(:,m) == 1 & a.trialType == 2 & a.correct == 1 & a.reverse == 1;
%         corrIdx=find(a.correct);
%         ok1Idx = find(ok1);
%         [~,sort1idx] = sort(a.mouseDay(ok1==1));
%         ok1sorted = ok1Idx(sort1idx);    
%         okInfoPreRevIdx = find(ok1sorted,300,'last');
%         okInfoPreRev = ok1sorted(okInfoPreRevIdx);
%         okInfoPreRevCorr=find(ismember(corrIdx,okInfoPreRev));
%         ok2 = a.mice(:,m) == 1 & a.trialType == 3 & a.correct == 1 & a.reverse == 1;
%         ok2Idx = find(ok2);
%         [~,sort2idx] = sort(a.mouseDay(ok2==1));
%         ok2sorted = ok2Idx(sort2idx);     
%         okRandPreRevIdx = find(ok2sorted,300,'last');
%         okRandPreRev = ok2sorted(okRandPreRevIdx);
%         okRandPreRevCorr=find(ismember(corrIdx,okRandPreRev));
%         ok3 = a.mice(:,m) == 1 & a.trialType == 2 & a.correct == 1 & a.reverse == -1;
%         ok3Idx = find(ok3);
%         [~,sort3idx] = sort(a.mouseDay(ok3==1));
%         ok3sorted = ok3Idx(sort3idx);     
%         okInfoPostRevIdx = find(ok3sorted,300,'last');
%         okInfoPostRev = ok3sorted(okInfoPostRevIdx);
%         okInfoPostRevCorr=find(ismember(corrIdx,okInfoPostRev));
%         ok4 = a.mice(:,m) == 1 & a.trialType == 3 & a.correct == 1 & a.reverse == -1;
%         ok4Idx = find(ok4);
%         [~,sort4idx] = sort(a.mouseDay(ok4==1));
%         ok4sorted = ok4Idx(sort4idx); 
%         okRandPostRevIdx = find(ok4sorted,300,'last');
%         okRandPostRev = ok4sorted(okRandPostRevIdx);
%         okRandPostRevCorr=find(ismember(corrIdx,okRandPostRev));
%        % pre-reverse, INFO
%        a.preRevEarlyLicks(m,1) = mean(a.earlyInfoLicks(okInfoPreRevCorr),'omitnan');
%        a.preRevRxnSpeed(m,1) = mean(a.rxnSpeed(okInfoPreRev));
%        a.preRevRxn(m,1) = mean(a.rxn(okInfoPreRev));
%        % pre-reverse, NO INFO
%        a.preRevEarlyLicks(m,2) = mean(a.earlyRandLicks(okRandPreRevCorr));
%        a.preRevRxnSpeed(m,2) = mean(a.rxnSpeed(okRandPreRev));
%        a.preRevRxn(m,2) = mean(a.rxn(okRandPreRev));
%        % pre-reverse diff p-val
%        [~,a.preRevEarlyLicks(m,3)] = ttest2(a.earlyInfoLicks(okInfoPreRevCorr),a.earlyRandLicks(okRandPreRevCorr));
%        [~,a.preRevRxnSpeed(m,3)] = ttest2(a.rxnSpeed(okInfoPreRev),a.rxnSpeed(okRandPreRev));
%        % post-reverse, INFO
%        a.postRevEarlyLicks(m,1) = mean(a.earlyInfoLicks(okInfoPostRevCorr));
%        a.postRevRxnSpeed(m,1) = mean(a.rxnSpeed(okInfoPostRev));
%        a.postRevRxn(m,1) = mean(a.rxn(okInfoPostRev));
%        % post-reverse, NO INFO
%        a.postRevEarlyLicks(m,2) = mean(a.earlyRandLicks(okRandPostRevCorr));
%        a.postRevRxnSpeed(m,2) = mean(a.rxnSpeed(okRandPostRev));
%        a.postRevRxn(m,2) = mean(a.rxn(okRandPostRev));
%        % post-reverse diff p-val
%        [~,a.postRevEarlyLicks(m,3)] = ttest2(a.earlyInfoLicks(okInfoPostRevCorr),a.earlyRandLicks(okRandPostRevCorr));
%        [~,a.postRevRxnSpeed(m,3)] = ttest2(a.rxnSpeed(okInfoPostRev),a.rxnSpeed(okRandPostRev));   
%        % pre-reverse
%        a.earlyLickIdx(m,1) = (a.preRevEarlyLicks(m,1)-a.preRevEarlyLicks(m,2))/(a.preRevEarlyLicks(m,1)+a.preRevEarlyLicks(m,2));
%        a.rxnSpeedIdx(m,1) = (a.preRevRxnSpeed(m,1)-a.preRevRxnSpeed(m,2))/(a.preRevRxnSpeed(m,1)+a.preRevRxnSpeed(m,2));
%        % post-reverse
%        a.earlyLickIdx(m,2) = (a.postRevEarlyLicks(m,1)-a.postRevEarlyLicks(m,2))/(a.postRevEarlyLicks(m,1)+a.postRevEarlyLicks(m,2));
%        a.rxnSpeedIdx(m,2) = (a.postRevRxnSpeed(m,1)-a.postRevRxnSpeed(m,2))/(a.postRevRxnSpeed(m,1)+a.postRevRxnSpeed(m,2));
%        % info Pre and Post
%     end
% 
% end
% 
% 
% %% CHOICE, RXN SPEED, EARLY LICKS, AND REWARD RATE AROUND REVERSALS BY IIS
% 
% if ~isempty(a.reverseMice)
%     a.reversalPrefs = NaN(numel(a.reverseMice),4);
%     a.reversalPrefsCurr = NaN(numel(a.reverseMice),4);
%     a.reversalRxn = NaN(numel(a.reverseMice),4);
%     a.reversalLicks = NaN(numel(a.reverseMice),4);
%     a.reversalMultiPrefs = NaN(numel(a.reverseMice),8);
%     for m = 1:numel(a.reverseMice)
%         mm = a.reverseMice(m);
%         for n = 1:4
%             if ~isnan(a.reversalDays(m,n))
%                 day = a.reversalDays(m,n);
%             else
%                 if n>1 & a.mouseDayCt(mm)>a.reversalDays(m,n-1)
% %                     day = a.reversalDays(m,n-1)+3;
%                     day = a.mouseDayCt(mm);
%                 else
%                     day = 0;
%                 end
%             end
%             if ~isnan(a.reversalDays(m,n))
%                 a.reversalPrefs(m,n) = a.daySummary.percentIIS{mm,day};
%                 a.reversalPrefsCurr(m,n) = a.daySummary.percentInfo{mm,day};
%                 a.reversalPrefsEarly(m,n) = a.daySummary.percentInfoEarly{mm,day};
%                 a.reversalPrefsLate(m,n) = a.daySummary.percentInfoLate{mm,day};
%                 if n == 1
%                     for k = 1:4
% %                         if ~isempty(a.daySummary.percentIIS{mm,a.reversalDays(m,n)+k-1})
%                         if a.mouseDayCt(mm)>(day+k-1)
%                             a.reversalMultiPrefs(m,k) = a.daySummary.percentIIS{mm,a.reversalDays(m,n)+k-1};
%                             a.reversalMultiPrefsCurr(m,k) = a.daySummary.percentInfo{mm,a.reversalDays(m,n)+k-1};
%                         end
%                     end
%                 elseif n==2
%                     for k = 1:4
% %                         if ~isempty(a.daySummary.percentIIS{mm,a.reversalDays(m,n)+k-1})
%                         if a.mouseDayCt(mm)>(day+k-1)
%                             a.reversalMultiPrefs(m,k+4) = a.daySummary.percentIIS{mm,a.reversalDays(m,n)+k-1};
%                             a.reversalMultiPrefsCurr(m,k+4) = a.daySummary.percentInfo{mm,a.reversalDays(m,n)+k-1};
%                         end
%                     end
%                 end
%             else
%                 if n>1 & day>0
%                     a.reversalPrefs(m,n) = a.daySummary.percentIIS{mm,day};
%                     a.reversalPrefsCurr(m,n) = a.daySummary.percentInfo{mm,day};
%                     a.reversalPrefsEarly(m,n) = a.daySummary.percentInfoEarly{mm,day};
%                     a.reversalPrefsLate(m,n) = a.daySummary.percentInfoEarly{mm,day};
%                 end
%             end
%             if day > 0
%     %             if isnan(a.daySummary.rxnSpeedIdx{m,a.reversalDays(m,n)})
%     %                 a.reversalRxn(m,n) = a.daySummary.rxnSpeedIdx{m,a.reversalDays(m,n)-1};
%     %             else
%                     a.reversalRxn(m,n) = a.daySummary.rxnSpeedIdx{mm,day};
%                     a.reversalRxnInfo(m,n) = a.daySummary.rxnInfoForced{mm,day};
%                     a.reversalRxnRand(m,n) = a.daySummary.rxnRandForced{mm,day};
%                     a.reversalRxnInfoChoice(m,n) = a.daySummary.rxnInfoChoice{mm,day};
%                     a.reversalRxnRandChoice(m,n) = a.daySummary.rxnRandChoice{mm,day};                    
%     %             end
%     %             if isnan(a.daySummary.earlyLickIdx{m,a.reversalDays(m,n)})
%     %                 a.reversalLicks(m,n) = a.daySummary.earlyLickIdx{m,a.reversalDays(m,n)-1};
%     %             else
%                     a.reversalLicks(m,n) = a.daySummary.earlyLickIdx{mm,day};
%                     a.reversalInfoEarlyLicks(m,n) = a.daySummary.infoLicksEarly{mm,day};
%                     a.reversalRandEarlyLicks(m,n) = a.daySummary.randLicksEarly{mm,day};
%                     a.reversalInfoBigEarlyLicks(m,n) = a.daySummary.infoBigLicksEarly{mm,day};
%                     a.reversalInfoSmallEarlyLicks(m,n) = a.daySummary.infoSmallLicksEarly{mm,day};
%                     a.reversalRandCEarlyLicks(m,n) = a.daySummary.randCLicksEarly{mm,day};
%                     a.reversalRandDEarlyLicks(m,n) = a.daySummary.randDLicksEarly{mm,day};
%                     a.reversalInfoBigLicks(m,n) = a.daySummary.infoBigLicks{mm,day};
%                     a.reversalInfoSmallLicks(m,n) = a.daySummary.infoSmallLicks{mm,day};
%                     a.reversalRandCLicks(m,n) = a.daySummary.randCLicks{mm,day};
%                     a.reversalRandDLicks(m,n) = a.daySummary.randDLicks{mm,day};
%     %             end
%     %             a.reversalRewardRateIdx(m,n) = (a.daySummary.rewardRateInfoForced{m,a.reversalDays(m,n)}-a.daySummary.rewardRateRandForced{m,a.reversalDays(m,n)})/(a.daySummary.rewardRateInfoForced{m,a.reversalDays(m,n)}+a.daySummary.rewardRateRandForced{m,a.reversalDays(m,n)});
%                   if n==2
%                     a.reversalRewardRateIdx(m,n) = (a.daySummary.rewardRateRandForced{mm,day}-a.daySummary.rewardRateInfoForced{mm,day});
%                     a.reversalRewardRateInfo(m,n) = a.daySummary.rewardRateRand{mm,day};
%                     a.reversalRewardRateRand(m,n) = a.daySummary.rewardRateInfo{mm,day};
%                   else
%                     a.reversalRewardRateIdx(m,n) = (a.daySummary.rewardRateInfoForced{mm,day}-a.daySummary.rewardRateRandForced{mm,day});   
%                     a.reversalRewardRateInfo(m,n) = a.daySummary.rewardRateInfo{mm,day};
%                     a.reversalRewardRateRand(m,n) = a.daySummary.rewardRateRand{mm,day};
%                   end
%             end
%         end
%     end
% end
% 
%     %%
% if ~isempty(a.reverseMice)    
% %     if  ~isnan(sum(a.reversalPrefs(:,2)))
%     
%     a.meanReversalMultiPrefs = nanmean(a.reversalMultiPrefs);
%     a.SEMReversalMultiPrefs = sem(a.reversalMultiPrefs);
%     
% %     a.meanReversalMultiPrefs = nanmean(a.reversalMultiPrefs(a.reversalMultiPrefs(:,1)>0.5,:));
% %     a.SEMReversalMultiPrefs = sem(a.reversalMultiPrefs(a.reversalMultiPrefs(:,1)>0.5,:));
% 
%     a.reversalPrefs_stats = a.reversalPrefs*100;
%     a.reversal1P = signrank(a.reversalPrefs_stats(:,1),a.reversalPrefs_stats(:,2));
%     if ~isnan(a.reversalPrefs(:,3))
%     a.reversal2P = signrank(a.reversalPrefs_stats(:,2),a.reversalPrefs_stats(:,3));
%     a.reversalP = signrank(a.reversalPrefs_stats(:,1),a.reversalPrefs_stats(:,3));
%     end
% 
%     a.reversalRxnP(1,1) = signrank(a.reversalRxn(:,1),a.reversalRxn(:,2));
%     if ~isnan(a.reversalPrefs(:,3))
%     a.reversalRxnP(1,2) = signrank(a.reversalRxn(:,2),a.reversalRxn(:,3));
%     a.reversalRxnP(1,3) = signrank(a.reversalRxn(:,1),a.reversalRxn(:,3));
%     end
% 
%     a.reversalLicksP(1,1) = signrank(a.reversalLicks(:,1),a.reversalLicks(:,2));
%     if ~isnan(a.reversalPrefs(:,3))
%     a.reversalLicksP(1,2) = signrank(a.reversalLicks(:,2),a.reversalLicks(:,3));
%     a.reversalLicksP(1,3) = signrank(a.reversalLicks(:,1),a.reversalLicks(:,3));
%     end
% 
%     a.reversalRewardRateP(1,1) = signrank(a.reversalRewardRateIdx(:,1),a.reversalRewardRateIdx(:,2));
%     if ~isnan(a.reversalPrefs(:,3))
%     a.reversalRewardRateP(1,2) = signrank(a.reversalRewardRateIdx(:,2),a.reversalRewardRateIdx(:,3));
%     a.reversalRewardRateP(1,3) = signrank(a.reversalRewardRateIdx(:,1),a.reversalRewardRateIdx(:,3));
%     end
% 
%     if ~isnan(a.reversalPrefs(:,3))
%     for p =1:3
%         a.reversalPVals(1,p) = signrank(a.reversalPrefs_stats(:,p)-50);
%         a.reversalRxnPVals(1,p) = signrank(a.reversalRxn(:,p));
% %         a.reversalLicksPVals(1,p) = signrank(a.reversalLicks(:,p));
%         a.reversalRewardRatePVals(1,p) = signrank(a.reversalRewardRateIdx(:,p));
%     end
%     end
%     a.reversalRxnInfoRandP(1,1) = signrank(a.reversalRxnInfo(:,1),a.reversalRxnRand(:,1));
%     a.reversalRewardRateInfoRandP(1,1) = signrank(a.reversalRewardRateInfo(:,1),a.reversalRewardRateRand(:,1));
% %     end
% end
% 
% %% LAST N TRIALS BEFORE AND AFTER FIRST REVERSE
% 
% trialsToCount = 100;
% 
% if ~isempty(a.reverseMice)
%     for m=1:a.mouseCt  
%         ok1 = a.mice(:,m) == 1 & a.trialType == 2 & a.reverse == 1;
%         ok1Idx = find(ok1);
%         [~,sort1idx] = sort(a.mouseDay(ok1==1));
%         ok1sorted = ok1Idx(sort1idx);    
%         okInfoPreRevIdx = find(ok1sorted,trialsToCount,'last');
%         okInfoPreRev = ok1sorted(okInfoPreRevIdx);
%         ok2 = a.mice(:,m) == 1 & a.trialType == 2 & a.reverse == -1;
%         ok2Idx = find(ok2);
%         [~,sort2idx] = sort(a.mouseDay(ok2==1));
%         ok2sorted = ok2Idx(sort2idx);    
%         okInfoPostRevIdx = find(ok2sorted,trialsToCount,'last');
%         okInfoPostRev = ok2sorted(okInfoPostRevIdx);        
%         okInfo=sort([okInfoPreRev; okInfoPostRev]);
%         
%         ok3 = a.mice(:,m) == 1 & a.trialType == 3 & a.reverse == 1;
%         ok3Idx = find(ok3);
%         [~,sort3idx] = sort(a.mouseDay(ok3==1));
%         ok3sorted = ok3Idx(sort3idx);    
%         okRandPreRevIdx = find(ok3sorted,trialsToCount,'last');
%         okRandPreRev = ok3sorted(okRandPreRevIdx);
%         ok4 = a.mice(:,m) == 1 & a.trialType == 3 & a.reverse == -1;
%         ok4Idx = find(ok4);
%         [~,sort4idx] = sort(a.mouseDay(ok4==1));
%         ok4sorted = ok4Idx(sort4idx);    
%         okRandPostRevIdx = find(ok4sorted,trialsToCount,'last');
%         okRandPostRev = ok4sorted(okRandPostRevIdx);        
%         okRand=sort([okRandPreRev; okRandPostRev]);
%         
%         okInfoCorr=a.correct(okInfo);
%         okRandCorr=a.correct(okRand);
%         
%         a.percentCorrRev(m,1) = mean(a.correct(okInfo));
%         a.percentCorrRev(m,2) = mean(a.correct(okRand));
%         a.rewardRateRevCorr(m,1) = sum(a.reward(okInfo(okInfoCorr)),'omitnan') / (sum(a.trialLengthCenterEntry(okInfo(okInfoCorr)),'omitnan')/60);
%         a.rewardRateRevCorr(m,2) = sum(a.reward(okRand(okRandCorr)),'omitnan') / (sum(a.trialLengthCenterEntry(okInfo(okInfoCorr)),'omitnan')/60);
%         a.rewardRateRev(m,1) = sum(a.reward(okInfo),'omitnan') / (sum(a.trialLengthCenterEntry(okInfo),'omitnan')/60);
%         a.rewardRateRev(m,2) = sum(a.reward(okRand),'omitnan') / (sum(a.trialLengthCenterEntry(okInfo),'omitnan')/60);  
%         a.rxnRev(m,1) = mean(a.rxn(okInfo),'omitnan');
%         a.rxnRev(m,2) = mean(a.rxn(okRand),'omitnan');
%         
%     end
% end
% 
% %% ERRORS AND REWARD RATE DURING TRAINING
% 
% earlyTrain = a.trialTypes==4 & a.rewardDelay==10 & a.odorTime==0;
% 
% for m=1:a.mouseCt
%     ok = a.mice(:,m) == 1;
%    a.percentCorrTrain(m,1) = mean(a.correct(ok & a.training & a.trialType==2)); 
%    a.percentCorrTrain(m,2) = mean(a.correct(ok & a.training & a.trialType==3));
%    a.trainingErrorsInfo(m,1) = sum(ok & a.training & a.trialType==2 & (a.errorTypes==1|a.errorTypes==4))/sum(ok & a.training & a.trialType==2);
%    a.trainingErrorsInfo(m,2) = sum(ok & a.training & a.trialType==2 & a.errorTypes==2)/sum(ok & a.training & a.trialType==2);
%    a.trainingErrorsInfo(m,3) = sum(ok & a.training & a.trialType==2 & a.errorTypes==3)/sum(ok & a.training & a.trialType==2);
%    a.trainingErrorsRand(m,1) = sum(ok & a.training & a.trialType==3 & (a.errorTypes==1|a.errorTypes==4))/sum(ok & a.training & a.trialType==3);
%    a.trainingErrorsRand(m,2) = sum(ok & a.training & a.trialType==3 & a.errorTypes==2)/sum(ok & a.training & a.trialType==3);
%    a.trainingErrorsRand(m,3) = sum(ok & a.training & a.trialType==3 & a.errorTypes==3)/sum(ok & a.training & a.trialType==3);
%    a.rewardRateTrain(m,1) = sum(a.reward(ok & a.training&a.trialType==2),'omitnan') / (sum(a.trialLengthCenterEntry(ok & a.training & a.trialType==2),'omitnan')/60);
%    a.rewardRateTrain(m,2) = sum(a.reward(ok & a.training&a.trialType==3),'omitnan') / (sum(a.trialLengthCenterEntry(ok & a.training & a.trialType==3),'omitnan')/60);    
%    a.rewardRateTrainCorr(m,1) = sum(a.reward(ok & a.training& a.trialType==2 & a.correct==1),'omitnan') / (sum(a.trialLengthCenterEntry(ok & a.training & a.trialType==2 & a.correct==1),'omitnan')/60);
%    a.rewardRateTrainCorr(m,2) = sum(a.reward(ok & a.training& a.trialType==3 & a.correct==1),'omitnan') / (sum(a.trialLengthCenterEntry(ok & a.training & a.trialType==3 & a.correct==1),'omitnan')/60);    
%    a.rewardRateTrainEarly(m,1) = sum(a.reward(ok & earlyTrain & a.trialType==2),'omitnan') / (sum(a.trialLengthCenterEntry(ok & earlyTrain  & a.trialType==2),'omitnan')/60);
%    a.rewardRateTrainEarly(m,2) = sum(a.reward(ok & earlyTrain & a.trialType==3),'omitnan') / (sum(a.trialLengthCenterEntry(ok & earlyTrain  & a.trialType==3),'omitnan')/60);    
% 
% end
% 
% %% INFO vs RAND STATS OVERALL (not by day)
% 
% % do these need to be for correct??
% % CHANGE BACK TO ONLY PREF DAYS!
% 
% for m=1:a.mouseCt
%     ok = a.mice(:,m)==1 & a.trialTypes == 5 & abs(a.reverse)== 1 & a.forcedCorrTrials == 1;
% %     ok = a.mice(:,m)==1 &  a.forcedCorrTrials == 1;
%     a.rxnMean(m,1) = nanmean(a.rxn(ok & a.info==1 & a.correct==1));
%     a.rxnMean(m,2) = nanmean(a.rxn(ok & a.info==0 & a.correct==1));
%     a.rxnDiff(m,1) = a.rxnMean(m,1) - a.rxnMean(m,2);
%     for i = 1:numel(a.reverseTypes)
%        r = a.reverseTypes(i);
%        a.rxnInfoRev(m,i) = nanmean(a.rxn(ok & a.reverse==r & a.info == 1 & a.correct==1));
%        a.rxnRandRev(m,i) = nanmean(a.rxn(ok & a.reverse==r & a.info == 0 & a.correct==1));
%     end
%     
%     okAll = a.mice(:,m)==1 & abs(a.reverse)==1;
% %     okAll = a.mice(:,m)==1 & a.reverse == 0;
%     a.rewardRate(m,1) = nansum(a.reward(a.info == 1 & okAll == 1)) / (nansum(a.trialLengthCenterEntry(a.info == 1 & okAll == 1))/60);
%     a.rewardRate(m,2) = nansum(a.reward(a.info == 0 & okAll == 1)) / (nansum(a.trialLengthCenterEntry(a.info == 0 & okAll == 1))/60);
%     a.rewardDiff(m,1) = a.rewardRate(m,1) - a.rewardRate(m,2);
%     a.rewardIdx(m,1) = a.rewardRate(m,1)/a.rewardRate(m,2);
%     
%     if ismember(m,a.reverseMice)
%         mm=find(a.reverseMice==m);
%         okPref = a.mice(:,m)==1 & abs(a.reverse)==1;
%         okPrefCorr = okPref & a.correct==1;
%         a.rewardRatePrefDays(mm,1) = nansum(a.reward(a.info == 1 & okPref == 1)) / (nansum(a.trialLengthCenterEntry(a.info == 1 & okPref == 1))/60);
%         a.rewardRatePrefDays(mm,2) = nansum(a.reward(a.info == 0 & okPref == 1)) / (nansum(a.trialLengthCenterEntry(a.info == 0 & okPref == 1))/60);
%         a.rewardDiffPrefDays(mm,1) = a.rewardRatePrefDays(mm,1) - a.rewardRatePrefDays(mm,2);
%         a.rewardIdxPrefDays(mm,1) = a.rewardRatePrefDays(mm,1) / a.rewardRatePrefDays(mm,2);
%         a.rewardIdxPrefDaysCorr(mm,1) = nansum(a.reward(a.info == 1 & okPrefCorr == 1)) / (nansum(a.trialLengthCenterEntry(a.info == 1 & okPrefCorr == 1))/60);
%         a.rewardIdxPrefDaysCorr(mm,2) = nansum(a.reward(a.info == 0 & okPrefCorr == 1)) / (nansum(a.trialLengthCenterEntry(a.info == 0 & okPrefCorr == 1))/60);
%         a.rewardIdxPrefDaysCorr(mm,3) = a.rewardIdxPrefDaysCorr(mm,1)/a.rewardIdxPrefDaysCorr(mm,2);
%     end
% 
% end


%% PREF BY TIME IN SESSION

%% SAVE
% save(fullfile(datapath,'infoSeekData_BPODBEHAVIOR_Stay_analyzed.mat'),'-struct','a','-v7.3');
save(fullfile(datapath,'infoSeekData_BPODBEHAVIOR_Df16current2_analyzed.mat'),'-struct','a','-v7.3');
% save(fullfile(datapath,'infoSeekData_JB214BEHAVIOR_Ports_analyzed.mat'),'-struct','a','-v7.3');
% save(fullfile(datapath,'infoSeekData_BpodSTAY_analyzed.mat'),'-struct','a','-v7.3');
% save(fullfile(datapath,'infoSeekData_BpodSTAY_analyzed.mat'),'-struct','a','-v7.3');