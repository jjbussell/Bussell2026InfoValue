% function BpodNeuralDataTone(mice,days)

    clear;
%     mice={'JB483'};
% %     days={{'20240524','20240529','20240614','20240618','20240619','20240625','20240628'},{'20240524','20240528','20240614','20240618','20240619','20240628','20240701'}};
%     days={{'20240614'}};
    
%     mice={'JB483','JB484'};
% %     days={{'20240524','20240529','20240614','20240618','20240619','20240625','20240628'},{'20240524','20240528','20240614','20240618','20240619','20240628','20240701'}};
%     days={{'20240614','20240618','20240625','20240628'};{'20240614','20240619','20240628','20240701'}};
%     days={{'20240614'};{'20240619'}};

% mice={'JB509'};
% days={{'20250205','20250206','20250213','20250214'}};

mice={'JB506','JB507'};
days={{'20250205','20250206','20250212','20250213'},{'20250206','20250207','20250213','20250214'}};

%     mice={'JB483','JB484','JB482'};
%     days={{'20240517'};{'20240516','20240517'};{'20240515','20240516'}};

    infoseekdir=findInfoseekData();

    %% Set parameters

    set(0,'DefaultFigureWindowStyle','docked');

    % VARS

    loadVars={'mouse','day','trial','startTime','endTime','StartTrial',...
        'centerEntryCount','centerExitGo','centerExitFirst','odor2On','odor2LeavingTime',...
        'OutcomeDelivery','TimeoutOutcome','correct','info','big',...
        'outcome','choice','trialType','trialTypes','infoSide','bigSide','reward',...
        'infoForced','randForced','bigForced','smallForced',...
        'infoBig','infoSmall','randBig','randSmall','bigWater','smallWater','rxn','trialLength',...
        'trialLengthCenterEntry','odorDelay','rewardDelay','toneOn',...
        'odor2type','odorAtrials','odorBtrials','odorCtrials','odorDtrials','odorWatertrials',...
        'rewardParams'};

    expandVars = {'CenterDelay','CenterOdor','GlobalTimer7_Start','GlobalTimer7_End',...
        'GlobalTimer8_Start','GlobalTimer8_End','BNC1High','BNC1Low'};

    m=1;d=1;
    
    for m=1:numel(mice)

        for d=1:numel(days{m})

            mouse=mice{m};
            day=days{m}{d};

            baseDir = ['D:\Bussell Dropbox\Jennifer Bussell\BpodInfoseek\Analysis\',mouse,'_pipeline'];
            neuroDir = baseDir;
            BpodDir = baseDir;
            SyncDir = baseDir;
            output_dir = baseDir;


            % load from file
            % 'InfoseekNeuroAnalysisParams.mat'
            params=load(fullfile(baseDir,'InfoseekNeuroAnalysisParams.mat'));

            % params
            params.GPIOopts = delimitedTextImportOptions("NumVariables", 3);
            params.GPIOopts.DataLines = [2, Inf];
            params.GPIOopts.Delimiter = ",";
            params.GPIOopts.VariableNames = ["Times", "ChannelName", "Value"];
            params.GPIOopts.VariableTypes = ["double", "string", "double"];
            params.GPIOopts.ExtraColumnsRule = "ignore";
            params.GPIOopts.EmptyLineRule = "read";
            params.GPIOopts = setvaropts(params.GPIOopts, "ChannelName", "WhitespaceRule", "preserve");
            params.GPIOopts = setvaropts(params.GPIOopts, "ChannelName", "EmptyFieldRule", "auto");

            params.scopethreshold = 10000; %200 %500 %150 %58500
            params.DAQthreshold = 0.05;
            params.syncDev = 2; % 1 for scope, 2 for DAQ

            params.smoothed = 1;
            params.normalize = 1;
            params.interval = 2000;
            % params.framesAround = params.interval/1000*params.Fs;
            params.events = {'trialStart'; 'centerEntry'; 'odor1'; 'centerExit';...
                'sideEntry'; 'odor2'; 'outcome'; 'odor1all'; 'odor1first'; 'baseline';'total'; 'leaving'; 'centerExitFirst'; 'tone'};
            params.intervals = [2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,18000,2000,2000,2000];
            % params.framesAroundEvent = params.intervals./1000*params.Fs;
            params.baselineParam = 2; %seconds before trial start for baseline (during ITI presumably)

            %% LOAD SESSION TABLE

            load(fullfile(infoseekdir,['BpodInfoseekSessions_',params.dataset{1},'.mat']));

            %% load data for each session

            % load neural data (C, C_raw, Fs)
            % find matching Bpod, DAQ, GPIO files


            filename=fullfile(neuroDir, [mice{m}, '_*', days{m}{d}, '*cells*.mat']);
            neuroFiles=dir(filename);
            nfiles=numel(neuroFiles); % base on neural data
            f=1;

            [~,fname,ext]=fileparts(fullfile(neuroFiles(f).folder,neuroFiles(f).name));
            names=strsplit(fname,'_');
            nameroot=[names{1},'_',names{2},'_',names{3}];

            disp('Syncing data for:')
            fname

            GPIOfilename = [mouse '_*' day '*GPIO.csv'];
            GPIOfiles = dir(fullfile(SyncDir,GPIOfilename));
            DAQfilename = [day '*DAQout.csv'];
            DAQfiles = dir(fullfile(SyncDir,DAQfilename));
            Bpodfilename = [mouse '_*Infoseek*' day '*_waterpp.mat'];
            Bpodfiles=dir(fullfile(BpodDir,Bpodfilename));

            if numel(Bpodfiles)~=numel(DAQfiles)
                disp('NOTE: different number of Bpod and DAQ files!!!');
            end   


        %% SCOPE GPIO
            if ~isempty(GPIOfiles)
                disp('GPIO sync');
                a.GPIOFrames=[];
                a.GPIOSync=[];
                a.GPIOFile=[];
                a.GPIOFramesFile=[];

                for ff=1:numel(GPIOfiles)
                % file name
                GPIOname = GPIOfiles(ff).name;
                filepath = fullfile(SyncDir,GPIOname);

                % Import the data
                tbl = readtable(filepath, params.GPIOopts);
                Times = tbl.Times;
                ChannelName = tbl.ChannelName;
                Value = tbl.Value;
                channels = unique(ChannelName);

                % SCOPE GPIO
                gpio1data=strcmp(channels{21},ChannelName);
                gpio1times=Times(gpio1data);
                gpio1vals=Value(gpio1data);
                gpio1times=gpio1times(~isnan(gpio1vals));
                gpio1vals=gpio1vals(~isnan(gpio1vals));
    %             gpio2data=strcmp(channels{22},ChannelName);
    %             gpio2times=Times(gpio2data);
    %             gpio2vals = Value(gpio2data);
    %             gpio2times=gpio2times(~isnan(gpio2vals));
    %             gpio2vals=gpio2vals(~isnan(gpio2vals));

        %         scopethreshold = 10000; %200 %500 %150 %58500

                valdiff1 = diff(gpio1vals>params.scopethreshold);
    %             valdiff2 = diff(gpio2vals>params.scopethreshold);
                changeFlags1 = find(valdiff1~=0)+1;
                Bpod1Scope = gpio1times(changeFlags1);
                BpodScopeAll = sort(Bpod1Scope);
    %             changeFlags2 = find(valdiff2~=0)+1;
    %             Bpod2Scope = gpio2times(changeFlags2);

    %             BpodScopeAll = sort([Bpod1Scope;Bpod2Scope]);

                % SCOPE SYNC OUTPUT FOR EACH FRAME

                GPIOsync = strcmp(channels{1},ChannelName);
                GPIOsyncTimes = Times(GPIOsync);
                GPIOsyncVals = Value(GPIOsync);
                GPIOsyncTimes=GPIOsyncTimes(~isnan(GPIOsyncVals));
                GPIOsyncVals=GPIOsyncVals(~isnan(GPIOsyncVals));

                ScopeFrameDiff = diff(GPIOsyncVals);
                ScopeFrames = GPIOsyncTimes(find(ScopeFrameDiff==1)+1); % frame timestamps in scope's timeframe (Bpod starts sometime after these)
                GPIOFile(1:numel(BpodScopeAll),1)=ff;
                GPIOFramesFile(1:numel(ScopeFrames),1)=ff;

                a.GPIOFile= [a.GPIOFile;GPIOFile];
                a.GPIOFrames = [a.GPIOFrames;ScopeFrames];
                a.GPIOFramesFile=[a.GPIOFramesFile;GPIOFramesFile];
                a.GPIOSync = [a.GPIOSync; BpodScopeAll];
                end
            end

            %% DAQ SYNC
                if ~isempty(DAQfiles)
            disp('DAQ sync');
            a.DAQFrames=[];
            a.DAQSync=[];
            a.DAQFile=[];
            a.DAQFramesFile=[];
            a.breaks=[];
            for ff=1:numel(DAQfiles)
                DAQname = DAQfiles(ff).name;
                filepath = fullfile(SyncDir,DAQname);
                DAQdata = csvread(filepath);
    %             DAQdata=DAQdata(306683:end,:);
    %             DAQframeVals=DAQdata(:,1); DAQTime = DAQdata(:,4); DAQBpod1=DAQdata(:,2); DAQBpod2=DAQdata(:,3);
                DAQframeVals=DAQdata(:,1); DAQTime = DAQdata(:,5); DAQBpod1=DAQdata(:,2); DAQBpod2=[];
        %         DAQthreshold = 0.05; %0.05

                Bpod1diff = diff(DAQBpod1>params.DAQthreshold);
                Bpod1changes=find(Bpod1diff~=0)+1;
                Bpod1DAQ=DAQTime(Bpod1changes);

                Bpod2diff = diff(DAQBpod2>params.DAQthreshold);
                Bpod2changes=find(Bpod2diff~=0)+1;
                Bpod2DAQ=DAQTime(Bpod2changes);

                BpodDAQAll = sort([Bpod1DAQ;Bpod2DAQ]);

                DAQfile(1:numel(BpodDAQAll),1)=ff;

                % sync from scope
                DAQframesDiff=diff(DAQframeVals>params.DAQthreshold);
                DAQframesLocs=find(DAQframesDiff==1)+1;
                DAQFrames=DAQTime(DAQframesLocs);
                DAQFramesFile(1:numel(DAQFrames),1)=ff;

                a.DAQFrames=[a.DAQFrames; DAQFrames];
                a.DAQFramesFile=[a.DAQFramesFile;DAQFramesFile];
                a.DAQSync= [a.DAQSync; BpodDAQAll];
                a.DAQFile=[a.DAQFile;DAQfile];
                a.breaks=[a.breaks; find(diff(a.DAQSync)>0.11)];
            end
                if numel(a.breaks)>1
                    disp('ERROR: more than one split in DAQ files!!') 
                end
            if numel(DAQfiles)<numel(Bpodfiles)
                disp('Check file numbers. Adjusting DAQ files and timestamps to match 2 BpodFiles and 1 DAQFile, make sure not using GPIO')
                newFrame=a.DAQFrames-a.DAQSync(a.breaks(1)+1);
                newFrame(newFrame<0)=NaN;
                [~,frame]=min(newFrame);
                a.DAQFrames(frame:end)=newFrame(frame:end);
                a.DAQFramesFile(frame:end)=2;
                a.DAQFile(a.breaks(1)+1:end)=2;
                a.DAQSync(a.breaks(1)+1:end)=a.DAQSync(a.breaks(1)+1:end)-a.DAQSync(a.breaks(1)+1);

            end
        end

    %     if sum(mouse=='JB413')==5 & sum(day == '20211019')==8 % for 426 2/1!!!!!!
    %         a.DAQSync=[a.DAQSync(1:9477); a.DAQSync(9479:end)];
    %     end    

    %     if ~isempty(a.breaks) & numel(DAQfiles)==1
    %         a.DAQFile(a.breaks(1)+1:end)=2;
    %     end
        if isempty(DAQfiles)
            params.syncDev = 1;
        end

            %% BPOD DATA
   disp('Bpod Sync');
   a.file=[];
   a.trialCt=0;
   a.imagingTrials=[];   
   for ff=1:numel(Bpodfiles)
       b=load(fullfile(BpodDir,Bpodfiles(ff).name));
       trialCt=b.trialCt;
       imagingTrials(1:trialCt,1)=logical(1); 
       a.trialCt=a.trialCt + trialCt;
       a.imagingTrials = [a.imagingTrials; imagingTrials]; 
       fileFlag(1:trialCt,1)=ff;
       a.file= [a.file;fileFlag];
       if ~isfield(a,loadVars{1})
           for i = 1:numel(loadVars)
              a.(loadVars{i})=b.(loadVars{i}); 
           end
       else
           for i = 1:numel(loadVars)
                a.(loadVars{i})=cat(1,a.(loadVars{i}),b.(loadVars{i}));
           end
       end

       for i = 1:numel(expandVars)
           vardata.(expandVars{i}){ff}=b.(expandVars{i});
           varsize.(expandVars{i}){ff}=size(b.(expandVars{i}),2);
       end
       
       b=[];
       trialCt=[];
       imagingTrials=[];
       fileFlag=[];
   end
   
   for i=1:numel(expandVars)
       maxLength=max([varsize.(expandVars{i}){:}]);
%        a.(expandVars{i})=NaN(a.trialCt,maxLength);      
       for ff=1:numel(Bpodfiles)
          dataSize=size(vardata.(expandVars{i}){ff});
          data{ff}=NaN(dataSize(1),maxLength);
          data{ff}(:,1:dataSize(2))=vardata.(expandVars{i}){ff};
       end
       a.(expandVars{i})=cat(1,data{:});
   end
   
   a.BpodFile=[]; BpodFile=[];
   a.BpodSyncTimers=[];
   a.BpodTimersAll=[];
%    a.BpodTimersAllRel=[];
   for ff=1:numel(Bpodfiles)
              
    timer7times = a.GlobalTimer7_Start(a.file==ff,:)+a.startTime(a.file==ff); % set relative to all of Bpod
    [timer7idx,~]=find(timer7times); % get row (trial) of each time
    timer7=reshape(timer7times,[],1); % make single column
    [timer7trials,timer7trialidx]=sort(timer7idx); % sort by trial (row than column?)
    timer7=timer7(timer7trialidx);

    timer7timesend = a.GlobalTimer7_End(a.file==ff,:)+a.startTime(a.file==ff); % set relative to all of Bpod
    if size(timer7timesend,2)==size(timer7times,2)-1
        timer7timesend(:,end+1)=NaN(size(timer7timesend,1),1);
    end
    [timer7idxend,~]=find(timer7timesend); % get row (trial) of each time
    timer7end=reshape(timer7timesend,[],1); % make single column
    [timer7trialsend,timer7trialidxend]=sort(timer7idxend); % sort by trial
    timer7end=timer7end(timer7trialidxend);

%     timer8times = a.GlobalTimer8_Start(a.file==ff,:)+a.startTime(a.file==ff); % set relative to all of Bpod
%     [timer8idx,~]=find(timer8times); % get row (trial) of each time
%     timer8=reshape(timer8times,[],1); % make single column
%     [timer8trials,timer8trialidx]=sort(timer8idx); % sort by trial
%     timer8=timer8(timer8trialidx);
% 
%     timer8timesend = a.GlobalTimer8_End(a.file==ff,:)+a.startTime(a.file==ff); % set relative to all of Bpod
%     [timer8idxend,~]=find(timer8timesend); % get row (trial) of each time
%     timer8end=reshape(timer8timesend,[],1); % make single column
%     [timer8trialsend,timer8trialidxend]=sort(timer8idxend); % sort by trial
%     timer8end=timer8end(timer8trialidxend);
    
    imagingEndTimes=a.endTime(a.file==ff);
    timer7nan=isnan(timer7);
    timer7endnan=isnan(timer7end);
    timer7end(timer7endnan~=timer7nan) = imagingEndTimes(timer7trialsend(timer7endnan~=timer7nan));

%     timer8nan=isnan(timer8);
%     timer8endnan=isnan(timer8end);
%     timer8end(timer8endnan~=timer8nan) = imagingEndTimes(timer8trialsend(timer8endnan~=timer8nan));

    timer7all = sort([timer7(~isnan(timer7)); timer7end(~isnan(timer7end))]);
%     timer8all = sort([timer8(~isnan(timer8)); timer8end(~isnan(timer8end))]);

    Bpodtimer7 = timer7(~isnan(timer7));
%     Bpodtimer8 = timer8(~isnan(timer8));
    Bpodtimer7end = timer7end(~isnan(timer7end));
%     Bpodtimer8end = timer8end(~isnan(timer8end));
    Bpodtimer7trials = timer7trials(~isnan(timer7));
%     Bpodtimer8trials = timer8trials(~isnan(timer8));
    Bpodtimer7trialsend = timer7trialsend(~isnan(timer7end));
%     Bpodtimer8trialsend = timer8trialsend(~isnan(timer8end));

    timer7alltrials = sort([timer7trials(~isnan(timer7)); timer7trialsend(~isnan(timer7end))]);
%     timer8alltrials = sort([timer8trials(~isnan(timer8)); timer8trialsend(~isnan(timer8end))]);

%     BpodTimersAll = sort([timer7all;timer8all]);
    BpodTimersAll = sort(timer7all);     

                if sum(mouse=='JB484')==5 & sum(day == '20240412')==8 % for 426 3/02!!!!!!
                    BpodTimersAll=[BpodTimersAll(1:55586); BpodTimersAll(55589:end)];
                end

                if sum(mouse=='JB482')==5 & sum(day == '20240416')==8 % for 426 3/02!!!!!!
                    BpodTimersAll=[BpodTimersAll(1:64399); BpodTimersAll(64402:end)];
                end 
                if sum(mouse=='JB483')==5 & sum(day == '20240529')==8 % for 426 3/02!!!!!!
                    BpodTimersAll=[BpodTimersAll(1:43288); BpodTimersAll(43291:end)];
                end
                if sum(mouse=='JB483')==5 & sum(day == '20240614')==8 % for 426 3/02!!!!!!
                    BpodTimersAll=[BpodTimersAll(1:30676); BpodTimersAll(30679:end)];
                end                
%                 if sum(mouse=='JB484')==5 & sum(day == '20240614')==8 % for 426 3/02!!!!!!
%                     BpodTimersAll=[BpodTimersAll(1:32938); BpodTimersAll(32941:end)];
%                 end
%                 if sum(mouse=='JB484')==5 & sum(day == '20240619')==8 % for 426 3/02!!!!!!
%                     BpodTimersAll=[BpodTimersAll(1:14088); BpodTimersAll(14091:end)];
%                 end 
    if ff==2
                if sum(mouse=='JB509')==5 & sum(day == '20250205')==8 % for 426 3/02!!!!!!
                    BpodTimersAll=[BpodTimersAll(1:28492); BpodTimersAll(28495:end)];
                end
    end

   BpodFile(1:numel(BpodTimersAll),1)=ff;

    a.BpodFile=[a.BpodFile;BpodFile];
    a.BpodSyncTimers = [a.BpodSyncTimers;BpodTimersAll];
    
    a.BpodTimersAll = [a.BpodTimersAll; BpodTimersAll];
    BpodTimersAllRel = BpodTimersAll - BpodTimersAll(1);
%     a.BpodTimersAllRel = [a.BpodTimersAllRel;BpodTimersAllRel];    
   end

%% CHECK SYNC
%     ff=2;
    for ff=1:numel(Bpodfiles)
        
   % To Find Skipped Signals, uncomment and run this section, editing the Bpod timers to skip as above, until clear linear plot of DAQ-Bpod sync difference with total <100ms
%    for ff=1:numel(Bpodfiles) % Comment this out


%     BpodTimers=a.BpodTimersAll(a.BpodFile==ff);
%     BpodTimers=BpodTimers-BpodTimers(1);
%     % Bpod vs DAQ
%     if ~isempty(DAQfiles)
%     DAQframes=a.DAQFrames(a.DAQFramesFile==ff);
%     DAQFramesRel = DAQframes-DAQframes(1);
%     BpodDAQAll=a.DAQSync(a.DAQFile==ff);
%     BpodDAQAllRel=BpodDAQAll-BpodDAQAll(1);
%     if numel(BpodDAQAllRel)<numel(BpodTimers)
%         disp('Too many Bpod sync signals!')
%         BpodDAQDiff = BpodTimers(1:numel(BpodDAQAllRel))-BpodDAQAllRel;
%         BpodTimers=BpodTimers(1:numel(BpodDAQAllRel));            
%     end
% 
% 
%     BpodDAQDiff = BpodTimers-BpodDAQAllRel(1:numel(BpodTimers));
%     %         BpodDAQDiff = BpodTimers(1:numel(BpodDAQAllRel))-BpodDAQAllRel;
%     %         BpodTimers=BpodTimers(1:numel(BpodDAQAllRel));
% 
%     figure();
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0 0 11 8.5];
%     %     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     ax = nsubplot(1,1,1,1);
%     plot(BpodTimers,BpodDAQDiff,'.');
%     xlabel('Bpod time (s)');
%     ylabel('Difference in timestamp between DAQ and Bpod Sync Signals (s)');
%     title(fname,'Interpreter', 'none');
%     saveas(fig,fullfile(output_dir,[nameroot,'_file_',num2str(ff),'_BpodDAQalignment']),'pdf');
%     
%     test=diff(BpodTimersAllRel);
%     test2=diff(BpodDAQDiff);
%     test3=round(test,2);
%     test4=round(diff(BpodDAQAllRel),2);
%     test5=diff(BpodDAQDiff);
%     find(abs(test2)>0.05,1,'first')
% 
%     end
    
    %%
        BpodTimers=a.BpodTimersAll(a.BpodFile==ff);
        BpodTimers=BpodTimers-BpodTimers(1);
        % Bpod vs DAQ
        if ~isempty(DAQfiles)
        DAQframes=a.DAQFrames(a.DAQFramesFile==ff);
        DAQFramesRel = DAQframes-DAQframes(1);
        BpodDAQAll=a.DAQSync(a.DAQFile==ff);
        BpodDAQAllRel=BpodDAQAll-BpodDAQAll(1);
        if numel(BpodDAQAllRel)<numel(BpodTimers)
            disp('Too many Bpod sync signals!')
            BpodDAQDiff = BpodTimers(1:numel(BpodDAQAllRel))-BpodDAQAllRel;
            BpodTimers=BpodTimers(1:numel(BpodDAQAllRel));            
        end
        

        BpodDAQDiff = BpodTimers-BpodDAQAllRel(1:numel(BpodTimers));
%         BpodDAQDiff = BpodTimers(1:numel(BpodDAQAllRel))-BpodDAQAllRel;
%         BpodTimers=BpodTimers(1:numel(BpodDAQAllRel));

        figure();
        fig = gcf;
        fig.PaperUnits = 'inches';
        fig.PaperPosition = [0 0 11 8.5];
        %     set(fig,'renderer','painters');
        set(fig,'PaperOrientation','landscape');
        ax = nsubplot(1,1,1,1);
        plot(BpodTimers,BpodDAQDiff,'.');
        xlabel('Bpod time (s)');
        ylabel('Difference in timestamp between DAQ and Bpod Sync Signals (s)');
        title(fname,'Interpreter', 'none');
        saveas(fig,fullfile(output_dir,[nameroot,'_file_',num2str(ff),'_BpodDAQalignment']),'pdf');
    %     close gcf;
        end

        % SCOPE v Bpod    
        if ~isempty(GPIOfiles)&numel(GPIOfiles)>=ff
            scopeframes=a.GPIOFrames(a.GPIOFile==ff);
            ScopeFramesRel=scopeframes-scopeframes(1);
            GPIOsync=a.GPIOSync(a.GPIOFile==ff);
            BpodScopeAllRel = GPIOsync-GPIOsync(1);
            BpodScopeDiff = BpodTimers-BpodScopeAllRel(1:numel(BpodTimers));

            figure();
            fig = gcf;
            fig.PaperUnits = 'inches';
            fig.PaperPosition = [0 0 11 8.5];
            %     set(fig,'renderer','painters');
            set(fig,'PaperOrientation','landscape');
            ax = nsubplot(1,1,1,1);        
            plot(BpodTimers,BpodScopeDiff,'.');
            title(fname,'Interpreter', 'none');
            xlabel('Bpod time (s)');
            ylabel('Difference in timestamp between nVista and Bpod Sync Signals (s)');
            saveas(fig,fullfile(output_dir,[nameroot,'_file_',num2str(ff),'_BpodScopealignment']),'pdf');
    %     close gcf;
        end

        % FRAMES
        if and(~isempty(DAQfiles),~isempty(GPIOfiles))
        FrameCt = min([numel(DAQFramesRel) numel(ScopeFramesRel)]);
        FrameDiff = DAQFramesRel(1:FrameCt) - ScopeFramesRel(1:FrameCt);  

        figure();
        fig = gcf;
        fig.PaperUnits = 'inches';
        fig.PaperPosition = [0 0 11 8.5];
        %     set(fig,'renderer','painters');
        set(fig,'PaperOrientation','landscape');
        ax = nsubplot(1,1,1,1); 
        plot(ScopeFramesRel(1:FrameCt),FrameDiff,'.');
        title(fname,'Interpreter', 'none')
        xlabel('nVista time (s)');
        ylabel('Difference in timestamp between nVista and DAQ Frame Sync Signals (s)');
        saveas(fig,fullfile(output_dir,[nameroot,'_file_',num2str(ff),'_DAQScopealignment']),'pdf');
    %     close gcf;
        end
    
   end

        %% CLEAR LARGE DATA
            clearvars -except a m d mice days params session loadVars expandVars output_dir SyncDir nfiles neuroFiles baseDir neuroDir nameroot mice fname filepath f DAQfiles GPIOfiles Bpodfiles BpodDir infoseekdir

        %% SYNC NEURAL DATA

            if params.syncDev == 1
                a.frameTimes = a.GPIOFrames;
                a.frameFile = a.GPIOFile;
            else
                if isfield(a,'DAQFrames')
                a.frameTimes = a.DAQFrames;
                a.frameFile = a.DAQFile;
                else
                a.frameTimes = a.GPIOFrames;
                a.frameFile = a.GPIOFile;            
                end
            end

            a.frameCount = size(a.frameTimes,1);

            disp('Loading neural data.');
            load(fullfile(neuroDir,neuroFiles(f).name));
            parts = split(neuroFiles(f).name,'_');

            [a.neuronCt,a.neuronFrames] = size(neuron.C); 

            sessionfileloc=find(strcmp(session.mouse,parts{1})&strcmp(session.date,parts{2}));
            session.cellcount(sessionfileloc)=a.neuronCt;


            if a.neuronFrames<a.frameCount % neural data for only part of session (< behavior), maybe bad video, only partial recording-->DAQ recorded frames before scope could start? or scope recording stopped before behavior
               if params.syncDev == 2
                   if numel(Bpodfiles)==1
                   disp('Fewer neural/scope frames than DAQ.'); 
                   firstFrame = a.frameCount-a.neuronFrames;
                   firstFrameTime = a.frameTimes(firstFrame);
                   a.frameTimes = a.frameTimes(firstFrame+1:end);
            %        a.frameTimes = a.frameTimes(1:end-firstFrame);
            %        a.DAQFramesFile = a.DAQFramesFile(1:end-firstFrame);
                   a.frameCount = size(a.frameTimes,1);
                   trialStarts = a.startTime(a.imagingTrials);
                   trialStops = a.endTime(a.imagingTrials);
                   lastTrial = min(find(trialStops>a.frameTimes(end)));
                   firstTrial = min(find(trialStarts>firstFrameTime));
                   a.imagingTrials(find(a.imagingTrials)<firstTrial) = 0; 
                   else
                       disp('Fewer neural frames than behavior but multifile! STOP HERE!!!!!');
                   end
               else
                   if a.frameCount==a.neuronFrames+1
                       a.frameTimes=a.frameTimes(2:end);
                       a.frameCount = size(a.frameTimes,1);
                       a.GPIOFramesFile = a.GPIOFramesFile(2:end);
                   end
               end
            end

            if a.frameCount>a.neuronFrames
                disp('More behavior frames than neural data!!!')
                if numel(Bpodfiles)==1
                if a.neuronFrames == a.frameCount+numel(a.imagingFiles)
                    a.C_smoothed = neuron.C(:,2:end);
                    a.C_raw = neuron.C_raw(:,2:end);       
                end
                a.C_smoothed = neuron.C(:,1:a.frameCount);
                a.C_raw = neuron.C_raw(:,1:a.frameCount);
                else
                    disp('And multiple files!!!! STOP HERE!!!!!')
                end
            else
                a.C_smoothed = neuron.C;
                a.C_raw = neuron.C_raw;
            end   

            params.Fs = neuron.Fs;

        %% NEURAL ACTIVITY MATRIX (RAW VS SMOOTHED)

            if params.smoothed==1
                a.C = a.C_smoothed;
            else
                a.C=a.C_raw;
            end


        %% NORMALIZE CELL ACTIVITY

            if params.normalize == 1
                % 1 value per cell
                uactivity_max = nan*ones(a.neuronCt,1);
                uactivity_mean = nan*ones(a.neuronCt,1);
                uactivity_std = nan*ones(a.neuronCt,1);
                for u = 1:a.neuronCt
                    uactivity_max(u) = max(a.C(u,:));
                    uactivity_mean(u) = mean(a.C(u,:));
                    uactivity_std(u) = std(a.C(u,:));
                    uactivity_min(u) = min(a.C(u,:));
                    a.C_norm(u,:) = ((a.C(u,:) - uactivity_mean(u)) ./ uactivity_std(u)) - uactivity_min(u);
                end
                a.C = a.C_norm;
            end

        %% SET PSTH WINDOW PARAMS

        %     % set the analysis interval for PSTH's
        %     a.interval = 2000;
            a.framesAround = params.interval/1000*neuron.Fs;
        % 
        %     a.events = {'trialStart'; 'centerEntry'; 'odor1'; 'centerExit';...
        %         'sideEntry'; 'odor2'; 'outcome'; 'odor1all'; 'odor1first'; 'baseline';'total'; 'leaving'};
        %     a.intervals = [2000,2000,2000,2000,2000,2000,2000,2000,2000,2000,18000,2000];
        %     % a.intervals = [1000,1000,1000,1000,1000,12000,1000,1000,1000,1000];
            a.framesAroundEvent = params.intervals./1000*neuron.Fs;
        % 
        %     a.baselineParam = 2; %seconds before trial start for baseline (during ITI presumably)

        %% PSTH MATRIX
            disp('Calculating PSTHs.');
            % need to put events into Bpod total time not trial time
            % what about multiple files? entries/exits??

            % a.BpodSyncTimers,a.GPIOSync,a.DAQSync, a.frameTimes all have size(1,f)

            for e = 1:size(params.events)
                a.C_events{e} = NaN(a.neuronCt,2*a.framesAroundEvent(e),sum(a.imagingTrials));
            end

            a.BpodEventTime = NaN(sum(a.imagingTrials),numel(params.events));
            a.eventTime = NaN(sum(a.imagingTrials),numel(params.events));
            a.odor1All = NaN(sum(a.imagingTrials),size(a.CenterOdor,2)/2);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START BY FILE HERE

            a.imagingTrialsList = find(a.imagingTrials);
        %     a.imagingTrialsList = trials; % break this down by files!
            for tt = 1:sum(a.imagingTrials)
                t = a.imagingTrialsList(tt); %
                trialStart = a.startTime(t);

               % TRIAL START
                a.BpodEventTime(tt,1) = a.StartTrial(t,1)+trialStart;
                a.BpodEventTime(tt,10) = a.BpodEventTime(tt,1) - params.baselineParam; % "BASELINE"

                % CENTER ENTRY
                % THIS FINDS LAST CENTER ENTRY OF TRIAL (CENTER ENTRY GO)
                a.BpodEventTime(tt,2) = a.CenterDelay(t,a.centerEntryCount(t)*2-1)+trialStart;   

                % ODOR 1
                a.BpodEventTime(tt,3) = a.CenterOdor(t,a.centerEntryCount(t)*2-1)+trialStart;
                a.BpodEventTime(tt,11) = a.CenterOdor(t,a.centerEntryCount(t)*2-1)+trialStart;

                % ODOR 1 FIRST
                a.BpodEventTime(tt,9) = a.CenterOdor(t,1)+trialStart;        

                % ODOR 1 ALL!!
                a.odor1All(tt,:) = a.CenterOdor(t,1:2:end)+trialStart;
            %     a.odor1All = vertcat(a.odor1All{:,:});
                odor1All = NaN(a.neuronCt,a.framesAroundEvent(8)*2,size(a.odor1All,1));

                % CENTER EXIT
                a.BpodEventTime(tt,4) = a.centerExitGo(t,1)+trialStart;

                % CENTER EXIT FIRST
                a.BpodEventTime(tt,13) = a.centerExitFirst(t,1)+trialStart;        

                % SIDE ENTRY
                a.BpodEventTime(tt,5) = a.choice(t,1)+trialStart;

                % ODOR 2
                a.BpodEventTime(tt,6) = a.odor2On(t,1)+trialStart;

                % SIDE EXIT
                a.BpodEventTime(tt,12) = a.odor2LeavingTime(t,1)+trialStart;

                % TONE
                a.BpodEventTime(tt,14) = a.toneOn(t,1)+trialStart;

                % OUTCOME
                if ~isnan(a.OutcomeDelivery(t,1))
                    a.BpodEventTime(tt,7) = a.OutcomeDelivery(t,1)+trialStart;
                else
                    a.BpodEventTime(tt,7) = a.TimeoutOutcome(t,1)+trialStart;
                end

            end

            for ff=1:numel(Bpodfiles)
                % PULL SYNC DATA
                if params.syncDev == 1
                   devsync = a.GPIOSync(a.GPIOFile==ff);
                   fileFrames = a.frameTimes(a.GPIOFramesFile==ff)';
                else
                    if numel(DAQfiles)==1
                   devsync = a.DAQSync(a.DAQFile==ff);
                   fileFrames = a.frameTimes(a.DAQFramesFile==1)';
                    else
                        disp('ERROR: check daqfiles!!')
                   devsync = a.DAQSync(a.DAQFile==ff);
                   fileFrames = a.frameTimes(a.DAQFramesFile==ff)';                
                    end
                end
                BpodSync = a.BpodSyncTimers(a.BpodFile==ff);

                trials=a.imagingTrialsList(a.file==ff);
                for t=1:sum(a.imagingTrials&a.file==ff)
                    tt=trials(t);
                for e=1:numel(params.events)
                    if e~=8 % all except odor1all
                        % find closest sync event in Bpod timescale
                        if ~isnan(a.BpodEventTime(tt,e))
                        BpodEventTime = a.BpodEventTime(tt,e);
                        % this finds sync event within Bpod file/session
                        [syncTimeDiff,syncEvent] = min(abs(BpodEventTime - BpodSync));
                        % use file dev sync
                        a.eventTime(tt,e) = devsync(syncEvent) + (BpodEventTime - BpodSync(syncEvent));

                        % FIND CLOSEST FRAME
                        frameEventDiff=fileFrames-a.eventTime(tt,e);
                        frameEventDiff(frameEventDiff<0)=inf;
                        [~,frameEventIdx(tt,e)] = min(frameEventDiff,[],2);
                        okFrames = ones(1,a.framesAroundEvent(e)*2);
                        eventFrames = frameEventIdx(tt,e)-a.framesAroundEvent(e):frameEventIdx(tt,e)+a.framesAroundEvent(e)-1;
                        % make sure not butting up against start or end of behavior session
                        % (bad if >file framecount
                        okFrames(eventFrames<=0)=0;
                        okFrames(eventFrames>size(fileFrames,2))=0;
                        a.C_events{1,e}(:,okFrames==1,tt) = a.C(:,eventFrames(okFrames==1));
                        end


                    else % odor1all
                        e=8;
                        odor1starts = a.odor1All(tt,:);
                        for i = 1:sum(~isnan(odor1starts))
                            BpodEventTime = odor1starts(i);
                            [syncTimeDiff,syncEvent] = min(abs(BpodEventTime - BpodSync));
                            a.odor1Time{tt,i} = devsync(syncEvent) + (BpodEventTime - BpodSync(syncEvent));
                            % FIND CLOSEST FRAME
                            frameEventDiff=fileFrames-a.odor1Time{tt,i};
                            frameEventDiff(frameEventDiff<0)=inf;
                            [~,frameEventIdx(tt,e)] = min(frameEventDiff,[],2);
                            okFrames = ones(1,a.framesAroundEvent(e)*2);
                            eventFrames = frameEventIdx(tt,e)-a.framesAroundEvent(e):frameEventIdx(tt,e)+a.framesAroundEvent(e)-1;
                            % make sure not butting up against start or end of behavior session
                            % (bad if >file framecount
                            okFrames(eventFrames<=0)=0;
                            okFrames(eventFrames>size(fileFrames,2))=0;
                            activity = NaN(a.neuronCt,a.framesAroundEvent(e)*2);
                            activity(:,okFrames==1)=a.C(:,eventFrames(okFrames==1));
                            odor1AllActivity{tt,i} = activity;
                        end
            %                 a.odor1mean(tt) = nanmean(
            %                 a.C_events{1,e}(:,okFrames==1,tt) = a.C(:,eventFrames(okFrames==1));
                    end
                end
                a.C_odor1AllActivity{tt,1} = cat(3,odor1AllActivity{tt,:});
                a.C_odor1Mean(:,:,tt) = mean(a.C_odor1AllActivity{tt,1},3,'omitnan');
                a.C_events{1,8} = a.C_odor1Mean;
                end
            end

            % PSTHs
            a.timeToOdor=a.BpodEventTime(:,6)-a.BpodEventTime(:,3);

            c.C_baseline = a.C_events{1,10};
            c.C_trialStart = a.C_events{1,1};
            c.C_centerEntry = a.C_events{1,2};
            c.C_centerExit = a.C_events{1,4};
            c.C_centerExitFirst = a.C_events{1,13};
            c.C_odor1 = a.C_events{1,3};
            c.C_odor1All = a.C_events{1,8};
            c.C_odor1First = a.C_events{1,9};
        %     c.odor1AllActivity = a.C_odor1AllActivity;
            c.C_odor1Mean=a.C_odor1Mean;
            c.C_sideEntry = a.C_events{1,5};
            c.C_odor2 = a.C_events{1,6};
            c.C_sideExit = a.C_events{1,12};
            c.C_tone = a.C_events{1,14};
            c.C_outcome = a.C_events{1,7};
            c.C_trial = a.C_events{1,11};

            % TRIAL-LEVEL METRICS
            c.mouse = a.mouse;
            c.day = a.day;
        %     c.params = params;
            c.imagingTrialNum = find(a.imagingTrials==1);
            c.imagingTrials = a.imagingTrials;
            c.rxn = a.rxn(a.imagingTrials==1);
            c.odor2type = a.odor2type(a.imagingTrials==1);
            c.timeToOdor = a.timeToOdor;
            c.reward = a.reward(a.imagingTrials==1);
            c.info = a.info(a.imagingTrials==1);
            c.big = a.big(a.imagingTrials==1);
            c.rewardParams = a.rewardParams(a.imagingTrials==1,:);
            c.infoSide = a.infoSide(a.imagingTrials==1);
            c.bigSide = a.bigSide(a.imagingTrials==1);
%             c.errorTypes = a.errorTypes(a.imagingTrials==1);
            c.centerEntryCount = a.centerEntryCount(a.imagingTrials==1);
            c.centerExitGo=a.BpodEventTime(a.imagingTrials==1,4);
            c.sideEntry=a.BpodEventTime(a.imagingTrials==1,5);
            c.centerOdor = a.BpodEventTime(a.imagingTrials==1,11);

            %% TRIAL TYPES

            c.imagingCorr = a.correct==1 & a.imagingTrials == 1;
            c.imageTrialType = a.trialType(a.imagingTrials==1);
            % odor2
            c.imagingOdor2 = a.odor2type(a.imagingTrials==1);
            c.imagingPrevOutcome = NaN(sum(a.imagingTrials),1);
            c.imagingPrevCorrect = NaN(sum(a.imagingTrials),1);
            for ff=1:numel(Bpodfiles)
                filetrials=find(a.imagingTrials(a.file==ff));
                trials=a.imagingTrialsList(a.file==ff);
            for t = 1:sum(a.imagingTrials&a.file==ff)
                tt=trials(t);
                tf=filetrials(t);
                if tf-1>0
                   c.imagingPrevOutcome(tt,1) = a.outcome(t-1);
                   c.imagingPrevCorrect(tt,1) = a.correct(t-1);
                else
                end
            end
            end
            c.imagingOutcome = a.outcome(a.imagingTrials==1);

            %% TRIAL CHOICE TYPE

            % 1 = small, 2 = info forced, 3 = rand forced, 4 = big
            % correct only? no choice?
            c.imagingChoice = NaN(sum(a.imagingTrials,1),1);
            c.imagingChoice(ismember(c.imagingOutcome,[2 3]) )= 1;
            c.imagingChoice(ismember(c.imagingOutcome,[6 7 8 9])) = 2;
            c.imagingChoice(ismember(c.imagingOutcome,[12 13 14 15])) = 3;
            c.imagingChoice(ismember(c.imagingOutcome,[18 19])) = 4;

        %%    
        disp('Saving processed neural data.');
        names=strsplit(fname,'_');
        if params.normalize==1
            save(fullfile(output_dir,[names{1},'_',names{2},'_neuralNORMZ.mat']),'-struct','c','-v7.3');
        else
            save(fullfile(output_dir,[names{1},'_',names{2},'_neural.mat']),'-struct','c','-v7.3');
        end
        save(fullfile(infoseekdir,['BpodInfoseekSessionsNORMZ_',params.dataset{1},'.mat']),'session');
        save(fullfile(output_dir,['Params_NORMZ' nameroot '.mat']),'-struct','params');


        clear a
        clear c
        end
    end

% end