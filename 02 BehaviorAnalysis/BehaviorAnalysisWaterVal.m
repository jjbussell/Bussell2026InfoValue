clear; close all;

datapath=findInfoseekData();

a1=load('behaviorMiceBpodWaterVal2.mat');

a1.sessions2.name={a1.sessions(:).name}';
a1.sessions2.date={a1.sessions(:).date}';
a1.sessions2.mouse={a1.sessions(:).mouse}';

a1.sessions=a1.sessions2;


% DELETE SESSIONS2
a1=rmfield(a1,'sessions2');

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

a=a1;


save(fullfile(datapath,'infoSeekData_ALLBEHAVIOR_WaterVal2.mat'),'-struct','a','-v7.3');

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

a.choiceTypeNames = {'Info','Rand','Big','Small'};
a.choiceTypeCts = [sum(a.trialType == 2) sum(a.trialType == 3) sum(a.trialType == 4) sum(a.trialType == 1)];
a.infoForced = a.trialType == 2;
a.randForced = a.trialType == 3;
a.bigForced = a.trialType == 4;
a.smallForced = a.trialType == 1;

% ALL CORRECT TRIALS (INCLUDES NOT PRESENT BUT NOT NO CHOICE OR INCORRECT)

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

a.infoCorr = a.info == 1 & a.correct == 1;
a.randCorr = a.info == 0 & a.correct == 1;
a.bigCorr = a.big ==1 & a.correct ==1;
a.smallCorr = a.big == 0 & a.correct == 1;

a.infoCorrect = a.infoCorr(a.correct == 1);
a.randCorrect = a.randCorr(a.correct == 1);
a.bigCorrect = a.bigCorr(a.correct == 1);
a.smallCorrect = a.smallCorr(a.correct == 1);
a.randBigCorrect = a.randBig(a.correct == 1);
a.randSmallCorrect = a.randSmall(a.correct == 1);
a.infoBigCorrect = a.infoBig(a.correct == 1);
a.infoSmallCorrect = a.infoSmall(a.correct == 1);

a.rewardCorr=a.reward(a.correct==1); %these are the same!

 
%% NOT PRESENT
% 
a.infoBigNP = a.outcome==7;
a.infoSmallNP = a.outcome==9;
a.randBigNP =  a.outcome==13;
a.randSmallNP = a.outcome==15;
a.bigNP = a.outcome==19;
a.smallNP = a.outcome==3;
a.notPresent = [sum(a.infoBigNP)/sum(a.infoBig) sum(a.infoSmallNP)/sum(a.infoSmall) sum(a.randBigNP)/sum(a.randBig) sum(a.randSmallNP)/sum(a.randSmall) sum(a.bigNP)/sum(a.bigWater) sum(a.smallNP)/sum(a.smallWater)];

%% REACTION SPEED
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
                if ~isempty(paramChange) & paramChange>reversesIdx(1) %#ok<AND2>
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
% want: before and after first reversal 3 days to show pref and for "only pre-reverse analysis"
a.reverseAround=NaN(numel(a.reverseMice),6);
if ~isempty(a.reverseMice)
    for m=1:numel(a.reverseMice)
        mm=a.reverseMice(m);
        dd=a.reverseDay{mm,1};
        a.reverseAround(m,:) = (dd-3:dd+2);
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
        
        % DAY SUMMARY
        a.daySummary.mouse{m,d} = m;
        a.daySummary.day{m,d} = d;
        a.daySummary.outcome{m,d} = a.outcome(okAll == 1);
        a.daySummary.info{m,d} = sum(a.infoCorr(ok));
        a.daySummary.rand{m,d} = sum(a.randCorr(ok));
        a.daySummary.big{m,d} = sum(a.bigCorr(ok));
        a.daySummary.small{m,d} = sum(a.smallCorr(ok));
        a.daySummary.infoBig{m,d} = sum(a.infoBig(ok));
        a.daySummary.infoSmall{m,d} = sum(a.infoSmall(ok));
        a.daySummary.randBig{m,d} = sum(a.randBig(ok));
        a.daySummary.randSmall{m,d} = sum(a.randSmall(ok));
        
        a.daySummary.trialCt{m,d} = sum(okAll);
        a.daySummary.totalCorrectTrials{m,d} = sum(a.correct(okAll));
        a.daySummary.totalWater{m,d} = sum(a.reward(okAll));
                
        a.daySummary.rxnInfo{m,d} = mean(a.rxn(a.infoCorr & ok),'omitnan');
        a.daySummary.rxnRand{m,d} = mean(a.rxn(a.randCorr & ok),'omitnan');
        a.daySummary.rxnBig{m,d} = mean(a.rxn(a.bigCorr & ok),'omitnan');
        a.daySummary.rxnSmall{m,d} = mean(a.rxn(a.smallCorr & ok),'omitnan');
        
        a.daySummary.trialLengthInfo{m,d} = sum(a.trialLength(a.infoCorrect == 1 & okCorr == 1),'omitnan')/sum(~isnan(a.trialLength(a.infoCorrect == 1 & okCorr == 1)));
        a.daySummary.trialLengthRand{m,d} = sum(a.trialLength(a.randCorrect == 1 & okCorr == 1),'omitnan')/sum(~isnan(a.trialLength(a.randCorrect == 1 & okCorr == 1)));
        a.daySummary.trialLengthBig{m,d} = sum(a.trialLength(a.bigCorrect == 1 & okCorr == 1),'omitnan')/sum(~isnan(a.trialLength(a.bigCorrect == 1 & okCorr == 1)));
        a.daySummary.trialLengthSmall{m,d} = sum(a.trialLength(a.smallCorrect == 1 & okCorr == 1),'omitnan')/sum(~isnan(a.trialLength(a.smallCorrect == 1 & okCorr == 1)));        
        
        a.daySummary.maxDelay{m,d} = max(a.odorDelay(ok))+max(a.rewardDelay(ok));
               
        a.daySummary.ARewards{m,d} = sum(a.rewardCorr(a.odorAtrials==1 & okCorr==1),'omitnan')/sum(a.odorAtrials & okCorr,'omitnan');
        a.daySummary.BRewards{m,d} = sum(a.rewardCorr(a.odorBtrials==1 & okCorr==1),'omitnan')/sum(a.odorBtrials & okCorr,'omitnan');
        a.daySummary.CRewards{m,d} = sum(a.rewardCorr(a.odorCtrials==1 & okCorr==1),'omitnan')/sum(a.odorCtrials & okCorr,'omitnan');
        a.daySummary.DRewards{m,d} = sum(a.rewardCorr(a.odorDtrials==1 & okCorr==1),'omitnan')/sum(a.odorDtrials & okCorr,'omitnan');
        a.daySummary.randBigRewards{m,d} = sum(a.rewardCorr(a.randBigCorrect==1 & okCorr==1),'omitnan')/sum(a.randBigCorrect & okCorr,'omitnan');
        a.daySummary.randSmallRewards{m,d} = sum(a.rewardCorr(a.randSmallCorrect==1 & okCorr==1),'omitnan')/sum(a.randSmallCorrect & okCorr,'omitnan');
        a.daySummary.bigRewards{m,d} = sum(a.rewardCorr(okCorr==1 & a.bigCorrect==1),'omitnan')/sum(a.bigCorrect & okCorr,'omitnan');
        a.daySummary.smallRewards{m,d} = sum(a.rewardCorr(okCorr==1 & a.smallCorrect==1),'omitnan')/sum(a.smallCorrect & okCorr,'omitnan');
        
        a.daySummary.rewardRateInfo{m,d} = sum(a.reward(a.trialType==2 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.trialType==2 & okAll == 1),'omitnan')/60);
        a.daySummary.rewardRateRand{m,d} = sum(a.reward(a.trialType==3 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.trialType==3 & okAll == 1),'omitnan')/60);
        a.daySummary.rewardRateBig{m,d} = sum(a.reward(a.trialType == 4 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.trialType == 4 & okAll == 1),'omitnan')/60);
        a.daySummary.rewardRateSmall{m,d} = sum(a.reward(a.trialType == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.trialType == 1 & okAll == 1),'omitnan')/60);
        
        a.daySummary.rewardRateInfoCorr{m,d} = sum(a.rewardCorr(a.infoCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.infoCorrect == 1 & okCorr == 1),'omitnan')/60);
        a.daySummary.rewardRateRandCorr{m,d} = sum(a.rewardCorr(a.randCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.randCorrect == 1 & okCorr == 1),'omitnan')/60);
        a.daySummary.rewardRateBigCorr{m,d} = sum(a.rewardCorr(a.bigCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.bigCorrect == 1 & okCorr == 1),'omitnan')/60);
        a.daySummary.rewardRateSmallCorr{m,d} = sum(a.rewardCorr(a.smallCorrect == 0 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.smallCorrect == 0 & okCorr == 1),'omitnan')/60);     
        
    end
end

%% BEHAVIOR MEASURES

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bydays=0;

%% DAYS BEFORE FIRST REVERSAL (PRE-REVERSE) - mean of last threes

for m=1:numel(a.mouseList)
    if ismember(m,a.reverseMice)
    days = a.reverseAround(m,1:3);

    
    if bydays==1

        a.preRevRxnInfo(m,:)=cell2mat(a.daySummary.rxnInfo(m,days));
        a.preRevRxnRand(m,:)=cell2mat(a.daySummary.rxnRand(m,days));
        a.preRevRxnBig(m,:)=cell2mat(a.daySummary.rxnBig(m,days));
        a.preRevRxnSmall(m,:)=cell2mat(a.daySummary.rxnSmall(m,days));
        a.preRevRxnMean(m,1) = mean(a.preRevRxnInfo(m,:),'omitnan');
        a.preRevRxnMean(m,2) = mean(a.preRevRxnRand(m,:),'omitnan');
        a.preRevRxnMean(m,3) = mean(a.preRevRxnBig(m,:),'omitnan');
        a.preRevRxnMean(m,4) = mean(a.preRevRxnSmall(m,:),'omitnan');

        a.preRevCorrectInfo(m,:)=cell2mat(a.daySummary.info(m,days));
        a.preRevCorrectRand(m,:)=cell2mat(a.daySummary.rand(m,days));
        
        a.preRevCorrectMean(m,1)=mean(a.preRevCorrectInfo(m,:),'omitnan');
        a.preRevCorrectMean(m,2)=mean(a.preRevCorrectRand(m,:),'omitnan');

        a.preRevRewardRateInfo(m,:)=cell2mat(a.daySummary.rewardRateInfo(m,days));
        a.preRevRewardRateRand(m,:)=cell2mat(a.daySummary.rewardRateRand(m,days));
        a.preRevRewardRateBig(m,:)=cell2mat(a.daySummary.rewardRateBig(m,days));
        a.preRevRewardRateSmall(m,:)=cell2mat(a.daySummary.rewardRateSmall(m,days));
        a.preRevRewardRateMean(m,1)=mean(a.preRevRewardRateInfo(m,:),'omitnan');
        a.preRevRewardRateMean(m,2)=mean(a.preRevRewardRateRand(m,:),'omitnan');
        a.preRevRewardRateMean(m,3)=mean(a.preRevRewardRateBig(m,:),'omitnan');
        a.preRevRewardRateMean(m,4)=mean(a.preRevRewardRateSmall(m,:),'omitnan');

        a.preRevRewardRateCorrInfo(m,:)=cell2mat(a.daySummary.rewardRateInfoCorr(m,days));
        a.preRevRewardRateCorrRand(m,:)=cell2mat(a.daySummary.rewardRateRandCorr(m,days));
        a.preRevRewardRateCorrBig(m,:)=cell2mat(a.daySummary.rewardRateBigCorr(m,days));
        a.preRevRewardRateCorrSmall(m,:)=cell2mat(a.daySummary.rewardRateSmallCorr(m,days));
        
        a.preRevRewardRateCorrMean(m,1)=mean(a.preRevRewardRateCorrInfo(m,:),'omitnan');
        a.preRevRewardRateCorrMean(m,2)=mean(a.preRevRewardRateCorrRand(m,:),'omitnan');
        a.preRevRewardRateCorrMean(m,3)=mean(a.preRevRewardRateCorrBig(m,:),'omitnan');
        a.preRevRewardRateCorrMean(m,4)=mean(a.preRevRewardRateCorrSmall(m,:),'omitnan');
    
    else
        
        ok = a.mouseNums==m & ismember(a.mouseDay,days) & a.correct==1;
        okAll = ismember(a.mouseDay,days) & a.mice(:,m) == 1;
        okCorr = ismember(a.mouseDayCorr,days) & a.miceCorr(:,m) == 1;
        
        [a.preRevCorrectMean(m,1),a.preRevCorrectCI(m,[1 2])] = binofit(sum(a.correct(okAll & a.trialType == 2)),sum(okAll & a.trialType == 2));
        [a.preRevCorrectMean(m,2),a.preRevCorrectCI(m,[3 4])] = binofit(sum(a.correct(okAll & a.trialType == 3)),sum(okAll & a.trialType == 3));
        [a.preRevCorrectMean(m,3),a.preRevCorrectCI(m,[5 6])] = binofit(sum(a.correct(okAll & a.trialType == 1)),sum(okAll & a.trialType == 1));
        [a.preRevCorrectMean(m,4),a.preRevCorrectCI(m,[7 8])] = binofit(sum(a.correct(okAll & a.trialType == 4)),sum(okAll & a.trialType == 4));
        
        a.preRevRxnMean(m,1) = mean(a.rxn(a.infoCorr & ok),'omitnan');
        a.preRevRxnMean(m,2) = mean(a.rxn(a.randCorr & ok),'omitnan');
        a.preRevRxnMean(m,3) = mean(a.rxn(a.bigCorr & ok),'omitnan');
        a.preRevRxnMean(m,4) = mean(a.rxn(a.smallCorr & ok),'omitnan');
        a.preRevRxn{m,1}=a.rxn(a.infoCorr & ok);
        a.preRevRxn{m,2}=a.rxn(a.randCorr & ok);
        a.preRevRxn{m,3}=a.rxn(a.bigCorr & ok);
        a.preRevRxn{m,4}=a.rxn(a.smallCorr & ok);
        
        a.preRevRewardRateMean(m,1)=sum(a.reward(a.infoCorr == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.infoCorr == 1 & okAll == 1),'omitnan')/60);
        a.preRevRewardRateMean(m,2)=sum(a.reward(a.randCorr == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.randCorr == 1 & okAll == 1),'omitnan')/60);
        a.preRevRewardRateMean(m,3)=sum(a.reward(a.bigCorr == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.bigCorr == 1 & okAll == 1),'omitnan')/60);
        a.preRevRewardRateMean(m,4)=sum(a.reward(a.smallCorr == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.smallCorr == 1 & okAll == 1),'omitnan')/60);

        a.preRevRewardRateCorrMean(m,1)=sum(a.rewardCorr(a.infoCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.infoCorrect == 1 & okCorr == 1),'omitnan')/60);
        a.preRevRewardRateCorrMean(m,2)=sum(a.rewardCorr(a.randCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.randCorrect == 1 & okCorr == 1),'omitnan')/60);
        a.preRevRewardRateCorrMean(m,3)=sum(a.rewardCorr(a.bigCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.bigCorrect == 1 & okCorr == 1),'omitnan')/60); 
        a.preRevRewardRateCorrMean(m,4)=sum(a.rewardCorr(a.smallCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.smallCorrect == 1 & okCorr == 1),'omitnan')/60); 
    
    end
    end
end

for i=1:4
    a.preRevRxnAll{1,i}=vertcat(a.preRevRxn{:,i});
end

% can't use friedman for this since NaN for choice rand-->
% multiple signrank's
% [a.preRevRxnpval, tbl, stats] = friedman(a.preRevRxnMean, 1,'off');
% a.preRevRxnComp = multcompare(stats,'Display','off');


%% PRE-REVERSAL PORT DWELL

a.infoPort = NaN(size(a.Port2));
a.randPort = NaN(size(a.Port2));
infoLeft = a.infoSide == 0;
infoRight = a.infoSide == 1;

a.infoPort(infoLeft,:) = a.Port1(infoLeft,:);
a.infoPort(infoRight,:) = a.Port3(infoRight,:);
a.randPort(infoLeft,:) = a.Port3(infoLeft,:);
a.randPort(infoRight,:) = a.Port1(infoRight,:);

a.bigPort = NaN(size(a.Port2));
a.smallPort = NaN(size(a.Port2));
bigLeft = a.bigSide==0;
bigRight = a.bigSide==1;
a.bigPort(bigLeft,:) = a.Port1(bigLeft,:);
a.bigPort(bigRight,:) = a.Port1(bigRight,:);
a.smallPort(bigLeft,:) = a.Port3(bigLeft,:);
a.smallPort(bigRight,:) = a.Port1(bigRight,:);

for m=1:a.mouseCt
    days = a.reverseAround(m,1:3);

    ok=a.reverse==1 & a.trialTypes == 5 & a.correct==1 & a.mouseNums==m & ismember(a.mouseDay,days);
    a.infoDwell(m,1)= mean(mean(a.infoPort(a.infoCorr & ok,54:250),2));
    a.randDwell(m,1) = mean(mean(a.randPort(a.randCorr & ok,54:250),2));
    a.bigDwell(m,1) = mean(mean(a.bigPort(a.bigCorr & ok,54:250),2));
    a.smallDwell(m,1) = mean(mean(a.smallPort(a.smallCorr & ok,54:250),2));
    a.infoDwell1sec(m,1)= mean(mean(a.infoPort(a.infoCorr & ok,54:74),2));
    a.randDwell1sec(m,1)=mean(mean(a.randPort(a.randCorr & ok,54:74),2));
    a.bigDwell1sec(m,1)=mean(mean(a.bigPort(a.bigCorr & ok,54:74),2));
    a.smallDwell1sec(m,1)=mean(mean(a.smallPort(a.smallCorr & ok,54:74),2));

    a.centerDwellInfo(m,:) = mean(a.Port2(a.trialType==2 & ok,:));
    a.centerDwellRand(m,:) = mean(a.Port2(a.trialType==3 & ok,:));
    a.centerDwellBig(m,:) = mean(a.Port2(a.trialType==4 & ok,:));
    a.centerDwellSmall(m,:) = mean(a.Port2(a.trialType==1 & ok,:));

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
    
    a.bigDwellTime(m,:) = mean(a.bigPort(a.bigCorr==1 & ok,:));
    a.smallDwellTime(m,:) = mean(a.smallPort(a.smallCorr==1 & ok,:));
end


%% DAYS BEFORE AND AFTER FIRST REVERSAL

for m=1:numel(a.mouseList)
    days = a.reversalDays(m,:);
    
    if bydays==1
        
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
    
    else
        
        for dd=1:2
            daylist={[1,2],[3,4]};
            d=daylist{dd};
            ok = a.mouseNums==m & ismember(a.mouseDay,days(d)) & a.correct==1;
            okAll = ismember(a.mouseDay,days(d)) & a.mice(:,m) == 1;
            okCorr = ismember(a.mouseDayCorr,days(d)) & a.miceCorr(:,m) == 1;        

            a.reversalRxnInfo(m,dd)=mean(a.rxn(a.infoCorr & ok),'omitnan');
            a.reversalRxnRand(m,dd)=mean(a.rxn(a.randCorr & ok),'omitnan');
            a.reversalRxnBig(m,dd)=mean(a.rxn(a.bigCorr & ok),'omitnan');
            a.reversalRxnSmall(m,dd)=mean(a.rxn(a.smallCorr & ok),'omitnan');
            a.reversalRxnMean(m,1) = mean(a.reversalRxnInfo(m,:),'omitnan');
            a.reversalRxnMean(m,2) = mean(a.reversalRxnRand(m,:),'omitnan');
            a.reversalRxnMean(m,3) = mean(a.reversalRxnBig(m,:),'omitnan');
            a.reversalRxnMean(m,4) = mean(a.reversalRxnSmall(m,:),'omitnan');

            a.reversalCorrectInfo(m,dd)=binofit(sum(a.correct(okAll & a.trialType == 2)),sum(okAll & a.trialType == 2));
            a.reversalCorrectRand(m,dd)=binofit(sum(a.correct(okAll & a.trialType == 3)),sum(okAll & a.trialType == 3));
            a.reversalCorrectBig(m,dd)=binofit(sum(a.correct(okAll & a.trialType == 4)),sum(okAll & a.trialType == 4));
            a.reversalCorrectSmall(m,dd)=binofit(sum(a.correct(okAll & a.trialType == 1)),sum(okAll & a.trialType == 1));
            a.reversalCorrectMean(m,1)=mean(a.reversalCorrectInfo(m,:),'omitnan');
            a.reversalCorrectMean(m,2)=mean(a.reversalCorrectRand(m,:),'omitnan');
            a.reversalCorrectMean(m,3)=mean(a.reversalCorrectBig(m,:),'omitnan');
            a.reversalCorrectMean(m,4)=mean(a.reversalCorrectSmall(m,:),'omitnan');

            a.reversalRewardRateInfo(m,dd)=sum(a.reward(a.infoCorr == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.infoCorr == 1 & okAll == 1),'omitnan')/60);
            a.reversalRewardRateRand(m,dd)=sum(a.reward(a.randCorr == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.randCorr == 1 & okAll == 1),'omitnan')/60);
            a.reversalRewardRateBig(m,dd)=sum(a.reward(a.bigCorr == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.bigCorr == 1 & okAll == 1),'omitnan')/60);
            a.reversalRewardRateSmall(m,dd)=sum(a.reward(a.smallCorr == 1 & okAll == 1),'omitnan') / (sum(a.trialLengthCenterEntry(a.smallCorr == 1 & okAll == 1),'omitnan')/60);
            a.reversalRewardRateMean(m,1)=mean(a.reversalRewardRateInfo(m,:),'omitnan');
            a.reversalRewardRateMean(m,2)=mean(a.reversalRewardRateRand(m,:),'omitnan');
            a.reversalRewardRateMean(m,3)=mean(a.reversalRewardRateBig(m,:),'omitnan');
            a.reversalRewardRateMean(m,4)=mean(a.reversalRewardRateSmall(m,:),'omitnan');

            a.reversalRewardRateCorrInfo(m,dd)=sum(a.rewardCorr(a.infoCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.infoCorrect == 1 & okCorr == 1),'omitnan')/60);
            a.reversalRewardRateCorrRand(m,dd)=sum(a.rewardCorr(a.randCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.randCorrect == 1 & okCorr == 1),'omitnan')/60);
            a.reversalRewardRateCorrBig(m,dd)=sum(a.rewardCorr(a.bigCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.bigCorrect == 1 & okCorr == 1),'omitnan')/60);
            a.reversalRewardRateCorrSmall(m,dd)=sum(a.rewardCorr(a.smallCorrect == 1 & okCorr == 1),'omitnan') / (sum(a.trialLength(a.smallCorrect == 1 & okCorr == 1),'omitnan')/60);
            a.reversalRewardRateCorrMean(m,1)=mean(a.reversalRewardRateCorrInfo(m,:),'omitnan');
            a.reversalRewardRateCorrMean(m,2)=mean(a.reversalRewardRateCorrRand(m,:),'omitnan');
            a.reversalRewardRateCorrMean(m,3)=mean(a.reversalRewardRateCorrBig(m,:),'omitnan');
            a.reversalRewardRateCorrMean(m,4)=mean(a.reversalRewardRateCorrSmall(m,:),'omitnan');

        end
    end
end

a.reversalRxn=[a.reversalRxnInfo(:,1) a.reversalRxnRand(:,1) a.reversalRxnBig(:,1) a.reversalRxnSmall(:,1) a.reversalRxnInfo(:,2) a.reversalRxnRand(:,2) a.reversalRxnBig(:,2) a.reversalRxnSmall(:,2)];
a.reversalCorrect=[a.reversalCorrectInfo(:,1) a.reversalCorrectRand(:,1) a.reversalCorrectBig(:,1) a.reversalCorrectSmall(:,1) a.reversalCorrectInfo(:,2) a.reversalCorrectRand(:,2) a.reversalCorrectBig(:,2) a.reversalCorrectSmall(:,2) ];
a.reversalRewardRate=[a.reversalRewardRateInfo(:,1) a.reversalRewardRateRand(:,1) a.reversalRewardRateBig(:,1) a.reversalRewardRateSmall(:,1) a.reversalRewardRateInfo(:,2) a.reversalRewardRateRand(:,2) a.reversalRewardRateBig(:,2) a.reversalRewardRateSmall(:,2)];
a.reversalRewardRateCorr=[a.reversalRewardRateCorrInfo(:,1) a.reversalRewardRateCorrRand(:,1) a.reversalRewardRateCorrBig(:,1) a.reversalRewardRateCorrSmall(:,1) a.reversalRewardRateCorrInfo(:,2) a.reversalRewardRateCorrRand(:,2) a.reversalRewardRateCorrBig(:,2) a.reversalRewardRateCorrSmall(:,2)];


%% SAVE
save(fullfile(datapath,'infoSeekData_BPODBEHAVIOR_WaterVal_analyzed2.mat'),'-struct','a','-v7.3');
