%% BehaviordataBpod
% Loads pre-processed Bpod behavior data files for a designated
% experimental group and saves the concatenated data to a .mat file

%%
clear; close all;

% utility function finds the Bpod data folder on disk. Substitute with
% manually inputting a data path
datapath=findInfoseekData();

% load the settings file (here input manually) for a particular cohort
% "dataset" with a list of mice and the Bpod protocols used
summarySettings=load(fullfile(datapath,'BpodInfoseekSummarySettingsWTAll.mat'));

dataset = summarySettings.dataset;
mouseList = summarySettings.mouseList;
protocol = summarySettings.protocol;

files=dir('random');
for m=1:numel(mouseList)
   for p=1:numel(protocol)
      filename=[mouseList{m} '_' protocol{p} '*pp.mat'];
      files=[files; dir(fullfile(datapath,'**/*',filename))];
   end
end

filesT=struct2table(files);
filesUnique=unique(filesT);

%%

numFiles = size(filesUnique,1);

% Manually selecting variables to load from the processed Bpod files to
% save space
loadVars={'mouse','day','trial','correct','info',...
    'outcome','trialType','trialTypes','infoSide','reward',...
    'rxn','trialLength','trialLengthCenterEntry','trialLengthTotal','odorDelay','rewardDelay',...
    'rewardParams','odorAtrials','odorBtrials','odorCtrials','odorDtrials',...
    'odor2On','anticipatoryInfoLicks','anticipatoryRandLicks',...
    'earlyInfoLicks','earlyRandLicks','waterInfoLicks','waterRandLicks',...
    'Port2','infoPort','randPort','odor2LeavingTime','centerEntryCount',...,
    'trialSettings.OdorTime','StartTrial','CenterDelay'}; 


% Concatenate data across all files
for f=1:numFiles
   b=load(fullfile(filesUnique.folder{f},filesUnique.name{f}));
   trialCt=b.trialCt;
   b.file(1:trialCt,1)=f;  
   
   if exist('a','var') == 0
       for i = 1:numel(loadVars)
           if contains(loadVars{i},'.')
               str1=loadVars{i}(1:strfind(loadVars{i},'.')-1);
               str2=loadVars{i}(strfind(loadVars{i},'.')+1:end);
              a.(str1).(str2)=[b.(str1).(str2)]';
           else
               if strcmp(loadVars{i},'CenterDelay')
                   a.centerEntryFirst = b.CenterDelay(:,1);
               else
                    a.(loadVars{i})=b.(loadVars{i}); 
               end
               a.file=b.file;
           end
       end
   else
       for i = 1:numel(loadVars)
           if contains(loadVars{i},'.')
               str1=loadVars{i}(1:strfind(loadVars{i},'.')-1);
               str2=loadVars{i}(strfind(loadVars{i},'.')+1:end);
               a.(str1).(str2)=cat(1,a.(str1).(str2),b.(str1).(str2));
           else
               if strcmp(loadVars{i},'CenterDelay')
                   a.centerEntryFirst=cat(1,a.centerEntryFirst,b.CenterDelay(:,1));
               else
                   a.(loadVars{i})=cat(1,a.(loadVars{i}),b.(loadVars{i}));
               end
           end
       end
       a.file=cat(1,a.file,b.file);
   end
   sessions(f)=b.session; % ensure not a duplicate!! need to load session table
   b=[];
   trialCt=[];
end

% a.ITI=a.trialSettings.Interval;
% a.gracePeriod=a.trialSettings.GracePeriod;
a.odorTime = a.trialSettings.OdorTime;
a = rmfield( a , 'trialSettings' );
a.sessions=sessions;

%% SAVE FILE

save(fullfile(datapath,'behaviorMiceBpodPorts6.mat'),'-struct','a','-v7.3');
