clear all; close all;

rng('shuffle')

set(0,'DefaultFigureWindowStyle','docked'); % plot in docked window

%% DATA FOLDER

datapath=uigetdir('','Choose data directory');
% datapath = 'D:\Bussell Dropbox\Bussell Labe\BpodInfoseek\Analysis\Learning';

% plotfolder
if exist(fullfile(datapath,'plots'))
    plotfolder=fullfile(datapath,'plots');
else
    mkdir(fullfile(datapath,'plots'))
    plotfolder=fullfile(datapath,'plots');
end

%% LOAD PARAMS

params=load(fullfile(datapath,'InfoseekNeuroAnalysisParams.mat'));

%% LOAD DATASET INFO (SESSION TABLE)

load(fullfile(datapath,['BpodInfoseekSessions_',params.dataset{1},'.mat']));

%% SAVING

% output_dir = 'D:\Dropbox\BpodInfoseek\Analysis\Graphs';
output_dir = plotfolder;

%% SET OR SELECT SESSIONS TO LOAD

% mice = {'JB425','JB426','JB432'};
% days = {{'20220105','20220106','20220119','20220120','20220203','20220207'},{'20220126','20220127','20220131','20220201','20220302','20220303'},{'20220429','20220506','20220527'}};
% conditions = {{{'20220105','20220106'},{'20220119','20220120'},{'20220203','20220207'}},{{'20220126','20220127'},{'20220131','20220201'},{'20220302','20220303'}},{{'20220429'},{'20220506'},{'20220527'}}};

% mice = {'JB424'};
% days = {{'20220527','20220531','20220606','20220607'}};
% conditions = {{{'20220606','20220607'},{'20220527','20220531'}}};
% mice = {'JB425'};
% days = {{'20220518','20220519','20220607','20220609'}};
% conditions = {{{'20220607','20220609'},{'20220518','20220519'}}};
% mice = {'JB431'};
% days = {{'20220518','20220519','20220607','20220609'}};
% conditions = {{{'20220518','20220519'},{'20220607','20220609'}}};

% % ORIGINAL DELAY VALUE
% mice = {'JB426','JB432','JB433','JB434'};
% days = {{'20220616','20220617','20220711','20220713'},... % long short
%     {'20220623','20220627','20220706','20220707'},... % long short
%     {'20220629','20220630','20220708','20220711'},...% SHORT LONG
%     {'20220812','20220817','20220824','20220825'}}; % long short
% conditions = {{{'20220711','20220713'},{'20220616','20220617'}},... % short long
%     {{'20220706','20220707'},{'20220623','20220627'}},...
%     {{'20220629','20220630'},{'20220708','20220711'}},...
%     {{'20220824','20220825'},{'20220812','20220817'}}};
% conditionNames = {'Short Delay','Long Delay'};

% THIS IS THE MAIN ONE!!
% ALL MICE ORIGINAL DELAY VALUE
mice = {'JB424','JB425','JB426','JB432','JB433','JB434'};
days = {{'20220527','20220531','20220606','20220607'},... % long short
    {'20220518','20220519','20220607','20220609'},... % long short
    {'20220616','20220617','20220711','20220713'},... % long short
    {'20220623','20220627','20220706','20220707'},... % long short
    {'20220629','20220630','20220708','20220711'},...% SHORT LONG
    {'20220812','20220817','20220824','20220825'}}; % long short
conditions = {{{'20220606','20220607'},{'20220527','20220531'}},...
    {{'20220607','20220609'},{'20220518','20220519'}},...
    {{'20220711','20220713'},{'20220616','20220617'}},... % short long
    {{'20220706','20220707'},{'20220623','20220627'}},...
    {{'20220629','20220630'},{'20220708','20220711'}},...
    {{'20220824','20220825'},{'20220812','20220817'}}};
conditionNames = {'Short Delay','Long Delay'};

% NEW MICE ORIGINAL DELAY VALUE
% mice = {'JB506','JB507','JB509'};
% days = {{'20241205','20241206','20241212','20241213','20250109','20250110'},... % long short medium
%     {'20241205','20241206','20241212','20241213','20250109','20250110'},... % long short med
%     {'20250109','20250110','20250114','20250115','20250124','20250127'}}; % med short long
% conditions = {{{'20241212','20241213'},{'20241205','20241206'},{'20250109','20250110'}},... % short long med
%     {{'20241212','20241213'},{'20241205','20241206'},{'20250109','20250110'}},... % short long med
%     {{'20250114','20250115'},{'20250124','20250127'},{'20250109','20250110'}}}; % short long med
% conditionNames = {'Short Delay','Long Delay','Med Delay'};
% mice = {'JB506','JB507'};
% days = {{'20241205','20241206','20241212','20241213','20250109','20250110'},... % long short medium
%     {'20241205','20241206','20241212','20241213','20250109','20250110'},... % long short med
%     }; % med short long
% conditions = {{{'20241212','20241213'},{'20241205','20241206'},{'20250109','20250110'}},... % short long med
%     {{'20241212','20241213'},{'20241205','20241206'},{'20250109','20250110'}},... % short long med
%     }; % short long med
% conditionNames = {'Short Delay','Long Delay','Med Delay'};



% % BACKWARDS DELAY VALUE ALL MICE
% mice = {'JB424','JB425','JB426','JB432','JB433','JB434'};
% days = {{'20220606','20220607','20220616','20220617'},... % long short
%     {'20220607','20220609','20220616','20220617'},... % long short
%     {'20220711','20220713','20220728','20220729'},... % long short
%     {'20220706','20220707','20220727','20220728'},... % long short
%     {'20220629','20220630','20220708','20220711'},...% long short
%     {'20220824','20220825','20220906','20220907'}}; % long short
% conditions = {{{'20220606','20220607'},{'20220616','20220617'}},...
%     {{'20220607','20220609'},{'20220616','20220617'}},...
%     {{'20220711','20220713'},{'20220728','20220729'}},... % short long
%     {{'20220706','20220707'},{'20220727','20220728'}},...
%     {{'20220629','20220630'},{'20220708','20220711'}},...
%     {{'20220824','20220825'},{'20220906','20220907'}}};
% conditionNames = {'Short Delay1','Long Delay2'};

% % BACKWARDS DELAY VALUE ALL MICE
% mice = {'JB424','JB425','JB426','JB432','JB433','JB434'};
% days = {{'20220606','20220607','20220616','20220617'},... % long short
%     {'20220607','20220609','20220616','20220617'},... % long short
%     {'20220711','20220713','20220728','20220729'},... % long short
%     {'20220706','20220707','20220727','20220728'},... % long short
%     {'20220629','20220630','20220708','20220711'},...% long short
%     {'20220824','20220825','20220906','20220907'}}; % long short
% conditions = {{{'20220606','20220607'},{'20220616','20220617'}},...
%     {{'20220607','20220609'},{'20220616','20220617'}},...
%     {{'20220711','20220713'},{'20220728','20220729'}},... % short long
%     {{'20220706','20220707'},{'20220727','20220728'}},...
%     {{'20220629','20220630'},{'20220708','20220711'}},...
%     {{'20220824','20220825'},{'20220906','20220907'}}};
% conditionNames = {'Short Delay1','Long Delay2'};


% % % BEFORE AND AFTER VALUE ALL MICE
% mice = {'JB424','JB425','JB426','JB432','JB433','JB434'};
% days = {{'20220527','20220531','20220616','20220617'},...
%     {'20220518','20220519','20220616','20220617'},...
%     {'20220616','20220617','20220728','20220729'},... % long long
%     {'20220623','20220627','20220727','20220728'},... % long long
%     {'20220621','20220711'},...% long long
%     {'20220812','20220817','20220906','20220907'}}; % long long
% conditions = {{{'20220527','20220531'},{'20220616','20220617'}},...
%     {{'20220518','20220519'},{'20220616','20220617'}},...
%     {{'20220616','20220617'},{'20220728','20220729'}},... % long long
%     {{'20220623','20220627'},{'20220727','20220728'}},...
%     {{'20220621'},{'20220711'}},...
%     {{'20220812','20220817'},{'20220906','20220907'}}};
% conditionNames = {'Long Delay1','Long DelayC2'};

% % BACKWARDS DELAY VALUE
% mice = {'JB426','JB432','JB433','JB434'};
% days = {{'20220711','20220713','20220728','20220729'},... % long short
%     {'20220706','20220707','20220727','20220728'},... % long short
%     {'20220629','20220630','20220708','20220711'},...% long short
%     {'20220824','20220825','20220906','20220907'}}; % long short
% conditions = {{{'20220711','20220713'},{'20220728','20220729'}},... % short long
%     {{'20220706','20220707'},{'20220727','20220728'}},...
%     {{'20220629','20220630'},{'20220708','20220711'}},...
%     {{'20220824','20220825'},{'20220906','20220907'}}};
% conditionNames = {'Short Delay','Long Delay2'};

% BEFORE AND AFTER VALUE
% mice = {'JB426','JB432','JB433','JB434'};
% days = {{'20220616','20220617','20220728','20220729'},... % long long
%     {'20220623','20220627','20220727','20220728'},... % long long
%     {'20220621','20220711'},...% long long
%     {'20220812','20220817','20220906','20220907'}}; % long long
% conditions = {{{'20220616','20220617'},{'20220728','20220729'}},... % long long
%     {{'20220623','20220627'},{'20220727','20220728'}},...
%     {{'20220621'},{'20220711'}},...
%     {{'20220812','20220817'},{'20220906','20220907'}}};
% conditionNames = {'Long Delay1','Long Delay2'};

% ORIGINAL PREF TIMES
% mice = {'JB426','JB432'};
% days = {{'20220302','20220316','20220303','20220317'},... 
%     {'20220526','20220613','20220527','20220614'}};
% conditions = {{{'20220302','20220316'},{'20220303','20220317'}},... 
%     {{'20220526','20220613'},{'20220527','20220614'}}};
% conditionNames = {'Day1','Day2'};

% WATER VALUE
% mice = {'JB413','JB424','JB425','JB426'};
% days = {{'20220105','20220106','20220119','20220120'},...
%     {'20220328','20220329','20220413','20220414'},...
%     {'20220309','20220314','20220321','20220322'},...
%     {'20220406','20220411','20220426','20220427'}};
% conditions = {{{'20220119','20220120'},{'20220105','20220106'}},...
%     {{'20220413','20220414'},{'20220328','20220329'}},...
%     {{'20220321','20220322'},{'20220309','20220314'}},...
%     {{'20220426','20220427'},{'20220406','20220411'}}};
% conditionNames={'Drops1','Drops4-1'};

% % WATER VALUE LATER
% mice = {'JB413','JB424','JB425','JB426'};
% days = {{'20220119','20220120','20220127','20220128'},...
%     {'20220413','20220414','20220421','20220422',},...
%     {'20220321','20220322','20220331','20220401'},...
%     {'20220426','20220427','20220504','20220505'}};
% conditions = {{{'20220119','20220120'},{'20220127','20220128'}},...
%     {{'20220413','20220414'},{'20220421','20220422'}},...
%     {{'20220321','20220322'},{'20220331','20220401'}},...
%     {{'20220426','20220427'},{'20220504','20220505'}}};
% conditionNames={'Drops1','Drops4-2'};

% ORIGINAL LEARNING
% mice = {'JB426','JB432'};
% days = {{'20220126','20220127','20220131','20220201','20220302','20220303'},{'20220429','20220506','20220527'}};
% conditions = {{{'20220126','20220127'},{'20220131','20220201'},{'20220302','20220303'}},{{'20220429'},{'20220506'},{'20220527'}}};
% conditionNames={'Pre-learning','Early Learning','Learned'};

% % EARLY LEARNING
% mice = {'JB413','JB426','JB432','JB433'};
% days = {{'20211014','20211015','20211018','20211020'},...
%     {'20220126','20220127','20220131','20220201'},...
%     {'20220428','20220429','20220502','20220503'},...
%     {'20220428','20220429','20220502','20220503'}};
% conditions = {{{'20211014','20211015'},{'20211018','20211020'}},...
%     {{'20220126','20220127'},{'20220131','20220201'}},...
%     {{'20220428','20220429'},{'20220502','20220503'}},...
%     {{'20220428','20220429'},{'20220502','20220503'}}};
% conditionNames={'Pre-learning','Early Learning'};


% LATER LEARNING
% mice = {'JB413','JB426','JB432','JB433','JB434'};
% days = {{'20211014','20211015','20211102','20211103'},...
%     {'20220126','20220127','20220131','20220201'},...
%     {'20220428','20220429','20220505','20220506'},...
%     {'20220428','20220429','20220505','20220506'},...
%     {'20220428','20220429','20220504','20220505'}};
% conditions = {{{'20211014','20211015'},{'20211102','20211103'}},...
%     {{'20220126','20220127'},{'20220131','20220201'}},...
%     {{'20220428','20220429'},{'20220505','20220506'}},...
%     {{'20220428','20220429'},{'20220505','20220506'}},...
%     {{'20220428','20220429'},{'20220504','20220505'}}};
% conditionNames={'Pre-learning','Late Learning'};

% % LATER LEARNING ALL MICE
% mice = {'JB413','JB424','JB425','JB426','JB432','JB433','JB434'};
% days = {{'20211014','20211015','20211102','20211103'},...
%     {'20220105','20220106','20220121','20220124'},...
%     {'20220105','20220106','20220119','20220120'},...
%     {'20220126','20220127','20220131','20220201'},...
%     {'20220428','20220429','20220505','20220506'},...
%     {'20220428','20220429','20220505','20220506'},...
%     {'20220428','20220429','20220504','20220505'}};
% conditions = {{{'20211014','20211015'},{'20211102','20211103'}},...
%     {{'20220105','20220106'},{'20220121','20220124'}},...
%     {{'20220105','20220106'},{'20220119','20220120'}},...
%     {{'20220126','20220127'},{'20220131','20220201'}},...
%     {{'20220428','20220429'},{'20220505','20220506'}},...
%     {{'20220428','20220429'},{'20220505','20220506'}},...
%     {{'20220428','20220429'},{'20220504','20220505'}}};
% conditionNames={'Pre-learning','Late Learning'};

% INITIAL LONG DELAY VS LATER LONG DELAY
% mice = {'JB426','JB432','JB433','JB434'};
% days = {{'20220302','20220303','20220616','20220617'},... % initial long
%     {'20220526','20220527','20220623','20220627'},... % initial long
%     {'20220527','20220617'},...
%     {'20220526','20220527','20220812','20220817'}}; % initial long
% conditions = {{{'20220302','20220303'},{'20220616','20220617'}},... % initial long
%     {{'20220526','20220527'},{'20220623','20220627'}},...
%     {{'20220527'},{'20220617'}},...
%     {{'20220526','20220527'},{'20220812','20220817'}}};
% conditionNames = {'Initial','Long Delay'};

% INITIAL LONG VS SHORT DELAY
% days = {{'20220302','20220303','20220711','20220713'},... % initial long
%     {'20220526','20220527','20220706','20220707'},... % initial long
%     {'20220526','20220527','20220824','20220825'}}; % initial long
% conditions = {{{'20220302','20220303'},{'20220711','20220713'}},... % initial long
%     {{'20220526','20220527'},{'20220706','20220707'}},...
%     {{'20220526','20220527'},{'20220824','20220825'}}};
% conditionNames = {'Initial Long','Short Delay'};


% conditionNames={'Info equal value','Info Onequarter water value'};
% conditionNames={'LowProb','HighProb'};
% mice={'JB426'};
% days={{'20220302','20220303','20220316','20220317'},{1}};
% days={{'20220302','20220303','20220328','20220329'},{1}};
% days = {{'20220616','20220617','20220624','20220628'},{1}};
% days = {{'20220406','20220411','20220426','20220427'},{1}};
% conditions = {{'20220616','20220617'},{'20220624','20220628'}};
% days={{'20220314','20220315','20220316','20220317'},{1}};
% days={{'20220321','20220322','20220328','20220329'},{1}};
% days = {{'20220616','20220617','20220711','20220713'},{1}};
% days = {{'20220126','20220127','20220131','20220201','20220302','20220303'},{1}};
% conditions = {{{'20220126','20220127'},{'20220131','20220201'},{'20220302','20220303'}}};
% conditions = {{{'20220616','20220617'},{'20220711','20220713'}}};
% conditions = {{{'20220711','20220713'},{'20220616','20220617'}}};
% conditionNames={'Short Delay','Long Delay'};
% conditions = {{{'20220321','20220322'},{'20220328','20220329'}}};
% conditionNames={'Time1','Time2'};
% conditionNames={'Pref','Reverse'};
% mice={'JB432'};
% days = {{'20220623','20220627','20220706','20220707'},{1}};
% conditions = {{'20220706','20220707'},{'20220623','20220627'}};
% mice={'JB433'};
% days = {{'20220629','20220630','20220708','20220711'},{1}};
% conditions = {{'20220629','20220630'},{'20220708','20220711'}};
% mice={'JB425'};
% days = {{'20220518','20220519','20220607','20220609'},{1}};
% conditions = {{'20220518','20220519'},{'20220607','20220609'}};
% mice={'JB434'};
% days = {{'20220812','20220817','20220824','20220825'},{1}};
% conditions = {{'20220812','20220817'},{'20220824','20220825'}};

condct=numel(conditions{1});
alldays={};
for m=1:numel(mice)
    alldays=[alldays days{m}];
end
alldays=strjoin(alldays);

allconditions = strjoin(conditionNames);


%% LOAD INDIVIDUAL FILE DATA INTO Z
% Z(m) for each mouse has event arrays cells x time x trials
% concatenated by all trials each day
% create condition array to label trial by condition

files=dir('random');
for m=1:numel(mice)
   regfname=dir(fullfile(datapath,[mice{m} '_' num2str(numel(days{m})) 'days_' strjoin(days{m},'_') '_reg.mat']));
   load(fullfile(datapath,regfname.name),'MATCHED_ROIS');
   reg{m}=MATCHED_ROIS;
   for d=1:numel(days{m})
       dates=days{m};
       filename=[mice{m} '_' dates{d} '*neural.mat'];
       files=[files; dir(fullfile(datapath,filename))];
       f=numel(files);
       file=dir(fullfile(datapath,filename));
       disp(['loading file ',file.name]);
       b=load(fullfile(file.folder,file.name));
%        files=[files; dir(fullfile(datapath,filename))];
%        m=find(strcmp(b.mouse{1},mice));
       ff=find(strcmp(b.day{1},days{m}));
       ROIS=reg{m}(:,ff);
       trialCt=numel(b.mouse);
       b.file(1:trialCt,1)=f; 
       vars=fields(b);
       if exist('z','var') == 0
           for i = 1:numel(vars)
               if strcmp(vars{i}(1:2),'C_')
                   % only registered cells for activity matrices
                   z(m).(vars{i}) = b.(vars{i})(ROIS,:,:);
               else
                   % for trial-size matrices
                   z(m).(vars{i})=b.(vars{i});
               end
           end
       else
           if numel(z)>=m
               for i = 1:numel(vars)
                   if strcmp(vars{i}(1:2),'C_')
                       z(m).(vars{i})=cat(3,z(m).(vars{i}),b.(vars{i})(ROIS,:,:));
                   else
                       z(m).(vars{i})=cat(1,z(m).(vars{i}),b.(vars{i}));            
                   end
               end
           else
               for i = 1:numel(vars)
                   if strcmp(vars{i}(1:2),'C_')
                       % only registered cells for activity matrices
                       z(m).(vars{i}) = b.(vars{i})(ROIS,:,:);
                   else
                       % for trial-size matrices
                       z(m).(vars{i})=b.(vars{i});
                   end
               end
           end
       end
       b=[];
       trialCt=[];
       vars=[];      
   end
   z(m).cd=NaN(size(z(m).day));
   for i=1:numel(conditions{m})
       z(m).cd(ismember(z(m).day,conditions{m}{i}))=i;
   end
end

numFiles=numel(files);
for m=1:numel(mice)
    maxTrials(m)=size(z(m).day,1);
end
maxTrials=max(maxTrials);


%%

% make conditional activity by condition (cell array)
% e.g. odor1FirstInfo{1}
% then concat by mouse

% add all info/rand not just forced!
% figure out NaNs

for m=1:numel(mice)
    a=z(m);
    a.nameEventsFirst = [9,6,7];
    
    for cd=1:numel(conditions{m})
%         c.baseline{cd}=a.baseline(:,:,a.cd==cd);
%         c.C_baseline=a.C_baseline;
        c.events{1,cd} = a.C_trialStart(:,:,a.cd==cd);
        c.events{2,cd} = a.C_centerEntry(:,:,a.cd==cd);
        c.events{3,cd} = a.C_odor1(:,:,a.cd==cd);
        c.events{4,cd} = a.C_centerExit(:,:,a.cd==cd);
        c.events{5,cd} = a.C_sideEntry(:,:,a.cd==cd);
        c.events{6,cd} = a.C_odor2(:,:,a.cd==cd);
        c.events{7,cd} = a.C_outcome(:,:,a.cd==cd);
        c.events{8,cd} = a.C_odor1All(:,:,a.cd==cd);
        c.events{9,cd} = a.C_odor1First(:,:,a.cd==cd);
        c.events{10,cd} = a.C_baseline(:,:,a.cd==cd);
        c.events{11,cd} = a.C_trial(:,:,a.cd==cd);
        c.events{12,cd} = a.C_sideExit(:,:,a.cd==cd);
        c.events{13,cd} = a.C_centerExitFirst(:,:,a.cd==cd);
        c.C_odor1First{cd}=a.C_odor1First(:,:,a.cd==cd);
%         c.C_odor1InfoFirst{cd} = a.C_odor1First(:,:,a.imageTrialType==2);
%         c.C_odor1RandFirst{cd} = a.C_odor1First(:,:,a.imageTrialType==3);
%         c.C_odor1ChoiceFirst{cd} = a.C_odor1First(:,:,a.imageTrialType==1);        
%         c.C_odor1FirstInfoLeft{cd}=a.C_odor1First(:,:,a.infoSide==0&a.info==1&a.imagingCorr==1);
%         c.C_odor1FirstInfoRight{cd}=a.C_odor1First(:,:,a.infoSide==1&a.info==1&a.imagingCorr==1);
%         c.C_odor1FirstRandRight{cd}=a.C_odor1First(:,:,a.infoSide==0&a.info==0&a.imagingCorr==1);
%         c.C_odor1FirstRandLeft{cd}=a.C_odor1First(:,:,a.infoSide==1&a.info==0&a.imagingCorr==1);

        c.C_odor1FirstInfo{cd} = a.C_odor1First(:,:,a.cd==cd&a.imageTrialType==2 & a.imagingPrevCorrect == 1);
        c.C_odor1FirstRand{cd} = a.C_odor1First(:,:,a.cd==cd&a.imageTrialType==3 & a.imagingPrevCorrect == 1);
        c.C_odor1FirstInfoForced{cd} = a.C_odor1First(:,:,a.imagingChoice==1&a.cd==cd & a.imagingPrevCorrect == 1);
        c.C_odor1FirstInfoChoice{cd} = a.C_odor1First(:,:,a.imagingChoice==2&a.cd==cd & a.imagingPrevCorrect == 1);
        c.C_odor1FirstRandForced{cd} = a.C_odor1First(:,:,a.imagingChoice==3&a.cd==cd & a.imagingPrevCorrect == 1);
        c.C_odor1FirstRandChoice{cd} = a.C_odor1First(:,:,a.imagingChoice==4&a.cd==cd & a.imagingPrevCorrect == 1);
        c.C_odor2A{cd} = a.C_odor2(:,:,a.imagingOdor2 == 1&a.cd==cd & a.imagingPrevCorrect == 1 & a.imagingChoice==1);
        c.C_odor2B{cd} = a.C_odor2(:,:,a.imagingOdor2 == 2&a.cd==cd & a.imagingPrevCorrect == 1 & a.imagingChoice==1);
        c.C_odor2C{cd} = a.C_odor2(:,:,a.imagingOdor2 == 3&a.cd==cd & a.imagingPrevCorrect == 1 & a.imagingChoice==3);
        c.C_odor2D{cd} = a.C_odor2(:,:,a.imagingOdor2 == 4&a.cd==cd& a.imagingPrevCorrect == 1 & a.imagingChoice==3);
        c.C_odor2info{cd} = a.C_odor2(:,:,(a.imagingOdor2 == 1 | a.imagingOdor2 == 2) & a.imagingPrevCorrect == 1 & a.imagingChoice==1&a.cd==cd);
        c.C_odor2rand{cd} = a.C_odor2(:,:,(a.imagingOdor2 == 3 | a.imagingOdor2 == 4) & a.imagingPrevCorrect == 1 & a.imagingChoice==3&a.cd==cd);        
        c.C_outcomeInfoBig{cd} = a.C_outcome(:,:,(a.imagingOutcome == 11 | a.imagingOutcome == 2)& a.cd==cd);
        c.C_outcomeInfoSmall{cd} = a.C_outcome(:,:,(a.imagingOutcome == 13 | a.imagingOutcome == 4 | a.imagingOutcome == 5 | a.imagingOutcome == 14) & a.cd==cd);
        c.C_outcomeRandBig{cd} = a.C_outcome(:,:,(a.imagingOutcome == 17 | a.imagingOutcome == 6) & a.cd==cd);
        c.C_outcomeRandSmall{cd} = a.C_outcome(:,:,(a.imagingOutcome == 19 | a.imagingOutcome == 8) &a.cd==cd);
        c.C_outcomeBig{cd} = a.C_outcome(:,:,(a.imagingOutcome == 2 | a.imagingOutcome == 6 | a.imagingOutcome == 11| a.imagingOutcome == 17) & a.cd==cd);
        c.C_outcomeSmall{cd} = a.C_outcome(:,:,(a.imagingOutcome == 4 | a.imagingOutcome == 8 | a.imagingOutcome == 13 | a.imagingOutcome == 14 | a.imagingOutcome == 19 | a.imagingOutcome == 5) & a.cd==cd);

        c.C_trialInfoForcedBig{cd} = a.C_trial(:,:,a.imagingOutcome == 11 & a.cd==cd);
        c.C_trialInfoForcedSmall{cd} = a.C_trial(:,:,a.imagingOutcome == 13 | a.imagingOutcome == 14 & a.cd==cd);
        c.C_trialRandForcedBig{cd} = a.C_trial(:,:,a.imagingOutcome == 17 & a.cd==cd);
        c.C_trialRandForcedSmall{cd} = a.C_trial(:,:,a.imagingOutcome == 19 & a.cd==cd);

%         c.C_trialInfoChoiceBig{cd} = a.C_trial(:,:,a.imagingOutcome == 2 & a.cd==cd);
%         c.C_trialInfoChoiceSmall{cd} = a.C_trial(:,:,a.imagingOutcome == 4 | a.imagingOutcome == 5 & a.cd==cd);
%         c.C_trialRandChoiceBig{cd} = a.C_trial(:,:,a.imagingOutcome == 6 & a.cd==cd);
%         c.C_trialRandChoiceSmall{cd} = a.C_trial(:,:,a.imagingOutcome == 8 & a.cd==cd);        
        
        % BASELINE
        c.baseline = cell(numel(params.events),2);
        for i = 1:numel(params.events)
        c.baseline{i,cd}=c.events{i,cd};
        end
%         c.baseline{6,cd}=a.C_odor2(:,:,a.cd==cd);
%         c.baseline{11,cd}=a.C_trial(:,:,a.cd==cd);
%         c.baseline{12,cd}=a.C_odor2(:,:,a.cd==cd);
%         c.baseline{7,cd}=a.C_outcome(:,:,a.cd==cd);

        imagingChoiceCD=a.imagingChoice(a.cd==cd & a.imagingPrevCorrect == 1);
        imagingOutcomeCD=a.imagingOutcome(a.cd==cd);
        imagingePrevCorrCD=a.imagingPrevCorrect(a.cd==cd);
%         c.baselineTypes = cell(3,1); % size of namesfirst, 1 for each event with conditional activity
        c.baselineTypes{1,cd}(imagingePrevCorrCD==1,1:4) = 1; % all trials for center odors
        c.baselineTypes{2,cd}(imagingePrevCorrCD==1,4) = 0; % for side odors
        c.baselineTypes{2,cd}(imagingChoiceCD == 1 | imagingChoiceCD == 2,1) = 1; %info for info big
        c.baselineTypes{2,cd}(imagingChoiceCD == 1 | imagingChoiceCD == 2,2) = 1; %info for info small
        c.baselineTypes{2,cd}(imagingChoiceCD == 3 | imagingChoiceCD == 4,3) = 1; %rand for rand big
        c.baselineTypes{2,cd}(imagingChoiceCD == 3 | imagingChoiceCD == 4,4) = 1; %rand for rand small
        c.baselineTypes{3,cd}(1:sum(a.imagingTrials & a.cd==cd),4) = 0;
        c.baselineTypes{3,cd}(imagingOutcomeCD == 11 | imagingOutcomeCD == 2,1) = 1; %info big for info big
        c.baselineTypes{3,cd}(imagingOutcomeCD == 13 | imagingOutcomeCD == 4 | imagingOutcomeCD == 5 | imagingOutcomeCD == 14,2) = 1; % info small for info small
        c.baselineTypes{3,cd}(imagingChoiceCD == 3 | imagingChoiceCD == 4,3) = 1; %rand for rand big
        c.baselineTypes{3,cd}(imagingChoiceCD == 3 | imagingChoiceCD == 4,4) = 1; % rand for rand small

%         c.baselineCond = cell(3,1);
        for i = 1:3
           e = a.nameEventsFirst(i);
           for ci = 1:4
               c.baselineCond{i,cd} = c.baseline{e,cd}(:,:,c.baselineTypes{i,cd}(:,ci)==1);
           end
        end
    c.rxn{cd}=a.rxn(a.cd==cd);
    c.imageTrialType{cd}=a.imageTrialType(a.cd==cd);
    c.imagingOutcome{cd}=a.imagingOutcome(a.cd==cd);
    c.imagingChoice{cd}=a.imagingChoice(a.cd==cd);
    c.imagingPrevOutcome{cd}=a.imagingPrevOutcome(a.cd==cd);
    
    end
    
    vars=fields(c);
    for i=1:numel(vars)
        for cd=1:numel(conditions{m})
            if contains(vars{i},'C_')
                [numcells,numtime,numtrials]=size(c.(vars{i}){cd});
                b=NaN(numcells,numtime,maxTrials);
                b(1:numcells,1:numtime,1:numtrials)=c.(vars{i}){cd};
                if m==1
                   allmice.(vars{i}){cd} = b; 
                else
                   allmice.(vars{i}){cd}=cat(1,allmice.(vars{i}){cd},b);
                end
                clear b;
            elseif iscell(c.(vars{i})) & size(c.(vars{i}),1)>1
                for n=1:size(c.(vars{i}),1)
                    [numcells,numtime,numtrials]=size(c.(vars{i}){n,cd});
                    b=NaN(numcells,numtime,maxTrials);
                    b(1:numcells,1:numtime,1:numtrials)=c.(vars{i}){n,cd};
                    if m==1
                       allmice.(vars{i}){n,cd} = b; 
                    else
                       allmice.(vars{i}){n,cd}=cat(1,allmice.(vars{i}){n,cd},b);
                    end
                    clear b;                    
                end
            else
                if m==1
                    allmice.(vars{i}){cd}=c.(vars{i}){cd};
                else
                    allmice.(vars{i}){cd}=cat(1,allmice.(vars{i}){cd},c.(vars{i}){cd});
                end                
            end
        end
    end
    
    mouse(1:size(a.C_odor1First,1),1)=m;
    if m==1
        allmice.mouse = mouse;
    else
        allmice.mouse=cat(1,allmice.mouse,mouse);
    end
        
    clear a c mouse;
end

%%

a=allmice;
clear allmice;

a.neuronCt=size(a.C_odor1FirstInfo{1},1);

a.nameEventsFirst = [9,6,7];
a.namesFirst = {{'C_odor1FirstInfoForced','C_odor1FirstInfoChoice',...
    'C_odor1FirstRandForced','C_odor1FirstRandChoice'};...
    {'C_odor2A','C_odor2B','C_odor2C','C_odor2D'};... 
    {'C_outcomeInfoBig','C_outcomeInfoSmall','C_outcomeRandBig',...
    'C_outcomeRandSmall'}};
a.labels = {{'Center Odor Info Forced','Center Odor Info Choice','Center Odor No Info Forced','Center Odor No Info Choice'};...
    {'Side Odor A Info Water','Side Odor B Info No Water','Side Odor No Info C','Side Odor No Info D'};...
    {'Outcome Info Water','Outcome Info No Water','Outcome Rand Water','Outcome Rand No Water'}};

a.compNamesFirst = {{'C_odor1FirstInfoForced','C_odor1FirstRandForced'};...
    {'C_odor2A','C_odor2B'};{'C_odor2C','C_odor2D'};...
    {'C_odor2info','C_odor2rand'};...
    {'C_outcomeInfoBig','C_outcomeInfoSmall'};{'C_outcomeRandBig',...
    'C_outcomeRandSmall'}};
a.compEventsFirst = [9,6,6,6,7,7];
a.compLabels = { 'Info - No Info';...
    'Info Water A - Info No Water B';'No Info C - No Info D';...
    'Info AB - No Info CD';
    'Info Water - Info No Water';'No Info Water - No Info No Water'};
a.conditionLabels = {{'Info Forced','No Info Forced'};...
    {'A Info Water','B Info No Water'};{'No Info C','No Info D'};...
    {'AB','CD'};...
    {'Info Water','Info No Water'};{'No Info Water','No Info No Water'}};

%%
framesAroundEvent = params.intervals./1000*params.Fs;
for e = 1:numel(params.events)
    a.t{e}=((1:2*framesAroundEvent(e))-framesAroundEvent(e))*(1/params.Fs);
    a.okt{e} = params.resp_win(1) <= a.t{e} & a.t{e} <= params.resp_win(2);
    a.tpre{e} = params.pre_win(1) <= a.t{e} & a.t{e} <= params.pre_win(2);
end

iStart = 40;
iStop = 56;
PID=0.075;

%% SIGNIFICANCE

a.pcrit = 0.05;
a.maxcrit = 0.2;
a.diffcrit=0.1;

%%

a.grey = [.8 .8 .8];
a.purple = [121 32 196] ./ 255;
a.lightPurple = [204 204 255] ./ 255;
a.orange = [251 139 6] ./ 255;
a.lightOrange = [255 204 153] ./ 255;
a.cornflower = [100 149 237] ./ 255;
a.teal = [0 128 128] ./ 255;
a.darkcyan = [0 139 139] ./ 255;
a.blues = [222,235,247;158,202,225;49,130,189]./ 255;
a.reds = [254,224,210;252,146,114;222,45,38]./ 255;
a.purples = [239,237,245;188,189,220;117,107,177]./ 255;
a.oranges = [254,230,206;253,174,107;230,85,13]./ 255;

a.magma=magma();
a.inferno=inferno();
a.plasma=plasma();
a.viridis=viridis();

a.rwb = make_colormap('b','w','r');
a.rbb = make_colormap('b','k','r');
a.rwt = make_colormap(a.darkcyan,'w','r');
a.rbt = make_colormap(a.darkcyan,'k','r');
a.rbc = make_colormap('c','k','r');
a.ckr= make_colormap([0 0.5 0.6],'k',[0.85 0 0]);

RA=0;

%% DECODING AT CENTER ODOR
% 
% % uses matrix trials x cells
% 
% % PARAMS
% event = 'C_odor1First'; % to decode around first presentation of center odor
% decodeEvent='Center Odor First';
% decode=1;
% decodeName='Info';
% e=3;
% nOut= 20;
% nTest = 100;
% i1List = 1:5:76;
% t=a.t{e}(i1List+2);
% eTest = zeros(length(i1List),1);
% i1=50;
% i2=54;
% if condct==2
%     cdTrain=2;
%     cdTest=1;
% else
%     cdTrain = 3;
%     cdTest = 2;
%     cdTest2 = 1;
% end
% 
% for m=1:numel(mice)
% 
% for jj=1:length(i1List)
%     i1 = i1List(jj);
%     i2 = i1+4;
%     % trials x cells
%     x_info=squeeze(mean(a.C_odor1FirstInfoForced{cdTrain}(a.mouse==m,i1:i2,:),2))';
%     x_info=x_info(~isnan(x_info(:,1)),:);
%     x_rand=squeeze(mean(a.C_odor1FirstRandForced{cdTrain}(a.mouse==m,i1:i2,:),2))';
%     x_rand=x_rand(~isnan(x_rand(:,1)),:);
%     x=[x_info;x_rand];
% 
%     y_info=ones(size(x_info,1),1);
%     y_rand=ones(size(x_rand,1),1)*-1;
%     y=[y_info;y_rand];
% 
%     nTrial = size(x,1);
%     
%     x_info2=squeeze(mean(a.C_odor1FirstInfoForced{cdTest}(a.mouse==m,i1:i2,:),2))';
%     x_info2=x_info2(~isnan(x_info2(:,1)),:);
%     x_rand2=squeeze(mean(a.C_odor1FirstRandForced{cdTest}(a.mouse==m,i1:i2,:),2))';
%     x_rand2=x_rand2(~isnan(x_rand2(:,1)),:);
%     x2=[x_info2;x_rand2];
%     y_info2=ones(size(x_info2,1),1);
%     y_rand2=ones(size(x_rand2,1),1)*-1;
%     y2=[y_info2;y_rand2];    
%     nTrial2 = size(x2,1);
%     
%     if condct>2
%         x_info3= squeeze(mean(a.C_odor1FirstInfoForced{cdTest2}(a.mouse==m,i1:i2,:),2))';
%         x_info3=x_info3(~isnan(x_info3(:,1)),:);
%         x_rand3=squeeze(mean(a.C_odor1FirstRandForced{cdTest2}(a.mouse==m,i1:i2,:),2))';
%         x_rand3=x_rand3(~isnan(x_rand3(:,1)),:);
%         x3=[x_info3;x_rand3];
%         y_info3=ones(size(x_info3,1),1);
%         y_rand3=ones(size(x_rand3,1),1)*-1;
%         y3=[y_info3;y_rand3];    
%         nTrial3 = size(x3,1);        
%     end
%     
%     % set up classifier
%     % cross valiation tests
%     errTest = zeros(nTest,1);
%     errTest2 = zeros(nTest,1);
%     errTest3 = zeros(nTest,1);
%     for i=1:nTest
%         ii = randperm(nTrial);
%         i2 = randperm(nTrial2);
%         iTest = ii(1:nOut);
%         iT = randperm(nTrial);
%         xx = x(iT,:);
%         yy = y(iT,:);
%         xTest = xx(iTest,:);
%         yTest = yy(iTest);
%         xx(iTest,:) = [];
%         yy(iTest,:) = [];
%         xTest2 = x2(i2,:);
%         yTest2 = y2(i2,:);
%         svmInfo = fitclinear(xx,yy);
%         errTest(i)=100*sum((yTest.*(xTest*svmInfo.Beta+svmInfo.Bias)<0))/nOut;
%         errTest2(i)=100*sum((yTest2.*(xTest2*svmInfo.Beta+svmInfo.Bias)<0))/size(xTest2,1);
%         if condct>2
%             i3 = randperm(nTrial3);
%             xTest3 = x3(i3,:);
%             yTest3 = y3(i3,:);
%             errTest3(i)=100*sum((yTest3.*(xTest3*svmInfo.Beta+svmInfo.Bias)<0))/size(xTest3,1);
%         end
%     end
%     eTest(jj) = mean(errTest);
%     eTest2(jj) = mean(errTest2);
%     eTest3(jj) = mean(errTest3,'omitnan');
%     weights{decode,m}(:,jj)=svmInfo.Beta;
%     clear y_info y_rand
% end
% 
% 
% % DECODING PLOT
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [1 1 10 7];
%     set(fig,'PaperOrientation','landscape');
% set(fig,'renderer','painters')
% ax=nsubplot(1,1,1,1);
% plot(ax,t,eTest,'color','b','linewidth',3,'marker','o','MarkerFaceColor','b');
% hold on;
% plot(ax,t,eTest2,'color','r','linewidth',3,'marker','o','MarkerFaceColor','r');
% if condct>2
% plot(ax,t,eTest3,'color','m','linewidth',3,'marker','o','MarkerFaceColor','m');
% end
% plot([-1 +1].*10^10,[50 50],'k','linewidth',2,'xliminclude','off')
% plot([0 0],[0 55],'k','linewidth',2) % Center Odor On
% plot([0.2 0.2],[0 55],'k','linewidth',2) % Center Odor Off
% plot([1.45 1.45],[0 55],'color',[.8 .8 .8],'linewidth',2) % Side Odor on
% hold off;
% if condct>2
% legend([conditionNames{cdTrain} '-Train'],[conditionNames{cdTest} '-Test'],[conditionNames{cdTest2} '-Test'],'location','southwest');
% else
% legend([conditionNames{cdTrain} '-Train'],[conditionNames{cdTest} '-Test'],'location','southwest');    
% end
% %     xlim([0 80])
% % ylim([0 100])
% xlabel('decoding time (s)')
% ylabel('decoding error')
% title([mice{m} ' ' strjoin(days{m}) ' ' allconditions ' decoding ' decodeName ' at ' decodeEvent]);
% saveas(fig,fullfile(output_dir,[mice{m},'_',strjoin(days{m}),'_',allconditions,'_decoding_', decodeName,'_',decodeEvent]),'pdf');        
% 
% end
% 
% %% DECODING CONDITION
% 
% event = 'C_odor1First'; % to decode around first presentation of center odor
% decodeEvent='Center Odor First';
% decode=1;
% decodeName='Info';
% e=3;
% nOut= 20;
% nTest = 100;
% i1List = 1:5:76;
% t=a.t{e}(i1List+2);
% eTest = zeros(length(i1List),1);
% 
% i1=50;
% i2=54;
% m=1;
% 
% for m=1:numel(mice)
% 
% for jj=1:length(i1List)
%     i1 = i1List(jj);
%     i2 = i1+4;
%     % trials x cells
%     x1=squeeze(mean(a.C_odor1FirstInfoForced{1}(a.mouse==m,i1:i2,:),2))';
%     x1=x1(~isnan(x1(:,1)),:);
%     x2=squeeze(mean(a.C_odor1FirstInfoForced{2}(a.mouse==m,i1:i2,:),2))';
%     x2=x2(~isnan(x2(:,1)),:);
%     x=[x1;x2];
% 
%     y1=ones(size(x1,1),1);
%     y2=ones(size(x2,1),1)*-1;
%     y=[y1;y2];
% 
%     nTrial = size(x,1);
%        
%     % set up classifier
%     % cross valiation tests
%     errTest = zeros(nTest,1);
%     for i=1:nTest
%         ii = randperm(nTrial);
%         iTest = ii(1:nOut);
%         iT = randperm(nTrial);
%         xx = x(iT,:);
%         yy = y(iT,:);
%         xTest = xx(iTest,:);
%         yTest = yy(iTest);
%         xx(iTest,:) = [];
%         yy(iTest,:) = [];
%         svmInfo = fitclinear(xx,yy);
%         errTest(i)=100*sum((yTest.*(xTest*svmInfo.Beta+svmInfo.Bias)<0))/nOut;
% 
%     end
%     eTest(jj) = mean(errTest);
%     weights{decode,m}(:,jj)=svmInfo.Beta;
%     
% end
% 
% % DECODING PLOT
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [1 1 10 7];
% set(fig,'PaperOrientation','landscape');
% set(fig,'renderer','painters')
% ax=nsubplot(1,1,1,1);
% plot(ax,t,eTest,'color','b','linewidth',3,'marker','o','MarkerFaceColor','b');
% hold on;
% plot([-1 +1].*10^10,[50 50],'k','linewidth',2,'xliminclude','off')
% plot([0 0],[0 55],'k','linewidth',2) % Center Odor On
% plot([0.2 0.2],[0 55],'k','linewidth',2) % Center Odor Off
% plot([1.45 1.45],[0 55],'color',[.8 .8 .8],'linewidth',2) % Side Odor on
% hold off;
% %     xlim([0 80])
% % ylim([0 100])
% xlabel('decoding time (s)')
% ylabel('decoding error')
% title([mice{m} ' ' strjoin(days{m}) ' decoding ' conditionNames ' at center odor info forced']);
% saveas(fig,fullfile(output_dir,[mice{m},'_',strjoin(days{m}),'_',allconditions,'_decodingconditioncenterodor']),'pdf');
% end
% 
% %% DECODING QUANT
% 
% nOut= 20;
% nTest = 100;
% 
% 
% m=1;
% 
% for m=1:numel(mice)
%     % decoding condition before after info CS
%     
%     i1=46;
%     i2=66;
%     % trials x cells
%     x1=squeeze(mean(a.C_odor1FirstInfoForced{1}(a.mouse==m,i1:i2,:),2))';
%     x1=x1(~isnan(x1(:,1)),:);
%     x2=squeeze(mean(a.C_odor1FirstInfoForced{2}(a.mouse==m,i1:i2,:),2))';
%     x2=x2(~isnan(x2(:,1)),:);
%     x=[x1;x2];
% 
%     y1=ones(size(x1,1),1);
%     y2=ones(size(x2,1),1)*-1;
%     y=[y1;y2];
% 
%     nTrial = size(x,1);
%        
%     % set up classifier
%     % cross valiation tests
%     errTest = zeros(nTest,1);
%     for i=1:nTest
%         ii = randperm(nTrial);
%         iTest = ii(1:nOut);
%         iT = randperm(nTrial);
%         xx = x(iT,:);
%         yy = y(iT,:);
%         xTest = xx(iTest,:);
%         yTest = yy(iTest);
%         xx(iTest,:) = [];
%         yy(iTest,:) = [];
%         svmInfo = fitclinear(xx,yy);
%         errTest(i)=100*sum((yTest.*(xTest*svmInfo.Beta+svmInfo.Bias)<0))/nOut;
% 
%     end
%     a.conditionError(1,m) = mean(errTest);
%  
%     i1=16;
%     i2=36;
%     % trials x cells
%     x1=squeeze(mean(a.C_odor1FirstInfoForced{1}(a.mouse==m,i1:i2,:),2))';
%     x1=x1(~isnan(x1(:,1)),:);
%     x2=squeeze(mean(a.C_odor1FirstInfoForced{2}(a.mouse==m,i1:i2,:),2))';
%     x2=x2(~isnan(x2(:,1)),:);
%     x=[x1;x2];
% 
%     y1=ones(size(x1,1),1);
%     y2=ones(size(x2,1),1)*-1;
%     y=[y1;y2];
% 
%     nTrial = size(x,1);
%        
%     % set up classifier
%     % cross valiation tests
%     errTest = zeros(nTest,1);
%     for i=1:nTest
%         ii = randperm(nTrial);
%         iTest = ii(1:nOut);
%         iT = randperm(nTrial);
%         xx = x(iT,:);
%         yy = y(iT,:);
%         xTest = xx(iTest,:);
%         yTest = yy(iTest);
%         xx(iTest,:) = [];
%         yy(iTest,:) = [];
%         svmInfo = fitclinear(xx,yy);
%         errTest(i)=100*sum((yTest.*(xTest*svmInfo.Beta+svmInfo.Bias)<0))/nOut;
% 
%     end
%     a.conditionError(2,m) = mean(errTest);    
% 
%     % Decoding info
%     i1=46;
%     i2=66;
%     % trials x cells
%     x_info=squeeze(mean(a.C_odor1FirstInfoForced{cdTrain}(a.mouse==m,i1:i2,:),2))';
%     x_info=x_info(~isnan(x_info(:,1)),:);
%     x_rand=squeeze(mean(a.C_odor1FirstRandForced{cdTrain}(a.mouse==m,i1:i2,:),2))';
%     x_rand=x_rand(~isnan(x_rand(:,1)),:);
%     x=[x_info;x_rand];
% 
%     y_info=ones(size(x_info,1),1);
%     y_rand=ones(size(x_rand,1),1)*-1;
%     y=[y_info;y_rand];
% 
%     nTrial = size(x,1);
%     
%     x_info2=squeeze(mean(a.C_odor1FirstInfoForced{cdTest}(a.mouse==m,i1:i2,:),2))';
%     x_info2=x_info2(~isnan(x_info2(:,1)),:);
%     x_rand2=squeeze(mean(a.C_odor1FirstRandForced{cdTest}(a.mouse==m,i1:i2,:),2))';
%     x_rand2=x_rand2(~isnan(x_rand2(:,1)),:);
%     x2=[x_info2;x_rand2];
%     y_info2=ones(size(x_info2,1),1);
%     y_rand2=ones(size(x_rand2,1),1)*-1;
%     y2=[y_info2;y_rand2];    
%     nTrial2 = size(x2,1);
%     
%     if condct>2
%         x_info3= squeeze(mean(a.C_odor1FirstInfoForced{cdTest2}(a.mouse==m,i1:i2,:),2))';
%         x_info3=x_info3(~isnan(x_info3(:,1)),:);
%         x_rand3=squeeze(mean(a.C_odor1FirstRandForced{cdTest2}(a.mouse==m,i1:i2,:),2))';
%         x_rand3=x_rand3(~isnan(x_rand3(:,1)),:);
%         x3=[x_info3;x_rand3];
%         y_info3=ones(size(x_info3,1),1);
%         y_rand3=ones(size(x_rand3,1),1)*-1;
%         y3=[y_info3;y_rand3];    
%         nTrial3 = size(x3,1);        
%     end
%     
%     % set up classifier
%     % cross valiation tests
%     errTest1 = zeros(nTest,1);
%     errTest2 = zeros(nTest,1);
%     errTest3 = zeros(nTest,1);
%     for i=1:nTest
%         ii = randperm(nTrial);
%         ii2 = randperm(nTrial2);
%         iTest = ii(1:nOut);
%         iT = randperm(nTrial);
%         xx = x(iT,:);
%         yy = y(iT,:);
%         xTest = xx(iTest,:);
%         yTest = yy(iTest);
%         xx(iTest,:) = [];
%         yy(iTest,:) = [];
%         xTest2 = x2(ii2,:);
%         yTest2 = y2(ii2,:);
%         svmInfo = fitclinear(xx,yy);
%         errTest(i)=100*sum((yTest.*(xTest*svmInfo.Beta+svmInfo.Bias)<0))/nOut;
%         errTest2(i)=100*sum((yTest2.*(xTest2*svmInfo.Beta+svmInfo.Bias)<0))/size(xTest2,1);
%         if condct>2
%             ii3 = randperm(nTrial3);
%             xTest3 = x3(ii3,:);
%             yTest3 = y3(ii3,:);
%             errTest3(i)=100*sum((yTest3.*(xTest3*svmInfo.Beta+svmInfo.Bias)<0))/size(xTest3,1);
%         end
%     end
%     a.infoError{1}(m) = mean(errTest);
%     a.infoError{2}(m) = mean(errTest2);
%     a.infoError{3}(m) = mean(errTest3,'omitnan');
%     
% end
% 
% %%
% 
% accDelta=(a.conditionError(2,:)-a.conditionError(1,:))/100;
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [1 1 10 7];
% set(fig,'PaperOrientation','landscape');
% set(fig,'renderer','painters')
% ax=nsubplot(1,1,1,1);
% bar([accDelta mean(accDelta)]);
% ylim([0 0.5]);
% xticks([1:max(a.mouse)+1]);
% xlabel('Mouse and mean');
% ylabel('Decoding accuracy for condition, CHANGE after Info Forced center odor');
% title([strjoin(mice, ' _ ') ' ' alldays ' decoding ' conditionNames ' at center odor info forced']);
% saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_',allconditions,'_decodingQuantconditionChangecenterodor']),'pdf');
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [1 1 10 7];
% set(fig,'PaperOrientation','landscape');
% set(fig,'renderer','painters')
% ax=nsubplot(1,1,1,1);
% bar([1-a.conditionError(1,:)/100 mean(1-a.conditionError(1,:)/100)]);
% ylim([0 1]);
% xticks([1:max(a.mouse)+1]);
% xlabel('Mouse and mean');
% ylabel('Decoding accuracy for condition after Info Forced center odor');
% title([strjoin(mice, ' _ ') ' ' alldays ' decoding ' conditionNames ' at center odor info forced']);
% saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_',allconditions,'_decodingQuantconditioncenterodor']),'pdf');
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [1 1 10 7];
% set(fig,'PaperOrientation','landscape');
% set(fig,'renderer','painters')
% ax=nsubplot(1,1,1,1);
% bar([1-a.infoError{1}/100 mean(1-a.infoError{1}/100)]);
% ylim([0 1]);
% xticks([1:max(a.mouse)+1]);
% xlabel('Mouse and mean');
% ylabel('Decoding accuracy for Info');
% title([strjoin(mice, ' _ ') ' ' alldays ' decoding Info trained on ' conditionNames{2} ' tested on ' conditionNames{1}]);
% saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_',allconditions,'_decodingQuantInfocenterodor']),'pdf');


%% SIGNIFICANT CONDITIONAL RESPONSE IN EACH LEARNING CONDITION

for cm=1:condct
    for cd = 1:numel(a.namesFirst)
       cname = a.namesFirst{cd};
       e = a.nameEventsFirst(cd);
       cy = cellfun(@(z) a.(z),cname,'uniform',0);
        t=a.t{e};
        okt=a.okt{e};
       for ci = 1:numel(cname)
           y=cy{ci}{cm};
           if ~isempty(y)
               % mean across time (vals for each trial for each cell)
               ybaseline = squeeze(mean(a.baselineCond{cd,cm}(:,a.tpre{e},:),2,'omitnan'));
               [maxval,maxidx]=max(y(:,16:39,:),[],2,'omitnan');
               maxval=squeeze(maxval);maxidx=squeeze(maxidx);
               basetimes=t(okt);
    %            decay = @(b)
                ybaselineExp=[];
                for i=1:numel(basetimes)
                    ybaselineExp(:,i,:)=maxval.*0.5.^((basetimes(i)-t(maxidx+16))/0.4);
                end
                ybaselineExp=squeeze(mean(ybaselineExp,2)); 
                               
                ypost = squeeze(mean(y(:,a.okt{e},:),2,'omitnan'));
                a.postAct{cd,cm}{ci} = mean(ypost,2,'omitnan');
                a.baseAct{cd,cm}{ci} = mean(ybaseline,2,'omitnan');
                a.baseActExp{cd,cm}{ci}=mean(ybaselineExp,2,'omitnan');           

                badidx=a.baseAct{cd,cm}{ci}-a.baseActExp{cd,cm}{ci}>a.maxcrit;
                ybase=ybaselineExp;
                ybase(badidx,:)=ybaseline(badidx,:);           
           
               pvals=NaN(a.neuronCt,1);
               for u = 1:a.neuronCt
                   if sum(~isnan(ypost(u,:)))>0
                   pvals(u,1) = ranksum(ybaseline(u,:),ypost(u,:));
                   pvalsPS(u,1) =ranksum(ybase(u,:),ypost(u,:));
                   pvalsExp(u,1) = ranksum(ybaselineExp(u,:),ypost(u,:));
                   end
               end
               a.C_condBasePostP{cd,cm}(:,ci)=pvals;
               a.C_condBasePostPS{cd,cm}(:,ci)=pvalsPS;
               a.C_condBasePostPExp{cd,cm}(:,ci)=pvalsExp;
               ymean=mean(y,3,'omitnan');
               maxresp = max(ymean(:,a.okt{e}),[],2);
               a.C_condBasePostRSActive{cd,cm}(:,ci) = a.C_condBasePostP{cd,cm}(:,ci)<a.pcrit&a.postAct{cd,cm}{ci}-a.baseAct{cd,cm}{ci}>0.1;
               a.C_condBasePostRSActiveExp{cd,cm}(:,ci) = a.C_condBasePostPS{cd,cm}(:,ci)<a.pcrit&a.postAct{cd,cm}{ci}-a.baseAct{cd,cm}{ci}>0.1;          

%          
           end
       end
    end
end

for cm=1:condct
activeCells=[];
for cd = 1:numel(a.namesFirst)
    cnames = a.namesFirst{cd};
    activeCellscd = a.C_condBasePostRSActiveExp{cd,cm};        
    activeCells = [activeCells activeCellscd];
end
a.cellTypes{cm}=activeCells;
end

% 1 = info forced, 2 = no info forced responders

%% SIGNIFICANT DIFFERENCE BETWEEN LEARNING CONDITIONS

for cd = 1:numel(a.namesFirst)
   cname = a.namesFirst{cd};
   e = a.nameEventsFirst(cd);
   cy = cellfun(@(z) a.(z),cname,'uniform',0);
   for ci = 1:numel(cname)
       y1=cy{ci}{1};
       y1mean = mean(y1,3,'omitnan');
       ypost1 = squeeze(mean(y1(:,a.okt{e},:),2,'omitnan'));
       y1meanPost = mean(y1mean(:,a.okt{e}),2,'omitnan');
       y2=cy{ci}{2};
       y2mean = mean(y2,3,'omitnan');
       y2meanPost = mean(y2mean(:,a.okt{e}),2,'omitnan');
       ypost2 = squeeze(mean(y2(:,a.okt{e},:),2,'omitnan'));
       a.absActivityPostDiff_xcond{cd,ci} = abs(y2meanPost-y1meanPost);
       a.activityPostDiff_xcond{cd,ci} = y2meanPost-y1meanPost;
       a.RSpvalsmean_xcond{cd,ci}=NaN(a.neuronCt,1);
       for u=1:a.neuronCt
           if sum(~isnan(ypost1(u,:)))>0 & sum(~isnan(ypost2(u,:)))>0
                a.RSpvalsmean_xcond{cd,ci}(u,1) = ranksum(ypost1(u,:),ypost2(u,:));
           end
       end
       a.C_condRSdifferent_xcond{cd,ci}=a.RSpvalsmean_xcond{cd,ci}<a.pcrit&a.absActivityPostDiff_xcond{cd,ci}>a.diffcrit;
       if sum(~isnan(ypost1(:)))>0 & sum(~isnan(ypost2(:)))>0
            a.popRSdiff_xcond{cd,ci}=ranksum(ypost1(:),ypost2(:));
            a.cellRSdiff_xcond{cd,ci}=ranksum(y1meanPost,y2meanPost);
       end
   end
   
end

%%
a.differentCells=[];
for cd = 1:numel(a.namesFirst)
    cnames = a.namesFirst{cd};
    for ci=1:numel(cnames)
        a.differentCells=[a.differentCells a.C_condRSdifferent_xcond{cd,ci}];
    end
end

%% SHUFFLE ACTIVITY BETWEEN INFO-NO INFO (CONDITIONS) TO FIND SIGNIFICANT DIFF WITHIN EACH CONDITION WITHIN LEARNING TIMES (instead of PCA)

mouseCells=histc(a.mouse(:),unique(a.mouse));
mouseCellCts=[0; cumsum(mouseCells)];

clear yy;
for cd = 1:size(a.compNamesFirst)
    cname = a.compNamesFirst{cd};
    e = a.compEventsFirst(cd);
    
    cy = cellfun(@(z) a.(z),cname,'uniform',0);
    
    for ci=1:condct
        y1 = cy{1}{ci}; % info activity for each time
        y2 = cy{2}{ci}; % random activity for each time
        n1=sum(~isnan(y1(cumsum(mouseCells),1,:)),3); % number of non-NaN trials per mouse
        n2=sum(~isnan(y2(cumsum(mouseCells),1,:)),3);
        clear ii;
        for m=1:numel(mice)
            yy1{m}=y1(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:n1(m)); % that mouse's activity (noNaN) for condition 1
            yy2{m}=y2(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:n2(m));
            yy{m}=cat(3,yy1{m},yy2{m}); % stack condition 1 and condition 2 for that mouse
            ii{m}(1:n1(m),1)=1; % label for condition 1 trials for that mouse
            ii{m}(n1(m)+1:n1(m)+n2(m),1)=2; % label for condition 2 trials for that mouse       
        end

        for j=1:1000
            for m=1:numel(mice) 
                shuffle = ii{m}(randperm(size(ii{m},1))'); % shuffle whether trials are condition 1 or condition 2
                y1shuffle=yy{m}(:,:,shuffle==1); % take a random subset to be condition 1 of condition 1 size
                s1=NaN(size(y1shuffle,1),size(y1shuffle,2),max(n1)); % fill with NaN for matched size
                s1(:,:,1:size(y1shuffle,3))=y1shuffle;
                y2shuffle=yy{m}(:,:,shuffle==2);
                s2=NaN(size(y2shuffle,1),size(y2shuffle,2),max(n2));
                s2(:,:,1:size(y2shuffle,3))=y2shuffle;
                if m==1 % concatenate mice back together
                   y1=s1;
                   y2=s2;
                else
                    y1=cat(1,y1,s1);
                    y2=cat(1,y2,s2);
                end
            end

            y1mean = mean(y1,3,'omitnan'); % mean across trials in cond 1
            y2mean = mean(y2,3,'omitnan');

            y1meanPost = mean(y1mean(:,a.okt{e}),2,'omitnan');
            y1meanPre = mean(y1mean(:,a.tpre{e}),2,'omitnan');
            y2meanPost = mean(y2mean(:,a.okt{e}),2,'omitnan');
            y2meanPre = mean(y2mean(:,a.tpre{e}),2,'omitnan');

            a.shuffleDiff{cd,ci}(:,:,j)=abs(y1mean-y2mean);
            a.shuffleDiffPost{cd,ci}(:,j)=abs(y1meanPost-y2meanPost); % this is randNeuronAreas
            a.shuffleDiffPre{cd,ci}(:,j)=abs(y1meanPre-y2meanPre);
            
            a.shuffleDiffMean{cd,ci}(j,:)=mean(squeeze(a.shuffleDiff{cd,ci}(:,:,j)));
            a.shuffleDiffPostMean{cd,ci}(j,1)=mean(a.shuffleDiffPost{cd,ci}(:,j));
            a.shuffleDiffPreMean{cd,ci}(j,1)=mean(a.shuffleDiffPre{cd,ci}(:,j));

            y11=y1(:,:,1:2:end); %condition 1 (info) odd trials
            y12=y1(:,:,2:2:end); % condition 1 even trials

            y21=y2(:,:,1:2:end); % condition 2 (rand)
            y22=y2(:,:,2:2:end);    

            y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1 odd trials
            y1mean2 = mean(y12,3,'omitnan'); % mean across trials in cond 1 even trials
            y2mean1 = mean(y21,3,'omitnan');
            y2mean2 = mean(y22,3,'omitnan');
            y1meanPost1 = mean(y1mean1(:,a.okt{e}),2,'omitnan'); % mean post-act in condition 1 odd trials
            y1meanPost2 = mean(y1mean2(:,a.okt{e}),2,'omitnan'); % mean post-act in condition 1 even trials
            y2meanPost1 = mean(y2mean1(:,a.okt{e}),2,'omitnan');
            y2meanPost2 = mean(y2mean2(:,a.okt{e}),2,'omitnan');
            y1meanPre1 = mean(y1mean1(:,a.tpre{e}),2,'omitnan'); % mean post-act in condition 1 odd trials
            y1meanPre2 = mean(y1mean2(:,a.tpre{e}),2,'omitnan'); % mean post-act in condition 1 even trials
            y2meanPre1 = mean(y2mean1(:,a.tpre{e}),2,'omitnan');
            y2meanPre2 = mean(y2mean2(:,a.tpre{e}),2,'omitnan');        

            activityDifference1 = y1mean1-y2mean1; % condition 1 odd trials - condition 2 odd trials (then multiply by sign of even trials)
            activityDifference2 = y1mean2-y2mean2;
            a.activityDifferenceEBMShuffle{cd,ci}(:,:,j) = ((sign(activityDifference1).*activityDifference2)+(sign(activityDifference2).*activityDifference1))/2;

            actDiffPost1 = y1meanPost1-y2meanPost1; % difference in post 1sec between condition 1 odds and condition 2 odds
            actDiffPost2 = y1meanPost2-y2meanPost2;
            a.actDiffPostEBMShuffle{cd,ci}(:,j) = ((sign(actDiffPost1).*actDiffPost2)+(sign(actDiffPost2).*actDiffPost1))/2;

            actDiffPre1 = y1meanPre1-y2meanPre1; % difference in post 1sec between condition 1 odds and condition 2 odds
            actDiffPre2 = y1meanPre2-y2meanPre2;
            a.actDiffPreEBMShuffle{cd,ci}(:,j) = ((sign(actDiffPre1).*actDiffPre2)+(sign(actDiffPre2).*actDiffPre1))/2;               
        end
    end
end

%% ACTIVITY BETWEEN CONDITIONS (DIFFERENTIAL) - DIFFERENT BETWEEN TRIAL CONDITIONS

for cd = 1:size(a.compNamesFirst)
    cname = a.compNamesFirst{cd};
    e = a.compEventsFirst(cd);
    cy = cellfun(@(z) a.(z),cname,'uniform',0); 
    
    for ci=1:condct % first for first learning time, then for second
        y1 = cy{1}{ci}; % info
        y2 = cy{2}{ci}; %rand

        y1mean = mean(y1,3,'omitnan'); % mean across trials in cond 1
        y2mean = mean(y2,3,'omitnan');
        y1meanPost = mean(y1mean(:,a.okt{e}),2,'omitnan');
        y1meanPre = mean(y1mean(:,a.tpre{e}),2,'omitnan');
        y2meanPost = mean(y2mean(:,a.okt{e}),2,'omitnan');
        y2meanPre = mean(y2mean(:,a.tpre{e}),2,'omitnan');
        
        if ~isempty(y1) & ~isempty(y2)
        
            a.absActivityPostDiff{cd,ci} = abs(y1meanPost-y2meanPost);
            a.activityPostDiff{cd,ci} = y1meanPost-y2meanPost;

            a.pNeuronsPost{cd,ci} = NaN(a.neuronCt,1);
            for i=1:a.neuronCt
                a.pNeuronsPost{cd,ci}(i) = 100*sum((a.shuffleDiffPost{cd,ci}(:)>a.absActivityPostDiff{cd,ci}(i))) ...
                    /length(a.shuffleDiffPost{cd,ci}(:));
            end

            % RANK-SUM instead of shuffle between conditions
            for u = 1:a.neuronCt
                Activity_1 = squeeze(y1(u,:,:))';
                Activity_2 = squeeze(y2(u,:,:))';
                a.RSpvalsmean{cd,ci}=NaN(a.neuronCt,1);
                if sum(~isnan(Activity_1))>0 & sum(~isnan(Activity_2))>0
                    a.RSpvalsmean{cd,ci}(u,1) = ranksum(mean(Activity_2(:,a.okt{e}),2,'omitnan'),mean(Activity_1(:,a.okt{e}),2,'omitnan'));
                end
            end
            
            a.C_condRSdifferent{cd,ci}=a.RSpvalsmean{cd,ci}<a.pcrit&a.absActivityPostDiff{cd,ci}>a.diffcrit;
            a.C_condShuffleDifferent{cd,ci}=a.pNeuronsPost{cd,ci}<(a.pcrit*100)&a.absActivityPostDiff{cd,ci}>a.diffcrit;
            
        end
    end
end

%%

% info - no info 10s a.activityPostDiff{1,2}
% info - no info 1s a.activityPostDiff{1,2}

% plot of 10s vs 1s * sign 10s

activity1=a.activityPostDiff{1,2}.*sign(a.activityPostDiff{1,2});
activity2=a.activityPostDiff{1,1}.*sign(a.activityPostDiff{1,2});

%% MEAN ACTIVITY DIFFERENCE BY MOUSE

for m=1:numel(mice)
    a.absDiffByMouse(m,1)=mean(a.absActivityPostDiff{1,2}(mouseCellCts(m)+1:mouseCellCts(m+1),:))-mean(a.absActivityPostDiff{1,1}(mouseCellCts(m)+1:mouseCellCts(m+1),:));
end


%% EBM CODING

disp('Calculating EBM index for each event');

for cd = 1:size(a.compNamesFirst)
    cname = a.compNamesFirst{cd};
    e = a.compEventsFirst(cd);
    
    cy = cellfun(@(z) a.(z),cname,'uniform',0);
    for ci=1:condct
    
    y1 = cy{1}{ci};
    y2 = cy{2}{ci};
    
    y11=y1(:,:,1:2:end);
    y12=y1(:,:,2:2:end);
    
    y21=y2(:,:,1:2:end);
    y22=y2(:,:,2:2:end);    
    
    y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
    y1mean2 = mean(y12,3,'omitnan');
    y2mean1 = mean(y21,3,'omitnan');
    y2mean2 = mean(y22,3,'omitnan');
    
    y1meanPost1 = mean(y1mean1(:,a.okt{e}),2,'omitnan');
    y1meanPre1 = mean(y1mean1(:,a.tpre{e}),2,'omitnan');
    y1meanPost2 = mean(y1mean2(:,a.okt{e}),2,'omitnan');
    y1meanPre2 = mean(y1mean2(:,a.tpre{e}),2,'omitnan');
    y2meanPost1 = mean(y2mean1(:,a.okt{e}),2,'omitnan');
    y2meanPre1 = mean(y2mean1(:,a.tpre{e}),2,'omitnan');
    y2meanPost2 = mean(y2mean2(:,a.okt{e}),2,'omitnan');
    y2meanPre2 = mean(y2mean2(:,a.tpre{e}),2,'omitnan');
    
    activityDifference1 = y1mean1-y2mean1; % difference on odd trials
    activityDifference2 = y1mean2-y2mean2;
    a.activityDifferenceEBM{cd,ci} = (sign(activityDifference1).*activityDifference2+sign(activityDifference2).*activityDifference1).*0.5;
    a.popActDiffEBM{cd,ci}=mean(a.activityDifferenceEBM{cd,ci});
    
    actDiffPost1 = y1meanPost1-y2meanPost1; % difference in post 1sec between condition 1 odds and condition 2 odds
    actDiffPost2 = y1meanPost2-y2meanPost2;
    a.actDiffPostEBM{cd,ci} = (sign(actDiffPost1).*actDiffPost2+sign(actDiffPost2).*actDiffPost1)/2;
    
    actDiffPre1 = y1meanPre1-y2meanPre1; % difference in post 1sec between condition 1 odds and condition 2 odds
    actDiffPre2 = y1meanPre2-y2meanPre2;
    a.actDiffPreEBM{cd,ci} = (sign(actDiffPre1).*actDiffPre2+sign(actDiffPre2).*actDiffPre1)/2;    
    
    for t=1:size(activityDifference1,2)
        a.activityDifferenceEBMSig{cd,ci}(:,t) = signrank(a.activityDifferenceEBM{cd,ci}(:,t));
    end
    
    a.actDiffIdxEBMPostSig{cd,ci} = signrank(mean(a.activityDifferenceEBM{cd,ci}(:,a.okt{e}),2));
    a.actDiffIdxEBMPreSig{cd,ci} = signrank(mean(a.activityDifferenceEBM{cd,ci}(:,a.tpre{e}),2));
    end
       
end

%% SIGNFICANT DIFFERENCES

for cd = 1:size(a.compNamesFirst)
    % cd =1 info, rand
    for ci=1:condct
    
        trueDiff = a.actDiffPostEBM{cd,ci}-a.actDiffPreEBM{cd,ci};
        trueDiffPop = mean(a.actDiffPostEBM{cd,ci}) - mean(a.actDiffPreEBM{cd,ci});

        shuffleDiff = a.actDiffPostEBMShuffle{cd,ci}-a.actDiffPreEBMShuffle{cd,ci};
        shuffleDiffPop = mean(a.actDiffPostEBMShuffle{cd,ci})-mean(a.actDiffPreEBMShuffle{cd,ci});

        a.actDiffPopIdxEBMSig{cd,ci}=sum(shuffleDiffPop>trueDiffPop)/1000;
        a.actDiffIdxEBMSig{cd,ci}=sum(shuffleDiff>trueDiff,2)/1000;
    end

    trueCondDiffPop = mean(a.actDiffPostEBM{cd,2})-mean(a.actDiffPostEBM{cd,1});
    shuffleCondDiffPop = mean(a.actDiffPostEBMShuffle{cd,2}) - mean(a.actDiffPostEBMShuffle{cd,1});
    
    a.actDiffPopCondEBMSig{cd}=sum(shuffleCondDiffPop>trueCondDiffPop)/1000;
    
end

%% MEAN EBM DIFF IN EACH CONDITION IN EACH LEARNING TIME

for cd=1:size(a.compNamesFirst)

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
set(fig,'renderer','painters');
hold on;

e=a.compEventsFirst(cd);
t=a.t{e};
y1=a.activityDifferenceEBM{cd,1};
y2=a.activityDifferenceEBM{cd,2};
% y3=a.activityDifferenceEBM{cd,3};
% meanSh1=mean(squeeze(mean(a.activityDifferenceEBMShuffle{cd,1},1)),2);
% semSh1=sem(squeeze(mean(a.activityDifferenceEBMShuffle{cd,1},1)),2);
% meanSh2=mean(squeeze(mean(a.activityDifferenceEBMShuffle{cd,2},1)),2);
% semSh2=sem(squeeze(mean(a.activityDifferenceEBMShuffle{cd,2},1)),2);
label1=[conditionNames{1}, 'p= ', num2str(a.actDiffPopIdxEBMSig{cd,1})];
label2=[conditionNames{2}, 'p= ' ,num2str(a.actDiffPopIdxEBMSig{cd,2})];
% label3=[conditionNames{3}, 'p= ' ,num2str(a.actDiffPopIdxEBMSig{cd,3})];

p1 = a.actDiffPopIdxEBMSig{cd,1};
p2 = a.actDiffPopIdxEBMSig{cd,2};
if p1 == 0; pstr1 = 'p<2e-308'; else; pstr1 = sprintf('p=%.3e', p1); end
if p2 == 0; pstr2 = 'p<2e-308'; else; pstr2 = sprintf('p=%.3e', p2); end
label1 = [conditionNames{1}, ' ', pstr1];
label2 = [conditionNames{2}, ' ', pstr2];

nsubplot(1,1,1,1);
h_for_legend=[];
h_for_legend(end+1)=plot(t,mean(y1,'omitnan'),'Color','r','linewidth',4);
h = fill([t, fliplr(t)], [mean(y1,'omitnan')-sem(y1), fliplr(mean(y1,'omitnan')+sem(y1))], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(t,mean(y2,'omitnan'),'Color','b','linewidth',4);
h = fill([t, fliplr(t)], [mean(y2,'omitnan')-sem(y2), fliplr(mean(y2,'omitnan')+sem(y2))], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
% h_for_legend(end+1)=plot(t,mean(y3,'omitnan'),'Color','g','linewidth',4);
% h = fill([t, fliplr(t)], [mean(y3,'omitnan')-sem(y3), fliplr(mean(y3,'omitnan')+sem(y3))], 'b','EdgeColor','none');
% set(h, 'FaceAlpha', 0.1);
plot([0+PID 0+PID],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
plot([1.2 1.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);

% legend(h_for_legend,{label1 label2 label3},'Orientation','vertical','Location','northwest','Box','off');
legend(h_for_legend,{label1 label2},'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel(a.compLabels{cd})
title(a.compLabels{cd})

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_EBMdiff_',a.compLabels{cd},[conditionNames{:}]]),'pdf');
end

%% MEAN EBM DIFF IN EACH CONDITION DIFFERENCE BETWEEN EACH LEARNING TIME

for cd=1:size(a.compNamesFirst)
figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
set(fig,'renderer','painters');
hold on;

e=a.compEventsFirst(cd);
t=a.t{e};
y1=a.activityDifferenceEBM{cd,1};
y2=a.activityDifferenceEBM{cd,2};
% meanSh1=mean(squeeze(mean(a.activityDifferenceEBMShuffle{cd,1},1)),2);
% semSh1=sem(squeeze(mean(a.activityDifferenceEBMShuffle{cd,1},1)),2);
% meanSh2=mean(squeeze(mean(a.activityDifferenceEBMShuffle{cd,2},1)),2);
% semSh2=sem(squeeze(mean(a.activityDifferenceEBMShuffle{cd,2},1)),2);

p = a.actDiffPopCondEBMSig{cd};
if p == 0
    pstr = 'p<2e-308';
else
    pstr = sprintf('p=%.3e', p);
end
% title([a.compLabels{cd} ' ' pstr])

nsubplot(1,1,1,1);
plot(t,squeeze(mean(a.activityDifferenceEBMShuffle{cd,2},'omitnan'))-squeeze(mean(a.activityDifferenceEBMShuffle{cd,1},'omitnan')),'Color',a.grey,'linewidth',0.5);
plot(t,mean(y2,'omitnan')-mean(y1,'omitnan'),'Color',a.purple,'linewidth',4);
xlabel('Time')
ylabel(conditionNames)
title([a.compLabels{cd} ' ' pstr])
% title([a.compLabels{cd} ' p=' num2str(a.actDiffPopCondEBMSig{cd})])
plot([0+PID 0+PID],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
plot([1.2 1.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_EBMdiffShuffle_',a.compLabels{cd},'_absDiffShuffleEBM_',[conditionNames{:}]]),'pdf');
end

%% SHUFFLE RESPONSES ACROSS CONDITIONS TO FIND SHUFFLED ACTIVITY

yy1=[];
yy2=[];

yInfo1=a.C_odor1FirstInfoForced{1};
yRand1=a.C_odor1FirstRandForced{1};
yInfo2=a.C_odor1FirstInfoForced{2};
yRand2=a.C_odor1FirstRandForced{2};

yInfo1mean=mean(yInfo1,3,'omitnan');
% yInfo1mean=yInfo1mean-mean(yInfo1mean(:,30:40,:),2);
yInfo2mean=mean(yInfo2,3,'omitnan');
% yInfo2mean=yInfo1mean-mean(yInfo2mean(:,30:40,:),2);
yRand1mean=mean(yRand1,3,'omitnan');
% yRand1mean=yRand1mean-mean(yRand1mean(:,30:40,:),2);
yRand2mean=mean(yRand2,3,'omitnan');
% yRand2mean=yRand2mean-mean(yRand2mean(:,30:40,:),2);

y1=abs(yInfo1mean-yRand1mean); % info-rand for each cell in condition1
y2=abs(yInfo2mean-yRand2mean); % info-rand in condition2

% shuffle whether difference is in condition 1 or condition 2
for j=1:1000
   ii=rand(size(y1,1),1);
   yy1=NaN(size(y1));
   yy1(ii>0.5,:)=y1(ii>0.5,:); % randomly half of cells are from condition 1
   yy1(ii<=0.5,:)=y2(ii<=0.5,:);
   yy2(ii>0.5,:)=y2(ii>0.5,:); % randomly other half of cells are from condition 1
   yy2(ii<=0.5,:)=y1(ii<=0.5,:);
   ydiffshuffle1=yy1;
   ydiffshuffle2=yy2;
   shuffle1(j,:)=mean(ydiffshuffle1,1);
   shuffle2(j,:)=mean(ydiffshuffle2,1);
end

ydiff1=y1;
ydiff2=y2;
cond1=mean(ydiff1,1);
sem1=nanstd(ydiff1,[],1) ./ sqrt(size(ydiff1,1));
cond2=mean(ydiff2,1);
sem2=nanstd(ydiff2,[],1) ./ sqrt(size(ydiff2,1));

%% EBM

y11=yInfo1(:,:,1:2:end);
y12=yInfo1(:,:,2:2:end);
y21=yRand1(:,:,1:2:end);
y22=yRand1(:,:,2:2:end);

y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
y1mean2 = mean(y12,3,'omitnan');
y2mean1 = mean(y21,3,'omitnan');
y2mean2 = mean(y22,3,'omitnan');

activityDifferenceTrial1 = y1mean1-y2mean1;
activityDifferenceTrial2 = y1mean2-y2mean2;
a.activityDifferenceTrialEBM{1} = (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;
   
y11=yInfo2(:,:,1:2:end);
y12=yInfo2(:,:,2:2:end);
y21=yRand2(:,:,1:2:end);
y22=yRand2(:,:,2:2:end);

y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
y1mean2 = mean(y12,3,'omitnan');
y2mean1 = mean(y21,3,'omitnan');
y2mean2 = mean(y22,3,'omitnan');

activityDifferenceTrial1 = y1mean1-y2mean1;
activityDifferenceTrial2 = y1mean2-y2mean2;
a.activityDifferenceTrialEBM{2} = (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;


%%
nInfo1=sum(~isnan(yInfo1(cumsum(mouseCells),1,:)),3); % number of non-NaN trials per mouse
nInfo2=sum(~isnan(yInfo2(cumsum(mouseCells),1,:)),3);
nRand1=sum(~isnan(yRand1(cumsum(mouseCells),1,:)),3); % number of non-NaN trials per mouse
nRand2=sum(~isnan(yRand2(cumsum(mouseCells),1,:)),3);
allN=max(max([nInfo1 nInfo2 nRand1 nRand2]));
for m=1:numel(mice)
    yyInfo1{m}=yInfo1(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nInfo1(m)); % that mouse's activity (noNaN) for condition 1
    yyInfo2{m}=yInfo2(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nInfo2(m));
    yyInfo{m}=cat(3,yyInfo1{m},yyInfo2{m}); % stack condition 1 and condition 2 for that mouse
    iiInfo{m}(1:nInfo1(m),1)=1; % label for condition 1 trials for that mouse
    iiInfo{m}(nInfo1(m)+1:nInfo1(m)+nInfo2(m),1)=2; % label for condition 2 trials for that mouse       
    yyRand1{m}=yRand1(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nRand1(m)); % that mouse's activity (noNaN) for condition 1
    yyRand2{m}=yRand2(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nRand2(m));
    yyRand{m}=cat(3,yyRand1{m},yyRand2{m}); % stack condition 1 and condition 2 for that mouse
    iiRand{m}(1:nRand1(m),1)=1; % label for condition 1 trials for that mouse
    iiRand{m}(nRand1(m)+1:nRand1(m)+nRand2(m),1)=2; % label for condition 2 trials for that mouse       
end

%%
for j=1:1000
    for m=1:numel(mice) 
        shuffleInfo=randperm(nInfo1(m)+nInfo2(m));
        yInfoShuffle=yyInfo{m}(:,:,shuffleInfo);
        shuffleRand=randperm(nRand1(m)+nRand2(m));
        yRandShuffle=yyRand{m}(:,:,shuffleRand);
        yInfo1Shuffle=yInfoShuffle(:,:,iiInfo{m}==1);
        yInfo2Shuffle=yInfoShuffle(:,:,iiInfo{m}==2);
        sInfo1=NaN(size(yInfo1Shuffle,1),size(yInfo1Shuffle,2),allN); % fill with NaN for matched size
        sInfo1(:,:,1:size(yInfo1Shuffle,3))=yInfo1Shuffle;
        sInfo2=NaN(size(yInfo2Shuffle,1),size(yInfo2Shuffle,2),allN); % fill with NaN for matched size
        sInfo2(:,:,1:size(yInfo2Shuffle,3))=yInfo2Shuffle;            
        yRand1Shuffle=yRandShuffle(:,:,iiRand{m}==1);
        yRand2Shuffle=yRandShuffle(:,:,iiRand{m}==2);
        sRand1=NaN(size(yRand1Shuffle,1),size(yRand1Shuffle,2),allN); % fill with NaN for matched size
        sRand1(:,:,1:size(yRand1Shuffle,3))=yRand1Shuffle;
        sRand2=NaN(size(yRand2Shuffle,1),size(yRand2Shuffle,2),allN); % fill with NaN for matched size
        sRand2(:,:,1:size(yRand2Shuffle,3))=yRand2Shuffle;
        if m==1 % concatenate mice back together
           yShInfo1=sInfo1;
           yShInfo2=sInfo2;
           yShRand1=sRand1;
           yShRand2=sRand2;
        else
            yShInfo1=cat(1,yShInfo1,sInfo1);
            yShInfo2=cat(1,yShInfo2,sInfo2);
            yShRand1=cat(1,yShRand1,sRand1);
            yShRand2=cat(1,yShRand2,sRand2);
        end
    end

    yShInfo1mean=mean(yShInfo1,3,'omitnan'); % mean across trials of info activity shuffled between cond1 and cond2
    yShRand1mean=mean(yShRand1,3,'omitnan');
    shuffleDiff1(j,:)=mean(abs(yShInfo1mean-yShRand1mean)); % mean abs diff b/t info and rand with info and rand shuffled across cond1 and cond 2
    yShInfo2mean=mean(yShInfo2,3,'omitnan');
    yShRand2mean=mean(yShRand2,3,'omitnan');
    shuffleDiff2(j,:)=mean(abs(yShInfo2mean-yShRand2mean));        

end

%% ABSOLUTE DIFFERENCE IN ACTIVITY IN EACH CONDITION

semSh=nanstd(shuffleDiff1,[],1) ./ sqrt(size(shuffleDiff1,1));
meanSh=mean(shuffleDiff1);
semSh2=nanstd(shuffleDiff2,[],1) ./ sqrt(size(shuffleDiff2,1));
meanSh2=mean(shuffleDiff2);

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;

nsubplot(1,1,1,1);
h_for_legend=[];
h_for_legend(end+1)=plot(cond1,'Color','r','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond1-sem1, fliplr(cond1+sem1)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(cond2,'Color','b','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond2-sem2, fliplr(cond2+sem2)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(meanSh,'Color',a.grey,'linewidth',4);
h = fill([1:80, fliplr(1:80)], [meanSh-semSh, fliplr(meanSh+semSh)],a.grey,'EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(meanSh,'Color','k','linewidth',4);
h = fill([1:80, fliplr(1:80)], [meanSh2-semSh2, fliplr(meanSh2+semSh2)],'k','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);

% plot(mean(shuffle1),'Color',a.grey,'linewidth',4);
% plot(mean(shuffle2),'Color','k','linewidth',4);

% plot(shuffleDiff1,'Color',a.grey,'linewidth',4);
% plot(mean(abs(yShInfo2-yShRand2)),'Color',a.grey,'linewidth',4);



% for i=1:size(shuffleDiff1,1)
% %     plot(shuffle1(i,:),'Color',a.grey,'linewidth',0.5);
% %     plot(shuffle2(i,:),'Color','k','linewidth',0.5);
%     plot(shuffleDiff1(i,:),'Color',a.grey,'linewidth',0.5);
%     plot(shuffleDiff2(i,:),'Color','k','linewidth',0.5);
% end

legend(h_for_legend,[conditionNames 'Shuffle1' 'Shuffle2'],'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of Info-No Info')
title('Info - No Info Abs Diff')

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_absDiffShuffle_',[conditionNames{:}]]),'pdf');

%% ABSOLUTE DIFFERENCE IN ACTIVITY IN EACH CONDITION WITH SIMPLER SHUFFLE

semSh=nanstd(shuffle1,[],1) ./ sqrt(size(shuffle1,1));
meanSh=mean(shuffle1);
semSh2=nanstd(shuffle2,[],1) ./ sqrt(size(shuffle2,1));
meanSh2=mean(shuffle2);
figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
set(fig,'renderer','painters');
hold on;

nsubplot(1,1,1,1);
h_for_legend=[];
h_for_legend(end+1)=plot(cond1,'Color','r','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond1-sem1, fliplr(cond1+sem1)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(cond2,'Color','b','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond2-sem2, fliplr(cond2+sem2)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);

% h = fill([1:80, fliplr(1:80)], [meanSh-semSh, fliplr(meanSh+semSh)],a.grey,'EdgeColor','none');
% set(h, 'FaceAlpha', 0.1);
% h_for_legend(end+1)=plot(meanSh,'Color','k','linewidth',4);
% h = fill([1:80, fliplr(1:80)], [meanSh2-semSh2, fliplr(meanSh2+semSh2)],'k','EdgeColor','none');
% set(h, 'FaceAlpha', 0.1);


% plot(mean(shuffle1),'Color',a.grey,'linewidth',4);
% plot(mean(shuffle2),'Color','k','linewidth',4);

% plot(shuffleDiff1,'Color',a.grey,'linewidth',4);
% plot(mean(abs(yShInfo2-yShRand2)),'Color',a.grey,'linewidth',4);

h_for_legend(end+1)=plot(shuffle1(1,:),'Color',a.grey,'linewidth',0.5);
for i=2:size(shuffle1,1)
    plot(shuffle1(i,:),'Color',a.grey,'linewidth',0.5);
%     plot(shuffle2(i,:),'Color','k','linewidth',0.5);
% %     plot(shuffleDiff1(i,:),'Color',a.grey,'linewidth',0.5);
% %     plot(shuffleDiff2(i,:),'Color','k','linewidth',0.5);
end
h_for_legend(end+1)=plot(meanSh,'Color','k','linewidth',4);

legend(h_for_legend,[conditionNames 'shuffle1' 'shuffle2'],'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of Info-No Info')
title('Info - No Info  Abs Diff')

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_absDiffShuffle2all_',[conditionNames{:}]]),'pdf');

%% EBM DIFFERENCE IN ACTIVITY IN EACH CONDITION WITH SIMPLER SHUFFLE

semSh=nanstd(shuffle1,[],1) ./ sqrt(size(shuffle1,1));
meanSh=mean(shuffle1);
semSh2=nanstd(shuffle2,[],1) ./ sqrt(size(shuffle2,1));
meanSh2=mean(shuffle2);

y1=a.activityDifferenceEBM{1};
y2=a.activityDifferenceEBM{2};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
set(fig,'renderer','painters');
hold on;

nsubplot(1,1,1,1);
h_for_legend=[];
h_for_legend(end+1)=plot(mean(y1),'Color','r','linewidth',4);
h = fill([1:80, fliplr(1:80)], [mean(y1)-sem(y1), fliplr(mean(y1)+sem(y1))], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(mean(y2),'Color','b','linewidth',4);
h = fill([1:80, fliplr(1:80)], [mean(y2)-sem(y2), fliplr(mean(y2)+sem(y2))], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);

% h = fill([1:80, fliplr(1:80)], [meanSh-semSh, fliplr(meanSh+semSh)],a.grey,'EdgeColor','none');
% set(h, 'FaceAlpha', 0.1);
% h_for_legend(end+1)=plot(meanSh,'Color','k','linewidth',4);
% h = fill([1:80, fliplr(1:80)], [meanSh2-semSh2, fliplr(meanSh2+semSh2)],'k','EdgeColor','none');
% set(h, 'FaceAlpha', 0.1);


% plot(mean(shuffle1),'Color',a.grey,'linewidth',4);
% plot(mean(shuffle2),'Color','k','linewidth',4);

% plot(shuffleDiff1,'Color',a.grey,'linewidth',4);
% plot(mean(abs(yShInfo2-yShRand2)),'Color',a.grey,'linewidth',4);
h_for_legend(end+1)=plot(shuffle1(1,:),'Color',a.grey,'linewidth',0.5);
for i=2:size(shuffle1,1)
    plot(shuffle1(i,:),'Color',a.grey,'linewidth',0.5);
%     plot(shuffle2(i,:),'Color','k','linewidth',0.5);
% %     plot(shuffleDiff1(i,:),'Color',a.grey,'linewidth',0.5);
% %     plot(shuffleDiff2(i,:),'Color','k','linewidth',0.5);
end
h_for_legend(end+1)=plot(meanSh,'Color','k','linewidth',4);

legend(h_for_legend,[conditionNames 'shuffle1' 'shuffle2'],'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of Info-No Info')
title('Info - No Info EBM')

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_absDiffShuffle3all_',[conditionNames{:}]]),'pdf');


%% ABSOLUTE DIFFERENCE IN ACTIVITY BETWEEN CONDITIONS

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;

nsubplot(1,1,1,1);
plot(cond2-cond1,'Color','b','linewidth',4);
for i=1:100
plot(shuffleDiff2(i,:)-shuffleDiff1(i,:),'Color',a.grey,'linewidth',0.5);
end
ylim([-0.05 0.15])
xlabel('Time')
ylabel('Condition 2 Infodiff - Condition 1 Infodiff')

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_',allconditions,'_CondDiffInfo-NoInfo']),'pdf');

%% ABSOLUTE DIFFERENCE IN ACTIVITY BETWEEN CONDITIONS 2

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;

nsubplot(1,1,1,1);
plot(cond2-cond1,'Color','b','linewidth',4);
for i=1:100
plot(shuffle2(i,:)-shuffle1(i,:),'Color',a.grey,'linewidth',0.5);
end
ylim([-0.05 0.15])
xlabel('Time')
ylabel('Condition 2 Infodiff - Condition 1 Infodiff')

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_',allconditions,'_CondDiff2Info-NoInfo']),'pdf');

%% ABS DIFF FOR INFO-No INFO CELLS ONLY

infoCells=[a.C_condShuffleDifferent{1,1} a.C_condShuffleDifferent{1,2}];
% infoCells=[a.RSpvalsmean{1,1} a.RSpvalsmean{1,2}]<0.05;
infoBothCells=sum(infoCells,2)==2;

yInfo1=a.C_odor1FirstInfoForced{1};
yRand1=a.C_odor1FirstRandForced{1};
yInfo2=a.C_odor1FirstInfoForced{2};
yRand2=a.C_odor1FirstRandForced{2};

yInfo1mean=mean(yInfo1,3,'omitnan');
% yInfo1mean=yInfo1mean-mean(yInfo1mean(:,30:40,:),2);
yInfo2mean=mean(yInfo2,3,'omitnan');
% yInfo2mean=yInfo1mean-mean(yInfo2mean(:,30:40,:),2);
yRand1mean=mean(yRand1,3,'omitnan');
% yRand1mean=yRand1mean-mean(yRand1mean(:,30:40,:),2);
yRand2mean=mean(yRand2,3,'omitnan');
% yRand2mean=yRand2mean-mean(yRand2mean(:,30:40,:),2);

y1=abs(yInfo1mean-yRand1mean); % info-rand for each cell in condition1
y2=abs(yInfo2mean-yRand2mean); % info-rand in condition2

ydiff1=y1(infoCells(:,1),:);
ydiff2=y2(infoCells(:,2),:);
cond1=mean(ydiff1,1);
sem1=nanstd(ydiff1,[],1) ./ sqrt(size(ydiff1,1));
cond2=mean(ydiff2,1);
sem2=nanstd(ydiff2,[],1) ./ sqrt(size(ydiff2,1));

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;

nsubplot(1,1,1,1);
h_for_legend=[];
h_for_legend(end+1)=plot(cond1,'Color','r','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond1-sem1, fliplr(cond1+sem1)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(cond2,'Color','b','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond2-sem2, fliplr(cond2+sem2)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);

legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of Info-No Info')
title('Info - No Info, differentiating cells only')

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_absDiffInfoCellsOnly_',[conditionNames{:}]]),'pdf');

%% INFO AND NO INFO MEAN ACTIVITY RESPONDING CELLS ONLY

% a.cellTypes{cm}
% infoRespCells1=a.cellTypes{1}(:,1)<0.05;
% noInfoRespCells1=a.cellTypes{1}(:,3)<0.05;
% infoRespCells2=a.cellTypes{2}(:,1)<0.05;
% noInfoRespCells2=a.cellTypes{2}(:,3)<0.05;

infoRespCells1=a.C_condBasePostRSActiveExp{1,1}(:,1);
noInfoRespCells1=a.C_condBasePostRSActiveExp{1,1}(:,3);
infoRespCells2=a.C_condBasePostRSActiveExp{1,2}(:,1);
noInfoRespCells2=a.C_condBasePostRSActiveExp{1,2}(:,3);

yInfo1=mean(a.C_odor1FirstInfoForced{1},3,'omitnan');
yRand1=mean(a.C_odor1FirstRandForced{1},3,'omitnan');
yInfo2=mean(a.C_odor1FirstInfoForced{2},3,'omitnan');
yRand2=mean(a.C_odor1FirstRandForced{2},3,'omitnan');

yInfo1=yInfo1-mean(yInfo1(:,30:40),2);
yInfo2=yInfo2-mean(yInfo2(:,30:40),2);
yRand1=yRand1-mean(yRand1(:,30:40),2);
yRand2=yRand2-mean(yRand2(:,30:40),2);

yInfo1=yInfo1(infoRespCells1,:);
yInfo2=yInfo2(infoRespCells2,:);
yRand1=yRand1(noInfoRespCells1,:);
yRand2=yRand2(noInfoRespCells2,:);

yInfo1mean=mean(yInfo1);
yInfo2mean=mean(yInfo2);
yRand1mean=mean(yRand1);
yRand2mean=mean(yRand2);

yInfo1sem=std(yInfo1,[],1) ./ sqrt(size(yInfo1,1));
yInfo2sem=std(yInfo2,[],1) ./ sqrt(size(yInfo2,1));
yRand1sem=std(yRand1,[],1) ./ sqrt(size(yRand1,1));
yRand2sem=std(yRand2,[],1) ./ sqrt(size(yRand2,1));

e = a.nameEventsFirst(1);
ypostI1 = squeeze(mean(a.C_odor1FirstInfoForced{1}(infoRespCells1,a.okt{e},:),2,'omitnan')); % one value for each trial for each responding cell (mean over 1s post)
ypostI2 = squeeze(mean(a.C_odor1FirstInfoForced{2}(infoRespCells2,a.okt{e},:),2,'omitnan')); % one value for each trial for each responding cell (mean over 1s post)
ypostImean1=mean(ypostI1,'omitnan')';
ypostImean2=mean(ypostI2,'omitnan')';
ptrials(1,1)=ranksum(ypostI1(:),ypostI2(:)); % one value for each trial for each responding cell (mean over 1s post)
pcells(1,1)=ranksum(ypostImean1(:),ypostImean2(:));
ypostN1 = squeeze(mean(a.C_odor1FirstRandForced{1}(noInfoRespCells1,a.okt{e},:),2,'omitnan'));
ypostN2 = squeeze(mean(a.C_odor1FirstRandForced{2}(noInfoRespCells2,a.okt{e},:),2,'omitnan'));
ypostNmean1=mean(ypostN1,'omitnan')';
ypostNmean2=mean(ypostN2,'omitnan')';
ptrials(1,2)=ranksum(ypostN1(:),ypostN2(:));
pcells(1,2)=ranksum(ypostNmean1(:),ypostNmean2(:));

t=a.t{9};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;

nsubplot(1,2,1,1);
h_for_legend=[];
h_for_legend(end+1)=plot(t,yInfo1mean,'Color','r','linewidth',4);
h = fill([t, fliplr(t)], [yInfo1mean-yInfo1sem, fliplr(yInfo1mean+yInfo1sem)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(t,yInfo2mean,'Color','b','linewidth',4);
h = fill([t, fliplr(t)], [yInfo2mean-yInfo2sem, fliplr(yInfo2mean+yInfo2sem)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
xlim([-0.5 1.2]);
xticks([-2:0.2:2]);
axis square;

legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of Info')
% title('Info, responding cells only, p trials= p cells=')
pstr1 = sprintf('%.4e', ptrials(1));
pstr2 = sprintf('%.4e', pcells(1));
title(sprintf('Info, responding cells only, p trials=%s p cells=%s', pstr1, pstr2))

nsubplot(1,2,1,2);
h_for_legend=[];
h_for_legend(end+1)=plot(t,yRand1mean,'Color','r','linewidth',4);
h = fill([t, fliplr(t)], [yRand1mean-yRand1sem, fliplr(yRand1mean+yRand1sem)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(t,yRand2mean,'Color','b','linewidth',4);
h = fill([t, fliplr(t)], [yRand2mean-yRand2sem, fliplr(yRand2mean+yRand2sem)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
xlim([-0.5 1.2]);
xticks([-2:0.2:2]);
axis square;

legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of No Info')
% title('No Info, responding cells only')
pstr1 = sprintf('%.4e', ptrials(2));
pstr2 = sprintf('%.4e', pcells(2));
title(sprintf('No Info, responding cells only, p trials=%s p cells=%s', pstr1, pstr2))

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_meanActivityRespondingcells_',[conditionNames{:}]]),'pdf');

%% DIFFERENTIATING CELLS VENNS

for cd=1:1:size(a.compNamesFirst)
%     diffCells=[a.C_condShuffleDifferent{cd,1} a.C_condShuffleDifferent{cd,2}];
    diffCells=[a.actDiffIdxEBMSig{cd,1}<0.05 a.actDiffIdxEBMSig{cd,2}<0.05];
    cond1Cells = diffCells(:,1);
    cond2Cells = diffCells(:,2);

    setLabels = {conditionNames{1}; conditionNames{2}};

    vennPlot{1}=find(cond1Cells);
    vennPlot{2}=find(cond2Cells);
    
    [tbl,chi2,p] = crosstab(cond1Cells,cond2Cells);

    figure();
    fig = gcf;
    fig.PaperUnits = 'inches';
    set(fig,'PaperOrientation','landscape');
    fig.PaperSize = [11 8.5];
    fig.PaperPosition = [0 0 10 8];

    h=vennEulerDiagram(vennPlot, setLabels, 'drawProportional', true,'showintersectioncounts',true);

    % axis square;
    title([a.compLabels{cd} ' EBM diff cells p=' num2str(p)])
    saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_',allconditions,'_',a.compLabels{cd},'_EBMVenn']),'pdf');
end

%% OVERLAP

cond1Cells=a.actDiffIdxEBMSig{1,1}<0.05;
cond2Cells=a.actDiffIdxEBMSig{1,2}<0.05;

totalCells = cond1Cells|cond2Cells;

inA=cond1Cells(totalCells);
inB=cond2Cells(totalCells);

overlapObs = sum(inA & inB);

nPerm = 10000;
null = zeros(nPerm,1);

for k = 1:nPerm
    shufB = inB(randperm(length(inB)));  % permute labels
    null(k) = sum(inA & shufB);
end

pHigh = (sum(null >= overlapObs) + 1) / (nPerm + 1);
pLow  = (sum(null <= overlapObs) + 1) / (nPerm + 1);
pTwo  = min(2 * min(pHigh, pLow), 1);

fprintf('Observed overlap within labeled cells %d, two-tailed p = %.4f\nhigh p = %.4f low p = %.4f\n', overlapObs, pTwo, pHigh, pLow);

inA=cond1Cells;
inB=cond2Cells;

overlapObs = sum(inA & inB);

nPerm = 10000;
null = zeros(nPerm,1);

for k = 1:nPerm
    shufB = inB(randperm(length(inB)));  % permute labels
    null(k) = sum(inA & shufB);
end

pHigh = (sum(null >= overlapObs) + 1) / (nPerm + 1);
pLow  = (sum(null <= overlapObs) + 1) / (nPerm + 1);
pTwo  = min(2 * min(pHigh, pLow), 1);

fprintf('Observed overlap across all cells %d, two-tailed p = %.4f\nhigh p = %.4f low p = %.4f\n', overlapObs, pTwo, pHigh, pLow);


chanceOverlap=(sum(inA)/a.neuronCt)*(sum(inB)/a.neuronCt);
vsChance=(overlapObs/a.neuronCt)/chanceOverlap;

%% RESPONDING CELLS VENNS

for cd=1:1:size(a.namesFirst)
    cname = a.namesFirst{cd};
    for ci=1:numel(cname)
        activeCells=[a.C_condBasePostRSActiveExp{cd,1}(:,ci) a.C_condBasePostRSActiveExp{cd,2}(:,ci)];
        cond1Cells = activeCells(:,1);
        cond2Cells = activeCells(:,2);

        setLabels = {conditionNames{1}; conditionNames{2}};

        vennPlot{1}=find(cond1Cells);
        vennPlot{2}=find(cond2Cells);

        if sum(cond1Cells)>0 & sum(cond2Cells)>0
            figure();
            fig = gcf;
            fig.PaperUnits = 'inches';
            set(fig,'PaperOrientation','landscape');
            fig.PaperSize = [11 8.5];
            fig.PaperPosition = [0 0 10 8];

            h=vennEulerDiagram(vennPlot, setLabels, 'drawProportional', true,'showintersectioncounts',true);

            % axis square;
            title([a.labels{cd}{ci} ' Responding Cells in Each Condition'])
            saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_',allconditions,'_',a.labels{cd}{ci},'_RespVenn']),'pdf');
        end
    end
end


%% INFO-NO INFO VENN

for cm=1:condct
infoCells=a.C_condBasePostRSActiveExp{1,cm}(:,1);
randCells=a.C_condBasePostRSActiveExp{1,cm}(:,3);
figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% ax=nsubplot(1,1,1,1); hold off;

vennPlot{1}=find(infoCells);
vennPlot{2}=find(randCells);

h=vennEulerDiagram(fig,vennPlot, {'Info','No Info'}, 'drawProportional', true,'showintersectioncounts',true);
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoNoInfoVenn_',conditionNames{cm}]),'pdf');
end

%% OF INFO-NO INFO CELLS, IS INFO BIGGER OR LESS IN SECOND CONDITION?
% IS NO INFO BIGGER OR LESS IN SECOND CONDITION?

infoCells=[a.C_condShuffleDifferent{1,1} a.C_condShuffleDifferent{1,2}];

% INFO cells in condition 1
a.cellChange(1,1)=sum(a.activityPostDiff_xcond{1,1}(infoCells(:,1),:)>0)/sum(infoCells(:,1)); % INFO cells in time 1 with greater INFO resp in time 2 than time 1
a.cellChange(1,2)=sum(a.activityPostDiff_xcond{1,3}(infoCells(:,1),:)>0)/sum(infoCells(:,1)); % INFO cells in time 1 with greater NO INFO resp in time 2 than time 1

% INFO cells in condition 1
a.cellChange(1,3)=sum(a.activityPostDiff_xcond{1,1}(infoCells(:,2),:)>0)/sum(infoCells(:,2)); % INFO cells in time 2 with greater INFO resp in time 2 than time 1
a.cellChange(1,4)=sum(a.activityPostDiff_xcond{1,3}(infoCells(:,2),:)>0)/sum(infoCells(:,2)); % INFO cells in time 2 with greater NO INFO resp in time 2 than time 1

increaseLabels={[conditionNames{1} ' Cells Info Response Increased'],...
    [conditionNames{1} ' Cells No Info Response Increased'],...
    [conditionNames{2} ' Cells Info Response Increased'],...
    [conditionNames{2} ' Cells No Info Response Increased']};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;
nsubplot(1,1,1,1);
bar(a.cellChange);
ylabel('% of cells')
ylim([0 1]);
xticks([1 2 3 4]);
title('Info-No Info Differentiating Cells')
xticklabels(increaseLabels);
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_',allconditions,'_IncreasingCells']),'pdf');

%% CONDITIONAL MEAN ACTIVITY BEFORE AND AFTER

% test=mean(mean(a.C_odor1FirstInfo{1},3,'omitnan'));
% test2=mean(mean(a.C_odor1FirstInfo{2},3,'omitnan'));
% test=test-mean(test(20:40));
% test2=test2-mean(test2(20:40));
% figure();hold on;plot(test)
% plot(test2)

for cd = 1:size(a.compNamesFirst)
    cname = a.compNamesFirst{cd};
    e = a.compEventsFirst(cd);
    cy = cellfun(@(z) a.(z),cname,'uniform',0); 
    
    ya1 = cy{1}{1}; % info in that learning condition
    ya2 = cy{1}{2}; % info in that learning condition
    yb1 = cy{2}{1}; %rand in that learning condition
    yb2 = cy{2}{2}; %rand in that learning condition
    ya1TrialMean=mean(ya1,3,'omitnan'); %yInfo1
    ya2TrialMean=mean(ya2,3,'omitnan');
    yb1TrialMean=mean(yb1,3,'omitnan'); %yRand1   
    yb2TrialMean=mean(yb2,3,'omitnan');      
    ya1Trialmean=ya1TrialMean-mean(ya1TrialMean(:,30:40),2);
    ya2Trialmean=ya2TrialMean-mean(ya2TrialMean(:,30:40),2);
    yb1Trialmean=yb1TrialMean-mean(yb1TrialMean(:,30:40),2);
    yb2Trialmean=yb2TrialMean-mean(yb2TrialMean(:,30:40),2);
    ya1mean=mean(ya1Trialmean);
    ya2mean=mean(ya2Trialmean);
    yb1mean=mean(yb1Trialmean);
    yb2mean=mean(yb2Trialmean);
%     ya1mean=mean(ya1TrialMean-mean(ya1TrialMean(:,30:40),2),1); %yInfo1mean
%     ya2mean=mean(ya2TrialMean-mean(ya2TrialMean(:,30:40),2),1);
%     yb1mean=mean(yb1TrialMean-mean(yb1TrsialMean(:,30:40),2),1);
%     yb2mean=mean(yb2TrialMean-mean(yb2TrialMean(:,30:40),2),1);
    ya1sem=std(ya1Trialmean,[],1,'omitnan')./sqrt(size(ya1Trialmean,1));
    ya2sem=std(ya2Trialmean,[],1,'omitnan')./sqrt(size(ya2Trialmean,1));
    yb1sem=std(yb1Trialmean,[],1,'omitnan')./sqrt(size(yb1Trialmean,1));
    yb2sem=std(yb2Trialmean,[],1,'omitnan')./sqrt(size(yb2Trialmean,1));
    t=a.t{e};

    figure()
    fig=gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 11 8.5];
    set(fig,'PaperOrientation','landscape');
    hold on;

    nsubplot(1,2,1,1);
    h_for_legend=[];
    h_for_legend(end+1)=plot(t,ya1mean,'Color','r','linewidth',4);
    h = fill([t, fliplr(t)], [ya1mean-ya1sem, fliplr(ya1mean+ya1sem)], 'r','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    h_for_legend(end+1)=plot(t,ya2mean,'Color','b','linewidth',4);
    h = fill([t, fliplr(t)], [ya2mean-ya2sem, fliplr(ya2mean+ya2sem)], 'b','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    xlim([-0.5 1.2]);
    xticks([-2:0.2:2]);
%     ylim([-0.02 0.1])
    axis square;

    legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
    xlabel('Time')
    ylabel(['Mean of ' a.conditionLabels{cd}{1}])
    title([a.conditionLabels{cd}{1} ', all cells'])

    nsubplot(1,2,1,2);
    h_for_legend=[];
    h_for_legend(end+1)=plot(t,yb1mean,'Color','r','linewidth',4);
    h = fill([t, fliplr(t)], [yb1mean-yb1sem, fliplr(yb1mean+yb1sem)], 'r','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    h_for_legend(end+1)=plot(t,yb2mean,'Color','b','linewidth',4);
    h = fill([t, fliplr(t)], [yb2mean-yb2sem, fliplr(yb2mean+yb2sem)], 'b','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    xlim([-0.5 1.2]);
    xticks([-2:0.2:2]);
%     ylim([-0.02 0.1])
    axis square;

    legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
    xlabel('Time')
    ylabel(['Mean of ' a.conditionLabels{cd}{2}])
    title([a.conditionLabels{cd}{2}  ', all cells'])

    saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_meanActivitybyCondition_',allconditions,'_',a.compLabels{cd}]),'pdf');

%     ya1TimeMean=mean(ya1TrialMean(:,a.okt{e}),2); %yInfo1
%     ya2TimeMean=mean(ya2TrialMean(:,a.okt{e}),2);
%     yb1TimeMean=mean(yb1TrialMean(:,a.okt{e}),2); 
%     yb2TimeMean=mean(yb2TrialMean(:,a.okt{e}),2); 
% 
%     a.meanActP{cd,1}=ranksum(ya1TimeMean,ya2TimeMean);
%     a.meanActP{cd,2}=ranksum(yb1TimeMean,yb2TimeMean);
%     
%     test=mean(ya1(:,a.okt{e},:),2,'omitnan');
%     test2=test(~isnan(test(:)));
%     
%     test3=mean(ya2(:,a.okt{e},:),2,'omitnan');
%     test4=test(~isnan(test3(:)));    
%     
    
%     figure()
%     fig=gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'PaperOrientation','landscape');
%     hold on;
% 
%     nsubplot(1,2,1,1);
%     h_for_legend=[];
%     h_for_legend(end+1)=plot(t,ya1mean,'Color','b','linewidth',4);
%     h = fill([t, fliplr(t)], [ya1mean-ya1sem, fliplr(ya1mean+ya1sem)], 'b','EdgeColor','none');
%     set(h, 'FaceAlpha', 0.1);
%     h_for_legend(end+1)=plot(t,yb1mean,'Color','r','linewidth',4);
%     h = fill([t, fliplr(t)], [yb1mean-yb1sem, fliplr(yb1mean+yb1sem)], 'r','EdgeColor','none');
%     set(h, 'FaceAlpha', 0.1);
%     xlim([-0.5 1.2]);
%     xticks([-2:0.2:2]);
% %     ylim([-0.02 0.1])
%     axis square;
% 
%     legend(h_for_legend,{a.conditionLabels{cd}{1},a.conditionLabels{cd}{2}},'Orientation','vertical','Location','northwest','Box','off');
%     xlabel('Time')
%     ylabel('Mean Activity')
%     title([conditionNames{1} ' all cells'])
% 
%     nsubplot(1,2,1,2);
%     h_for_legend=[];
%     h_for_legend(end+1)=plot(t,ya2mean,'Color','b','linewidth',4);
%     h = fill([t, fliplr(t)], [ya2mean-ya2sem, fliplr(ya2mean+ya2sem)], 'b','EdgeColor','none');
%     set(h, 'FaceAlpha', 0.1);
%     h_for_legend(end+1)=plot(t,yb2mean,'Color','r','linewidth',4);
%     h = fill([t, fliplr(t)], [yb2mean-yb2sem, fliplr(yb2mean+yb2sem)], 'r','EdgeColor','none');
%     set(h, 'FaceAlpha', 0.1);
%     xlim([-0.5 1.2]);
%     xticks([-2:0.2:2]);
% %     ylim([-0.02 0.1])
%     axis square;
% 
%     legend(h_for_legend,{a.conditionLabels{cd}{1},a.conditionLabels{cd}{2}},'Orientation','vertical','Location','northwest','Box','off');
%     xlabel('Time')
%     ylabel('Mean of No Info')
%     title([conditionNames{2} ' all cells'])
% 
%     saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_meanActivitybyLearning_',allconditions,'_',a.compLabels{cd}]),'pdf');

end

%% CONDITIONAL MEAN ACTIVITY BEFORE AND AFTER ONLY DIFFERENT CELLS

for cd = 1:size(a.compNamesFirst)
    cname = a.compNamesFirst{cd};
    e = a.compEventsFirst(cd);
    cy = cellfun(@(z) a.(z),cname,'uniform',0);
        
    ya1 = cy{1}{1}; % info in that learning condition
    ya2 = cy{1}{2}; % info in that learning condition
    yb1 = cy{2}{1}; %rand in that learning condition
    yb2 = cy{2}{2}; %rand in that learning condition
    ya1TrialMean=mean(ya1,3,'omitnan'); %yInfo1 mean across trials
    ya2TrialMean=mean(ya2,3,'omitnan');
    yb1TrialMean=mean(yb1,3,'omitnan');
    yb2TrialMean=mean(yb2,3,'omitnan');    %yRand1     
    ya1Trialmean=ya1TrialMean-mean(ya1TrialMean(:,30:40),2);
    ya2Trialmean=ya2TrialMean-mean(ya2TrialMean(:,30:40),2);
    yb1Trialmean=yb1TrialMean-mean(yb1TrialMean(:,30:40),2);
    yb2Trialmean=yb2TrialMean-mean(yb2TrialMean(:,30:40),2);
    ya1Trialmean=ya1Trialmean(a.C_condShuffleDifferent{cd,1},:);
    ya2Trialmean=ya2Trialmean(a.C_condShuffleDifferent{cd,2},:);
    yb1Trialmean=yb1Trialmean(a.C_condShuffleDifferent{cd,1},:);
    yb2Trialmean=yb2Trialmean(a.C_condShuffleDifferent{cd,2},:);
%     ya1Trialmean=ya1Trialmean(a.actDiffIdxEBMSig{1,1}<0.05,:);
%     ya2Trialmean=ya2Trialmean(a.actDiffIdxEBMSig{1,1}<0.05,:);
%     yb1Trialmean=yb1Trialmean(a.actDiffIdxEBMSig{1,1}<0.05,:);
%     yb2Trialmean=yb2Trialmean(a.actDiffIdxEBMSig{1,1}<0.05,:);    
    ya1mean=mean(ya1Trialmean); %yInfo1mean across cells
    ya2mean=mean(ya2Trialmean);
    yb1mean=mean(yb1Trialmean);
    yb2mean=mean(yb2Trialmean);
    ya1sem=std(ya1Trialmean,[],1,'omitnan')./sqrt(size(ya1Trialmean,1));
    ya2sem=std(ya2Trialmean,[],1,'omitnan')./sqrt(size(ya2Trialmean,1));
    yb1sem=std(yb1Trialmean,[],1,'omitnan')./sqrt(size(yb1Trialmean,1));
    yb2sem=std(yb2Trialmean,[],1,'omitnan')./sqrt(size(yb2Trialmean,1));
    t=a.t{e};

    figure()
    fig=gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 11 8.5];
    set(fig,'PaperOrientation','landscape');
    hold on;

    nsubplot(1,2,1,1);
    h_for_legend=[];
    h_for_legend(end+1)=plot(t,ya1mean,'Color','r','linewidth',4);
    h = fill([t, fliplr(t)], [ya1mean-ya1sem, fliplr(ya1mean+ya1sem)], 'r','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    h_for_legend(end+1)=plot(t,ya2mean,'Color','b','linewidth',4);
    h = fill([t, fliplr(t)], [ya2mean-ya2sem, fliplr(ya2mean+ya2sem)], 'b','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    xlim([-0.5 1.2]);
    xticks([-2:0.2:2]);
%     ylim([-0.02 0.1])
    axis square;

    legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
    xlabel('Time')
    ylabel(['Mean of ' a.conditionLabels{cd}{1}])
    title([a.conditionLabels{cd}{1} ', different cells'])

    nsubplot(1,2,1,2);
    h_for_legend=[];
    h_for_legend(end+1)=plot(t,yb1mean,'Color','r','linewidth',4);
    h = fill([t, fliplr(t)], [yb1mean-yb1sem, fliplr(yb1mean+yb1sem)], 'r','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    h_for_legend(end+1)=plot(t,yb2mean,'Color','b','linewidth',4);
    h = fill([t, fliplr(t)], [yb2mean-yb2sem, fliplr(yb2mean+yb2sem)], 'b','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    xlim([-0.5 1.2]);
    xticks([-2:0.2:2]);
%     ylim([-0.02 0.1])
    axis square;

    legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
    xlabel('Time')
    ylabel(['Mean of ' a.conditionLabels{cd}{2}])
    title([a.conditionLabels{cd}{2}  ', different cells'])

    saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_meanActivitybyConditionDIFFCELLS_',allconditions,'_',a.compLabels{cd}]),'pdf');


    figure()
    fig=gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 11 8.5];
    set(fig,'PaperOrientation','landscape');
    hold on;

    nsubplot(1,2,1,1);
    h_for_legend=[];
    h_for_legend(end+1)=plot(t,ya1mean,'Color','b','linewidth',4);
    h = fill([t, fliplr(t)], [ya1mean-ya1sem, fliplr(ya1mean+ya1sem)], 'b','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    h_for_legend(end+1)=plot(t,yb1mean,'Color','r','linewidth',4);
    h = fill([t, fliplr(t)], [yb1mean-yb1sem, fliplr(yb1mean+yb1sem)], 'r','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    xlim([-0.5 1.2]);
    xticks([-2:0.2:2]);
%     ylim([-0.02 0.1])
    axis square;

    legend(h_for_legend,{a.conditionLabels{cd}{1},a.conditionLabels{cd}{2}},'Orientation','vertical','Location','northwest','Box','off');
    xlabel('Time')
    ylabel('Mean Activity')
    title([conditionNames{1} ' different cells'])

    nsubplot(1,2,1,2);
    h_for_legend=[];
    h_for_legend(end+1)=plot(t,ya2mean,'Color','b','linewidth',4);
    h = fill([t, fliplr(t)], [ya2mean-ya2sem, fliplr(ya2mean+ya2sem)], 'b','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    h_for_legend(end+1)=plot(t,yb2mean,'Color','r','linewidth',4);
    h = fill([t, fliplr(t)], [yb2mean-yb2sem, fliplr(yb2mean+yb2sem)], 'r','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    xlim([-0.5 1.2]);
    xticks([-2:0.2:2]);
%     ylim([-0.02 0.1])
    axis square;

    legend(h_for_legend,{a.conditionLabels{cd}{1},a.conditionLabels{cd}{2}},'Orientation','vertical','Location','northwest','Box','off');
    xlabel('Time')
    ylabel('Mean of No Info')
    title([conditionNames{2} ' different cells'])

    saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_meanActivitybyLearningDIFFCELLS_',allconditions,'_',a.compLabels{cd}]),'pdf');

end

%% CONDITIONAL MEAN ACTIVITY BEFORE AND AFTER ONLY DIFFERENT EBM CELLS

for cd = 1:size(a.compNamesFirst)
    
    cname = a.compNamesFirst{cd};
    e = a.compEventsFirst(cd);
    cy = cellfun(@(z) a.(z),cname,'uniform',0);
        
    ya1 = cy{1}{1}; % info in that learning condition
    ya2 = cy{1}{2}; % info in that learning condition
    yb1 = cy{2}{1}; %rand in that learning condition
    yb2 = cy{2}{2}; %rand in that learning condition
    ya1TrialMean=mean(ya1,3,'omitnan'); %yInfo1 mean across trials
    ya2TrialMean=mean(ya2,3,'omitnan');
    yb1TrialMean=mean(yb1,3,'omitnan');
    yb2TrialMean=mean(yb2,3,'omitnan');    %yRand1     
    ya1Trialmean=ya1TrialMean-mean(ya1TrialMean(:,30:40),2);
    ya2Trialmean=ya2TrialMean-mean(ya2TrialMean(:,30:40),2);
    yb1Trialmean=yb1TrialMean-mean(yb1TrialMean(:,30:40),2);
    yb2Trialmean=yb2TrialMean-mean(yb2TrialMean(:,30:40),2);
    ya1Trialmean=ya1Trialmean(a.actDiffIdxEBMSig{1,1}<0.05,:);
    ya2Trialmean=ya2Trialmean(a.actDiffIdxEBMSig{1,2}<0.05,:);
    yb1Trialmean=yb1Trialmean(a.actDiffIdxEBMSig{2,1}<0.05,:);
    yb2Trialmean=yb2Trialmean(a.actDiffIdxEBMSig{2,2}<0.05,:);

    ya1mean=mean(ya1Trialmean); %yInfo1mean across cells
    ya2mean=mean(ya2Trialmean);
    yb1mean=mean(yb1Trialmean);
    yb2mean=mean(yb2Trialmean);
    ya1sem=std(ya1Trialmean,[],1,'omitnan')./sqrt(size(ya1Trialmean,1)); % take error across restricted, not whole population!!
    ya2sem=std(ya2Trialmean,[],1,'omitnan')./sqrt(size(ya2Trialmean,1));
    yb1sem=std(yb1Trialmean,[],1,'omitnan')./sqrt(size(yb1Trialmean,1));
    yb2sem=std(yb2Trialmean,[],1,'omitnan')./sqrt(size(yb2Trialmean,1));

    
    t=a.t{e};
    
    figure()
    fig=gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 11 8.5];
    set(fig,'PaperOrientation','landscape');
    hold on;

    nsubplot(1,2,1,1);
    h_for_legend=[];
    h_for_legend(end+1)=plot(t,ya1mean,'Color','r','linewidth',4);
    h = fill([t, fliplr(t)], [ya1mean-ya1sem, fliplr(ya1mean+ya1sem)], 'r','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    h_for_legend(end+1)=plot(t,ya2mean,'Color','b','linewidth',4);
    h = fill([t, fliplr(t)], [ya2mean-ya2sem, fliplr(ya2mean+ya2sem)], 'b','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    xlim([-0.5 1.2]);
    xticks([-2:0.2:2]);
%     ylim([-0.02 0.1])
    axis square;

    legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
    xlabel('Time')
    ylabel(['Mean of ' a.conditionLabels{cd}{1}])
    title([a.conditionLabels{cd}{1} ', different cells EBM'])

    nsubplot(1,2,1,2);
    h_for_legend=[];
    h_for_legend(end+1)=plot(t,yb1mean,'Color','r','linewidth',4);
    h = fill([t, fliplr(t)], [yb1mean-yb1sem, fliplr(yb1mean+yb1sem)], 'r','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    h_for_legend(end+1)=plot(t,yb2mean,'Color','b','linewidth',4);
    h = fill([t, fliplr(t)], [yb2mean-yb2sem, fliplr(yb2mean+yb2sem)], 'b','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    xlim([-0.5 1.2]);
    xticks([-2:0.2:2]);
%     ylim([-0.02 0.1])
    axis square;

    legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
    xlabel('Time')
    ylabel(['Mean of ' a.conditionLabels{cd}{2}])
    title([a.conditionLabels{cd}{2}  ', different cells EBM'])

    saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_meanActivitybyConditionDIFFCELLSEBM_',allconditions,'_',a.compLabels{cd}]),'pdf');


    figure()
    fig=gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 11 8.5];
    set(fig,'PaperOrientation','landscape');
    hold on;

    nsubplot(1,2,1,1);
    h_for_legend=[];
    h_for_legend(end+1)=plot(t,ya1mean,'Color','b','linewidth',4);
    h = fill([t, fliplr(t)], [ya1mean-ya1sem, fliplr(ya1mean+ya1sem)], 'b','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    h_for_legend(end+1)=plot(t,yb1mean,'Color','r','linewidth',4);
    h = fill([t, fliplr(t)], [yb1mean-yb1sem, fliplr(yb1mean+yb1sem)], 'r','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    xlim([-0.5 1.2]);
    xticks([-2:0.2:2]);
%     ylim([-0.02 0.1])
    axis square;

    legend(h_for_legend,{a.conditionLabels{cd}{1},a.conditionLabels{cd}{2}},'Orientation','vertical','Location','northwest','Box','off');
    xlabel('Time')
    ylabel('Mean Activity')
    title([conditionNames{1} ' different cells EBM'])

    nsubplot(1,2,1,2);
    h_for_legend=[];
    h_for_legend(end+1)=plot(t,ya2mean,'Color','b','linewidth',4);
    h = fill([t, fliplr(t)], [ya2mean-ya2sem, fliplr(ya2mean+ya2sem)], 'b','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    h_for_legend(end+1)=plot(t,yb2mean,'Color','r','linewidth',4);
    h = fill([t, fliplr(t)], [yb2mean-yb2sem, fliplr(yb2mean+yb2sem)], 'r','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    xlim([-0.5 1.2]);
    xticks([-2:0.2:2]);
%     ylim([-0.02 0.1])
    axis square;

    legend(h_for_legend,{a.conditionLabels{cd}{1},a.conditionLabels{cd}{2}},'Orientation','vertical','Location','northwest','Box','off');
    xlabel('Time')
    ylabel('Mean of No Info')
    title([conditionNames{2} ' different cells EBM'])

    saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_meanActivitybyLearningDIFFCELLSEBM_',allconditions,'_',a.compLabels{cd}]),'pdf');

end

% %% CONDITIONAL MEAN ACTIVITY BEFORE AND AFTER ONLY RESPONDING (ACTIVE) CELLS
% 
% for cd = 1:size(a.compNamesFirst)
%     cname = a.compNamesFirst{cd};
%     e = a.compEventsFirst(cd);
%     cy = cellfun(@(z) a.(z),cname,'uniform',0);
%     
% %     a.C_condBasePostRSActiveExp{cd,cm}(:,ci);
%     
%     ya1 = cy{1}{1}; % info in that learning condition
%     ya2 = cy{1}{2}; % info in that learning condition
%     yb1 = cy{2}{1}; %rand in that learning condition
%     yb2 = cy{2}{2}; %rand in that learning condition
%     ya1TrialMean=mean(ya1,3,'omitnan'); %yInfo1 mean across trials
%     ya2TrialMean=mean(ya2,3,'omitnan');
%     yb1TrialMean=mean(yb1,3,'omitnan');
%     yb2TrialMean=mean(yb2,3,'omitnan');    %yRand1     
%     ya1Trialmean=ya1TrialMean-mean(ya1TrialMean(:,30:40),2);
%     ya2Trialmean=ya2TrialMean-mean(ya2TrialMean(:,30:40),2);
%     yb1Trialmean=yb1TrialMean-mean(yb1TrialMean(:,30:40),2);
%     yb2Trialmean=yb2TrialMean-mean(yb2TrialMean(:,30:40),2);
%     ya1mean=mean(ya1Trialmean(a.C_condBasePostRSActiveExp{cd,1}(:,1),:),1); %yInfo1mean across cells
%     ya2mean=mean(ya2Trialmean(a.C_condBasePostRSActiveExp{cd,2}(:,1),:),1);
%     yb1mean=mean(yb1Trialmean(a.C_condBasePostRSActiveExp{cd,1}(:,2),:),1);
%     yb2mean=mean(yb2Trialmean(a.C_condBasePostRSActiveExp{cd,2}(:,2),:),1);
%     ya1sem=std(ya1TrialMean,[],1,'omitnan')./sqrt(size(ya1TrialMean,1));
%     ya2sem=std(ya2TrialMean,[],1,'omitnan')./sqrt(size(ya2TrialMean,1));
%     yb1sem=std(yb1TrialMean,[],1,'omitnan')./sqrt(size(yb1TrialMean,1));
%     yb2sem=std(yb2TrialMean,[],1,'omitnan')./sqrt(size(yb2TrialMean,1));
%     t=a.t{e};
% 
%     figure()
%     fig=gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'PaperOrientation','landscape');
%     hold on;
% 
%     nsubplot(1,2,1,1);
%     h_for_legend=[];
%     h_for_legend(end+1)=plot(t,ya1mean,'Color','r','linewidth',4);
%     h = fill([t, fliplr(t)], [ya1mean-ya1sem, fliplr(ya1mean+ya1sem)], 'r','EdgeColor','none');
%     set(h, 'FaceAlpha', 0.1);
%     h_for_legend(end+1)=plot(t,ya2mean,'Color','b','linewidth',4);
%     h = fill([t, fliplr(t)], [ya2mean-ya2sem, fliplr(ya2mean+ya2sem)], 'b','EdgeColor','none');
%     set(h, 'FaceAlpha', 0.1);
%     xlim([-0.5 1.2]);
%     xticks([-2:0.2:2]);
% %     ylim([-0.02 0.1])
%     axis square;
% 
%     legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
%     xlabel('Time')
%     ylabel(['Mean of ' a.conditionLabels{cd}{1}])
%     title([a.conditionLabels{cd}{1} ', different cells'])
% 
%     nsubplot(1,2,1,2);
%     h_for_legend=[];
%     h_for_legend(end+1)=plot(t,yb1mean,'Color','r','linewidth',4);
%     h = fill([t, fliplr(t)], [yb1mean-yb1sem, fliplr(yb1mean+yb1sem)], 'r','EdgeColor','none');
%     set(h, 'FaceAlpha', 0.1);
%     h_for_legend(end+1)=plot(t,yb2mean,'Color','b','linewidth',4);
%     h = fill([t, fliplr(t)], [yb2mean-yb2sem, fliplr(yb2mean+yb2sem)], 'b','EdgeColor','none');
%     set(h, 'FaceAlpha', 0.1);
%     xlim([-0.5 1.2]);
%     xticks([-2:0.2:2]);
% %     ylim([-0.02 0.1])
%     axis square;
% 
%     legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
%     xlabel('Time')
%     ylabel(['Mean of ' a.conditionLabels{cd}{2}])
%     title([a.conditionLabels{cd}{2}  ', different cells'])
% 
%     saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_meanActivitybyConditionDIFFCELLS_',allconditions,'_',a.compLabels{cd}]),'pdf');
% 
% 
%     figure()
%     fig=gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'PaperOrientation','landscape');
%     hold on;
% 
%     nsubplot(1,2,1,1);
%     h_for_legend=[];
%     h_for_legend(end+1)=plot(t,ya1mean,'Color','b','linewidth',4);
%     h = fill([t, fliplr(t)], [ya1mean-ya1sem, fliplr(ya1mean+ya1sem)], 'b','EdgeColor','none');
%     set(h, 'FaceAlpha', 0.1);
%     h_for_legend(end+1)=plot(t,yb1mean,'Color','r','linewidth',4);
%     h = fill([t, fliplr(t)], [yb1mean-yb1sem, fliplr(yb1mean+yb1sem)], 'r','EdgeColor','none');
%     set(h, 'FaceAlpha', 0.1);
%     xlim([-0.5 1.2]);
%     xticks([-2:0.2:2]);
% %     ylim([-0.02 0.1])
%     axis square;
% 
%     legend(h_for_legend,{a.conditionLabels{cd}{1},a.conditionLabels{cd}{2}},'Orientation','vertical','Location','northwest','Box','off');
%     xlabel('Time')
%     ylabel('Mean Activity')
%     title([conditionNames{1} ' different cells'])
% 
%     nsubplot(1,2,1,2);
%     h_for_legend=[];
%     h_for_legend(end+1)=plot(t,ya2mean,'Color','b','linewidth',4);
%     h = fill([t, fliplr(t)], [ya2mean-ya2sem, fliplr(ya2mean+ya2sem)], 'b','EdgeColor','none');
%     set(h, 'FaceAlpha', 0.1);
%     h_for_legend(end+1)=plot(t,yb2mean,'Color','r','linewidth',4);
%     h = fill([t, fliplr(t)], [yb2mean-yb2sem, fliplr(yb2mean+yb2sem)], 'r','EdgeColor','none');
%     set(h, 'FaceAlpha', 0.1);
%     xlim([-0.5 1.2]);
%     xticks([-2:0.2:2]);
% %     ylim([-0.02 0.1])
%     axis square;
% 
%     legend(h_for_legend,{a.conditionLabels{cd}{1},a.conditionLabels{cd}{2}},'Orientation','vertical','Location','northwest','Box','off');
%     xlabel('Time')
%     ylabel('Mean of No Info')
%     title([conditionNames{2} ' different cells'])
% 
%     saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_meanActivitybyLearningDIFFCELLS_',allconditions,'_',a.compLabels{cd}]),'pdf');
% 
% end

% %% PCA INFO
% 
% % reconstruct activity for each mouse - make function!
% % mouseCells=histc(a.mouse(:),unique(a.mouse));
% % mouseCellCts=[0; cumsum(mouseCells)];
% 
% %% SHUFFLE INFO-NO INFO AND PCA FOR SIG CELLS
% 
% for cd=1:numel(conditions{1})
%     ii=[];
%     Iact=[];
%     Nact=[];
%     iI=[];
%     iN=[];
%     N=size(a.C_odor1FirstInfoForced{cd},1);
%     
%     nmI=sum(~isnan(a.C_odor1FirstInfoForced{cd}(cumsum(mouseCells),1,:)),3);
%     nmN=sum(~isnan(a.C_odor1FirstRandForced{cd}(cumsum(mouseCells),1,:)),3);
%     
%     % doesn't include NaNs!!
%     for m=1:numel(mice)
%        Iact{m}=a.C_odor1FirstInfoForced{cd}(mouseCellCts(m)+1:mouseCellCts(m+1),iStart:iStop,1:nmI(m)); 
%        Nact{m}=a.C_odor1FirstRandForced{cd}(mouseCellCts(m)+1:mouseCellCts(m+1),iStart:iStop,1:nmN(m));
%        mAct{m}=cat(3,Iact{m},Nact{m});
%        iI{m}(1:nmI(m),1)=1;
%        iN{m}(1:nmN(m),1)=2;
%        ii{m}=[iI{m};iN{m};];
%        mxT(m)=numel(ii{m});
%     end
% 
%     mxT=max(mxT);
% 
%     % SHUFFLE for stats
% 
%     nRuns = 100;
%     randPCArea = zeros(nRuns,1);
%     randNeuronAreas = zeros(nRuns,N);
%     for j=1:nRuns
%         for m=1:numel(mice)
%             % shuffle all trials (all types)
%             iShuffle{m}=ii{m}(randperm(size(ii{m},1)));
%             for i=1:2
%                 rs{i} = mAct{m}(:,:,iShuffle{m}==i);
%                 s{i}=NaN(size(rs{i},1),size(rs{i},2),mxT);
%                 s{i}(:,:,1:size(rs{i},3))=rs{i};     
%                 if m==1
%                    suffleR{i} = s{i};
%                 else
%                    suffleR{i} = cat(1,suffleR{i},s{i});
%                 end
%             end      
%         end
% 
%         rsI = squeeze(mean(suffleR{1},3,'omitnan'));
%         rsN = squeeze(mean(suffleR{2},3,'omitnan'));
% 
%         rsI = rsI - rsI(:,1);
%         rsN = rsN - rsN(:,1);
% 
%         rsIN = rsI-rsN; % neurons x time (selected interval)
% 
%         [UsIN SsIN VsIN] = svd(rsIN);
%         LsIN = diag(SsIN).^2;
%         LsIN = 100*LsIN/sum(LsIN);
% 
%         randPCArea(j) = abs(mean(UsIN(:,1)'*rsIN));
%         randNeuronAreas(j,:) = abs(mean(rsIN,2)); 
%     end
% 
%     % PCA
% 
%     rI = mean(a.C_odor1FirstInfoForced{cd}(:,iStart:iStop,:),3,'omitnan');
%     rN = mean(a.C_odor1FirstRandForced{cd}(:,iStart:iStop,:),3,'omitnan');
% 
%     rI = rI - rI(:,1);
%     rN = rN - rN(:,1);
%     rIN = rI-rN;
% 
%     [UIN SIN VIN] = svd(rIN);
%     LIN = diag(SIN).^2;
%     LIN = 100*LIN/sum(LIN);
% 
%     [UINSort iINSort] = sort(UIN(:,1),'descend');
% 
%     PCArea = abs(mean(UIN(:,1)'*rIN));
%     sNeuronAreas(:,cd) = mean(rIN,2);
%     NeuronAreas = abs(sNeuronAreas);
%     [ASort(:,cd) iASort(:,cd)] = sort(NeuronAreas(:,cd),'descend');
%     [sASort(:,cd) isASort(:,cd)] = sort(sNeuronAreas(:,cd),'descend');
% 
%     pPC = 100*sum(randPCArea>PCArea)/nRuns;
%     pNeurons = zeros(N,1);
%     for i=1:N
%         pNeurons(i) = 100*sum((randNeuronAreas(:)>NeuronAreas(i,cd))) ...
%             /length(randNeuronAreas(:));
%     end
%     nSig  = sum(pNeurons<5)'
%     
%     sigCells(:,cd)=pNeurons<5;
% 
% end
% 
% %%
% 
% cond1Cells = sigCells(:,1);
% cond2Cells = sigCells(:,2);
% overlapCells = cond1Cells&cond2Cells;
% only1Cells = cond1Cells&~cond2Cells;
% only2Cells = cond2Cells&~cond1Cells;
% 
% setLabels = {conditionNames{1}; conditionNames{2}};
% cells=sum([only1Cells only2Cells])/a.neuronCt;
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(cond1Cells) sum(cond2Cells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % axis square;
% title('Info-No Info Cells by PCA')
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_',allconditions,'_ConditionsPCAVenn']),'pdf');
% 
% 
% %%
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 8.5 11];
% set(fig,'PaperOrientation','portrait');
% nsubplot(1,1,1,1);
% hold on;
% h_for_legend=[];
% legnames={};
% 
% % legnameInfo(end+1) = {['Info' conditionNames{cd}]};
% 
% for cd=1:numel(conditions{1})
%     rI=mean(a.C_odor1FirstInfoForced{cd}(:,iStart:iStop,:),3,'omitnan');
%     rN=mean(a.C_odor1FirstRandForced{cd}(:,iStart:iStop,:),3,'omitnan');
%     rI=rI-rI(:,1);
%     rN=rN-rN(:,1);
% 
%     rIN = rI-rN;
%     [UIN SIN VIN] = svd(rIN);
%     LIN = diag(SIN).^2;
%     LIN = 100*LIN/sum(LIN);
%     
%     plot(a.t{e}(iStart:iStop),UIN(:,1)'*rI,'Color',a.purples(cd,:),'linewidth',6);
%     plot(a.t{e}(iStart:iStop),UIN(:,1)'*rN,'Color',a.oranges(cd,:),'linewidth',6);
%     legnames{end+1}=['Info ' conditionNames{cd}];
%     legnames{end+1}=['No Info ' conditionNames{cd}];
% end
% 
% plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
% plot([0 0],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% hold off;
% xlabel('Seconds since odor on')
% ylabel('PC1 Projection')
% % title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
% legend(legnames,'location','northwest');
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.96,[strjoin(mice,' _ ') ' Info-No Info Component ' alldays],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_',allconditions,'_PCprojections_INFO']),'pdf');
% 
% %%
% for cd=1:numel(conditions{1})
% rI=mean(a.C_odor1FirstInfoForced{cd}(:,iStart:iStop,:),3,'omitnan');
% rN=mean(a.C_odor1FirstRandForced{cd}(:,iStart:iStop,:),3,'omitnan');
% rI=rI-rI(:,1);
% rN=rN-rN(:,1);
% 
% rIN = rI-rN;
% [UIN SIN VIN] = svd(rIN);
% LIN = diag(SIN).^2;
% LIN = 100*LIN/sum(LIN);
% 
% yMax = [5];
% yMin = [-5];
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 8.5 11];
% set(fig,'PaperOrientation','portrait');
% nsubplot(1,1,1,1);
% hold on;
% h_for_legend=[];
% for t=1:size(rI,1)
%    tI=a.C_odor1FirstInfoForced{cd}(:,iStart:iStop,t);
%    tI=tI-tI(:,1);
%    plot(a.t{e}(iStart:iStop),UIN(:,1)'*tI,'Color',a.purple,'Linewidth',0.2)
%    tN=a.C_odor1FirstRandForced{cd}(:,iStart:iStop,t);
%    tN=tN-tN(:,1);
%    plot(a.t{e}(iStart:iStop),UIN(:,1)'*tN,'Color',a.orange,'Linewidth',0.2)
% end
% h_for_legend(end+1)=plot(a.t{e}(iStart:iStop),UIN(:,1)'*rI,'Color',a.purple,'linewidth',6);
% h_for_legend(end+1)=plot(a.t{e}(iStart:iStop),UIN(:,1)'*rN,'Color',a.orange,'linewidth',6);
% plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
% plot([0 0],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% hold off;
% % xlim([iStart iStop]);
% % ylim([yMin(1) yMax(1)]);
% xlabel('Seconds since odor on')
% ylabel('PC1 Projection')
% % title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
% legend(h_for_legend,'Info','No Info','location','northwest');
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.96,[strjoin(mice,' _ ') ' ' conditionNames{cd}],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% 
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_',conditionNames{cd},'_PCprojection_INFO']),'pdf');
% 
% end
% 
% %% PCA A-B
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 8.5 11];
% set(fig,'PaperOrientation','portrait');
% nsubplot(1,1,1,1);
% hold on;
% h_for_legend=[];
% legnames={};
% 
% % legnameInfo(end+1) = {['Info' conditionNames{cd}]};
% 
% for cd=1:numel(conditions{1})
% rA=mean(a.C_odor2A{cd}(:,iStart:iStop,:),3,'omitnan');
% rB=mean(a.C_odor2B{cd}(:,iStart:iStop,:),3,'omitnan');
% rA=rA-rA(:,1);
% rB=rB-rB(:,1);
% 
% rAB = rA-rB;
% if sum(sum(isnan(rAB)))==0
%     [UAB SAB VAB] = svd(rAB);
%     LAB = diag(SAB).^2;
%     LAB = 100*LAB/sum(LAB);
%     
%     plot(a.t{e}(iStart:iStop),UAB(:,1)'*rA,'Color',a.reds(cd,:),'linewidth',6);
%     plot(a.t{e}(iStart:iStop),UAB(:,1)'*rB,'Color',a.blues(cd,:),'linewidth',6);
%     legnames{end+1}=['A ' conditionNames{cd}];
%     legnames{end+1}=['B ' conditionNames{cd}];
% end
% end
% 
%     plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
%     plot([0 0],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
%     plot([0.2 0.2],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
%     hold off;
%     xlabel('Seconds since odor on')
%     ylabel('PC1 Projection')
%     % title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
%     legend(legnames,'location','northwest');
%     ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
%     text(0.5, 0.96,[strjoin(mice,' _ ') ' A-B Component ' alldays],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
%     saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_',allconditions,'_PCprojections_AB']),'pdf');
% 
% %%
% for cd=1:numel(conditions{1})
% rA=mean(a.C_odor2A{cd}(:,iStart:iStop,:),3,'omitnan');
% rB=mean(a.C_odor2B{cd}(:,iStart:iStop,:),3,'omitnan');
% rA=rA-rA(:,1);
% rB=rB-rB(:,1);
% 
% rAB = rA-rB;
% if sum(sum(isnan(rAB)))==0
% [UAB SAB VAB] = svd(rAB);
% LAB = diag(SAB).^2;
% LAB = 100*LAB/sum(LAB);
% 
% yMax = [5];
% yMin = [-5];
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 8.5 11];
% set(fig,'PaperOrientation','portrait');
% nsubplot(1,1,1,1);
% hold on;
% h_for_legend = [];
% for t=1:size(rA,1)
%    tA=a.C_odor2A{cd}(:,iStart:iStop,t);
%    tA=tA-tA(:,1);
%    plot(a.t{e}(iStart:iStop),UAB(:,1)'*tA,'Color','g','Linewidth',0.2)
% end
% for t=1:size(rB)
%    tB=a.C_odor2B{cd}(:,iStart:iStop,t);
%    tB=tB-tB(:,1);
%    plot(a.t{e}(iStart:iStop),UAB(:,1)'*tB,'Color','m','Linewidth',0.2)
% end
% h_for_legend(end+1)=plot(a.t{e}(iStart:iStop),UAB(:,1)'*rA,'Color','g','linewidth',6);
% h_for_legend(end+1)=plot(a.t{e}(iStart:iStop),UAB(:,1)'*rB,'Color','m','linewidth',6);
% plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
% plot([0 0],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% hold off;
% % xlim([iStart iStop]);
% % ylim([yMin(1) yMax(1)]);
% xlabel('Seconds since odor on')
% ylabel('PC1 Projection')
% % title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
% legend(h_for_legend,'A','B','location','northwest');
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.96,[strjoin(mice,' _ ') ' ' conditionNames{cd}],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_',conditionNames{cd},'_PCprojection_AB',]),'pdf');
% end
% end
% 
% %% PCA INFO OUTCOME
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 8.5 11];
% set(fig,'PaperOrientation','portrait');
% nsubplot(1,1,1,1);
% hold on;
% h_for_legend=[];
% legnames={};
% 
% % legnameInfo(end+1) = {['Info' conditionNames{cd}]};
% 
% for cd=1:numel(conditions{1})
% rW=mean(a.C_outcomeInfoBig{cd}(:,iStart:iStop,:),3,'omitnan');
% rO=mean(a.C_outcomeInfoSmall{cd}(:,iStart:iStop,:),3,'omitnan');
% rW=rW-rW(:,1);
% rO=rO-rO(:,1);
% 
% rWO = rW-rO;
% if sum(sum(isnan(rWO)))==0
% [UWO SWO VWO] = svd(rWO);
% LWO = diag(SWO).^2;
% LWO = 100*LWO/sum(LWO);
%     
% plot(a.t{e}(iStart:iStop),UWO(:,1)'*rW,'Color',a.reds(cd,:),'linewidth',6);
% plot(a.t{e}(iStart:iStop),UWO(:,1)'*rO,'Color',a.blues(cd,:),'linewidth',6);
% legnames{end+1}=['Info Water ' conditionNames{cd}];
% legnames{end+1}=['Info No Water ' conditionNames{cd}];
% end
% end
% 
% plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
% plot([0 0],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% hold off;
% xlabel('Seconds since odor on')
% ylabel('PC1 Projection')
% % title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
% legend(legnames,'location','northwest');
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.96,[strjoin(mice,' _ ') ' Info Coutcome Component ' alldays],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_',allconditions,'_PCprojections_InfoOutcome']),'pdf');
% 
% %%
% 
% for cd=1:numel(conditions{1})
% rW=mean(a.C_outcomeInfoBig{cd}(:,iStart:iStop,:),3,'omitnan');
% rO=mean(a.C_outcomeInfoSmall{cd}(:,iStart:iStop,:),3,'omitnan');
% rW=rW-rW(:,1);
% rO=rO-rO(:,1);
% 
% rWO = rW-rO;
% if sum(sum(isnan(rWO)))==0
% [UWO SWO VWO] = svd(rWO);
% LWO = diag(SWO).^2;
% LWO = 100*LWO/sum(LWO);
% 
% yMax = [5];
% yMin = [-5];
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 8.5 11];
% set(fig,'PaperOrientation','portrait');
% nsubplot(1,1,1,1);
% hold on;
% for t=1:size(rO,1)
%    tW=a.C_outcomeRandBig{cd}(:,iStart:iStop,t);
%    tW=tW-tW(:,1);
%    plot(a.t{e}(iStart:iStop),UWO(:,1)'*tW,'Color','g','Linewidth',0.2);
%    tO=a.C_outcomeRandSmall{cd}(:,iStart:iStop,t);
%    tO=tO-tO(:,1);
%    plot(a.t{e}(iStart:iStop),UWO(:,1)'*tO,'Color','m','Linewidth',0.2);
% end
% plot(a.t{e}(iStart:iStop),UWO(:,1)'*rW,'Color','g','linewidth',6);
% plot(a.t{e}(iStart:iStop),UWO(:,1)'*rO,'Color','m','linewidth',6);
% plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
% plot([0 0],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% hold off;
% % xlim([iStart iStop]);
% % ylim([yMin(1) yMax(1)]);
% xlabel('Seconds since outcome')
% ylabel('PC1 Projection')
% % title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
% legend('Info Water','Info No Water','location','northwest');
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.96,[strjoin(mice,' _ ') ' ' conditionNames{cd}],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_',conditionNames{cd},'_PCprojection_InfoOutcome',]),'pdf');
% end
% end
% 
% %% PCA RAND OUTCOME
% 
% %%
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 8.5 11];
% set(fig,'PaperOrientation','portrait');
% nsubplot(1,1,1,1);
% hold on;
% h_for_legend=[];
% legnames={};
% 
% % legnameInfo(end+1) = {['Info' conditionNames{cd}]};
% 
% for cd=1:numel(conditions{1})
% rW=mean(a.C_outcomeRandBig{cd}(:,iStart:iStop,:),3,'omitnan');
% rO=mean(a.C_outcomeRandSmall{cd}(:,iStart:iStop,:),3,'omitnan');
% rW=rW-rW(:,1);
% rO=rO-rO(:,1);
% 
% rWO = rW-rO;
% if sum(sum(isnan(rWO)))==0
% [UWO SWO VWO] = svd(rWO);
% LWO = diag(SWO).^2;
% LWO = 100*LWO/sum(LWO);
%     
% plot(a.t{e}(iStart:iStop),UWO(:,1)'*rW,'Color',a.reds(cd,:),'linewidth',6);
% plot(a.t{e}(iStart:iStop),UWO(:,1)'*rO,'Color',a.blues(cd,:),'linewidth',6);
% legnames{end+1}=['No Info Water ' conditionNames{cd}];
% legnames{end+1}=['No Info No Water ' conditionNames{cd}];
% end
% end
% 
% plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
% plot([0 0],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% hold off;
% xlabel('Seconds since odor on')
% ylabel('PC1 Projection')
% % title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
% legend(legnames,'location','northwest');
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.96,[strjoin(mice,' _ ') ' No Info Outcome Component ' alldays],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_',allconditions,'_PCprojections_NOInfoOutcome']),'pdf');
% 
% %%
% 
% for cd=1:numel(conditions{1})
% rW=mean(a.C_outcomeRandBig{cd}(:,iStart:iStop,:),3,'omitnan');
% rO=mean(a.C_outcomeRandSmall{cd}(:,iStart:iStop,:),3,'omitnan');
% rW=rW-rW(:,1);
% rO=rO-rO(:,1);
% 
% rWO = rW-rO;
% if sum(sum(isnan(rWO)))==0
% [UWO SWO VWO] = svd(rWO);
% LWO = diag(SWO).^2;
% LWO = 100*LWO/sum(LWO);
% 
% yMax = [5];
% yMin = [-5];
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 8.5 11];
% set(fig,'PaperOrientation','portrait');
% nsubplot(1,1,1,1);
% hold on;
% for t=1:size(rO,1)
%    tW=a.C_outcomeRandBig{cd}(:,iStart:iStop,t);
%    tW=tW-tW(:,1);
%    plot(a.t{e}(iStart:iStop),UWO(:,1)'*tW,'Color','b','Linewidth',0.2);
%    tO=a.C_outcomeRandSmall{cd}(:,iStart:iStop,t);
%    tO=tO-tO(:,1);
%    plot(a.t{e}(iStart:iStop),UWO(:,1)'*tO,'Color','c','Linewidth',0.2);
% end
% plot(a.t{e}(iStart:iStop),UWO(:,1)'*rW,'Color','b','linewidth',6);
% plot(a.t{e}(iStart:iStop),UWO(:,1)'*rO,'Color','c','linewidth',6);
% plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
% plot([0 0],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% hold off;
% % xlim([iStart iStop]);
% % ylim([yMin(1) yMax(1)]);
% xlabel('Seconds since outcome')
% ylabel('PC1 Projection')
% % title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
% legend('No Info Water','No Info No Water','location','northwest');
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.96,[strjoin(mice,' _ ') ' ' conditionNames{cd}],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% 
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_',conditionNames{cd},'_PCprojection_RandOutcome',]),'pdf');
% end
% end

%%

y_info=[];
y_rand=[];

for cd=1:numel(conditions{1})
   y_info{cd}=mean(a.C_odor1FirstInfoForced{cd},3,'omitnan');
   y_rand{cd}=mean(a.C_odor1FirstRandForced{cd},3,'omitnan');
   ydiff{cd}=y_info{cd}-y_rand{cd};
    [infoSort(:,cd),infoIdx(:,cd)] = sort(mean(y_info{cd}(:,40:64),2,'omitnan'),'descend');
    [randSort(:,cd),randIdx(:,cd)] = sort(mean(y_rand{cd}(:,40:64),2,'omitnan'),'descend');
    [diffSort(:,cd),diffIdx(:,cd)] = sort(mean(ydiff{cd}(:,40:64),2,'omitnan'),'descend');
end


%% 

e=3;
t=a.t{e};
color_limits=[-1.4,1.4];
color_limits=[-1.6 1.6];
diff_limits = [-0.8 0.8];

%% TimeConditionDifferences2

for cd = 1:numel(conditions{1})
    figure()
    fig=gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 11 8.5];
    set(fig,'PaperOrientation','landscape');

    cell_sort_ids=diffIdx(:,cd);

    for ci=1:condct
        ax=nsubplot(1,condct+1,1,ci);
        y=ydiff{ci};
        y=y-mean(y(:,30:40),2);
        imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
        plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
        plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
        axis tight;
%         ax.YAxis.Visible = 'off';
        xlim([-0.2 1.45]);
        xlabel('Seconds');
        title(['Info-No Info ' conditionNames{ci}]);
        set(ax, 'Ydir', 'reverse')
    end
    ax=nsubplot(1,condct+1,1,condct+1);
    if cd==1
      y=(ydiff{1}-mean(ydiff{1}(:,30:40),2))-(ydiff{2}-mean(ydiff{2}(:,30:40),2));  
    else
       y=(ydiff{2}-mean(ydiff{2}(:,30:40),2))-(ydiff{1}-mean(ydiff{1}(:,30:40),2)); 
    end
    
    imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
    ax.YAxis.Visible = 'off';
    xlim([-0.2 1]);
    xlabel('Seconds');
    if cd ==1
    title('Diff 1 - Diff 2');
    else
    title('Diff 2 - Diff 1');    
    end
    set(ax, 'Ydir', 'reverse')
    colorbar()
    colorcet('D1');

    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 0.96, [strjoin(mice,' _ '),' Sort By Diff in Condition ',conditionNames{cd}],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');

    saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_TimeConditionDifferences2_SortDiff_',conditionNames{cd}]),'pdf');
    
end

%% TimeConditionDifferencesEBM

EBM_limits=[-1.4 1.4];

    figure()
    fig=gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 11 8.5];
    set(fig,'PaperOrientation','landscape');

%     cell_sort_ids=diffIdx(:,cd);

    yEBM{1}=a.activityDifferenceEBM{1,1};
    yEBM{2}=a.activityDifferenceEBM{1,2};
%     yEBM{3}=a.activityDifferenceEBM{1,3};
    yEBMDiff1=yEBM{2}-yEBM{1};
%     yEBMDiff2=yEBM{2}-yEBM{3};
    
%     [~, maxIndices] = max(yEBM{2}(:,50:60), [], 2);
%     [~, cell_sort_ids] = sort(maxIndices);
    
    [~,cell_sort_ids]=sort(mean(yEBM{2}(:,40:64),2),'descend');
    
    for ci=1:condct
    ax=nsubplot(1,condct+2,1,ci);
    imagesc(t,1:size(yEBM{ci},1),yEBM{ci}(cell_sort_ids,:),EBM_limits);
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
%         ax.YAxis.Visible = 'off';
    xlim([-0.2 1.45]);
    xlabel('Seconds');
    title(['Info-No Info ' conditionNames{ci}]);
    set(ax, 'Ydir', 'reverse')
    colorbar()
    end
    
    ax=nsubplot(1,condct+2,1,condct+1);
    imagesc(t,1:size(yEBMDiff1,1),yEBMDiff1(cell_sort_ids,:),[-1 1]);
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
    ax.YAxis.Visible = 'off';
    xlim([-0.2 1]);
    xlabel('Seconds');
    title('Diff 2 - Diff 1');
    set(ax, 'Ydir', 'reverse')
    colorbar()
    
%     ax=nsubplot(1,condct+2,1,condct+2);
%     imagesc(t,1:size(yEBMDiff2,1),yEBMDiff2(cell_sort_ids,:),[-1 1]);
%     plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
%     plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
%     axis tight;
%     ax.YAxis.Visible = 'off';
%     xlim([-0.2 1]);
%     xlabel('Seconds');
%     title('Diff 2 - Diff 3');
%     set(ax, 'Ydir', 'reverse')
%     colorbar()    
%     if RA==1
%     colormap(a.ckr);
%     else
%     colorcet('D1')
%     end

    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 0.96, [strjoin(mice,' _ '),' Sort By Diff in Condition ',conditionNames{2}],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');

    saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_TimeConditionDifferencesEBM_RA_SortDiff_',conditionNames{2}]),'pdf');
    


%% TimeConditionDifferences

for cd=1:numel(conditions{1})
    
cell_sort_ids=infoIdx(:,cd);
% cell_sort_ids=randIdx;

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');

for ci=1:condct
ax=nsubplot(1,condct*2+2*condct-1,1,ci);
y=y_info{ci};
y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'Info  '; conditionNames{ci}}); %{'First line';'Second line'}
set(ax, 'Ydir', 'reverse')
colorbar();
end

y_info1=y_info{1};
y_info2=y_info{2};
ax=nsubplot(1,condct*2+2*condct-1,1,condct+1);
y=y_info2-y_info1;
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'Info,'; 'Condition 2-1'});
set(ax, 'Ydir', 'reverse')
colorbar()

if condct==3
y_info1=y_info{1};
y_info2=y_info{3};
ax=nsubplot(1,condct*2+2*condct-1,1,condct+2);
y=y_info2-y_info1;
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'Info,'; 'Condition 3-1'});
set(ax, 'Ydir', 'reverse')
colorbar()
end

for ci=1:condct
ax=nsubplot(1,condct*2+2*condct-1,1,ci+condct+2);
y=y_rand{ci};
y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'NO Info  '; conditionNames{ci}});
set(ax, 'Ydir', 'reverse')
colorbar()
end

y1=y_rand{1};
y2=y_rand{2};
ax=nsubplot(1,condct*2+2*condct-1,1,condct*2+3);
y=y2-y1;
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'NO Info,'; 'Condition 2-1'});
set(ax, 'Ydir', 'reverse')
colorbar()

if condct==3
y_rand1=y_rand{1};
y_rand2=y_rand{3};
ax=nsubplot(1,condct*2+2*condct-1,1,condct*2+4);
y=y_rand2-y_rand1;
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'NO Info,'; 'Condition 3-1'});
set(ax, 'Ydir', 'reverse')
end
colorbar()
colorcet('D1');
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, [strjoin(mice,' _ '),' Sort Info ',conditionNames{cd}],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');


colorcet('D1');
saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_TimeConditionDifferences_SortInfo_',conditionNames{cd}]),'pdf');

% %%%%%%%%%%%%%%%%%%%%%%%
cell_sort_ids=randIdx(:,cd);

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');

for ci=1:condct
ax=nsubplot(1,condct*2+2*condct-1,1,ci);
y=y_info{ci};
y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title({'Info  '; conditionNames{ci}});
set(ax, 'Ydir', 'reverse')
colorbar()
end

y_info1=y_info{1};
y_info2=y_info{2};
ax=nsubplot(1,condct*2+2*condct-1,1,condct+1);
y=y_info2-y_info1;
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title({'Info,'; 'Condition 2-1'});
set(ax, 'Ydir', 'reverse')
colorbar()

if condct==3
y_info1=y_info{1};
y_info2=y_info{3};
ax=nsubplot(1,condct*2+2*condct-1,1,condct+2);
y=y_info2-y_info1;
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title({'Info,'; 'Condition 3-1'});
set(ax, 'Ydir', 'reverse')
colorbar()
end

for ci=1:condct
ax=nsubplot(1,condct*2+2*condct-1,1,ci+condct+2);
y=y_rand{ci};
y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title({'NO Info  '; conditionNames{ci}});
set(ax, 'Ydir', 'reverse')
colorbar()
end

y1=y_rand{1};
y2=y_rand{2};
ax=nsubplot(1,condct*2+2*condct-1,1,condct*2+3);
y=y2-y1;
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title({'NO Info,'; 'Condition 2-1'});
set(ax, 'Ydir', 'reverse')
colorbar()

if condct==3
y_rand1=y_rand{1};
y_rand2=y_rand{3};
ax=nsubplot(1,condct*2+2*condct-1,1,condct*2+4);
y=y_rand2-y_rand1;
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title({'NO Info,'; 'Condition 3-1'});
set(ax, 'Ydir', 'reverse')
colorbar()
end


colorcet('D1');
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, [strjoin(mice,' _ '),' Sort NO Info ',conditionNames{cd}],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');

colorcet('D1');
saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_TimeConditionDifferences_SortNOInfo_',conditionNames{cd}]),'pdf');

end

%%

y_info=[];
y_rand=[];
infoSort=[];
randSort=[];
infoIdx=[];randIdx=[];
diffSort=[];diffIdx=[];

for cd=1:numel(conditions{1})
   y_info{cd}=mean(a.C_odor1FirstInfoForced{cd},3,'omitnan');
   y_info{cd}=y_info{cd}(infoCells(:,cd),:);
   y_rand{cd}=mean(a.C_odor1FirstRandForced{cd},3,'omitnan');
   y_rand{cd}=y_rand{cd}(infoCells(:,cd),:);
   ydiff{cd}=y_info{cd}-y_rand{cd};
    [infoSort{cd},infoIdx{cd}] = sort(mean(y_info{cd}(:,40:64),2,'omitnan'),'descend');
    [randSort{cd},randIdx{cd}] = sort(mean(y_rand{cd}(:,40:64),2,'omitnan'),'descend');
    [diffSort{cd},diffIdx{cd}] = sort(mean(ydiff{cd}(:,40:64),2,'omitnan'),'descend');
end

%% TimeConditionDifferences2 INFO CELLS ONLY

only_limits=[-2 2];

% for cd = 1:numel(conditions{1})
    figure()
    fig=gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 11 8.5];
    set(fig,'PaperOrientation','landscape');

    for ci=1:condct
        ax=nsubplot(1,condct,1,ci);
        y=ydiff{ci};
        y=y-mean(y(:,30:40),2);
        cell_sort_ids=diffIdx{ci};
        imagesc(t,1:size(y,1),y(cell_sort_ids,:),only_limits);
        plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
        plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
        axis tight;
%         ax.YAxis.Visible = 'off';
        xlim([-0.2 1.45]);
        xlabel('Seconds');
        title(['Info-No Info ' conditionNames{ci}]);
        set(ax, 'Ydir', 'reverse')
    end

    colorbar()
    colorcet('D1');

    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 0.96, [strjoin(mice,' _ '),' Only Info-NoInfo Cells, Sort By Diff'],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
    text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');

    saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_TimeConditionDifferences2INFOCELLS_SortDiff_']),'pdf');
    
% end


%% ABS DIFF

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;

nsubplot(1,1,1,1);
h_for_legend=[];
if condct==2
yInfo1=mean(a.C_odor1FirstInfoForced{1},3,'omitnan');
size(yInfo1);
yRand1=mean(a.C_odor1FirstRandForced{1},3,'omitnan');
yInfo1mean=mean(yInfo1,1);
yRand1mean=mean(yRand1,1);
ydiff1=abs(yInfo1-yRand1);
cond1=mean(ydiff1,1);
sem1=nanstd(ydiff1,[],1) ./ sqrt(size(ydiff1,1));
yInfo2=mean(a.C_odor1FirstInfoForced{2},3,'omitnan');
yRand2=mean(a.C_odor1FirstRandForced{2},3,'omitnan');
ydiff2=abs(yInfo2-yRand2);
cond2=mean(ydiff2,1);
sem2=nanstd(ydiff2,[],1) ./ sqrt(size(ydiff2,1));

for t=1:size(ydiff1,2)
    [ks(t),pks(t)] = kstest2(ydiff1(:,t),ydiff2(:,t));
    [~,pt(t)] = ttest(ydiff1(:,t),ydiff2(:,t));
end

cond1=cond1-mean(cond1(30:40));
cond2=cond2-mean(cond2(30:40));

h_for_legend(end+1)=plot(cond1,'Color','r','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond1-sem1, fliplr(cond1+sem1)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(cond2,'Color','b','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond2-sem2, fliplr(cond2+sem2)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
for m=1:numel(mice)
    plot(mean(ydiff1(a.mouse==m,:),1),'Color','r','linewidth',0.5);
    plot(mean(ydiff2(a.mouse==m,:),1),'Color','b','linewidth',0.5);
end
legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of Info-No Info')
title('Info - No Info')

elseif condct==3
    y1=mean(a.C_odor1FirstInfoForced{1},3,'omitnan');
    size(y1);
    y2=mean(a.C_odor1FirstRandForced{1},3,'omitnan');
    y1mean=mean(y1,1);
    y2mean=mean(y2,1);
    ydiff=abs(y1-y2);
    size(ydiff);
    cond1=mean(ydiff,1);
    y1=mean(a.C_odor1FirstInfoForced{2},3,'omitnan');
    y2=mean(a.C_odor1FirstRandForced{2},3,'omitnan');
    ydiff=abs(y1-y2);
    cond2=mean(ydiff,1);
    y1=mean(a.C_odor1FirstInfoForced{3},3,'omitnan');
    y2=mean(a.C_odor1FirstRandForced{3},3,'omitnan');
    ydiff=abs(y1-y2);
    cond3=mean(ydiff,1);    
    plot(cond1);
    plot(cond2)
    plot(cond3)
    legend(conditionNames,'Orientation','vertical','Location','northwest','Box','off');
end

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_absDiff_',[conditionNames{:}]]),'pdf');

%%

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;

nsubplot(1,1,1,1);
h_for_legend=[];
if condct==2
y1=mean(a.C_odor1FirstInfoForced{1},3,'omitnan');
size(y1);
y2=mean(a.C_odor1FirstRandForced{1},3,'omitnan');
y1mean=mean(y1,1);
y2mean=mean(y2,1);
ydiff1=abs(y1-y2);
size(ydiff);
cond1=abs(y1mean-y2mean);
% sem1=nanstd(ydiff1,[],1) ./ sqrt(size(ydiff1,1));
y1=mean(a.C_odor1FirstInfoForced{2},3,'omitnan');
y2=mean(a.C_odor1FirstRandForced{2},3,'omitnan');
y1mean=mean(y1,1);
y2mean=mean(y2,1);
ydiff2=abs(y1-y2);
cond2=abs(y1mean-y2mean);
% sem2=nanstd(ydiff2,[],1) ./ sqrt(size(ydiff2,1));

h_for_legend(end+1)=plot(cond1,'Color','r','linewidth',4);
% h = fill([1:80, fliplr(1:80)], [cond1-sem1, fliplr(cond1+sem1)], 'r','EdgeColor','none');
% set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(cond2,'Color','b','linewidth',4);
% h = fill([1:80, fliplr(1:80)], [cond2-sem2, fliplr(cond2+sem2)], 'b','EdgeColor','none');
% set(h, 'FaceAlpha', 0.1);
% for m=1:numel(mice)
%     plot(mean(ydiff1(a.mouse==m,:),1),'Color','r','linewidth',0.5);
%     plot(mean(ydiff2(a.mouse==m,:),1),'Color','b','linewidth',0.5);
% end
legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of Info-Mean of No Info')
title('Info - No Info, mean diff')

elseif condct==3
    y1=mean(a.C_odor1FirstInfoForced{1},3,'omitnan');
    size(y1);
    y2=mean(a.C_odor1FirstRandForced{1},3,'omitnan');
    y1mean=mean(y1,1);
    y2mean=mean(y2,1);
    ydiff=abs(y1-y2);
    size(ydiff);
    cond1=mean(ydiff,1);
    y1=mean(a.C_odor1FirstInfoForced{2},3,'omitnan');
    y2=mean(a.C_odor1FirstRandForced{2},3,'omitnan');
    ydiff=abs(y1-y2);
    cond2=mean(ydiff,1);
    y1=mean(a.C_odor1FirstInfoForced{3},3,'omitnan');
    y2=mean(a.C_odor1FirstRandForced{3},3,'omitnan');
    ydiff=abs(y1-y2);
    cond3=mean(ydiff,1);    
    plot(cond1);
    plot(cond2)
    plot(cond3)
    legend(conditionNames,'Orientation','vertical','Location','northwest','Box','off');
end

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_absMeanDiff_',[conditionNames{:}]]),'pdf');

%% ABS DIFF AB

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;

nsubplot(1,1,1,1);
h_for_legend=[];
if condct==2
yA1=mean(a.C_odor2A{1},3,'omitnan');
size(yA1);
yB1=mean(a.C_odor2B{1},3,'omitnan');
yA1mean=mean(yA1,1);
yB1mean=mean(yB1,1);
ydiff1=abs(yA1-yB1);
size(ydiff1);
cond1=mean(ydiff1,1);
sem1=nanstd(ydiff1,[],1) ./ sqrt(size(ydiff1,1));
yA2=mean(a.C_odor2A{2},3,'omitnan');
yB2=mean(a.C_odor2B{2},3,'omitnan');
ydiff2=abs(yA2-yB2);
cond2=mean(ydiff2,1);
sem2=nanstd(ydiff2,[],1) ./ sqrt(size(ydiff2,1));

cond1=cond1-mean(cond1(30:40));
cond2=cond2-mean(cond2(30:40));


for t=1:size(ydiff1,2)
    [ks(t),pks(t)] = kstest2(ydiff1(:,t),ydiff2(:,t));
    pt(t) = ttest(ydiff1(:,t),ydiff2(:,t));
end

h_for_legend(end+1)=plot(cond1,'Color','r','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond1-sem1, fliplr(cond1+sem1)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(cond2,'Color','b','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond2-sem2, fliplr(cond2+sem2)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
for m=1:numel(mice)
    plot(mean(ydiff1(a.mouse==m,:),1),'Color','r','linewidth',0.5);
    plot(mean(ydiff2(a.mouse==m,:),1),'Color','b','linewidth',0.5);
end
legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of A-B')
title('Odor A - B')

elseif condct==3
    y1=mean(a.C_odor2A{1},3,'omitnan');
    size(y1);
    y2=mean(a.C_odor2B{1},3,'omitnan');
    y1mean=mean(y1,1);
    y2mean=mean(y2,1);
    ydiff=abs(y1-y2);
    size(ydiff);
    cond1=mean(ydiff,1);
    y1=mean(a.C_odor2A{2},3,'omitnan');
    y2=mean(a.C_odor2B{2},3,'omitnan');
    ydiff=abs(y1-y2);
    cond2=mean(ydiff,1);
    y1=mean(a.C_odor2A{3},3,'omitnan');
    y2=mean(a.C_odor2B{3},3,'omitnan');
    ydiff=abs(y1-y2);
    cond3=mean(ydiff,1);    
    plot(cond1);
    plot(cond2)
    plot(cond3)
    legend(conditionNames,'Orientation','vertical','Location','northwest','Box','off');
end

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_absDiffAB_',[conditionNames{:}]]),'pdf');

%% ABS DIFF CD

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;

nsubplot(1,1,1,1);
h_for_legend=[];

yC1=mean(a.C_odor2C{1},3,'omitnan');
size(yC1);
yD1=mean(a.C_odor2D{1},3,'omitnan');
yC1mean=mean(yC1,1);
yD1mean=mean(yD1,1);
ydiff1=abs(yD1-yC1);
size(ydiff1);
cond1=mean(ydiff1,1);
sem1=nanstd(ydiff1,[],1) ./ sqrt(size(ydiff1,1));
yC2=mean(a.C_odor2C{2},3,'omitnan');
yD2=mean(a.C_odor2D{2},3,'omitnan');
ydiff2=abs(yD2-yC2);
cond2=mean(ydiff2,1);
sem2=nanstd(ydiff2,[],1) ./ sqrt(size(ydiff2,1));

for t=1:size(ydiff1,2)
    [ks(t),pks(t)] = kstest2(ydiff1(:,t),ydiff2(:,t));
    pt(t) = ttest(ydiff1(:,t),ydiff2(:,t));
end

cond1=cond1-mean(cond1(30:40));
cond2=cond2-mean(cond2(30:40));


h_for_legend(end+1)=plot(cond1,'Color','r','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond1-sem1, fliplr(cond1+sem1)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(cond2,'Color','b','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond2-sem2, fliplr(cond2+sem2)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
for m=1:numel(mice)
    plot(mean(ydiff1(a.mouse==m,:),1),'Color','r','linewidth',0.5);
    plot(mean(ydiff2(a.mouse==m,:),1),'Color','b','linewidth',0.5);
end
legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of D-C')
title('Odor D - C')

% elseif condct==3
%     y1=mean(a.C_odor2A{1},3,'omitnan');
%     size(y1);
%     y2=mean(a.C_odor2B{1},3,'omitnan');
%     y1mean=mean(y1,1);
%     y2mean=mean(y2,1);
%     ydiff=abs(y1-y2);
%     size(ydiff);
%     cond1=mean(ydiff,1);
%     y1=mean(a.C_odor2A{2},3,'omitnan');
%     y2=mean(a.C_odor2B{2},3,'omitnan');
%     ydiff=abs(y1-y2);
%     cond2=mean(ydiff,1);
%     y1=mean(a.C_odor2A{3},3,'omitnan');
%     y2=mean(a.C_odor2B{3},3,'omitnan');
%     ydiff=abs(y1-y2);
%     cond3=mean(ydiff,1);    
%     plot(cond1);
%     plot(cond2)
%     plot(cond3)
%     legend(conditionNames,'Orientation','vertical','Location','northwest','Box','off');
% end

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_absDiffCD_',[conditionNames{:}]]),'pdf');

%% ABS DIFF AB-CD

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;

nsubplot(1,1,1,1);
h_for_legend=[];

yA1=mean(a.C_odor2info{1},3,'omitnan');
size(yA1);
yB1=mean(a.C_odor2rand{1},3,'omitnan');

y11=yA1(:,:,1:2:end);
y12=yA1(:,:,1:2:end);

y21=yB1(:,:,1:2:end);
y22=yB1(:,:,1:2:end);    

y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
y1mean2 = mean(y12,3,'omitnan');
y2mean1 = mean(y21,3,'omitnan');
y2mean2 = mean(y22,3,'omitnan');

activityDifferenceTrial1 = y1mean1-y2mean1;
activityDifferenceTrial2 = y1mean2-y2mean2;
ydiff1= (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;
cond1=mean(ydiff1,1);
sem1=nanstd(ydiff1,[],1) ./ sqrt(size(ydiff1,1));

yA2=mean(a.C_odor2info{2},3,'omitnan');
yB2=mean(a.C_odor2rand{2},3,'omitnan');

y11=yA2(:,:,1:2:end);
y12=yA2(:,:,1:2:end);

y21=yB2(:,:,1:2:end);
y22=yB2(:,:,1:2:end);    

y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
y1mean2 = mean(y12,3,'omitnan');
y2mean1 = mean(y21,3,'omitnan');
y2mean2 = mean(y22,3,'omitnan');

activityDifferenceTrial1 = y1mean1-y2mean1;
activityDifferenceTrial2 = y1mean2-y2mean2;
ydiff2= (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;

cond2=mean(ydiff2,1);
sem2=nanstd(ydiff2,[],1) ./ sqrt(size(ydiff2,1));

cond1=cond1-mean(cond1(30:40));
cond2=cond2-mean(cond2(30:40));


% for t=1:size(ydiff1,2)
%     [ks(t),pks(t)] = kstest2(ydiff1(:,t),ydiff2(:,t));
%     pt(t) = ttest(ydiff1(:,t),ydiff2(:,t));
% end

h_for_legend(end+1)=plot(cond1,'Color','r','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond1-sem1, fliplr(cond1+sem1)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(cond2,'Color','b','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond2-sem2, fliplr(cond2+sem2)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
for m=1:numel(mice)
    plot(mean(ydiff1(a.mouse==m,:),1),'Color','r','linewidth',0.5);
    plot(mean(ydiff2(a.mouse==m,:),1),'Color','b','linewidth',0.5);
end
legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of AB-CD')
title('Odor AB - CD')

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_absDiffABCD_EBM_',[conditionNames{:}]]),'pdf');

%% ABS DIFF AB

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;

nsubplot(1,1,1,1);
h_for_legend=[];

yA1=mean(a.C_odor2A{1},3,'omitnan');
size(yA1);
yB1=mean(a.C_odor2B{1},3,'omitnan');

y11=yA1(:,:,1:2:end);
y12=yA1(:,:,1:2:end);

y21=yB1(:,:,1:2:end);
y22=yB1(:,:,1:2:end);    

y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
y1mean2 = mean(y12,3,'omitnan');
y2mean1 = mean(y21,3,'omitnan');
y2mean2 = mean(y22,3,'omitnan');

activityDifferenceTrial1 = y1mean1-y2mean1;
activityDifferenceTrial2 = y1mean2-y2mean2;
ydiff1= (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;
cond1=mean(ydiff1,1);
sem1=nanstd(ydiff1,[],1) ./ sqrt(size(ydiff1,1));

yA2=mean(a.C_odor2A{2},3,'omitnan');
yB2=mean(a.C_odor2B{2},3,'omitnan');

y11=yA2(:,:,1:2:end);
y12=yA2(:,:,1:2:end);

y21=yB2(:,:,1:2:end);
y22=yB2(:,:,1:2:end);    

y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
y1mean2 = mean(y12,3,'omitnan');
y2mean1 = mean(y21,3,'omitnan');
y2mean2 = mean(y22,3,'omitnan');

activityDifferenceTrial1 = y1mean1-y2mean1;
activityDifferenceTrial2 = y1mean2-y2mean2;
ydiff2= (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;

cond2=mean(ydiff2,1);
sem2=nanstd(ydiff2,[],1) ./ sqrt(size(ydiff2,1));

cond1=cond1-mean(cond1(30:40));
cond2=cond2-mean(cond2(30:40));


% for t=1:size(ydiff1,2)
%     [ks(t),pks(t)] = kstest2(ydiff1(:,t),ydiff2(:,t));
%     pt(t) = ttest(ydiff1(:,t),ydiff2(:,t));
% end

h_for_legend(end+1)=plot(cond1,'Color','r','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond1-sem1, fliplr(cond1+sem1)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(cond2,'Color','b','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond2-sem2, fliplr(cond2+sem2)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
for m=1:numel(mice)
    plot(mean(ydiff1(a.mouse==m,:),1),'Color','r','linewidth',0.5);
    plot(mean(ydiff2(a.mouse==m,:),1),'Color','b','linewidth',0.5);
end
legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of A-B')
title('Odor A - B')

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_absDiffAB_EBM_',[conditionNames{:}]]),'pdf');

%% ABS DIFF CD

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;

nsubplot(1,1,1,1);
h_for_legend=[];

yA1=mean(a.C_odor2C{1},3,'omitnan');
size(yA1);
yB1=mean(a.C_odor2D{1},3,'omitnan');

y11=yA1(:,:,1:2:end);
y12=yA1(:,:,1:2:end);

y21=yB1(:,:,1:2:end);
y22=yB1(:,:,1:2:end);    

y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
y1mean2 = mean(y12,3,'omitnan');
y2mean1 = mean(y21,3,'omitnan');
y2mean2 = mean(y22,3,'omitnan');

activityDifferenceTrial1 = y1mean1-y2mean1;
activityDifferenceTrial2 = y1mean2-y2mean2;
ydiff1= (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;
cond1=mean(ydiff1,1);
sem1=nanstd(ydiff1,[],1) ./ sqrt(size(ydiff1,1));

yA2=mean(a.C_odor2C{2},3,'omitnan');
yB2=mean(a.C_odor2D{2},3,'omitnan');

y11=yA2(:,:,1:2:end);
y12=yA2(:,:,1:2:end);

y21=yB2(:,:,1:2:end);
y22=yB2(:,:,1:2:end);    

y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
y1mean2 = mean(y12,3,'omitnan');
y2mean1 = mean(y21,3,'omitnan');
y2mean2 = mean(y22,3,'omitnan');

activityDifferenceTrial1 = y1mean1-y2mean1;
activityDifferenceTrial2 = y1mean2-y2mean2;
ydiff2= (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;

cond2=mean(ydiff2,1);
sem2=nanstd(ydiff2,[],1) ./ sqrt(size(ydiff2,1));

cond1=cond1-mean(cond1(30:40));
cond2=cond2-mean(cond2(30:40));


% for t=1:size(ydiff1,2)
%     [ks(t),pks(t)] = kstest2(ydiff1(:,t),ydiff2(:,t));
%     pt(t) = ttest(ydiff1(:,t),ydiff2(:,t));
% end

h_for_legend(end+1)=plot(cond1,'Color','r','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond1-sem1, fliplr(cond1+sem1)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(cond2,'Color','b','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond2-sem2, fliplr(cond2+sem2)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
for m=1:numel(mice)
    plot(mean(ydiff1(a.mouse==m,:),1),'Color','r','linewidth',0.5);
    plot(mean(ydiff2(a.mouse==m,:),1),'Color','b','linewidth',0.5);
end
legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of C-D')
title('Odor C - D')

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_absDiffCD_EBM_',[conditionNames{:}]]),'pdf');

%% ABS DIFF OUTCOME EBM

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;

nsubplot(1,2,1,1);
h_for_legend=[];
yA1=mean(a.C_outcomeRandBig{1},3,'omitnan');
size(yA1);
yB1=mean(a.C_outcomeRandSmall{1},3,'omitnan');
y11=yA1(:,:,1:2:end);
y12=yA1(:,:,1:2:end);

y21=yB1(:,:,1:2:end);
y22=yB1(:,:,1:2:end);    

y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
y1mean2 = mean(y12,3,'omitnan');
y2mean1 = mean(y21,3,'omitnan');
y2mean2 = mean(y22,3,'omitnan');

activityDifferenceTrial1 = y1mean1-y2mean1;
activityDifferenceTrial2 = y1mean2-y2mean2;
ydiff1= (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;
cond1=mean(ydiff1,1);
sem1=nanstd(ydiff1,[],1) ./ sqrt(size(ydiff1,1));

yA2=mean(a.C_outcomeRandBig{2},3,'omitnan');
yB2=mean(a.C_outcomeRandSmall{2},3,'omitnan');
y11=yA2(:,:,1:2:end);
y12=yA2(:,:,1:2:end);

y21=yB2(:,:,1:2:end);
y22=yB2(:,:,1:2:end);    

y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
y1mean2 = mean(y12,3,'omitnan');
y2mean1 = mean(y21,3,'omitnan');
y2mean2 = mean(y22,3,'omitnan');

activityDifferenceTrial1 = y1mean1-y2mean1;
activityDifferenceTrial2 = y1mean2-y2mean2;
ydiff2= (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;

cond2=mean(ydiff2,1);
sem2=nanstd(ydiff2,[],1) ./ sqrt(size(ydiff2,1));

% for t=1:size(ydiff1,2)
%     [ks(t),pks(t)] = kstest2(ydiff1(:,t),ydiff2(:,t));
%     pt(t) = ttest(ydiff1(:,t),ydiff2(:,t));
% end

cond1=cond1-mean(cond1(30:40));
cond2=cond2-mean(cond2(30:40));


h_for_legend(end+1)=plot(cond1,'Color','r','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond1-sem1, fliplr(cond1+sem1)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(cond2,'Color','b','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond2-sem2, fliplr(cond2+sem2)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
for m=1:numel(mice)
    plot(mean(ydiff1(a.mouse==m,:),1),'Color','r','linewidth',0.5);
    plot(mean(ydiff2(a.mouse==m,:),1),'Color','b','linewidth',0.5);
end
legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of No Info Water - No Info No Water')
title('No Info Water')


nsubplot(1,2,1,2);
h_for_legend=[];

yA1=mean(a.C_outcomeInfoBig{1},3,'omitnan');
size(yA1);
yB1=mean(a.C_outcomeInfoSmall{1},3,'omitnan');

y11=yA1(:,:,1:2:end);
y12=yA1(:,:,1:2:end);

y21=yB1(:,:,1:2:end);
y22=yB1(:,:,1:2:end);    

y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
y1mean2 = mean(y12,3,'omitnan');
y2mean1 = mean(y21,3,'omitnan');
y2mean2 = mean(y22,3,'omitnan');

activityDifferenceTrial1 = y1mean1-y2mean1;
activityDifferenceTrial2 = y1mean2-y2mean2;
ydiff1= (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;
cond1=mean(ydiff1,1);
sem1=nanstd(ydiff1,[],1) ./ sqrt(size(ydiff1,1));
yA2=mean(a.C_outcomeInfoBig{2},3,'omitnan');
yB2=mean(a.C_outcomeInfoSmall{2},3,'omitnan');
y11=yA2(:,:,1:2:end);
y12=yA2(:,:,1:2:end);

y21=yB2(:,:,1:2:end);
y22=yB2(:,:,1:2:end);    

y1mean1 = mean(y11,3,'omitnan'); % mean across trials in cond 1
y1mean2 = mean(y12,3,'omitnan');
y2mean1 = mean(y21,3,'omitnan');
y2mean2 = mean(y22,3,'omitnan');

activityDifferenceTrial1 = y1mean1-y2mean1;
activityDifferenceTrial2 = y1mean2-y2mean2;
ydiff2= (sign(activityDifferenceTrial1).*activityDifferenceTrial2+sign(activityDifferenceTrial2).*activityDifferenceTrial1)/2;

cond2=mean(ydiff2,1);
sem2=nanstd(ydiff2,[],1) ./ sqrt(size(ydiff2,1));

cond1=cond1-mean(cond1(30:40));
cond2=cond2-mean(cond2(30:40));

% for t=1:size(ydiff1,2)
%     [ks(t),pks(t)] = kstest2(ydiff1(:,t),ydiff2(:,t));
%     pt(t) = ttest(ydiff1(:,t),ydiff2(:,t));
% end

h_for_legend(end+1)=plot(cond1,'Color','r','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond1-sem1, fliplr(cond1+sem1)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(cond2,'Color','b','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond2-sem2, fliplr(cond2+sem2)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
for m=1:numel(mice)
    plot(mean(ydiff1(a.mouse==m,:),1),'Color','r','linewidth',0.5);
    plot(mean(ydiff2(a.mouse==m,:),1),'Color','b','linewidth',0.5);
end
legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of Info Water - Info No Water')
title('Info Water')


saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_absDiffoutcome_EBM_',[conditionNames{:}]]),'pdf');

%% ABS DIFF OUTCOME

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
hold on;

nsubplot(1,2,1,1);
h_for_legend=[];
if condct==2
yA1=mean(a.C_outcomeRandBig{1},3,'omitnan');
size(yA1);
yB1=mean(a.C_outcomeRandSmall{1},3,'omitnan');
yA1mean=mean(yA1,1);
yB1mean=mean(yB1,1);
ydiff1=abs(yA1-yB1);
size(ydiff1);
cond1=mean(ydiff1,1);
sem1=nanstd(ydiff1,[],1) ./ sqrt(size(ydiff1,1));
yA2=mean(a.C_outcomeRandBig{2},3,'omitnan');
yB2=mean(a.C_outcomeRandSmall{2},3,'omitnan');
ydiff2=abs(yA2-yB2);
cond2=mean(ydiff2,1);
sem2=nanstd(ydiff2,[],1) ./ sqrt(size(ydiff2,1));

for t=1:size(ydiff1,2)
    [ks(t),pks(t)] = kstest2(ydiff1(:,t),ydiff2(:,t));
    pt(t) = ttest(ydiff1(:,t),ydiff2(:,t));
end

cond1=cond1-mean(cond1(30:40));
cond2=cond2-mean(cond2(30:40));


h_for_legend(end+1)=plot(cond1,'Color','r','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond1-sem1, fliplr(cond1+sem1)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(cond2,'Color','b','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond2-sem2, fliplr(cond2+sem2)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
for m=1:numel(mice)
    plot(mean(ydiff1(a.mouse==m,:),1),'Color','r','linewidth',0.5);
    plot(mean(ydiff2(a.mouse==m,:),1),'Color','b','linewidth',0.5);
end
legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of No Info Water - No Info No Water')
title('No Info Water')

elseif condct==3
    y1=mean(a.C_outcomeRandBig{1},3,'omitnan');
    size(y1);
    y2=mean(a.C_outcomeRandSmall{1},3,'omitnan');
    y1mean=mean(y1,1);
    y2mean=mean(y2,1);
    ydiff=abs(y1-y2);
    size(ydiff);
    cond1=mean(ydiff,1);
    y1=mean(a.C_outcomeRandBig{2},3,'omitnan');
    y2=mean(a.C_outcomeRandSmall{2},3,'omitnan');
    ydiff=abs(y1-y2);
    cond2=mean(ydiff,1);
    y1=mean(a.C_outcomeRandBig{3},3,'omitnan');
    y2=mean(a.C_outcomeRandSmall{3},3,'omitnan');
    ydiff=abs(y1-y2);
    cond3=mean(ydiff,1);    
    plot(cond1);
    plot(cond2)
    plot(cond3)
    legend(conditionNames,'Orientation','vertical','Location','northwest','Box','off');
end

nsubplot(1,2,1,2);
h_for_legend=[];
if condct==2
yA1=mean(a.C_outcomeInfoBig{1},3,'omitnan');
size(yA1);
yB1=mean(a.C_outcomeInfoSmall{1},3,'omitnan');
yA1mean=mean(yA1,1);
yB1mean=mean(yB1,1);
ydiff1=abs(yA1-yB1);
size(ydiff1);
cond1=mean(ydiff1,1);
sem1=nanstd(ydiff1,[],1) ./ sqrt(size(ydiff1,1));
yA2=mean(a.C_outcomeInfoBig{2},3,'omitnan');
yB2=mean(a.C_outcomeInfoSmall{2},3,'omitnan');
ydiff2=abs(yA2-yB2);
cond2=mean(ydiff2,1);
sem2=nanstd(ydiff2,[],1) ./ sqrt(size(ydiff2,1));

for t=1:size(ydiff1,2)
    [ks(t),pks(t)] = kstest2(ydiff1(:,t),ydiff2(:,t));
    pt(t) = ttest(ydiff1(:,t),ydiff2(:,t));
end

h_for_legend(end+1)=plot(cond1,'Color','r','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond1-sem1, fliplr(cond1+sem1)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(cond2,'Color','b','linewidth',4);
h = fill([1:80, fliplr(1:80)], [cond2-sem2, fliplr(cond2+sem2)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
for m=1:numel(mice)
    plot(mean(ydiff1(a.mouse==m,:),1),'Color','r','linewidth',0.5);
    plot(mean(ydiff2(a.mouse==m,:),1),'Color','b','linewidth',0.5);
end
legend(h_for_legend,conditionNames,'Orientation','vertical','Location','northwest','Box','off');
xlabel('Time')
ylabel('Mean of Info Water - Info No Water')
title('Info Water')

elseif condct==3
    y1=mean(a.C_outcomeInfoBig{1},3,'omitnan');
    size(y1);
    y2=mean(a.C_outcomeInfoSmall{1},3,'omitnan');
    y1mean=mean(y1,1);
    y2mean=mean(y2,1);
    ydiff=abs(y1-y2);
    size(ydiff);
    cond1=mean(ydiff,1);
    y1=mean(a.C_outcomeInfoBig{2},3,'omitnan');
    y2=mean(a.C_outcomeInfoSmall{2},3,'omitnan');
    ydiff=abs(y1-y2);
    cond2=mean(ydiff,1);
    y1=mean(a.C_outcomeInfoBig{3},3,'omitnan');
    y2=mean(a.C_outcomeInfoSmall{3},3,'omitnan');
    ydiff=abs(y1-y2);
    cond3=mean(ydiff,1);    
    plot(cond1);
    plot(cond2)
    plot(cond3)
    legend(conditionNames,'Orientation','vertical','Location','northwest','Box','off');
end

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_absDiffoutcome_',[conditionNames{:}]]),'pdf');

%%  TIME CONDITION DIFFERENCES NEW

y_info=[]; infoSort=[]; infoIdx=[];
y_rand=[]; randSort=[]; randIdx=[];
diffSort=[];diffIdx=[];

for cd=1:numel(conditions{1})
   y_info{cd}=mean(a.C_odor1FirstInfoForced{cd},3,'omitnan');
   y_rand{cd}=mean(a.C_odor1FirstRandForced{cd},3,'omitnan');
   
   y_info{cd}=y_info{cd}-mean(y_info{cd}(:,30:40),2);
   y_rand{cd}=y_rand{cd}-mean(y_rand{cd}(:,30:40),2);
   ydiff{cd}=y_info{cd}-y_rand{cd};
    [infoSort(:,cd),infoIdx(:,cd)] = sort(mean(y_info{cd}(:,40:64),2,'omitnan'),'descend');
    [randSort(:,cd),randIdx(:,cd)] = sort(mean(y_rand{cd}(:,40:64),2,'omitnan'),'descend');
    [diffSort(:,cd),diffIdx(:,cd)] = sort(mean(ydiff{cd}(:,40:64),2,'omitnan'),'descend');
%     [~,bothIdx(:,cd)] = sortrows([mean(y_info{cd}(:,40:50),2,'omitnan') mean(y_rand{cd}(:,40:50),2,'omitnan')],'descend');
end

% [~,bothIdx(:,cd)] = sortrows([mean(y_info{1}(:,40:50),2,'omitnan') mean(y_info{2}(:,40:50),2,'omitnan')],'descend');

infoPre=a.C_condBasePostRSActiveExp{1,1}(:,1)==1;
infoPost=a.C_condBasePostRSActiveExp{1,2}(:,1)==1;

%%
% idx=NaN(a.neuronCt,1);
% [~,idx2]=sort(mean(y_info{2}(infoPost,40:64),2,'omitnan'),'descend');
% [~,idx1]=sort(mean(y_info{1}(infoPre,40:64),2,'omitnan'),'descend');
% [~,idx3]=sort(mean(y_info{2}(~infoPre&~infoPost,40:64),2,'omitnan'),'descend');
% idx2=idx2+sum(infoPre&~infoPost);
% idx3=idx3+sum(infoPost&~infoPre);
% idx(~infoPre&~infoPost)=idx3;
% idx(infoPost)=idx2;
% idx(infoPre)=idx1;
% 
% cellIdx=1:a.neuronCt;
% cellIdx=find(infoPre);

%%


% y=y_info{1}(infoIdx(:,1),:);
% y2=y_info{1}(infoIdx(:,2),:);
% y3=y;
% y3(201:end,:)=y2(201:end,:);
% 
% [~,idx]=sort(mean(y3(:,40:64),2,'omitnan'),'descend');
% 
% idx2=infoIdx(:,2); % sort by post info
% idx1=infoIdx(:,1); % sort by pre info
% idx=idx1;
% [~,idx3]=sort(idx2(idx1>200),'descend');
% idx(idx1>200)=idx3;
% 
% % idx(idx>sum(infoPre))=sort(idx2(~infoPre));


%% 

e=3;
t=a.t{e};
% color_limits=[-1.4,1.4];
color_limits=[-1.6 1.6];
diff_limits = [-0.8 0.8];

%%

cd=2;
% cell_sort_ids=infoIdx(:,1);
% cell_sort_ids=bothIdx(:,cd);
cell_sort_ids=diffIdx(:,cd);
% cell_sort_ids=infoPre;
% cell_sort_ids=idx;

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');


ax=nsubplot(1,4,1,1);
y=y_info{1};
% y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
% imagesc(t,1:size(y,1),y3,color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'Left  '; conditionNames{1}}); %{'First line';'Second line'}
set(ax, 'Ydir', 'reverse')
% ylim([0 20])
colorbar();

ax=nsubplot(1,4,1,2);
y=y_rand{1};
% y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'Right  '; conditionNames{1}}); %{'First line';'Second line'}
set(ax, 'Ydir', 'reverse')
colorbar();

ax=nsubplot(1,4,1,3);
y=y_info{2};
% y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'Info  '; conditionNames{2}}); %{'First line';'Second line'}
set(ax, 'Ydir', 'reverse')
colorbar();

ax=nsubplot(1,4,1,4);
y=y_rand{2};
% y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'No Info  '; conditionNames{2}}); %{'First line';'Second line'}
set(ax, 'Ydir', 'reverse')
colorbar();


colorcet('D1');
% colormap(a.ckr);
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, [strjoin(mice,' _ '),' Sort Info ',conditionNames{cd}],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');


saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_TimeConditionDifferences_SortNEW_',conditionNames{cd}]),'pdf');

%%

% cd=2;
% cell_sort_ids=infoIdx(:,1);
% cell_sort_ids=bothIdx(:,cd);
% cell_sort_ids=diffIdx(:,cd);
% cell_sort_ids=infoPre;
% cell_sort_ids=idx;

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');


ax=nsubplot(1,4,1,1);
y1=y_info{1}(infoIdx(:,1),:);
y2=y_info{1}(infoIdx(:,2),:);
y=y1;
y(201:end,:)=y2(201:end,:);
% y=y-mean(y(:,30:40),2);
% imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
imagesc(t,1:size(y,1),y,color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'Left  '; conditionNames{1}}); %{'First line';'Second line'}
set(ax, 'Ydir', 'reverse')
% ylim([0 20])
colorbar();

ax=nsubplot(1,4,1,2);
y1=y_rand{1}(infoIdx(:,1),:);
y2=y_rand{1}(infoIdx(:,2),:);
y=y1;
% y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y,color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'Right  '; conditionNames{1}}); %{'First line';'Second line'}
set(ax, 'Ydir', 'reverse')
colorbar();

ax=nsubplot(1,4,1,3);
y1=y_info{2}(infoIdx(:,1),:);
y2=y_info{2}(infoIdx(:,2),:);
y=y1;
y(201:end,:)=y2(201:end,:);
% y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y,color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'Info  '; conditionNames{2}}); %{'First line';'Second line'}
set(ax, 'Ydir', 'reverse')
colorbar();

ax=nsubplot(1,4,1,4);
y1=y_rand{2}(infoIdx(:,1),:);
y2=y_rand{2}(infoIdx(:,2),:);
y=y1;
y(201:end,:)=y2(201:end,:);
% y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y,color_limits);
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1.45]);
xlabel('Seconds');
title({'No Info  '; conditionNames{2}}); %{'First line';'Second line'}
set(ax, 'Ydir', 'reverse')
colorbar();


colorcet('D1');
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, [strjoin(mice,' _ '),' Sort Info ',conditionNames{cd}],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');


saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_TimeConditionDifferences_SortNEW']),'pdf');

%% CODING STABILITY

fig = figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [1 1 10 7];
set(fig,'PaperOrientation','landscape');
set(fig,'renderer','painters');

y_info{1}=mean(a.C_odor1FirstInfoForced{1},3,'omitnan');
y_rand{1}=mean(a.C_odor1FirstRandForced{1},3,'omitnan');
y_info{2}=mean(a.C_odor1FirstInfoForced{2},3,'omitnan');
y_rand{2}=mean(a.C_odor1FirstRandForced{2},3,'omitnan');

info1=mean(y_info{1}(:,a.okt{e}),2);
info2=mean(y_info{2}(:,a.okt{e}),2);
rand1=mean(y_rand{1}(:,a.okt{e}),2);
rand2=mean(y_rand{2}(:,a.okt{e}),2);

ax1=nsubplot(1,2,1,1);
hold on;
scatter(ax1,info1,info2, 'k');
[co,p]=corr(info1,info2,'Type','Pearson');
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
h = refline(1, 0);          % slope = 1, intercept = 0
h.Color = 'r';              % optional: change color
h.LineStyle = '--'; 
xlabel('Mean Info Activity Day 1');
ylabel('Mean Info Activity Day 2');
title(['Info corr= ' num2str(co) ' p= ' num2str(p,'%.4g') ]);
axis equal;
hold off;

ax2=nsubplot(1,2,1,2);
hold on;
scatter(ax2,rand1,rand2, 'k');
[co,p]=corr(rand1,rand2,'Type','Pearson');
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
h = refline(1, 0);          % slope = 1, intercept = 0
h.Color = 'r';              % optional: change color
h.LineStyle = '--'; 
xlabel('Mean Rand Activity Day 1');
ylabel('Mean Rand Activity Day 2');
title(['Rand corr= ' num2str(co) ' p= ' num2str(p,'%.4g') ]);
axis square;
hold off;
saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_ConditionCorr']),'pdf');
