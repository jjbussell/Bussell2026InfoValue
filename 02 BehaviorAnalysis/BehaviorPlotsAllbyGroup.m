close all;

%% SAVEPATH

% datapath=findInfoseekData();
datapath = 'D:\Bussell Dropbox\Jennifer Bussell\BpodInfoseek\';
% datapath = 'D:\Bussell Dropbox\Bussell Lab\BpodInfoseek\'; 
% datapath = 'C:\Users\Axel\Bussell Dropbox\Bussell Lab\BpodInfoseek\';
% datapath = 'C:\Users\Jen\Bussell Dropbox\Jennifer Bussell\BpodInfoseek\';

% plotfolder=fullfile(datapath,'AllMicePlotsNoCTSilencing');
% plotfolder=fullfile(datapath,'AllMicePlotsStay');
plotfolder=fullfile(datapath,'AllMicePlots');

pathname=plotfolder;

set(0,'DefaultFigureWindowStyle','docked'); % plot in docked window
% 
%% PLOTTING COLORS AND LABELS

purple = [121 32 196] ./ 255;
orange = [251 139 6] ./ 255;
cornflower = [100 149 237] ./ 255;
grey = [.8 .8 .8];

CCfinal = [0.2,0.2,0.2; %choice no choice
    0.474509803921569,0.125490196078431,0.768627450980392; %choice info big
    171/255,130/255,1; % choice info big NP
    0.9490, 0.8, 1.0; %choiceinfosmall
    238/255,224/255,229/255; %choiceinfoNPsmall    
    0.984313725490196,0.545098039215686,0.0235294117647059; %choice rand big
    245/255,222/255,179/255; % choice rand big NP
    1, 0.8, 0.0; %choice rand small
    244/255, 164/255, 96/255; %choice rand small NP
    0.6,0.6,0.6; %info no choice
    0,1,0; %info big
    152/255,251/255,152/255;% info big NP
    1,0,1; %infosmall
    1,192/255,203/255; %info small not present
    0.0,0.0,0.0; %infoincorrect
    0.2,0.2,0.2;% rand no choice
    0,0,1; %rand big
    135/255,206/255,1; % rand big NP
    0,1,1; %rand small
    187/255,1,1; %rand small NP
    0.0,0.0,0.0]; %rand incorrect

CCNP = [0.474509803921569,0.125490196078431,0.768627450980392; %choice info big
    0.9490, 0.8, 1.0; %choiceinfosmall  
    0.984313725490196,0.545098039215686,0.0235294117647059; %choice rand big
    1, 0.8, 0.0; %choice rand small
    0,1,0; %info big
    1,0,1; %infosmall
    0,0,1; %rand big
    0,1,1]; %rand small

CCtype = [grey; purple; orange;...
    0,1,0; %info big
    1,0,1; %infosmall
    0,0,1; %rand big
    0,1,1];

a.typeLabels = {'Choice','Info','No Info','Info Water',...
    'Info No Water','No Info Water','No Info No Water'};

a.choiceLabels = {'ChoiceInfoBig','ChoiceInfoSmall','ChoiceRandBig',...
    'ChoiceRandSmall','InfoBig','InfoSmall','RandBig','RandSmall'};

a.outcomeLabels = {'ChoiceNoChoice','ChoiceInfoBig','ChoiceInfoBigNP',...
    'ChoiceInfoSmall','ChoiceInfoSmallNP','ChoiceRandBig','ChoiceRandBigNP',...
    'ChoiceRandSmall','ChoiceRandSmallNP','InfoNoChoice','InfoBig',...
    'InfoBigNP','InfoSmall','InfoSmallNP','InfoIncorrect','RandNoChoice',...
    'RandBig','RandBigNP','RandSmall','RandSmallNP',...
    'RandIncorrect'};



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GROUPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% a.mouseNums = arrayfun(@(X)  find(a.mice(X,:),1,'last'), 1:size(a.mice,1))';

clear flag labels label;

% a.goodMice=ones(size(a.mouseList));
% a.goodMice([27 34 35])=2;
% 
% % % load('MouseTypesAll.mat');
% % % 
% flag='goodMice';
% labels={'GoodMice','BadMice'};
% label={'GoodBad'};

% flag='imageMice';
% labels={'WTMice','ImagedMice'};
% label={'Imaged'};


% a.sex=ones(size(a.mouseList));
% a.sex([20 24 25 27 29 33 34 35 36 37])=2;
% flag='sex';
% labels={'Male','Female'};
% label={'Sex'};
% 
% a.origMice=ones(size(a.mouseList));
% a.origMice(15:end)=2;
% flag='origMice';
% labels={'Original','Later'};
% label={'Orig'};

% a.noCT=ones(size(a.mouseList));
% a.noCT(5:end)=2;
% flag='noCT';
% label={'NoCT'};
% labels={'Imaging','WTnoCT'};

% a.leavingMice=ones(size(unique(a.mouse)));
% % a.leavingMice([1 2 3 11 12])=2;
% a.leavingMice([1 2 3 9 10])=2;
% % a.leavingMice([1 2 3])=2;
% % a.leavingMice([7 8])=3;
% flag='leavingMice';
% labels={'Tones','Always Water'};
% label={'LeavingMice'};

a.df=ones(size(a.mouseList));
% a.df([2 4 5 6 8 10 11 12 14 15])=2;
a.df([1 3 4 5 8 10 11 12 14 15])=2;
flag='df';
labels={'WT','Del'};
label={'Df16'};


active=sum(a.(flag)>0);
idx1=find(a.(flag)==1);
idx2=find(a.(flag)==2);
flag1=a.(flag)==1;
flag2=a.(flag)==2;
mice1=a.mouseList(idx1);
mice2=a.mouseList(idx2);
label1=labels{1};
label2=labels{2};

revFlag=a.(flag)(a.reverseMice);
idx1rev=find(revFlag==1);
idx2rev=find(revFlag==2);
mice1rev=a.mouseList(idx1rev);
mice2rev=a.mouseList(idx2rev);


% silencing=sum(a.halo>0);
% hIdx=find(a.halo==1);
% yIdx=find(a.halo==2);
% hMice=a.mouseList(hIdx);
% yMice=a.mouseList(yIdx);

%%
win = 0.050; % bins in ms
bins = [-1:win:15];
a.bins=bins;
a.win = win;

%% PLOT POPULATION MEAN CHOICES AROUND REVERSALS

for d=1:6
a.reversalMultiPrefsP(1,d) = signrank(a.reversalMultiPrefs(idx1rev,d)*100-50);
a.reversalMultiPrefsP(2,d) = signrank(a.reversalMultiPrefs(idx2rev,d)*100-50);
end

fig = figure();

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.YTick = [0 0.25 0.50 0.75 1];
ax.YLim = [0 1];
ax.XLim = [0.5 6.5];
ax.XTick = [1:6];
plot([1:3], mean(a.reversalMultiPrefs(idx1rev,1:3),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
for n=1:3
   errorbar(n,mean(a.reversalMultiPrefs(idx1rev,n),1,'omitnan'),sem(a.reversalMultiPrefs(idx1rev,n)),'Color','k','LineWidth',2,'CapSize',25);
   text(n, mean(a.reversalMultiPrefs(idx1rev,n),1,'omitnan') + 0.1, ['p=', num2str(a.reversalMultiPrefsP(1,n))], 'HorizontalAlignment', 'center');
end
plot([4:6], mean(a.reversalMultiPrefs(idx1rev,4:6),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
for n=4:6
   errorbar(n,mean(a.reversalMultiPrefs(idx1rev,n),1,'omitnan'),sem(a.reversalMultiPrefs(idx1rev,n)),'Color','k','LineWidth',2,'CapSize',25);
   text(n, mean(a.reversalMultiPrefs(idx1rev,n),1,'omitnan') + 0.1, ['p=', num2str(a.reversalMultiPrefsP(1,n))], 'HorizontalAlignment', 'center');
end    
plot([3.5 3.5],[-10000000 1000000],'color','r','linewidth',2,'linestyle','--','yliminclude','off','xliminclude','off');
reverseLabels = {'-3','-2','-1','1','2','3'};
set(gca,'XTickLabel',reverseLabels);
ylabel({'% choice of', 'info side'});
xlabel('Day relative to side reversal');
title(label1)
hold off;
axis square;

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.YTick = [0 0.25 0.50 0.75 1];
ax.YLim = [0 1];
ax.XLim = [0.5 6.5];
ax.XTick = [1:6];
plot([1:3], mean(a.reversalMultiPrefs(idx2rev,1:3),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
for n=1:3
   errorbar(n,mean(a.reversalMultiPrefs(idx2rev,n),1,'omitnan'),sem(a.reversalMultiPrefs(idx2rev,n)),'Color','k','LineWidth',2,'CapSize',25);
   text(n, mean(a.reversalMultiPrefs(idx2rev,n),1,'omitnan') + 0.1, ['p=', num2str(a.reversalMultiPrefsP(2,n))], 'HorizontalAlignment', 'center');
end
plot([4:6], mean(a.reversalMultiPrefs(idx2rev,4:6),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
for n=4:6
   errorbar(n,mean(a.reversalMultiPrefs(idx2rev,n),1,'omitnan'),sem(a.reversalMultiPrefs(idx2rev,n)),'Color','k','LineWidth',2,'CapSize',25);
   text(n, mean(a.reversalMultiPrefs(idx2rev,n),1,'omitnan') + 0.1, ['p=', num2str(a.reversalMultiPrefsP(2,n))], 'HorizontalAlignment', 'center');
end    
plot([3.5 3.5],[-10000000 1000000],'color','r','linewidth',2,'linestyle','--','yliminclude','off','xliminclude','off');
reverseLabels = {'-3','-2','-1','1','2','3'};
set(gca,'XTickLabel',reverseLabels);
ylabel({'% choice of', 'info side'});
xlabel('Day relative to side reversal');
title(label2)
hold off;
axis square;

saveas(fig,fullfile(pathname,[label{1} '_ReversalMultiChoicesIIS']),'pdf');

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PRE-REVERSAL, last 2 days before
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% PRE-REVERSAL DWELL TIME QUANT

[a.preRevDwellspval, tbl, stats] = friedman([a.infoDwell(idx1,1) a.randDwell(idx1,1) a.infoDwell1sec(idx1,1) a.randDwell1sec(idx1,1)], 1,'off');
a.preRevDwellComp = multcompare(stats,'Display','off');

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.YTick = [0 0.500 1.000];
ax.YLim = [0 1];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],[a.infoDwell(m,1) a.randDwell(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],[a.infoDwell1sec(m,1) a.randDwell1sec(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.infoDwell(idx1,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(1,mean(a.infoDwell(idx1,1)),sem(a.infoDwell(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.randDwell(idx1,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(3,mean(a.randDwell(idx1,1)),sem(a.randDwell(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(5,mean(a.infoDwell1sec(idx1,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(5,mean(a.infoDwell1sec(idx1,1)),sem(a.infoDwell1sec(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(7,mean(a.randDwell1sec(idx1,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(7,mean(a.randDwell1sec(idx1,1)),sem(a.randDwell1sec(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info','No Info','Info 1sec','No Info 1sec'});
ylabel('Probability in correct reward port during delay, pre-reverse');
p1=signrank(a.infoDwell(idx1,1),a.randDwell(idx1,1));
p2=signrank(a.infoDwell1sec(idx1,1),a.randDwell1sec(idx1,1));
title([label1 ' sign rank p = ' num2str(p1) ' 1sec p= ' num2str(p2) 'also Friedman'])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.YTick = [0 0.500 1.000];
ax.YLim = [0 1];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx2rev)
    m=idx2rev(mm);
    plot([1 3],[a.infoDwell(m,1) a.randDwell(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],[a.infoDwell1sec(m,1) a.randDwell1sec(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.infoDwell(idx2,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(1,mean(a.infoDwell(idx2,1)),sem(a.infoDwell(idx2,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.randDwell(idx2,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(3,mean(a.randDwell(idx2,1)),sem(a.randDwell(idx2,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(5,mean(a.infoDwell1sec(idx2,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(5,mean(a.infoDwell1sec(idx2,1)),sem(a.infoDwell1sec(idx2,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(7,mean(a.randDwell1sec(idx2,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(7,mean(a.randDwell1sec(idx2,1)),sem(a.randDwell1sec(idx2,1)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info','No Info','Info 1sec','No Info 1sec'});
ylabel('Probability in correct reward port during delay, pre-reverse');
p1=signrank(a.infoDwell(idx2,1),a.randDwell(idx2,1));
p2=signrank(a.infoDwell1sec(idx2,1),a.randDwell1sec(idx2,1));
title([label2 ' sign rank p = ' num2str(p1) ' 1sec p= ' num2str(p2) 'also Friedman']);

saveas(fig,fullfile(pathname,[label{1} '_preRevDwellTimeQuant']),'pdf');


%% PORT PROBABILITY PRE-REVERSAL

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(3,2,1,1);
title([label1 ' Probability in port by trial type, pre-reversal choice days']);
ax.FontSize = 8;
ylabel('CENTER port');
hold on;
fill([bins, fliplr(bins)], [mean(a.centerDwellChoice(idx1,:))-sem(a.centerDwellChoice(idx1,:)), fliplr(mean(a.centerDwellChoice(idx1,:))+sem(a.centerDwellChoice(idx1,:)))],grey,'EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.centerDwellInfo(idx1,:))-sem(a.centerDwellInfo(idx1,:)), fliplr(mean(a.centerDwellInfo(idx1,:))+sem(a.centerDwellInfo(idx1,:)))],purple,'EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.centerDwellRand(idx1,:))-sem(a.centerDwellRand(idx1,:)), fliplr(mean(a.centerDwellRand(idx1,:))+sem(a.centerDwellRand(idx1,:)))],orange,'EdgeColor','none','FaceAlpha', 0.1);
plot(bins,mean(a.centerDwellChoice(idx1,:)),'Color',grey,'LineWidth',0.5);
plot(bins,mean(a.centerDwellInfo(idx1,:)),'Color',purple,'LineWidth',0.5);
plot(bins,mean(a.centerDwellRand(idx1,:)),'Color',orange,'LineWidth',0.5);    
ax.YTick = [0 0.25 0.50 0.75 1];
ax.YLim = [-0.1 1.1];
plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
ax.XLim = [-1 12];
%     xlabel('Time relative to go cue (s)');

ax = nsubplot(3,2,2,1);
ax.FontSize = 8;
ylabel('INFO port');
hold on;
fill([bins, fliplr(bins)], [mean(a.infoDwellInfoBig(idx1,:))-sem(a.infoDwellInfoBig(idx1,:)), fliplr(mean(a.infoDwellInfoBig(idx1,:))+sem(a.infoDwellInfoBig(idx1,:)))],'g','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.infoDwellInfoSmall(idx1,:))-sem(a.infoDwellInfoSmall(idx1,:)), fliplr(mean(a.infoDwellInfoSmall(idx1,:))+sem(a.infoDwellInfoSmall(idx1,:)))],'m','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.infoDwellInfo(idx1,:))-sem(a.infoDwellInfo(idx1,:)), fliplr(mean(a.infoDwellInfo(idx1,:))+sem(a.infoDwellInfo(idx1,:)))],purple,'EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.infoDwellRandBig(idx1,:))-sem(a.infoDwellRandBig(idx1,:)), fliplr(mean(a.infoDwellRandBig(idx1,:))+sem(a.infoDwellRandBig(idx1,:)))],'b','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.infoDwellRandSmall(idx1,:))-sem(a.infoDwellRandSmall(idx1,:)), fliplr(mean(a.infoDwellRandSmall(idx1,:))+sem(a.infoDwellRandSmall(idx1,:)))],'c','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.infoDwellRand(idx1,:))-sem(a.infoDwellRand(idx1,:)), fliplr(mean(a.infoDwellRand(idx1,:))+sem(a.infoDwellRand(idx1,:)))],orange,'EdgeColor','none','FaceAlpha', 0.1);
plot(bins,mean(a.infoDwellInfoBig(idx1,:)),'Color','g','LineWidth',0.5);
plot(bins,mean(a.infoDwellInfoSmall(idx1,:)),'Color','m','LineWidth',0.5); 
plot(bins,mean(a.infoDwellRandBig(idx1,:)),'Color','b','LineWidth',0.5);
plot(bins,mean(a.infoDwellRandSmall(idx1,:)),'Color','c','LineWidth',0.5);
plot(bins,mean(a.infoDwellInfo(idx1,:)),'Color',purple,'LineWidth',0.5);
plot(bins,mean(a.infoDwellRand(idx1,:)),'Color',orange,'LineWidth',0.5);
ax.YTick = [0 0.25 0.50 0.75 1];
ax.YLim = [-0.1 1.1];
plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
ax.XLim = [-1 12];
%     xlabel('Time relative to go cue (s)');

ax = nsubplot(3,2,3,1);
ax.FontSize = 8;
ylabel('NO INFO port');
hold on;
fill([bins, fliplr(bins)], [mean(a.randDwellInfoBig(idx1,:))-sem(a.randDwellInfoBig(idx1,:)), fliplr(mean(a.randDwellInfoBig(idx1,:))+sem(a.randDwellInfoBig(idx1,:)))],'g','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.randDwellInfoSmall(idx1,:))-sem(a.randDwellInfoSmall(idx1,:)), fliplr(mean(a.randDwellInfoSmall(idx1,:))+sem(a.randDwellInfoSmall(idx1,:)))],'m','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.randDwellInfo(idx1,:))-sem(a.randDwellInfo(idx1,:)), fliplr(mean(a.randDwellInfo(idx1,:))+sem(a.randDwellInfo(idx1,:)))],purple,'EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.randDwellRandBig(idx1,:))-sem(a.randDwellRandBig(idx1,:)), fliplr(mean(a.randDwellRandBig(idx1,:))+sem(a.randDwellRandBig(idx1,:)))],'b','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.randDwellRandSmall(idx1,:))-sem(a.randDwellRandSmall(idx1,:)), fliplr(mean(a.randDwellRandSmall(idx1,:))+sem(a.randDwellRandSmall(idx1,:)))],'c','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.randDwellRand(idx1,:))-sem(a.randDwellRand(idx1,:)), fliplr(mean(a.randDwellRand(idx1,:))+sem(a.randDwellRand(idx1,:)))],orange,'EdgeColor','none','FaceAlpha', 0.1);
plot(bins,mean(a.randDwellInfoBig(idx1,:)),'Color','g','LineWidth',0.5);
plot(bins,mean(a.randDwellInfoSmall(idx1,:)),'Color','m','LineWidth',0.5); 
plot(bins,mean(a.randDwellRandBig(idx1,:)),'Color','b','LineWidth',0.5);
plot(bins,mean(a.randDwellRandSmall(idx1,:)),'Color','c','LineWidth',0.5);
plot(bins,mean(a.randDwellInfo(idx1,:)),'Color',purple,'LineWidth',0.5);
plot(bins,mean(a.randDwellRand(idx1,:)),'Color',orange,'LineWidth',0.5);
ax.YTick = [0 0.25 0.50 0.75 1];
ax.YLim = [-0.1 1.1];
ax.XLim = [-1 12];
plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
xlabel('Time relative to go cue (s)');

ax = nsubplot(3,2,1,2);
title([label2 ' Probability in port by trial type, pre-reversal choice days']);
ax.FontSize = 8;
ylabel('CENTER port');
hold on;
fill([bins, fliplr(bins)], [mean(a.centerDwellChoice(idx2,:))-sem(a.centerDwellChoice(idx2,:)), fliplr(mean(a.centerDwellChoice(idx2,:))+sem(a.centerDwellChoice(idx2,:)))],grey,'EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.centerDwellChoice(idx2,:))-sem(a.centerDwellInfo(idx2,:)), fliplr(mean(a.centerDwellInfo(idx2,:))+sem(a.centerDwellInfo(idx2,:)))],purple,'EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.centerDwellChoice(idx2,:))-sem(a.centerDwellRand(idx2,:)), fliplr(mean(a.centerDwellRand(idx2,:))+sem(a.centerDwellRand(idx2,:)))],orange,'EdgeColor','none','FaceAlpha', 0.1);
plot(bins,mean(a.centerDwellChoice(idx2,:)),'Color',grey,'LineWidth',0.5);
plot(bins,mean(a.centerDwellInfo(idx2,:)),'Color',purple,'LineWidth',0.5);
plot(bins,mean(a.centerDwellRand(idx2,:)),'Color',orange,'LineWidth',0.5);    
ax.YTick = [0 0.25 0.50 0.75 1];
ax.YLim = [-0.1 1.1];
plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
ax.XLim = [-1 12];
%     xlabel('Time relative to go cue (s)');

ax = nsubplot(3,2,2,2);
ax.FontSize = 8;
ylabel('INFO port');
hold on;
fill([bins, fliplr(bins)], [mean(a.infoDwellInfoBig(idx2,:))-sem(a.infoDwellInfoBig(idx2,:)), fliplr(mean(a.infoDwellInfoBig(idx2,:))+sem(a.infoDwellInfoBig(idx2,:)))],'g','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.infoDwellInfoSmall(idx2,:))-sem(a.infoDwellInfoSmall(idx2,:)), fliplr(mean(a.infoDwellInfoSmall(idx2,:))+sem(a.infoDwellInfoSmall(idx2,:)))],'m','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.infoDwellInfo(idx2,:))-sem(a.infoDwellInfo(idx2,:)), fliplr(mean(a.infoDwellInfo(idx2,:))+sem(a.infoDwellInfo(idx2,:)))],purple,'EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.infoDwellRandBig(idx2,:))-sem(a.infoDwellRandBig(idx2,:)), fliplr(mean(a.infoDwellRandBig(idx2,:))+sem(a.infoDwellRandBig(idx2,:)))],'b','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.infoDwellRandSmall(idx2,:))-sem(a.infoDwellRandSmall(idx2,:)), fliplr(mean(a.infoDwellRandSmall(idx2,:))+sem(a.infoDwellRandSmall(idx2,:)))],'c','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.infoDwellRand(idx2,:))-sem(a.infoDwellRand(idx2,:)), fliplr(mean(a.infoDwellRand(idx2,:))+sem(a.infoDwellRand(idx2,:)))],orange,'EdgeColor','none','FaceAlpha', 0.1);
plot(bins,mean(a.infoDwellInfoBig(idx2,:)),'Color','g','LineWidth',0.5);
plot(bins,mean(a.infoDwellInfoSmall(idx2,:)),'Color','m','LineWidth',0.5); 
plot(bins,mean(a.infoDwellRandBig(idx2,:)),'Color','b','LineWidth',0.5);
plot(bins,mean(a.infoDwellRandSmall(idx2,:)),'Color','c','LineWidth',0.5);
plot(bins,mean(a.infoDwellInfo(idx2,:)),'Color',purple,'LineWidth',0.5);
plot(bins,mean(a.infoDwellRand(idx2,:)),'Color',orange,'LineWidth',0.5);
ax.YTick = [0 0.25 0.50 0.75 1];
ax.YLim = [-0.1 1.1];
plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
ax.XLim = [-1 12];
%     xlabel('Time relative to go cue (s)');

ax = nsubplot(3,2,3,2);
ax.FontSize = 8;
ylabel('NO INFO port');
hold on;
fill([bins, fliplr(bins)], [mean(a.randDwellInfoBig(idx2,:))-sem(a.randDwellInfoBig(idx2,:)), fliplr(mean(a.randDwellInfoBig(idx2,:))+sem(a.randDwellInfoBig(idx2,:)))],'g','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.randDwellInfoSmall(idx2,:))-sem(a.randDwellInfoSmall(idx2,:)), fliplr(mean(a.randDwellInfoSmall(idx2,:))+sem(a.randDwellInfoSmall(idx2,:)))],'m','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.randDwellInfo(idx2,:))-sem(a.randDwellInfo(idx2,:)), fliplr(mean(a.randDwellInfo(idx2,:))+sem(a.randDwellInfo(idx2,:)))],purple,'EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.randDwellRandBig(idx2,:))-sem(a.randDwellRandBig(idx2,:)), fliplr(mean(a.randDwellRandBig(idx2,:))+sem(a.randDwellRandBig(idx2,:)))],'b','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.randDwellRandSmall(idx2,:))-sem(a.randDwellRandSmall(idx2,:)), fliplr(mean(a.randDwellRandSmall(idx2,:))+sem(a.randDwellRandSmall(idx2,:)))],'c','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.randDwellRand(idx2,:))-sem(a.randDwellRand(idx2,:)), fliplr(mean(a.randDwellRand(idx2,:))+sem(a.randDwellRand(idx2,:)))],orange,'EdgeColor','none','FaceAlpha', 0.1);
plot(bins,mean(a.randDwellInfoBig(idx2,:)),'Color','g','LineWidth',0.5);
plot(bins,mean(a.randDwellInfoSmall(idx2,:)),'Color','m','LineWidth',0.5); 
plot(bins,mean(a.randDwellRandBig(idx2,:)),'Color','b','LineWidth',0.5);
plot(bins,mean(a.randDwellRandSmall(idx2,:)),'Color','c','LineWidth',0.5);
plot(bins,mean(a.randDwellInfo(idx2,:)),'Color',purple,'LineWidth',0.5);
plot(bins,mean(a.randDwellRand(idx2,:)),'Color',orange,'LineWidth',0.5);
ax.YTick = [0 0.25 0.50 0.75 1];
ax.YLim = [-0.1 1.1];
ax.XLim = [-1 12];
plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
xlabel('Time relative to go cue (s)');

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
h_for_legend=[];
hold on;
for i = 1:7
    h_for_legend(end+1) = plot(ha,0,0, 'color',CCtype(i,:),'linewidth',2);
end
hold off;

leg = legend(h_for_legend,a.typeLabels,'Location','south','Orientation','horizontal');
legend('boxoff');
%     text(0.51,0.98,[a.mouseList{m} ' Choice of Side'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');        

saveas(fig,fullfile(pathname,[label{1} '_preRevPortDwell']),'pdf');

%% PORT DWELL PROBABILITY BY MOUSE PRE-REVERSAL

for m = 1:a.mouseCt
    
    figure();
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0.5 0.5 10 7];
    set(fig,'renderer','painters');
    set(fig,'PaperOrientation','landscape');

    ax = nsubplot(3,2,1,1);
    title([a.mouseList{m} ' Probability in port by trial type, pre-reversal choice days']);
    ax.FontSize = 8;
    ylabel('CENTER port');
    hold on;
    plot(bins,a.centerDwellChoice(m,:),'Color',grey,'LineWidth',0.5);
    plot(bins,a.centerDwellInfo(m,:),'Color',purple,'LineWidth',0.5);
    plot(bins,a.centerDwellRand(m,:),'Color',orange,'LineWidth',0.5);    
    ax.YTick = [0 0.25 0.50 0.75 1];
    ax.YLim = [-0.1 1.1];
    plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
    plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
    plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
    ax.XLim = [-1 12];
    %     xlabel('Time relative to go cue (s)');

    ax = nsubplot(3,2,2,1);
    ax.FontSize = 8;
    ylabel('INFO port');
    hold on;
    plot(bins,a.infoDwellInfoBig(m,:),'Color','g','LineWidth',0.5);
    plot(bins,a.infoDwellInfoSmall(m,:),'Color','m','LineWidth',0.5); 
    plot(bins,a.infoDwellRandBig(m,:),'Color','b','LineWidth',0.5);
    plot(bins,a.infoDwellRandSmall(m,:),'Color','c','LineWidth',0.5);
    plot(bins,a.infoDwellInfo(m,:),'Color',purple,'LineWidth',0.5);
    plot(bins,a.infoDwellRand(m,:),'Color',orange,'LineWidth',0.5);
    ax.YTick = [0 0.25 0.50 0.75 1];
    ax.YLim = [-0.1 1.1];
    plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
    plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
    plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
    ax.XLim = [-1 12];
    %     xlabel('Time relative to go cue (s)');

    ax = nsubplot(3,2,3,1);
    ax.FontSize = 8;
    ylabel('NO INFO port');
    hold on;
    plot(bins,a.randDwellInfoBig(m,:),'Color','g','LineWidth',0.5);
    plot(bins,a.randDwellInfoSmall(m,:),'Color','m','LineWidth',0.5); 
    plot(bins,a.randDwellRandBig(m,:),'Color','b','LineWidth',0.5);
    plot(bins,a.randDwellRandSmall(m,:),'Color','c','LineWidth',0.5);
    plot(bins,a.randDwellInfo(m,:),'Color',purple,'LineWidth',0.5);
    plot(bins,a.randDwellRand(m,:),'Color',orange,'LineWidth',0.5);
    ax.YTick = [0 0.25 0.50 0.75 1];
    ax.YLim = [-0.1 1.1];
    ax.XLim = [-1 12];
    plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
    plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
    plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
    xlabel('Time relative to go cue (s)');
    
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    h_for_legend=[];
    hold on;
    for i = 1:7
        h_for_legend(end+1) = plot(ha,0,0, 'color',CCtype(i,:),'linewidth',2);
    end
    hold off;

    leg = legend(h_for_legend,a.typeLabels,'Location','south','Orientation','horizontal');
    legend('boxoff');
%     text(0.51,0.98,[a.mouseList{m} ' Choice of Side'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');        
      
    saveas(fig,fullfile(pathname,['preRevPortDwell_' a.mouseList{m}]),'pdf');
%     close;
end

%% PRE-REVERSAL REACTION TIME
% 
% fig=figure();
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% ax = nsubplot(1,2,1,1);
% ax.FontSize = 8;
% ax.YTick = [0 0.500 1.000 1.500];
% ax.YLim = [0 1.5];
% ax.XLim = [0.5 3.5];
% 
% for mm = 1:numel(idx1)
%     m=idx1(mm);
%     plot([1 3],[mean(a.preRevRxnInfoForced(m,1)) mean(a.preRevRxnRandForced(m,1))],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
% end
% plot(1,mean(a.preRevRxnMean(idx1,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
% errorbar(1,mean(a.preRevRxnMean(idx1,1),'omitnan'),sem(a.preRevRxnMean(idx1,1)),'Color','k','LineWidth',2,'CapSize',100);
% plot(3,mean(a.preRevRxnMean(idx1,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
% errorbar(3,mean(a.preRevRxnMean(idx1,2),'omitnan'),sem(a.preRevRxnMean(idx1,2)),'Color','k','LineWidth',2,'CapSize',100);
% xticks([1 3]);
% xticklabels({'Info','No Info'});
% ylabel('Reaction time in pre-reversal choice sessions');
% p1=signrank(a.preRevRxnMean(idx1,1),a.preRevRxnMean(idx1,2));
% title([label1 ' sign rank p = ' num2str(p1)])
% 
% ax = nsubplot(1,2,1,2);
% ax.FontSize = 8;
% ax.YTick = [0 0.500 1.000 1.500];
% ax.YLim = [0 1.5];
% ax.XLim = [0.5 3.5];
% 
% for mm = 1:numel(idx2)
%     m=idx2(mm);
%     plot([1 3],[mean(a.preRevRxnInfoForced(m,1)) mean(a.preRevRxnRandForced(m,1))],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
% end
% plot(1,mean(a.preRevRxnMean(idx2,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
% errorbar(1,mean(a.preRevRxnMean(idx2,1),'omitnan'),sem(a.preRevRxnMean(idx2,1)),'Color','k','LineWidth',2,'CapSize',100);
% plot(3,mean(a.preRevRxnMean(idx2,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
% errorbar(3,mean(a.preRevRxnMean(idx2,2),'omitnan'),sem(a.preRevRxnMean(idx2,2)),'Color','k','LineWidth',2,'CapSize',100);
% xticks([1 3]);
% xticklabels({'Info','No Info'});
% ylabel('Reaction time in pre-reversal choice sessions');
% p2=signrank(a.preRevRxnMean(idx2,1),a.preRevRxnMean(idx2,2));
% title([label2 ' sign rank p = ' num2str(p2)])
% 
% saveas(fig,fullfile(pathname,[label{1} '_preRevReactionTime']),'pdf');

%% PRE-REVERSAL REACTION TIME WITH CHOICE

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
% ax.YTick = [0 0.500 1.000 1.500];
% ax.YLim = [0 1.5];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx1)
    m=idx1(mm);
    plot([1 3],[a.preRevRxnMean(m,1) a.preRevRxnMean(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],[a.preRevRxnMean(m,3) a.preRevRxnMean(m,4)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);

end
plot(1,mean(a.preRevRxnMean(idx1,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(1,mean(a.preRevRxnMean(idx1,1),'omitnan'),sem(a.preRevRxnMean(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.preRevRxnMean(idx1,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(3,mean(a.preRevRxnMean(idx1,2),'omitnan'),sem(a.preRevRxnMean(idx1,2)),'Color','k','LineWidth',2,'CapSize',25);
plot(5,mean(a.preRevRxnMean(idx1,3),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(5,mean(a.preRevRxnMean(idx1,3),'omitnan'),sem(a.preRevRxnMean(idx1,3)),'Color','k','LineWidth',2,'CapSize',25);
plot(7,mean(a.preRevRxnMean(idx1,4),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(7,mean(a.preRevRxnMean(idx1,4),'omitnan'),sem(a.preRevRxnMean(idx1,4)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info Forced','No Info Forced','Info Choice','No Info Choice'});
ylabel('Reaction time in pre-reversal choice sessions');
p1=signrank(a.preRevRxnMean(idx1,1),a.preRevRxnMean(idx1,2));
p2=signrank(a.preRevRxnMean(idx1,3),a.preRevRxnMean(idx1,4));
p3=signrank(a.preRevRxnMean(idx1,1),a.preRevRxnMean(idx1,3));
p4=signrank(a.preRevRxnMean(idx1,2),a.preRevRxnMean(idx1,4));
title([label1 ' sign rank forced p = ' num2str(p1) ' sign rank choice p = '...
    num2str(p2) ' info p=' num2str(p3) ' rand p=' num2str(p4)])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
% ax.YTick = [0 0.500 1.000 1.500];
% ax.YLim = [0 1.5];
ax.XLim = [0.5 7.5];
for mm = 1:numel(idx2)
    m=idx2(mm);
    plot([1 3],[a.preRevRxnMean(m,1) a.preRevRxnMean(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],[a.preRevRxnMean(m,3) a.preRevRxnMean(m,4)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);

end
plot(1,mean(a.preRevRxnMean(idx2,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(1,mean(a.preRevRxnMean(idx2,1),'omitnan'),sem(a.preRevRxnMean(idx2,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.preRevRxnMean(idx2,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(3,mean(a.preRevRxnMean(idx2,2),'omitnan'),sem(a.preRevRxnMean(idx2,2)),'Color','k','LineWidth',2,'CapSize',25);
plot(5,mean(a.preRevRxnMean(idx2,3),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(5,mean(a.preRevRxnMean(idx2,3),'omitnan'),sem(a.preRevRxnMean(idx2,3)),'Color','k','LineWidth',2,'CapSize',25);
plot(7,mean(a.preRevRxnMean(idx2,4),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(7,mean(a.preRevRxnMean(idx2,4),'omitnan'),sem(a.preRevRxnMean(idx2,4)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info Forced','No Info Forced','Info Choice','No Info Choice'});
ylabel('Reaction time in pre-reversal choice sessions');
p1=signrank(a.preRevRxnMean(idx2,1),a.preRevRxnMean(idx2,2));
p2=signrank(a.preRevRxnMean(idx2,3),a.preRevRxnMean(idx2,4));
p3=signrank(a.preRevRxnMean(idx2,1),a.preRevRxnMean(idx2,3));
p4=signrank(a.preRevRxnMean(idx2,2),a.preRevRxnMean(idx2,4));
title([label2 ' sign rank forced p = ' num2str(p1) ' sign rank choice p = '...
    num2str(p2) ' info p=' num2str(p3) ' rand p=' num2str(p4)])

saveas(fig,fullfile(pathname,[label{1} '_preRevReactionTimeChoice']),'pdf');


%% Reaction Violin

for i=1:4
    a.preRevRxnAll{1,i}=vertcat(a.preRevRxn{idx1,i});
    a.preRevRxnAll{2,i}=vertcat(a.preRevRxn{idx2,i});
end

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

nsubplot(1,2,1,1);
for i=1:4
    v1=Violin(a.preRevRxnAll{1,i},i);
    v1.ViolinColor=[0.4 0.4 0.4]; 
    v1.EdgeColor='none'; 
    v1.BoxColor='none';
    v1.ScatterPlot.MarkerFaceColor='k';
    v1.ScatterPlot.MarkerFaceAlpha=1;
    v1.ShowMean=true; 
end
xticks(1:4);
xticklabels({'Info Forced','Rand Forced','Info Choice','Rand Choice'});
ylim([0 5])
ylabel('Rxn (s)');
title([label1 ' info p ' num2str(ranksum(a.preRevRxnAll{1,1},a.preRevRxnAll{1,2})) ' choice p ' num2str(ranksum(a.preRevRxnAll{1,3},a.preRevRxnAll{1,4}))])

nsubplot(1,2,1,2);
for i=1:4
    v1=Violin(a.preRevRxnAll{2,i},i);
    v1.ViolinColor=[0.4 0.4 0.4]; 
    v1.EdgeColor='none'; 
    v1.BoxColor='none';
    v1.ScatterPlot.MarkerFaceColor='k';
    v1.ScatterPlot.MarkerFaceAlpha=1;
    v1.ShowMean=true; 
end
xticks(1:4);
xticklabels({'Info Forced','Rand Forced','Info Choice','Rand Choice'});
ylim([0 5])
ylabel('Rxn (s)');
title([label2 ' info p ' num2str(ranksum(a.preRevRxnAll{2,1},a.preRevRxnAll{2,2})) ' choice p ' num2str(ranksum(a.preRevRxnAll{2,3},a.preRevRxnAll{2,4}))])

saveas(fig,fullfile(pathname,[label{1} '_preRevRxnMeanAllViolin']),'pdf');

%% PRE-REVERSE RXN AND PREF CORRELATION

a.preRevRxnIdx=(a.preRevRxnMean(:,4)-a.preRevRxnMean(:,3))./(a.preRevRxnMean(:,3)+a.preRevRxnMean(:,4));
% a.preRevRxnIdx=(a.preRevRxnMean(:,4)-a.preRevRxnMean(:,3));

choiceIdx=find(~isnan(a.preRevRxnIdx));
[rho1,pval1]=corr(a.preRevRxnIdx(intersect(choiceIdx,idx1)),a.pref(intersect(choiceIdx,idx1),1),'Type','Spearman','Tail','right');
% [rho1,pval1]=corr(a.preRevRxnIdx(intersect(choiceIdx,idx1)),a.pref(intersect(choiceIdx,idx1),1),'Type','Spearman');
[rho2,pval2]=corr(a.preRevRxnIdx(intersect(choiceIdx,idx2)),a.pref(intersect(choiceIdx,idx2),1),'Type','Spearman','Tail','right');

fig = figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.XLim = [-1 1];
ax.YLim = [0 1];
scatter(a.preRevRxnIdx(intersect(choiceIdx,idx1)),a.pref(intersect(choiceIdx,idx1),1),100,'k','filled')
plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
plot([0 0],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
ylabel({'% info choice', 'pre-reversal'}); %{'Info choice', 'probability'}
xlabel({'Choice Trial Reaction Time Index', '(No Info Choice - Info Choice)/(Info + No Info Choice), pre-reversal'});
title('Choice Reaction Time Index vs Info preference');
hold off;
axis square;
title([label1 ' corr=' num2str(rho1) ' p=' num2str(pval1)]);


a.preRevRxnIdx=(a.preRevRxnMean(:,2)-a.preRevRxnMean(:,1))./(a.preRevRxnMean(:,1)+a.preRevRxnMean(:,2));
% a.preRevRxnIdx=(a.preRevRxnMean(:,4)-a.preRevRxnMean(:,3));

choiceIdx=find(~isnan(a.preRevRxnIdx));
[rho1,pval1]=corr(a.preRevRxnIdx(intersect(choiceIdx,idx1)),a.pref(intersect(choiceIdx,idx1),1),'Type','Spearman','Tail','right');
% [rho1,pval1]=corr(a.preRevRxnIdx(intersect(choiceIdx,idx1)),a.pref(intersect(choiceIdx,idx1),1),'Type','Spearman');
[rho2,pval2]=corr(a.preRevRxnIdx(intersect(choiceIdx,idx2)),a.pref(intersect(choiceIdx,idx2),1),'Type','Spearman','Tail','right');

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.XLim = [-1 1];
ax.YLim = [0 1];
scatter(a.preRevRxnIdx(intersect(choiceIdx,idx1)),a.pref(intersect(choiceIdx,idx1),1),100,'k','filled')
plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
plot([0 0],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
ylabel({'% info choice', 'pre-reversal'}); %{'Info choice', 'probability'}
xlabel({'Forced Trial Reaction Time Index', '(No Info Forced - Info Forced)/(Info + No Info Forced), pre-reversal'});
title('Forced Reaction Time Index vs Info preference');
hold off;
axis square;
title([label2 ' corr=' num2str(rho1) ' p=' num2str(pval1)]);

saveas(fig,fullfile(pathname,[label{1} '_RxnvsPref']),'pdf');

%% PRE-REVERSE DWELL AND PREF CORRELATION

a.preRevDwellIdx=(a.infoDwell(idx1,1)-a.randDwell(idx1,1))./(a.infoDwell(idx1,1)+a.randDwell(idx1,1));
% a.preRevRxnIdx=(a.preRevRxnMean(:,4)-a.preRevRxnMean(:,3));

% [rho1,pval1]=corr(a.preRevDwellIdx,a.pref(idx1),'Type','Spearman','Tail','right');
[rho1,pval1]=corr(a.preRevDwellIdx,a.pref(idx1),'Type','Spearman','Tail','left');
% [rho2,pval2]=corr(a.preRevRxnIdx(intersect(choiceIdx,idx2)),a.pref(intersect(choiceIdx,idx2),1),'Type','Spearman','Tail','right');

fig = figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.XLim = [-1 1];
ax.YLim = [0 1];
scatter(a.preRevDwellIdx,a.pref(idx1),100,'k','filled')
plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
plot([0 0],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
ylabel({'% info choice', 'pre-reversal'}); %{'Info choice', 'probability'}
xlabel({'Dwell Time Index', '(Info - No Info)/(Info + No Info), pre-reversal'});
title('Dwell Time Index vs Info preference');
hold off;
axis square;
title([label1 ' corr=' num2str(rho1) ' p=' num2str(pval1)]);


% a.preRevRxnIdx=(a.preRevRxnMean(:,2)-a.preRevRxnMean(:,1))./(a.preRevRxnMean(:,1)+a.preRevRxnMean(:,2));
% % a.preRevRxnIdx=(a.preRevRxnMean(:,4)-a.preRevRxnMean(:,3));
% 
% choiceIdx=find(~isnan(a.preRevRxnIdx));
% [rho1,pval1]=corr(a.preRevRxnIdx(intersect(choiceIdx,idx1)),a.pref(intersect(choiceIdx,idx1),1),'Type','Spearman','Tail','right');
% [rho2,pval2]=corr(a.preRevRxnIdx(intersect(choiceIdx,idx2)),a.pref(intersect(choiceIdx,idx2),1),'Type','Spearman','Tail','right');
% 
% ax = nsubplot(1,2,1,2);
% ax.FontSize = 8;
% ax.XLim = [-1 1];
% ax.YLim = [0 1];
% scatter(a.preRevRxnIdx(intersect(choiceIdx,idx1)),a.pref(intersect(choiceIdx,idx1),1),100,'k','filled')
% plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% plot([0 0],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% ylabel({'% info choice', 'pre-reversal'}); %{'Info choice', 'probability'}
% xlabel({'Forced Trial Reaction Time Index', '(No Info Forced - Info Forced)/(Info + No Info Forced), pre-reversal'});
% title('Forced Reaction Time Index vs Info preference');
% hold off;
% axis square;
% title([label1 ' corr=' num2str(rho1) ' p=' num2str(pval1)]);

saveas(fig,fullfile(pathname,[label{1} '_DwellvsPref']),'pdf');


%% PRE-REVERSE LICKS AND PREF CORRELATION

% lickIdx1=find(~isnan(a.earlyLickIdx));
% lickIdx2=find(~isnan(a.anticipatoryInfoLicksIndex));

a.earlyLickIdx=(a.preRevEarlyLicksMean(idx1,2)-a.preRevEarlyLicksMean(idx1,1))./(a.preRevEarlyLicksMean(idx1,1)+a.preRevEarlyLicksMean(idx1,2));
a.anticipatoryInfoLicksIndex=(a.preRevLicksMean(idx1,1)-a.preRevLicksMean(idx1,4))./(a.preRevLicksMean(idx1,1)+a.preRevLicksMean(idx1,4));

lickIdx1=find(~isnan(a.earlyLickIdx));
lickIdx2=find(~isnan(a.anticipatoryInfoLicksIndex));
[rho1,pval1]=corr(a.earlyLickIdx(intersect(lickIdx1,idx1)),a.pref(intersect(lickIdx1,idx1),1),'Type','Spearman','Tail','right');
[rho2,pval2]=corr(a.anticipatoryInfoLicksIndex(intersect(lickIdx2,idx1)),a.pref(intersect(lickIdx2,idx1),1),'Type','Spearman','Tail','right');

fig = figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.XLim = [-1 1];
ax.YLim = [0 1];
scatter(a.earlyLickIdx(intersect(lickIdx1,idx1)),a.pref(intersect(lickIdx1,idx1),1),100,'k','filled')
plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
plot([0 0],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
ylabel({'% info choice', 'pre-reversal'}); %{'Info choice', 'probability'}
xlabel({'No Info vs Info Pre-Odor Lick Index', 'pre-reversal'});
title('Pre-Odor Lick Index vs Info preference');
hold off;
axis square;
title([label1 ' corr=' num2str(rho1) ' p=' num2str(pval1)]);

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.XLim = [-1 1];
ax.YLim = [0 1];
scatter(a.anticipatoryInfoLicksIndex(intersect(lickIdx2,idx1)),a.pref(intersect(lickIdx2,idx1),1),100,'k','filled')
plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
plot([0 0],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
ylabel({'% info choice', 'pre-reversal'}); %{'Info choice', 'probability'}
xlabel({'Info Water vs Info No Water Anticipatory Lick Index','pre-reversal'});
title('Water Anticipatory Lick Index vs Info preference');
hold off;
axis square;
title([label1 ' corr=' num2str(rho2) ' p=' num2str(pval2)]);



saveas(fig,fullfile(pathname,[label{1} '_LicksvsPref']),'pdf');


%% PRE-REVERSAL REWARD RATE CORRECT

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.YTick = [0 10 20 30 40];
ax.YLim = [0 40];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx1)
    m=idx1(mm);
    plot([1 3],[a.preRevRewardRateCorrMean(m,1) a.preRevRewardRateCorrMean(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.preRevRewardRateCorrMean(idx1,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.preRevRewardRateCorrMean(idx1,1),'omitnan'),sem(a.preRevRewardRateCorrMean(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.preRevRewardRateCorrMean(idx1,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.preRevRewardRateCorrMean(idx1,2),'omitnan'),sem(a.preRevRewardRateCorrMean(idx1,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('Reward rate on correct trials pre-reversal');
p1=signrank(a.preRevRewardRateCorrMean(idx1,1),a.preRevRewardRateCorrMean(idx1,2));
title([label1 ' p = ' num2str(p1)])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
% ax.YTick = [0 20 40];
% ax.YLim = [0 40];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx2)
    m=idx2(mm);
    plot([1 3],[a.preRevRewardRateCorrMean(m,1) a.preRevRewardRateCorrMean(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.preRevRewardRateCorrMean(idx2,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.preRevRewardRateCorrMean(idx2,1),'omitnan'),sem(a.preRevRewardRateCorrMean(idx2,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.preRevRewardRateCorrMean(idx2,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.preRevRewardRateCorrMean(idx2,2),'omitnan'),sem(a.preRevRewardRateCorrMean(idx2,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('Reward rate on correct trials pre-reversal');
p2=signrank(a.preRevRewardRateCorrMean(idx2,1),a.preRevRewardRateCorrMean(idx2,2));
title([label2 ' p = ' num2str(p2)])

saveas(fig,fullfile(pathname,[label{1} '_preRevRewardRateCorr']),'pdf');

%% PRE-REVERSAL REWARD RATE ALL

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.YTick = [0 20 40];
% ax.YLim = [0 40];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx1)
    m=idx1(mm);
    plot([1 3],[a.preRevRewardRateMean(m,1) a.preRevRewardRateMean(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.preRevRewardRateMean(idx1,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.preRevRewardRateMean(idx1,1),'omitnan'),sem(a.preRevRewardRateMean(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.preRevRewardRateMean(idx1,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.preRevRewardRateMean(idx1,2),'omitnan'),sem(a.preRevRewardRateMean(idx1,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('Reward rate on all trials pre-reversal');
p1=signrank(a.preRevRewardRateMean(idx1,1),a.preRevRewardRateMean(idx1,2));
title([label1 ' p = ' num2str(p1)])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.YTick = [0 20 40];
% ax.YLim = [0 40];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx2)
    m=idx2(mm);
    plot([1 3],[a.preRevRewardRateMean(m,1) a.preRevRewardRateMean(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.preRevRewardRateMean(idx2,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.preRevRewardRateMean(idx2,1),'omitnan'),sem(a.preRevRewardRateMean(idx2,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.preRevRewardRateMean(idx2,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.preRevRewardRateMean(idx2,2),'omitnan'),sem(a.preRevRewardRateMean(idx2,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('Reward rate on all trials pre-reversal');
p2=signrank(a.preRevRewardRateMean(idx2,1),a.preRevRewardRateMean(idx2,2));
title([label2 ' p = ' num2str(p2)])

saveas(fig,fullfile(pathname,[label{1} '_preRevRewardRate']),'pdf');

%% PRE-REVERSAL PERCENT CORRECT

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.YTick = [0 0.25 0.5 0.75 1];
ax.YLim = [0 1];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx1)
    m=idx1(mm);
    plot([1 3],[a.preRevCorrectMean(m,1) a.preRevCorrectMean(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.preRevCorrectMean(idx1,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.preRevCorrectMean(idx1,1),'omitnan'),sem(a.preRevCorrectMean(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.preRevCorrectMean(idx1,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.preRevCorrectMean(idx1,2),'omitnan'),sem(a.preRevCorrectMean(idx1,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('% correct pre-reversal');
p1=signrank(a.preRevCorrectMean(idx1,1),a.preRevCorrectMean(idx1,2));
title([label1 ' p = ' num2str(p1)])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.YTick = [0 0.25 0.5 0.75 1];
ax.YLim = [0 1];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx2)
    m=idx2(mm);
    plot([1 3],[a.preRevCorrectMean(m,1) a.preRevCorrectMean(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.preRevCorrectMean(idx2,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.preRevCorrectMean(idx2,1),'omitnan'),sem(a.preRevCorrectMean(idx2,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.preRevCorrectMean(idx2,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.preRevCorrectMean(idx2,2),'omitnan'),sem(a.preRevCorrectMean(idx2,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('% correct pre-reversal');
p2=signrank(a.preRevCorrectMean(idx2,1),a.preRevCorrectMean(idx2,2));
title([label2 ' p = ' num2str(p2)])

saveas(fig,fullfile(pathname,[label{1} '_preRevCorrect']),'pdf');

%% PRE-REVERSAL SATIETY

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.YTick = [0 0.25 0.5 0.75 1];
ax.YLim = [0 1];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],[a.preRevPrefEarlyMean(m,1) a.preRevPrefLateMean(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.preRevPrefEarlyMean(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.preRevPrefEarlyMean(idx1rev,1),'omitnan'),sem(a.preRevPrefEarlyMean(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.preRevPrefLateMean(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.preRevPrefLateMean(idx1rev,1),'omitnan'),sem(a.preRevPrefLateMean(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Early trials','Late trials'});
ylabel('% Info choice pre-reversal');
p1=signrank(a.preRevPrefEarlyMean(idx1rev,1),a.preRevPrefLateMean(idx1rev,1));
title([label1 ' sign rank p = ' num2str(p1)])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.YTick = [0 0.25 0.5 0.75 1];
ax.YLim = [0 1];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx2rev)
    m=idx2rev(mm);
    plot([1 3],[a.preRevPrefEarlyMean(m,1) a.preRevPrefLateMean(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.preRevPrefEarlyMean(idx2rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.preRevPrefEarlyMean(idx2rev,1),'omitnan'),sem(a.preRevPrefEarlyMean(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.preRevPrefLateMean(idx2rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.preRevPrefLateMean(idx2rev,1),'omitnan'),sem(a.preRevPrefLateMean(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Early trial','Late trials'});
ylabel('% choose Info pre-reversal');
p2=signrank(a.preRevPrefEarlyMean(idx2rev,1),a.preRevPrefLateMean(idx2,1));
title([label2 ' sign rank p = ' num2str(p2)])

saveas(fig,fullfile(pathname,[label{1} '_preRevSatiety']),'pdf');

%% PRE-REVERSAL LICKS
  
fig = figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

licklabels={'Info Water', 'No Info C','No Info D','Info No Water'};

ax = nsubplot(2,2,1,1);
ax.FontSize = 8;
xticks([1 3]);
ax.XLim = [0.5 3.5];
ax.YLim = [0 1.5];
hold on;
for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],[mean(a.preRevEarlyLicksMean(m,1)) mean(a.preRevEarlyLicksMean(m,2))],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.preRevEarlyLicksMean(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(1,mean(a.preRevEarlyLicksMean(idx1rev,1),'omitnan'),sem(a.preRevEarlyLicksMean(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.preRevEarlyLicksMean(idx1rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(3,mean(a.preRevEarlyLicksMean(idx1rev,2),'omitnan'),sem(a.preRevEarlyLicksMean(idx1rev,2)),'Color','k','LineWidth',2,'CapSize',25);
xticklabels({'Info','No Info'});
ylabel('Mean Pre-Odor Licks');
p1=signrank(a.preRevEarlyLicksMean(idx1rev,1),a.preRevEarlyLicksMean(idx1,2));
title([label1 ' signrank p = ' num2str(p1)]);


[a.preRevLickspvalOG, tbl, stats] = friedman(a.preRevLicksMean(idx1,:), 1,'off');
a.preRevLicksCompOG = multcompare(stats,'Display','off');


ax = nsubplot(2,2,2,1);
ax.FontSize = 8;
xticks([1 3]);
ax.XLim = [0.5 7.5];
% ax.YLim = [0 1.5];
hold on;
for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1:2:7],a.preRevLicksMean(m,:),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
xs=[1:2:7]';
for n=1:4
plot(xs(n),mean(a.preRevLicksMean(idx1rev,n),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(xs(n),mean(a.preRevLicksMean(idx1rev,n),'omitnan'),sem(a.preRevLicksMean(idx1rev,n)),'Color','k','LineWidth',2,'CapSize',25);
end
xticklabels(licklabels);
ylabel('Mean Pre-Outcome Licks');
title([label1 ' Friedman p = ' num2str(a.preRevLickspval)]);
hold off;

saveas(fig,fullfile(pathname,[label{1} '_preRevLicks']),'pdf');

%%
% 
% fig = figure();
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% licklabels={'Info Water', 'No Info C','No Info D','Info No Water'};
% 
% ax = nsubplot(1,2,1,1);
% ax.FontSize = 8;
% xticks([1 3]);
% xticklabels({'Info','No Info'});
% ax.XLim = [0.5 3.5];
% ax.YLim = [0 1.5];
% hold on;
% v1=Violin(a.preRevEarlyLicksMean(idx1rev,1),1);
% v2=Violin(a.preRevEarlyLicksMean(idx1rev,2),2);
% v1.ViolinColor='b'; 
% v1.EdgeColor='none'; 
% v1.BoxColor='none';
% v1.ScatterPlot.MarkerFaceColor='k';
% v1.ScatterPlot.MarkerFaceAlpha=1;
% v1.ShowMean=true;
% v2.ViolinColor='r'; 
% v2.EdgeColor='none'; 
% v2.BoxColor='none';
% v2.ScatterPlot.MarkerFaceColor='k';
% v2.ScatterPlot.MarkerFaceAlpha=1;
% v2.ShowMean=true;
% ax.XTickLabel={'Info','No Info'};
% ylabel('Mean Pre-Odor Licks');
% [h,p]=ttest(a.preRevEarlyLicksMean(idx1rev,1),a.preRevEarlyLicksMean(idx1rev,2));
% title([label1 ' Pre-reversal p = ' num2str(a.preRevEarlyLicksP1(1,1))])
% hold off;
% 
% ax = nsubplot(1,2,1,2);
% ax.FontSize = 8;
% ax.XLim = [0.5 4.5];
% ax.XTick = [1 2 3 4];
% %     ax.YLim = [0 1.5];
% hold on;
% v1=Violin(a.preRevLicksMean(idx1rev,1),1);
% v2=Violin(a.preRevLicksMean(idx1rev,2),2);
% v3=Violin(a.preRevLicksMean(idx1rev,3),3);
% v4=Violin(a.preRevLicksMean(idx1rev,4),4);
% v1.ViolinColor='g'; 
% v1.EdgeColor='none'; 
% v1.BoxColor='none';
% v1.ScatterPlot.MarkerFaceColor='k';
% v1.ScatterPlot.MarkerFaceAlpha=1;
% v1.ShowMean=true;
% v2.ViolinColor=cornflower; 
% v2.EdgeColor='none'; 
% v2.BoxColor='none';
% v2.ScatterPlot.MarkerFaceColor='k';
% v2.ScatterPlot.MarkerFaceAlpha=1;
% v2.ShowMean=true;
% v3.ViolinColor=cornflower; 
% v3.EdgeColor='none'; 
% v3.BoxColor='none';
% v3.ScatterPlot.MarkerFaceColor='k';
% v3.ScatterPlot.MarkerFaceAlpha=1;
% v3.ShowMean=true;
% v4.ViolinColor='m'; 
% v4.EdgeColor='none'; 
% v4.BoxColor='none';
% v4.ScatterPlot.MarkerFaceColor='k';
% v4.ScatterPlot.MarkerFaceAlpha=1;
% v4.ShowMean=true;   
% ax.XTickLabel=licklabels;
% ylabel('Mean Pre-Outcome Licks');
% title([label1 ' Pre-reversal ANOVA p = ' num2str(a.preRevLicksP1(2,1))])
% hold off;    
% 
% saveas(fig,fullfile(pathname,[label{1} '_preRevLicks']),'pdf');

%% PORT PROBABILITY PRE-REVERSAL (All trials not just 3 days)
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% % ok=abs(a.reverse)==1 & a.trialTypes == 5 & a.correct==1 & ismember(a.mouseNums,idx1);
% ok=a.reverse==1 & a.trialTypes == 5 & a.correct==1 & ismember(a.mouseNums,idx1);
% 
% ax = nsubplot(3,2,1,1);
% title([label1 ' Probability in port by trial type, pre-reversal choice days']);
% ax.FontSize = 8;
% ylabel('CENTER port');
% plot(bins,mean(a.Port2(a.trialType==1 & ok,:)),'Color',grey,'LineWidth',2);
% plot(bins,mean(a.Port2(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.Port2(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);    
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% ax.XLim = [-1 12];
% %     xlabel('Time relative to go cue (s)');
% 
% ax = nsubplot(3,2,2,1);
% ax.FontSize = 8;
% ylabel('INFO port');
% plot(bins,mean(a.infoPort(a.infoBig==1 & ok,:)),'Color','g','LineWidth',2);
% plot(bins,mean(a.infoPort(a.infoSmall==1 & ok,:)),'Color','m','LineWidth',2); 
% plot(bins,mean(a.infoPort(a.randBig==1 & ok,:)),'Color','b','LineWidth',2);
% plot(bins,mean(a.infoPort(a.randSmall==1 & ok,:)),'Color','c','LineWidth',2);
% plot(bins,mean(a.infoPort(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.infoPort(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% ax.XLim = [-1 12];
% %     xlabel('Time relative to go cue (s)');
% 
% ax = nsubplot(3,2,3,1);
% ax.FontSize = 8;
% ylabel('NO INFO port');
% plot(bins,mean(a.randPort(a.infoBig==1 & ok,:)),'Color','g','LineWidth',2);
% plot(bins,mean(a.randPort(a.infoSmall==1 & ok,:)),'Color','m','LineWidth',2); 
% plot(bins,mean(a.randPort(a.randBig==1 & ok,:)),'Color','b','LineWidth',2);
% plot(bins,mean(a.randPort(a.randSmall==1 & ok,:)),'Color','c','LineWidth',2);
% plot(bins,mean(a.randPort(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.randPort(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% ax.XLim = [-1 12];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% xlabel('Time relative to go cue (s)');
% 
% ok=abs(a.reverse)==1 & a.trialTypes == 5 & a.correct==1 & ismember(a.mouseNums,idx2);
% 
% ax = nsubplot(3,2,1,2);
% title([label2 ' Probability in port by trial type, pre-reverse choice days']);
% ax.FontSize = 8;
% ylabel('CENTER port');
% plot(bins,mean(a.Port2(a.trialType==1 & ok,:)),'Color',grey,'LineWidth',2);
% plot(bins,mean(a.Port2(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.Port2(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);    
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% ax.XLim = [-1 12];
% %     xlabel('Time relative to go cue (s)');
% 
% ax = nsubplot(3,2,2,2);
% ax.FontSize = 8;
% ylabel('INFO port');
% plot(bins,mean(a.infoPort(a.infoBig==1 & ok,:)),'Color','g','LineWidth',2);
% plot(bins,mean(a.infoPort(a.infoSmall==1 & ok,:)),'Color','m','LineWidth',2); 
% plot(bins,mean(a.infoPort(a.randBig==1 & ok,:)),'Color','b','LineWidth',2);
% plot(bins,mean(a.infoPort(a.randSmall==1 & ok,:)),'Color','c','LineWidth',2);
% plot(bins,mean(a.infoPort(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.infoPort(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% ax.XLim = [-1 12];
% %     xlabel('Time relative to go cue (s)');
% 
% ax = nsubplot(3,2,3,2);
% ax.FontSize = 8;
% ylabel('NO INFO port');
% plot(bins,mean(a.randPort(a.infoBig==1 & ok,:)),'Color','g','LineWidth',2);
% plot(bins,mean(a.randPort(a.infoSmall==1 & ok,:)),'Color','m','LineWidth',2); 
% plot(bins,mean(a.randPort(a.randBig==1 & ok,:)),'Color','b','LineWidth',2);
% plot(bins,mean(a.randPort(a.randSmall==1 & ok,:)),'Color','c','LineWidth',2);
% plot(bins,mean(a.randPort(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.randPort(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% ax.XLim = [-1 12];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% xlabel('Time relative to go cue (s)');
% 
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% h_for_legend=[];
% hold on;
% for i = 1:7
%     h_for_legend(end+1) = plot(ha,0,0, 'color',CCtype(i,:),'linewidth',2);
% end
% hold off;
% 
% leg = legend(h_for_legend,a.typeLabels,'Location','south','Orientation','horizontal');
% legend('boxoff');
% %     text(0.51,0.98,[a.mouseList{m} ' Choice of Side'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');        
% 
% saveas(fig,fullfile(pathname,[label1 '_PrerevPortDwell']),'pdf');    
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %% ACROSS REVERSAL, 2 days before/2 days after
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% REVERSAL REACTION TIME

% can't do because NaN-->do multiple sign ranks
% [a.reversalRxnpval, tbl, stats] = friedman(a.reversalRxn, 1,'off');
% a.reversalRxnsComp = multcompare(stats,'Display','off');

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.YTick = [0 0.500 1.000 1.500];
ax.YLim = [0 2];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],a.reversalRxn(m,(1:2)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],a.reversalRxn(m,(3:4)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot([1 3 5 7],mean(a.reversalRxn(idx1rev,:),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar([1 3 5 7],mean(a.reversalRxn(idx1rev,:),'omitnan'),sem(a.reversalRxn(idx1rev,:)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info Pre','No Info Pre','Info Post','No Info Post'});
ylabel('Reaction time across reversal choice sessions');
p1=signrank(a.reversalRxn(idx1rev,1),a.reversalRxn(idx1,2));
p2=signrank(a.reversalRxn(idx1rev,3),a.reversalRxn(idx1,4));
title([label1 ' pre p = ' num2str(p1) ' post p = ' num2str(p2)])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.YTick = [0 0.500 1.000 1.500];
ax.YLim = [0 2];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx2rev)
    m=idx2rev(mm);
    plot([1 3],a.reversalRxn(m,(1:2)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],a.reversalRxn(m,(3:4)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot([1 3 5 7],mean(a.reversalRxn(idx2rev,:),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar([1 3 5 7],mean(a.reversalRxn(idx2rev,:),'omitnan'),sem(a.reversalRxn(idx2rev,:)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info Pre','No Info Pre','Info Post','No Info Post'});
ylabel('Reaction time across reversal choice sessions');
p1=signrank(a.reversalRxn(idx2rev,1),a.reversalRxn(idx2,2));
p2=signrank(a.reversalRxn(idx2rev,3),a.reversalRxn(idx2,4));
title([label2 ' pre p = ' num2str(p1) ' post p = ' num2str(p2)])

saveas(fig,fullfile(pathname,[label{1} '_ReversalReactionTime']),'pdf');

%% REVERSAL REWARD RATE CORR

% can't do because NaN-->do multiple sign ranks
% [a.reversalRewardRateCorrpval, tbl, stats] = friedman(a.reversalRewardRateCorr, 1,'off');
% a.reversalRewardRateCorrComp = multcompare(stats,'Display','off');

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
% ax.YTick = [0 0.500 1.000 1.500];
% ax.YLim = [0 2];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],a.reversalRewardRateCorr(m,(1:2)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],a.reversalRewardRateCorr(m,(3:4)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot([1 3 5 7],mean(a.reversalRewardRateCorr(idx1rev,:),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar([1 3 5 7],mean(a.reversalRewardRateCorr(idx1rev,:),'omitnan'),sem(a.reversalRewardRateCorr(idx1rev,:)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info Pre','No Info Pre','Info Post','No Info Post'});
ylabel('Reward rate on correct trials across reversal choice sessions (mL/min)');
p1=signrank(a.reversalRewardRateCorr(idx1rev,1),a.reversalRewardRateCorr(idx1,2));
p2=signrank(a.reversalRewardRateCorr(idx1rev,3),a.reversalRewardRateCorr(idx1,4));
title([label1 ' pre p = ' num2str(p1) ' post p = ' num2str(p2)])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
% ax.YTick = [0 0.500 1.000 1.500];
% ax.YLim = [0 2];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx2rev)
    m=idx2rev(mm);
    plot([1 3],a.reversalRewardRateCorr(m,(1:2)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],a.reversalRewardRateCorr(m,(3:4)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot([1 3 5 7],mean(a.reversalRewardRateCorr(idx2rev,:),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar([1 3 5 7],mean(a.reversalRewardRateCorr(idx2rev,:),'omitnan'),sem(a.reversalRewardRateCorr(idx2rev,:)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info Pre','No Info Pre','Info Post','No Info Post'});
ylabel('Reward rate on correct trials across reversal choice sessions (mL/min)');
p1=signrank(a.reversalRewardRateCorr(idx2rev,1),a.reversalRewardRateCorr(idx2,2));
p2=signrank(a.reversalRewardRateCorr(idx2rev,3),a.reversalRewardRateCorr(idx2,4));
title([label2 ' pre p = ' num2str(p1) ' post p = ' num2str(p2)])

saveas(fig,fullfile(pathname,[label{1} '_ReversalRewardRateCorr']),'pdf');

%% REVERSAL REWARD RATE

[a.reversalRewardRatepval1, tbl, stats] = friedman(a.reversalRewardRate(idx1,:), 1,'off');
a.reversalRewardRateComp1 = multcompare(stats,'Display','off');
[a.reversalRewardRatepval2, tbl, stats] = friedman(a.reversalRewardRate(idx2,:), 1,'off');
a.reversalRewardRateComp2 = multcompare(stats,'Display','off');

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
% ax.YTick = [0 0.500 1.000 1.500];
% ax.YLim = [0 2];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],a.reversalRewardRate(m,(1:2)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],a.reversalRewardRate(m,(3:4)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot([1 3 5 7],mean(a.reversalRewardRate(idx1rev,:),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar([1 3 5 7],mean(a.reversalRewardRate(idx1rev,:),'omitnan'),sem(a.reversalRewardRate(idx1rev,:)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info Pre','No Info Pre','Info Post','No Info Post'});
ylabel('Reward rate across reversal choice sessions (mL/min)');
p1=signrank(a.reversalRewardRate(idx1rev,1),a.reversalRewardRate(idx1,2));
p2=signrank(a.reversalRewardRate(idx1rev,3),a.reversalRewardRate(idx1,4));
title([label1 ' pre p = ' num2str(p1) ' post p = ' num2str(p2) ' friedman p=' num2str(a.reversalRewardRatepval1)])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
% ax.YTick = [0 0.500 1.000 1.500];
% ax.YLim = [0 2];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx2rev)
    m=idx2rev(mm);
    plot([1 3],a.reversalRewardRate(m,(1:2)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],a.reversalRewardRate(m,(3:4)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot([1 3 5 7],mean(a.reversalRewardRate(idx2rev,:),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar([1 3 5 7],mean(a.reversalRewardRate(idx2rev,:),'omitnan'),sem(a.reversalRewardRate(idx2rev,:)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info Pre','No Info Pre','Info Post','No Info Post'});
ylabel('Reward rate across reversal choice sessions (mL/min)');
p1=signrank(a.reversalRewardRate(idx2rev,1),a.reversalRewardRate(idx2,2));
p2=signrank(a.reversalRewardRate(idx2rev,3),a.reversalRewardRate(idx2,4));
title([label2 ' pre p = ' num2str(p1) ' post p = ' num2str(p2) ' friedman p=' num2str(a.reversalRewardRatepval2)])

saveas(fig,fullfile(pathname,[label{1} '_ReversalRewardRate']),'pdf');

%% REVERSAL PERCENT CORRECT

[a.reversalCorrectpval1, tbl, stats] = friedman(a.reversalCorrect(idx1rev,:), 1,'off');
a.reversalCorrectComp1 = multcompare(stats,'Display','off');
[a.reversalCorrectpval2, tbl, stats] = friedman(a.reversalCorrect(idx2rev,:), 1,'off');
a.reversalCorrectComp2 = multcompare(stats,'Display','off');

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.YTick = [0 0.500 1.000];
ax.YLim = [0 1];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],a.reversalCorrect(m,(1:2)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],a.reversalCorrect(m,(3:4)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot([1 3 5 7],mean(a.reversalCorrect(idx1rev,:),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar([1 3 5 7],mean(a.reversalCorrect(idx1rev,:),'omitnan'),sem(a.reversalCorrect(idx1rev,:)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info Pre','No Info Pre','Info Post','No Info Post'});
ylabel('% correct across reversal');
p1=signrank(a.reversalCorrect(idx1rev,1),a.reversalCorrect(idx1,2));
p2=signrank(a.reversalCorrect(idx1rev,3),a.reversalCorrect(idx1,4));
title([label1 ' pre p = ' num2str(p1) ' post p = ' num2str(p2) ' friedman p=' num2str(a.reversalCorrectpval1)])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.YTick = [0 0.25 0.5 0.75 1];
ax.YLim = [0 1];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx2rev)
    m=idx2rev(mm);
    plot([1 3],a.reversalCorrect(m,(1:2)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],a.reversalCorrect(m,(3:4)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot([1 3 5 7],mean(a.reversalCorrect(idx2rev,:),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar([1 3 5 7],mean(a.reversalCorrect(idx2rev,:),'omitnan'),sem(a.reversalCorrect(idx2rev,:)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info Pre','No Info Pre','Info Post','No Info Post'});
ylabel('% correct across reversal');
p1=signrank(a.reversalCorrect(idx2rev,1),a.reversalCorrect(idx2,2));
p2=signrank(a.reversalCorrect(idx2rev,3),a.reversalCorrect(idx2,4));
title([label2 ' pre p = ' num2str(p1) ' post p = ' num2str(p2) ' friedman p=' num2str(a.reversalCorrectpval2)])

saveas(fig,fullfile(pathname,[label{1} '_ReversalCorrect']),'pdf');

%% REVERSAL SATIETY

[a.reversalSatietypval1, tbl, stats] = friedman([a.reversalPrefEarly(idx1,:) a.reversalPrefLate(idx1,:)], 1,'off');
a.reversalSatiety1Comp = multcompare(stats,'Display','off');
[a.reversalSatietypval2, tbl, stats] = friedman([a.reversalPrefEarly(idx2,:) a.reversalPrefLate(idx2,:)], 1,'off');
a.reversalSatiety2Comp = multcompare(stats,'Display','off');

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.YTick = [0 0.25 0.5 0.75 1];
ax.YLim = [0 1];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],[a.reversalPrefEarly(m,1) a.reversalPrefLate(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],[a.reversalPrefEarly(m,2) a.reversalPrefLate(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.reversalPrefEarly(idx1rev,1),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar(1,mean(a.reversalPrefEarly(idx1rev,1),'omitnan'),sem(a.reversalPrefEarly(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.reversalPrefLate(idx1rev,1),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar(3,mean(a.reversalPrefLate(idx1rev,1),'omitnan'),sem(a.reversalPrefLate(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(5,mean(a.reversalPrefEarly(idx1rev,2),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar(5,mean(a.reversalPrefEarly(idx1rev,2),'omitnan'),sem(a.reversalPrefEarly(idx1rev,2)),'Color','k','LineWidth',2,'CapSize',25);
plot(7,mean(a.reversalPrefLate(idx1rev,2),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar(7,mean(a.reversalPrefLate(idx1rev,2),'omitnan'),sem(a.reversalPrefLate(idx1rev,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Early Pre','Late Pre','Early Post','Late Post'});
ylabel('Preference early and late in sessions across reversal choice sessions');
p1=signrank(a.reversalPrefEarly(idx1rev,1),a.reversalPrefLate(idx1,1));
p2=signrank(a.reversalPrefEarly(idx1rev,2),a.reversalPrefLate(idx1,2));
title([label1 ' pre p = ' num2str(p1) ' post p = ' num2str(p2) ' friedman p=' num2str(a.reversalSatietypval1)]);

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.YTick = [0 0.25 0.5 0.75 1];
ax.YLim = [0 1];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx2rev)
    m=idx2rev(mm);
    plot([1 3],[a.reversalPrefEarly(m,1) a.reversalPrefLate(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],[a.reversalPrefEarly(m,2) a.reversalPrefLate(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.reversalPrefEarly(idx2rev,1),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar(1,mean(a.reversalPrefEarly(idx2rev,1),'omitnan'),sem(a.reversalPrefEarly(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.reversalPrefLate(idx2rev,1),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar(3,mean(a.reversalPrefLate(idx2rev,1),'omitnan'),sem(a.reversalPrefLate(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(5,mean(a.reversalPrefEarly(idx2rev,2),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar(5,mean(a.reversalPrefEarly(idx2rev,2),'omitnan'),sem(a.reversalPrefEarly(idx2rev,2)),'Color','k','LineWidth',2,'CapSize',25);
plot(7,mean(a.reversalPrefLate(idx2rev,2),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar(7,mean(a.reversalPrefLate(idx2rev,2),'omitnan'),sem(a.reversalPrefLate(idx2rev,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Early Pre','Late Pre','Early Post','Late Post'});
ylabel('Preference early and late in sessions across reversal choice sessions');
p1=signrank(a.reversalPrefEarly(idx2rev,1),a.reversalPrefLate(idx2,1));
p2=signrank(a.reversalPrefEarly(idx2rev,2),a.reversalPrefLate(idx2,2));
title([label2 ' pre p = ' num2str(p1) ' post p = ' num2str(p2) ' friedman p=' num2str(a.reversalSatietypval2)]);

saveas(fig,fullfile(pathname,[label{1} '_ReversalSatiety']),'pdf');

%% REVERSAL LICKS


[a.reversalEarlyLickspval, tbl, stats] = friedman(a.reversalEarlyLicks, 1,'off');
a.reversalEarlyLicksComp = multcompare(stats,'Display','off');

[a.reversalLickspval, tbl, stats] = friedman(a.reversalLicks, 1,'off');
a.reversalLicksComp = multcompare(stats,'Display','off');

licklabelsrev={'Info Water', 'No Info C','No Info D','Info No Water' 'Info Water', 'No Info C','No Info D','Info No Water'};


fig = figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(2,2,1,1);
ax.FontSize = 8;
xticks([1 3]);
ax.XLim = [0.5 7.5];
% ax.YLim = [0 1.5];
hold on;
for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3 5 7],a.reversalEarlyLicks(m,:),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot([1 3 5 7],mean(a.reversalEarlyLicks(idx1rev,:),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar([1 3 5 7],mean(a.reversalEarlyLicks(idx1rev,:),'omitnan'),sem(a.reversalEarlyLicks(idx1rev,:)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info Pre','No Info Pre','Info Post','No Info Post'});
ylabel('Mean Pre-Odor Licks');
p1=signrank(a.reversalEarlyLicks(idx1rev,1),a.reversalEarlyLicks(idx1,2));
p2=signrank(a.reversalEarlyLicks(idx1rev,3),a.reversalEarlyLicks(idx1,4));
title([label1 ' pre p = ' num2str(p1) ' post p = ' num2str(p2) ' friedman p=' num2str(a.reversalEarlyLickspval)])

ax = nsubplot(2,2,2,1);
ax.FontSize = 8;
xticks([1 3]);
% ax.XLim = [0.5 7.5];
% ax.YLim = [0 1.5];
hold on;
for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1:2:7],a.reversalLicks(m,1:4),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([9:2:15],a.reversalLicks(m,5:8),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
xs=[1:2:15]';
for n=1:4
plot(xs(n),mean(a.reversalLicks(idx1rev,n),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(xs(n),mean(a.reversalLicks(idx1rev,n),'omitnan'),sem(a.reversalLicks(idx1rev,n)),'Color','k','LineWidth',2,'CapSize',25);
end
for n=5:8
plot(xs(n),mean(a.reversalLicks(idx1rev,n),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(xs(n),mean(a.reversalLicks(idx1rev,n),'omitnan'),sem(a.reversalLicks(idx1rev,n)),'Color','k','LineWidth',2,'CapSize',25);
end
xticklabels(licklabels);
ylabel('Mean Pre-Outcome Licks');
title([label1 ' Friedman p = ' num2str(a.reversalLickspval)]);
hold off;

saveas(fig,fullfile(pathname,[label{1} '_ReversalLicks']),'pdf');
   
% fig = figure();
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% licklabels={'Info Water', 'No Info C','No Info D','Info No Water'};
% 
% ax = nsubplot(1,2,1,1);
% ax.FontSize = 8;
% ax.XLim = [0.5 2.5];
% ax.XTick = [1 2];
% ax.YLim = [0 1.5];
% hold on;
% v1=Violin(a.reversalEarlyLicksMean(idx1rev,1),1);
% v2=Violin(a.reversalEarlyLicksMean(idx1rev,2),2);
% v1.ViolinColor='b'; 
% v1.EdgeColor='none'; 
% v1.BoxColor='none';
% v1.ScatterPlot.MarkerFaceColor='k';
% v1.ScatterPlot.MarkerFaceAlpha=1;
% v1.ShowMean=true;
% v2.ViolinColor='r'; 
% v2.EdgeColor='none'; 
% v2.BoxColor='none';
% v2.ScatterPlot.MarkerFaceColor='k';
% v2.ScatterPlot.MarkerFaceAlpha=1;
% v2.ShowMean=true;
% ax.XTickLabel={'Info','No Info'};
% ylabel('Mean Pre-Odor Licks');
% title([label1 ' Reversal p = ' num2str(a.reversalEarlyLicksP1(1,1))])
% hold off;
% 
% ax = nsubplot(1,2,1,2);
% ax.FontSize = 8;
% ax.XLim = [0.5 4.5];
% ax.XTick = [1 2 3 4];
% %     ax.YLim = [0 1.5];
% hold on;
% v1=Violin(a.reversalLicksMean(idx1rev,1),1);
% v2=Violin(a.reversalLicksMean(idx1rev,2),2);
% v3=Violin(a.reversalLicksMean(idx1rev,3),3);
% v4=Violin(a.reversalLicksMean(idx1rev,4),4);
% v1.ViolinColor='g'; 
% v1.EdgeColor='none'; 
% v1.BoxColor='none';
% v1.ScatterPlot.MarkerFaceColor='k';
% v1.ScatterPlot.MarkerFaceAlpha=1;
% v1.ShowMean=true;
% v2.ViolinColor=cornflower; 
% v2.EdgeColor='none'; 
% v2.BoxColor='none';
% v2.ScatterPlot.MarkerFaceColor='k';
% v2.ScatterPlot.MarkerFaceAlpha=1;
% v2.ShowMean=true;
% v3.ViolinColor=cornflower; 
% v3.EdgeColor='none'; 
% v3.BoxColor='none';
% v3.ScatterPlot.MarkerFaceColor='k';
% v3.ScatterPlot.MarkerFaceAlpha=1;
% v3.ShowMean=true;
% v4.ViolinColor='m'; 
% v4.EdgeColor='none'; 
% v4.BoxColor='none';
% v4.ScatterPlot.MarkerFaceColor='k';
% v4.ScatterPlot.MarkerFaceAlpha=1;
% v4.ShowMean=true;   
% ax.XTickLabel=licklabels;
% ylabel('Mean Pre-Outcome Licks');
% title([label1 ' Reversal ANOVA p = ' num2str(a.reversalLicksP1(1,1))])
% hold off;    
% 
% saveas(fig,fullfile(pathname,[label1 '_ReversalLicks']),'pdf');

%% PORT PROBABILITY ACROSS REVERSAL all, not just days

% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
%     ok=abs(a.reverse)==1 & a.trialTypes == 5 & a.correct==1 & ismember(a.mouseNums,idx1);
% % ok=a.reverse==1 & a.trialTypes == 5 & a.correct==1 & ismember(a.mouseNums,idx1);
% 
% ax = nsubplot(3,2,1,1);
% title([label1 ' Probability in port by trial type, reversal days']);
% ax.FontSize = 8;
% ylabel('CENTER port');
% plot(bins,mean(a.Port2(a.trialType==1 & ok,:)),'Color',grey,'LineWidth',2);
% plot(bins,mean(a.Port2(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.Port2(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);    
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% ax.XLim = [-1 12];
% %     xlabel('Time relative to go cue (s)');
% 
% ax = nsubplot(3,2,2,1);
% ax.FontSize = 8;
% ylabel('INFO port');
% plot(bins,mean(a.infoPort(a.infoBig==1 & ok,:)),'Color','g','LineWidth',2);
% plot(bins,mean(a.infoPort(a.infoSmall==1 & ok,:)),'Color','m','LineWidth',2); 
% plot(bins,mean(a.infoPort(a.randBig==1 & ok,:)),'Color','b','LineWidth',2);
% plot(bins,mean(a.infoPort(a.randSmall==1 & ok,:)),'Color','c','LineWidth',2);
% plot(bins,mean(a.infoPort(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.infoPort(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% ax.XLim = [-1 12];
% %     xlabel('Time relative to go cue (s)');
% 
% ax = nsubplot(3,2,3,1);
% ax.FontSize = 8;
% ylabel('NO INFO port');
% plot(bins,mean(a.randPort(a.infoBig==1 & ok,:)),'Color','g','LineWidth',2);
% plot(bins,mean(a.randPort(a.infoSmall==1 & ok,:)),'Color','m','LineWidth',2); 
% plot(bins,mean(a.randPort(a.randBig==1 & ok,:)),'Color','b','LineWidth',2);
% plot(bins,mean(a.randPort(a.randSmall==1 & ok,:)),'Color','c','LineWidth',2);
% plot(bins,mean(a.randPort(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.randPort(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% ax.XLim = [-1 12];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% xlabel('Time relative to go cue (s)');
% 
% ok=abs(a.reverse)==1 & a.trialTypes == 5 & a.correct==1 & ismember(a.mouseNums,idx2);
% 
% ax = nsubplot(3,2,1,2);
% title([label2 ' Probability in port by trial type, pre-reverse choice days']);
% ax.FontSize = 8;
% ylabel('CENTER port');
% plot(bins,mean(a.Port2(a.trialType==1 & ok,:)),'Color',grey,'LineWidth',2);
% plot(bins,mean(a.Port2(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.Port2(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);    
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% ax.XLim = [-1 12];
% %     xlabel('Time relative to go cue (s)');
% 
% ax = nsubplot(3,2,2,2);
% ax.FontSize = 8;
% ylabel('INFO port');
% plot(bins,mean(a.infoPort(a.infoBig==1 & ok,:)),'Color','g','LineWidth',2);
% plot(bins,mean(a.infoPort(a.infoSmall==1 & ok,:)),'Color','m','LineWidth',2); 
% plot(bins,mean(a.infoPort(a.randBig==1 & ok,:)),'Color','b','LineWidth',2);
% plot(bins,mean(a.infoPort(a.randSmall==1 & ok,:)),'Color','c','LineWidth',2);
% plot(bins,mean(a.infoPort(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.infoPort(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% ax.XLim = [-1 12];
% %     xlabel('Time relative to go cue (s)');
% 
% ax = nsubplot(3,2,3,2);
% ax.FontSize = 8;
% ylabel('NO INFO port');
% plot(bins,mean(a.randPort(a.infoBig==1 & ok,:)),'Color','g','LineWidth',2);
% plot(bins,mean(a.randPort(a.infoSmall==1 & ok,:)),'Color','m','LineWidth',2); 
% plot(bins,mean(a.randPort(a.randBig==1 & ok,:)),'Color','b','LineWidth',2);
% plot(bins,mean(a.randPort(a.randSmall==1 & ok,:)),'Color','c','LineWidth',2);
% plot(bins,mean(a.randPort(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.randPort(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% ax.XLim = [-1 12];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% xlabel('Time relative to go cue (s)');
% 
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% h_for_legend=[];
% hold on;
% for i = 1:7
%     h_for_legend(end+1) = plot(ha,0,0, 'color',CCtype(i,:),'linewidth',2);
% end
% hold off;
% 
% leg = legend(h_for_legend,a.typeLabels,'Location','south','Orientation','horizontal');
% legend('boxoff');
% %     text(0.51,0.98,[a.mouseList{m} ' Choice of Side'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');        
% 
% saveas(fig,fullfile(pathname,[label1 '_ReversalPortDwell']),'pdf');
%     close;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TRAINING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TRAINING 1 REWARD RATE CORRECT

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.YTick = [0 20 40 60];
ax.YLim = [0 60];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],[a.training1MeanRewardRateCorr(m,1) a.training1MeanRewardRateCorr(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.training1MeanRewardRateCorr(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.training1MeanRewardRateCorr(idx1rev,1),'omitnan'),sem(a.training1MeanRewardRateCorr(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.training1MeanRewardRateCorr(idx1rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.training1MeanRewardRateCorr(idx1rev,2),'omitnan'),sem(a.training1MeanRewardRateCorr(idx1rev,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('Reward rate during training, correct trials, after info');
p1=signrank(a.training1MeanRewardRateCorr(idx1rev,1),a.training1MeanRewardRateCorr(idx1,2));
title([label1 ' signrank p = ' num2str(p1)])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.YTick = [0 20 40 60];
ax.YLim = [0 60];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx2rev)
    m=idx2rev(mm);
    plot([1 3],[a.training1MeanRewardRateCorr(m,1) a.training1MeanRewardRateCorr(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.training1MeanRewardRateCorr(idx2rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.training1MeanRewardRateCorr(idx2rev,1),'omitnan'),sem(a.training1MeanRewardRateCorr(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.training1MeanRewardRateCorr(idx2rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.training1MeanRewardRateCorr(idx2rev,2),'omitnan'),sem(a.training1MeanRewardRateCorr(idx2rev,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('Reward rate during training, correct trials, after info');
p2=signrank(a.training1MeanRewardRateCorr(idx2rev,1),a.training1MeanRewardRateCorr(idx2,2));
title([label2 ' signrank p = ' num2str(p2)])

saveas(fig,fullfile(pathname,[label{1} '_Training1RewardRateCorr']),'pdf');

%% TRAINING 2 REWARD RATE CORRECT

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.YTick = [0 20 40 60];
ax.YLim = [0 60];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],[a.training2MeanRewardRateCorr(m,1) a.training2MeanRewardRateCorr(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.training2MeanRewardRateCorr(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.training2MeanRewardRateCorr(idx1rev,1),'omitnan'),sem(a.training2MeanRewardRateCorr(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.training2MeanRewardRateCorr(idx1rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.training2MeanRewardRateCorr(idx1rev,2),'omitnan'),sem(a.training2MeanRewardRateCorr(idx1rev,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('Reward rate during training, correct trials, before info');
p1=signrank(a.training2MeanRewardRateCorr(idx1rev,1),a.training2MeanRewardRateCorr(idx1,2));
title([label1 ' sign rank p = ' num2str(p1)])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.YTick = [0 20 40 60];
ax.YLim = [0 60];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx2rev)
    m=idx2rev(mm);
    plot([1 3],[a.training2MeanRewardRateCorr(m,1) a.training2MeanRewardRateCorr(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.training2MeanRewardRateCorr(idx2rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.training2MeanRewardRateCorr(idx2rev,1),'omitnan'),sem(a.training2MeanRewardRateCorr(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.training2MeanRewardRateCorr(idx2rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.training2MeanRewardRateCorr(idx2rev,2),'omitnan'),sem(a.training2MeanRewardRateCorr(idx2rev,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('Reward rate during training, correct trials, before info');
p2=signrank(a.training2MeanRewardRateCorr(idx2rev,1),a.training2MeanRewardRateCorr(idx2,2));
title([label2 ' sign rank p = ' num2str(p2)])

saveas(fig,fullfile(pathname,[label{1} '_Training2RewardRateCorr']),'pdf');

%% TRAINING 1 REWARD RATE ALL

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.YTick = [0 20 40 60];
ax.YLim = [0 60];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],[a.training1MeanRewardRate(m,1) a.training1MeanRewardRate(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.training1MeanRewardRate(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.training1MeanRewardRate(idx1rev,1),'omitnan'),sem(a.training1MeanRewardRate(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.training1MeanRewardRate(idx1rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.training1MeanRewardRate(idx1rev,2),'omitnan'),sem(a.training1MeanRewardRate(idx1rev,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('Reward rate during training after info');
p1=signrank(a.training1MeanRewardRate(idx1rev,1),a.training1MeanRewardRate(idx1,2));
title([label1 ' sign rank p = ' num2str(p1)])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.YTick = [0 20 40 60];
ax.YLim = [0 60];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx2rev)
    m=idx2rev(mm);
    plot([1 3],[a.training1MeanRewardRate(m,1) a.training1MeanRewardRate(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.training1MeanRewardRate(idx2rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.training1MeanRewardRate(idx2rev,1),'omitnan'),sem(a.training1MeanRewardRate(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.training1MeanRewardRate(idx2rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.training1MeanRewardRate(idx2rev,2),'omitnan'),sem(a.training1MeanRewardRate(idx2rev,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('Reward rate during training after info');
p2=signrank(a.training1MeanRewardRate(idx2rev,1),a.training1MeanRewardRate(idx2,2));
title([label2 ' sign rank p = ' num2str(p2)])

saveas(fig,fullfile(pathname,[label{1} '_Training1RewardRate']),'pdf');

%% TRAINING 2 REWARD RATE ALL

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.YTick = [0 20 40 60];
ax.YLim = [0 60];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],[a.training2MeanRewardRate(m,1) a.training2MeanRewardRate(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.training2MeanRewardRate(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.training2MeanRewardRate(idx1rev,1),'omitnan'),sem(a.training2MeanRewardRate(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.training2MeanRewardRate(idx1rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.training2MeanRewardRate(idx1rev,2),'omitnan'),sem(a.training2MeanRewardRate(idx1rev,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('Reward rate during training before info');
p1=signrank(a.training2MeanRewardRate(idx1rev,1),a.training2MeanRewardRate(idx1,2));
title([label1 ' sign rank p = ' num2str(p1)])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.YTick = [0 20 40 60];
ax.YLim = [0 60];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx2rev)
    m=idx2rev(mm);
    plot([1 3],[a.training2MeanRewardRate(m,1) a.training2MeanRewardRate(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.training2MeanRewardRate(idx2rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.training2MeanRewardRate(idx2rev,1),'omitnan'),sem(a.training2MeanRewardRate(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.training2MeanRewardRate(idx2rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.training2MeanRewardRate(idx2rev,2),'omitnan'),sem(a.training2MeanRewardRate(idx2rev,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('Reward rate during training before info');
p2=signrank(a.training2MeanRewardRate(idx2rev,1),a.training2MeanRewardRate(idx2,2));
title([label2 ' sign rank p = ' num2str(p2)])

saveas(fig,fullfile(pathname,[label{1} '_Training2RewardRate']),'pdf');

%% TRAINING 1 PERCENT CORRECT

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.YTick = [0 0.25 0.5 0.75 1];
ax.YLim = [0 1];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],[a.training1MeanCorrect(m,1) a.training1MeanCorrect(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.training1MeanCorrect(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.training1MeanCorrect(idx1rev,1),'omitnan'),sem(a.training1MeanCorrect(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.training1MeanCorrect(idx1rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.training1MeanCorrect(idx1rev,2),'omitnan'),sem(a.training1MeanCorrect(idx1rev,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('% correct during training after info');
p1=signrank(a.training1MeanCorrect(idx1rev,1),a.training1MeanCorrect(idx1,2));
title([label1 ' sign rank p = ' num2str(p1)])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.YTick = [0 0.25 0.5 0.75 1];
ax.YLim = [0 1];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx2rev)
    m=idx2rev(mm);
    plot([1 3],[a.training1MeanCorrect(m,1) a.training1MeanCorrect(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.training1MeanCorrect(idx2rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.training1MeanCorrect(idx2rev,1),'omitnan'),sem(a.training1MeanCorrect(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.training1MeanCorrect(idx2rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.training1MeanCorrect(idx2rev,2),'omitnan'),sem(a.training1MeanCorrect(idx2rev,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('% correct during training after info');
p2=signrank(a.training1MeanCorrect(idx2rev,1),a.training1MeanCorrect(idx2,2));
title([label2 ' sign rank p = ' num2str(p2)])

saveas(fig,fullfile(pathname,[label{1} '_training1Correct']),'pdf');

%% TRAINING 2 PERCENT CORRECT

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.YTick = [0 0.25 0.5 0.75 1];
ax.YLim = [0 1];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],[a.training2MeanCorrect(m,1) a.training2MeanCorrect(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.training2MeanCorrect(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.training2MeanCorrect(idx1rev,1),'omitnan'),sem(a.training2MeanCorrect(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.training2MeanCorrect(idx1rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.training2MeanCorrect(idx1rev,2),'omitnan'),sem(a.training2MeanCorrect(idx1rev,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('% correct during training after info');
p1=signrank(a.training2MeanCorrect(idx1rev,1),a.training2MeanCorrect(idx1,2));
title([label1 ' sign rank p = ' num2str(p1)])

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.YTick = [0 0.25 0.5 0.75 1];
ax.YLim = [0 1];
ax.XLim = [0.5 3.5];

for mm = 1:numel(idx2rev)
    m=idx2rev(mm);
    plot([1 3],[a.training2MeanCorrect(m,1) a.training2MeanCorrect(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.training2MeanCorrect(idx2rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.training2MeanCorrect(idx2rev,1),'omitnan'),sem(a.training2MeanCorrect(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.training2MeanCorrect(idx2rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.training2MeanCorrect(idx2rev,2),'omitnan'),sem(a.training2MeanCorrect(idx2rev,2)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3]);
xticklabels({'Info','No Info'});
ylabel('% correct during training after info');
p2=signrank(a.training2MeanCorrect(idx2rev,1),a.training2MeanCorrect(idx2,2));
title([label2 ' sign rank p = ' num2str(p2)])

saveas(fig,fullfile(pathname,[label{1} '_training2Correct']),'pdf');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PREFERENCE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% OVERALL: PRE-REVERSE SORTED PREFERENCE BARS WITH CONFIDENCE INTERVAL (overall.pdf)

    
%     [choiceSort1,sort1]=sort(a.meanChoice(idx1,1));
%     [choiceSort2,sort2]=sort(a.meanChoice(idx2,1));
%     CI1=sort(a.choiceCI(idx1,:));
%     CI2=sort(a.choiceCI(idx2,:));
[choiceSort1,sort1]=sort(a.pref(idx1,3));
[choiceSort2,sort2]=sort(a.pref(idx2,3));
CI1=a.prefCI(idx1(sort1),3:4);
CI2=a.prefCI(idx2(sort2),3:4);    
p1=signrank(choiceSort1*100-50);
p2=signrank(choiceSort2*100-50);
[~,p]=ttest2(choiceSort1,choiceSort2);

fig = figure();    
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.XTick = [1:numel(idx1)+1];
ax.YTick = [0 0.25 0.50 0.75 1];
ax.XTickLabel = [mice1(sort1); 'Mean'];
ax.YLim = [0 1];
for mm = 1:numel(idx1)
    bar(mm,choiceSort1(mm,1),'facecolor',[0.3 0.3 0.3],'edgecolor','none');
    errorbar(mm,choiceSort1(mm,1),choiceSort1(mm,1)-CI1(mm,1),CI1(mm,2)-choiceSort1(mm,1),'LineStyle','none','LineWidth',2,'Color','k');
end
bar(numel(idx1)+1,mean(choiceSort1),'facecolor','k','edgecolor','none');
errorbar(numel(idx1)+1,mean(choiceSort1),mean(choiceSort1) - mean(CI1(:,1)),mean(CI1(:,1)) - mean(choiceSort1),'LineStyle','none','LineWidth',2,'Color','k');
plot([-10000000 1000000],[0.5 0.5],'k','yliminclude','off','xliminclude','off');
text(numel(idx1)+1,mean(choiceSort1,'omitnan')+0.1,['p = ' num2str(p1) ' mean=' num2str(mean(choiceSort1,'omitnan'))])
ylabel('Initial info side preference');
xlabel('Mouse');
title([label1 ' p=' num2str(p)]);
hold off;

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.XTick = [1:numel(idx2)+1];
ax.YTick = [0 0.25 0.50 0.75 1];
ax.XTickLabel = [mice2(sort2); 'Mean'];
ax.YLim = [0 1];
for mm = 1:numel(idx2)
    bar(mm,choiceSort2(mm,1),'facecolor',[0.3 0.3 0.3],'edgecolor','none');
    errorbar(mm,choiceSort2(mm,1),choiceSort2(mm,1)-CI2(mm,1),CI2(mm,2)-choiceSort2(mm,1),'LineStyle','none','LineWidth',2,'Color','k');
end
bar(numel(idx2)+1,mean(choiceSort2),'facecolor','k','edgecolor','none');
errorbar(numel(idx2)+1,mean(choiceSort2),mean(choiceSort2) - mean(CI2(:,1)),mean(CI2(:,1)) - mean(choiceSort2),'LineStyle','none','LineWidth',2,'Color','k');
plot([-10000000 1000000],[0.5 0.5],'k','yliminclude','off','xliminclude','off');
text(numel(idx2)+1,mean(choiceSort2,'omitnan')+0.1,['p = ' num2str(p2)])
ylabel('Initial info side preference');
xlabel('Mouse');
title(label2);
hold off; 

saveas(fig,fullfile(pathname,[label{1} '_Overall']),'pdf');
%     close(fig);

%% OVERALL: PRE-REVERSE FINAL PAPER (overallinitfinal.pdf)

[choiceSort1,sort1]=sort(a.pref(idx1,1));
[choiceSort2,sort2]=sort(a.pref(idx2,1));
CI1=a.prefCI(idx1(sort1),1:2);
CI2=a.prefCI(idx2(sort2),1:2);    
p1=signrank(choiceSort1*100-50);
p2=signrank(choiceSort2*100-50);
[~,p]=ttest2(choiceSort1,choiceSort2);

fig = figure();    
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

% % Set the output size in inches
% fig.Units = 'inches';
% fig.Position = [0 0 6 4];  % [left, bottom, width, height]
% 
% fig.PaperUnits = 'inches';
% fig.PaperSize = [6 4];       % must match Position width/height
% fig.PaperPosition = [0 0 6 4];  % no margins

% test1=test(idx1);
% test2=test1(sort1);

ax = nsubplot(2,1,1,1);
ax.FontSize = 8;
ax.XTick = [1:numel(idx1)+1];
ax.YTick = [0 0.25 0.50 0.75 1];
ax.XTickLabel = [mice1(sort1); 'Mean'];
ax.YLim = [0 1];

errorbar(1:numel(choiceSort1), choiceSort1,...
            choiceSort1 - CI1(:,1), CI1(:,2) - choiceSort1,...
            'o', 'MarkerFaceColor', 'k','MarkerSize',10,'Color', 'k', 'CapSize', 10, 'LineStyle','none','LineWidth',0.5)
errorbar(numel(idx1)+1,mean(choiceSort1),sem(choiceSort1),sem(choiceSort1),...
    'o', 'MarkerFaceColor', 'r', 'MarkerSize',10,'Color', 'r', 'CapSize', 10,'LineStyle','none','LineWidth',0.5);
plot([-10000000 1000000],[0.5 0.5],'k','yliminclude','off','xliminclude','off');
text(numel(idx1)+1,mean(choiceSort1,'omitnan')+0.1,['p = ' num2str(p1) ' mean=' num2str(mean(choiceSort1,'omitnan'))])
ylabel('Initial info side preference');
xlabel('Mouse');
title([label1 ' p=' num2str(p)]);
hold off;

ax = nsubplot(2,1,2,1);
ax.FontSize = 8;
ax.XTick = [1:numel(idx2)+1];
ax.YTick = [0 0.25 0.50 0.75 1];
ax.XTickLabel = [mice2(sort2); 'Mean'];
ax.YLim = [0 1];
errorbar(1:numel(choiceSort2), choiceSort2,...
            choiceSort2 - CI2(:,1), CI2(:,2) - choiceSort2,...
            'o', 'MarkerFaceColor', 'k','MarkerSize',10,'Color', 'k', 'CapSize', 10, 'LineStyle','none','LineWidth',0.5)
errorbar(numel(idx2)+1,mean(choiceSort2),sem(choiceSort2),sem(choiceSort2),...
    'o', 'MarkerFaceColor', 'r', 'MarkerSize',10,'Color', 'r', 'CapSize', 10,'LineStyle','none','LineWidth',0.5);
plot([-10000000 1000000],[0.5 0.5],'k','yliminclude','off','xliminclude','off');
text(numel(idx2)+1,mean(choiceSort2,'omitnan')+0.1,['p = ' num2str(p2) ' mean=' num2str(mean(choiceSort2,'omitnan'))])
ylabel('Initial info side preference');
xlabel('Mouse');
title([label2 ' p=' num2str(p)]);
hold off;

% exportgraphics(fig, fullfile(pathname,[label{1} '_OverallInitFinal.pdf']), 'ContentType', 'vector');

saveas(fig,fullfile(pathname,[label{1} '_OverallInitFinal']),'pdf');

%% OVERALL ***** NEW ********: PRE-REVERSE SORTED PREFERENCE BARS WITH CONFIDENCE INTERVAL (overall.pdf)
    
%     [choiceSort1,sort1]=sort(a.meanChoice(idx1,1));
%     [choiceSort2,sort2]=sort(a.meanChoice(idx2,1));
%     CI1=sort(a.choiceCI(idx1,:));
%     CI2=sort(a.choiceCI(idx2,:));
[choiceSort1,sort1]=sort(a.preRevPrefMean(idx1,1));
[choiceSort2,sort2]=sort(a.preRevPrefMean(idx2,1));
CI1=a.preRevPrefSEM(sort1);
CI2=a.preRevPrefSEM(sort2);    
p1=signrank(choiceSort1*100-50);
p2=signrank(choiceSort2*100-50);
[~,p]=ttest2(choiceSort1,choiceSort2);

fig = figure();    
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.XTick = [1:numel(idx1)+1];
ax.YTick = [0 0.25 0.50 0.75 1];
ax.XTickLabel = [mice1(sort1); 'Mean'];
ax.YLim = [0 1];
for mm = 1:numel(idx1)
    bar(mm,choiceSort1(mm,1),'facecolor',[0.3 0.3 0.3],'edgecolor','none');
    errorbar(mm,choiceSort1(mm,1),CI1(mm,1),'LineStyle','none','LineWidth',2,'Color','k');
end
bar(numel(idx1)+1,mean(choiceSort1),'facecolor','k','edgecolor','none');
errorbar(numel(idx1)+1,mean(choiceSort1),sem(choiceSort1),'LineStyle','none','LineWidth',2,'Color','k');
plot([-10000000 1000000],[0.5 0.5],'k','yliminclude','off','xliminclude','off');
text(numel(idx1)+1,mean(choiceSort1,'omitnan')+0.1,['p = ' num2str(p1)])
ylabel('Initial info side preference');
xlabel('Mouse');
title([label1 ' p=' num2str(p)]);
hold off;

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.XTick = [1:numel(idx2)+1];
ax.YTick = [0 0.25 0.50 0.75 1];
ax.XTickLabel = [mice2(sort2); 'Mean'];
ax.YLim = [0 1];
for mm = 1:numel(idx2)
    bar(mm,choiceSort2(mm,1),'facecolor',[0.3 0.3 0.3],'edgecolor','none');
    errorbar(mm,choiceSort2(mm,1),CI2(mm,1),'LineStyle','none','LineWidth',2,'Color','k');
end
bar(numel(idx2)+1,mean(choiceSort2),'facecolor','k','edgecolor','none');
errorbar(numel(idx2)+1,mean(choiceSort2),sem(choiceSort2),'LineStyle','none','LineWidth',2,'Color','k');
plot([-10000000 1000000],[0.5 0.5],'k','yliminclude','off','xliminclude','off');
text(numel(idx2)+1,mean(choiceSort2,'omitnan')+0.1,['p = ' num2str(p2)])
ylabel('Initial info side preference');
xlabel('Mouse');
title(label2);
hold off; 

saveas(fig,fullfile(pathname,[label{1} '_OverallNew']),'pdf');
%     close(fig);

%% MEAN PREFERENCE CI

fig = figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 6;
ax.YLim = [0 1];
choicetoplot = a.overallChoice(idx1,6);
%     choicetoplot = mean([a.pref(idx1,3) a.pref(idx1,4)],2);
choicetoplot(isnan(choicetoplot))=0.5;
[choicetoplot,idx]=sort(choicetoplot);
semplot=a.overallCI(idx1(idx),:);
p1=signrank(choicetoplot*100-50);
%     bar(choicetoplot,'FaceColor','k');
for mm = 1:numel(idx1)
    bar(mm,choicetoplot(mm,1),'facecolor',[0.3 0.3 0.3],'edgecolor','none');
    errorbar(mm,choicetoplot(mm),choicetoplot(mm)-semplot(mm,1),choicetoplot(mm)-semplot(mm,2),'LineStyle','none','LineWidth',2,'Color','k');
end
bar(numel(idx1)+1,mean(choicetoplot),'FaceColor','r');
errorbar(numel(idx1)+1,mean(choicetoplot),sem(choicetoplot));
% bar(numel(idx1)+1,mean(a.overallChoice(idx1,5),'omitnan'),'FaceColor','r');
% errorbar(numel(idx1)+1,mean(a.overallChoice(idx1,5)),sem(a.overallChoice(idx1,5)));
plot([-10000000 1000000],[0.5 0.5],'Color',grey,'yliminclude','off','xliminclude','off');
xticks(1:numel(idx1)+1);
xticklabels([mice1(idx); 'Mean']);
xlim([0.5 numel(idx1)+1.5]);
ylabel('Mean choice of info side across reversals');
%     yticks([-.5 -.25 0 .25 .5]);
%     yticklabels({'0%','25%','50%','75%','100%'});
text(numel(idx1)+1,nanmean(choicetoplot)+0.1,['Mean = ' num2str(mean(choicetoplot))],'HorizontalAlignment','center');
text(numel(idx1)+1,nanmean(choicetoplot)+0.05,['p = ' num2str(round(p1,4))],'HorizontalAlignment','center');
title(label1)

ax = nsubplot(1,2,1,2);
ax.FontSize = 6;
ax.YLim = [0 1];    
choicetoplot = a.overallChoice(idx2,6);
%     choicetoplot = mean([a.pref(idx2,3) a.pref(idx2,4)],2);
choicetoplot(isnan(choicetoplot))=0.5;
[choicetoplot,idx]=sort(choicetoplot);
semplot=a.overallCI(idx2(idx),:);
p2=signrank(choicetoplot*100-50);
for mm = 1:numel(idx2)
    bar(mm,choicetoplot(mm,1),'facecolor',[0.3 0.3 0.3],'edgecolor','none');
    errorbar(mm,choicetoplot(mm),choicetoplot(mm)-semplot(mm,1),choicetoplot(mm)-semplot(mm,2),'LineStyle','none','LineWidth',2,'Color','k');
end
bar(numel(idx2)+1,mean(a.overallChoice(idx2,5),'omitnan'),'FaceColor','r');
errorbar(numel(idx2)+1,mean(a.overallChoice(idx2,5)),sem(a.overallChoice(idx2,5)));
plot([-10000000 1000000],[0.5 0.5],'Color',grey,'yliminclude','off','xliminclude','off');
xticks(1:numel(idx2)+1);
xticklabels([mice2(idx); 'Mean']);
xlim([0.5 numel(idx2)+1.5]);
ylabel('Mean choice of info side across reversals');
%     yticks([-.5 -.25 0 .25 .5]);
%     yticklabels({'0%','25%','50%','75%','100%'});
text(numel(idx2)+1,nanmean(a.overallChoice(idx2,5))+0.1,['Mean = ' num2str(round(nanmean(a.overallChoice(idx2,5)),4))],'HorizontalAlignment','center');
text(numel(idx2)+1,nanmean(a.overallChoice(idx2,5))+0.05,['p = ' num2str(round(p2,4))],'HorizontalAlignment','center');
title(label2)    

saveas(fig,fullfile(pathname,[label{1} '_OverallIndexCI']),'pdf');

%% FINAL OVERALL REVERSAL PAPER

fig = figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 6;
ax.YLim = [0.25 1];
choicetoplot = a.overallChoice(idx1,6);
%     choicetoplot = mean([a.pref(idx1,3) a.pref(idx1,4)],2);
choicetoplot(isnan(choicetoplot))=0.5;
[choicetoplot,idx]=sort(choicetoplot);
semplot=a.overallCI(idx1(idx),:);
p1=signrank(choicetoplot*100-50);

errorbar(1:numel(choicetoplot), choicetoplot,...
            choicetoplot - semplot(:,1), semplot(:,2) - choicetoplot,...
        'o', 'MarkerFaceColor', 'k', 'Color', 'k', 'CapSize', 6, 'LineWidth', 1.2)
errorbar(numel(idx1)+1,mean(choicetoplot),sem(choicetoplot),'o', 'MarkerFaceColor', 'r', 'Color', 'r', 'CapSize', 6, 'LineWidth', 1.2);
plot([-10000000 1000000],[0.5 0.5],'Color',grey,'yliminclude','off','xliminclude','off');
xticks(1:numel(idx1)+1);
xticklabels([mice1(idx); 'Mean']);
xlim([0.5 numel(idx1)+1.5]);
ylabel('Mean choice of info side across reversals');
%     yticks([-.5 -.25 0 .25 .5]);
%     yticklabels({'0%','25%','50%','75%','100%'});
text(numel(idx1)+1,nanmean(choicetoplot)+0.1,['Mean = ' num2str(mean(choicetoplot))],'HorizontalAlignment','center');
text(numel(idx1)+1,nanmean(choicetoplot)+0.05,['p = ' num2str(round(p1,4))],'HorizontalAlignment','center');
title(label1)

ax = nsubplot(1,2,1,2);
ax.FontSize = 6;
ax.YLim = [0.25 1];
choicetoplot = a.overallChoice(idx2,6);
%     choicetoplot = mean([a.pref(idx1,3) a.pref(idx1,4)],2);
choicetoplot(isnan(choicetoplot))=0.5;
[choicetoplot,idx]=sort(choicetoplot);
semplot=a.overallCI(idx2(idx),:);
p2=signrank(choicetoplot*100-50);

errorbar(1:numel(choicetoplot), choicetoplot,...
            choicetoplot - semplot(:,1), semplot(:,2) - choicetoplot,...
        'o', 'MarkerFaceColor', 'k', 'Color', 'k', 'CapSize', 6, 'LineWidth', 1.2)
errorbar(numel(idx2)+1,mean(choicetoplot),sem(choicetoplot),'o', 'MarkerFaceColor', 'r', 'Color', 'r', 'CapSize', 6, 'LineWidth', 1.2);
plot([-10000000 1000000],[0.5 0.5],'Color',grey,'yliminclude','off','xliminclude','off');
xticks(1:numel(idx2)+1);
xticklabels([mice2(idx); 'Mean']);
xlim([0.5 numel(idx2)+1.5]);
ylabel('Mean choice of info side across reversals');
%     yticks([-.5 -.25 0 .25 .5]);
%     yticklabels({'0%','25%','50%','75%','100%'});
text(numel(idx2)+1,nanmean(choicetoplot)+0.1,['Mean = ' num2str(mean(choicetoplot))],'HorizontalAlignment','center');
text(numel(idx2)+1,nanmean(choicetoplot)+0.05,['p = ' num2str(round(p2,4))],'HorizontalAlignment','center');
title(label2)  

saveas(fig,fullfile(pathname,[label{1} '_OverallReverseFinal']),'pdf');

%%
% x = randi(50, 1, 100);                      % Create Data
% SEM = std(x)/sqrt(length(x));               % Standard Error
% ts = tinv([0.025  0.975],length(x)-1);      % T-Score
% CI = mean(x) + ts*SEM;                      % Confidence Intervals

% assuming you have arrays: animals, phat, ci_low, ci_high
figure; hold on
errorbar(1:a.mouseCt, a.overallChoice(:,6),...
            a.overallChoice(:,6) - a.overallCI(:,1), a.overallCI(:,2) - a.overallChoice(:,6),...
        'o', 'MarkerFaceColor', 'k', 'Color', 'k', 'CapSize', 6, 'LineWidth', 1.2)
yline(0.5, '--', 'Color', [0.6 0.6 0.6])  % chance level
% set(gca, 'XTick', 1:numel(a.mouseCt), )
% xlim([0.5, numel(animalNames) + 0.5])
ylabel('P(correct)')

%% MEAN PREFERENCE CI NEW

fig = figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 6;
ax.YLim = [0 1];
choicetoplot = a.reversalPrefMean(idx1rev,1);
[choicetoplot,idx]=sort(choicetoplot);
semplot=a.reversalPrefSEM(idx);
p1=signrank(choicetoplot*100-50);
%     bar(choicetoplot,'FaceColor','k');
for mm = 1:numel(idx1rev)
    bar(mm,choicetoplot(mm,1),'facecolor',[0.3 0.3 0.3],'edgecolor','none');
    errorbar(mm,choicetoplot(mm),semplot(mm),'LineStyle','none','LineWidth',2,'Color','k');
end
bar(numel(idx1rev)+1,mean(choicetoplot),'FaceColor','r');
errorbar(numel(idx1rev)+1,mean(choicetoplot),sem(choicetoplot));
plot([-10000000 1000000],[0.5 0.5],'Color',grey,'yliminclude','off','xliminclude','off');
xticks(1:numel(idx1rev)+1);
xticklabels([mice1(idx); 'Mean']);
xlim([0.5 numel(idx1rev)+1.5]);
ylabel('Mean choice of info side across reversals');
%     yticks([-.5 -.25 0 .25 .5]);
%     yticklabels({'0%','25%','50%','75%','100%'});
text(numel(idx1rev)+1,mean(choicetoplot)+0.1,['Mean = ' num2str(round(nanmean(a.overallChoice(idx1rev,5)),4))],'HorizontalAlignment','center');
text(numel(idx1rev)+1,mean(choicetoplot)+0.05,['p = ' num2str(round(p1,4))],'HorizontalAlignment','center');
title(label1)

ax = nsubplot(1,2,1,2);
ax.FontSize = 6;
ax.YLim = [0 1];    
choicetoplot = a.reversalPrefMean(idx2rev,1);
%     choicetoplot = mean([a.pref(idx2rev,3) a.pref(idx2rev,4)],2);
%     choicetoplot(isnan(choicetoplot))=0.5;
[choicetoplot,idx]=sort(choicetoplot);
semplot=a.reversalPrefSEM(idx);
p2=signrank(choicetoplot*100-50);
for mm = 1:numel(idx2rev)
    bar(mm,choicetoplot(mm,1),'facecolor',[0.3 0.3 0.3],'edgecolor','none');
    errorbar(mm,choicetoplot(mm),semplot(mm,1),'LineStyle','none','LineWidth',2,'Color','k');
end
bar(numel(idx2rev)+1,mean(choicetoplot),'FaceColor','r');
errorbar(numel(idx2rev)+1,mean(choicetoplot),sem(choicetoplot));
plot([-10000000 1000000],[0.5 0.5],'Color',grey,'yliminclude','off','xliminclude','off');
xticks(1:numel(idx2rev)+1);
xticklabels([mice2(idx); 'Mean']);
xlim([0.5 numel(idx2rev)+1.5]);
ylabel('Mean choice of info side across reversals');
%     yticks([-.5 -.25 0 .25 .5]);
%     yticklabels({'0%','25%','50%','75%','100%'});
text(numel(idx2rev)+1,mean(choicetoplot)+0.1,['Mean = ' num2str(round(nanmean(a.overallChoice(idx2rev,5)),4))],'HorizontalAlignment','center');
text(numel(idx2rev)+1,mean(choicetoplot)+0.05,['p = ' num2str(round(p2,4))],'HorizontalAlignment','center');
title(label2)    

saveas(fig,fullfile(pathname,[label{1} '_OverallIndexAno']),'pdf');

%% OVERALL GROUP VIOLIN COMP NEW
    
[choiceSort1,sort1]=sort(a.preRevPrefMean(idx1,1));
[choiceSort2,sort2]=sort(a.preRevPrefMean(idx2,1));
CI1=a.preRevPrefSEM(sort1);
CI2=a.preRevPrefSEM(sort2);    
p1=signrank(choiceSort1*100-50);
p2=signrank(choiceSort2*100-50);
[~,p]=ttest2(choiceSort1,choiceSort2);

fig = figure();    
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,1,1,1);
ax.FontSize = 8;
ax.XTick = [1 2];
ax.XLim = [0,3];
ax.YTick = [0 0.25 0.50 0.75 1];
ax.XTickLabel = {label1,label2};
ax.YLim = [0 1];
v1=Violin(choiceSort1,1);
v2=Violin(choiceSort2,2);
v1.ViolinColor=[0.4 0.4 0.4]; 
v1.EdgeColor='none'; 
v1.BoxColor='none';
v1.ScatterPlot.MarkerFaceColor='k';
v1.ScatterPlot.MarkerFaceAlpha=1;
v1.ShowMean=true;
v2.ViolinColor=[0.4 0.4 0.4]; 
v2.EdgeColor='none'; 
v2.BoxColor='none';
v2.ScatterPlot.MarkerFaceColor='k';
v2.ScatterPlot.MarkerFaceAlpha=1;
v2.ShowMean=true;   

text(0.5,0.1,{['mean ' num2str(mean(choiceSort1,'omitnan'))] ['p = ' num2str(p1)]})
text(1.5,0.1,{['mean ' num2str(mean(choiceSort2,'omitnan'))] ['p = ' num2str(p2)]})
ylabel('Initial info side preference');
xlabel('Mouse');
title([label{1} ' p=' num2str(p)]);
hold off;
axis square;

saveas(fig,fullfile(pathname,[label{1} '_OverallbyCategoryViolin']),'pdf');

%% PRE VS POST REVERSAL PREFERENCE

fig = figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.XLim = [0 1];
ax.YLim = [0 1];
for l = 1:numel(idx1rev)
    m = idx1rev(l);
    plot([a.pref(m,3) a.pref(m,3)],[a.prefRevCI(m,3) a.prefRevCI(m,4)],'color',[0.2 0.2 0.2],'linewidth',0.25);
    plot([a.prefCI(m,3) a.prefCI(m,4)],[a.pref(m,4) a.pref(m,4)],'color',[0.2 0.2 0.2],'linewidth',0.25);
    dy = 0.02;
    text(a.pref(m,3),a.pref(m,4) + dy,mice1rev(l),'HorizontalAlignment','center');
end
scatter(a.pref(idx1rev,3),a.pref(idx1rev,4),100,'k','filled')
plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
%     text(numel(idx1)+2,a.overallPref,['p = ' num2str(a.overallP)])
%     patch([0.5 1 1 0.5],[0 0 0.5 0.5],[0.3 0.3 0.3],'FaceAlpha',0.1,'EdgeColor','none');
ylabel({'% info choice', 'POST-reversal'}); %{'Info choice', 'probability'}
xlabel({'% info choice', 'PRE-reversal'});
title('Info preference pre vs post-reversal');
hold off;
axis square;
title(label1);

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.XLim = [0 1];
ax.YLim = [0 1];
for l = 1:numel(idx2rev)
    m = idx2rev(l);
    plot([a.pref(m,3) a.pref(m,3)],[a.prefRevCI(m,3) a.prefRevCI(m,4)],'color',[0.2 0.2 0.2],'linewidth',0.25);
    plot([a.prefCI(m,3) a.prefCI(m,4)],[a.pref(m,4) a.pref(m,4)],'color',[0.2 0.2 0.2],'linewidth',0.25);
    dy = 0.02;
    text(a.pref(m,3),a.pref(m,4) + dy,mice2rev(l),'HorizontalAlignment','center');
end
scatter(a.pref(idx2rev,3),a.pref(idx2rev,4),100,'k','filled')
plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
%     text(numel(idx1)+2,a.overallPref,['p = ' num2str(a.overallP)])
%     patch([0.5 1 1 0.5],[0 0 0.5 0.5],[0.3 0.3 0.3],'FaceAlpha',0.1,'EdgeColor','none');
ylabel({'% info choice', 'POST-reversal'}); %{'Info choice', 'probability'}
xlabel({'% info choice', 'PRE-reversal'});
title('Info preference pre vs post-reversal');
hold off;
axis square;
title(label2);   

saveas(fig,fullfile(pathname,[label{1} '_PrevsPostPref']),'pdf');

%% PRE VS POST REVERSAL PREFERENCE NEW

fig = figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,2,1,1);
ax.FontSize = 8;
ax.XLim = [0 1];
ax.YLim = [0 1];
for l = 1:numel(idx1rev)
    m = idx1rev(l);
    prePref=mean(a.reversalPref(m,[1 2]));
    postPref=mean(a.reversalPref(m,[3 4]));
%     plot([prePref prePref],[a.prefRevCI(m,3) a.prefRevCI(m,4)],'color',[0.2 0.2 0.2],'linewidth',0.25);
%     plot([a.prefCI(m,3) a.prefCI(m,4)],[postPref postPref],'color',[0.2 0.2 0.2],'linewidth',0.25);
%     dy = 0.02;
    text(prePref,postPref + dy,mice1(l),'HorizontalAlignment','center');
end
scatter(mean(a.reversalPref(idx1rev,[1 2]),2),mean(a.reversalPref(idx1rev,[3 4]),2),100,'k','filled')
plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
%     text(numel(idx1)+2,a.overallPref,['p = ' num2str(a.overallP)])
%     patch([0.5 1 1 0.5],[0 0 0.5 0.5],[0.3 0.3 0.3],'FaceAlpha',0.1,'EdgeColor','none');
ylabel({'% info choice', 'POST-reversal'}); %{'Info choice', 'probability'}
xlabel({'% info choice', 'PRE-reversal'});
title('Info preference pre vs post-reversal');
hold off;
axis square;
title(label1);

ax = nsubplot(1,2,1,2);
ax.FontSize = 8;
ax.XLim = [0 1];
ax.YLim = [0 1];
for l = 1:numel(idx2rev)
    m = idx2rev(l);
    prePref=mean(a.reversalPref(m,[1 2]));
    postPref=mean(a.reversalPref(m,[3 4]));
%     plot([prePref prePref],[a.prefRevCI(m,3) a.prefRevCI(m,4)],'color',[0.2 0.2 0.2],'linewidth',0.25);
%     plot([a.prefCI(m,3) a.prefCI(m,4)],[postPref postPref],'color',[0.2 0.2 0.2],'linewidth',0.25);
%     dy = 0.02;
    text(prePref,postPref + dy,mice2(l),'HorizontalAlignment','center');
end
scatter(mean(a.reversalPref(idx2rev,[1 2]),2),mean(a.reversalPref(idx2rev,[3 4]),2),100,'k','filled')
plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
%     text(numel(idx1)+2,a.overallPref,['p = ' num2str(a.overallP)])
%     patch([0.5 1 1 0.5],[0 0 0.5 0.5],[0.3 0.3 0.3],'FaceAlpha',0.1,'EdgeColor','none');
ylabel({'% info choice', 'POST-reversal'}); %{'Info choice', 'probability'}
xlabel({'% info choice', 'PRE-reversal'});
title('Info preference pre vs post-reversal');
hold off;
axis square;
title(label2);   

saveas(fig,fullfile(pathname,[label{1} '_PrevsPostPrefNew']),'pdf');

%% CUMULATIVE

fig = figure();

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 7 10];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','portrait');

ax = nsubplot(2,1,1,1);
ax.FontSize = 8;
hold on;

for mm = 1:numel(idx1)
    m=idx1(mm);
    ci = a.cumInfo{m};
%     ci_frac = ci / ci(end);  % normalize by total info-side choices
        plot(1:length(ci), ci, 'Color', 'k', 'LineWidth', 2);
end

% for mm = 1:length(idx2)
%     m=idx2(mm);
%     ci = a.cumInfo{m};
%     plot(1:length(ci), ci, 'Color', 'g', 'LineWidth', 2);
% end

% href=refline(1,0);
% href.Color = 'r';
xlabel('Trial');
ylabel('Cumulative Information-Side Choices');
title(['Cumulative Info Choices ']);
% ax.YLim = [0 300];
% ax.XLim = [0 300];
grid on;

% legend('Control','Halo','location','northwest');



win=100;

ax = nsubplot(2,1,2,1);
ax.FontSize = 8;
hold on;

for mm = 1:numel(okMice)
    m=idx1(mm);
    ci = a.choices{m};
    ci_avg=movmean(ci,win);
    plot(1:length(ci_avg), ci_avg, 'LineWidth', 2);
end
% href=refline(1,0);
% href.Color = 'r';
xlabel('10-trial window');
ylabel('Info preference');
title(['Rolling Average ' 'CONTROL']);
% ax.YLim = [0 300];
ax.XLim = [0 400];
grid on;
hold off;

saveas(fig,fullfile(pathname,[label{1} '_OverallCumulative']),'pdf');

%% Overall Cumulative by Group

fig = figure();

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 7 10];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','portrait');

ax = nsubplot(2,2,1,1);
ax.FontSize = 8;
hold on;

for mm = 1:numel(idx1)
    m=idx1(mm);
    ci = a.cumInfo{m};
        plot(1:length(ci), ci, 'Color', 'k', 'LineWidth', 2);
end

xlabel('Trial');
ylabel('Information-Side Choices');
title(['Cumulative Info Choices ' labels{1}]);
% ax.YLim = [0 300];
% ax.XLim = [0 300];
grid on;

win=100;

ax = nsubplot(2,2,2,1);
ax.FontSize = 8;
hold on;

for mm = 1:numel(idx1)
    m=idx1(mm);
    ci = a.choices{m};
    ci_avg=movmean(ci,win);
    plot(1:length(ci_avg), ci_avg, 'LineWidth', 2);
end
xlabel('100-trial window');
ylabel('Info preference');
title(['Rolling Average ' labels{1}]);
% ax.YLim = [0 300];
ax.XLim = [0 400];
grid on;
hold off;

ax = nsubplot(2,2,1,2);
ax.FontSize = 8;
hold on;

for mm = 1:numel(idx2)
    m=idx2(mm);
    ci = a.cumInfo{m};
        plot(1:length(ci), ci, 'Color', 'k', 'LineWidth', 2);
end

xlabel('Trial');
ylabel('Information-Side Choices');
title(['Cumulative Info Choices ' labels{2}]);
% ax.YLim = [0 300];
% ax.XLim = [0 300];
grid on;

win=100;

ax = nsubplot(2,2,2,2);
ax.FontSize = 8;
hold on;

for mm = 1:numel(idx2)
    m=idx2(mm);
    ci = a.choices{m};
    ci_avg=movmean(ci,win);
    plot(1:length(ci_avg), ci_avg, 'LineWidth', 2);
end
xlabel('100-trial window');
ylabel('Info preference');
title(['Rolling Average ' labels{2}]);
% ax.YLim = [0 300];
ax.XLim = [0 400];
grid on;
hold off;

saveas(fig,fullfile(pathname,[label{1} '_OverallCumulativebyGroup']),'pdf');

%%
revMice=ismember(1:a.mouseCt,a.reverseMice)';
okMice=a.pref(:,4)>0.5 & a.pref(:,3)>0.5 & revMice;
okMice=find(okMice);

fig = figure();

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 7 10];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','portrait');

ax = nsubplot(2,1,1,1);
ax.FontSize = 8;
hold on;

for mm = 1:numel(okMice)
    m=okMice(mm);
    ci = a.cumInfo{m};
%     ci_frac = ci / ci(end);  % normalize by total info-side choices
        plot(1:length(ci), ci, 'Color', 'k', 'LineWidth', 2);
end

% for mm = 1:length(idx2)
%     m=idx2(mm);
%     ci = a.cumInfo{m};
%     plot(1:length(ci), ci, 'Color', 'g', 'LineWidth', 2);
% end

% href=refline(1,0);
% href.Color = 'r';
xlabel('Trial');
ylabel('Cumulative Information-Side Choices');
title(['Cumulative Info Choices ']);
% ax.YLim = [0 300];
% ax.XLim = [0 300];
grid on;

% legend('Control','Halo','location','northwest');

win=100;

ax = nsubplot(2,1,2,1);
ax.FontSize = 8;
hold on;

for mm = 1:numel(okMice)
    m=okMice(mm);
    ci = a.choices{m};
    ci_avg=movmean(ci,win);
    plot(1:length(ci_avg), ci_avg, 'LineWidth', 2);
end
% href=refline(1,0);
% href.Color = 'r';
xlabel('100-trial window');
ylabel('Info preference');
title(['Rolling Average ' 'REV MICE ONLY']);
% ax.YLim = [0 300];
ax.XLim = [0 500];
grid on;
hold off;

saveas(fig,fullfile(pathname,[label{1} '_OverallCumulativeRevOnly']),'pdf');

%%

revMice=ismember(1:a.mouseCt,a.reverseMice)';
okMice=a.pref(:,4)>0.5 & a.pref(:,3)>0.5 & revMice;
okMice=find(okMice);

nItems = 22;
nCols = 6;  % x-direction
nRows = 4;  % y-direction

positions = zeros(nItems, 2);  % preallocate: [x, y] positions

for i = 1:nItems
    col = mod(i-1, nCols) + 1;           % column index (x)
    row = floor((i-1) / nCols) + 1;      % row index (y)
    positions(i, :) = [col, row];
end

fig = figure();

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10.5 7.5];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

for mm = 1:numel(okMice)
m=okMice(mm);
nsubplot(6,4,positions(mm,1),positions(mm,2));

ci = a.choices{m};
ci_avg=movmean(ci,win);
plot(1:length(ci_avg), ci_avg, 'LineWidth', 2);

% href=refline(1,0);
% href.Color = 'r';
% xlabel('100-trial window');
ylabel('Info preference');
% title(['Rolling Average ' 'REV MICE ONLY']);
ylim([0 1]);
xlim([0 500]);
plot([-10000000 1000000],[0.5 0.5],'Color',grey,'yliminclude','off','xliminclude','off');
hold off;
end
saveas(fig,fullfile(pathname,[label{1} '_OverallCumulativeIndRevOnly']),'pdf');

%%
% revMice=ismember(1:a.mouseCt,a.reverseMice)';
% okMice=a.pref(:,4)>0.5 & a.pref(:,3)>0.5 & revMice;
% okMice=find(okMice);

nItems = numel(idx1);
nCols = 6;  % x-direction
nRows = 4;  % y-direction

positions = zeros(nItems, 2);  % preallocate: [x, y] positions

for i = 1:nItems
    col = mod(i-1, nCols) + 1;           % column index (x)
    row = floor((i-1) / nCols) + 1;      % row index (y)
    positions(i, :) = [col, row];
end

fig = figure();

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10.5 7.5];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

for mm = 1:numel(idx1)
m=idx1(mm);
nsubplot(6,4,positions(mm,1),positions(mm,2));

ci = a.choices{m};
ci_avg=movmean(ci,win);
plot(1:length(ci_avg), ci_avg, 'LineWidth', 2);

% href=refline(1,0);
% href.Color = 'r';
% xlabel('100-trial window');
ylabel('Info preference');
% title('Rolling Average');
xlabel('Trial');
ylim([0 1]);
xlim([0 500]);
plot([-10000000 1000000],[0.5 0.5],'Color',grey,'yliminclude','off','xliminclude','off');
hold off;
end

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, labels{1},'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig,fullfile(pathname,[label{1} '_OverallCumulativeInd_' labels{1}]),'pdf');

nItems = numel(idx2);
nCols = 6;  % x-direction
nRows = 4;  % y-direction

positions = zeros(nItems, 2);  % preallocate: [x, y] positions

for i = 1:nItems
    col = mod(i-1, nCols) + 1;           % column index (x)
    row = floor((i-1) / nCols) + 1;      % row index (y)
    positions(i, :) = [col, row];
end

fig = figure();

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10.5 7.5];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

for mm = 1:numel(idx2)
m=idx2(mm);
nsubplot(6,4,positions(mm,1),positions(mm,2));

ci = a.choices{m};
ci_avg=movmean(ci,win);
plot(1:length(ci_avg), ci_avg, 'LineWidth', 2);

% href=refline(1,0);
% href.Color = 'r';
% xlabel('100-trial window');
ylabel('Info preference');
% title('Rolling Average');
xlabel('Trial');
ylim([0 1]);
xlim([0 500]);
plot([-10000000 1000000],[0.5 0.5],'Color',grey,'yliminclude','off','xliminclude','off');
hold off;
end

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, labels{2},'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig,fullfile(pathname,[label{1} '_OverallCumulativeInd_' labels{2}]),'pdf');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NOTHING MORE AFTER THIS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PREFERENCE/CHOICES (OLD)

% %% MEAN PREFERENCE (INDEX) OLD
% 
% if ~isempty(a.reverseMice)
%     fig = figure();
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
% 
%     ax = nsubplot(1,2,1,1);
%     ax.FontSize = 6;
%     ax.YLim = [-0.5 0.5];
%     choicetoplot = a.overallChoice(idx1,5);
%     choicetoplot(isnan(choicetoplot))=0.5;
%     [choicetoplot,idx]=sort(choicetoplot);
%     p1=signrank(choicetoplot*100-50);
%     bar(choicetoplot-0.5,'FaceColor',grey);
%     bar(numel(idx1)+1,mean(a.overallChoice(idx1,5)-0.5,'omitnan'),'FaceColor','k');
%     xticks(1:numel(idx1)+1);
%     xticklabels([mice1(idx); 'Mean']);
%     xlim([0.5 numel(idx1)+1.5]);
%     ylabel('Mean choice of info side across reversals');
%     yticks([-.5 -.25 0 .25 .5]);
%     yticklabels({'0%','25%','50%','75%','100%'});
%     text(numel(idx1)+1,nanmean(a.overallChoice(idx1,5))-0.45,['Mean = ' num2str(round(nanmean(a.overallChoice(idx1,5)),4))],'HorizontalAlignment','center');
%     text(numel(idx1)+1,nanmean(a.overallChoice(idx1,5))-0.46,['p = ' num2str(round(p1,4))],'HorizontalAlignment','center');
%     title(label1)
% 
%     ax = nsubplot(1,2,1,2);
%     ax.FontSize = 6;
%     ax.YLim = [-0.5 0.5];    
%     choicetoplot = a.overallChoice(idx2,5);
%     choicetoplot(isnan(choicetoplot))=0.5;
%     [choicetoplot,idx]=sort(choicetoplot);
%     p2=signrank(choicetoplot*100-50);
%     bar(choicetoplot-0.5,'FaceColor',grey);
%     bar(numel(idx2)+1,mean(a.overallChoice(idx2,5)-0.5,'omitnan'),'FaceColor','k');
%     xticks(1:numel(idx2)+1);
%     xticklabels([mice2(idx); 'Mean']);
%     xlim([0.5 numel(idx2)+1.5]);
%     ylabel('Mean choice of info side across reversals');
%     yticks([-.5 -.25 0 .25 .5]);
%     yticklabels({'0%','25%','50%','75%','100%'});
%     text(numel(idx2)+1,nanmean(a.overallChoice(idx2,5))-0.45,['Mean = ' num2str(round(nanmean(a.overallChoice(idx2,5)),4))],'HorizontalAlignment','center');
%     text(numel(idx2)+1,nanmean(a.overallChoice(idx2,5))-0.46,['p = ' num2str(round(p2,4))],'HorizontalAlignment','center');
%     title(label2)    
% 
%     saveas(fig,fullfile(pathname,[label{1} '_OverallIndex']),'pdf');
% end
% 
% %% OVERALL GROUP VIOLIN COMP
% 
% if a.choiceMouseCt > 1 && active>0
%     
%     [choiceSort1,sort1]=sort(a.meanChoice(idx1,1));
%     [choiceSort2,sort2]=sort(a.meanChoice(idx2,1));
%     CI1=sort(a.choiceCI(idx1,:));
%     CI2=sort(a.choiceCI(idx2,:));
%     p1=signrank(choiceSort1*100-50);
%     p2=signrank(choiceSort2*100-50);
%     [~,p]=ttest2(choiceSort1,choiceSort2);
%     
%     fig = figure();    
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     
%     ax = nsubplot(1,1,1,1);
%     ax.FontSize = 8;
%     ax.XTick = [1 2];
%     ax.XLim = [0,3];
%     ax.YTick = [0 0.25 0.50 0.75 1];
%     ax.XTickLabel = {label1,label2};
%     ax.YLim = [0 1];
%     v1=Violin(choiceSort1,1);
%     v2=Violin(choiceSort2,2);
%    v1.ViolinColor=[0.4 0.4 0.4]; 
%    v1.EdgeColor='none'; 
%    v1.BoxColor='none';
%    v1.ScatterPlot.MarkerFaceColor='k';
%    v1.ScatterPlot.MarkerFaceAlpha=1;
%    v1.ShowMean=true;
%    v2.ViolinColor=[0.4 0.4 0.4]; 
%    v2.EdgeColor='none'; 
%    v2.BoxColor='none';
%    v2.ScatterPlot.MarkerFaceColor='k';
%    v2.ScatterPlot.MarkerFaceAlpha=1;
%    v2.ShowMean=true;   
% 
%     text(0.5,0.1,{['mean ' num2str(mean(choiceSort1,'omitnan'))] ['p = ' num2str(p1)]})
%     text(1.5,0.1,{['mean ' num2str(mean(choiceSort2,'omitnan'))] ['p = ' num2str(p2)]})
%     ylabel('Initial info side preference');
%     xlabel('Mouse');
%     title([label{1} ' p=' num2str(p)]);
%     hold off;
%     axis square;
%     
%     saveas(fig,fullfile(pathname,[label{1} '_OverallbyCategory']),'pdf');
% 
% end
% 
% %%
% if ~isempty(a.reverseMice) && active>0
%     fig = figure();
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
% 
%     ax = nsubplot(1,2,1,1);
%     ax.FontSize = 8;
%     ax.XLim = [0 1];
%     ax.YLim = [0 1];
%     for l = 1:numel(idx1)
%         m = idx1(l);
%         plot([a.pref(m,1) a.pref(m,1)],[a.prefRevCI(m,1) a.prefRevCI(m,2)],'color',[0.2 0.2 0.2],'linewidth',0.25);
%         plot([a.prefCI(m,1) a.prefCI(m,2)],[a.pref(m,2) a.pref(m,2)],'color',[0.2 0.2 0.2],'linewidth',0.25);
%         dy = a.prefRevCI(m,2) - a.pref(m,2) + 0.02;
%         text(a.pref(m,1),a.pref(m,2) + dy,mice1(l),'HorizontalAlignment','center');
%     end
%     scatter(a.pref(idx1,1),a.pref(idx1,2),'filled')
%     plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
%     plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% %     text(numel(idx1)+2,a.overallPref,['p = ' num2str(a.overallP)])
% %     patch([0.5 1 1 0.5],[0 0 0.5 0.5],[0.3 0.3 0.3],'FaceAlpha',0.1,'EdgeColor','none');
%     ylabel({'% choice of initially informative side', 'POST-reversal'}); %{'Info choice', 'probability'}
%     xlabel({'% choice of initially informative side', 'PRE-reversal'});
%     title('Raw choice percentages, pre vs post-reversal');
%     hold off;
%     axis square;
%     title(label1);
%     
%     ax = nsubplot(1,2,1,2);
%     ax.FontSize = 8;
%     ax.XLim = [0 1];
%     ax.YLim = [0 1];
%     for l = 1:numel(idx2)
%         m = idx2(l);
%         plot([a.pref(m,1) a.pref(m,1)],[a.prefRevCI(m,1) a.prefRevCI(m,2)],'color',[0.2 0.2 0.2],'linewidth',0.25);
%         plot([a.prefCI(m,1) a.prefCI(m,2)],[a.pref(m,2) a.pref(m,2)],'color',[0.2 0.2 0.2],'linewidth',0.25);
%         dy = a.prefRevCI(m,2) - a.pref(m,2) + 0.02;
%         text(a.pref(m,1),a.pref(m,2) + dy,mice2(l),'HorizontalAlignment','center');
%     end
%     scatter(a.pref(idx2,1),a.pref(idx2,2),'filled')
%     plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
%     plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% %     text(numel(idx1)+2,a.overallPref,['p = ' num2str(a.overallP)])
% %     patch([0.5 1 1 0.5],[0 0 0.5 0.5],[0.3 0.3 0.3],'FaceAlpha',0.1,'EdgeColor','none');
%     ylabel({'% choice of initially informative side', 'POST-reversal'}); %{'Info choice', 'probability'}
%     xlabel({'% choice of initially informative side', 'PRE-reversal'});
%     title('Raw choice percentages, pre vs post-reversal');
%     hold off;
%     axis square;
%     title(label2);    
% 
%     saveas(fig,fullfile(pathname,[label{1} '_PrevsPostIIS']),'pdf');
% %     close(fig);
% end
% 
    %% LOGISTIC REGRESSION ON TRIALS TO COUNT (regression.pdf) 
    
    l=4;

if ~isempty(a.reverseMice)
    fig = figure();
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0.5 0.5 10 7];
    set(fig,'renderer','painters');
    set(fig,'PaperOrientation','landscape');

    ax = nsubplot(1,2,1,1);
    ax.FontSize = 8;
    ax.XLim = [-l l];
    ax.YLim = [-l l];
    for mm = 1:numel(idx1)
        m = idx1(mm);
        plot([a.beta(m,1) a.beta(m,1)],[a.beta(m,2) - a.betaSE(m,2) a.beta(m,2) + a.betaSE(m,2)],'color',[0.2 0.2 0.2],'linewidth',0.25);
        plot([a.beta(m,1)-a.betaSE(m,1) a.beta(m,1)+a.betaSE(m,1)],[a.beta(m,2) a.beta(m,2)],'color',[0.2 0.2 0.2],'linewidth',0.25);
%         dy = a.beta(m,2) - a.betaCI(m,2) + 0.02;
        text(a.beta(m,1),a.beta(m,2) + 0.1,mice1{mm},'HorizontalAlignment','center');
    end
    scatter(a.beta(idx1,1),a.beta(idx1,2),'filled','MarkerFaceColor','k');
    plot([-10000000 1000000],[0 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
    plot([0 0],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
    ylabel({'Info preference', '(log odds biasing to currently informative side'}); %{'Info choice', 'probability'}
    xlabel({'Side bias', '(log odds biasing to initially informative side)'});
    title(['Logistic Regression Analysis ' label1]);
    axis square;
    hold off;
    
    ax = nsubplot(1,2,1,2);
    ax.FontSize = 8;
    ax.XLim = [-l l];
    ax.YLim = [-l l];
    for mm = 1:numel(idx2)
        m = idx2(mm);
        plot([a.beta(m,1) a.beta(m,1)],[a.beta(m,2) - a.betaSE(m,2) a.beta(m,2) + a.betaSE(m,2)],'color',[0.2 0.2 0.2],'linewidth',0.25);
        plot([a.beta(m,1)-a.betaSE(m,1) a.beta(m,1)+a.betaSE(m,1)],[a.beta(m,2) a.beta(m,2)],'color',[0.2 0.2 0.2],'linewidth',0.25);
%         dy = a.beta(m,2) - a.betaCI(m,2) + 0.02;
        text(a.beta(m,1),a.beta(m,2) + 0.1,mice2{mm},'HorizontalAlignment','center');
    end
    scatter(a.beta(idx2,1),a.beta(idx2,2),'filled','MarkerFaceColor','k');
    plot([-10000000 1000000],[0 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
    plot([0 0],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
    ylabel({'Info preference', '(log odds biasing to currently informative side'}); %{'Info choice', 'probability'}
    xlabel({'Side bias', '(log odds biasing to initially informative side)'});
    title(['Logistic Regression Analysis ' label2]);
    axis square;
    hold off;    

    saveas(fig,fullfile(pathname,[label{1} '_Regression']),'pdf');
%     close(fig);
end

%% PLOT MEAN CHOICES AROUND REVERSALS
% if ~isempty(a.reverseMice) && active>0
%     fig = figure();
%     
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     
%     ax = nsubplot(1,2,1,1);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.25 0.50 0.75 1];
%     ax.YLim = [0 1];
%     ax.XLim = [0.5 10.5];
%     ax.XTick = [1:9];
%     
%     plot(1, mean(a.reversalMultiPrefs(idx1rev,1),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     errorbar(1,mean(a.reversalMultiPrefs(idx1rev,1),1,'omitnan'),sem(a.reversalMultiPrefs(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',50);
%     plot([2:4], 1-mean(a.reversalMultiPrefs(idx1rev,2:4),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     for n=2:4
%        errorbar(n,1-mean(a.reversalMultiPrefs(idx1rev,n),1,'omitnan'),sem(a.reversalMultiPrefs(idx1rev,n)),'Color','k','LineWidth',2,'CapSize',50);
%     end
%     plot(6, 1-mean(a.reversalMultiPrefs(idx1rev,5),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     errorbar(6,1-mean(a.reversalMultiPrefs(idx1rev,5),1,'omitnan'),sem(a.reversalMultiPrefs(idx1rev,n)),'Color','k','LineWidth',2,'CapSize',50);
%     plot([7:9], mean(a.reversalMultiPrefs(idx1rev,6:8),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     for n=6:8
%        errorbar(n+1,mean(a.reversalMultiPrefs(idx1rev,n),1,'omitnan'),sem(a.reversalMultiPrefs(idx1rev,n)),'Color','k','LineWidth',2,'CapSize',50);
%     end    
%     plot([1.5 1.5],[-10000000 1000000],'color','r','linewidth',1,'linestyle','--','yliminclude','off','xliminclude','off');
%     plot([6.5 6.5],[-10000000 1000000],'color','r','linewidth',1,'linestyle','--','yliminclude','off','xliminclude','off');
%     
%     reverseLabels = {'Pre-reverse','1','2','3',' ','Pre-reverse','1','2','3'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel({'% choice of', 'current info side'});
%     title(label1)
%     hold off;
%     axis square;
%     
%     ax = nsubplot(1,2,1,2);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.25 0.50 0.75 1];
%     ax.YLim = [0 1];
%     ax.XLim = [0.5 10.5];
%     ax.XTick = [1:9];
%     
%     plot(1, mean(a.reversalMultiPrefs(idx2rev,1),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     errorbar(1,mean(a.reversalMultiPrefs(idx2rev,1),1,'omitnan'),sem(a.reversalMultiPrefs(idx2rev,n)),'Color','k','LineWidth',2,'CapSize',50);
%     plot([2:4], 1-mean(a.reversalMultiPrefs(idx2rev,2:4),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     for n=2:4
%        errorbar(n,1-mean(a.reversalMultiPrefs(idx2rev,n),1,'omitnan'),sem(a.reversalMultiPrefs(idx2rev,n)),'Color','k','LineWidth',2,'CapSize',50);
%     end
%     plot(6, 1-mean(a.reversalMultiPrefs(idx2rev,5),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     errorbar(6,1-mean(a.reversalMultiPrefs(idx2rev,5),1,'omitnan'),sem(a.reversalMultiPrefs(idx2rev,n)),'Color','k','LineWidth',2,'CapSize',50);
%     plot([7:9], mean(a.reversalMultiPrefs(idx2rev,6:8),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     for n=6:8
%        errorbar(n+1,mean(a.reversalMultiPrefs(idx2rev,n),1,'omitnan'),sem(a.reversalMultiPrefs(idx2rev,n)),'Color','k','LineWidth',2,'CapSize',50);
%     end    
%     plot([1.5 1.5],[-10000000 1000000],'color','r','linewidth',1,'linestyle','--','yliminclude','off','xliminclude','off');
%     plot([6.5 6.5],[-10000000 1000000],'color','r','linewidth',1,'linestyle','--','yliminclude','off','xliminclude','off');
%     
%     reverseLabels = {'Pre-reverse','1','2','3',' ','Pre-reverse','1','2','3'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel({'% choice of', 'current info side'});
%     title(label2)
%     hold off;
%     axis square;
%     
%     saveas(fig,fullfile(pathname,[label{1} '_ReversalMultiChoices']),'pdf');
% end
% 
% %% PLOT MEAN CHOICES AROUND REVERSALS IIS
% if ~isempty(a.reverseMice) && active>0
%     fig = figure();
%     
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     
%     ax = nsubplot(1,2,1,1);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.25 0.50 0.75 1];
%     ax.YLim = [0 1];
%     ax.XLim = [0.5 10.5];
%     ax.XTick = [1:9];
%     
%     plot(1, mean(a.reversalMultiPrefs(idx1rev,1),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     errorbar(1,mean(a.reversalMultiPrefs(idx1rev,1),1,'omitnan'),sem(a.reversalMultiPrefs(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',50);
%     plot([2:4], mean(a.reversalMultiPrefs(idx1rev,2:4),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     for n=2:4
%        errorbar(n,mean(a.reversalMultiPrefs(idx1rev,n),1,'omitnan'),sem(a.reversalMultiPrefs(idx1rev,n)),'Color','k','LineWidth',2,'CapSize',50);
%     end
%     plot(6, mean(a.reversalMultiPrefs(idx1rev,5),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     errorbar(6,mean(a.reversalMultiPrefs(idx1rev,5),1,'omitnan'),sem(a.reversalMultiPrefs(idx1rev,5)),'Color','k','LineWidth',2,'CapSize',50);
%     plot([7:9], mean(a.reversalMultiPrefs(idx1rev,6:8),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     for n=6:8
%        errorbar(n+1,mean(a.reversalMultiPrefs(idx1rev,n),1,'omitnan'),sem(a.reversalMultiPrefs(idx1rev,n)),'Color','k','LineWidth',2,'CapSize',50);
%     end    
%     plot([1.5 1.5],[-10000000 1000000],'color','r','linewidth',1,'linestyle','--','yliminclude','off','xliminclude','off');
%     plot([6.5 6.5],[-10000000 1000000],'color','r','linewidth',1,'linestyle','--','yliminclude','off','xliminclude','off');
%     
%     reverseLabels = {'Pre-reverse','1','2','3',' ','Pre-reverse','1','2','3'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel({'% choice of', 'INITIAL info side'});
%     title(label1)
%     hold off;
%     axis square;
%     
%     ax = nsubplot(1,2,1,2);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.25 0.50 0.75 1];
%     ax.YLim = [0 1];
%     ax.XLim = [0.5 10.5];
%     ax.XTick = [1:9];
%     
%     plot(1, mean(a.reversalMultiPrefs(idx2rev,1),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     errorbar(1,mean(a.reversalMultiPrefs(idx2rev,1),1,'omitnan'),sem(a.reversalMultiPrefs(idx2rev,n)),'Color','k','LineWidth',2,'CapSize',50);
%     plot([2:4], mean(a.reversalMultiPrefs(idx2rev,2:4),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     for n=2:4
%        errorbar(n,mean(a.reversalMultiPrefs(idx2rev,n),1,'omitnan'),sem(a.reversalMultiPrefs(idx2rev,n)),'Color','k','LineWidth',2,'CapSize',50);
%     end
%     plot(6, mean(a.reversalMultiPrefs(idx2rev,5),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     errorbar(6,mean(a.reversalMultiPrefs(idx2rev,5),1,'omitnan'),sem(a.reversalMultiPrefs(idx2rev,n)),'Color','k','LineWidth',2,'CapSize',50);
%     plot([7:9], mean(a.reversalMultiPrefs(idx2rev,6:8),1,'omitnan'),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',5);
%     for n=6:8
%        errorbar(n+1,mean(a.reversalMultiPrefs(idx2rev,n),1,'omitnan'),sem(a.reversalMultiPrefs(idx2rev,n)),'Color','k','LineWidth',2,'CapSize',50);
%     end    
%     plot([1.5 1.5],[-10000000 1000000],'color','r','linewidth',1,'linestyle','--','yliminclude','off','xliminclude','off');
%     plot([6.5 6.5],[-10000000 1000000],'color','r','linewidth',1,'linestyle','--','yliminclude','off','xliminclude','off');
%     
%     reverseLabels = {'Pre-reverse','1','2','3',' ','Pre-reverse','1','2','3'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel({'% choice of', 'INITIAL info side'});
%     title(label2)
%     hold off;
%     axis square;
%     
%     saveas(fig,fullfile(pathname,[label{1} '_ReversalMultiChoicesIIS']),'pdf');
% end
% 
% %% PLOT MEAN CHOICES AROUND REVERSALS IIS
% if ~isempty(a.reverseMice) && active>0
%     
%     for d=1:size(a.choicesAround,2)
%        choices=vertcat(a.choicesAround{idx1,d});
%        [allChoices{1}(1,d), allChoicesCI{1}(1:2,d)] = binofit(sum(choices==1),numel(choices));
%        choices=vertcat(a.choicesAround{idx2,d});
%        [allChoices{2}(1,d), allChoicesCI{2}(1:2,d)] = binofit(sum(choices==1),numel(choices));
%     end
%     
%     
%     fig = figure();
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     
%     ax = nsubplot(1,2,1,1);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.25 0.50 0.75 1];
%     ax.YLim = [0 1];
%     ax.XLim = [0.5 6.5];
%     ax.XTick = [1:6];
%     
%     plot(1:3, allChoices{1}(1:3),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',7);
%     errorbar(1:3,allChoices{1}(1:3),allChoices{1}(1:3)-allChoicesCI{1}(1,1:3),allChoicesCI{1}(2,1:3)-allChoices{1}(1:3),'Color','k','LineWidth',3,'CapSize',25);
%     plot(4:6, allChoices{1}(4:6),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',7);
%     errorbar(4:6,allChoices{1}(4:6),allChoices{1}(4:6)-allChoicesCI{1}(1,4:6),allChoicesCI{1}(2,4:6)-allChoices{1}(4:6),'Color','k','LineWidth',3,'CapSize',25);
%     plot([3.5 3.5],[-10000000 1000000],'color','r','linewidth',1,'linestyle','--','yliminclude','off','xliminclude','off');
%     
%     reverseLabels = {'-3','-2','-1','1','2','3'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel({'% choice of', 'INITIAL info side'});
%     title(label1)
%     hold off;
%     axis square;
%     
%     ax = nsubplot(1,2,1,2);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.25 0.50 0.75 1];
%     ax.YLim = [0 1];
%     ax.XLim = [0.5 6.5];
%     ax.XTick = [1:6];
%     
%     plot(1:3, allChoices{2}(1:3),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',7);
%     errorbar(1:3,allChoices{2}(1:3),allChoices{2}(1:3)-allChoicesCI{1}(1,1:3),allChoicesCI{2}(2,1:3)-allChoices{2}(1:3),'Color','k','LineWidth',3,'CapSize',25);
%     plot(4:6, allChoices{2}(4:6),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',7);
%     errorbar(4:6,allChoices{2}(4:6),allChoices{1}(4:6)-allChoicesCI{2}(1,4:6),allChoicesCI{1}(2,4:6)-allChoices{2}(4:6),'Color','k','LineWidth',3,'CapSize',25);
%     plot([3.5 3.5],[-10000000 1000000],'color','r','linewidth',1,'linestyle','--','yliminclude','off','xliminclude','off');
%     
%     reverseLabels = {'-3','-2','-1','1','2','3'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel({'% choice of', 'INITIAL info side'});
%     title(label2)
%     hold off;
%     axis square;    
%     saveas(fig,fullfile(pathname,[label{1} '_ReversalMultiChoicesIISPrePost']),'pdf');
% end  
% %% PLOT MEAN CHOICES AROUND REVERSALS (single mice)
% if ~isempty(a.reverseMice) && active>0
%     fig = figure();
%     
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     
%     ax = nsubplot(1,2,1,1);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.25 0.50 0.75 1];
%     ax.YLim = [0 1];
%     ax.XLim = [0.5 4.5];
%     ax.XTick = [1 2 3 4];
%     
% %     c=linspecer(numel(idx1rev));
%     c=colorcet('C2', 'N', numel(idx1rev));
%     for m = 1:numel(idx1rev)
%         mm = idx1rev(m);
%         if ~isnan(a.reversalPrefs(mm,3))
%             plot(a.reversalPrefs(mm,:),'Color',c(m,:),'LineWidth',1,'Marker','o','MarkerFaceColor',c(m,:));                
%         end
%     end
%     for n=1:4
%     plot(n,mean(a.reversalPrefs(idx1rev,n),'omitnan'),'Color','k','LineWidth',4,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(n,mean(a.reversalPrefs(idx1rev,n),'omitnan'),sem(a.reversalPrefs(idx1rev,n)),'Color','k','LineWidth',4,'CapSize',100);
%     if n<4
%     [~,p1]=ttest(a.reversalPrefs(idx1rev,n),a.reversalPrefs(idx1rev,n+1));
%     text(n+0.5,1.05,['p=' num2str(p1)],'HorizontalAlignment','center');
%     end
%     end
%     reverseLabels = {'Info on Side 1','Info on Side 2','Info on Side 1','Info on Side 2'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel({'% choice of', 'initial info side'});
%     title(label1);
%     axis square;
%     
%     ax = nsubplot(1,2,1,2);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.25 0.50 0.75 1];
%     ax.YLim = [0 1];
%     ax.XLim = [0.5 4.5];
%     ax.XTick = [1 2 3 4];
%     hold on;
% %     c=linspecer(numel(idx2rev));
%     c=colorcet('C2', 'N', numel(idx2rev));
%     for m = 1:numel(idx2rev)
%         mm = idx2rev(m);
%         if ~isnan(a.reversalPrefs(mm,3))
%             plot(a.reversalPrefs(mm,:),'Color',c(m,:),'LineWidth',1,'Marker','o','MarkerFaceColor',c(m,:));                
%         end
%     end
%     for n=1:4
%     plot(n,mean(a.reversalPrefs(idx2rev,n),'omitnan'),'Color','k','LineWidth',4,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(n,mean(a.reversalPrefs(idx2rev,n),'omitnan'),sem(a.reversalPrefs(idx2rev,n)),'Color','k','LineWidth',4,'CapSize',100);
%     if n<4
%     [~,p2]=ttest(a.reversalPrefs(idx2rev,n),a.reversalPrefs(idx2rev,n+1));
%     text(n+0.5,1.05,['p=' num2str(p2)],'HorizontalAlignment','center');
%     end    
%     end    
%     reverseLabels = {'Info on Side 1','Info on Side 2','Info on Side 1','Info on Side 2'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel({'% choice of', 'initial info side'});
%     title(label2);
%     axis square;
%     
%     saveas(fig,fullfile(pathname,[label{1} '_ReversalChoices']),'pdf');
% end
% 
% %% PLOT MEAN CHOICES AROUND REVERSALS CURR SIDE (single mice)
% if ~isempty(a.reverseMice) && active>0
%     fig = figure();
%     
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     
%     ax = nsubplot(1,2,1,1);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.25 0.50 0.75 1];
%     ax.YLim = [0 1];
%     ax.XLim = [0.5 4.5];
%     ax.XTick = [1 2 3 4];
%     
% %     c=linspecer(numel(idx1));
%     c=colorcet('C2', 'N', numel(idx1rev));
%     for m = 1:numel(idx1rev)
%         mm = idx1rev(m);
%         if ~isnan(a.reversalPrefsCurr(mm,3))
%             plot(a.reversalPrefsCurr(mm,:),'Color',c(m,:),'LineWidth',1,'Marker','o','MarkerFaceColor',c(m,:),'MarkerSize',10);                
%         end
%     end
%     for n=1:4
%     plot(n,mean(a.reversalPrefsCurr(idx1rev,n),'omitnan'),'Color','k','LineWidth',4,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(n,mean(a.reversalPrefsCurr(idx1rev,n),'omitnan'),sem(a.reversalPrefsCurr(idx1rev,n)),'Color','k','LineWidth',4,'CapSize',100);
%     if n<4
%     [~,p1]=ttest(a.reversalPrefsCurr(idx1rev,n),a.reversalPrefsCurr(idx1rev,n+1));
%     text(n+0.5,1.05,['p=' num2str(p1)],'HorizontalAlignment','center');
%     end    
%     end
%     reverseLabels = {'Info on Side 1','Info on Side 2','Info on Side 1','Info on Side 2'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel({'% choice of', 'CURRENT info side'});
%     title(label1);
%     axis square;
%     
%     ax = nsubplot(1,2,1,2);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.25 0.50 0.75 1];
%     ax.YLim = [0 1];
%     ax.XLim = [0.5 4.5];
%     ax.XTick = [1 2 3 4];
%     hold on;
% %     c=linspecer(numel(idx2rev));
%     c=colorcet('C2', 'N', numel(idx2rev));
%     for m = 1:numel(idx2rev)
%         mm = idx2rev(m);
%         if ~isnan(a.reversalPrefsCurr(mm,3))
%             plot(a.reversalPrefsCurr(mm,:),'Color',c(m,:),'LineWidth',1,'Marker','o','MarkerFaceColor',c(m,:),'MarkerSize',10);                
%         end
%     end
%     for n=1:4
%     plot(n,mean(a.reversalPrefsCurr(idx2rev,n),'omitnan'),'Color','k','LineWidth',4,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(n,mean(a.reversalPrefsCurr(idx2rev,n),'omitnan'),sem(a.reversalPrefsCurr(idx2rev,n)),'Color','k','LineWidth',4,'CapSize',100);
%     if n<4
%     [~,p2]=ttest(a.reversalPrefsCurr(idx2rev,n),a.reversalPrefsCurr(idx2rev,n+1));
%     text(n+0.5,1.05,['p=' num2str(p2)],'HorizontalAlignment','center');
%     end      
%     end    
%     reverseLabels = {'Info on Side 1','Info on Side 2','Info on Side 1','Info on Side 2'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel({'% choice of', 'CURRENT info side'});
%     title(label2);
%     axis square;
%     
%     saveas(fig,fullfile(pathname,[label{1} '_ReversalChoicesCurr']),'pdf');
% end
%    
%% SATIETY
% if ~isempty(a.reverseMice) && active>0
%     fig = figure();
%     
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     
%     ax = nsubplot(1,2,1,1);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.25 0.5 0.75 1.0];
%     ax.YLim = [0 1];
%     ax.XLim = [0.5 3.5];
% %     ax.XTick = [1 2 3];
%     
% %     bar(1,nanmean(a.reversalRxn(:,1)));
%     for mm = 1:numel(idx1rev)
%         m=idx1rev(mm);
%         plot([1 3],[a.reversalPrefsEarly(m,1) a.reversalPrefsLate(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
%     end
%     plot(1,mean(a.reversalPrefsEarly(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(1,mean(a.reversalPrefsEarly(idx1rev,1),'omitnan'),sem(a.reversalPrefsEarly(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',100);
%     plot(3,mean(a.reversalPrefsLate(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(3,mean(a.reversalPrefsLate(idx1rev,1),'omitnan'),sem(a.reversalPrefsLate(:,1)),'Color','k','LineWidth',2,'CapSize',100);
%     xticks([1 3]);
%     xticklabels({'Early trials','Late trials'});
%     ylabel('P(info) on last session before reversal');
%     p1=ranksum(a.reversalPrefsEarly(idx1rev,1),a.reversalPrefsLate(idx1,1));
%     title([label1 ' p = ' num2str(p1)])
% 
% ax = nsubplot(1,2,1,2);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.25 0.5 0.75 1.0];
%     ax.YLim = [0 1];
%     ax.XLim = [0.5 3.5];
% %     ax.XTick = [1 2 3];
%     
% %     bar(1,nanmean(a.reversalRxn(:,1)));
%     for mm = 1:numel(idx2rev)
%         m=idx2rev(mm);
%         plot([1 3],[a.reversalPrefsEarly(m,1) a.reversalPrefsLate(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
%     end
%     plot(1,mean(a.reversalPrefsEarly(idx2rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(1,mean(a.reversalPrefsEarly(idx2rev,1),'omitnan'),sem(a.reversalPrefsEarly(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',100);
%     plot(3,mean(a.reversalPrefsLate(idx2rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(3,mean(a.reversalPrefsLate(idx2rev,1),'omitnan'),sem(a.reversalPrefsLate(:,1)),'Color','k','LineWidth',2,'CapSize',100);
%     xticks([1 3]);
%     xticklabels({'Early trials','Late trials'});
%     ylabel('P(info) on last session before reversal');
%     p2=ranksum(a.reversalPrefsEarly(idx2rev,1),a.reversalPrefsLate(idx2,1));
%     title([label2 ' p = ' num2str(p2)])
%     
%     saveas(fig,fullfile(pathname,[label{1} '_Satiety']),'pdf');
% end
% 
%% REACTION TIME

% %% REACTION SPEED REGRESSION
% if active>0
%     bothSig = a.preRevRxnSpeed(:,3)<0.05 & a.postRevRxnSpeed(:,3)<0.05;
%     for m = 1:a.mouseCt
%         if bothSig(m) == 1
%             if a.preRevRxnSpeed(m,1)>a.preRevRxnSpeed(m,2)
%                 if a.postRevRxnSpeed(m,1)>a.postRevRxnSpeed(m,2)
%                     sig(m) = 1;
%                 else
%                     sig(m) = 3;
%                 end
%             else if a.preRevRxnSpeed(m,1)<a.preRevRxnSpeed(m,2)
%                     if a.postRevRxnSpeed(m,1)<a.postRevRxnSpeed(m,2)
%                         sig(m) = 2;
%                     else
%                         sig(m) = 3;
%                     end
%                 end
%             end
%         else sig(m) = 4;
%         end
%     end
%     a.rxnSpeedIdxRev=a.rxnSpeedIdx;
% 
%     fig = figure();
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
% 
%     ax = nsubplot(1,2,1,1);
%     ax.FontSize = 8;
%     ax.XLim = [-.4 .4];
%     ax.YLim = [-.4 .4];
%     for mm = 1:numel(idx1)
%         m = idx1(mm);
%         dy = 0.01;
%         text(a.rxnSpeedIdxRev(m,1),a.rxnSpeedIdxRev(m,2) + dy,mice1{mm},'HorizontalAlignment','center');
%     end
%     plot([-10000000 1000000],[0 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
%     plot([0 0],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
%     scatter(a.rxnSpeedIdxRev(sig==1&flag1',1),a.rxnSpeedIdxRev(sig==1&flag1',2),'filled','MarkerEdgeColor','none','MarkerFaceColor',purple);
%     scatter(a.rxnSpeedIdxRev(sig==2&flag1',1),a.rxnSpeedIdxRev(sig==2&flag1',2),'filled','MarkerEdgeColor','none','MarkerFaceColor',orange);
%     scatter(a.rxnSpeedIdxRev(sig==3&flag1',1),a.rxnSpeedIdxRev(sig==3&flag1',2),'filled','MarkerEdgeColor','none','MarkerFaceColor','k');
%     scatter(a.rxnSpeedIdxRev(sig==4&flag1',1),a.rxnSpeedIdxRev(sig==4&flag1',2),'filled','MarkerEdgeColor','none','MarkerFaceColor',[.8 .8 .8]);
%     ylabel('POST-reversal (info side vs other side)');
%     xlabel('PRE-reversal (info side vs other side)');
%     title({label1,'Reaction speed indices, pre vs post-reversal', '(1 = faster reaction for info side)'});
%     hold off;
%     axis square;
% 
%     ax = nsubplot(1,2,1,2);
%     ax.FontSize = 8;
%     ax.XLim = [-.4 .4];
%     ax.YLim = [-.4 .4];
%     for mm = 1:numel(idx2rev)
%         m = idx2rev(mm);
%         dy = 0.01;
%         text(a.rxnSpeedIdxRev(m,1),a.rxnSpeedIdxRev(m,2) + dy,mice2{mm},'HorizontalAlignment','center');
%     end
%     plot([-10000000 1000000],[0 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
%     plot([0 0],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
%     scatter(a.rxnSpeedIdxRev(sig==1&flag2',1),a.rxnSpeedIdxRev(sig==1&flag2',2),'filled','MarkerEdgeColor','none','MarkerFaceColor',purple);
%     scatter(a.rxnSpeedIdxRev(sig==2&flag2',1),a.rxnSpeedIdxRev(sig==2&flag2',2),'filled','MarkerEdgeColor','none','MarkerFaceColor',orange);
%     scatter(a.rxnSpeedIdxRev(sig==3&flag2',1),a.rxnSpeedIdxRev(sig==3&flag2',2),'filled','MarkerEdgeColor','none','MarkerFaceColor','k');
%     scatter(a.rxnSpeedIdxRev(sig==4&flag2',1),a.rxnSpeedIdxRev(sig==4&flag2',2),'filled','MarkerEdgeColor','none','MarkerFaceColor',[.8 .8 .8]);
%     ylabel('POST-reversal (info side vs other side)');
%     xlabel('PRE-reversal (info side vs other side)');
%     title({label2,'Reaction speed indices, pre vs post-reversal', '(1 = faster reaction for info side)'});
%     hold off;
%     axis square;
%     
%     saveas(fig,fullfile(pathname,[label{1} '_PrevsPostRxn']),'pdf');
% %     close(fig);
% end
% 
% %% REACTION SPEED PLOT
% if ~isempty(a.reverseMice) && active>0
%     fig = figure();
%     
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     
%     ax = nsubplot(1,2,1,1);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.500 1.000 1.500];
%     ax.YLim = [0 1.5];
%     ax.XLim = [0.5 3.5];
% %     ax.XTick = [1 2 3];
%     
% %     bar(1,nanmean(a.reversalRxn(:,1)));
%     for mm = 1:numel(idx1rev)
%         m=idx1rev(mm);
%         plot([1 3],[a.reversalRxnInfo(m,1) a.reversalRxnRand(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
%     end
%     plot(1,mean(a.reversalRxnInfo(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(1,mean(a.reversalRxnInfo(idx1rev,1),'omitnan'),sem(a.reversalRxnInfo(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',100);
%     plot(3,mean(a.reversalRxnRand(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(3,mean(a.reversalRxnRand(idx1rev,1),'omitnan'),sem(a.reversalRxnRand(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',100);
%     xticks([1 3]);
%     xticklabels({'Info','No Info'});
%     ylabel('Reaction time on last session before reversal');
%     [~,p1]=ttest(a.reversalRxnInfo(idx1rev,1),a.reversalRxnRand(idx1,1));
%     title([label1 ' p = ' num2str(p1)])
% 
%     ax = nsubplot(1,2,1,2);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.500 1.000 1.500];
%     ax.YLim = [0 1.5];;
%     ax.XLim = [0.5 3.5];
% %     ax.XTick = [1 2 3];
%     
% %     bar(1,nanmean(a.reversalRxn(:,1)));
%     for mm = 1:numel(idx2rev)
%         m=idx2rev(mm);
%         plot([1 3],[a.reversalRxnInfo(m,1) a.reversalRxnRand(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
%     end
%     plot(1,nanmean(a.reversalRxnInfo(idx2rev,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(1,nanmean(a.reversalRxnInfo(idx2rev,1)),sem(a.reversalRxnInfo(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',100);
%     plot(3,nanmean(a.reversalRxnRand(idx2rev,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(3,nanmean(a.reversalRxnRand(idx2rev,1)),sem(a.reversalRxnRand(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',100);
%     xticks([1 3]);
%     xticklabels({'Info','No Info'});
%     ylabel('Reaction time on last session before reversal');
%     [~,p2]=ttest(a.reversalRxnInfo(idx2rev,1),a.reversalRxnRand(idx2rev,1));
%     title([label2 ' p = ' num2str(p2)])
%     
%     saveas(fig,fullfile(pathname,[label{1} '_ReactionTime']),'pdf');
% end
% 
% 
% %% REACTION SPEED PLOT FORCED CHOICE
% if ~isempty(a.reverseMice) && active>0
%     fig = figure();
%     
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     
%     ax = nsubplot(2,2,1,1);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.500 1.000 1.500];
%     ax.YLim = [0 1.5];
%     ax.XLim = [0.5 3.5];
% %     ax.XTick = [1 2 3];
%     
% %     bar(1,nanmean(a.reversalRxn(:,1)));
%     for mm = 1:numel(idx1rev)
%         m=idx1rev(mm);
%         plot([1 3],[a.reversalRxnInfo(m,1) a.reversalRxnInfoChoice(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
%     end
%     plot(1,nanmean(a.reversalRxnInfo(idx1rev,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(1,nanmean(a.reversalRxnInfo(idx1rev,1)),sem(a.reversalRxnInfo(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',50);
%     plot(3,nanmean(a.reversalRxnInfoChoice(idx1rev,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(3,nanmean(a.reversalRxnInfoChoice(idx1rev,1)),sem(a.reversalRxnInfoChoice(:,1)),'Color','k','LineWidth',2,'CapSize',50);
%     xticks([1 3]);
%     xticklabels({'Info forced','Info Choice'});
%     ylabel('Reaction time on last session before reversal');
%     [~,p1]=ttest(a.reversalRxnInfo(idx1rev,1),a.reversalRxnInfoChoice(idx1rev,1));
%     title([label1 ' p = ' num2str(p1)])
% 
%     ax = nsubplot(2,2,1,2);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.500 1.000 1.500];
%     ax.YLim = [0 1.5];;
%     ax.XLim = [0.5 3.5];
% %     ax.XTick = [1 2 3];
%     
% %     bar(1,nanmean(a.reversalRxn(:,1)));
%     for mm = 1:numel(idx1rev)
%         m=idx1rev(mm);
%         plot([1 3],[a.reversalRxnRand(m,1) a.reversalRxnRandChoice(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
%     end
%     plot(1,nanmean(a.reversalRxnRand(idx1rev,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(1,nanmean(a.reversalRxnRand(idx1rev,1)),sem(a.reversalRxnRand(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',50);
%     plot(3,nanmean(a.reversalRxnRandChoice(idx1rev,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(3,nanmean(a.reversalRxnRandChoice(idx1rev,1)),sem(a.reversalRxnRandChoice(:,1)),'Color','k','LineWidth',2,'CapSize',50);
%     xticks([1 3]);
%     xticklabels({'No Info Forced','No Info Choice'});
%     ylabel('Reaction time on last session before reversal');
%     [~,p2]=ttest(a.reversalRxnRand(idx1rev,1),a.reversalRxnRandChoice(idx1rev,1));
%     title([label1 ' p = ' num2str(p2)])
%     
%     ax = nsubplot(2,2,2,1);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.500 1.000 1.500];
%     ax.YLim = [0 1.5];
%     ax.XLim = [0.5 3.5];
% %     ax.XTick = [1 2 3];
%     
% %     bar(1,nanmean(a.reversalRxn(:,1)));
%     for mm = 1:numel(idx2rev)
%         m=idx2rev(mm);
%         plot([1 3],[a.reversalRxnInfo(m,1) a.reversalRxnInfoChoice(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
%     end
%     plot(1,nanmean(a.reversalRxnInfo(idx2rev,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(1,nanmean(a.reversalRxnInfo(idx2rev,1)),sem(a.reversalRxnInfo(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',50);
%     plot(3,nanmean(a.reversalRxnInfoChoice(idx2rev,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(3,nanmean(a.reversalRxnInfoChoice(idx2rev,1)),sem(a.reversalRxnInfoChoice(:,1)),'Color','k','LineWidth',2,'CapSize',50);
%     xticks([1 3]);
%     xticklabels({'Info forced','Info Choice'});
%     ylabel('Reaction time on last session before reversal');
%     [~,p1]=ttest(a.reversalRxnInfo(idx2rev,1),a.reversalRxnInfoChoice(idx2rev,1));
%     title([label2 ' p = ' num2str(p1)])
% 
%     ax = nsubplot(2,2,2,2);
%     ax.FontSize = 8;
%     ax.YTick = [0 0.500 1.000 1.500];
%     ax.YLim = [0 1.5];;
%     ax.XLim = [0.5 3.5];
% %     ax.XTick = [1 2 3];
%     
% %     bar(1,nanmean(a.reversalRxn(:,1)));
%     for mm = 1:numel(idx2rev)
%         m=idx2rev(mm);
%         plot([1 3],[a.reversalRxnRand(m,1) a.reversalRxnRandChoice(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
%     end
%     plot(1,nanmean(a.reversalRxnRand(idx2rev,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(1,nanmean(a.reversalRxnRand(idx2rev,1)),sem(a.reversalRxnRand(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',50);
%     plot(3,nanmean(a.reversalRxnRandChoice(idx2rev,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(3,nanmean(a.reversalRxnRandChoice(idx2rev,1)),sem(a.reversalRxnRandChoice(:,1)),'Color','k','LineWidth',2,'CapSize',50);
%     xticks([1 3]);
%     xticklabels({'No Info Forced','No Info Choice'});
%     ylabel('Reaction time on last session before reversal');
%     [~,p2]=ttest(a.reversalRxnRand(idx2rev,1),a.reversalRxnRandChoice(idx2rev,1));
%     title([label2 ' p = ' num2str(p2)])
%     
%     
%     saveas(fig,fullfile(pathname,[label{1} '_ReactionTimeChoice']),'pdf');
% end
% 
% 
% %% REACTION TIME PLOT ALL DAYS
% 
%     fig = figure();
%     
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     
%     ax = nsubplot(1,2,1,1);
%     ax.FontSize = 8;
% %     ax.YTick = [0 500 1000 1500];
% %     ax.YLim = [300 1300];
%     ax.XLim = [0.5 3.5];
% %     ax.XTick = [1 2 3];
%     
% %     bar(1,nanmean(a.reversalRxn(:,1)));
%     for mm = 1:numel(idx1)
%         m=idx1(mm);
%         plot([1 3],[a.rxnMean(m,1) a.rxnMean(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
%     end
%     plot(1,nanmean(a.rxnMean(idx1,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(1,nanmean(a.rxnMean(idx1,1)),sem(a.rxnMean(idx1,1)),'Color','k','LineWidth',2,'CapSize',100);
%     plot(3,nanmean(a.rxnMean(idx1,2)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(3,nanmean(a.rxnMean(idx1,2)),sem(a.rxnMean(idx1,2)),'Color','k','LineWidth',2,'CapSize',100);
%     xticks([1 3]);
%     xticklabels({'Info','No Info'});
%     ylabel('Reaction time across all preference days');
%     [~,p1]=ttest(a.rxnMean(idx1,1),a.rxnMean(idx1,2));
%     title([label1 ' p = ' num2str(p1)])
% 
%     ax = nsubplot(1,2,1,2);
%     ax.FontSize = 8;
% %     ax.YTick = [0 500 1000 1500];
% %     ax.YLim = [300 1300];
%     ax.XLim = [0.5 3.5];
% %     ax.XTick = [1 2 3];
%     
% %     bar(1,nanmean(a.reversalRxn(:,1)));
%     for mm = 1:numel(idx2)
%         m=idx2(mm);
%         plot([1 3],[a.rxnMean(m,1) a.rxnMean(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
%     end
%     plot(1,nanmean(a.rxnMean(idx2,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(1,nanmean(a.rxnMean(idx2,1)),sem(a.rxnMean(idx2,1)),'Color','k','LineWidth',2,'CapSize',100);
%     plot(3,nanmean(a.rxnMean(idx2,2)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
%     errorbar(3,nanmean(a.rxnMean(idx2,2)),sem(a.rxnMean(idx2,2)),'Color','k','LineWidth',2,'CapSize',100);
%     xticks([1 3]);
%     xticklabels({'Info','No Info'});
%     ylabel('Reaction time across all preference days');
%     [~,p2]=ttest(a.rxnMean(idx2,1),a.rxnMean(idx2,2));
%     title([label2 ' p = ' num2str(p2)])
%     
%     saveas(fig,fullfile(pathname,[label{1} '_ReactionTimeAllDays']),'pdf');  
% 
%% LICKS
% %% PLOT LICKS AROUND REVERSALS
% 
% % if numel(a.reverseMice) > 1
%     fig = figure();
% 
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     
%     reverseLabels = {'Info on Side 1','Info on Side 2','Info on Side 1','Info on Side 2'};
% 
%     ax = nsubplot(2,2,1,1);
%     ax.FontSize = 8;
%     %     ax.YTick = [0 0.25 0.50 0.75 1];
%     %     ax.YLim = [0 40];
%     ax.XLim = [0.5 4.5];
%     ax.XTick = [1 2 3 4];
% 
%     plot(nanmean(a.reversalInfoBigEarlyLicks(idx1rev,:)),'Color','g','LineWidth',3,'Marker','o','MarkerFaceColor','g','MarkerSize',5); 
%     plot(nanmean(a.reversalInfoSmallEarlyLicks(idx1rev,:)),'Color','m','LineWidth',3,'Marker','o','MarkerFaceColor','m','MarkerSize',5); 
%     plot(nanmean(a.reversalRandCEarlyLicks(idx1rev,:)),'Color',cornflower,'LineWidth',3,'Marker','o','MarkerFaceColor',cornflower,'MarkerSize',5); 
%     plot(nanmean(a.reversalRandDEarlyLicks(idx1rev,:)),'Color',cornflower,'LineWidth',3,'LineStyle','--','Marker','o','MarkerFaceColor',cornflower,'MarkerSize',5); 
% %     reverseLabels = {'Pre-reversal','Reversal','Post-reversal'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel('Mean Pre-Odor Licks');
%     title(label1)
%     hold off;
%     
%     ax = nsubplot(2,2,1,2);
%     ax.FontSize = 8;
%     %     ax.YTick = [0 0.25 0.50 0.75 1];
%     %     ax.YLim = [0 40];
%     ax.XLim = [0.5 4.5];
%     ax.XTick = [1 2 3 4];
% 
%     plot(nanmean(a.reversalInfoBigEarlyLicks(idx2rev,:)),'Color','g','LineWidth',3,'Marker','o','MarkerFaceColor','g','MarkerSize',5); 
%     plot(nanmean(a.reversalInfoSmallEarlyLicks(idx2rev,:)),'Color','m','LineWidth',3,'Marker','o','MarkerFaceColor','m','MarkerSize',5); 
%     plot(nanmean(a.reversalRandCEarlyLicks(idx2rev,:)),'Color',cornflower,'LineWidth',3,'Marker','o','MarkerFaceColor',cornflower,'MarkerSize',5); 
%     plot(nanmean(a.reversalRandDEarlyLicks(idx2rev,:)),'Color',cornflower,'LineWidth',3,'LineStyle','--','Marker','o','MarkerFaceColor',cornflower,'MarkerSize',5); 
% %     reverseLabels = {'Pre-reversal','Reversal','Post-reversal'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel('Mean Pre-Odor Licks');
%     title(label2)
%     hold off;    
% 
%     ax = nsubplot(2,2,2,1);
%     ax.FontSize = 8;
%     %     ax.YTick = [0 0.25 0.50 0.75 1];
%     %     ax.YLim = [0 40];
%     ax.XLim = [0.5 4.5];
%     ax.XTick = [1 2 3 4];
% 
%     plot(nanmean(a.reversalInfoBigLicks(idx1rev,:)),'Color','g','LineWidth',3,'Marker','o','MarkerFaceColor','g','MarkerSize',5); 
%     plot(nanmean(a.reversalInfoSmallLicks(idx1rev,:)),'Color','m','LineWidth',3,'Marker','o','MarkerFaceColor','m','MarkerSize',5); 
%     plot(nanmean(a.reversalRandCLicks(idx1rev,:)),'Color',cornflower,'LineWidth',3,'Marker','o','MarkerFaceColor',cornflower,'MarkerSize',5); 
%     plot(nanmean(a.reversalRandDLicks(idx1rev,:)),'Color',cornflower,'LineWidth',3,'LineStyle','--','Marker','o','MarkerFaceColor',cornflower,'MarkerSize',5);    
% %     reverseLabels = {'Pre-reversal','Reversal','Post-reversal'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel('Mean Anticipatory Licks');
%     title(label1)
%     hold off; 
%     
%     ax = nsubplot(2,2,2,2);
%     ax.FontSize = 8;
%     %     ax.YTick = [0 0.25 0.50 0.75 1];
%     %     ax.YLim = [0 40];
%     ax.XLim = [0.5 4.5];
%     ax.XTick = [1 2 3 4];
% 
%     plot(nanmean(a.reversalInfoBigLicks(idx2rev,:)),'Color','g','LineWidth',3,'Marker','o','MarkerFaceColor','g','MarkerSize',5); 
%     plot(nanmean(a.reversalInfoSmallLicks(idx2rev,:)),'Color','m','LineWidth',3,'Marker','o','MarkerFaceColor','m','MarkerSize',5); 
%     plot(nanmean(a.reversalRandCLicks(idx2rev,:)),'Color',cornflower,'LineWidth',3,'Marker','o','MarkerFaceColor',cornflower,'MarkerSize',5); 
%     plot(nanmean(a.reversalRandDLicks(idx2rev,:)),'Color',cornflower,'LineWidth',3,'LineStyle','--','Marker','o','MarkerFaceColor',cornflower,'MarkerSize',5);    
% %     reverseLabels = {'Pre-reversal','Reversal','Post-reversal'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel('Mean Anticipatory Licks');
%     title(label2)
%     hold off;     
%     
%     saveas(fig,fullfile(pathname,[label{1} '_ReversalMeanLicks']),'pdf');
% % end
% 
% %% PLOT LICKS AROUND REVERSALS
% 
% % % if numel(a.reverseMice) > 1
% %     fig = figure();
% % 
% %     fig = gcf;
% %     fig.PaperUnits = 'inches';
% %     fig.PaperPosition = [0.5 0.5 10 7];
% %     set(fig,'renderer','painters');
% %     set(fig,'PaperOrientation','landscape');
% %     
% %     reverseLabels = {'Info on Side 1','Info on Side 2','Info on Side 1'};
% % 
% %     ax = nsubplot(2,2,1,1);
% %     ax.FontSize = 8;
% %     %     ax.YTick = [0 0.25 0.50 0.75 1];
% %     %     ax.YLim = [0 40];
% %     ax.XLim = [0.5 3.5];
% %     ax.XTick = [1 2 3];
% %     hold on;
% %     plot(mean(a.reversalInfoBigEarlyLicks(idx1rev,1:3),'omitnan'),'Color','g','LineWidth',3,'Marker','o','MarkerFaceColor','g','MarkerSize',5); 
% %     plot(mean(a.reversalInfoSmallEarlyLicks(idx1rev,1:3),'omitnan'),'Color','m','LineWidth',3,'Marker','o','MarkerFaceColor','m','MarkerSize',5); 
% %     plot(mean(a.reversalRandCEarlyLicks(idx1rev,1:3),'omitnan'),'Color',cornflower,'LineWidth',3,'Marker','o','MarkerFaceColor',cornflower,'MarkerSize',5); 
% %     plot(mean(a.reversalRandDEarlyLicks(idx1rev,1:3),'omitnan'),'Color',cornflower,'LineWidth',3,'LineStyle','--','Marker','o','MarkerFaceColor',cornflower,'MarkerSize',5); 
% %     for n=1:3
% %         plot(n,mean(a.reversalInfoBigEarlyLicks(idx1rev,n),'omitnan'),'Marker','o','MarkerFaceColor','g','MarkerSize',6);
% %         errorbar(n,mean(a.reversalInfoBigEarlyLicks(idx1rev,n),'omitnan'),sem(a.reversalInfoBigEarlyLicks(idx1rev,n)),'Color','g','LineWidth',4,'CapSize',50);
% %         errorbar(n,mean(a.reversalInfoSmallEarlyLicks(idx1rev,n),'omitnan'),sem(a.reversalInfoSmallEarlyLicks(idx1rev,n)),'Color','m','LineWidth',4,'CapSize',50);
% %         errorbar(n,mean(a.reversalRandCEarlyLicks(idx1rev,n),'omitnan'),sem(a.reversalRandCEarlyLicks(idx1rev,n)),'Color',cornflower,'LineWidth',4,'CapSize',50);
% %         errorbar(n,mean(a.reversalRandDEarlyLicks(idx1rev,n),'omitnan'),sem(a.reversalRandDEarlyLicks(idx1rev,n)),'Color',cornflower,'LineWidth',4,'CapSize',50);
% %     end
% % %     reverseLabels = {'Pre-reversal','Reversal','Post-reversal'};
% %     set(gca,'XTickLabel',reverseLabels);
% %     ylabel('Mean Pre-Odor Licks');
% %     title(label1)
% %     hold off;
% 
% %%
%     licks=[a.reversalInfoBigLicks(idx1rev,1);a.reversalRandCLicks(idx1rev,1);a.reversalRandDLicks(idx1rev,1);a.reversalInfoSmallLicks(idx1rev,1)];
%     tt=[ones(size(idx1rev))*1;ones(size(idx1rev))*2;ones(size(idx1rev))*3;ones(size(idx1rev))*4];
%     [a.lickp1,~,stats] =anova1(licks,tt);
% %     aov=anova(tt,licks);
% %     c1=multcompare(aov);
%     a.lickc1 = multcompare(stats);
%     
%     licks=[a.reversalInfoBigLicks(idx1rev,2);a.reversalRandCLicks(idx1rev,2);a.reversalRandDLicks(idx1rev,2);a.reversalInfoSmallLicks(idx1rev,2)];
%     tt=[ones(size(idx1rev))*1;ones(size(idx1rev))*2;ones(size(idx1rev))*3;ones(size(idx1rev))*4];
%     [a.lickp2,~,stats] =anova1(licks,tt);
% %     aov=anova(tt,licks);
% %     c1=multcompare(aov);
%     a.lickc2 = multcompare(stats);
%     
% %%
% 
%     fig = figure();
% 
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     
%     licklabels={'Info Water', 'No Info C','No Info D','Info No Water'};
%     
%     ax = nsubplot(2,2,1,1);
%     ax.FontSize = 8;
%     ax.XLim = [0.5 2.5];
%     ax.XTick = [1 2];
%     ax.YLim = [0 1.5];
%     hold on;
%     v1=Violin(a.reversalInfoEarlyLicks(idx1rev,1),1);
%     v2=Violin(a.reversalRandEarlyLicks(idx1rev,1),2);
%     [h,p]=ttest2(a.reversalInfoEarlyLicks(idx1rev,1),a.reversalRandEarlyLicks(idx1rev,1));
%    v1.ViolinColor='b'; 
%    v1.EdgeColor='none'; 
%    v1.BoxColor='none';
%    v1.ScatterPlot.MarkerFaceColor='k';
%    v1.ScatterPlot.MarkerFaceAlpha=1;
%    v1.ShowMean=true;
%    v2.ViolinColor='r'; 
%    v2.EdgeColor='none'; 
%    v2.BoxColor='none';
%    v2.ScatterPlot.MarkerFaceColor='k';
%    v2.ScatterPlot.MarkerFaceAlpha=1;
%    v2.ShowMean=true;
%     ax.XTickLabel={'Info','No Info'};
%     ylabel('Mean Pre-Odor Licks');
%     title([label1 ' Pre-reverse p = ' num2str(p)])
%     hold off;
%     
%     ax = nsubplot(2,2,1,2);
%     ax.FontSize = 8;
%     ax.XLim = [0.5 2.5];
%     ax.XTick = [1 2];
%     ax.YLim = [0 1.5];
%     hold on;
%     v1=Violin(a.reversalInfoEarlyLicks(idx1rev,2),1);
%     v2=Violin(a.reversalRandEarlyLicks(idx1rev,2),2);
%         [h,p]=ttest2(a.reversalInfoEarlyLicks(idx1rev,2),a.reversalRandEarlyLicks(idx1rev,2));
%    v1.ViolinColor='b'; 
%    v1.EdgeColor='none'; 
%    v1.BoxColor='none';
%    v1.ScatterPlot.MarkerFaceColor='k';
%    v1.ScatterPlot.MarkerFaceAlpha=1;
%    v1.ShowMean=true;
%    v2.ViolinColor='r'; 
%    v2.EdgeColor='none'; 
%    v2.BoxColor='none';
%    v2.ScatterPlot.MarkerFaceColor='k';
%    v2.ScatterPlot.MarkerFaceAlpha=1;
%    v2.ShowMean=true;
%     ax.XTickLabel={'Info','No Info'};
%     ylabel('Mean Pre-Odor Licks');
%     title([label1 ' Post-reverse p = ' num2str(p)])
%     hold off;
%     
%     ax = nsubplot(2,2,2,1);
%     ax.FontSize = 8;
%     ax.XLim = [0.5 4.5];
%     ax.XTick = [1 2 3 4];
% %     ax.YLim = [0 1.5];
%     hold on;
%     
%     v1=Violin(a.reversalInfoBigLicks(idx1rev,1),1);
%     v2=Violin(a.reversalInfoSmallLicks(idx1rev,1),4);
%     v3=Violin(a.reversalRandCLicks(idx1rev,1),2);
%     v4=Violin(a.reversalRandDLicks(idx1rev,1),3);
%    v1.ViolinColor='g'; 
%    v1.EdgeColor='none'; 
%    v1.BoxColor='none';
%    v1.ScatterPlot.MarkerFaceColor='k';
%    v1.ScatterPlot.MarkerFaceAlpha=1;
%    v1.ShowMean=true;
%    v2.ViolinColor='m'; 
%    v2.EdgeColor='none'; 
%    v2.BoxColor='none';
%    v2.ScatterPlot.MarkerFaceColor='k';
%    v2.ScatterPlot.MarkerFaceAlpha=1;
%    v2.ShowMean=true;
%    v3.ViolinColor=cornflower; 
%    v3.EdgeColor='none'; 
%    v3.BoxColor='none';
%    v3.ScatterPlot.MarkerFaceColor='k';
%    v3.ScatterPlot.MarkerFaceAlpha=1;
%    v3.ShowMean=true;
%    v4.ViolinColor=cornflower; 
%    v4.EdgeColor='none'; 
%    v4.BoxColor='none';
%    v4.ScatterPlot.MarkerFaceColor='k';
%    v4.ScatterPlot.MarkerFaceAlpha=1;
%    v4.ShowMean=true;   
%     ax.XTickLabel=licklabels;
%     ylabel('Mean Pre-Outcome Licks');
%     title([label1 ' Pre-reverse p ANOVA = ' num2str(a.lickp1)])
%     hold off;
%     
%     ax = nsubplot(2,2,2,2);
%     ax.FontSize = 8;
%     ax.XLim = [0.5 4.5];
%     ax.XTick = [1 2 3 4];
% %     ax.YLim = [0 1.5];
%     hold on;
%     v1=Violin(a.reversalInfoBigLicks(idx1rev,2),1);
%     v2=Violin(a.reversalInfoSmallLicks(idx1rev,2),4);
%     v3=Violin(a.reversalRandCLicks(idx1rev,2),2);
%     v4=Violin(a.reversalRandDLicks(idx1rev,2),3);
%    v1.ViolinColor='g'; 
%    v1.EdgeColor='none'; 
%    v1.BoxColor='none';
%    v1.ScatterPlot.MarkerFaceColor='k';
%    v1.ScatterPlot.MarkerFaceAlpha=1;
%    v1.ShowMean=true;
%    v2.ViolinColor='m'; 
%    v2.EdgeColor='none'; 
%    v2.BoxColor='none';
%    v2.ScatterPlot.MarkerFaceColor='k';
%    v2.ScatterPlot.MarkerFaceAlpha=1;
%    v2.ShowMean=true;
%    v3.ViolinColor=cornflower; 
%    v3.EdgeColor='none'; 
%    v3.BoxColor='none';
%    v3.ScatterPlot.MarkerFaceColor='k';
%    v3.ScatterPlot.MarkerFaceAlpha=1;
%    v3.ShowMean=true;
%    v4.ViolinColor=cornflower; 
%    v4.EdgeColor='none'; 
%    v4.BoxColor='none';
%    v4.ScatterPlot.MarkerFaceColor='k';
%    v4.ScatterPlot.MarkerFaceAlpha=1;
%    v4.ShowMean=true;   
%     ax.XTickLabel=licklabels;
%     ylabel('Mean Pre-Outcome Licks');
%     title([label1 ' Post-reverse ANOVA p = ' num2str(a.lickp2)])
%     hold off;    
%     
%     saveas(fig,fullfile(pathname,[label1 '_ReversalMeanLicksStats']),'pdf');
% % end
% 
% %% PLOT EARLY LICK IDX AROUND REVERSALS
% 
% % if numel(a.reverseMice) > 1
%     fig = figure();
%     
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     
%     ax = nsubplot(1,2,1,1);
%     ax.FontSize = 8;
%     ax.XLim = [0.5 4.5];
%     ax.XTick = [1 2 3 4];
%     
%     c=colorcet('C2', 'N', numel(idx1rev));
%     for n=1:4
%        plot(n,nanmean(a.reversalLicks(idx1rev,n)),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',10); 
%        errorbar(n,nanmean(a.reversalLicks(idx1rev,n)),sem(a.reversalLicks(idx1rev,n)),'Color','k','LineWidth',2,'CapSize',100);
%     end
%     for mm = 1:numel(idx1rev)
%         m=idx1rev(mm);
%         if ~isnan(a.reversalPrefs(m,3))
%             plot(a.reversalLicks(m,:),'Color',c(mm,:),'LineWidth',1,'Marker','o','MarkerFaceColor',c(mm,:),'MarkerSize',10);
%         end
%     end
%     reverseLabels = {'Info on Side 1','Info on Side 2','Info on Side 1','Info on Side 2'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel('Early Lick Index');
%     title(label1);
%     
%     ax = nsubplot(1,2,1,2);
%     ax.FontSize = 8;
%     ax.XLim = [0.5 4.5];
%     ax.XTick = [1 2 3 4];    
%     c=colorcet('C2', 'N', numel(idx2rev));
%     for n=1:4
%        plot(n,nanmean(a.reversalLicks(idx2rev,n)),'Color','k','LineWidth',3,'Marker','o','MarkerFaceColor','k','MarkerSize',10); 
%        errorbar(n,nanmean(a.reversalLicks(idx2rev,n)),sem(a.reversalLicks(idx2rev,n)),'Color','k','LineWidth',2,'CapSize',100);
%     end
%     for mm = 1:numel(idx2rev)
%         m=idx2rev(mm);
%         if ~isnan(a.reversalPrefs(m,3))
%             plot(a.reversalLicks(m,:),'Color',c(mm,:),'LineWidth',1,'Marker','o','MarkerFaceColor',c(mm,:),'MarkerSize',10);
%         end
%     end
%     reverseLabels = {'Info on Side 1','Info on Side 2','Info on Side 1','Info on Side 2'};
%     set(gca,'XTickLabel',reverseLabels);
%     ylabel('Early Lick Index');
%     title(label2);    
% 
% %     ax = nsubplot(1,2,1,2);
% %     ax.FontSize = 8;
% %     ax.XLim = [0.5 4.5];
% %     ax.XTick = [1 2 3 4];
% %     v=violinplot(a.reversalLicks(idx1rev,:)); %,[],'EdgeColor','none'
% %     for i=1:4
% %        v(i).ViolinColor=[0.4 0.4 0.4]; 
% %        v(i).EdgeColor='none'; 
% %        v(i).BoxColor='none';
% %        v(i).ScatterPlot.MarkerFaceColor='k';
% %        v(i).ScatterPlot.MarkerFaceAlpha=1;
% %        v(i).ShowMean=true;
% %     end
%     
%     saveas(fig,fullfile(pathname,[label{1} '_ReversalLicks']),'pdf');
% % end
% 
% %% EARLY LICKS REGRESSION
% if ~isempty(a.reverseMice)
%     bothSig = a.preRevEarlyLicks(:,3)<0.05 & a.postRevEarlyLicks(:,3)<0.05;
% 
%     for m = 1:a.mouseCt
%         if bothSig(m) == 1
%             if a.preRevEarlyLicks(m,1)>a.preRevEarlyLicks(m,2)
%                 if a.postRevEarlyLicks(m,1)>a.preRevEarlyLicks(m,2)
%                     sig(m) = 2;
%                 else
%                     sig(m) = 3;
%                 end
%             else if a.preRevEarlyLicks(m,1)<a.preRevEarlyLicks(m,2)
%                     if a.postRevEarlyLicks(m,1)<a.postRevEarlyLicks(m,2)
%                         sig(m) = 1;
%                     else
%                         sig(m) = 3;
%                     end
%                 end
%             end
%         else sig(m) = 4;
%         end
%     end
%     
%     a.earlyLickIdxRev = a.earlyLickIdx;
% 
%     fig = figure();
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0.5 0.5 10 7];
%     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
% 
%     ax = nsubplot(1,2,1,1);
%     ax.FontSize = 8;
%     ax.XLim = [-1.1 1.1];
%     ax.YLim = [-1.1 1.1];
%     for l = 1:numel(idx1)
%         m = idx1(l);
%         dy = 0.02;
%         text(a.earlyLickIdx(m,1),a.earlyLickIdx(m,2) + dy,mice1{l},'HorizontalAlignment','center');
%     end
%     plot([-10000000 1000000],[0 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
%     plot([0 0],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% %     reverseSig1=sig(idx1);
%     scatter(a.earlyLickIdxRev(sig==1&flag1',1),a.earlyLickIdxRev(sig==1&flag1',2),'filled','MarkerEdgeColor','none','MarkerFaceColor',orange);
%     scatter(a.earlyLickIdxRev(sig==2&flag1',1),a.earlyLickIdxRev(sig==2&flag1',2),'filled','MarkerEdgeColor','none','MarkerFaceColor',purple);
%     scatter(a.earlyLickIdxRev(sig==3&flag1',1),a.earlyLickIdxRev(sig==3&flag1',2),'filled','MarkerEdgeColor','none','MarkerFaceColor','k');
%     scatter(a.earlyLickIdxRev(sig==4&flag1',1),a.earlyLickIdxRev(sig==4&flag1',2),'filled','MarkerEdgeColor','none','MarkerFaceColor',[.8 .8 .8]);
%     ylabel('POST-reversal (info side vs other side)');
%     xlabel('PRE-reversal (info side vs other side)');
%     title({'Pre-odor2 lick indices, pre vs post-reversal', '(-1 = lick more for no info side)',label1});
%     hold off;
%     axis square;
%     
%     ax = nsubplot(1,2,1,2);
%     ax.FontSize = 8;
%     ax.XLim = [-1.1 1.1];
%     ax.YLim = [-1.1 1.1];
%     for l = 1:numel(idx2)
%         m = idx2(l);
%         dy = 0.02;
%         text(a.earlyLickIdx(m,1),a.earlyLickIdx(m,2) + dy,mice2{l},'HorizontalAlignment','center');
%     end
%     plot([-10000000 1000000],[0 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
%     plot([0 0],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% %     reverseSig2=sig(idx2);
%     scatter(a.earlyLickIdxRev(sig==1&flag2',1),a.earlyLickIdxRev(sig==1&flag2',2),'filled','MarkerEdgeColor','none','MarkerFaceColor',orange);
%     scatter(a.earlyLickIdxRev(sig==2&flag2',1),a.earlyLickIdxRev(sig==2&flag2',2),'filled','MarkerEdgeColor','none','MarkerFaceColor',purple);
%     scatter(a.earlyLickIdxRev(sig==3&flag2',1),a.earlyLickIdxRev(sig==3&flag2',2),'filled','MarkerEdgeColor','none','MarkerFaceColor','k');
%     scatter(a.earlyLickIdxRev(sig==4&flag2',1),a.earlyLickIdxRev(sig==4&flag2',2),'filled','MarkerEdgeColor','none','MarkerFaceColor',[.8 .8 .8]);
%     ylabel('POST-reversal (info side vs other side)');
%     xlabel('PRE-reversal (info side vs other side)');
%     title({'Pre-odor2 lick indices, pre vs post-reversal', '(-1 = lick more for no info side)',label2});
%     hold off;
%     axis square;    
% 
%     saveas(fig,fullfile(pathname,[label{1} '_PrevsPostEarlyLicks']),'pdf');
% % %     close(fig);
% end
% 
%% NOT PRESENT / LEAVING

    figure();
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0.5 0.5 10 7];
    set(fig,'renderer','painters');
    set(fig,'PaperOrientation','landscape');
    
    ax = nsubplot(1,2,1,1);    
    ax.FontSize = 8;
    ylabel('% trials not present in reward port at outcome');    
    ax.YTick = [0 0.25 0.50 0.75 1];
    ax.YLim = [0 1];    
    c=colorcet('C2', 'N', 8);
%     bar(mean(a.incomplete),'FaceColor','none','EdgeColor','k');
    hold on;
%     plot(a.incomplete','Linestyle','none','Marker','o');
    v=violinplot(a.incomplete(idx1,:)); %,[],'EdgeColor','none'
    for i=1:8
       v(i).ViolinColor=[0.4 0.4 0.4]; 
       v(i).EdgeColor='none'; 
       v(i).BoxColor='none';
       v(i).ScatterPlot.MarkerFaceColor='k';
       v(i).ScatterPlot.MarkerFaceAlpha=1;
       v(i).ShowMean=true;
    end
    title(label1);
    set(gca,'XTickLabel',a.choiceLabels,'XTick',[1:8]);
    axis square;
    
    ax = nsubplot(1,2,1,2);    
    ax.FontSize = 8;
    ylabel('% trials not present in reward port at outcome');    
    ax.YTick = [0 0.25 0.50 0.75 1];
    ax.YLim = [0 1];    
    c=colorcet('C2', 'N', 8);
%     bar(mean(a.incomplete),'FaceColor','none','EdgeColor','k');
    hold on;
%     plot(a.incomplete','Linestyle','none','Marker','o');
    v=violinplot(a.incomplete(idx2,:)); %,[],'EdgeColor','none'
    for i=1:8
       v(i).ViolinColor=[0.4 0.4 0.4]; 
       v(i).EdgeColor='none'; 
       v(i).BoxColor='none';
       v(i).ScatterPlot.MarkerFaceColor='k';
       v(i).ScatterPlot.MarkerFaceAlpha=1;
       v(i).ShowMean=true;
    end
    title(label2);
    set(gca,'XTickLabel',a.choiceLabels,'XTick',[1:8]);
    axis square;
    
    saveas(fig,fullfile(pathname,[label{1} '_notPresentMeanViolin']),'pdf');
    
    figure();
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0.5 0.5 10 7];
    set(fig,'renderer','painters');
    set(fig,'PaperOrientation','landscape');
    
    ax = nsubplot(1,2,1,1);    
    ax.FontSize = 8;
    ylabel('% trials not present in reward port at outcome during training');    
    ax.YTick = [0 0.25 0.50 0.75 1];
    ax.YLim = [0 1];    
    c=colorcet('C2', 'N', 8);
%     bar(mean(a.incomplete),'FaceColor','none','EdgeColor','k');
    hold on;
%     plot(a.incomplete','Linestyle','none','Marker','o');
    v=violinplot(a.incompleteTrain(idx1,:)); %,[],'EdgeColor','none'
    for i=1:8
       v(i).ViolinColor=[0.4 0.4 0.4]; 
       v(i).EdgeColor='none'; 
       v(i).BoxColor='none';
       v(i).ScatterPlot.MarkerFaceColor='k';
       v(i).ScatterPlot.MarkerFaceAlpha=1;
       v(i).ShowMean=true;
    end
    title(label1);
    set(gca,'XTickLabel',a.choiceLabels,'XTick',[1:8]);
    axis square;
    
    ax = nsubplot(1,2,1,2);    
    ax.FontSize = 8;
    ylabel('% trials not present in reward port at outcome during training');    
    ax.YTick = [0 0.25 0.50 0.75 1];
    ax.YLim = [0 1];    
    c=colorcet('C2', 'N', 8);
%     bar(mean(a.incomplete),'FaceColor','none','EdgeColor','k');
    hold on;
%     plot(a.incomplete','Linestyle','none','Marker','o');
    v=violinplot(a.incompleteTrain(idx2,:)); %,[],'EdgeColor','none'
    for i=1:8
       v(i).ViolinColor=[0.4 0.4 0.4]; 
       v(i).EdgeColor='none'; 
       v(i).BoxColor='none';
       v(i).ScatterPlot.MarkerFaceColor='k';
       v(i).ScatterPlot.MarkerFaceAlpha=1;
       v(i).ShowMean=true;
    end
    title(label2);
    set(gca,'XTickLabel',a.choiceLabels,'XTick',[1:8]);
    axis square;
    
    saveas(fig,fullfile(pathname,[label{1} '_notPresentMeanViolinTraining']),'pdf');
%     
% 
%% PREF BY LEAVING

% %% LEAVINNG VS PREF COMMON SCALE
% 
% if ~isempty(a.reverseMice)
% fig = figure();
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% ax = nsubplot(1,2,1,1);
% ax.FontSize = 8;
% ax.XLim = [0 1];
% ax.YLim = [0 1];
% for mm = 1:numel(idx1)
%     m = idx1(mm);
%     text(a.overallChoice(m,5),a.incomplete(m,6) + 0.01,mice1{mm},'HorizontalAlignment','center');
% end
% scatter(a.overallChoice(idx1,5),a.incomplete(idx1,6),'filled')
% plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[0 1],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[1 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% [corr1,p1]=corr(a.overallChoice(idx1,5),a.incomplete(idx1,6));
% xlabel({'P(choose info)'}); %{'Info choice', 'probability'}
% ylabel({'P(NOT present in port on info small)'});
% title(['Overall mean choice of information vs. probability of leaving on low-value info trials ' label1  ...
%     ' corr=' num2str(corr1) ' , p=' num2str(p1)]);
% hold off;
% axis square;
% 
% 
% 
% saveas(fig,fullfile(pathname,[label{1} '_LeavingbyPrefcommscale']),'pdf');
% %     close(fig);
% end
% 
%     
% %% PREFERENCE VS LEAVING COMMON SCALE
% 
% if ~isempty(a.reverseMice)
% fig = figure();
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% ax = nsubplot(1,2,1,1);
% ax.FontSize = 8;
% ax.XLim = [0 1];
% ax.YLim = [0 1];
% for mm = 1:numel(idx1)
%     m = idx1(mm);
%     text(a.incomplete(m,6),a.overallChoice(m,5) + 0.01,mice1{mm},'HorizontalAlignment','center');
% end
% scatter(a.incomplete(idx1,6),a.overallChoice(idx1,5),'filled')
% plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[0 1],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[1 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% [corr1,p1]=corr(a.incomplete(idx1,6),a.overallChoice(idx1,5));
% ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% xlabel({'P(NOT present in port on info small)'});
% title(['Overall mean choice of information vs. probability of leaving on low-value info trials ' label1  ...
%     ' corr=' num2str(corr1) ' , p=' num2str(p1)]);
% hold off;
% axis square;
% 
% if ~isempty(idx2)
% ax = nsubplot(1,2,1,2);
% ax.FontSize = 8;
% ax.XLim = [0 1];
% ax.YLim = [0 1];
% for mm = 1:numel(idx2)
%     m = idx2(mm);
%     text(a.incomplete(m,6),a.overallChoice(m,5) + 0.01,mice2{mm},'HorizontalAlignment','center');
% end
% scatter(a.incomplete(idx2,6),a.overallChoice(idx2,5),'filled');
% [corr2,p2]=corr(a.incomplete(idx2,6),a.overallChoice(idx2,5));
% plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[0 1],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[1 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% xlabel({'P(NOT present in port on info small)'});
% title(['Overall mean choice of information vs. probability of leaving on low-value info trials ' label2  ...
%     ' corr=' num2str(corr2) ' , p=' num2str(p2)]);
% hold off;
% axis square;
% end
% 
% saveas(fig,fullfile(pathname,[label{1} '_Prefbyleavingcommscale']),'pdf');
% %     close(fig);
% end
% 
% %% PREFERENCE VS LEAVING OVERALL
% 
% if ~isempty(a.reverseMice)
% fig = figure();
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% ax = nsubplot(1,2,1,1);
% ax.FontSize = 8;
% % ax.XLim = [0 1];
% ax.YLim = [0 1];
% for mm = 1:numel(idx1)
%     m = idx1(mm);
%     text(a.incomplete(m,6),a.overallChoice(m,5) + 0.01,mice1{mm},'HorizontalAlignment','center');
% end
% scatter(a.incomplete(idx1,6),a.overallChoice(idx1,5),'filled')
% plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[0 1],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[1 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% [corr1,p1]=corr(a.incomplete(idx1,6),a.overallChoice(idx1,5));
% ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% xlabel({'P(NOT present in port on info small)'});
% title(['Overall mean choice of information vs. probability of leaving on low-value info trials ' label1  ...
%     ' corr=' num2str(corr1) ' , p=' num2str(p1)]);
% hold off;
% axis square;
% 
% if ~isempty(idx2)
% ax = nsubplot(1,2,1,2);
% ax.FontSize = 8;
% % ax.XLim = [0 1];
% ax.YLim = [0 1];
% for mm = 1:numel(idx2)
%     m = idx2(mm);
%     text(a.incomplete(m,6),a.overallChoice(m,5) + 0.01,mice2{mm},'HorizontalAlignment','center');
% end
% scatter(a.incomplete(idx2,6),a.overallChoice(idx2,5),'filled');
% [corr2,p2]=corr(a.incomplete(idx2,6),a.overallChoice(idx2,5));
% plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[0 1],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[1 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% xlabel({'P(NOT present in port on info small)'});
% title(['Overall mean choice of information vs. probability of leaving on low-value info trials ' label2  ...
%     ' corr=' num2str(corr2) ' , p=' num2str(p2)]);
% hold off;
% axis square;
% end
% 
% saveas(fig,fullfile(pathname,[label{1} '_PrefbyleavingOverall']),'pdf');
% %     close(fig);
% end
% 
% %% initial pref vs initial leaving
% if ~isempty(a.reverseMice)
% fig = figure();
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% ax = nsubplot(1,2,1,1);
% ax.FontSize = 8;
% % ax.XLim = [0 1];
% ax.YLim = [0 1];
% for mm = 1:numel(idx1)
%     m = idx1(mm);
%     text(a.initialIncomplete(m,1),a.pref(m,1) + 0.01,a.choiceMiceList{mm},'HorizontalAlignment','center');
% end
% scatter(a.initialIncomplete(idx1,1),a.pref(idx1,1),'filled');
% [corr1,p1]=corr(a.initialIncomplete(idx1,1),a.pref(idx1,1));
% plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[0 1],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[1 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% xlabel({'P(NOT present in port on info small)'});
% title(['Initial choice of information vs. probability of leaving on low-value info trials ' label1  ...
%     ' corr=' num2str(corr1) ' , p=' num2str(p1)]);
% hold off;
% axis square;
% 
% if ~isempty(idx2)
% ax = nsubplot(1,2,1,2);
% ax.FontSize = 8;
% % ax.XLim = [0 1];
% ax.YLim = [0 1];
% for mm = 1:numel(idx2)
%     m = idx2(mm);
%     text(a.initialIncomplete(m,1),a.pref(m,1) + 0.01,a.choiceMiceList{mm},'HorizontalAlignment','center');
% end
% scatter(a.initialIncomplete(idx2,1),a.pref(idx2,1),'filled');
% [corr2,p2]=corr(a.initialIncomplete(idx2,1),a.pref(idx2,1));
% plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[0 1],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[1 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% xlabel({'P(NOT present in port on info small)'});
% title(['Initial choice of information vs. probability of leaving on low-value info trials ' label2  ...
%     ' corr=' num2str(corr2) ' , p=' num2str(p2)]);
% hold off;
% axis square;
% end
% 
% saveas(fig,fullfile(pathname,[label{1} '_InitPrefbyleaving']),'pdf');
% %     close(fig);
% end
% 
% %% initial pref vs initial leaving
% if ~isempty(a.reverseMice)
% fig = figure();
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% ax = nsubplot(1,2,1,1);
% ax.FontSize = 8;
% ax.XLim = [0 1];
% ax.YLim = [0 1];
% for mm = 1:numel(idx1)
%     m = idx1(mm);
%     text(a.initialIncomplete(m,1),a.pref(m,1) + 0.01,a.choiceMiceList{mm},'HorizontalAlignment','center');
% end
% scatter(a.initialIncomplete(idx1,1),a.pref(idx1,1),'filled');
% [corr1,p1]=corr(a.initialIncomplete(idx1,1),a.pref(idx1,1));
% plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[0 1],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[1 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% xlabel({'P(NOT present in port on info small)'});
% title(['Initial choice of information vs. probability of leaving on low-value info trials ' label1  ...
%     ' corr=' num2str(corr1) ' , p=' num2str(p1)]);
% hold off;
% axis square;
% 
% if ~isempty(idx2)
% ax = nsubplot(1,2,1,2);
% ax.FontSize = 8;
% ax.XLim = [0 1];
% ax.YLim = [0 1];
% for mm = 1:numel(idx2)
%     m = idx2(mm);
%     text(a.initialIncomplete(m,1),a.pref(m,1) + 0.01,a.choiceMiceList{mm},'HorizontalAlignment','center');
% end
% scatter(a.initialIncomplete(idx2,1),a.pref(idx2,1),'filled');
% [corr2,p2]=corr(a.initialIncomplete(idx2,1),a.pref(idx2,1));
% plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[0 1],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[1 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% xlabel({'P(NOT present in port on info small)'});
% title(['Initial choice of information vs. probability of leaving on low-value info trials ' label2  ...
%     ' corr=' num2str(corr2) ' , p=' num2str(p2)]);
% hold off;
% axis square;
% end
% 
% saveas(fig,fullfile(pathname,[label{1} '_InitPrefbyleavingcommscale']),'pdf');
% %     close(fig);
% end
% 
% %% PREFERENCE VS LEAVING BY DAY
% 
% if ~isempty(a.reverseMice)
% fig = figure();
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% ax = nsubplot(1,2,1,1);
% ax.FontSize = 8;
% ax.XLim = [-0.1 1.1];
% ax.YLim = [-0.1 1.1];
% hold on;
% 
% prefs = [];
% NP = [];
% for mm = 1:numel(idx1rev)
%     m = idx1rev(mm);
%     scatter(a.choiceDayInfoSmallNP{m,:},a.choiceDayPref{m,:},'k','Filled');
%     NP=[NP a.choiceDayInfoSmallNP{m,:}];
%     prefs=[prefs a.choiceDayPref{m,:}];
% end
% [corr1,p1]=corr(NP(~isnan(NP+prefs))',prefs(~isnan(NP+prefs))');
% ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% xlabel({'P(NOT present in port on Info No Water)'});
% title(['Information Preference vs. probability of leaving on Info No Water trials, PER SESSION ' ...
%     'corr=' num2str(corr1) ' p=' num2str(p1) ' ' label1]);
% axis square;
% hold off;
% 
% if ~isempty(idx2)
% ax = nsubplot(1,2,1,2);
% ax.FontSize = 8;
% ax.XLim = [-0.1 1.1];
% ax.YLim = [-0.1 1.1];
% hold on;
% 
% prefs = [];
% NP = [];
% for mm = 1:numel(idx2rev)
%     m = idx2rev(mm);
%     scatter(a.choiceDayInfoSmallNP{m,:},a.choiceDayPref{m,:},'k','Filled');
%     NP=[NP a.choiceDayInfoSmallNP{m,:}];
%     prefs=[prefs a.choiceDayPref{m,:}];
% end
% [corr2,p2]=corr(NP(~isnan(NP+prefs))',prefs(~isnan(NP+prefs))');
% ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% xlabel({'P(NOT present in port on Info No Water)'});
% title(['Information Preference vs. probability of leaving on Info No Water trials, PER SESSION ' ...
%     'corr=' num2str(corr2) ' p=' num2str(p2) ' ' label2]);
% axis square;
% hold off;
% end
% 
% saveas(fig,fullfile(pathname,[label{1} '_Prefbyleavingbyday']),'pdf');
% %     close(fig);
% end
% 
% % %% PREFERENCE VS LEAVING BY DAY PREF MICE
% % 
% % if ~isempty(a.reverseMice)
% % fig = figure();
% % fig.PaperUnits = 'inches';
% % fig.PaperPosition = [0.5 0.5 10 7];
% % set(fig,'renderer','painters');
% % set(fig,'PaperOrientation','landscape');
% % 
% % ax = nsubplot(1,2,1,1);
% % ax.FontSize = 8;
% % ax.XLim = [-0.1 1.1];
% % ax.YLim = [-0.1 1.1];
% % hold on;
% % 
% % prefs = [];
% % NP = [];
% % for mm = 1:numel(idx1rev)
% %     m = idx1rev(mm);
% %     scatter(a.choiceDayInfoSmallNP{m,:},a.choiceDayPref{m,:},'k','Filled');
% %     NP=[NP a.choiceDayInfoSmallNP{m,:}];
% %     prefs=[prefs a.choiceDayPref{m,:}];
% % end
% % [corr1,p1]=corr(NP(~isnan(NP+prefs))',prefs(~isnan(NP+prefs))');
% % ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% % xlabel({'P(NOT present in port on Info No Water)'});
% % title(['Information Preference vs. probability of leaving on Info No Water trials, PER SESSION ' ...
% %     'corr=' num2str(corr1) ' p=' num2str(p1) ' ' label1]);
% % axis square;
% % hold off;
% % 
% % if ~isempty(idx2)
% % ax = nsubplot(1,2,1,2);
% % ax.FontSize = 8;
% % ax.XLim = [-0.1 1.1];
% % ax.YLim = [-0.1 1.1];
% % hold on;
% % 
% % prefs = [];
% % NP = [];
% % for mm = 1:numel(idx2rev)
% %     m = idx2rev(mm);
% %     scatter(a.choiceDayInfoSmallNP{m,:},a.choiceDayPref{m,:},'k','Filled');
% %     NP=[NP a.choiceDayInfoSmallNP{m,:}];
% %     prefs=[prefs a.choiceDayPref{m,:}];
% % end
% % [corr2,p2]=corr(NP(~isnan(NP+prefs))',prefs(~isnan(NP+prefs))');
% % ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% % xlabel({'P(NOT present in port on Info No Water)'});
% % title(['Information Preference vs. probability of leaving on Info No Water trials, PER SESSION ' ...
% %     'corr=' num2str(corr2) ' p=' num2str(p2) ' ' label2]);
% % axis square;
% % hold off;
% % end
% % 
% % saveas(fig,fullfile(pathname,[label{1} '_Prefbyleavingbyday']),'pdf');
% % %     close(fig);
% % end
% 
% %% PREFERENCE VS LEAVING DIFFERENCE PREF MICE
% % if ~isempty(a.reverseMice)
% fig = figure();
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% % idx=idx1(a.overallChoice(idx1,5)>0.54);
% 
% ax = nsubplot(1,2,1,1);
% ax.FontSize = 8;
% % ax.XLim = [0 1];
% ax.YLim = [0 1];
% for mm = 1:numel(idx)
%     m = idx(mm);
%     text(a.incompleteDifference(m)*100,a.overallChoice(m,5) + 0.01,mice1{mm},'HorizontalAlignment','center');
% end
% scatter(a.incompleteDifference(idx)*100,a.overallChoice(idx,5),'filled');
% [corr1,p1]=corr(a.incompleteDifference(idx,1),a.overallChoice(idx,1));
% plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[0 1],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[1 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% xlabel({'Difference in % trials not in port at outcome, info - no info'});
% title(['Overall mean choice of information vs. probability difference of leaving ' label1  ...
%     ' corr=' num2str(corr1) ' , p=' num2str(p1)]);
% hold off;
% 
% if ~isempty(idx2)
% % idx=idx2(a.overallChoice(idx2,5)>0.54);
% ax = nsubplot(1,2,1,2);
% ax.FontSize = 8;
% % ax.XLim = [0 1];
% ax.YLim = [0 1];
% for mm = 1:numel(idx)
%     m = idx(mm);
%     text(a.incompleteDifference(m)*100,a.overallChoice(m,5) + 0.01,mice2{mm},'HorizontalAlignment','center');
% end
% scatter(a.incompleteDifference(idx)*100,a.overallChoice(idx,5),'filled');
% [corr2,p2]=corr(a.incompleteDifference(idx,1),a.overallChoice(idx,1));
% plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[0 1],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[1 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% xlabel({'Difference in % trials not in port at outcome, info - no info'});
% title(['Overall mean choice of information vs. probability difference of leaving ' label2  ...
%     ' corr=' num2str(corr2) ' , p=' num2str(p2)]);
% hold off;
% end
% 
% saveas(fig,fullfile(pathname,[label{1} '_PrefbyleavingdifferenceMice']),'pdf');
% %     close(fig);
% % end
% 
% 
% %% LEAVING DIFFERENCE VS PREFERENCE
% % if ~isempty(a.reverseMice)
% fig = figure();
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% % idx=idx1(a.overallChoice(idx1,5)>0.54);
% idx=idx1;
% 
% ax = nsubplot(1,2,1,1);
% hold on;
% ax.FontSize = 8;
% ax.XLim = [0 1];
% ax.YLim = [0 1];
% for mm = 1:numel(idx)
%     m = idx(mm);
%     text(a.overallChoice(m,5),a.incompleteDifference(m) + 0.01,mice1{mm},'HorizontalAlignment','center');
% end
% scatter(a.overallChoice(idx,5),a.incompleteDifference(idx),'filled');
% [corr1,p1]=corr(a.overallChoice(idx,1),a.incompleteDifference(idx,1));
% plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[0 1],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[1 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% xlabel({'P(choose info)'}); %{'Info choice', 'probability'}
% ylabel({'Difference in % trials not in port at outcome, info - no info'});
% title(['Overall mean choice of information vs. probability difference of leaving ' label1  ...
%     ' corr=' num2str(corr1) ' , p=' num2str(p1)]);
% hold off;
% 
% % if ~isempty(idx2)
% % % idx=idx2(a.overallChoice(idx2,5)>0.54);
% % ax = nsubplot(1,2,1,2);
% % ax.FontSize = 8;
% % % ax.XLim = [0 1];
% % ax.YLim = [0 1];
% % for mm = 1:numel(idx)
% %     m = idx(mm);
% %     text(a.incompleteDifference(m)*100,a.overallChoice(m,5) + 0.01,mice2{mm},'HorizontalAlignment','center');
% % end
% % scatter(a.incompleteDifference(idx)*100,a.overallChoice(idx,5),'filled');
% % [corr2,p2]=corr(a.incompleteDifference(idx,1),a.overallChoice(idx,1));
% % plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % % plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % % plot([0 1],[0 1],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % % plot([0 1],[1 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% % xlabel({'Difference in % trials not in port at outcome, info - no info'});
% % title(['Overall mean choice of information vs. probability difference of leaving ' label2  ...
% %     ' corr=' num2str(corr2) ' , p=' num2str(p2)]);
% % hold off;
% % end
% 
% saveas(fig,fullfile(pathname,[label{1} '_leavingdifferencebyPref']),'pdf');
% %     close(fig);
% % end
% 
% 
% %% INIT PREFERENCE VS LEAVING DIFFERENCE PREF MICE
% % if ~isempty(a.reverseMice)
% fig = figure();
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% % idx=idx1(a.pref(idx1,1)>0.5);
% 
% ax = nsubplot(1,2,1,1);
% ax.FontSize = 8;
% % ax.XLim = [0 1];
% ax.YLim = [0 1];
% for mm = 1:numel(idx)
%     m = idx(mm);
%     text(a.initialIncompleteDifference(m)*100,a.pref(m,1) + 0.01,mice1{mm},'HorizontalAlignment','center');
% end
% scatter(a.initialIncompleteDifference(idx)*100,a.pref(idx,1),'filled');
% [corr1,p1]=corr(a.initialIncompleteDifference(idx,1),a.pref(idx,1));
% plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[0 1],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % plot([0 1],[1 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% ylabel({'P(choose info) INitial'}); %{'Info choice', 'probability'}
% xlabel({'Difference in % trials not in port at outcome, info - no info'});
% title(['Overall initial mean choice of information vs. probability difference of leaving ' label1  ...
%     ' corr=' num2str(corr1) ' , p=' num2str(p1)]);
% hold off;
% 
% % if ~isempty(idx2)
% % % idx=idx1(a.pref(idx1,1)>0.5);
% % ax = nsubplot(1,2,1,2);
% % ax.FontSize = 8;
% % % ax.XLim = [0 1];
% % ax.YLim = [0 1];
% % for mm = 1:numel(idx)
% %     m = idx(mm);
% %     text(a.initialIncompleteDifference(m)*100,a.pref(m,1) + 0.01,mice2{mm},'HorizontalAlignment','center');
% % end
% % scatter(a.initialIncompleteDifference(idx)*100,a.pref(idx,1),'filled');
% % [corr2,p2]=corr(a.initialIncompleteDifference(idx,1),a.pref(idx,1));
% % plot([-10000000 1000000],[0.5 0.5],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % % plot([0.5 0.5],[-10000000 1000000],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % % plot([0 1],[0 1],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % % plot([0 1],[1 0],'color',[0.2 0.2 0.2],'linewidth',0.25,'yliminclude','off','xliminclude','off');
% % ylabel({'P(choose info)'}); %{'Info choice', 'probability'}
% % xlabel({'Difference in % trials not in port at outcome, info - no info'});
% % title(['Overall mean choice of information vs. probability difference of leaving ' label2  ...
% %     ' corr=' num2str(corr2) ' , p=' num2str(p2)]);
% % hold off;
% % end
% 
% saveas(fig,fullfile(pathname,[label{1} '_PrefbyleavingdiffInitialPref']),'pdf');
% %     close(fig);
% % end
% 
%% PORT PROBABILITY (OLD)
% 
% win = 0.050; % bins in ms
% bins = [-1:win:15];
% a.bins=bins;
% a.win = win;

%     ok=abs(a.reverse)==1 & a.trialTypes == 5 & a.correct==1 & a.mouseNums>17;
%     ok=abs(a.reverse)==1 & a.trialTypes == 5 & a.correct==1;
    
% %     figure();
% %     fig = gcf;
% %     fig.PaperUnits = 'inches';
% %     fig.PaperPosition = [0.5 0.5 10 7];
% %     set(fig,'renderer','painters');
% %     set(fig,'PaperOrientation','landscape');
% %     
% %     ax = nsubplot(3,1,1,1);
% %     title(['All Mice Probability in port by trial type, choice days ' label{1}]);
% %     ax.FontSize = 8;
% %     ylabel('CENTER port');
% %     plot(bins,mean(a.Port2(a.trialType==1 & ok,:)),'Color',grey,'LineWidth',2);
% %     plot(bins,mean(a.Port2(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% %     plot(bins,mean(a.Port2(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);    
% %     ax.YTick = [0 0.25 0.50 0.75 1];
% %     ax.YLim = [-0.1 1.1];
% %     plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% %     plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% %     plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% %     ax.XLim = [-1 12];
% % %     xlabel('Time relative to go cue (s)');
% %     
% %     ax = nsubplot(3,1,2,1);
% %     ax.FontSize = 8;
% %     ylabel('INFO port');
% %     plot(bins,mean(a.infoPort(a.infoBig==1 & ok,:)),'Color','g','LineWidth',2);
% %     plot(bins,mean(a.infoPort(a.infoSmall==1 & ok,:)),'Color','m','LineWidth',2); 
% %     plot(bins,mean(a.infoPort(a.randBig==1 & ok,:)),'Color','b','LineWidth',2);
% %     plot(bins,mean(a.infoPort(a.randSmall==1 & ok,:)),'Color','c','LineWidth',2);
% %     plot(bins,mean(a.infoPort(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% %     plot(bins,mean(a.infoPort(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);
% %     ax.YTick = [0 0.25 0.50 0.75 1];
% %     ax.YLim = [-0.1 1.1];
% %     plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% %     plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% %     plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% %     ax.XLim = [-1 12];
% % %     xlabel('Time relative to go cue (s)');
% % 
% %     ax = nsubplot(3,1,3,1);
% %     ax.FontSize = 8;
% %     ylabel('NO INFO port');
% %     plot(bins,mean(a.randPort(a.infoBig==1 & ok,:)),'Color','g','LineWidth',2);
% %     plot(bins,mean(a.randPort(a.infoSmall==1 & ok,:)),'Color','m','LineWidth',2); 
% %     plot(bins,mean(a.randPort(a.randBig==1 & ok,:)),'Color','b','LineWidth',2);
% %     plot(bins,mean(a.randPort(a.randSmall==1 & ok,:)),'Color','c','LineWidth',2);
% %     plot(bins,mean(a.randPort(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% %     plot(bins,mean(a.randPort(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);
% %     ax.YTick = [0 0.25 0.50 0.75 1];
% %     ax.YLim = [-0.1 1.1];
% %     ax.XLim = [-1 12];
% %     plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% %     plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% %     plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% %     xlabel('Time relative to go cue (s)');
% %     
% %     ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% %     h_for_legend=[];
% %     hold on;
% %     for i = 1:7
% %         h_for_legend(end+1) = plot(ha,0,0, 'color',CCtype(i,:),'linewidth',2);
% %     end
% %     hold off;
% % 
% %     leg = legend(h_for_legend,a.typeLabels,'Location','south','Orientation','horizontal');
% %     legend('boxoff');
% % %     text(0.51,0.98,[a.mouseList{m} ' Choice of Side'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');        
% %       
% %     saveas(fig,fullfile(pathname,['portdwellChoiceDaysOverall_' label{1}]),'pdf');
% % %     close;
% % 
% %%
% 
% ok=abs(a.reverse)==1 & a.trialTypes == 5 & a.correct==1;
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% ax = nsubplot(1,1,1,1);
% bar([mean(mean(a.infoPort(a.infoForced & ok,54:250),2)) mean(mean(a.randPort(a.randForced & ok,54:250),2))]);
% errorbar(1,mean(mean(a.infoPort(a.infoForced & ok,54:250),2)),sem(mean(a.infoPort(a.infoForced & ok,54:250),2)),'Color','k','LineWidth',2,'CapSize',25);
% errorbar(2,mean(mean(a.randPort(a.randForced & ok,54:250),2)),sem(mean(a.randPort(a.randForced & ok,54:250),2)),'Color','k','LineWidth',2,'CapSize',25);
% pval=ranksum(mean(a.infoPort(a.infoForced & ok,54:250),2),mean(a.randPort(a.randForced & ok,54:250),2));
% ax.YLim = [0 1];
% ylabel('Probability in correct reward port throughout delay');
% xticks([1 2]);
% xticklabels({['Info p= ' num2str(pval)],'No Info'});
% title(label1);
% saveas(fig,fullfile(pathname,['portdwellBarReversal' label{1}]),'pdf');

% %% PORT PROBABILITY INIT CHOICE
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% %     ok=abs(a.reverse)==1 & a.trialTypes == 5 & a.correct==1 & a.mouseNums>17;
% ok=a.reverse==1 & a.trialTypes == 5 & a.correct==1 & ismember(a.mouseNums,idx1);
% 
% ax = nsubplot(3,2,1,1);
% title([label1 ' Probability in port by trial type, pre-reverse choice days']);
% ax.FontSize = 8;
% ylabel('CENTER port');
% plot(bins,mean(a.Port2(a.trialType==1 & ok,:)),'Color',grey,'LineWidth',2);
% plot(bins,mean(a.Port2(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.Port2(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);    
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% ax.XLim = [-1 12];
% %     xlabel('Time relative to go cue (s)');
% 
% ax = nsubplot(3,2,2,1);
% ax.FontSize = 8;
% ylabel('INFO port');
% plot(bins,mean(a.infoPort(a.infoBig==1 & ok,:)),'Color','g','LineWidth',2);
% plot(bins,mean(a.infoPort(a.infoSmall==1 & ok,:)),'Color','m','LineWidth',2); 
% plot(bins,mean(a.infoPort(a.randBig==1 & ok,:)),'Color','b','LineWidth',2);
% plot(bins,mean(a.infoPort(a.randSmall==1 & ok,:)),'Color','c','LineWidth',2);
% plot(bins,mean(a.infoPort(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.infoPort(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% ax.XLim = [-1 12];
% %     xlabel('Time relative to go cue (s)');
% 
% ax = nsubplot(3,2,3,1);
% ax.FontSize = 8;
% ylabel('NO INFO port');
% plot(bins,mean(a.randPort(a.infoBig==1 & ok,:)),'Color','g','LineWidth',2);
% plot(bins,mean(a.randPort(a.infoSmall==1 & ok,:)),'Color','m','LineWidth',2); 
% plot(bins,mean(a.randPort(a.randBig==1 & ok,:)),'Color','b','LineWidth',2);
% plot(bins,mean(a.randPort(a.randSmall==1 & ok,:)),'Color','c','LineWidth',2);
% plot(bins,mean(a.randPort(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.randPort(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% ax.XLim = [-1 12];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% xlabel('Time relative to go cue (s)');
% 
% ok=abs(a.reverse)==1 & a.trialTypes == 5 & a.correct==1 & ismember(a.mouseNums,idx2);
% 
% ax = nsubplot(3,2,1,2);
% title([label2 ' Probability in port by trial type, pre-reverse choice days']);
% ax.FontSize = 8;
% ylabel('CENTER port');
% plot(bins,mean(a.Port2(a.trialType==1 & ok,:)),'Color',grey,'LineWidth',2);
% plot(bins,mean(a.Port2(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.Port2(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);    
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% ax.XLim = [-1 12];
% %     xlabel('Time relative to go cue (s)');
% 
% ax = nsubplot(3,2,2,2);
% ax.FontSize = 8;
% ylabel('INFO port');
% plot(bins,mean(a.infoPort(a.infoBig==1 & ok,:)),'Color','g','LineWidth',2);
% plot(bins,mean(a.infoPort(a.infoSmall==1 & ok,:)),'Color','m','LineWidth',2); 
% plot(bins,mean(a.infoPort(a.randBig==1 & ok,:)),'Color','b','LineWidth',2);
% plot(bins,mean(a.infoPort(a.randSmall==1 & ok,:)),'Color','c','LineWidth',2);
% plot(bins,mean(a.infoPort(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.infoPort(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% ax.XLim = [-1 12];
% %     xlabel('Time relative to go cue (s)');
% 
% ax = nsubplot(3,2,3,2);
% ax.FontSize = 8;
% ylabel('NO INFO port');
% plot(bins,mean(a.randPort(a.infoBig==1 & ok,:)),'Color','g','LineWidth',2);
% plot(bins,mean(a.randPort(a.infoSmall==1 & ok,:)),'Color','m','LineWidth',2); 
% plot(bins,mean(a.randPort(a.randBig==1 & ok,:)),'Color','b','LineWidth',2);
% plot(bins,mean(a.randPort(a.randSmall==1 & ok,:)),'Color','c','LineWidth',2);
% plot(bins,mean(a.randPort(a.trialType==2 & ok,:)),'Color',purple,'LineWidth',2);
% plot(bins,mean(a.randPort(a.trialType==3 & ok,:)),'Color',orange,'LineWidth',2);
% ax.YTick = [0 0.25 0.50 0.75 1];
% ax.YLim = [-0.1 1.1];
% ax.XLim = [-1 12];
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
% xlabel('Time relative to go cue (s)');
% 
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% h_for_legend=[];
% hold on;
% for i = 1:7
%     h_for_legend(end+1) = plot(ha,0,0, 'color',CCtype(i,:),'linewidth',2);
% end
% hold off;
% 
% leg = legend(h_for_legend,a.typeLabels,'Location','south','Orientation','horizontal');
% legend('boxoff');
% %     text(0.51,0.98,[a.mouseList{m} ' Choice of Side'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');        
% 
% saveas(fig,fullfile(pathname,['portdwellChoiceDaysPrereverse_' label{1}]),'pdf');
% %     close;
% 
% %%

% % for m=1:a.mouseCt
% %     ok=a.reverse==1 & a.trialTypes == 5 & a.correct==1 & a.mouseNums==m;
% %    a.infoDwell(m,1)= mean(mean(a.infoPort(a.infoForced & ok,54:250),2));
% %    a.randDwell(m,1) = mean(mean(a.randPort(a.randForced & ok,54:250),2));
% % end
% 
% fig = figure();    
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% ax = nsubplot(1,2,1,1);
% ax.FontSize = 8;
% % ax.YTick = [0 0.500 1.000 1.500];
% % ax.YLim = [0 1.5];
% ax.XLim = [0.5 3.5];
% for mm = 1:numel(idx1rev)
%     m=idx1rev(mm);
%     plot([1 3],[mean(a.infoDwell(m,1)) mean(a.randDwell(m,1))],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
% end
% plot(1,mean(a.infoDwell(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
% errorbar(1,mean(a.infoDwell(idx1rev,1),'omitnan'),sem(a.infoDwell(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',100);
% plot(3,mean(a.randDwell(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
% errorbar(3,mean(a.randDwell(idx1rev,1),'omitnan'),sem(a.randDwell(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',100);
% xticks([1 3]);
% xticklabels({'Info','No Info'});
% ylabel('Probability in correct reward port during delay, pre-reverse');
% [~,p1]=ttest(a.infoDwell(idx1rev,1),a.randDwell(idx1,1));
% title([label1 ' p = ' num2str(p1)]);
% 
% ax = nsubplot(1,2,1,2);
% ax.FontSize = 8;
% % ax.YTick = [0 0.500 1.000 1.500];
% % ax.YLim = [0 1.5];
% ax.XLim = [0.5 3.5];
% for mm = 1:numel(idx2rev)
%     m=idx2rev(mm);
%     plot([1 3],[mean(a.infoDwell(m,1)) mean(a.randDwell(m,1))],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
% end
% plot(1,mean(a.infoDwell(idx2rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
% errorbar(1,mean(a.infoDwell(idx2rev,1),'omitnan'),sem(a.infoDwell(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',100);
% plot(3,mean(a.randDwell(idx2rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
% errorbar(3,mean(a.randDwell(idx2rev,1),'omitnan'),sem(a.randDwell(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',100);
% xticks([1 3]);
% xticklabels({'Info','No Info'});
% ylabel('Probability in correct reward port during delay, pre-reverse');
% [~,p1]=ttest(a.infoDwell(idx2rev,1),a.randDwell(idx2,1));
% title([label1 ' p = ' num2str(p1)]);
% 
% % ax = nsubplot(1,2,1,1);
% % ax.FontSize = 8;
% % ax.XTick = [1 2];
% % ax.XLim = [0,3];
% % ax.YTick = [0 0.25 0.50 0.75 1];
% % ax.XTickLabel = {'Info','No Info'};
% % ax.YLim = [0 1];
% % v1=Violin(infoDwell(idx1),1);
% % v2=Violin(randDwell(idx1),2);
% % v1.ViolinColor=[0.4 0.4 0.4]; 
% % v1.EdgeColor='none'; 
% % v1.BoxColor='none';
% % v1.ScatterPlot.MarkerFaceColor='k';
% % v1.ScatterPlot.MarkerFaceAlpha=1;
% % v1.ShowMean=true;
% % v2.ViolinColor=[0.4 0.4 0.4]; 
% % v2.EdgeColor='none'; 
% % v2.BoxColor='none';
% % v2.ScatterPlot.MarkerFaceColor='k';
% % v2.ScatterPlot.MarkerFaceAlpha=1;
% % v2.ShowMean=true;   
% % 
% % [~,pval]=ttest(infoDwell(idx1),randDwell(idx1));
% % ylabel('Probability in correct reward port during delay, pre-reverse');
% % xlabel('Trial Type');
% % title([label1 ' p=' num2str(pval)]);
% % hold off;
% % axis square;
% % 
% % ax = nsubplot(1,2,1,2);
% % ax.FontSize = 8;
% % ax.XTick = [1 2];
% % ax.XLim = [0,3];
% % ax.YTick = [0 0.25 0.50 0.75 1];
% % ax.XTickLabel = {'Info','No Info'};
% % ax.YLim = [0 1];
% % v1=Violin(infoDwell(idx2),1);
% % v2=Violin(randDwell(idx2),2);
% % v1.ViolinColor=[0.4 0.4 0.4]; 
% % v1.EdgeColor='none'; 
% % v1.BoxColor='none';
% % v1.ScatterPlot.MarkerFaceColor='k';
% % v1.ScatterPlot.MarkerFaceAlpha=1;
% % v1.ShowMean=true;
% % v2.ViolinColor=[0.4 0.4 0.4]; 
% % v2.EdgeColor='none'; 
% % v2.BoxColor='none';
% % v2.ScatterPlot.MarkerFaceColor='k';
% % v2.ScatterPlot.MarkerFaceAlpha=1;
% % v2.ShowMean=true;   
% % 
% % [~,pval]=ttest(infoDwell(idx2),randDwell(idx2));
% % ylabel('Probability in correct reward port during delay, pre-reverse');
% % xlabel('Trial Type');
% % title([label2 ' p=' num2str(pval)]);
% % hold off;
% % axis square;
% 
% saveas(fig,fullfile(pathname,[label{1} '_MeanportdwellPreRev']),'pdf');

% %%
% 
% fig = figure();    
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0.5 0.5 10 7];
% set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% ax = nsubplot(1,2,1,1);
% ax.FontSize = 8;
% % ax.YTick = [0 0.500 1.000 1.500];
% % ax.YLim = [0 1.5];
% ax.XLim = [0.5 3.5];
% for mm = 1:numel(idx1rev)
%     m=idx1rev(mm);
%     plot([1 3],[mean(a.infoDwell1sec(m,1)) mean(a.randDwell1sec(m,1))],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
% end
% plot(1,mean(a.infoDwell1sec(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
% errorbar(1,mean(a.infoDwell1sec(idx1rev,1),'omitnan'),sem(a.infoDwell1sec(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',100);
% plot(3,mean(a.randDwell1sec(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
% errorbar(3,mean(a.randDwell1sec(idx1rev,1),'omitnan'),sem(a.randDwell1sec(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',100);
% xticks([1 3]);
% xticklabels({'Info','No Info'});
% ylabel('Probability in correct reward port during delay, pre-reverse');
% [~,p1]=ttest(a.infoDwell1sec(idx1rev,1),a.randDwell1sec(idx1,1));
% title([label1 ' p = ' num2str(p1)]);
% 
% ax = nsubplot(1,2,1,2);
% ax.FontSize = 8;
% % ax.YTick = [0 0.500 1.000 1.500];
% % ax.YLim = [0 1.5];
% ax.XLim = [0.5 3.5];
% for mm = 1:numel(idx2rev)
%     m=idx2rev(mm);
%     plot([1 3],[mean(a.infoDwell1sec(m,1)) mean(a.randDwell1sec(m,1))],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
% end
% plot(1,mean(a.infoDwell1sec(idx2rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
% errorbar(1,mean(a.infoDwell1sec(idx2rev,1),'omitnan'),sem(a.infoDwell1sec(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',100);
% plot(3,mean(a.randDwell1sec(idx2rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
% errorbar(3,mean(a.randDwell1sec(idx2rev,1),'omitnan'),sem(a.randDwell1sec(idx2rev,1)),'Color','k','LineWidth',2,'CapSize',100);
% xticks([1 3]);
% xticklabels({'Info','No Info'});
% ylabel('Probability in correct reward port during delay, pre-reverse');
% [~,p1]=ttest(a.infoDwell1sec(idx2rev,1),a.randDwell1sec(idx2,1));
% title([label1 ' p = ' num2str(p1)]);
% 
% % ax = nsubplot(1,2,1,1);
% % ax.FontSize = 8;
% % ax.XTick = [1 2];
% % ax.XLim = [0,3];
% % ax.YTick = [0 0.25 0.50 0.75 1];
% % ax.XTickLabel = {'Info','No Info'};
% % ax.YLim = [0 1];
% % v1=Violin(infoDwell(idx1),1);
% % v2=Violin(randDwell(idx1),2);
% % v1.ViolinColor=[0.4 0.4 0.4]; 
% % v1.EdgeColor='none'; 
% % v1.BoxColor='none';
% % v1.ScatterPlot.MarkerFaceColor='k';
% % v1.ScatterPlot.MarkerFaceAlpha=1;
% % v1.ShowMean=true;
% % v2.ViolinColor=[0.4 0.4 0.4]; 
% % v2.EdgeColor='none'; 
% % v2.BoxColor='none';
% % v2.ScatterPlot.MarkerFaceColor='k';
% % v2.ScatterPlot.MarkerFaceAlpha=1;
% % v2.ShowMean=true;   
% % 
% % [~,pval]=ttest(infoDwell(idx1),randDwell(idx1));
% % ylabel('Probability in correct reward port during first 1s of delay, pre-reverse');
% % xlabel('Trial Type');
% % title([label1 ' p=' num2str(pval)]);
% % hold off;
% % axis square;
% % 
% % ax = nsubplot(1,2,1,2);
% % ax.FontSize = 8;
% % ax.XTick = [1 2];
% % ax.XLim = [0,3];
% % ax.YTick = [0 0.25 0.50 0.75 1];
% % ax.XTickLabel = {'Info','No Info'};
% % ax.YLim = [0 1];
% % v1=Violin(infoDwell(idx2),1);
% % v2=Violin(randDwell(idx2),2);
% % v1.ViolinColor=[0.4 0.4 0.4]; 
% % v1.EdgeColor='none'; 
% % v1.BoxColor='none';
% % v1.ScatterPlot.MarkerFaceColor='k';
% % v1.ScatterPlot.MarkerFaceAlpha=1;
% % v1.ShowMean=true;
% % v2.ViolinColor=[0.4 0.4 0.4]; 
% % v2.EdgeColor='none'; 
% % v2.BoxColor='none';
% % v2.ScatterPlot.MarkerFaceColor='k';
% % v2.ScatterPlot.MarkerFaceAlpha=1;
% % v2.ShowMean=true;   
% % 
% % [~,pval]=ttest(infoDwell(idx2),randDwell(idx2));
% % ylabel('Probability in correct reward port during first 1s of delay, pre-reverse');
% % xlabel('Trial Type');
% % title([label2 ' p=' num2str(pval)]);
% % hold off;
% % axis square;
% 
% saveas(fig,fullfile(pathname,['MeanportdwellfirstsecPrerev_' label{1}]),'pdf');

%%
set(0,'DefaultFigureWindowStyle','normal');