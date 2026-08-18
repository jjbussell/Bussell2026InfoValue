% find which day each info first trial is from, same for no info
% mean activity on that trial
% for each cell, plot mean info day 1 vs mean info day 2
% a.C_odor1FirstInfoForced, a.C_odor1FirstRandForced

% a.day(a.imagingChoice==1 & a.imagingPrevCorrect == 1)

mouseCells=histc(a.mouse(:),unique(a.mouse));
mouseCellCts=[0; cumsum(mouseCells)];
trialsM=sum(~isnan(a.C_events{3}(cumsum(mouseCells),1,:)),3);
trialCts=[0;cumsum(trialsM)];

%%

for d=1:4
    dayInfo=[];
    dayRand=[];
    dayInfoT=[];
    dayRandT=[];
    dayBig=[]; dayBigT=[];
    daySmall=[]; daySmallT=[];
    for mm=1:numel(okMice)
        m=okMice(mm);
        mouseDays=a.day(trialCts(m)+1:trialCts(m+1));
        mouseChoice=a.imagingChoice(trialCts(m)+1:trialCts(m+1));
        mousePrevCorr=a.imagingPrevCorrect(trialCts(m)+1:trialCts(m+1));
        [~, a.mouseDays{m}] = ismember(mouseDays,unique(mouseDays));

        mouseInfoDays=a.mouseDays{m}(mouseChoice==2&mousePrevCorr==1);
        mouseRandDays=a.mouseDays{m}(mouseChoice==3&mousePrevCorr==1);
        mouseBigDays=a.mouseDays{m}(mouseChoice==4&mousePrevCorr==1);
        mouseSmallDays=a.mouseDays{m}(mouseChoice==1&mousePrevCorr==1);
        
        dayInfoMT=mean(a.C_odor1InfoFirst(a.mouse==m,:,mouseInfoDays==d),3,'omitnan');
        dayInfoM=mean(squeeze(mean(a.C_odor1InfoFirst(a.mouse==m,a.okt{3},mouseInfoDays==d),2,'omitnan')),2,'omitnan');
        dayInfo=[dayInfo; dayInfoM];
        dayInfoT=[dayInfoT; dayInfoMT];
        dayRandM=mean(squeeze(mean(a.C_odor1RandFirst(a.mouse==m,a.okt{3},mouseRandDays==d),2,'omitnan')),2,'omitnan');
        dayRandMT=mean(a.C_odor1RandFirst(a.mouse==m,:,mouseInfoDays==d),3,'omitnan');
        dayRand=[dayRand; dayRandM];
        dayRandT=[dayRandT; dayRandMT];
        dayBigMT=mean(a.C_odor1BigFirst(a.mouse==m,:,mouseBigDays==d),3,'omitnan');
        dayBigM=mean(squeeze(mean(a.C_odor1BigFirst(a.mouse==m,a.okt{3},mouseBigDays==d),2,'omitnan')),2,'omitnan');
        dayBig=[dayBig; dayBigM];
        dayBigT=[dayBigT; dayBigMT];
        daySmallMT=mean(a.C_odor1SmallFirst(a.mouse==m,:,mouseSmallDays==d),3,'omitnan');
        daySmallM=mean(squeeze(mean(a.C_odor1SmallFirst(a.mouse==m,a.okt{3},mouseSmallDays==d),2,'omitnan')),2,'omitnan');
        daySmall=[daySmall; daySmallM];
        daySmallT=[dayInfoT; daySmallMT];        
    end
    infoByDay{d}=dayInfo;
    randByDay{d}=dayRand;
    infoByDayT{d}=dayInfoT;
    randByDayT{d}=dayRandT;
    smallByDay{d}=daySmall;
    bigByDay{d}=dayBig;
    bigByDayT{d}=dayBigT;
    smallByDayT{d}=daySmallT;    
end


%%

fig = figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [1 1 10 7];
set(fig,'PaperOrientation','landscape');
set(fig,'renderer','painters');

ax1=nsubplot(1,2,1,1);
hold on;
scatter(ax1,[infoByDay{1}; infoByDay{3}],[infoByDay{2};infoByDay{4}], 'k');
[co,p]=corr([infoByDay{1}; infoByDay{3}],[infoByDay{2};infoByDay{4}],'Type','Pearson');
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
h = refline(1, 0);          % slope = 1, intercept = 0
h.Color = 'r';              % optional: change color
h.LineStyle = '--'; 
xlabel('Mean Info Activity Day 1&3');
ylabel('Mean Info Activity Day 2&4');
title(['Info corr= ' num2str(co) ' p= ' num2str(p,'%.4g') ]);
axis square;
hold off;

ax2=nsubplot(1,2,1,2);
hold on;
scatter(ax2,[randByDay{1}; randByDay{3}],[randByDay{2};randByDay{4}], 'k');
[co,p]=corr([randByDay{1}; randByDay{3}],[randByDay{2};randByDay{4}],'Type','Pearson');
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
h = refline(1, 0);          % slope = 1, intercept = 0
h.Color = 'r';              % optional: change color
h.LineStyle = '--'; 
xlabel('Mean Rand Activity Day 1&3');
ylabel('Mean Rand Activity Day 2&4');
title(['Rand corr= ' num2str(co) ' p= ' num2str(p,'%.4g') ]);
axis square;
hold off;
saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_ConsecutiveDayCorr']),'pdf');


fig = figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [1 1 10 7];
set(fig,'PaperOrientation','landscape');
set(fig,'renderer','painters');

ax1=nsubplot(1,2,1,1);
hold on;
scatter(ax1,[bigByDay{1}; bigByDay{3}],[bigByDay{2};bigByDay{4}], 'k');
[co,p]=corr([bigByDay{1}; bigByDay{3}],[bigByDay{2};bigByDay{4}],'Type','Pearson');
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
h = refline(1, 0);          % slope = 1, intercept = 0
h.Color = 'r';              % optional: change color
h.LineStyle = '--'; 
xlabel('Mean big Activity Day 1&3');
ylabel('Mean big Activity Day 2&4');
title(['big corr= ' num2str(co) ' p= ' num2str(p,'%.4g') ]);
axis square;
hold off;

ax2=nsubplot(1,2,1,2);
hold on;
scatter(ax2,[smallByDay{1}; smallByDay{3}],[smallByDay{2};smallByDay{4}], 'k');
[co,p]=corr([smallByDay{1}; smallByDay{3}],[smallByDay{2};smallByDay{4}],'Type','Pearson');
% plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
h = refline(1, 0);          % slope = 1, intercept = 0
h.Color = 'r';              % optional: change color
h.LineStyle = '--'; 
xlabel('Mean Small Activity Day 1&3');
ylabel('Mean Small Activity Day 2&4');
title(['small corr= ' num2str(co) ' p= ' num2str(p,'%.4g') ]);
axis square;
hold off;
saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_ConsecutiveDayWaterCorr']),'pdf');

%%

color_limits = [-1.2 1.2];
% diff_limits = [-0.6 0.6];

% a.test= make_colormap(a.darkcyan,'k',[0.85 0 0]);

e=3;

[infoSort,infoIdx] = sort(mean(squeeze(mean(a.C_odor1InfoFirst(:,40:60,:),2,'omitnan')),2,'omitnan'),'descend');
[randSort,randIdx] = sort(mean(squeeze(mean(a.C_odor1RandFirst(:,40:60,:),2,'omitnan')),2,'omitnan'),'descend');
y_info=mean(a.C_odor1InfoFirst,3,'omitnan');
y_info=y_info-mean(y_info(:,30:40),2);
y_rand=mean(a.C_odor1RandFirst,3,'omitnan');
y_rand=y_rand-mean(y_rand(:,30:40),2);
[~,INdiffIdx] = sort(mean(y_info(:,40:60),2)-mean(y_rand(:,40:60),2),'descend');
% cell_sort_ids=isASort;
cell_sort_ids=infoIdx;
% cell_sort_ids = INdiffIdx;
% [~,cell_sort_ids] = sort(y_info,'descend');

[day1Sort,day1Idx] = sort(infoByDay{1},'descend');

[day1NSort,day1NIdx] = sort(randByDay{1},'descend');

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');

% cell_sort_ids=day1Idx;

ax=nsubplot(1,4,1,1);
y=infoByDayT{1};
y=y-mean(y(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
% ax.YAxis.Visible = 'off';
xlabel('Seconds');
set(ax, 'Ydir', 'reverse')
title('Info Day 1')

ax=nsubplot(1,4,1,2);
y=infoByDayT{2};
y=y-mean(y(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
ax.YAxis.Visible = 'off';
xlabel('Seconds');
set(ax, 'Ydir', 'reverse')
title('Info Day 2')

ax=nsubplot(1,4,1,3);
y=randByDayT{1};
y=y-mean(y(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
ax.YAxis.Visible = 'off';
xlabel('Seconds');
set(ax, 'Ydir', 'reverse')
title('Rand Day 1')

ax=nsubplot(1,4,1,4);
y=randByDayT{2};
y=y-mean(y(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
ax.YAxis.Visible = 'off';
xlabel('Seconds');
set(ax, 'Ydir', 'reverse')
title('Rand Day 2')

colorcet('D1');

saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_ConsecutiveDayHeatmap']),'pdf');

%%

color_limits = [-1.2 1.2];
% diff_limits = [-0.6 0.6];

% a.test= make_colormap(a.darkcyan,'k',[0.85 0 0]);

e=3;

[infoSort,infoIdx] = sort(mean(squeeze(mean(a.C_odor1BigFirst(:,40:60,:),2,'omitnan')),2,'omitnan'),'descend');
[randSort,randIdx] = sort(mean(squeeze(mean(a.C_odor1SmallFirst(:,40:60,:),2,'omitnan')),2,'omitnan'),'descend');
y_info=mean(a.C_odor1BigFirst,3,'omitnan');
y_info=y_info-mean(y_info(:,30:40),2);
y_rand=mean(a.C_odor1SmallFirst,3,'omitnan');
y_rand=y_rand-mean(y_rand(:,30:40),2);
[~,INdiffIdx] = sort(mean(y_info(:,40:60),2)-mean(y_rand(:,40:60),2),'descend');
% cell_sort_ids=isASort;
cell_sort_ids=infoIdx;
% cell_sort_ids = INdiffIdx;
% [~,cell_sort_ids] = sort(y_info,'descend');

[day1Sort,day1Idx] = sort(infoByDay{1},'descend');

[day1NSort,day1NIdx] = sort(randByDay{1},'descend');

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');

% cell_sort_ids=day1Idx;

ax=nsubplot(1,4,1,1);
y=infoByDayT{1};
y=y-mean(y(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
% ax.YAxis.Visible = 'off';
xlabel('Seconds');
set(ax, 'Ydir', 'reverse')
title('Big Day 1')

ax=nsubplot(1,4,1,2);
y=infoByDayT{2};
y=y-mean(y(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
ax.YAxis.Visible = 'off';
xlabel('Seconds');
set(ax, 'Ydir', 'reverse')
title('Big Day 2')

ax=nsubplot(1,4,1,3);
y=randByDayT{1};
y=y-mean(y(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
ax.YAxis.Visible = 'off';
xlabel('Seconds');
set(ax, 'Ydir', 'reverse')
title('Small Day 1')

ax=nsubplot(1,4,1,4);
y=randByDayT{2};
y=y-mean(y(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
ax.YAxis.Visible = 'off';
xlabel('Seconds');
set(ax, 'Ydir', 'reverse')
title('Small Day 2')

colorcet('D1');

saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_ConsecutiveDayHeatmapWater']),'pdf');

%% LOAD CROSS-DAY SCOUT REGISTRATION

load('JB483_4days_20240614_20240618_20240625_20240628_SCOUTreg_stab.mat')
probsAll{1}=probs;
load('JB484_4days_20240516_20240517_20240524_20240528_stab.mat')
probsAll{2}=probs;
load('JB506_4days_20250205_20250206_20250212_20250213_SCOUTreg_stab.mat')
probsAll{3}=probs;
load('JB507_4days_20250206_20250207_20250213_20250214_SCOUTreg_stab.mat')
probsAll{4}=probs;
load('JB509_4days_20250205_20250206_20250213_20250214_SCOUTreg_stab.mat')
probsAll{5}=probs;

%% PLOT CROSS-DAY REGISTRATION PROBABILITIES

fig = figure();    
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0.5 0.5 10 7];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax = nsubplot(1,1,1,1);
ax.FontSize = 8;
ax.XTick = [1 2 3 4 5];
ax.XLim = [0,6];
ax.YTick = [0 0.25 0.50 0.75 1];
% ax.XTickLabel = {label1,label2};
ax.YLim = [0 1];

for i=1:5
    v=Violin(probsAll{i},i); 
    v.ViolinColor=[0.4 0.4 0.4];
    v.EdgeColor='none'; 
    v.BoxColor='none';
    v.ScatterPlot.MarkerFaceColor='k';
    v.ScatterPlot.MarkerFaceAlpha=1;
    v.ShowMean=true;    
end

% text(0.5,0.1,{['mean ' num2str(mean(choiceSort1,'omitnan'))] ['p = ' num2str(p1)]})
% text(1.5,0.1,{['mean ' num2str(mean(choiceSort2,'omitnan'))] ['p = ' num2str(p2)]})
% ylabel('Initial info side preference');
% xlabel('Mouse');
% title([label{1} ' p=' num2str(p)]);
hold off;
% axis square;

saveas(fig,fullfile(plotfolder,'WaterValSCOUTProbs'),'pdf');