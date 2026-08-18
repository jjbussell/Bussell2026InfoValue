%% CodingStability

%% Counts of cells

mouseCells=histc(a.mouse(:),unique(a.mouse));
mouseCellCts=[0; cumsum(mouseCells)];
trialsM=sum(~isnan(a.C_events{3}(cumsum(mouseCells),1,:)),3);
trialCts=[0;cumsum(trialsM)];

%% Organize data by session (day)

for d=1:4
    dayInfo=[];
    dayRand=[];
    dayInfoT=[];
    dayRandT=[];
    for mm=1:numel(okMice)
        m=okMice(mm);
        mouseDays=a.day(trialCts(m)+1:trialCts(m+1));
        mouseChoice=a.imagingChoice(trialCts(m)+1:trialCts(m+1));
        mousePrevCorr=a.imagingPrevCorrect(trialCts(m)+1:trialCts(m+1));
        [~, a.mouseDays{m}] = ismember(mouseDays,unique(mouseDays));

        mouseInfoDays=a.mouseDays{m}(mouseChoice==1&mousePrevCorr==1);
        mouseRandDays=a.mouseDays{m}(mouseChoice==3&mousePrevCorr==1);
        
        dayInfoMT=mean(a.C_odor1FirstInfoForced(a.mouse==m,:,mouseInfoDays==d),3,'omitnan');
        dayInfoM=mean(squeeze(mean(a.C_odor1FirstInfoForced(a.mouse==m,a.okt{3},mouseInfoDays==d),2,'omitnan')),2);
        dayInfo=[dayInfo; dayInfoM];
        dayInfoT=[dayInfoT; dayInfoMT];
        dayRandM=mean(squeeze(mean(a.C_odor1FirstRandForced(a.mouse==m,a.okt{3},mouseRandDays==d),2,'omitnan')),2);
        dayRandMT=mean(a.C_odor1FirstRandForced(a.mouse==m,:,mouseInfoDays==d),3,'omitnan');
        dayRand=[dayRand; dayRandM];
        dayRandT=[dayRandT; dayRandMT];
    end
    infoByDay{d}=dayInfo;
    randByDay{d}=dayRand;
    infoByDayT{d}=dayInfoT;
    randByDayT{d}=dayRandT;
end


%% Correlation between consecutive days

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
title(['Info corr= ' num2str(co) ' p= ' num2str(p,'%.4e') ]);
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
title(['Rand corr= ' num2str(co) ' p= ' num2str(p,'%.4e') ]);
axis square;
hold off;
saveas(fig,fullfile(plotfolder,[strjoin(mice,'_') '_ConsecutiveDayCorr']),'pdf');

%% HEATMAP of consecutive-day activity

color_limits = [-1.2 1.2];

e=3;

[infoSort,infoIdx] = sort(mean(squeeze(mean(a.C_odor1FirstInfoForced(:,40:60,:),2,'omitnan')),2,'omitnan'),'descend');
[randSort,randIdx] = sort(mean(squeeze(mean(a.C_odor1FirstRandForced(:,40:60,:),2,'omitnan')),2,'omitnan'),'descend');
y_info=mean(a.C_odor1FirstInfoForced,3,'omitnan');
y_info=y_info-mean(y_info(:,30:40),2);
y_rand=mean(a.C_odor1FirstRandForced,3,'omitnan');
y_rand=y_rand-mean(y_rand(:,30:40),2);
[~,INdiffIdx] = sort(mean(y_info(:,40:60),2)-mean(y_rand(:,40:60),2),'descend');
% cell_sort_ids=isASort;
% cell_sort_ids=infoIdx;
cell_sort_ids = INdiffIdx;
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
set(gca, 'XTickLabel', xticklabels2)
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
