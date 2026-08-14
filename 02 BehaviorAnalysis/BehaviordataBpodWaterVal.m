%% BehaviordataBpod
% Loads pre-processed Bpod behavior data files for a designated
% experimental group in the 4-center port odor information vs water value
% task and saves the concatenated data to a .mat file

%%
clear; close all;

datapath=findInfoseekData();

summarySettings=load(fullfile(datapath,'BpodInfoseekSummarySettingsWaterVal.mat'));

dataset = summarySettings.dataset;
mouseList = summarySettings.mouseList;
protocol = summarySettings.protocol;

files=dir('random');
for m=1:numel(mouseList)
   for p=1:numel(protocol)
      filename=[mouseList{m} '_' protocol{p} '*waterpp.mat'];
      files=[files; dir(fullfile(datapath,'**/*',filename))];
   end
end

filesT=struct2table(files);
filesUnique=unique(filesT);

%%

numFiles = size(filesUnique,1);

loadVars={'mouse','day','trial','correct','info','big',...
    'outcome','trialType','trialTypes','infoSide','bigSide','reward',...
    'rxn','trialLength','trialLengthCenterEntry','trialLengthTotal','odorDelay','rewardDelay',...
    'rewardParams','toneOn','odorAtrials','odorBtrials','odorCtrials','odorDtrials',...
    'odor2On','Port2','infoPort','randPort','Port1','Port3','odor2LeavingTime','centerEntryCount',...,
    'trialSettings.OdorTime','StartTrial','CenterDelay'}; 


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

%%

save(fullfile(datapath,'behaviorMiceBpodWaterVal2.mat'),'-struct','a','-v7.3');