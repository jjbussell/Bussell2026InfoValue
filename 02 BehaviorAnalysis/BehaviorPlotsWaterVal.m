close all;

%% SAVEPATH

% datapath=findInfoseekData();
datapath = 'D:\Bussell Dropbox\Jennifer Bussell\BpodInfoseek\';


plotfolder=fullfile(datapath,'AllMicePlotsWaterVal');
pathname=plotfolder;

set(0,'DefaultFigureWindowStyle','docked'); % plot in docked window
% 
%% PLOTTING COLORS AND LABELS

purple = [121 32 196] ./ 255;
orange = [251 139 6] ./ 255;
cornflower = [100 149 237] ./ 255;
grey = [.8 .8 .8];

a.outcomeLabels = {'SmallNoChoice','Small','SmallNP','SmallIncorrect',...
'InfoNoChoice','InfoBig',...
'InfoBigNP','InfoSmall','InfoSmallNP','InfoIncorrect','RandNoChoice',...
'RandBig','RandBigNP','RandSmall','RandSmallNP',...
'RandIncorrect','BigNoChoice','Big','BigNP','BigIncorrect'};

CCfinal = [0.6,0.6,0.6; %small no choice
1,0,1; %small
1,192/255,203/255; %small not present
0.0,0.0,0.0; %small incorrect
0.6,0.6,0.6; %info no choice
0.474509803921569,0.125490196078431,0.768627450980392; %info big
171/255,130/255,1; % info big NP
0.9490, 0.8, 1.0; %infosmall
238/255,224/255,229/255; %infoNPsmall
0.0,0.0,0.0; %infoincorrect
0.6,0.6,0.6; %rand no choice
0.984313725490196,0.545098039215686,0.0235294117647059; %rand big
245/255,222/255,179/255; % rand big NP
1, 0.8, 0.0; %rand small
244/255, 164/255, 96/255; % rand small NP
0.0,0.0,0.0; %randincorrect
0.6,0.6,0.6; % big no choice
0,1,0; % big
152/255,251/255,152/255;% big NP
0.0,0.0,0.0]; %big incorrect

CCtype = [purple; orange;[1 0 0]; grey;
    0,1,0; %info big
    1,0,1; %infosmall
    0,0,1; %rand big
    0,1,1];

a.typeLabels = {'Info','No Info','Big','Small','Info Water',...
    'Info No Water','No Info Water','No Info No Water'};

a.choiceLabels = {'InfoBig','InfoSmall','RandBig','RandSmall','BigWater','SmallWater'};


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GROUPS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% a.mouseNums = arrayfun(@(X)  find(a.mice(X,:),1,'last'), 1:size(a.mice,1))';

clear flag labels label;

a.goodMice=ones(size(a.mouseList));

flag='goodMice';
labels={'GoodMice','BadMice'};
label={'GoodBad'};

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

%% PLOT STACKED BAR OUTCOMES BY MOUSE FOR CURRENT MICE

% outN=20;

for m = 1:a.mouseCt   
    outcomeCounts = [];
    outcomeBins = [];
    
    if a.mouseDayCt(m) > 3
        for d = 1:a.mouseDayCt(m)
            [outcomeCounts(d,:),outcomeBins(d,:)] = histcounts(a.daySummary.outcome{m,d},[0.5:1:20.5],'Normalization','probability');
        end
        figure();
        fig = gcf;
        fig.PaperUnits = 'inches';
        fig.PaperPosition = [0 0 11 8.5];
        set(fig,'renderer','painters')
        set(fig,'PaperOrientation','landscape');
        
        ax = nsubplot(1,1,1,1);
        title([a.mouseList(m) a.day{find(a.mice(:,m)==1&a.mouseDay==a.mouseDayCt(m),1)}]);
        ax.FontSize = 10;
        ylabel('Trial Outcomes (% of trials)');
        xlabel('Day');
        ax.YLim = [0 1];
        ax.YTick = [0:0.25:1];
        ax.XLim = [0 a.mouseDayCt(m)+1];
        ax.XTick = [1:10:a.mouseDayCt(m)];
        ax.XTickLabel = [1:10:a.mouseDayCt(m)];
%         colormap(fig,CCfinal);
        b = bar(outcomeCounts,'stacked','FaceColor','flat');
        for i = 1:20
            b(i).CData = CCfinal(i,:);
        end
        
        set(gca, 'ydir', 'reverse');
        lgd = legend(ax,a.outcomeLabels,'Location','eastoutside');
        lgd.Box = 'off';
        lgd.FontWeight = 'bold';

    else
        figure();
        fig = gcf;
        fig.PaperUnits = 'inches';
        fig.PaperPosition = [0 0 11 8.5];
        set(fig,'PaperOrientation','landscape');
        set(fig,'renderer','painters')
        for d = 1:a.mouseDayCt(m)
            ax = nsubplot(a.mouseDayCt(m),1,d,1);
            if d==1
            title([a.mouseList(m) a.day{find(a.mice(:,m)==1&a.mouseDay==a.mouseDayCt(m),1)}]);       
            end
            ax.FontSize = 10;
            [outcomeCounts,outcomeBins] = histcounts(a.daySummary.outcome{m,d},[0.5:1:20.5],'Normalization','probability');
            bar([1:21],outcomeCounts);
            colormap(fig,CCfinal);
            plot([9.5 9.5],[-10000000 1000000],'k','yliminclude','off','color',[0.6 0.6 0.6],'LineWidth',2);
            plot([15.5 15.5],[-10000000 1000000],'k','yliminclude','off','color',[0.6 0.6 0.6],'LineWidth',2);    
            if d == ceil(a.mouseDayCt(m)/2)
                ylabel('Trial Outcomes (% of trials)');
            end
            if d == a.mouseDayCt(m)
                ax.XTick = [1:21];
            set(gca,'XTickLabel',a.outcomeLabels,'XTickLabelRotation',35)
            end
        end
    end
    saveas(fig,fullfile(pathname,['outcomesStacked' a.mouseList{m}]),'pdf');
%     close(fig);
end

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PRE-REVERSAL, last 2 days before
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% PRE-REVERSAL DWELL TIME QUANT

[a.preRevDwellspval, tbl, stats] = friedman([a.infoDwell(idx1,1) a.randDwell(idx1,1) a.bigDwell(idx1,1) a.smallDwell(idx1,1) a.infoDwell1sec(idx1,1) a.randDwell1sec(idx1,1)], 1,'off');
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
ax.XLim = [0.5 15.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3 5 7],[a.infoDwell(m,1) a.randDwell(m,1) a.bigDwell(m,1) a.smallDwell(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([9 11 13 15],[a.infoDwell1sec(m,1) a.randDwell1sec(m,1) a.bigDwell1sec(m,1) a.smallDwell1sec(m,1)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.infoDwell(idx1,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(1,mean(a.infoDwell(idx1,1)),sem(a.infoDwell(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.randDwell(idx1,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(3,mean(a.randDwell(idx1,1)),sem(a.randDwell(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(5,mean(a.bigDwell1sec(idx1,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(5,mean(a.bigDwell1sec(idx1,1)),sem(a.bigDwell1sec(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(7,mean(a.smallDwell1sec(idx1,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(7,mean(a.smallDwell1sec(idx1,1)),sem(a.smallDwell1sec(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(9,mean(a.infoDwell1sec(idx1,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(9,mean(a.infoDwell1sec(idx1,1)),sem(a.infoDwell1sec(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(11,mean(a.randDwell1sec(idx1,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(11,mean(a.randDwell1sec(idx1,1)),sem(a.randDwell1sec(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(13,mean(a.bigDwell1sec(idx1,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(13,mean(a.bigDwell1sec(idx1,1)),sem(a.bigDwell1sec(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(15,mean(a.smallDwell1sec(idx1,1)),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(15,mean(a.smallDwell1sec(idx1,1)),sem(a.smallDwell1sec(idx1,1)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7 9 11 13 15]);
xticklabels({'Info','No Info','Big','Small','Info 1sec','No Info 1sec','Big 1sec','Small 1sec'});
ylabel('Probability in correct reward port during delay, pre-reverse');

saveas(fig,fullfile(pathname,[label{1} '_preRevDwellTimeQuant']),'pdf');

%% Dwell Time bar

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

nsubplot(1,1,1,1);
toPlot=[mean(a.infoDwell) mean(a.randDwell) mean(a.bigDwell) mean(a.smallDwell)];
bar(toPlot);
xticks(1:4);
xticklabels({'Info','Rand','Big','Small'});
ylabel('Prob in port');
saveas(fig,fullfile(pathname,[label{1} '_preRevDwellTimeMean']),'pdf');

%% Rxn bar

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

nsubplot(1,1,1,1);
% toPlot=[mean(a.infoDwell) mean(a.randDwell) mean(a.bigDwell) mean(a.smallDwell)];
bar(mean(a.preRevRxnMean));
xticks(1:4);
xticklabels({'Info','Rand','Big','Small'});
ylabel('Rxn');
saveas(fig,fullfile(pathname,[label{1} '_preRevRxnMean']),'pdf');

%%
fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

nsubplot(1,1,1,1);
% toPlot=[mean(a.infoDwell) mean(a.randDwell) mean(a.bigDwell) mean(a.smallDwell)];
bar(cellfun(@mean,a.preRevRxnAll));
errorbar(1:4,cellfun(@mean,a.preRevRxnAll),cellfun(@sem,a.preRevRxnAll),'o');
xticks(1:4);
xticklabels({'Info','Rand','Big','Small'});
ylabel('Rxn');
title(['info p ' num2str(ranksum(a.preRevRxnAll{1},a.preRevRxnAll{2})) ' water p ' num2str(ranksum(a.preRevRxnAll{3},a.preRevRxnAll{4}))])
saveas(fig,fullfile(pathname,[label{1} '_preRevRxnMeanAll']),'pdf');

%%
fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

nsubplot(1,1,1,1);
for i=1:4
   v1=Violin(a.preRevRxnAll{i},i);
    v1.ViolinColor=[0.4 0.4 0.4]; 
    v1.EdgeColor='none'; 
    v1.BoxColor='none';
    v1.ScatterPlot.MarkerFaceColor='k';
    v1.ScatterPlot.MarkerFaceAlpha=1;
    v1.ShowMean=true; 
end
xticks(1:4);
xticklabels({'Info','Rand','Big','Small'});
ylim([0 15])
ylabel('Rxn (s)');
title(['info p ' num2str(ranksum(a.preRevRxnAll{1},a.preRevRxnAll{2})) ' water p ' num2str(ranksum(a.preRevRxnAll{3},a.preRevRxnAll{4}))])
saveas(fig,fullfile(pathname,[label{1} '_preRevRxnMeanAllViolin']),'pdf');


%% PORT PROBABILITY PRE-REVERSAL

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(5,1,1,1);
title([label1 ' Probability in port by trial type, pre-reversal choice days']);
ax.FontSize = 8;
ylabel('CENTER port');
hold on;
fill([bins, fliplr(bins)], [mean(a.centerDwellInfo(idx1,:))-sem(a.centerDwellInfo(idx1,:)), fliplr(mean(a.centerDwellInfo(idx1,:))+sem(a.centerDwellInfo(idx1,:)))],purple,'EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.centerDwellRand(idx1,:))-sem(a.centerDwellRand(idx1,:)), fliplr(mean(a.centerDwellRand(idx1,:))+sem(a.centerDwellRand(idx1,:)))],orange,'EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.centerDwellBig(idx1,:))-sem(a.centerDwellBig(idx1,:)), fliplr(mean(a.centerDwellBig(idx1,:))+sem(a.centerDwellBig(idx1,:)))],'r','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.centerDwellSmall(idx1,:))-sem(a.centerDwellSmall(idx1,:)), fliplr(mean(a.centerDwellSmall(idx1,:))+sem(a.centerDwellSmall(idx1,:)))],grey,'EdgeColor','none','FaceAlpha', 0.1);
plot(bins,mean(a.centerDwellInfo(idx1,:)),'Color',purple,'LineWidth',0.5);
plot(bins,mean(a.centerDwellRand(idx1,:)),'Color',orange,'LineWidth',0.5);
plot(bins,mean(a.centerDwellBig(idx1,:)),'Color','r','LineWidth',0.5);
plot(bins,mean(a.centerDwellSmall(idx1,:)),'Color',grey,'LineWidth',0.5); 
ax.YTick = [0 0.25 0.50 0.75 1];
ax.YLim = [-0.1 1.1];
plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
ax.XLim = [-1 12];
%     xlabel('Time relative to go cue (s)');

ax = nsubplot(5,1,2,1);
ax.FontSize = 8;
ylabel('INFO port');
hold on;
fill([bins, fliplr(bins)], [mean(a.infoDwellInfoBig(idx1,:))-sem(a.infoDwellInfoBig(idx1,:)), fliplr(mean(a.infoDwellInfoBig(idx1,:))+sem(a.infoDwellInfoBig(idx1,:)))],'g','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.infoDwellInfoSmall(idx1,:))-sem(a.infoDwellInfoSmall(idx1,:)), fliplr(mean(a.infoDwellInfoSmall(idx1,:))+sem(a.infoDwellInfoSmall(idx1,:)))],'m','EdgeColor','none','FaceAlpha', 0.1);
% fill([bins, fliplr(bins)], [mean(a.infoDwellBig(idx1,:))-sem(a.infoDwellBig(idx1,:)), fliplr(mean(a.infoDwellBig(idx1,:))+sem(a.infoDwellBig(idx1,:)))],'r','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.infoDwellRandBig(idx1,:))-sem(a.infoDwellRandBig(idx1,:)), fliplr(mean(a.infoDwellRandBig(idx1,:))+sem(a.infoDwellRandBig(idx1,:)))],'b','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.infoDwellRandSmall(idx1,:))-sem(a.infoDwellRandSmall(idx1,:)), fliplr(mean(a.infoDwellRandSmall(idx1,:))+sem(a.infoDwellRandSmall(idx1,:)))],'c','EdgeColor','none','FaceAlpha', 0.1);
% fill([bins, fliplr(bins)], [mean(a.infoDwellSmall(idx1,:))-sem(a.infoDwellSmall(idx1,:)), fliplr(mean(a.infoDwellSmall(idx1,:))+sem(a.infoDwellSmall(idx1,:)))],a.grey,'EdgeColor','none','FaceAlpha', 0.1);
plot(bins,mean(a.infoDwellInfoBig(idx1,:)),'Color','g','LineWidth',0.5);
plot(bins,mean(a.infoDwellInfoSmall(idx1,:)),'Color','m','LineWidth',0.5); 
plot(bins,mean(a.infoDwellRandBig(idx1,:)),'Color','b','LineWidth',0.5);
plot(bins,mean(a.infoDwellRandSmall(idx1,:)),'Color','c','LineWidth',0.5);
% plot(bins,mean(a.infoDwellBig(idx1,:)),'Color','r','LineWidth',0.5);
% plot(bins,mean(a.infoDwellSmall(idx1,:)),'Color',a.grey,'LineWidth',0.5);
ax.YTick = [0 0.25 0.50 0.75 1];
ax.YLim = [-0.1 1.1];
plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
ax.XLim = [-1 12];
%     xlabel('Time relative to go cue (s)');

ax = nsubplot(5,1,3,1);
ax.FontSize = 8;
ylabel('NO INFO port');
hold on;
fill([bins, fliplr(bins)], [mean(a.randDwellInfoBig(idx1,:))-sem(a.randDwellInfoBig(idx1,:)), fliplr(mean(a.randDwellInfoBig(idx1,:))+sem(a.randDwellInfoBig(idx1,:)))],'g','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.randDwellInfoSmall(idx1,:))-sem(a.randDwellInfoSmall(idx1,:)), fliplr(mean(a.randDwellInfoSmall(idx1,:))+sem(a.randDwellInfoSmall(idx1,:)))],'m','EdgeColor','none','FaceAlpha', 0.1);
% fill([bins, fliplr(bins)], [mean(a.randDwellBig(idx1,:))-sem(a.randDwellBig(idx1,:)), fliplr(mean(a.randDwellBig(idx1,:))+sem(a.randDwellBig(idx1,:)))],'r','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.randDwellRandBig(idx1,:))-sem(a.randDwellRandBig(idx1,:)), fliplr(mean(a.randDwellRandBig(idx1,:))+sem(a.randDwellRandBig(idx1,:)))],'b','EdgeColor','none','FaceAlpha', 0.1);
fill([bins, fliplr(bins)], [mean(a.randDwellRandSmall(idx1,:))-sem(a.randDwellRandSmall(idx1,:)), fliplr(mean(a.randDwellRandSmall(idx1,:))+sem(a.randDwellRandSmall(idx1,:)))],'c','EdgeColor','none','FaceAlpha', 0.1);
% fill([bins, fliplr(bins)], [mean(a.randDwellSmall(idx1,:))-sem(a.randDwellSmall(idx1,:)), fliplr(mean(a.randDwellSmall(idx1,:))+sem(a.randDwellSmall(idx1,:)))],a.grey,'EdgeColor','none','FaceAlpha', 0.1);
plot(bins,mean(a.randDwellInfoBig(idx1,:)),'Color','g','LineWidth',0.5);
plot(bins,mean(a.randDwellInfoSmall(idx1,:)),'Color','m','LineWidth',0.5); 
plot(bins,mean(a.randDwellRandBig(idx1,:)),'Color','b','LineWidth',0.5);
plot(bins,mean(a.randDwellRandSmall(idx1,:)),'Color','c','LineWidth',0.5);
% plot(bins,mean(a.randDwellBig(idx1,:)),'Color','r','LineWidth',0.5);
% plot(bins,mean(a.randDwellSmall(idx1,:)),'Color',a.grey,'LineWidth',0.5);
ax.YTick = [0 0.25 0.50 0.75 1];
ax.YLim = [-0.1 1.1];
ax.XLim = [-1 12];
plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
xlabel('Time relative to go cue (s)');

ax = nsubplot(5,1,4,1);
ax.FontSize = 8;
ylabel('BIG port');
hold on;
fill([bins, fliplr(bins)], [mean(a.bigDwellTime(idx1,:))-sem(a.bigDwellTime(idx1,:)), fliplr(mean(a.bigDwellTime(idx1,:))+sem(a.bigDwellTime(idx1,:)))],'r','EdgeColor','none','FaceAlpha', 0.1);
plot(bins,mean(a.bigDwellTime(idx1,:)),'Color','r','LineWidth',0.5);
ax.YTick = [0 0.25 0.50 0.75 1];
ax.YLim = [-0.1 1.1];
ax.XLim = [-1 12];
plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([11.45 11.45],[-1 +1].*10^10,'color','k','yliminclude','off');
xlabel('Time relative to go cue (s)');

ax = nsubplot(5,1,5,1);
ax.FontSize = 8;
ylabel('SMALL port');
hold on;
fill([bins, fliplr(bins)], [mean(a.smallDwellTime(idx1,:))-sem(a.smallDwellTime(idx1,:)), fliplr(mean(a.smallDwellTime(idx1,:))+sem(a.smallDwellTime(idx1,:)))],grey,'EdgeColor','none','FaceAlpha', 0.1);
plot(bins,mean(a.smallDwellTime(idx1,:)),'Color',grey,'LineWidth',0.5);
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
for i = 1:8
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

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,1,1,1);
ax.FontSize = 8;
% ax.YTick = [0 0.500 1.000 1.500];
% ax.YLim = [0 1.5];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],[a.preRevRxnMean(m,1) a.preRevRxnMean(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],[a.preRevRxnMean(m,3) a.preRevRxnMean(m,4)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);

end
plot(1,mean(a.preRevRxnMean(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(1,mean(a.preRevRxnMean(idx1rev,1),'omitnan'),sem(a.preRevRxnMean(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.preRevRxnMean(idx1rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(3,mean(a.preRevRxnMean(idx1rev,2),'omitnan'),sem(a.preRevRxnMean(idx1rev,2)),'Color','k','LineWidth',2,'CapSize',25);
plot(5,mean(a.preRevRxnMean(idx1rev,3),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(5,mean(a.preRevRxnMean(idx1rev,3),'omitnan'),sem(a.preRevRxnMean(idx1rev,3)),'Color','k','LineWidth',2,'CapSize',25);
plot(7,mean(a.preRevRxnMean(idx1rev,4),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',8);
errorbar(7,mean(a.preRevRxnMean(idx1rev,4),'omitnan'),sem(a.preRevRxnMean(idx1rev,4)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info','No Info','Big','Small'});
ylabel('Reaction time in pre-reversal choice sessions');
p1=signrank(a.preRevRxnMean(idx1rev,1),a.preRevRxnMean(idx1,2));
p2=signrank(a.preRevRxnMean(idx1rev,3),a.preRevRxnMean(idx1,4));
title([label1 ' sign rank info p = ' num2str(p1) ' sign rank water val p = '...
    num2str(p2)])


saveas(fig,fullfile(pathname,[label{1} '_preRevReactionTime']),'pdf');

%% PRE-REVERSAL REWARD RATE CORRECT

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,1,1,1);
ax.FontSize = 8;
% ax.YTick = [0 20 40];
% ax.YLim = [0 40];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],[a.preRevRewardRateCorrMean(m,1) a.preRevRewardRateCorrMean(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],[a.preRevRewardRateCorrMean(m,3) a.preRevRewardRateCorrMean(m,4)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.preRevRewardRateCorrMean(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.preRevRewardRateCorrMean(idx1rev,1),'omitnan'),sem(a.preRevRewardRateCorrMean(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.preRevRewardRateCorrMean(idx1rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.preRevRewardRateCorrMean(idx1rev,2),'omitnan'),sem(a.preRevRewardRateCorrMean(idx1rev,2)),'Color','k','LineWidth',2,'CapSize',25);
plot(5,mean(a.preRevRewardRateCorrMean(idx1rev,3),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(5,mean(a.preRevRewardRateCorrMean(idx1rev,3),'omitnan'),sem(a.preRevRewardRateCorrMean(idx1rev,3)),'Color','k','LineWidth',2,'CapSize',25);
plot(7,mean(a.preRevRewardRateCorrMean(idx1rev,4),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(7,mean(a.preRevRewardRateCorrMean(idx1rev,4),'omitnan'),sem(a.preRevRewardRateCorrMean(idx1rev,4)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info','No Info','Big','Small'});
ylabel('Reward rate on correct trials pre-reversal');
p1=signrank(a.preRevRewardRateCorrMean(idx1rev,1),a.preRevRewardRateCorrMean(idx1,2));
p2=signrank(a.preRevRewardRateCorrMean(idx1rev,3),a.preRevRewardRateCorrMean(idx1,4));
title([label1 ' info p = ' num2str(p1) ' water val p=' num2str(p2)])

saveas(fig,fullfile(pathname,[label{1} '_preRevRewardRateCorr']),'pdf');

%% PRE-REVERSAL REWARD RATE ALL

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,1,1,1);
ax.FontSize = 8;
% ax.YTick = [0 20 40];
% ax.YLim = [0 40];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],[a.preRevRewardRateMean(m,1) a.preRevRewardRateMean(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],[a.preRevRewardRateMean(m,3) a.preRevRewardRateMean(m,4)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.preRevRewardRateMean(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.preRevRewardRateMean(idx1rev,1),'omitnan'),sem(a.preRevRewardRateMean(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.preRevRewardRateMean(idx1rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.preRevRewardRateMean(idx1rev,2),'omitnan'),sem(a.preRevRewardRateMean(idx1rev,2)),'Color','k','LineWidth',2,'CapSize',25);
plot(5,mean(a.preRevRewardRateMean(idx1rev,3),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(5,mean(a.preRevRewardRateMean(idx1rev,3),'omitnan'),sem(a.preRevRewardRateMean(idx1rev,3)),'Color','k','LineWidth',2,'CapSize',25);
plot(7,mean(a.preRevRewardRateMean(idx1rev,4),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(7,mean(a.preRevRewardRateMean(idx1rev,4),'omitnan'),sem(a.preRevRewardRateMean(idx1rev,4)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info','No Info','Big','Small'});
ylabel('Reward rate on all trials pre-reversal');
p1=signrank(a.preRevRewardRateMean(idx1rev,1),a.preRevRewardRateMean(idx1,2));
p2=signrank(a.preRevRewardRateMean(idx1rev,3),a.preRevRewardRateMean(idx1,4));
title([label1 ' info p = ' num2str(p1) ' water val p=' num2str(p2)])

saveas(fig,fullfile(pathname,[label{1} '_preRevRewardRate']),'pdf');

%% PRE-REVERSAL PERCENT CORRECT

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,1,1,1);
ax.FontSize = 8;
ax.YTick = [0 0.25 0.5 0.75 1];
ax.YLim = [0 1];
ax.XLim = [0.5 7.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],[a.preRevCorrectMean(m,1) a.preRevCorrectMean(m,2)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],[a.preRevCorrectMean(m,3) a.preRevCorrectMean(m,4)],'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1,mean(a.preRevCorrectMean(idx1rev,1),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(1,mean(a.preRevCorrectMean(idx1rev,1),'omitnan'),sem(a.preRevCorrectMean(idx1rev,1)),'Color','k','LineWidth',2,'CapSize',25);
plot(3,mean(a.preRevCorrectMean(idx1rev,2),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(3,mean(a.preRevCorrectMean(idx1rev,2),'omitnan'),sem(a.preRevCorrectMean(idx1rev,2)),'Color','k','LineWidth',2,'CapSize',25);
plot(5,mean(a.preRevCorrectMean(idx1rev,3),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(5,mean(a.preRevCorrectMean(idx1rev,3),'omitnan'),sem(a.preRevCorrectMean(idx1rev,3)),'Color','k','LineWidth',2,'CapSize',25);
plot(7,mean(a.preRevCorrectMean(idx1rev,4),'omitnan'),'Color','k','LineWidth',2,'Marker','o','MarkerFaceColor','k','MarkerSize',10);
errorbar(7,mean(a.preRevCorrectMean(idx1rev,4),'omitnan'),sem(a.preRevCorrectMean(idx1rev,4)),'Color','k','LineWidth',2,'CapSize',25);
xticks([1 3 5 7]);
xticklabels({'Info','No Info','Big','Small'});
ylabel('% correct pre-reversal');
p1=signrank(a.preRevCorrectMean(idx1rev,1),a.preRevCorrectMean(idx1,2));
title([label1 ' p = ' num2str(p1)])


saveas(fig,fullfile(pathname,[label{1} '_preRevCorrect']),'pdf');


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

ax = nsubplot(1,1,1,1);
ax.FontSize = 8;
% ax.YTick = [0 0.500 1.000 1.500];
% ax.YLim = [0 2];
ax.XLim = [0.5 15.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],a.reversalRxn(m,(1:2)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],a.reversalRxn(m,(3:4)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([9 11],a.reversalRxn(m,(5:6)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([13 15],a.reversalRxn(m,(7:8)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1:2:15,mean(a.reversalRxn(idx1rev,:),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar(1:2:15,mean(a.reversalRxn(idx1rev,:),'omitnan'),sem(a.reversalRxn(idx1rev,:)),'Color','k','LineWidth',2,'CapSize',25);
xticks(1:2:15);
xticklabels({'Info Pre','No Info Pre','Big Pre','Small Pre','Info Post','No Info Post','Big Post','Small Post'});
ylabel('Reaction time across reversal choice sessions');
p1=signrank(a.reversalRxn(idx1rev,1),a.reversalRxn(idx1,2));
p2=signrank(a.reversalRxn(idx1rev,3),a.reversalRxn(idx1,4));
p3=signrank(a.reversalRxn(idx1rev,5),a.reversalRxn(idx1,6));
p4=signrank(a.reversalRxn(idx1rev,7),a.reversalRxn(idx1,8));
title([label1 ' info pre p = ' num2str(p1) ' info post p = ' num2str(p2) ' waterval pre p=' num2str(p3) ' waterval post p=' num2str(p4)])

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

ax = nsubplot(1,1,1,1);
ax.FontSize = 8;
% ax.YTick = [0 0.500 1.000 1.500];
% ax.YLim = [0 2];
ax.XLim = [0.5 15.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],a.reversalRewardRateCorr(m,(1:2)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],a.reversalRewardRateCorr(m,(3:4)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([9 11],a.reversalRewardRateCorr(m,(5:6)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([13 15],a.reversalRewardRateCorr(m,(7:8)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1:2:15,mean(a.reversalRewardRateCorr(idx1rev,:),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar(1:2:15,mean(a.reversalRewardRateCorr(idx1rev,:),'omitnan'),sem(a.reversalRewardRateCorr(idx1rev,:)),'Color','k','LineWidth',2,'CapSize',25);
xticks(1:2:15);
xticklabels({'Info Pre','No Info Pre','Big Pre','Small Pre','Info Post','No Info Post','Big Post','Small Post'});
ylabel('Reward rate on correct trials across reversal choice sessions (mL/min)');
p1=signrank(a.reversalRewardRateCorr(idx1rev,1),a.reversalRewardRateCorr(idx1,2));
p2=signrank(a.reversalRewardRateCorr(idx1rev,3),a.reversalRewardRateCorr(idx1,4));
p3=signrank(a.reversalRewardRateCorr(idx1rev,5),a.reversalRewardRateCorr(idx1,6));
p4=signrank(a.reversalRewardRateCorr(idx1rev,7),a.reversalRewardRateCorr(idx1,8));
title([label1 ' info pre p = ' num2str(p1) ' info post p = ' num2str(p2) ' waterval pre p=' num2str(p3) ' waterval post p=' num2str(p4)])

saveas(fig,fullfile(pathname,[label{1} '_ReversalRewardRateCorr']),'pdf');

%% REVERSAL REWARD RATE

[a.reversalRewardRatepval1, tbl, stats] = friedman(a.reversalRewardRate(idx1,:), 1,'off');
a.reversalRewardRateComp1 = multcompare(stats,'Display','off');


fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,1,1,1);
ax.FontSize = 8;
% ax.YTick = [0 0.500 1.000 1.500];
% ax.YLim = [0 2];
ax.XLim = [0.5 15.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],a.reversalRewardRate(m,(1:2)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],a.reversalRewardRate(m,(3:4)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([9 11],a.reversalRewardRate(m,(5:6)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([13 15],a.reversalRewardRate(m,(7:8)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1:2:15,mean(a.reversalRewardRate(idx1rev,:),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar(1:2:15,mean(a.reversalRewardRate(idx1rev,:),'omitnan'),sem(a.reversalRewardRate(idx1rev,:)),'Color','k','LineWidth',2,'CapSize',25);
xticks(1:2:15);
xticklabels({'Info Pre','No Info Pre','Big Pre','Small Pre','Info Post','No Info Post','Big Post','Small Post'});
ylabel('Reward rate on all trials across reversal choice sessions (mL/min)');
p1=signrank(a.reversalRewardRate(idx1rev,1),a.reversalRewardRate(idx1,2));
p2=signrank(a.reversalRewardRate(idx1rev,3),a.reversalRewardRate(idx1,4));
p3=signrank(a.reversalRewardRate(idx1rev,5),a.reversalRewardRate(idx1,6));
p4=signrank(a.reversalRewardRate(idx1rev,7),a.reversalRewardRate(idx1,8));
title([label1 ' info pre p = ' num2str(p1) ' info post p = ' num2str(p2) ' waterval pre p=' num2str(p3) ' waterval post p=' num2str(p4)])

saveas(fig,fullfile(pathname,[label{1} '_ReversalRewardRate']),'pdf');

%% REVERSAL PERCENT CORRECT

[a.reversalCorrectpval1, tbl, stats] = friedman(a.reversalCorrect(idx1rev,:), 1,'off');
a.reversalCorrectComp1 = multcompare(stats,'Display','off');


fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,1,1,1);
ax.FontSize = 8;
% ax.YTick = [0 0.500 1.000 1.500];
% ax.YLim = [0 2];
ax.XLim = [0.5 15.5];

for mm = 1:numel(idx1rev)
    m=idx1rev(mm);
    plot([1 3],a.reversalCorrect(m,(1:2)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([5 7],a.reversalCorrect(m,(3:4)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([9 11],a.reversalCorrect(m,(5:6)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
    plot([13 15],a.reversalCorrect(m,(7:8)),'Color',grey,'LineStyle',':','LineWidth',2,'Marker','o','MarkerFaceColor',grey);
end
plot(1:2:15,mean(a.reversalCorrect(idx1rev,:),'omitnan'),'o','MarkerFaceColor','k','MarkerSize',8);
errorbar(1:2:15,mean(a.reversalCorrect(idx1rev,:),'omitnan'),sem(a.reversalCorrect(idx1rev,:)),'Color','k','LineWidth',2,'CapSize',25);
xticks(1:2:15);
xticklabels({'Info Pre','No Info Pre','Big Pre','Small Pre','Info Post','No Info Post','Big Post','Small Post'});
ylabel('% correct across reversal');
p1=signrank(a.reversalCorrect(idx1rev,1),a.reversalCorrect(idx1,2));
p2=signrank(a.reversalCorrect(idx1rev,3),a.reversalCorrect(idx1,4));
p3=signrank(a.reversalCorrect(idx1rev,5),a.reversalCorrect(idx1,6));
p4=signrank(a.reversalCorrect(idx1rev,7),a.reversalCorrect(idx1,8));
title([label1 ' info pre p = ' num2str(p1) ' info post p = ' num2str(p2) ' waterval pre p=' num2str(p3) ' waterval post p=' num2str(p4)])

saveas(fig,fullfile(pathname,[label{1} '_ReversalCorrect']),'pdf');


%%
set(0,'DefaultFigureWindowStyle','normal');