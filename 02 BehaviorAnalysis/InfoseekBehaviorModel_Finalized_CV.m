%% Decision models for water and delay titration sessions with cross-validation


%% IMPORT BEHAVIOR DATA
close all;

% load behavior data into 'a' structure
a=load('infoSeekData_ALLBEHAVIOR_analyzed_Aug2023.mat');

% This script contains the full RLwater + λ-RLinfo model, then drops the
% terms one at a time to test the sub-component models of RLwater, λ-RLinfo
% and RLwater + RLinfo separately. We also include a win-stay lose-shift
% Softmax approximation as a different conceptual model.

set(0,'DefaultFigureWindowStyle','docked');

%% SELECT A MODEL TO TEST

model=5;
accuracy = [];
infoval = [];
results.model=model;

rng(112)

% PARAMETERS FOR WHICH TRIALS AND MICE TO USE
allTrials=2;
daysToUse=4; % used, 

display(['Running model ' num2str(model)]);

if allTrials==1
    display('Using all trials');
elseif allTrials == 0
    display('Only preference (choice) trials');
elseif allTrials==2
    display('Water Titration Trials');
elseif allTrials ==3
    display('Water AND Delay Titration Trials');
elseif allTrials == 4
    display('Delay Titration Trials');
end

%% FOR DELAY OR WATER TITRATION

% water titration use a.valueMice, a.valueDays, a.daysForVal
% delay titration use a.delayMice, a.delayDays, a.daysForDelay


% miceToUse= [1 2 3 4]; % of value mice (or delay mice)

a.valueMice = [6 7 8 9 20 23 24 25 26 31 32 33];
a.valueDays = {{{{32:33},{75:77}},{{57:59},{63:65}},{{43:50},{69:71}},{{29:31},{60:62}},{{34:42},{72:74}},{{51:56},{66:68}}},...
    {{{26:27},{65:67}},{{39:41},{53:55}},{{31:36},{59:61}},{{23:25},{42:52}},{{28:30},{62:64}},{{37:38},{56:58}}},...
    {{{35:37},{65:67}},{{47:49},{53:55}},{{41:43},{59:61}},{{29:34},{50:52}},{{38:40},{62:64}},{{44:46},{56:58}}},...
    {{{34:36},{64:66}},{{46:48},{52:54}},{{40:42},{58:60}},{{27:33},{49:51}},{{37:39},{61:63}},{{43:45},{55:57}}},...
    {{74:82},{95:105},{89:94},{69:73},{83:88}},...
    {{73:82},{89:94},{101:106},{67:72},{83:88}},...
    {{64:69},{76:87},{95:100},{58:63},{70:75},{89:94}},...
    {{81:92},{111:117},{99:104},{75:80},{93:98},{105:110}},...
    {{97:102},{110:118},{123:128},{90:96},{103:109},{119:122}},...
    {{42:48},{62:67},{53:58},{35:41},{59:62},{49:52}},...
    {{40:45},{59:64},{50:55},{34:39},{56:58},{46:49}},...
    {{40:45},{60:64},{50:56},{34:39},{57:59},{46:49}}};

for mm=1:numel(a.valueMice)
%     m=a.valueMice(mm);
    valueDays=[];
    for v=1:numel(a.valueDays{mm})
         days=[]; part1days=[]; allpartdays=[];
        if numel(a.valueDays{mm}{v})>1
            part1days=cell2mat(a.valueDays{mm}{v}{1});
            part2days=cell2mat(a.valueDays{mm}{v}{2});
            if numel(part1days)+numel(part2days)>daysToUse
                part1days=part1days(numel(part1days)-floor(daysToUse/2)+1:end)';
                part2days=part2days(numel(part2days)-floor(daysToUse/2)+1:end)';
            else
                part1days=part1days(1:min([numel(part1days) numel(part2days)]))';
                part2days=part2days(1:min([numel(part1days) numel(part2days)]))';
            end
            allpartdays=[part1days; part2days];
            days=[days;allpartdays];
        else
            days=cell2mat(a.valueDays{mm}{v})';
        end
        valueDays=[valueDays;days];
%         valueDays=[valueDays;cell2mat(a.valueDays{mm}{v})'];
    end
    a.daysForVal{mm}=valueDays;
end

a.delayMice = [28 29 30 31 32 33];
a.delayDays={{{48:53},{142:150},{151:156},{40:47}},...
    {{44:50},{144:152},{153:158},{38:46}},...
    {{76:81},{143:150},{151:156},{82:87}},...
    {{75:81},{87:92},{82:86},{68:74}},...
    {{72:78},{83:89},{79:82},{65:71}},...
    {{72:78},{84:89},{79:83},{65:71}}};
for mm=1:numel(a.delayMice)
    m=a.delayMice(mm);
    delayDays=[]; days=[];
    for v=1:numel(a.delayDays{mm})
        days=cell2mat(a.delayDays{mm}{v})';
        if length(days)>daysToUse
            delayDays=[delayDays;days(length(days)-daysToUse+1:end)];
        else
            delayDays=[delayDays;days];
        end
    end
    a.daysForDelay{mm}=delayDays;
end


if allTrials==2
    a.mouseVec=a.valueMice;
elseif allTrials==3
    a.mouseVec=unique([a.valueMice a.delayMice]);
elseif allTrials==4
    a.mouseVec=a.delayMice;
end

%% LOOP THROUGH SUBJECTS

% pull that subject's behavior data into relevant vectors (Choice, Info,
% Side, Reward)

a.mouseVec = [6 7 8 9 28 29 30 31 32 33];

miceToUse=1:length(a.mouseVec);
nRuns = 5;
for mm=1:numel(miceToUse)
    a.TestAccuracies = [];
    a.TrainAIC = [];
    a.TrainBIC = [];
    a.Accuracies = [];
    
    a.nInfoRew1 = [];
    a.nNoInfoRew1 = [];
    a.nInfoUnRew1 = [];
    a.nNoInfoUnRew1 = [];
    a.nInfoRew2 = [];
    a.nNoInfoRew2 = [];
    a.nInfoUnRew2 = [];
    a.nNoInfoUnRew2 = [];
    

    for nR=1:nRuns
        %m=a.valueMice(miceToUse(mm));
        m=a.mouseVec(miceToUse(mm));
        %display(['Fitting ' a.mouseList{m}]);
        display(['MOUSE NUMBER ' num2str(m)]);
    
        if m < 0 % || m < 30 % || m < 9
            continue
        end
        % first 4 mice don't have delay
        if m > 10
            allTrials = 3;
        end
        
        if allTrials==2
            i=find(a.valueMice==m);
            valDays=sort(a.daysForVal{i});
        elseif allTrials==3
            i=find(a.valueMice==m);
            j=find(a.delayMice==m);
            valDays=unique([a.daysForVal{i}; a.daysForDelay{j}]);
        elseif allTrials==4
            j=find(a.delayMice==m);
            valDays=sort(a.daysForDelay{j});
        end
        
        if allTrials ==1
        % To use all trials, not just initial preference, and include water and
        % delay titration:
            okTrials=a.mice(:,m)==1&~isnan(a.outcome)&a.trialTypes==5&a.trialType==1;
            ok2=a.mice(:,m)==1&~isnan(a.outcome)&a.trialTypes==5;
            results.trials='All';
        elseif allTrials == 0
            okTrials=a.mice(:,m)==1&~isnan(a.outcome)&(a.reverse==-1|a.reverse==1)&a.trialType==1&a.errorTypes~=2; % choice trials, preference trials for that mouse
            results.trials='Preference';
            ok2=a.mice(:,m)==1&~isnan(a.outcome)&(a.reverse==-1|a.reverse==1)&a.errorTypes~=2; % all preference trials for that mouse where choice was made
            okCorr=a.mice(:,m)==1&~isnan(a.outcome)&(a.reverse==-1|a.reverse==1)&a.trialType==1&a.correct==1; 
        elseif allTrials>=2
            okTrials=a.mice(:,m)==1&~isnan(a.outcome)&ismember(a.mouseDay,valDays)&a.trialType==1&a.errorTypes~=2; % choice trials, preference trials for that mouse
            results.trials='Preference';
            ok2=a.mice(:,m)==1&~isnan(a.outcome)&ismember(a.mouseDay,valDays)&a.errorTypes~=2; % all preference trials for that mouse where choice was made
            okCorr=a.mice(:,m)==1&~isnan(a.outcome)&ismember(a.mouseDay,valDays)&a.trialType==1&a.correct==1;         
        end
     
        % model fits only choice trials
        nTrials = sum(okTrials);
        Info = a.info(okTrials);
        
        Info(isnan(Info))=0.5;
        Side = NaN(nTrials,1);
        Side(a.infoSide(okTrials)==0&a.info(okTrials)==1)=1;
        Side(a.infoSide(okTrials)==0&a.info(okTrials)==0)=0;
        Side(a.infoSide(okTrials)==1&a.info(okTrials)==1)=0;
        Side(a.infoSide(okTrials)==1&a.info(okTrials)==0)=1;
        Side(isnan(Side))=0.5;
        Reward=a.reward(okTrials)/4/4;
    %     Reward(Reward>0)=1; % normalize water reward amount. Need to change by which model (above) and make as fraction of max
        Choice=Info;
        Delay = a.rewardDelay(okTrials);
        %print(Delay)
        % all trials, not just choice
        FullDelay=a.rewardDelay(ok2);
        FullReward=a.reward(ok2)/4/4;
        %FullReward(FullReward>0)=1;
        FullChoice=a.info(ok2);
        FullChoice(isnan(FullChoice))=0.5;
        FullTypes = a.trialType(ok2);
        Correct = a.correct(okTrials);
        
        Values=a.rewardParams(okTrials,1);
        
        negLL = 10000; % initialization negative log likelihood to minimize to be arbitrarily large, see below at line with " if funTest < fun"
        %%% Change to 2 starting point for side bias
        tvec = 1:1:nTrials; % trial vector for each subject, choice trials only chronologically
        tvecfull=1:1:numel(FullChoice); %all types of trials chronologically
        tveccorr = find(Correct==1);
    
        %cross validation setup   
        cvT = 10;
        maxIter = 1000;
        cvCount = 0;
        nInfoRew1 = 0;
        nNoInfoRew1 = 0;
        nInfoUnRew1 = 0;
        nNoInfoUnRew1 = 0;    
        nInfoRew2 = 0;
        nNoInfoRew2 = 0;
        nInfoUnRew2 = 0;
        nNoInfoUnRew2 = 0;
    
        while cvCount < maxIter && (nInfoRew1 < cvT || nNoInfoRew1 < cvT || nInfoUnRew1 < cvT || nNoInfoUnRew1 < cvT || nInfoRew2 < cvT || nNoInfoRew2 < cvT || nInfoUnRew2 < cvT || nNoInfoUnRew2 < cvT)
            a.train = [];
            a.test = [];
            cvRand = randperm(numel(Choice),floor(numel(Choice)/3));
            %'Size of Test / Train'
            %length(cvRand)
            %length(FullChoice)
            cvIdx = 0;    
            nInfoRew1 = 0;
            nNoInfoRew1 = 0;
            nInfoUnRew1 = 0;
            nNoInfoUnRew1 = 0;
        
            nInfoRew2 = 0;
            nNoInfoRew2 = 0;
            nInfoUnRew2 = 0;
            nNoInfoUnRew2 = 0;
        
            for x = 1:numel(Choice)
                cvIdx = cvIdx + 1;
                if ismember(x,cvRand) == 1
                    a.train(cvIdx) = 0; 
                    a.test(cvIdx) = 1; 
                    if Choice(x) == 1 && Reward(x) > 0
                        nInfoRew1 = nInfoRew1 + 1;
                    end
                    if Choice(x) == 0 && Reward(x) > 0
                        nNoInfoRew1 = nNoInfoRew1 + 1;
                    end
                    if Choice(x) == 1 && Reward(x) == 0
                        nInfoUnRew1 = nInfoUnRew1 + 1;
                    end
                    if Choice(x) == 0 && Reward(x) == 0
                        nNoInfoUnRew1 = nNoInfoUnRew1 + 1;
                    end
                else
                    a.train(cvIdx) = 1;
                    a.test(cvIdx) = 0; 
                    if Choice(x) == 1 && Reward(x) > 0
                        nInfoRew2 = nInfoRew2 + 1;
                    end
                    if Choice(x) == 0 && Reward(x) > 0
                        nNoInfoRew2 = nNoInfoRew2 + 1;
                    end
                    if Choice(x) == 1 && Reward(x) == 0
                        nInfoUnRew2 = nInfoUnRew2 + 1;
                    end
                    if Choice(x) == 0 && Reward(x) == 0
                        nNoInfoUnRew2 = nNoInfoUnRew2 + 1;
                    end
                end    
            end
            cvCount = cvCount + 1;
        end
        
        NoS = [nInfoRew1,nNoInfoRew1, nInfoUnRew1,nNoInfoUnRew1,nInfoRew2, nNoInfoRew2,nInfoUnRew2,nNoInfoUnRew2];
        IterToReachBalance = cvCount;
        % vectors for win-stay lose-shift-like model (WS-LS), tracks what happened on
        % t-1 trial
        ttt = 0;
        a.PastInfoRew = [];
        a.PastNoInfoRew = [];
        a.PastInfoUnRew = [];
        a.PastNoInfoUnRew = [];    
    
        for x = 1:numel(FullChoice)       
                    
            if FullTypes(x)==1
                ttt = ttt +1;
                if x == 1
                    a.PastInfoRew(ttt) = 0;
                    a.PastNoInfoRew(ttt) = 0;
                    a.PastInfoUnRew(ttt) = 0;
                    a.PastNoInfoUnRew(ttt) = 0;
                end
                if x > 1
    
                    a.PastInfoRew(ttt) = 0;
                    a.PastNoInfoRew(ttt) = 0;
                    a.PastInfoUnRew(ttt) = 0;
                    a.PastNoInfoUnRew(ttt) = 0;
    
                    if FullChoice(x-1) == 1 && FullReward(x-1) > 0
                        a.PastInfoRew(ttt) = 1;
    
                        %a.PastInfoRew(ttt) = 0;
                        a.PastNoInfoRew(ttt) = 0;
                        a.PastInfoUnRew(ttt) = 0;
                        a.PastNoInfoUnRew(ttt) = 0;
                    end
                    if FullChoice(x-1) == 0 && FullReward(x-1) > 0
                        a.PastNoInfoRew(ttt) = 1;
    
                        a.PastInfoRew(ttt) = 0;
                        %a.PastNoInfoRew(ttt) = 0;
                        a.PastInfoUnRew(ttt) = 0;
                        a.PastNoInfoUnRew(ttt) = 0;
                    end
                    if FullChoice(x-1) == 1 && FullReward(x-1) == 0
                        a.PastInfoUnRew(ttt) = 1;
    
                        a.PastInfoRew(ttt) = 0;
                        a.PastNoInfoRew(ttt) = 0;
                        %a.PastInfoUnRew(ttt) = 0;
                        a.PastNoInfoUnRew(ttt) = 0;
                    end
                    if FullChoice(x-1) == 0 && FullReward(x-1) == 0
                        a.PastNoInfoUnRew(ttt) = 1;
    
                        a.PastInfoRew(ttt) = 0;
                        a.PastNoInfoRew(ttt) = 0;
                        a.PastInfoUnRew(ttt) = 0;
                        %a.PastNoInfoUnRew(ttt) = 0;
                    end
                    if FullChoice(x-1) == 0.5 || FullReward(x-1) == 0.5
                        a.PastInfoRew(ttt) = 0;
                        a.PastNoInfoRew(ttt) = 0;
                        a.PastInfoUnRew(ttt) = 0;
                        a.PastNoInfoUnRew(ttt) = 0;
                    end
    
                end   
    
    
            end
        
        end
    
        % store WS-LS model vectors
        vPastInfoRew = a.PastInfoRew;
        vPastNoInfoRew = a.PastNoInfoRew;
        vPastInfoUnRew = a.PastInfoUnRew;
        vPastNoInfoUnRew = a.PastNoInfoUnRew;
        test = a.test;
        train = a.train;
    
        %% DEFINE FIT EQUATION
        switch model
            % change to
            % Cue (3 params)
            % Cue + side bias (4 params)
            % Cue + satiation
            % Cue + water value (3 params)
            % Cue + water value + info value
            % Cue + water value + info value + delay discounting
    
            %ValueFuncFull(a1,t,tfull,FullReward,FullChoice,FullTypes,InfoVal)
            %InfoValueFuncFull(a1,t,tfull,FullReward,FullChoice,FullTypes,InfoVal,FullDelay,Exponent)
            
            case 1 % RLwater only            
                RLfcn = @(b,t,tfull) 1. ./ (1 + exp( (-1.0/b(1)) .*(b(2).*transpose(ValueFuncFull(b(3),t,tfull,FullReward,FullChoice,FullTypes,1)) + b(4))));
                %errCalc = @(b) -1*sum( log(RLfcn(b,tvec,tvecfull)).*Choice(tvec) + log(1-RLfcn(b,tvec,tvecfull)).*(1-Choice(tvec))); % -LL equation    
                errCalc = @(b) -1*sum( train(tvec).*transpose( log(RLfcn(b,tvec,tvecfull)).*Choice(tvec) + log(1-RLfcn(b,tvec,tvecfull)).*(1-Choice(tvec)) ) ); % -LL equation
                nFreeParams = 4; 
    
            case 2 % λ-RLinfo model            
                RLfcn = @(b,t,tfull) 1. ./ (1 + exp( (-1.0/b(1)) .*(transpose(InfoValueFuncFull(b(2),t,tfull,FullReward,FullChoice,FullTypes,b(3),FullDelay,b(4))) +b(5))));
                %errCalc = @(b) -1*sum( log(RLfcn(b,tvec,tvecfull)).*Choice(tvec) + log(1-RLfcn(b,tvec,tvecfull)).*(1-Choice(tvec))); % -LL equation    
                errCalc = @(b) -1*sum( train(tvec).*transpose( log(RLfcn(b,tvec,tvecfull)).*Choice(tvec) + log(1-RLfcn(b,tvec,tvecfull)).*(1-Choice(tvec)) ) ); % -LL equation
                nFreeParams = 4; %b3, info val, is fixed to 1
            
            case 3 % RLwater + RLinfo without λ             
                %b(6) is fixed to 0 below
                RLfcn = @(b,t,tfull) 1. ./ (1 + exp( (-1.0/b(1)) .*(b(2).*transpose(ValueFuncFull(b(3),t,tfull,FullReward,FullChoice,FullTypes,1)) + transpose(InfoValueFuncFull(b(4),t,tfull,FullReward,FullChoice,FullTypes,b(5),FullDelay,b(6))) +b(7))));
                %errCalc = @(b) -1*sum( log(RLfcn(b,tvec,tvecfull)).*Choice(tvec) + log(1-RLfcn(b,tvec,tvecfull)).*(1-Choice(tvec))); % -LL equation    
                errCalc = @(b) -1*sum( train(tvec).*transpose( log(RLfcn(b,tvec,tvecfull)).*Choice(tvec) + log(1-RLfcn(b,tvec,tvecfull)).*(1-Choice(tvec)) ) );
                nFreeParams = 5; %b5, info val, is fixed to 1
    
            case 4 % RLwater + λ-RLinfo exponential     
                RLfcn = @(b,t,tfull) 1. ./ (1 + exp( (-1.0/b(1)) .*(b(2).*transpose(ValueFuncFull(b(3),t,tfull,FullReward,FullChoice,FullTypes,1)) + transpose(InfoValueFuncFull(b(4),t,tfull,FullReward,FullChoice,FullTypes,b(5),FullDelay,b(6),0)) +b(7))));
                errCalc = @(b) -1*sum( train(tvec).*transpose( log(RLfcn(b,tvec,tvecfull)).*Choice(tvec) + log(1-RLfcn(b,tvec,tvecfull)).*(1-Choice(tvec)) ) ); % -LL equation    
                nFreeParams = 6; %b5, info val, is fixed to 1

            case 5 % RLwater + λ-RLinfo hyberbolic        
                RLfcn = @(b,t,tfull) 1. ./ (1 + exp( (-1.0/b(1)) .*(b(2).*transpose(ValueFuncFull(b(3),t,tfull,FullReward,FullChoice,FullTypes,1)) + transpose(InfoValueFuncFull(b(4),t,tfull,FullReward,FullChoice,FullTypes,b(5),FullDelay,b(6),1)) +b(7))));
                errCalc = @(b) -1*sum( train(tvec).*transpose( log(RLfcn(b,tvec,tvecfull)).*Choice(tvec) + log(1-RLfcn(b,tvec,tvecfull)).*(1-Choice(tvec)) ) ); % -LL equation    
                nFreeParams = 6; %b5, info val, is fixed to 1    
    
            case 11 % win-stay lose-shift-like, different weighting allowed for different t-1 conditions           
                RLfcn = @(b,t,tfull) 1. ./ (1 + exp( (-1.0/b(1)) .*(b(2).*transpose(vPastInfoRew) + b(3).*transpose(vPastNoInfoRew)  + b(4).*transpose(vPastInfoUnRew) + + b(5).*transpose(vPastNoInfoUnRew) + b(6)) ) );
                %errCalc = @(b) -1*sum( 1*( log(RLfcn(b,tvec,tvecfull)).*Choice(tvec) + log(1-RLfcn(b,tvec,tvecfull)).*(1-Choice(tvec)) ) ); % -LL equation    
                errCalc = @(b) -1*sum( train(tvec).*transpose( log(RLfcn(b,tvec,tvecfull)).*Choice(tvec) + log(1-RLfcn(b,tvec,tvecfull)).*(1-Choice(tvec)) ) ); % -LL equation
                nFreeParams = 6; 
    
               
        end
        
    %     errCalc = @(b) -1*sum( log(RLfcn(b,tvec)).*Choice(tvec) + log(1-RLfcn(b,tvec)).*(1-Choice(tvec))); % -LL equation
    %     errCalc = @(b) -1*sum( log(RLfcn(b,tvec)).*Choice(tvec) + log(1-RLfcn(b,tvec)).*(1-Choice(tvec)) )/nTrials; % -LL equation
        
        %% INITIALIZE PARAMETERS
        
        scale = 1; %option to expand the coefficient range as an exploration, don't scale learning rates or info val
        % p1 is normalization, initially test 0-100 but set max to 100*scale
    
        %Parameter Initialization
        p10=0.2; % normalization
        p1min=0.1;
        p1max= 1;
        p20=0.4; % RL value
        p2min= 0.2; %-1.5*scale; %-2*scale;
        p2max=1;
        p30 = 0.3; % learning rate    
        p3min = 0.3;
        p3max =  1;
        
        p40 = -0.1; % info value
        p4min = -0.1;
        p4max = 2;
            
    
        options = optimset('MaxIter',100,'MaxFunEval',100,'Display','off');
        
        %% MINIMIZE NLL FOR EACH SUBJECT
        
        switch model
    
            case 1 % RLwater
                
    
                p40 = -0.25; %epsilon bias term
               
                if m == 28 || m == 29 || m == 30
                    p4max = -0.225;
                    p4min = -0.3;
                else
                    p4max = -0.225;
                    p4min = -0.275;
                end
                
    
                for i = 1:2
                    for p = 1:1:2
                        for q = 1:1:2
                            for n = 1:1:2
                                for g = 1:1:1
                                    p1 = p10 + i*100/10;
                                    p2 = p20 + p*0.25; % water value coeff
                                    p3 = p30 + q*0.3; % learning rate
                                    p4 = p40 + n*0.01; % eps bias
                                    
                                    [parTest, funTest, exitflagTest, outputTest] = fminsearchbnd(errCalc,[p1,p2,p3,p4],[p1min,p2min,p3min,p4min],[p1max,p2max,p3max,p4max],options); %minimize - LL
                                    if funTest < negLL %minimize - LL
                                        par1 = parTest;
                                        negLL = funTest;
                                        exitflag = exitflagTest;
                                        output = outputTest;
                                    end
                                end
                            end
                        end
                    end
                end
             
            case 2 % no RLwater
    
                p30 = 1; 
                p3min = 1;                                
                p3max = 1; 
                p20=0.1; % learning rate 1
                p2min=0.05;
                p2max=0.5;   
                p40 = 1;
                p4min = 0.3;
                p4max = 2;
    
                if m < 10
                    p40 = 0;
                    p4min = 0;
                    p4max = 0;
                end
    
                p50 = -0.25;
               
                if m == 28 || m == 29 || m == 30
                    p5max = -0.225;
                    p5min = -0.3;
                else
                    p5max = -0.225;
                    p5min = -0.275;
                end
                
    
                for i = 1:1
                    for p = 1:1:2
                        for q = 1:1:2
                            for n = 1:1:2
                                for g = 1:1:2
                                    p1 = p10 + i*100/10;
                                    p2 = p20 + p*0.3; 
                                    p3 = p30 + q*0; 
                                    p4 = p40 + n*0.3; 
                                    p5 = p50 - g*0.02; 
                                    if m < 10
                                       p4 = p40 + n*0; 
                                    end
                                    
                                    [parTest, funTest, exitflagTest, outputTest] = fminsearchbnd(errCalc,[p1,p2,p3,p4,p5],[p1min,p2min,p3min,p4min,p5min],[p1max,p2max,p3max,p4max,p5max],options); %minimize - LL
                                    if funTest < negLL %minimize - LL
                                        par1 = parTest;
                                        negLL = funTest;
                                        exitflag = exitflagTest;
                                        output = outputTest;
                                    end
                                end
                            end
                        end
                    end
                end
    
            case 3 % RLwater + RLinfo no lambda
    
                p50 = 1; % infoValfixed; % info value
                p5min = 1; %0.9;
                if m == 30
                    p5min = 1; %0.9; %infoValfixed-0.15;
                end          
                             
                p2max = 1;
                p2min = 0.6;
                p20 = 0.6;
    
                p5max = 1; % infoValfixed+ 1.65;
                p40=0.1; % learning rate 2
                p4min=0.05;
                p4max=0.5;   
                p60 = 0;
                p6min =0;           
                p6max = 0;
    
                p70 = -0.25;
               
                if m == 28 || m == 29 || m == 30
                    p7max = -0.225;
                    p7min = -0.3;
                else
                    p7max = -0.225;
                    p7min = -0.275;
                end
                
    
                for i = 1:2
                    for p = 1:1:2
                        for q = 1:1:2
                            for n = 1:1:2
                                for g = 1:1:1
                                    p1 = p10 + i*100/10;
                                    p2 = p20 + p*0.3; % water value coeff
                                    p3 = p30 + q*0.3; % learning rate
                                    p4 = p40 + n*0.3; % learning rate 2
                                    p5 = p50 + g*0; % info val
                                    p6 = p60 + n*0;
                                    p7 = p70 + q*0.05;
                                    [parTest, funTest, exitflagTest, outputTest] = fminsearchbnd(errCalc,[p1,p2,p3,p4,p5,p6,p7],[p1min,p2min,p3min,p4min,p5min,p6min,p7min],[p1max,p2max,p3max,p4max,p5max,p6max,p7max],options); %minimize - LL
                                    if funTest < negLL %minimize - LL
                                        par1 = parTest;
                                        negLL = funTest;
                                        exitflag = exitflagTest;
                                        output = outputTest;
                                    end
                                end
                            end
                        end
                    end
                end 
    
            case 4 % Full model
    
                p50 = 1; % infoValfixed; % info value
                p5min = 1; %0.9;
                if m == 30
                    p5min = 1; %0.9; %infoValfixed-0.15;
                end
                
                p2max = 1;
                p2min = 0.6;
                p20 = 0.6;
                
                 
                p5max = 1; % infoValfixed+ 1.65;
                p40=0.1; % learning rate 2
                p4min=0.05;
                p4max=0.5;   
                p60 = 1;
                p6min = 0.3;
                p6max = 2;
    
                %if m  == 9
                %    p3min = 0.1;                
                %end
                %if m == 7 
                %    p3min = 0.2;    
                %end
                %if m == 6
                %    p3min = 0.25;
                %end
                if m < 10
                    p4min=0.2;                          
                end
    
                if m < 10
                    p60 = 0;
                    p6min = 0;
                    p6max = 0;
                end
                
                p70 = -0.25;
               
                if m == 28 || m == 29 || m == 30
                    p7max = -0.225;
                    p7min = -0.3;
                else
                    p7max = -0.225;
                    p7min = -0.275;
                end
                
    
                for i = 1:1
                    for p = 1:1:2
                        for q = 1:1:2
                            for n = 1:1:2
                                for g = 1:1:2
                                    p1 = p10 + i*100/10;
                                    p2 = p20 + p*0.3; % water value coeff
                                    p3 = p30 + q*0.4; % learning rate
                                    p4 = p40 + n*0.4; % learning rate 2
                                    p5 = p50 + g*0; % info val
                                    p6 = p60 - n*0.1;
                                    if m < 10
                                       p6 = p60 + n*0; 
                                    end
                                    p7 = p70 + q*0.5;
                                    [parTest, funTest, exitflagTest, outputTest] = fminsearchbnd(errCalc,[p1,p2,p3,p4,p5,p6,p7],[p1min,p2min,p3min,p4min,p5min,p6min,p7min],[p1max,p2max,p3max,p4max,p5max,p6max,p7max],options); %minimize - LL
                                    if funTest < negLL %minimize - LL
                                        par1 = parTest;
                                        negLL = funTest;
                                        exitflag = exitflagTest;
                                        output = outputTest;
                                    end
                                end
                            end
                        end
                    end
                end

                case 5 % Full model
    
                p50 = 1; % infoValfixed; % info value
                p5min = 1; %0.9;
                if m == 30
                    p5min = 1; %0.9; %infoValfixed-0.15;
                end
                
                p2max = 1;
                p2min = 0.6;
                p20 = 0.6;
                
                 
                p5max = 1; % infoValfixed+ 1.65;
                p40=0.1; % learning rate 2
                p4min=0.05;
                p4max=0.5;   
                p60 = 1;
                p6min = 0.05;
                p6max = 0.8;
    
                %if m  == 9
                %    p3min = 0.1;                
                %end
                %if m == 7 
                %    p3min = 0.2;    
                %end
                %if m == 6
                %    p3min = 0.25;
                %end
                if m < 10
                    p4min=0.2;                          
                end
    
                if m < 10
                    p60 = 0;
                    p6min = 0;
                    p6max = 0;
                end
                
                p70 = -0.25;
               
                if m == 28 || m == 29 || m == 30
                    p7max = -0.225;
                    p7min = -0.3;
                else
                    p7max = -0.225;
                    p7min = -0.275;
                end
                
    
                for i = 1:1
                    for p = 1:1:2
                        for q = 1:1:2
                            for n = 1:1:2
                                for g = 1:1:2
                                    p1 = p10 + i*100/10;
                                    p2 = p20 + p*0.3; % water value coeff
                                    p3 = p30 + q*0.4; % learning rate
                                    p4 = p40 + n*0.4; % learning rate 2
                                    p5 = p50 + g*0; % info val
                                    p6 = p60 - n*0.1;
                                    if m < 10
                                       p6 = p60 + n*0; 
                                    end
                                    p7 = p70 + q*0.5;
                                    [parTest, funTest, exitflagTest, outputTest] = fminsearchbnd(errCalc,[p1,p2,p3,p4,p5,p6,p7],[p1min,p2min,p3min,p4min,p5min,p6min,p7min],[p1max,p2max,p3max,p4max,p5max,p6max,p7max],options); %minimize - LL
                                    if funTest < negLL %minimize - LL
                                        par1 = parTest;
                                        negLL = funTest;
                                        exitflag = exitflagTest;
                                        output = outputTest;
                                    end
                                end
                            end
                        end
                    end
                end
    
                case 11 % WS-LS
    
                p20 = -1; 
                p2min = -1;
                p2max = 1;
                p30 = -1; 
                p3min = -1;
                p3max = 1;
                p40 = -1; 
                p4min = -1;
                p4max = 1;
                p50 = -1; 
                p5min = -1;
                p5max = 1;
    
                p60 = -1; 
                p6min = -2;
                p6max = -0.2;
    
                if m == 6 
                    p6max = -0.9;
                end
    
                if  m == 9
                    p6max = 0.05;
                end
    
                if m == 29 
                    p6max = 0.99;
                    p6min = 0.99;
                    p60 = 0.99; 
                end
    
                if  m == 28 
                    p6max = 0.99;
                    p6min = 0.99;
                    p60 = 0.99; 
                end
    
                if m == 32
                    p6max = -0.815;
                end
                
                if m == 33
                    p6max = -0.6;
                end
    
                for i = 1:1
                    for p = 1:1:2
                        for q = 1:1:2
                            for n = 1:1:2
                                for g = 1:1:2
                                    p1 = p10 + i*100/10;
                                    p2 = p20 + p*0.7; % water value coeff
                                    p3 = p30 + q*0.3; % learning rate
                                    p4 = p40 + n*0.3; % learning rate 2
                                    p5 = p50 + g*0; % info val
                                    p6 = p60 + n*0.05;
                                    %p7 = p70 + q*0.5;
                                    [parTest, funTest, exitflagTest, outputTest] = fminsearchbnd(errCalc,[p1,p2,p3,p4,p5,p6],[p1min,p2min,p3min,p4min,p5min,p6min],[p1max,p2max,p3max,p4max,p5max,p6max],options); %minimize - LL
                                    if funTest < negLL %minimize - LL
                                        par1 = parTest;
                                        negLL = funTest;
                                        exitflag = exitflagTest;
                                        output = outputTest;
                                    end
                                end
                            end
                        end
                    end
                end
        end
    
        
    
        for p=1:numel(par1)
            results.par1All{m,p}=par1(p);
            results.parPerMice{m,nR}.par1All{p}=par1(p);
        end
        results.negLLAll(m)=negLL;
        results.exitFlagAll{m}=exitflag;
        results.outputAll{m}=output;
     
        
        % TESTING GOODNESS OF FIT
        if model >0
            current_accuracy=1-sum(abs(round(RLfcn(par1,tvec,tvecfull))-Choice(tvec)))/nTrials;
            Ntest = sum(test)
            %current_accuracyTest=1-sum( test.*transpose(abs(round(RLfcn(par1,tvec,tvecfull)))) -test.*transpose(Choice(tvec))) /Ntest;
            current_accuracyTest=1-sum( test.*transpose(abs(round(RLfcn(par1,tvec,tvecfull)) -(Choice(tvec))))) /Ntest;
    
            modelChoice=round(RLfcn(par1,tvec,tvecfull));
            modelChoiceCorr = modelChoice(Correct==1);
            modelChoiceInfo = modelChoice(Info==1);
            modelChoiceNoInfo = modelChoice(Info==0);
            accuracyCorr = 1-sum(abs(modelChoiceCorr-Choice(tveccorr)))/sum(Correct);
            accuracyInfo = 1-sum(abs(modelChoiceInfo-Choice(Info==1)))/sum(Info==1);
            accuracyNoInfo = 1-sum(abs(modelChoiceNoInfo-Choice(Info==0)))/sum(Info==0);
        else
            current_accuracy=1-sum(abs(round(RLfcn(par1,tvec))-Choice(tveccorr)))/nTrials;
        end
        accuracy = [accuracy,current_accuracy];
        accuracyTest = [accuracy,current_accuracyTest];
        results.accuracy(m,1)=current_accuracy;
        results.accuracyTest(m,1)=current_accuracyTest;
        results.accuracyCorr(m,1)=accuracyCorr;
        results.accuracyInfo(m,1)=accuracyInfo;
        results.accuracyNoInfo(m,1)=accuracyNoInfo;
        
        results.modelChoices{m,1}=round(RLfcn(par1,tvec,tvecfull));
        results.modelChoiceInfo{m,1} = modelChoiceInfo;
        results.modelChoiceNoInfo{m,1} = modelChoiceNoInfo;
        results.realChoices{m,1}=Choice(tvec);
        results.correct{m,1}=Correct;
        results.diffBtwModelData{m,1} = round(RLfcn(par1,tvec,tvecfull)) - Choice(tvec);
        results.reward{m,1}=Reward;
        results.delay{m,1}=Delay;
        results.waterValue{m,1}=Values;
    
        if model == 4 || model == 5
            [ValDiffval,ValDiff,IwaterPE,NIwaterPE,InfoV_out,NoInfoV_out] = ValueFuncFull(par1(3),tvec,tvecfull,FullReward,FullChoice,FullTypes,1);
            if model == 4
                [ValDiffval2,ValDiff2,infoPE] = InfoValueFuncFull(par1(4),tvec,tvecfull,FullReward,FullChoice,FullTypes,par1(5),FullDelay,par1(6),0);
            end
            if model == 5
                [ValDiffval2,ValDiff2,infoPE] = InfoValueFuncFull(par1(4),tvec,tvecfull,FullReward,FullChoice,FullTypes,par1(5),FullDelay,par1(6),1);
            end
            results.ValFuncInfo{m,1} = transpose(ValDiff2);
            results.PEInfo{m,1} = transpose(infoPE);
            results.ValFuncWaterInfo{m,1} = transpose(InfoV_out);
            results.ValFuncWaterNoInfo{m,1} = transpose(NoInfoV_out);
            results.PENoInfo{m,1} = transpose(NIwaterPE);
            results.PEWaterNoInfo{m,1} = transpose(IwaterPE);
        end
    
    %     modelChoice=round(RLfcn(par1,tvec));
    %     choiceAccuracy = 1-sum(abs(modelChoice(ChoiceTrials==1)-Choice(ChoiceTrials==1)))/sum(ChoiceTrials==1);
    %     forcedInfoAccuracy = 1-sum(abs(modelChoice(ForcedInfo==1)-Choice(ForcedInfo==1)))/sum(ForcedInfo==1);
    %     forcedNoInfoAccuracy = 1-sum(abs(modelChoice(ForcedNoInfo==1)-Choice(ForcedNoInfo==1)))/sum(ForcedNoInfo==1);
        
    %     results.choiceAccuracy{m}=choiceAccuracy;
    %     results.forcedInfoAccuracy{m}=forcedInfoAccuracy;
    %     results.forcedNoInfoAccuracy{m}=forcedNoInfoAccuracy;
        
        results.N(m,1)=nTrials;
        results.preN(m,1)=sum(a.reverse==1&okTrials);
        results.postN(m,1)=sum(a.reverse==-1&okTrials);
        
        if m < 10 && (model == 4 || model == 5)
            nFreeParams = 5
        end
    
        if m < 10 && model == 2
            nFreeParams = 3
        end
        % AIC
        results.AIC(m,1) = 2*nFreeParams + 2*negLL;
    
        % BIC
        results.BIC(m,1) = log(nTrials)*nFreeParams + 2*negLL;
        
        display(['Accuracy ' num2str(current_accuracy)]);
        display(['AccuracyTest ' num2str(current_accuracyTest)]);
        
    %     sAcc = num2str(current_accuracy);
    %     titleString = strcat('Red-fit,Blue-data,Acc=',sAcc)
    %     figure 
    %     tplot = 50:1:100;
    %     plot(tplot,Choice(tplot),'b')
    %     hold on
    %     plot(tplot,round(RLfcn(par1,tplot)),'r')
    %     hold off
    %     axis([50 100 -0.5 1.5])
    %     xlabel('Trial # (slice)') 
    %     ylabel('Choice') 
    %     title(titleString)
    a.Accuracies(nR) = current_accuracy;
    a.TestAccuracies(nR) = current_accuracyTest;
    a.TrainAIC(nR) = 2*nFreeParams + 2*negLL;
    a.TrainBIC(nR) = log(nTrials-Ntest)*nFreeParams + 2*negLL;
    a.nInfoRew1(nR) = nInfoRew1;
    a.nNoInfoRew1(nR) = nNoInfoRew1;
    a.nInfoUnRew1(nR) = nInfoUnRew1;
    a.nNoInfoUnRew1(nR) = nNoInfoUnRew1;
    a.nInfoRew2(nR) = nInfoRew2;
    a.nNoInfoRew2(nR) = nNoInfoRew2;
    a.nInfoUnRew2(nR) = nInfoUnRew2;
    a.nNoInfoUnRew2(nR) = nNoInfoUnRew2;
    
    end
    nTrain = nTrials-Ntest;
    results.nTrain{m,1} = nTrain;
    results.nTest{m,1} = Ntest;

    results.Accuracies{m,1} = a.Accuracies;

    results.TestAccuracies{m,1} = a.TestAccuracies;
    results.meanTestAccuracies(m,1) = mean(a.TestAccuracies);
    results.semTestAccuracies(m,1) = std(a.TestAccuracies)/sqrt(length(a.TestAccuracies));
    results.stdTestAccuracies(m,1) = std(a.TestAccuracies);

    results.TrainAIC{m,1} = a.TrainAIC;
    results.meanTrainAIC(m,1) = mean(a.TrainAIC);
    results.semTrainAIC(m,1) = std(a.TrainAIC)/sqrt(length(a.TrainAIC));
    results.stdTrainAIC(m,1) = std(a.TrainAIC);

    results.TrainBIC{m,1} = a.TrainBIC;
    results.meanTrainBIC(m,1) = mean(a.TrainBIC);
    results.semTrainBIC(m,1) = std(a.TrainBIC)/sqrt(length(a.TrainBIC));
    results.stdTrainBIC(m,1) = std(a.TrainBIC);

    %results.TrainAIC{m,1} = a.TrainAIC;
    results.meanTrainAICN(m,1) = mean(a.TrainAIC)/nTrain;
    results.semTrainAICN(m,1) = (std(a.TrainAIC)/sqrt(length(a.TrainAIC)))/nTrain;
    results.stdTrainAICN(m,1) = std(a.TrainAIC)/nTrain;

    %results.TrainBIC{m,1} = a.TrainBIC;
    results.meanTrainBICN(m,1) = (mean(a.TrainBIC))/nTrain;
    results.semTrainBICN(m,1) = (std(a.TrainBIC)/sqrt(length(a.TrainBIC)))/nTrain;
    results.stdTrainBICN(m,1) = std(a.TrainBIC)/nTrain;

    results.nInfoRew1{m,1} = a.nInfoRew1;
    results.nNoInfoRew1{m,1} = a.nNoInfoRew1;
    results.nInfoUnRew1{m,1} = a.nInfoUnRew1;
    results.nNoInfoUnRew1{m,1} = a.nNoInfoUnRew1;
    results.nInfoRew2{m,1} = a.nInfoRew2;
    results.nNoInfoRew2{m,1} = a.nNoInfoRew2;
    results.nInfoUnRew2{m,1} = a.nInfoUnRew2;
    results.nNoInfoUnRew2{m,1} = a.nNoInfoUnRew2;

end
%% END SUBJECT LOOP

%% SAVE
% make sure to save fit above for each subject

save(['DecisionModelResults_Model',num2str(model),'_',num2str(allTrials),'_Models7_Value_LR0.1-1Info2',datestr(now,'yyyymmdd'),'.mat'],'results','errCalc','RLfcn');

% display('accuracy');
% accuracy
% 
% display('info val');
% infoval


%% VALUE FUNCTIONS
%first function is for when the two choice alternative value functions are subtracted from each other, second with just one choice value function

function [ValDiffval,ValDiff,IwaterPE,NIwaterPE,InfoV_out,NoInfoV_out] = ValueFuncFull(a1,t,tfull,FullReward,FullChoice,FullTypes,InfoVal)
    % simplest in fitting set a1 = a2 before inputting to this function, learning rates
    % InfoRew is the reward experienced for trial type Info, InfoV is the value function for Info
    % NoInfoRew / NoInfoV same but for trial type NoInfo 
    % trialVector = 1:EndTrialNumber
    % Water reward for each type of trial is Reward
    % a2=a1;
    ValDiff = [];
    InfoV = [];
    NoInfoV = [];
    IwaterPE = [];
    NIwaterPE = [];
    ValDiffval = -9999;
    InfoV_out = [];
    NoInfoV_out = [];

    if length(tfull) == 1
        tmax = tfull;
    end
    if length(tfull) > 1
        tmax = length(tfull);
    end

    for x = 1:1:tmax                         
        if x == 1
%            ValDiff = [ValDiff,0]; % begin Info = No Info
           InfoV = [InfoV,0.5];
           NoInfoV = [NoInfoV,0.5];
        else
           if FullChoice(x-1) == 1 % Info
               % if chose info last trial, update info
               % value to learning rate * last trial
               % reward - no info value + INFO VALUE
               % BONUS
               InfoV = [InfoV, (InfoV(x-1)+a1*(FullReward(x-1)-InfoV(x-1)) )];
               NoInfoV = [NoInfoV, NoInfoV(x-1)];
           end
           if FullChoice(x-1) == 0   % no info
               % if chose no info last, update no info
               % side value to learning rate * reward of
               % last trial - no info value at last trial
               NoInfoV = [NoInfoV, (NoInfoV(x-1)+a1*(FullReward(x-1)-NoInfoV(x-1)) )];
               InfoV = [InfoV, InfoV(x-1)];
               %InfoV = [InfoV,InfoV(x-1)];
           end
           if FullChoice(x-1) == 0.5 % miss, choice = 0.5 for no choice
               NoInfoV = [NoInfoV,NoInfoV(x-1)];
               InfoV = [InfoV,InfoV(x-1)];
           end

        end
        if FullTypes(x)==1
            ValDiff = [ValDiff,InfoV(x)-NoInfoV(x)];
            InfoV_out = [InfoV_out,InfoV(x)];
            NoInfoV_out = [NoInfoV_out,NoInfoV(x)];
            if x > 1
                if FullChoice(x-1) == 1
                    IwaterPE = [IwaterPE,(FullReward(x-1)-InfoV(x-1))];
                    NIwaterPE = [NIwaterPE,0];
                end
                if FullChoice(x-1) == 0
                    NIwaterPE = [NIwaterPE, (FullReward(x-1)-NoInfoV(x-1))];
                    IwaterPE = [IwaterPE, 0];
                end   
                if FullChoice(x-1) == 0.5   
                    IwaterPE = [IwaterPE, 0];
                    NIwaterPE = [NIwaterPE,0];
                end
            else
                IwaterPE = [IwaterPE,0];
                NIwaterPE = [NIwaterPE,0];
            end    
        end
        if x == tmax && length(t) == 1
           ValDiffval = ValDiff(t); 
           InfoV_out = InfoV(t);
           NoInfoV_out =NoInfoV(t);
           
           IwaterPE = 0;
           NIwaterPE = 0;
            
        end
    end
    if length(t) > 1
        ValDiffval = ValDiff;
        
    end                                
end



function [ValDiffval,ValDiff,infoPE] = InfoValueFuncFull(a1,t,tfull,FullReward,FullChoice,FullTypes,InfoVal,FullDelay,Exponent,hyperbolic)
    % simplest in fitting set a1 = a2 before inputting to this function, learning rates
    % InfoRew is the reward experienced for trial type Info, InfoV is the value function for Info
    % NoInfoRew / NoInfoV same but for trial type NoInfo 
    % trialVector = 1:EndTrialNumber
    % Water reward for each type of trial is Reward
    % a2=a1;
    ValDiff = [];
    InfoV = [];
    NoInfoV = [];
    infoPE = [];

    ValDiffval = -9999;

    if length(tfull) == 1
        tmax = tfull;
    end
    if length(tfull) > 1
        tmax = length(tfull);
    end

    for x = 1:1:tmax                         
        if x == 1
%            ValDiff = [ValDiff,0]; % begin Info = No Info
           InfoV = [InfoV,0];
           NoInfoV = [NoInfoV,0];
           infoPE = [infoPE,0];

        else
           if hyperbolic == 1 
            DiscountInfoVal = 0.5*InfoVal/( 1 - ((FullDelay(x-1)/10)*Exponent) ) ;
           end
           if hyperbolic == 0 
            DiscountInfoVal = InfoVal*((FullDelay(x-1)/10)^Exponent);
           end
           if FullChoice(x-1) == 1 % Info
               % if chose info last trial, update info
               % value to learning rate * last trial
               % reward - no info value + INFO VALUE
               % BONUS
               InfoV = [InfoV, (InfoV(x-1)+a1*(DiscountInfoVal-InfoV(x-1)) )];
               
               %NoInfoV = [NoInfoV, NoInfoV(x-1)];
           end
           if FullChoice(x-1) == 0   % no info
               % if chose no info last, update no info
               % side value to learning rate * reward of
               % last trial - no info value at last trial
               %NoInfoV = [NoInfoV, (NoInfoV(x-1)+a1*(0-NoInfoV(x-1)) )];
               InfoV = [InfoV, (InfoV(x-1)+a1*(0-InfoV(x-1)) )];
               
               %InfoV = [InfoV, InfoV(x-1)];
               %InfoV = [InfoV,InfoV(x-1)];
           end
           if FullChoice(x-1) == 0.5 % miss, choice = 0.5 for no choice
               %NoInfoV = [NoInfoV,NoInfoV(x-1)];
               InfoV = [InfoV,InfoV(x-1)];
           end

        end
        if FullTypes(x)==1
            %ValDiff = [ValDiff,InfoV(x)-NoInfoV(x)];
            ValDiff = [ValDiff,InfoV(x)];
            if x > 1
                if FullChoice(x-1) == 1
                    infoPE = [infoPE,(DiscountInfoVal-InfoV(x-1))];
                end
                if FullChoice(x-1) == 0
                    infoPE = [infoPE, (0-InfoV(x-1))];
                end   
                if FullChoice(x-1) == 0.5   
                    infoPE = [infoPE, (0-InfoV(x-1))];
                end
            else
                infoPE = [infoPE,0];
            end   


        end
        if x == tmax && length(t) == 1
           ValDiffval = ValDiff(t);  
           infoPE = 0;
        end
    end
    if length(t) > 1
        ValDiffval = ValDiff;
    end                                
end

%{
% JB432
4s 142:150
6s 151:156
1s 48:53
10s 40:47

JB433
10s 38:46
1s 44:50
4s 144:152
6s 153:158

JB434
10s 82:87
1s 76:81
4s 143:150
6s 151:156

JB454
10s 68:74
1s 75:81
4s 87:92
6s 82:86

JB455
10s 65:71
1s 72:78
4s 83:89
6s 79:82

JB456
10s 65:71
1s 72:78
4s 84:89
6s 79:83
%}


%{
JB219
1 32:33 75:77
2 57:59 63:65
3 43:50 69:71
4 29:31 60:62 78:80
5 34:42 72:74
6 51:56 66:68

JB220
1 26:27 65:67
2 39:41 53:55
3 31:36 59:61
4 23:25 42:52 68:70
5 28:30 62:64
6 37:38 56:58
    
JB221
1 35:37 65:67
2 47:49 53:55
3 41:43 59:61
4 29:34 50:52 68:70
5 38:40 62:64
6 44:46 56:58
   
JB222
1 34:36 64:66
2 46:48 52:54
3 40:42 58:60
4 27:33 49:51 67:69
5 37:39 61:63
6 43:45 55:57
    
JB413
1 74:82
2 95:105
3 89:94
4 69:73
5 83:88

JB424  
1 73:82
2 89:94
3 101:106
4 67:72
5 83:88
    
JB425
1 64:69
2 76:87
3 95:100
4 58:63
5 70:75
6 89:94
    
JB426
1 81:92
2 111:117
3 99:104
4 75:80
5 93:98
6 105:110
    
JB427
1 97:102
2 110:118
3 123:128
4 90:96
5 103:109
6 119:122
   
JB454
1 42:48
2 62:67
3 53:58
4 35:41
5 59:62
6 49:52
    
JB455
1 40:45
2 59:64
3 50:55
4 34:39
5 56:58
6 46:49
    
JB456
1 40:45
2 60:64
3 50:56
4 34:39
5 57:59
6 46:49
    
    %}