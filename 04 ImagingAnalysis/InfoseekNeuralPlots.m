%% InfoseekNeuralPlots

%% PARAMS

PC=1;

a.grey = [.8 .8 .8];
a.purple = [121 32 196] ./ 255;
a.lightPurple = [204 204 255] ./ 255;
a.orange = [251 139 6] ./ 255;
a.lightOrange = [255 204 153] ./ 255;
a.cornflower = [100 149 237] ./ 255;
a.teal = [0 128 128] ./ 255;
a.darkcyan = [0 139 139] ./ 255;

color_limits = [-1.6 1.6];
side_limits = [-1.2 1.2];
diff_limits = [-0.8 0.8];

heatLim = [-0.2 1];

RA=0;
width = 5;

a.decodeNames={'Info','Side','ChoiceForced'};
a.decodeLabels= {{'Info','No Info'},{'Left','Right'},{'Forced','Choice'}};

a.resp_win=params.resp_win;
a.colors = {{a.purple,a.lightPurple,a.orange,a.lightOrange};{a.purple,a.lightPurple,a.orange,a.lightOrange};...
    {'g','m',a.cornflower,a.cornflower};...
    {'g','m','b','c'}};
a.titles = {'Center Odor Side','Center Odor',...
    'Side Odor','Outcome'};
a.labels = {{'Center Odor Info Left','Center Odor Info Right','Center Odor No Info Left','Center Odor No Info Right'};...
    {'Center Odor Info Forced','Center Odor Info Choice','Center Odor No Info Forced','Center Odor No Info Choice'};...
    {'Side Odor A Info Water','Side Odor B Info No Water','Side Odor No Info C','Side Odor No Info D'};...
    {'Outcome Info Water','Outcome Info No Water','Outcome Rand Water','Outcome Rand No Water'}};
a.conditionLabels = {{'Info Left','Info Right','No Info Left','No Info Right'};...
    {'Info Forced','Info Choice','No Info Forced','No Info Choice'};...
    {'A Info Water','B Info No Water','No Info C','No Info D'};...
    {'Info Water','Info No Water','No Info Water','No Info No Water'}};
a.compTitles = {'Center Odor', 'Side Odor', 'Outcome', 'Side Odor Controls','Side Odor Controls 2'};
a.compOrder = {{1,2},{3,4,5},{5,6,7},{8,9},{10}};
a.compLabels = {'Left - Right'; 'Info - No Info';...
    'Info Water A - Info No Water B';'No Info C - No Info D';'InfoAB - No InfoCD';...                                                   
    'Info Water - Info No Water';'No Info Water - No Info No Water';...
    'Info No Water B - No Info C';'Info Water A - No Info D';'AC - BD';'Info choice-no info';'Info - No Info'};
a.legendnames = {'Info Forced','Info Choice','No Info Forced','No Info Choice','Info Water','Info No Water','No Info C','No Info D','No Info Water','No Info No Water'};
a.legendcolors = {a.purple,a.lightPurple,a.orange,a.lightOrange,'g','m',a.cornflower,a.cornflower,'b','c'};

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

output_dir=plotfolder;
cellpath = fullfile(output_dir,'Cells');
if ~isdir(cellpath)
mkdir(cellpath);
end

set(0,'DefaultFigureWindowStyle','docked');

% SORTING
sorting = 1;



%% TRIAL CODING INDEX

% INFO

t=a.t{11};
color_limitsEBM=[-1 1];

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
    set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');
ax=nsubplot(1,1,1,1);
y=a.activityDifferenceTrialEBM{1};
% ytosort=mean(y(
[~, maxIndices] = max(y(:,364:640), [], 2);
[~, cell_sort_ids] = sort(maxIndices);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limitsEBM);
colorcet('D1');
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'k','yliminclude','off');
plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'k','yliminclude','off');
plot([11.45 11.45],[-1 +1].*10^10,'k','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
xlim([-1 14]);
xlabel('Seconds');
ylabel('Cells');
title('Info-No Info Coding Index (sort)');
ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')
saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_heatmapInfoandWaterCodingIdxbyinfo1']),'pdf');

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
    set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');
ax=nsubplot(1,1,1,1);
y=a.activityDifferenceTrialEBM{2};
% [~, maxIndices] = max(y, [], 2);
% [~, cell_sort_ids] = sort(maxIndices);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limitsEBM);
colorcet('D1');
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'k','yliminclude','off');
plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'k','yliminclude','off');
plot([11.45 11.45],[-1 +1].*10^10,'k','yliminclude','off');
axis tight;
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% ax.YAxis.Visible = 'off';
xlim([-1 14]);
xlabel('Seconds');
ylabel('Cells');
title('Water Big-Small Coding Index, sort info');
% xticks([-2:0.2:2]); 
ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')
saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_heatmapInfoandWaterCodingIdxbyinfo2']),'pdf');

% Water

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
    set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');
ax=nsubplot(1,1,1,1);
y=a.activityDifferenceTrialEBM{2};
[~, maxIndices] = max(y(:,392:640), [], 2);
[~, cell_sort_ids] = sort(maxIndices);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limitsEBM);
colorcet('D1');
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'k','yliminclude','off');
plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'k','yliminclude','off');
plot([11.45 11.45],[-1 +1].*10^10,'k','yliminclude','off');
axis tight;
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% ax.YAxis.Visible = 'off';
xlim([-1 14]);
xlabel('Seconds');
ylabel('Cells');
title('Water Big-Small Coding Index (sort)');
ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')
saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_heatmapInfoandWaterCodingIdxbyWater1']),'pdf');

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
    set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');
ax=nsubplot(1,1,1,1);
y=a.activityDifferenceTrialEBM{1};
% [~, maxIndices] = max(y, [], 2);
% [~, cell_sort_ids] = sort(maxIndices);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limitsEBM);
colorcet('D1');
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'k','yliminclude','off');
plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'k','yliminclude','off');
plot([11.45 11.45],[-1 +1].*10^10,'k','yliminclude','off');
axis tight;
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% ax.YAxis.Visible = 'off';
xlim([-1 14]);
xlabel('Seconds');
ylabel('Cells');
title('Info-No Info Coding Index sort water');
% xticks([-2:0.2:2]); 
ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')
saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_heatmapInfoandWaterCodingIdxbyWater2']),'pdf');

%% MEAN WHOLE TRIAL CODING INDEX

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax=nsubplot(1,1,1,1);
ax.FontSize = 8;
hold on;
h_for_legend = [];
t=a.t{11};
% for j=1:1000
%    plot(t,mean(squeeze(a.activityDifferenceTrialEBMShuffle{1}(:,:,j))),'Color',a.grey,'LineWidth',0.2);
% end
ymean=mean(a.activityDifferenceTrialEBM{1});
ysem=sem(a.activityDifferenceTrialEBM{1});
h = fill([t, fliplr(t)], [ymean-ysem, fliplr(ymean+ysem)],a.purple,'EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(t,ymean,'color',a.purple,'linewidth',width); % only this plot is used for legend!!
ymean=mean(a.activityDifferenceTrialEBM{2});
ysem=sem(a.activityDifferenceTrialEBM{2});
h = fill([t, fliplr(t)], [ymean-ysem, fliplr(ymean+ysem)],'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(t,ymean,'color','b','linewidth',width); % only this plot is used for legend!!
plot([0+PID 0+PID],[-1 +1].*10^10,'k','yliminclude','off');
plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'k','yliminclude','off');
plot([11.45 11.45],[-1 +1].*10^10,'k','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
xlim([-1 14]);
xlabel('Seconds');
ylim([0 0.2]);
ylabel('Mean Population Coding Index')
leg = legend(h_for_legend,{'Info','Water'},'Orientation','horizontal','Location','southoutside','Box','off');
leg.FontSize = 6;

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ActivityIDXFullTrial']),'pdf');

%% CODING INDEX ACTIVITY ONE FIGURE

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 8];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

width=2;


for cd = 1:numel(a.compOrder)
    corder = a.compOrder{cd};
    ax4 = nsubplot(1,numel(a.compOrder),1,cd);
    hold on; 
    h_for_legend = [];
    clabel = [];
    for cm = 1:numel(corder)
        ci = corder{cm};
        e = a.compEventsFirst(ci);
            y = a.activityDifferenceEBM{ci};
            ymean = nanmean(y,1);
            ysem = nanstd(y,[],1) ./ sqrt(size(y,1));
            t=a.t{e};
                h = fill([t, fliplr(t)], [ymean-ysem, fliplr(ymean+ysem)],'r','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
            if cm == 1
                h_for_legend(end+1)=plot(ax4,t,ymean,'color','k','linewidth',width); % only this plot is used for legend!!
            elseif cm == 2
                h_for_legend(end+1)=plot(ax4,t,ymean,'color','k','linewidth',width,'linestyle',':'); % only this plot is used for legend!!
            else
                h_for_legend(end+1)=plot(ax4,t,ymean,'color','k','linewidth',width,'linestyle','--'); % only this plot is used for legend!!
            end
            clabel{end+1} = a.compLabels{ci};            
        if cm == numel(corder)
            xlim(t([1 end])); 
%                 ylim([0 1]);
%             setlim(ax4,'ylim','tight',[0 0.7]);
            xticks([-2:0.5:2]);
%             yticks([0 0.25 0.5]);
            set(gca,'fontsize',6); 
            plot([0 0],[-1*10^10 .75],'color','k','yliminclude','off');
            plot([-1 +1].*10^10,[0 0],'color',a.grey,'yliminclude','off');
            plot([a.resp_win(1) a.resp_win(1)],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
            plot([a.resp_win(2) a.resp_win(2)],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
            if ~isempty(h_for_legend)
            leg = legend(h_for_legend,clabel{:},'Location','southoutside','Orientation','vertical');
            legend('boxoff')
            leg.FontSize = 6;
            end
    %             xlabel('Seconds relative to event start');
            if cd==1
                ylabel({'Balanced index'; 'difference in activity'},'FontWeight','bold');
            end
            title(a.compTitles{cd});
            hold off
            axis square;
        end 
    end
end

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_CodingIdx_SUMMARY']),'pdf');


%% FULL TRIAL ACTIVITY DIFFERENCE PLOT

a.trialColors = {a.purple,'b','g',a.orange,'c','r'};
cebrastart=320;
cebrastop=640;

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

width = 1;

e=11;
hold on;

nsubplot(1,1,1,1);
h_for_legend=[];
for cd=1:numel(a.trialCompNames)
    curcolor=a.trialColors{cd};

    ypop=a.activityDifferenceTrialEBM{cd};
    ymean=mean(ypop);
    ysem = nanstd(ypop,[],1) ./ sqrt(size(ypop,1));
    t=a.t{e}(cebrastart:cebrastop);
    ymean=ymean(cebrastart:cebrastop);
    ysem=ysem(cebrastart:cebrastop);
      h = fill([t, fliplr(t)], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    h_for_legend(end+1)=plot(t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
end
plot([0+PID 0+PID],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
plot([1.2 1.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
plot([1.65 1.65],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
plot([2.65 2.65],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
plot([12.85 12.85],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
plot([11.85 11.85],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
plot([0+PID 0+PID],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([11.65 11.65],[-1 +1].*10^10,'color','k','yliminclude','off');
xticks([-1:1:14])
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
set(gca,'fontsize',8);
setlim('ylim','tight');
xlim([-1 14])
hold off;
%     end
%     axis square
ylabel('Calcium activity');
xlabel('Time from Odor 1 Onset (s)');
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
leg = legend(h_for_legend,{'Info v No Info','Water all v No Water all','A v B','C v D','No Info Water v None','Left v Right'},'Orientation','horizontal','Location','southoutside','Box','off');

% text(0.51, 0.98,[strjoin(mice,' _ '),' Response Power First Center Entry'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');
% 
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_TrialMeanActivityDiffEBM']),'pdf');

%% CODING INDEX PLOT EACH EVENT

for cd = 1:size(a.compNamesFirst)
    
    figure();
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 11 8.5];
        set(fig,'renderer','painters');
    set(fig,'PaperOrientation','landscape');
    
    
    label=a.compLabels{cd};
    nsubplot(1,1,1,1);
    e=6;
    ypop=a.activityDifferenceEBM{cd};
    ymean=mean(ypop);
    ysem = nanstd(ypop,[],1) ./ sqrt(size(ypop,1));
    t=a.t{e};
%     for j=1:1000
%         plot(t,mean(squeeze(a.activityDifferenceEBMShuffle{cd}(:,:,j))),'Color',a.grey,'LineWidth',0.2);
% %         plot(t,mean(squeeze(a.shuffleDiff{cd}(:,:,j))),'Color',a.grey,'LineWidth',0.2);
%     end
    h = fill([t, fliplr(t)], [ymean-ysem, fliplr(ymean+ysem)],'r','EdgeColor','none');
    set(h, 'FaceAlpha', 0.1);
    plot(t,ymean,'color','r','linewidth',width); % only this plot is used for legend!!    
    set(gca,'fontsize',8);
    ylim([-0.05 0.25]);
    ylabel('Calcium activity');
    xlabel('Time from Event Onset (s)');
    title([label sprintf(' p = %.3g', a.actDiffPopIdxEBMSig{cd})]);
    plot([0+PID 0+PID],[-1 +1].*10^10,'color','k','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
    plot([1.2 1.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
    plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
    if cd ~= 6 & cd~= 7
        xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
        xticks2 = xticks2 + PID;
        xticks(xticks2);
        xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
        set(gca, 'XTickLabel', xticklabels2);
    end
    xlim([-0.5 1.5+PID])
    saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_CodingIdx_' label]),'pdf');
       
end

%% HEATMAPS


%% CENTER ODOR LEFT/RIGHT

e=3;

[leftSort,leftIdx] = sort(mean(squeeze(mean(a.C_odor1FirstLeft(:,40:60,:),2,'omitnan')),2,'omitnan'),'descend');
[rightSort,rightIdx] = sort(mean(squeeze(mean(a.C_odor1FirstRight(:,40:60,:),2,'omitnan')),2,'omitnan'),'descend');
% [~,LRdiffSort] = sort(mean(squeeze(mean(a.C_odor1FirstLeft(:,40:60,:),2,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstRight(:,40:60,:),2,'omitnan')),2,'omitnan'),'descend');
y_left=mean(a.C_odor1FirstLeft,3,'omitnan');
y_left=y_left-mean(y_left(:,30:40),2);
y_right=mean(a.C_odor1FirstRight,3,'omitnan');
y_right=y_right-mean(y_right(:,30:40),2);
[~,LRdiffSort] = sort(mean(y_right(:,40:60),2)-mean(y_left(:,40:60),2),'descend');
% cell_sort_ids=flipud(isASortLR);
% cell_sort_ids=rightIdx;
cell_sort_ids=LRdiffSort;

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 8];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

clabels = a.decodeLabels{2};

% RIGHT
ax = nsubplot(1,3,1,1); 
y_right=mean(a.C_odor1FirstRight,3,'omitnan');
% y_right=y_right-y_right(:,36);
y_right=y_right-mean(y_right(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_right,1),y_right(cell_sort_ids,:),color_limits);
% colorcet('D1');
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
title(clabels(2));
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')

% LEFT
ax = nsubplot(1,3,1,2);
y_left=mean(a.C_odor1FirstLeft,3,'omitnan');
% y_left=y_left-y_left(:,36);
y_left=y_left-mean(y_left(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_left,1),y_left(cell_sort_ids,:),color_limits);
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
title(clabels(1));
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')


ax = nsubplot(1,3,1,3);
y_left=mean(a.C_odor1FirstLeft,3,'omitnan');
y_right=mean(a.C_odor1FirstRight,3,'omitnan');
y=y_right-y_left;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
% colorcet('D1');
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
title('Difference');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')
hold off;   
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.98,[strjoin(mice,' _ '),' Conditional Activity Center Odor, sort by left-right'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

if RA==1
colormap(a.ckr);
else
colorcet('D1')
end

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ConditionalActivity_CenterOdorbySide_byLeft-Right_meansub']),'pdf');

%% CENTER ODOR INFO/NO INFO BY DIFF

color_limits = [-1.2 1.2];
% diff_limits = [-0.6 0.6];

% a.test= make_colormap(a.darkcyan,'k',[0.85 0 0]);

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


figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 8];
    set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

clabels = a.decodeLabels{1};

% INFO
ax = nsubplot(1,3,1,1);
% y_info=mean(a.C_odor1FirstInfoForced,3,'omitnan');
% y_left=y_left-y_left(:,36);
% y_info=y_info-mean(y_info(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_info,1),y_info(cell_sort_ids,:),color_limits);
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
xlabel('Seconds');
title(clabels(1));
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse');

% NO INFO
ax = nsubplot(1,3,1,2); 
% y_rand=mean(a.C_odor1FirstRandForced,3,'omitnan');
% y_right=y_right-y_right(:,36);
% y_rand=y_rand-mean(y_rand(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_rand,1),y_rand(cell_sort_ids,:),color_limits);
% colorcet('D1');
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
xlabel('Seconds');
title(clabels(2));
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')

ax = nsubplot(1,3,1,3);
y_info=mean(a.C_odor1FirstInfoForced,3,'omitnan');
y_rand=mean(a.C_odor1FirstRandForced,3,'omitnan');
y=y_info-y_rand;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
% colorcet('D1');
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
xlabel('Seconds');
title('Difference');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')
hold off;   
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.98,[strjoin(mice,' _ '),' Conditional Activity Center Odor, sort by info-noinfo'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

if RA==1
colormap(a.ckr);
else
colorcet('D1')
end

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ConditionalActivity_CenterOdorbyInfo_byInfoDiff_meansub']),'pdf');

%% CENTER ODOR INFO FORCED/CHOICE

% color_limits = [-1.1 1.1];
% diff_limits = [-1.1 1.1];

% a.test= make_colormap(a.darkcyan,'k',[0.85 0 0]);

e=3;

[infoSort,infoIdx] = sort(mean(squeeze(mean(a.C_odor1FirstInfoForced(:,40:56,:),2,'omitnan')),2,'omitnan'),'descend');
[choiceSort,choiceIdx] = sort(mean(squeeze(mean(a.C_odor1FirstInfoChoice(:,40:56,:),2,'omitnan')),2,'omitnan'),'descend');
y_choice=mean(a.C_odor1FirstInfoChoice,3,'omitnan');
y_choice=y_choice-mean(y_choice(:,30:40),2);
[~,choiceIdx] = sort(mean(y_choice(:,40:60),2),'descend');
% cell_sort_ids=isASort;
% cell_sort_ids=choiceIdx;
cell_sort_ids = choiceIdx;

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 8];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

clabels = a.decodeLabels{1};

% INFO
ax = nsubplot(1,3,1,1);
y_info=mean(a.C_odor1FirstInfoForced,3,'omitnan');
% y_left=y_left-y_left(:,36);
y_info=y_info-mean(y_info(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_info,1),y_info(cell_sort_ids,:),color_limits);
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
xlabel('Seconds');
title('Info Forced');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')

% CHOICE
ax = nsubplot(1,3,1,2); 
y_choice=mean(a.C_odor1FirstInfoChoice,3,'omitnan');
% y_right=y_right-y_right(:,36);
y_choice=y_choice-mean(y_choice(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_choice,1),y_choice(cell_sort_ids,:),color_limits);
% colorcet('D1');
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
xlabel('Seconds');
title('Info Choice');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')

ax = nsubplot(1,3,1,3);
y_info=mean(a.C_odor1FirstInfoForced,3,'omitnan');
y_choice=mean(a.C_odor1FirstInfoChoice,3,'omitnan');
y=y_info-y_choice;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
% colorcet('D1');
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
xlabel('Seconds');
title('Difference');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')
hold off;   
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.98,[strjoin(mice,' _ '),' Conditional Activity Center Odor, sort by choice activity'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

if RA==1
colormap(a.ckr);
else
colorcet('D1')
end

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ConditionalActivity_CenterOdorbyChoiceForced_meansub_sortchoice']),'pdf');


%% SIDE ODOR A/B BY B

e=6;

y_A=mean(a.C_odor2A,3,'omitnan');
y_A=y_A-mean(y_A(:,30:40),2);
y_B=mean(a.C_odor2B,3,'omitnan');
y_B=y_B-mean(y_B(:,30:40),2);
[~,ABdiffSort] = sort(mean(y_A(:,40:60),2)-mean(y_B(:,40:60),2),'descend');
[~,Bsort] = sort(mean(y_B(:,40:60),2),'descend');
% cell_sort_ids=isASort;
% cell_sort_ids=infoIdx;
cell_sort_ids = Bsort;
% [~,cell_sort_ids] = sort(y_info,'descend');


figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 8];
    set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

clabels = a.decodeLabels{1};

ax = nsubplot(1,3,1,1);
% y_info=mean(a.C_odor1FirstInfoForced,3,'omitnan');
% y_left=y_left-y_left(:,36);
% y_info=y_info-mean(y_info(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_A,1),y_A(cell_sort_ids,:),side_limits);
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% plot([0 0],[-1 +1].*10^10,'w','ylimincl
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
xlabel('Seconds');
title('A');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')

ax = nsubplot(1,3,1,2); 
% y_rand=mean(a.C_odor1FirstRandForced,3,'omitnan');
% y_right=y_right-y_right(:,36);
% y_rand=y_rand-mean(y_rand(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_B,1),y_B(cell_sort_ids,:),side_limits);
% colorcet('D1');
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% plot([0 0],[-1 +1].*10^10,'w','ylimincl
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
xlabel('Seconds');
title('B');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')

ax = nsubplot(1,3,1,3);
y_A=mean(a.C_odor2A,3,'omitnan');
y_B=mean(a.C_odor2B,3,'omitnan');
y=y_A-y_B;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
% colorcet('D1');
colorbar()
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% plot([0 0],[-1 +1].*10^10,'w','ylimincl
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2+PID 1+PID]);
xlabel('Seconds');
title('Difference');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')
hold off;   
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.98,[strjoin(mice,' _ '),' Conditional Activity Side Odor, sort by B'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

if RA==1
colormap(a.ckr);
else
colorcet('D1')
end

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ConditionalActivity_SideOdorAB_byB_meansub']),'pdf');

%% AB CD HEATMAPS

e=6;
cd = 1;
% color_limits = [-1.4 1.4];
% diff_limits = [-0.6 0.6];

% [ASort,AIdx] = sort(mean(squeeze(mean(a.C_odor2A(:,40:80,:),2,'omitnan')-mean(a.C_odor2A(:,30:40,:),2,'omitnan')),2,'omitnan'),'descend');
% [CSort,CIdx] = sort(mean(squeeze(mean(a.C_odor2C(:,40:80,:),3,'omitnan')),2,'omitnan'),'descend');
% [DSort,DIdx] = sort(mean(squeeze(mean(a.C_odor2D(:,40:80,:),3,'omitnan')),2,'omitnan'),'descend');
y_A=mean(a.C_odor2A,3,'omitnan');
y_A=y_A-mean(y_A(:,30:40),2);
y_B=mean(a.C_odor2B,3,'omitnan');
y_B=y_B-mean(y_B(:,30:40),2);
[~,ABdiffSort] = sort(mean(y_A(:,40:60),2)-mean(y_B(:,40:60),2),'descend');
[~,Asort] = sort(mean(y_A(:,40:60),2),'descend');
[~,Bsort] = sort(mean(y_B(:,40:60),2),'descend');
% cell_sort_ids=DIdx;
cell_sort_ids = Asort;
% isASortAB

ctitle = a.titles{2};
clabels = {'A','B','C','D'};
cnames = {'C_odor2A','C_odor2B','C_odor2C','C_odor2D'};
figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

for cd=1:2
    ax = nsubplot(1,9,1,cd);
    cname=cnames{cd};
    y=mean(a.(cname),3,'omitnan');
    y=y-mean(y(:,30:40),2);
    t=a.t{e};
    imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),side_limits);
%     colorcet('D1');
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
    axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
        ax.YAxis.Visible = 'off';
%         end
    xlim(heatLim+PID);
    xlabel('Seconds');
    title(clabels(cd));
%     xticks([-2:0.2:1.45]); 
    ax.FontSize = 8; 
end

ax = nsubplot(1,9,1,3);
y1=mean(a.C_odor2B,3,'omitnan');
y2=mean(a.C_odor2A,3,'omitnan');
y=y2-y1;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
% colorcet('D1');
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
    ax.YAxis.Visible = 'off';
%         end
xlim(heatLim+PID);
xlabel('Seconds');
title('A-B');
% xticks([-2:0.2:1.45]); 
ax.FontSize = 8;         

for cd=3:4
    ax = nsubplot(1,9,1,cd+1);
    cname=cnames{cd};
    y=mean(a.(cname),3,'omitnan');
    y=y-mean(y(:,30:40),2);
    t=a.t{e};
    imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),side_limits);
%     colorcet('D1');
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);    
    axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
        ax.YAxis.Visible = 'off';
%         end
   xlim(heatLim+PID);
    xlabel('Seconds');
    title(clabels(cd));
%     xticks([-2:0.2:1.45]); 
    ax.FontSize = 8; 
end

ax = nsubplot(1,9,1,6);
y1=mean(a.C_odor2C,3,'omitnan');
y2=mean(a.C_odor2D,3,'omitnan');
y=y2-y1;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
% colorcet('D1');
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
    ax.YAxis.Visible = 'off';
%         end
xlim(heatLim+PID);
xlabel('Seconds');
title('D-C');
% xticks([-2:0.2:1.45]); 
ax.FontSize = 8;

ax = nsubplot(1,9,1,7);
y1=mean(a.C_odor2rand,3,'omitnan');
y2=mean(a.C_odor2info,3,'omitnan');
y=y2-y1;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
% colorcet('D1');
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
    ax.YAxis.Visible = 'off';
%         end
xlim(heatLim+PID);
xlabel('Seconds');
title('AB-CD');
% xticks([-2:0.2:1.45]); 
ax.FontSize = 8;

ax = nsubplot(1,9,1,8);
y1=mean(a.C_odor2D,3,'omitnan');
y2=mean(a.C_odor2A,3,'omitnan');
y=y2-y1;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
% colorcet('D1');
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
    ax.YAxis.Visible = 'off';
%         end
xlim(heatLim+PID);
xlabel('Seconds');
title('A-D');
% xticks([-2:0.2:1.45]); 
ax.FontSize = 8;

ax = nsubplot(1,9,1,9);
y1=mean(a.C_odor2C,3,'omitnan');
y2=mean(a.C_odor2B,3,'omitnan');
y=y2-y1;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
% colorcet('D1');
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
    ax.YAxis.Visible = 'off';
%         end
xlim(heatLim+PID);
xlabel('Seconds');
title('B-C');
% xticks([-2:0.2:1.45]); 
ax.FontSize = 8;

if RA==1
colormap(a.ckr);
else
colorcet('D1')
end

hold off;   
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.98,[strjoin(mice,' _ '),' Conditional Activity, sort by A'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ConditionalActivity_SideOdorABCD_byA']),'pdf');

%% OUTCOME HEATMAPS

e=7;
cd = 1;

[NBigSort,NBigIdx] = sort(mean(squeeze(mean(a.C_outcomeRandBig(:,40:80,:),3,'omitnan')),2,'omitnan'),'descend');
[NSmallSort,NsmallIdx] = sort(mean(squeeze(mean(a.C_outcomeRandSmall(:,40:80,:),3,'omitnan')),2,'omitnan'),'descend');
y_water=mean(a.C_outcomeRandBig,3,'omitnan');
y_nowater=mean(a.C_outcomeRandSmall,3,'omitnan');
[~,WNdiffSort] = sort(mean(y_water(:,40:60),2)-mean(y_nowater(:,40:60),2),'descend');
cell_sort_ids=WNdiffSort;

ctitle = a.titles{4};
clabels = a.conditionLabels{4};
cnames = {'C_outcomeInfoBig','C_outcomeInfoSmall','C_outcomeRandBig','C_outcomeRandSmall'};
figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

for cd=1:2
    ax = nsubplot(1,6,1,cd);
    cname=cnames{cd};
    y=mean(a.(cname),3,'omitnan');
    y=y-mean(y(:,30:40),2);
    t=a.t{e};
    imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
%     colorcet('D1');
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
    axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
        ax.YAxis.Visible = 'off';
%         end
    xlim([heatLim+PID]);
    xlabel('Seconds');
    title(clabels(cd));
%     xticks([-2:0.2:2]); 
    ax.FontSize = 8;
end

ax = nsubplot(1,6,1,3);
y1=mean(a.C_outcomeInfoBig,3,'omitnan');
y2=mean(a.C_outcomeInfoSmall,3,'omitnan');
y=y1-y2;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),diff_limits);
% colorcet('D1');
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
axis tight;
set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
    ax.YAxis.Visible = 'off';
%         end
xlim([heatLim+PID]);
xlabel('Seconds');
title('Info, Water - No Water');
% xticks([-2:0.2:2]); 
ax.FontSize = 8;         

for cd=3:4
    ax = nsubplot(1,6,1,cd+1);
    cname=cnames{cd};
    y=mean(a.(cname),3,'omitnan');
    y=y-mean(y(:,30:40),2);
    t=a.t{e};
    imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
%     colorcet('D1');
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
    axis tight;
    set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
        ax.YAxis.Visible = 'off';
%         end
    xlim([heatLim+PID]);
    xlabel('Seconds');
    title(clabels(cd));
%     xticks([-2:0.2:2]); 
    ax.FontSize = 8; 
end

ax = nsubplot(1,6,1,6);
y1=mean(a.C_outcomeRandBig,3,'omitnan');
y2=mean(a.C_outcomeRandSmall,3,'omitnan');
y=y1-y2;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),diff_limits);
% colorcet('D1');
plot([0+PID 0+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor On
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'w','linewidth',2,'yliminclude','off') % Center Odor Off
xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
axis tight;
set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
    ax.YAxis.Visible = 'off';
%         end
xlim([heatLim+PID]);
xlabel('Seconds');
title('No Info, Water - No Water');
% xticks([-2:0.2:2]); 
ax.FontSize = 8;         

if RA==1
colormap(a.ckr);
else
colorcet('D1')
end

hold off;   
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.98,[strjoin(mice,' _ '),' Conditional Activity, sort by Info-No Info Abs Val'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ConditionalActivity_Outcome_byNoInfoDiff']),'pdf');


%% PERCENT CELL BARS AND VENN DIAGRAMS


differentCellsEBM=[a.actDiffIdxEBMSig{:}]<0.05;
a.differentCellsEBM=differentCellsEBM;

% matrix whether cell is "active" for each condition namesFirst
activeCells=[];
activeCellsRS=[];
for cd = 1:numel(a.namesFirst)
    activeCells = [activeCells cell2mat(a.C_condBasePostRSActiveExpPos{cd})];
    activeCellsRS = [activeCellsRS cell2mat(a.C_condBasePostRSActiveExpPos{cd})];
end

activeCellsRS=activeCellsRS<0.05;

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 8];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');
nsubplot(1,1,1,1);bar(sum(activeCells)/a.neuronCt);
xticks([1:size(activeCells,2)]);
xticklabels([a.labels{:}]);
saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_activeCells']),'pdf');

fig=figure();
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 8];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');
nsubplot(1,1,1,1);bar(sum(differentCellsEBM)/a.neuronCt);
xticks([1:size(differentCellsEBM,2)]);
xticklabels(a.compLabels);
saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_differentCellsEBM']),'pdf');

%% ABSOLUTE DIFFERENCE IN ACTIVTY (POWER) for sig diff cells

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 8];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');


for cd = 1:numel(a.compOrder)
    corder = a.compOrder{cd};
    ax4 = nsubplot(1,numel(a.compOrder),1,cd);
    hold on; 
    h_for_legend = [];
    clabel = [];
    for cm = 1:numel(corder)
        ci = corder{cm};
        e = a.compEventsFirst(ci);
        sigCells=differentCellsEBM(:,ci);
        if ~isnan(a.absActivityTimeDiff{ci})
            y = a.absActivityTimeDiff{ci}(sigCells,:);
            ymean = nanmean(y,1);
            ysem = nanstd(y,[],1) ./ sqrt(size(y,1));
            t=a.t{e};
            if cm == 1
                h_for_legend(end+1)=plot(ax4,t,ymean,'color','k','linewidth',width); % only this plot is used for legend!!
            elseif cm == 2
                h_for_legend(end+1)=plot(ax4,t,ymean,'color','k','linewidth',width,'linestyle',':'); % only this plot is used for legend!!
            else
                h_for_legend(end+1)=plot(ax4,t,ymean,'color','k','linewidth',width,'linestyle','--'); % only this plot is used for legend!!
            end
            clabel{end+1} = a.compLabels{ci};            
        end
        if cm == numel(corder)
%             xlim(t([1 end])); 
                ylim([0 1]);
%             setlim(ax4,'ylim','tight',[0 0.7]);
%             xticks([-2:0.2:2]);
%             yticks([0 0.25 0.5]);
            set(gca,'fontsize',6); 
            xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
            xticks2 = xticks2 + PID;
            xticks(xticks2);
            xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
            set(gca, 'XTickLabel', xticklabels2);
            plot([0+PID 0+PID],[-1 +1].*10^10,'color','k','yliminclude','off');
%             plot([-1 +1].*10^10,[0 0],'color',a.grey,'yliminclude','off');
            plot([a.resp_win(1) a.resp_win(1)],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
            plot([a.resp_win(2) a.resp_win(2)],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
            if ~isempty(h_for_legend)
            leg = legend(h_for_legend,clabel{:},'Location','northwest','Orientation','vertical');
            legend('boxoff')
            leg.FontSize = 6;
            end
    %             xlabel('Seconds relative to event start');
            if cd==1
                ylabel({'Mean ABSOLUTE'; 'difference in activity, sig cells'},'FontWeight','bold');
            end
            hold off
            axis square;
        end 
    end
end

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AbsDiffSigCells']),'pdf');


%% INFO VALUE CS vs WATER CS VENN EBM

infoCells = differentCellsEBM(:,2);
waterCells = differentCellsEBM(:,3);
overlapCells = infoCells&waterCells;
infoValCells = infoCells&~waterCells;
waterValCells = waterCells&~infoCells;
% cellCount=size(differentCells,1);

% setLabels = {"Info"; "Water";};
% cells=sum([infoValCells waterValCells])/a.neuronCt;

vennPlot{1}=find(infoCells);
vennPlot{2}=find(waterCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(infoCells) sum(waterCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % axis square;

[tbl,chi2,p] = crosstab(infoCells,waterCells);

% pause(10);
h=vennEulerDiagram(vennPlot, {'InfoDiffCS','WaterDiffCS'}, 'drawProportional', true,'showintersectioncounts',true);
title(['EBM CS diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoValueEBMVenn']),'pdf');

infoCells = differentCells(:,2);
waterCells = differentCells(:,3);
vennPlot{1}=find(infoCells);
vennPlot{2}=find(waterCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];

[tbl,chi2,p] = crosstab(infoCells,waterCells);

% pause(10);
h=vennEulerDiagram(vennPlot, {'InfoDiffCS','WaterDiffCS'}, 'drawProportional', true,'showintersectioncounts',true);
title(['CS diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoValueVenn']),'pdf');



% % Example data
% neitherCells=a.neuronCt-sum(sum([infoValCells waterValCells overlapCells]));
% responds_A_B = sum(overlapCells); % Neurons responding to both A and B
% responds_A_notB = sum(infoValCells); % Neurons responding to A but not B
% notA_responds_B = sum(waterValCells); % Neurons not responding to A but responding to B
% notA_notB = neitherCells; % Neurons not responding to either A or B
% 
% % Create the contingency table
% observed = [responds_A_B, responds_A_notB;
%             notA_responds_B, notA_notB];
% 
% % Perform chi-squared test of independence
% [h, p, stats] = chi2gof(observed(:));

%% SIGNIFICANT OVERLAP

infoCells = differentCellsEBM(:,2);
waterCells = differentCellsEBM(:,3);
overlapCells = infoCells&waterCells;
totalCells = infoCells|waterCells;

infoOfCells=infoCells(totalCells);
waterOfCells=waterCells(totalCells);

trueOverlap=sum(overlapCells)/sum(totalCells);

% for j=1:10000
%    shuffle=randperm(size(totalCells,1));
%    shuffleInfo=infoCells(shuffle);
%    shuffleOverlapCells=shuffleInfo&waterCells;
%    shuffleOverlap(j)=sum(shuffleOverlapCells);
% end
% 
% percentOverlap=100*sum((shuffleOverlap(:)>trueOverlap)) ...
%                     /length(shuffleOverlap(:));
%                 
% sum(shuffleOverlap/sum(overlapCells))/10000

%                 
%                 %%
% for j=1:1000
%    shuffle=randperm(1000);
%    shuffleInfo=test1(shuffle);
%    shuffleOverlapCells=shuffleInfo&test2;
%    shuffleOverlap(j)=sum(shuffleOverlapCells)/1000;
% end
% 
% for j=1:10000
%    shuffle=randperm(sum(totalCells,1));
%    shuffleInfo=infoOfCells(shuffle);
%    shuffleWater=waterOfCells(shuffle);
%    shuffleOverlapCells=shuffleInfo&waterOfCells;
%    shuffleOverlap(j)=sum(shuffleOverlapCells);
% end

inA=infoOfCells;
inB=waterOfCells;

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

fprintf('Observed overlap within labeled cells %d, two-tailed p = %.4f\n high p = %.4f low p = %.4f\n', overlapObs, pTwo, pHigh, pLow);

inA=infoCells;
inB=waterCells;

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

fprintf('Observed overlap across all cells %d, two-tailed p = %.4f\n high p = %.4f low p = %.4f\n', overlapObs, pTwo, pHigh, pLow);


chanceOverlap=(sum(inA)/a.neuronCt)*(sum(inB)/a.neuronCt);
vsChance=((overlapObs/a.neuronCt)-chanceOverlap)/chanceOverlap;

%% INFO WATER CS BY ACTIVE
infoCells = activeCells(:,5);
waterCells = activeCells(:,9);


% setLabels = {"Info"; "Water";};
% cells=sum([infoValCells waterValCells])/a.neuronCt;

vennPlot{1}=find(infoCells);
vennPlot{2}=find(waterCells);

[tbl,chi2,p] = crosstab(infoCells,waterCells)

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(infoCells) sum(waterCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % axis square;

% pause(10);
h=vennEulerDiagram(vennPlot, {'InfoActCS','WaterActCS'}, 'drawProportional', true,'showintersectioncounts',true);
title(['active cells, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoValue2Venn']),'pdf');



%% INFO CS US VENN BY ACTIVE

ACells = activeCells(:,9);
BCells = activeCells(:,10);
USCells = ACells&BCells;

infoCells = differentCells(:,2);

vennPlot{1}=find(infoCells);
vennPlot{2}=find(USCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(infoValCells) sum(USCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
h=vennEulerDiagram(vennPlot, {'InfoCSDiff','InfoUS'}, 'drawProportional', true,'showintersectioncounts',true);

title('Info CS US cells by infovnoinfo and active for A&B')
% axis square;
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoUSVennbyDiff']),'pdf');

%% INFO CS US VENN 2

ACells = activeCells(:,9);
BCells = activeCells(:,10);
USCells = ACells&BCells;
% USCells = BCells;

infoCells = activeCells(:,5);

vennPlot{1}=find(infoCells);
vennPlot{2}=find(USCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(infoValCells) sum(USCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% axis square;
h=vennEulerDiagram(vennPlot, {'InfoCSActive','InfoUS'}, 'drawProportional', true,'showintersectioncounts',true);
title('Info CS US cells by info active and active for A&B')

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoUSVennbyActive']),'pdf');

%% INFO CS CD US VENN 2

CCells = activeCells(:,11);
DCells = activeCells(:,12);
USCells = CCells&DCells;

infoCells = activeCells(:,5);

vennPlot{1}=find(infoCells);
vennPlot{2}=find(USCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(infoValCells) sum(USCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% axis square;
h=vennEulerDiagram(vennPlot, {'InfoCSActive','CD'}, 'drawProportional', true,'showintersectioncounts',true);
title('Info CS US cells by info active and active for C&D')

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoCDUSVennbyActive']),'pdf');

%% INFO CS US VENN 3 BY DIFFERENCE

USCells = differentCells(:,5);
infoCells = differentCells(:,2);

vennPlot{1}=find(infoCells);
vennPlot{2}=find(USCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
[tbl,chi2,p] = crosstab(infoCells,USCells);
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(infoValCells) sum(USCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% axis square;
h=vennEulerDiagram(vennPlot, {'InfoCSDiff','InfoUSDiff'}, 'drawProportional', true,'showintersectioncounts',true);
title(['Info CS US cells by info diff and diff AB vs CD, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoUSVennbyBothDiff']),'pdf');

%% INFO CS US VENN 3 BY DIFFERENCE EBM

USCells = differentCellsEBM(:,5);
infoCells = differentCellsEBM(:,2);

vennPlot{1}=find(infoCells);
vennPlot{2}=find(USCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
[tbl,chi2,p] = crosstab(infoCells,USCells);
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(infoValCells) sum(USCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% axis square;
h=vennEulerDiagram(vennPlot, {'InfoCSDiff','InfoUSDiff'}, 'drawProportional', true,'showintersectioncounts',true);
title(['Info CS US cells by info diff and diff AB vs CD, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoUSVennbyBothDiffEBM']),'pdf');

%% INFO US WATER US VENN BY DIFFERENCE EBM

infoUSCells = differentCellsEBM(:,5);
waterUSCells = differentCellsEBM(:,7); % rand water US

vennPlot{1}=find(infoUSCells);
vennPlot{2}=find(waterUSCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
[tbl,chi2,p] = crosstab(infoUSCells,waterUSCells);
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(infoValCells) sum(USCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% axis square;
h=vennEulerDiagram(vennPlot, {'InfoUSDiff','RandWaterUSDiff'}, 'drawProportional', true,'showintersectioncounts',true);
title(['Info US cells vs Rand water US cells, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoUSRandWaterUSVennbyBothDiffEBM']),'pdf');

infoUSCells = differentCellsEBM(:,5);
waterUSCells = differentCellsEBM(:,6); % info water US

vennPlot{1}=find(infoUSCells);
vennPlot{2}=find(waterUSCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
[tbl,chi2,p] = crosstab(infoUSCells,waterUSCells);
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(infoValCells) sum(USCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% axis square;
h=vennEulerDiagram(vennPlot, {'InfoUSDiff','InfoWaterUSDiff'}, 'drawProportional', true,'showintersectioncounts',true);
title(['Info US cells vs info water US cells, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoUSInfoWaterUSVennbyBothDiffEBM']),'pdf');


totalCells = infoUSCells|waterUSCells;

inA=infoUSCells(totalCells);
inB=waterUSCells(totalCells);

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

inA=infoUSCells;
inB=waterUSCells;

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

%% INFO US Pos Neg Venn

% USPosCells=differentCells(:,5)&a.activityPostDiff{5}>0;
% USNegCells=differentCells(:,5)&a.activityPostDiff{5}<0;
% 
% vennPlot{1}=find(USPosCells);
% vennPlot{2}=find(USPosCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % nsubplot(1,1,1,1);
% % [H,S]=venn([sum(infoValCells) sum(USCells)],sum(overlapCells));
% %   for i = 1:2
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
% %   end
% % text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % axis square;
% h=vennEulerDiagram(vennPlot, {'InfoUSPos','InfoUSNeg'}, 'drawProportional', true,'showintersectioncounts',true);
% title('Info US cells by info vs no info greater')
% 
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoUSVennbyPosNeg']),'pdf');

%% INFO AND SIDE VENN

infoCells = differentCellsEBM(:,2);
sideCells = differentCellsEBM(:,1);
infoOnlyCells = infoCells&~sideCells;
sideOnlyCells = sideCells&~infoCells;
overlapCells = infoCells&sideCells;

setLabels = {"Info"; "Side";};
cells=sum([infoOnlyCells sideOnlyCells])/a.neuronCt;

vennPlot{1}=find(infoCells);
vennPlot{2}=find(sideCells);

[tbl,chi2,p] = crosstab(infoCells,sideCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(infoCells) sum(sideCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% axis square;
h=vennEulerDiagram(vennPlot, {'Info','Side'}, 'drawProportional', true,'showintersectioncounts',true);
title(['Info Side diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoSideVennEBM']),'pdf');


totalCells = infoCells|sideCells;

infoOfCells=infoCells(totalCells);
sideOfCells=sideCells(totalCells);
inA=infoOfCells;
inB=sideOfCells;

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

inA=infoCells;
inB=sideCells;

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

%% INFO LEFT RIGHT VENN

infoLeftCells = activeCells(:,1);
infoRightCells = activeCells(:,2);
% infoOnlyCells = infoCells&~sideCells;
% sideOnlyCells = sideCells&~infoCells;
% overlapCells = infoCells&sideCells;
% 
% setLabels = {"Info"; "Side";};
% cells=sum([infoOnlyCells sideOnlyCells])/a.neuronCt;

vennPlot{1}=find(infoLeftCells);
vennPlot{2}=find(infoRightCells);

[tbl,chi2,p] = crosstab(infoLeftCells,infoRightCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(infoCells) sum(sideCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% axis square;
h=vennEulerDiagram(vennPlot, {'Info Left','Info Right'}, 'drawProportional', true,'showintersectioncounts',true);
title(['Info Side diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoLeftRightVenn']),'pdf');

fprintf('Info Left Cells %d\nInfo Right cells %d\nBoth %d\n',sum(infoLeftCells),sum(infoRightCells),sum(infoLeftCells&infoRightCells))

%% INFO A VENN

infoCells = activeCells(:,1);
ACells = activeCells(:,9);
% infoOnlyCells = infoCells&~sideCells;
% sideOnlyCells = sideCells&~infoCells;
% overlapCells = infoCells&sideCells;
% 
% setLabels = {"Info"; "Side";};
% cells=sum([infoOnlyCells sideOnlyCells])/a.neuronCt;

vennPlot{1}=find(infoCells);
vennPlot{2}=find(ACells);

[tbl,chi2,p] = crosstab(infoCells,ACells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(infoCells) sum(sideCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% axis square;
h=vennEulerDiagram(vennPlot, {'Info','A'}, 'drawProportional', true,'showintersectioncounts',true);
title(['Info Side diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoAVenn']),'pdf');

fprintf('Info Cells %d\nA cells %d\nBoth %d\n',sum(infoCells),sum(ACells),sum(infoCells&ACells))


%%
ACells = activeCells(:,9);
BCells = activeCells(:,10);
AonlyCells=ACells&~BCells;
BonlyCells=BCells&~ACells;
overlapCells = ACells&BCells;

setLabels = {"A:Water"; "B:No Water";};
cells=sum([AonlyCells BonlyCells])/a.neuronCt;

vennPlot{1}=find(ACells);
vennPlot{2}=find(BCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];

% nsubplot(1,1,1,1);
% [H,S]=venn([sum(ACells) sum(BCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % axis square;

h=vennEulerDiagram(fig,vennPlot, {'A','B'}, 'drawProportional', true,'showintersectioncounts',true);
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ABVenn']),'pdf');

totalCells = ACells|BCells;

inA=ACells(totalCells);
inB=BCells(totalCells);

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

inA=ACells;
inB=BCells;

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

%%

CCells = activeCells(:,11);
DCells = activeCells(:,12);
ConlyCells=CCells&~DCells;
DonlyCells=DCells&~CCells;
overlapCells = CCells&DCells;

setLabels = {"C:No Info"; "D:No Info";};
cells=sum([ConlyCells DonlyCells])/a.neuronCt;

vennPlot{1}=find(CCells);
vennPlot{2}=find(DCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(CCells) sum(DCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % axis square;

h=vennEulerDiagram(fig,vennPlot, {'C','D'}, 'drawProportional', true,'showintersectioncounts',true);
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_CDVenn']),'pdf');

%%

ACells = activeCells(:,9);
BCells = activeCells(:,10);
CCells = activeCells(:,11);
DCells = activeCells(:,12);
CDCells = CCells&DCells;
ABCells = ACells&BCells;

vennPlot{1}=find(ABCells);
vennPlot{2}=find(CDCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(CCells) sum(DCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % axis square;
title('Active A&B or active C&D');

h=vennEulerDiagram(fig,vennPlot, {'AB','CD'}, 'drawProportional', true,'showintersectioncounts',true);
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ABCDVenn']),'pdf');
%%

USPosCells=differentCells(:,5)&a.activityPostDiff{5}>0;
USNegCells=differentCells(:,5)&a.activityPostDiff{5}<0;

vennPlot{1}=find(ACells);
vennPlot{2}=find(BCells);
vennPlot{3}=find(CCells);
vennPlot{4}=find(DCells);
% vennPlot{5}=USPosCells;
% vennPlot{6} = USNegCells;

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(CCells) sum(DCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % axis square;

h=vennEulerDiagram(fig,vennPlot, {'A','B','C','D'}, 'drawProportional', true,'showintersectioncounts',true);
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ABCDVenn2']),'pdf');

%%

h=[];vennPlot=[];
USPosCells=differentCells(:,5)&a.activityPostDiff{5}>0;
USNegCells=differentCells(:,5)&a.activityPostDiff{5}<0;

vennPlot{1}=find(ACells);
vennPlot{2}=find(BCells);
% vennPlot{3}=find(CCells);
% vennPlot{4}=find(DCells);
vennPlot{3}=find(USPosCells);
% vennPlot{6} = USNegCells;

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(CCells) sum(DCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % axis square;

h=vennEulerDiagram(fig,vennPlot, {'A','B','ABUS'}, 'drawProportional', true,'showintersectioncounts',true);
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ABUSVenn']),'pdf');


%% BC and CD Venn

CCells = activeCells(:,11);
BCells = activeCells(:,10);
ConlyCells=CCells&~BCells;
BonlyCells=BCells&~CCells;
overlapCells = CCells&BCells;

setLabels = {"C:No Info"; "B:Info No Water";};
cells=sum([ConlyCells BonlyCells])/a.neuronCt;

vennPlot{1}=find(CCells);
vennPlot{2}=find(BCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(CCells) sum(DCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % axis square;

h=vennEulerDiagram(fig,vennPlot, {'C','B'}, 'drawProportional', true,'showintersectioncounts',true);
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_BCVenn']),'pdf');

ACells = activeCells(:,9);
DCells = activeCells(:,12);
AonlyCells=ACells&~DCells;
DonlyCells=DCells&~ACells;
overlapCells = ACells&DCells;

setLabels = {"A:Info Water"; "D:No Info";};
cells=sum([AonlyCells DonlyCells])/a.neuronCt;

vennPlot{1}=find(ACells);
vennPlot{2}=find(DCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(CCells) sum(DCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % axis square;

h=vennEulerDiagram(fig,vennPlot, {'A','D'}, 'drawProportional', true,'showintersectioncounts',true);
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ADVenn']),'pdf');

BDiffCells = differentCells(:,8);
ADiffCells = differentCells(:,9);

vennPlot{1}=find(BDiffCells);
vennPlot{2}=find(ADiffCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(CCells) sum(DCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % axis square;

h=vennEulerDiagram(fig,vennPlot, {'B-C','A-D'}, 'drawProportional', true,'showintersectioncounts',true);
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_SideOdorsVenn']),'pdf');

%% INFO WATER

bigCells = activeCells(:,13);
smallCells = activeCells(:,14);

setLabels = {"Water"; "No Water";};

vennPlot{1}=find(bigCells);
vennPlot{2}=find(smallCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];

h=vennEulerDiagram(fig,vennPlot, setLabels, 'drawProportional', true,'showintersectioncounts',true);
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoWaterVenn']),'pdf');

%% RAND WATER

bigCells = activeCells(:,15);
smallCells = activeCells(:,16);

setLabels = {"Water"; "No Water";};

vennPlot{1}=find(bigCells);
vennPlot{2}=find(smallCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];

h=vennEulerDiagram(fig,vennPlot, setLabels, 'drawProportional', true,'showintersectioncounts',true);
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_RandWaterVenn']),'pdf');

%% WATER DIFFERENCE

infowaterCells = differentCellsEBM(:,6);
randwaterCells = differentCellsEBM(:,7);

setLabels = {"Info Water"; "No Info Water";};

vennPlot{1}=find(infowaterCells);
vennPlot{2}=find(randwaterCells);

[tbl,chi2,p] = crosstab(infowaterCells,randwaterCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];

h=vennEulerDiagram(fig,vennPlot, setLabels, 'drawProportional', true,'showintersectioncounts',true);
title(['Water US coding, p= ' num2str(p)])
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_WaterVenn']),'pdf');

%% WATER CS US CELLS EBM

waterCSCells = differentCellsEBM(:,3);
randwaterCells = differentCellsEBM(:,7);

setLabels = {"A-B"; "No Info Water";};

vennPlot{1}=find(waterCSCells);
vennPlot{2}=find(randwaterCells);

[tbl,chi2,p] = crosstab(waterCSCells,randwaterCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];

h=vennEulerDiagram(fig,vennPlot, setLabels, 'drawProportional', true,'showintersectioncounts',true);
title(['Water CS US coding, p= ' num2str(p)])
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_WaterCSUSEBMVenn']),'pdf');

waterCSCells = differentCellsEBM(:,3);
infowaterCells = differentCellsEBM(:,6);

setLabels = {"A-B"; "Info Water-No water";};

vennPlot{1}=find(waterCSCells);
vennPlot{2}=find(infowaterCells);

[tbl,chi2,p] = crosstab(waterCSCells,infowaterCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];

h=vennEulerDiagram(fig,vennPlot, setLabels, 'drawProportional', true,'showintersectioncounts',true);
title(['Water CS US coding, p= ' num2str(p)])
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_WaterCSUSInfoEBMVenn']),'pdf');

%% WATER
infowaterCells = activeCells(:,13);
randwaterCells = activeCells(:,15);

setLabels = {"Info Water"; "No Info Water";};

vennPlot{1}=find(infowaterCells);
vennPlot{2}=find(randwaterCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];

h=vennEulerDiagram(fig,vennPlot, setLabels, 'drawProportional', true,'showintersectioncounts',true);
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_WaterVenn']),'pdf');

%% Info forced choice venn

forcedCells = activeCells(:,5);
choiceCells = activeCells(:,6);
forcedOnlyCells=forcedCells&~choiceCells;
choiceOnlyCells=choiceCells&~forcedCells;
overlapCells = forcedCells&choiceCells;

setLabels = {'Info Forced' 'Info Choice'};
cells=sum([forcedOnlyCells choiceOnlyCells])/a.neuronCt;

vennPlot{1}=find(forcedCells);
vennPlot{2}=find(choiceCells);

[tbl,chi2,p] = crosstab(forcedCells,choiceCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(forcedCells) sum(choiceCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% axis square;
h=vennEulerDiagram(vennPlot, {'InfoForced','InfoChoice'}, 'drawProportional', true,'showintersectioncounts',true);
title(['CS diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ForcedChoiceVenn']),'pdf');

totalCells = forcedCells|choiceCells;

forcedOfCells=forcedCells(totalCells);
choiceOfCells=choiceCells(totalCells);

inA=forcedOfCells;
inB=choiceOfCells;

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

inA=forcedCells;
inB=choiceCells;

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

%% INFO FORCED CHOICE PER SIDE

forcedLCells = activeCells(:,1);
choiceLCells = activeCells(:,17);

vennPlot{1}=find(forcedLCells);
vennPlot{2}=find(choiceLCells);

[tbl,chi2,p] = crosstab(forcedLCells,choiceLCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
h=vennEulerDiagram(vennPlot, {'Info Forced Left','Info Choice Left'}, 'drawProportional', true,'showintersectioncounts',true);
title(['Info Choice Left diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ForcedChoiceInfoLeftVenn']),'pdf');

forcedRCells = activeCells(:,2);
choiceRCells = activeCells(:,18);

vennPlot{1}=find(forcedRCells);
vennPlot{2}=find(choiceRCells);

[tbl,chi2,p] = crosstab(forcedRCells,choiceRCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
h=vennEulerDiagram(vennPlot, {'Info Forced Right','Info Choice Right'}, 'drawProportional', true,'showintersectioncounts',true);
title(['Info Choice Right diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ForcedChoiceInfoRightVenn']),'pdf');

%%
forcedILCells = activeCells(:,17);
forcedNLCells = activeCells(:,21);

vennPlot{1}=find(forcedILCells);
vennPlot{2}=find(forcedNLCells);

[tbl,chi2,p] = crosstab(forcedILCells,forcedNLCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
h=vennEulerDiagram(vennPlot, {'Info Forced Left','Rand Forced Left'}, 'drawProportional', true,'showintersectioncounts',true);
title(['Info Left Rand Left diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoRandLeftVenn']),'pdf');

%%
forcedILCells = activeCells(:,17);
forcedIRCells = activeCells(:,19);

vennPlot{1}=find(forcedILCells);
vennPlot{2}=find(forcedIRCells);

[tbl,chi2,p] = crosstab(forcedILCells,forcedIRCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
h=vennEulerDiagram(vennPlot, {'Info Forced Left','Info Forced Right'}, 'drawProportional', true,'showintersectioncounts',true);
title(['Info L-R diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoForcedLRVenn']),'pdf');

%%
forcedILCells = activeCells(:,17);
choiceIRCells = activeCells(:,21);

vennPlot{1}=find(forcedILCells);
vennPlot{2}=find(choiceIRCells);

[tbl,chi2,p] = crosstab(forcedILCells,choiceIRCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
h=vennEulerDiagram(vennPlot, {'Info Forced Left','Info Choice Right'}, 'drawProportional', true,'showintersectioncounts',true);
title(['Info Left Choice Right diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ForcedLChoiceRVenn']),'pdf');


%% Info choice v No Info Forced Venn

forcedCells = differentCellsEBM(:,2);
choiceCells = differentCellsEBM(:,11);
forcedOnlyCells=forcedCells&~choiceCells;
choiceOnlyCells=choiceCells&~forcedCells;
overlapCells = forcedCells&choiceCells;

setLabels = {'Info Forced' 'Info Choice'};
cells=sum([forcedOnlyCells choiceOnlyCells])/a.neuronCt;

vennPlot{1}=find(forcedCells);
vennPlot{2}=find(choiceCells);

[tbl,chi2,p] = crosstab(forcedCells,choiceCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(forcedCells) sum(choiceCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% axis square;
h=vennEulerDiagram(vennPlot, {'InfoForced','InfoChoice'}, 'drawProportional', true,'showintersectioncounts',true);
title(['CS diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ForcedChoiceNoInfoForcedDiffVenn']),'pdf');

%% Info choice v No Info Choice Venn

forcedCells = differentCellsEBM(:,2);
choiceCells = differentCellsEBM(:,12);
forcedOnlyCells=forcedCells&~choiceCells;
choiceOnlyCells=choiceCells&~forcedCells;
overlapCells = forcedCells&choiceCells;

setLabels = {'Info Forced' 'Info Choice'};
cells=sum([forcedOnlyCells choiceOnlyCells])/a.neuronCt;

vennPlot{1}=find(forcedCells);
vennPlot{2}=find(choiceCells);

[tbl,chi2,p] = crosstab(forcedCells,choiceCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(forcedCells) sum(choiceCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% axis square;
h=vennEulerDiagram(vennPlot, {'InfoForced','InfoChoice'}, 'drawProportional', true,'showintersectioncounts',true);
title(['CS diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ForcedChoiceDiffVenn']),'pdf');



%% info rand venn

infoCells = activeCells(:,5);
randCells = activeCells(:,7);
infoOnlyCells=infoCells&~randCells;
randOnlyCells=randCells&~infoCells;
overlapCells = infoCells&randCells;

setLabels = {"Info Forced"; "No Info Forced";};
% cells=sum([infoOnlyCells randOnlyCells])/a.neuronCt;
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(infoCells) sum(randCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % axis square;
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoNoInfoVenn']),'pdf');

% %%
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
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoNoInfoVenn']),'pdf');


totalCells = infoCells|randCells;

inA=infoCells(totalCells);
inB=randCells(totalCells);

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

inA=infoCells;
inB=randCells;

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

%%
infoLeftCells = activeCells(:,1);
infoRightCells = activeCells(:,2);
randLeftCells = activeCells(:,3);
randRightCells = activeCells(:,4);
ILonly=sum(infoLeftCells&~infoRightCells&~randLeftCells&~randRightCells)
IRonly=sum(~infoLeftCells&infoRightCells&~randLeftCells&~randRightCells)
NLonly=sum(~infoLeftCells&~infoRightCells&randLeftCells&~randRightCells)
NRonly=sum(~infoLeftCells&~infoRightCells&~randLeftCells&randRightCells)

% %%
figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% ax=nsubplot(1,1,1,1); hold off;

vennPlot{1}=find(infoLeftCells);
vennPlot{2}=find(infoRightCells);
vennPlot{3}=find(randLeftCells);
vennPlot{4}=find(randRightCells);

h=vennEulerDiagram(fig,vennPlot, {'InfoL','InfoR','NoInfoL','NoInfoR'}, 'drawProportional', true,'showintersectioncounts',true);
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoNoInfobySideVenn']),'pdf');

totalCells = infoLeftCells|infoRightCells;

inA=infoLeftCells(totalCells);
inB=infoRightCells(totalCells);

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

inA=infoLeftCells;
inB=infoRightCells;

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

%%

shuffleCells= [a.C_condShuffleDifferent{:}];
shuffleCells=shuffleCells(:,2);
RSCells= [a.C_condRSdifferent{:}];
RSCells=RSCells(:,2);

RSOnly=RSCells&~shuffleCells;
shuffleOnly=shuffleCells&~RSCells;
overlapCells = shuffleCells&RSCells;

setLabels = {"RS"; "Shuffle";};
cells=sum([RSOnly shuffleOnly]);

vennPlot{1}=find(RSCells);
vennPlot{2}=find(shuffleCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% nsubplot(1,1,1,1);
% [H,S]=venn([sum(RSCells) sum(shuffleCells)],sum(overlapCells));
%   for i = 1:2
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
%   end
% text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells))])

h=vennEulerDiagram(fig,vennPlot, {'RS','Shuffle'}, 'drawProportional', true,'showintersectioncounts',true);

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_DiffInfoVenn']),'pdf');


%%

diffCells = shuffleCells;
infoCells = activeCells(:,5);
randCells = activeCells(:,7);
infoOnly=infoCells&~randCells&~diffCells;
randOnly=randCells&~infoCells&~diffCells;
diffOnly=diffCells&~infoCells&~randCells;
overlap3Cells = diffCells&infoCells&randCells;
overlap12Cells = diffCells&infoCells&~randCells;
overlap13Cells = diffCells&randCells&~infoCells;
overlap23Cells = infoCells&randCells&~diffCells;

setLabels = {"Difference"; "Info"; "No Info"};
cells=sum([diffOnly infoOnly randOnly]);

vennPlot{1}=find(infoCells);
vennPlot{2}=find(randCells);
vennPlot{3}=find(diffCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];

% [H,S]=venn([sum(diffCells) sum(infoCells) sum(randCells)],[sum(overlap12Cells),sum(overlap13Cells),sum(overlap23Cells),sum(overlap3Cells)]);
%   for i = 1:3
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))]);
%   end
% text(S.ZoneCentroid(4,1), S.ZoneCentroid(4,2), num2str(sum(overlap12Cells)));
% text(S.ZoneCentroid(5,1), S.ZoneCentroid(5,2), num2str(sum(overlap13Cells)));
% text(S.ZoneCentroid(6,1), S.ZoneCentroid(6,2), num2str(sum(overlap23Cells)));
% text(S.ZoneCentroid(7,1), S.ZoneCentroid(7,2), num2str(sum(overlap3Cells)));

h=vennEulerDiagram(fig,vennPlot, {'Info','No Info','Different'}, 'drawProportional', true,'showintersectioncounts',true);

% axis square;
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AllInfoVenn']),'pdf');

vennPlot=[];

%%
infoCSCells = differentCells(:,2);
waterCSCells = differentCells(:,3);
waterUSCells = differentCells(:,7);

vennPlot{1}=find(infoCSCells);
vennPlot{2}=find(waterCSCells);
vennPlot{3}=find(waterUSCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% 
% [H,S]=venn([sum(infoCells) sum(waterCSCells) sum(waterCells)],[sum(overlap12Cells),sum(overlap13Cells),sum(overlap23Cells),sum(overlap3Cells)]);
%   for i = 1:3
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))]);
%   end
% text(S.ZoneCentroid(4,1), S.ZoneCentroid(4,2), num2str(sum(overlap12Cells)/a.neuronCt));
% text(S.ZoneCentroid(5,1), S.ZoneCentroid(5,2), num2str(sum(overlap13Cells)/a.neuronCt));
% text(S.ZoneCentroid(6,1), S.ZoneCentroid(6,2), num2str(sum(overlap23Cells)/a.neuronCt));
% text(S.ZoneCentroid(7,1), S.ZoneCentroid(7,2), num2str(sum(overlap3Cells)/a.neuronCt));
% % axis square;
h=vennEulerDiagram(fig,vennPlot, {'InfoCS','WaterCS','WaterUS'}, 'drawProportional', true,'showintersectioncounts',true);
vennPlot=[];
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AllValuesVenn']),'pdf');


ACells = activeCells(:,9);
BCells = activeCells(:,10);
infoCSCells = differentCells(:,2);
% infoCSCells = activeCellsRS(:,5);
waterCSCells = differentCells(:,3);
waterUSCells = differentCells(:,7);
infoUSCells = ACells&BCells;

vennPlot{1}=find(infoCSCells);
vennPlot{2}=find(waterCSCells);
vennPlot{3}=find(waterUSCells);
vennPlot{4}=find(infoUSCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% 
% [H,S]=venn([sum(infoCells) sum(waterCSCells) sum(waterCells)],[sum(overlap12Cells),sum(overlap13Cells),sum(overlap23Cells),sum(overlap3Cells)]);
%   for i = 1:3
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))]);
%   end
% text(S.ZoneCentroid(4,1), S.ZoneCentroid(4,2), num2str(sum(overlap12Cells)/a.neuronCt));
% text(S.ZoneCentroid(5,1), S.ZoneCentroid(5,2), num2str(sum(overlap13Cells)/a.neuronCt));
% text(S.ZoneCentroid(6,1), S.ZoneCentroid(6,2), num2str(sum(overlap23Cells)/a.neuronCt));
% text(S.ZoneCentroid(7,1), S.ZoneCentroid(7,2), num2str(sum(overlap3Cells)/a.neuronCt));
% % axis square;
h=vennEulerDiagram(fig,vennPlot, {'InfoCS','WaterCS','WaterUS','InfoUS'}, 'drawProportional', true,'showintersectioncounts',true);
vennPlot=[];
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AllValuesVenn']),'pdf');


%% ALL VALUES 2
infoCSCells = activeCells(:,5); % infoforced
waterCSCells = activeCells(:,9); %A
infoUSCells = activeCells(:,10); %B
waterUSCells = activeCells(:,15); % no info water

vennPlot{1}=find(infoCSCells);
vennPlot{3}=find(waterCSCells);
vennPlot{2}=find(infoUSCells);
vennPlot{4}=find(waterUSCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% 
% [H,S]=venn([sum(infoCells) sum(waterCSCells) sum(waterCells)],[sum(overlap12Cells),sum(overlap13Cells),sum(overlap23Cells),sum(overlap3Cells)]);
%   for i = 1:3
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))]);
%   end
% text(S.ZoneCentroid(4,1), S.ZoneCentroid(4,2), num2str(sum(overlap12Cells)/a.neuronCt));
% text(S.ZoneCentroid(5,1), S.ZoneCentroid(5,2), num2str(sum(overlap13Cells)/a.neuronCt));
% text(S.ZoneCentroid(6,1), S.ZoneCentroid(6,2), num2str(sum(overlap23Cells)/a.neuronCt));
% text(S.ZoneCentroid(7,1), S.ZoneCentroid(7,2), num2str(sum(overlap3Cells)/a.neuronCt));
% % axis square;
h=vennEulerDiagram(fig,vennPlot, {'Info act','A act','B act','Water act'}, 'drawProportional', true,'showintersectioncounts',true);
vennPlot=[];
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AllValuesVenn2']),'pdf');

%% ALL VALUES 3
infoCSCells = differentCells(:,2); % infoforced
waterCSCells = differentCells(:,3); %A
infoUSCells = activeCells(:,10); %B
waterUSCells = activeCells(:,15); % no info water

vennPlot{1}=find(infoCSCells);
vennPlot{3}=find(waterCSCells);
vennPlot{2}=find(infoUSCells);
vennPlot{4}=find(waterUSCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% 
% [H,S]=venn([sum(infoCells) sum(waterCSCells) sum(waterCells)],[sum(overlap12Cells),sum(overlap13Cells),sum(overlap23Cells),sum(overlap3Cells)]);
%   for i = 1:3
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))]);
%   end
% text(S.ZoneCentroid(4,1), S.ZoneCentroid(4,2), num2str(sum(overlap12Cells)/a.neuronCt));
% text(S.ZoneCentroid(5,1), S.ZoneCentroid(5,2), num2str(sum(overlap13Cells)/a.neuronCt));
% text(S.ZoneCentroid(6,1), S.ZoneCentroid(6,2), num2str(sum(overlap23Cells)/a.neuronCt));
% text(S.ZoneCentroid(7,1), S.ZoneCentroid(7,2), num2str(sum(overlap3Cells)/a.neuronCt));
% % axis square;
h=vennEulerDiagram(fig,vennPlot, {'InfoDiff','A diff','B act','Water act'}, 'drawProportional', true,'showintersectioncounts',true);
vennPlot=[];
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AllValuesVenn3']),'pdf');

%% ALL VALUES 4
infoCSCells = differentCells(:,2); % infoforced
waterCSCells = differentCells(:,3); %A
infoUSCells = differentCells(:,9)&a.activityPostDiff{5}>0; % AB v CD
waterUSCells = differentCells(:,7); % no info water

vennPlot{1}=find(infoCSCells);
vennPlot{3}=find(waterCSCells);
vennPlot{2}=find(infoUSCells);
vennPlot{4}=find(waterUSCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% 
% [H,S]=venn([sum(infoCells) sum(waterCSCells) sum(waterCells)],[sum(overlap12Cells),sum(overlap13Cells),sum(overlap23Cells),sum(overlap3Cells)]);
%   for i = 1:3
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))]);
%   end
% text(S.ZoneCentroid(4,1), S.ZoneCentroid(4,2), num2str(sum(overlap12Cells)/a.neuronCt));
% text(S.ZoneCentroid(5,1), S.ZoneCentroid(5,2), num2str(sum(overlap13Cells)/a.neuronCt));
% text(S.ZoneCentroid(6,1), S.ZoneCentroid(6,2), num2str(sum(overlap23Cells)/a.neuronCt));
% text(S.ZoneCentroid(7,1), S.ZoneCentroid(7,2), num2str(sum(overlap3Cells)/a.neuronCt));
% % axis square;
h=vennEulerDiagram(fig,vennPlot, {'InfoDiff','AB>CD','A diff','Water diff'}, 'drawProportional', true,'showintersectioncounts',true);
vennPlot=[];
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AllValuesVenn4']),'pdf');

%% ALL VALUES 5
infoCSCells = differentCells(:,2); % infoforced
waterCSCells = differentCells(:,3); %A
infoUSPosCells = differentCells(:,9)&a.activityPostDiff{5}>0; % AB v CD
infoUSNegCells = differentCells(:,9)&a.activityPostDiff{5}<0; % AB v CD
waterUSCells = differentCells(:,7); % no info water

vennPlot{1}=find(infoCSCells);
vennPlot{3}=find(waterCSCells);
vennPlot{2}=find(infoUSPosCells);
vennPlot{4}=find(infoUSNegCells);
vennPlot{5}=find(waterUSCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];
% 
% [H,S]=venn([sum(infoCells) sum(waterCSCells) sum(waterCells)],[sum(overlap12Cells),sum(overlap13Cells),sum(overlap23Cells),sum(overlap3Cells)]);
%   for i = 1:3
%       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))]);
%   end
% text(S.ZoneCentroid(4,1), S.ZoneCentroid(4,2), num2str(sum(overlap12Cells)/a.neuronCt));
% text(S.ZoneCentroid(5,1), S.ZoneCentroid(5,2), num2str(sum(overlap13Cells)/a.neuronCt));
% text(S.ZoneCentroid(6,1), S.ZoneCentroid(6,2), num2str(sum(overlap23Cells)/a.neuronCt));
% text(S.ZoneCentroid(7,1), S.ZoneCentroid(7,2), num2str(sum(overlap3Cells)/a.neuronCt));
% % axis square;
h=vennEulerDiagram(fig,vennPlot, {'InfoDiff','AB>CD','A diff','CD>AB','Water diff'}, 'drawProportional', true,'showintersectioncounts',true);
vennPlot=[];
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AllValuesVenn5']),'pdf');

%% CORRELATIONS

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.pNeuronsPost{2}<5)={'X Sig'};
sig1(a.pNeuronsPost{3}<5)={'Y Sig'};
sig1(a.pNeuronsPost{2}<5&a.pNeuronsPost{3}<5)={'Both Sig'};
ax1=nsubplot(2,3,1,1);
gscatter(a.activityPostDiff{2},a.activityPostDiff{3},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.activityPostDiff{2},a.activityPostDiff{3});
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('Info-NoInfo')
ylabel('A-B')
xlim([-2 2])
ylim([-2 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.pNeuronsPost{2}<5)={'X Sig'};
sig1(a.pNeuronsPost{7}<5)={'Y Sig'};
sig1(a.pNeuronsPost{2}<5&a.pNeuronsPost{7}<5)={'Both Sig'};
ax1=nsubplot(2,3,1,2);
gscatter(a.activityPostDiff{2},a.activityPostDiff{7},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.activityPostDiff{2},a.activityPostDiff{7});
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('Info-NoInfo')
ylabel('Water - No Water')
% xlim([-2 2])
% ylim([0 2])
axis equal
% axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.pNeuronsPost{3}<5)={'X Sig'};
sig1(a.pNeuronsPost{7}<5)={'Y Sig'};
sig1(a.pNeuronsPost{3}<5&a.pNeuronsPost{7}<5)={'Both Sig'};
ax1=nsubplot(2,3,2,1);
gscatter(a.activityPostDiff{3},a.activityPostDiff{7},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.activityPostDiff{3},a.activityPostDiff{7});
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('A - B')
ylabel('Water - No Water')
% xlim([-2 2])
% ylim([0 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.pNeuronsPost{3}<5)={'X Sig'};
sig1(a.pNeuronsPost{6}<5)={'Y Sig'};
sig1(a.pNeuronsPost{3}<5&a.pNeuronsPost{6}<5)={'Both Sig'};
ax1=nsubplot(2,3,2,2);
gscatter(a.activityPostDiff{3},a.activityPostDiff{6},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.activityPostDiff{3},a.activityPostDiff{6});
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('A - B')
ylabel('Info Water - Info No Water')
% xlim([-2 2])
% ylim([0 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.pNeuronsPost{2}<5)={'X Sig'};
sig1(a.pNeuronsPost{5}<5)={'Y Sig'};
sig1(a.pNeuronsPost{2}<5&a.pNeuronsPost{5}<5)={'Both Sig'};
ax1=nsubplot(2,3,1,3);
gscatter(a.activityPostDiff{2},a.activityPostDiff{5},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.activityPostDiff{2},a.activityPostDiff{5});
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('Info-NoInfo')
ylabel('AB - CD')
% xlim([-2 2])
% ylim([0 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.pNeuronsPost{6}<5)={'X Sig'};
sig1(a.pNeuronsPost{7}<5)={'Y Sig'};
sig1(a.pNeuronsPost{6}<5&a.pNeuronsPost{7}<5)={'Both Sig'};
ax1=nsubplot(2,3,2,3);
gscatter(a.activityPostDiff{6},a.activityPostDiff{7},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.activityPostDiff{2},a.activityPostDiff{5});
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('Info Water - Info No Water')
ylabel('No Info Water - No Info No Water')
% xlim([-2 2])
% ylim([0 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ActivityCorrelations']),'pdf');

%% ACTIVITY CORRELATIONS EBM

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{2}<0.05)={'X Sig'};
sig1(a.actDiffIdxEBMSig{3}<0.05)={'Y Sig'};
sig1(a.actDiffIdxEBMSig{2}<0.05&a.actDiffIdxEBMSig{3}<0.05)={'Both Sig'};
ax1=nsubplot(2,3,1,1);
gscatter(a.actDiffPostEBM{2},a.actDiffPostEBM{3},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.actDiffPostEBM{2},a.actDiffPostEBM{3});
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('Info-NoInfo')
ylabel('A-B')
xlim([-2 2])
ylim([-2 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{2}<0.05)={'X Sig'};
sig1(a.actDiffIdxEBMSig{7}<0.05)={'Y Sig'};
sig1(a.actDiffIdxEBMSig{2}<0.05&a.actDiffIdxEBMSig{7}<0.05)={'Both Sig'};
ax1=nsubplot(2,3,1,2);
gscatter(a.actDiffPostEBM{2},a.actDiffPostEBM{7},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.actDiffPostEBM{2},a.actDiffPostEBM{7});
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('Info-NoInfo')
ylabel('Water - No Water')
% xlim([-2 2])
% ylim([0 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{3}<0.05)={'X Sig'};
sig1(a.actDiffIdxEBMSig{7}<0.05)={'Y Sig'};
sig1(a.actDiffIdxEBMSig{3}<0.05&a.actDiffIdxEBMSig{7}<0.05)={'Both Sig'};
ax1=nsubplot(2,3,2,1);
gscatter(a.actDiffPostEBM{3},a.actDiffPostEBM{7},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.actDiffPostEBM{3},a.actDiffPostEBM{7});
refline(1, 0);
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('A - B')
ylabel('Water - No Water')
% xlim([-2 2])
% ylim([0 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{3}<0.05)={'X Sig'};
sig1(a.actDiffIdxEBMSig{6}<0.05)={'Y Sig'};
sig1(a.actDiffIdxEBMSig{3}<0.05&a.actDiffIdxEBMSig{6}<0.05)={'Both Sig'};
ax1=nsubplot(2,3,2,2);
gscatter(a.actDiffPostEBM{3},a.actDiffPostEBM{6},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.actDiffPostEBM{3},a.actDiffPostEBM{6});
refline(1, 0);
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('A - B')
ylabel('Info Water - Info No Water')
% xlim([-2 2])
% ylim([0 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{2}<0.05)={'X Sig'};
sig1(a.actDiffIdxEBMSig{5}<0.05)={'Y Sig'};
sig1(a.actDiffIdxEBMSig{2}<0.05&a.actDiffIdxEBMSig{5}<0.05)={'Both Sig'};
ax1=nsubplot(2,3,1,3);
gscatter(a.actDiffPostEBM{2},a.actDiffPostEBM{5},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.actDiffPostEBM{2},a.actDiffPostEBM{5});
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('Info-NoInfo')
ylabel('AB - CD')
% xlim([-2 2])
% ylim([0 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{6}<0.05)={'X Sig'};
sig1(a.actDiffIdxEBMSig{7}<0.05)={'Y Sig'};
sig1(a.actDiffIdxEBMSig{6}<0.05&a.actDiffIdxEBMSig{7}<0.05)={'Both Sig'};
ax1=nsubplot(2,3,2,3);
gscatter(a.actDiffPostEBM{6},a.actDiffPostEBM{7},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.actDiffPostEBM{2},a.actDiffPostEBM{5});
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('Info Water - Info No Water')
ylabel('No Info Water - No Info No Water')
% xlim([-2 2])
% ylim([0 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ActivityCorrelationsEBM']),'pdf');

%% ACTIVITY CORRELATIONS EBM PREPOST

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{2}<0.05)={'X Sig'};
sig1(a.actDiffIdxEBMSig{3}<0.05)={'Y Sig'};
sig1(a.actDiffIdxEBMSig{2}<0.05&a.actDiffIdxEBMSig{3}<0.05)={'Both Sig'};
ax1=nsubplot(2,3,1,1);
gscatter(a.actDiffPostEBM{2}-a.actDiffPreEBM{2},a.actDiffPostEBM{3}-a.actDiffPreEBM{3},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.actDiffPostEBM{2}-a.actDiffPreEBM{2},a.actDiffPostEBM{3}-a.actDiffPreEBM{3},'Tail','right');
[diffCorr,diffP] = corr(a.actDiffPostEBM{2}-a.actDiffPreEBM{2},a.actDiffPostEBM{3}-a.actDiffPreEBM{3});
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('Info-NoInfo')
ylabel('A-B')
xlim([-2 2])
ylim([-2 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{2}<0.05)={'X Sig'};
sig1(a.actDiffIdxEBMSig{7}<0.05)={'Y Sig'};
sig1(a.actDiffIdxEBMSig{2}<0.05&a.actDiffIdxEBMSig{7}<0.05)={'Both Sig'};
ax1=nsubplot(2,3,1,2);
gscatter(a.actDiffPostEBM{2}-a.actDiffPreEBM{2},a.actDiffPostEBM{7}-a.actDiffPreEBM{7},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.actDiffPostEBM{2}-a.actDiffPreEBM{2},a.actDiffPostEBM{7}-a.actDiffPreEBM{7},'Tail','right');
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('Info-NoInfo')
ylabel('No Info Water - No Info No Water')
% xlim([-2 2])
% ylim([0 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{3}<0.05)={'X Sig'};
sig1(a.actDiffIdxEBMSig{7}<0.05)={'Y Sig'};
sig1(a.actDiffIdxEBMSig{3}<0.05&a.actDiffIdxEBMSig{7}<0.05)={'Both Sig'};
ax1=nsubplot(2,3,2,1);
gscatter(a.actDiffPostEBM{3}-a.actDiffPreEBM{3},a.actDiffPostEBM{7}-a.actDiffPreEBM{7},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.actDiffPostEBM{3}-a.actDiffPreEBM{3},a.actDiffPostEBM{7}-a.actDiffPreEBM{7},'Tail','right');
refline(1, 0);
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('A - B')
ylabel('No Info Water - No Info No Water')
% xlim([-2 2])
% ylim([0 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{3}<0.05)={'X Sig'};
sig1(a.actDiffIdxEBMSig{6}<0.05)={'Y Sig'};
sig1(a.actDiffIdxEBMSig{3}<0.05&a.actDiffIdxEBMSig{6}<0.05)={'Both Sig'};
ax1=nsubplot(2,3,2,2);
gscatter(a.actDiffPostEBM{3}-a.actDiffPreEBM{3},a.actDiffPostEBM{6}-a.actDiffPreEBM{6},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.actDiffPostEBM{3}-a.actDiffPreEBM{3},a.actDiffPostEBM{6}-a.actDiffPreEBM{6},'Tail','right');
refline(1, 0);
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('A - B')
ylabel('Info Water - Info No Water')
% xlim([-2 2])
% ylim([0 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{2}<0.05)={'X Sig'};
sig1(a.actDiffIdxEBMSig{5}<0.05)={'Y Sig'};
sig1(a.actDiffIdxEBMSig{2}<0.05&a.actDiffIdxEBMSig{5}<0.05)={'Both Sig'};
ax1=nsubplot(2,3,1,3);
gscatter(a.actDiffPostEBM{2}-a.actDiffPreEBM{2},a.actDiffPostEBM{5}-a.actDiffPreEBM{5},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.actDiffPostEBM{2}-a.actDiffPreEBM{2},a.actDiffPostEBM{5}-a.actDiffPreEBM{5},'Tail','right');
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('Info-NoInfo')
ylabel('AB - CD')
% xlim([-2 2])
% ylim([0 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{6}<0.05)={'X Sig'};
sig1(a.actDiffIdxEBMSig{7}<0.05)={'Y Sig'};
sig1(a.actDiffIdxEBMSig{6}<0.05&a.actDiffIdxEBMSig{7}<0.05)={'Both Sig'};
ax1=nsubplot(2,3,2,3);
gscatter(a.actDiffPostEBM{6}-a.actDiffPreEBM{6},a.actDiffPostEBM{7}-a.actDiffPreEBM{7},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.actDiffPostEBM{6}-a.actDiffPreEBM{6},a.actDiffPostEBM{7}-a.actDiffPreEBM{7},'Tail','right');
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('Info Water - Info No Water')
ylabel('No Info Water - No Info No Water')
% xlim([-2 2])
% ylim([0 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ActivityCorrelationsEBMPrePost']),'pdf');

%% ACTIVITY CORRELATIONS EBM PREPOST INFO US

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{5}<0.05)={'X Sig'};
sig1(a.actDiffIdxEBMSig{6}<0.05)={'Y Sig'};
sig1(a.actDiffIdxEBMSig{5}<0.05&a.actDiffIdxEBMSig{6}<0.05)={'Both Sig'};
ax1=nsubplot(1,2,1,1);
gscatter(a.actDiffPostEBM{5}-a.actDiffPreEBM{5},a.actDiffPostEBM{6}-a.actDiffPreEBM{6},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.actDiffPostEBM{5}-a.actDiffPreEBM{5},a.actDiffPostEBM{6}-a.actDiffPreEBM{6});
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('Info US AB-CD')
ylabel('Water US Info Water - Info No Water')
xlim([-2 2])
ylim([-2 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{5}<0.05)={'X Sig'};
sig1(a.actDiffIdxEBMSig{7}<0.05)={'Y Sig'};
sig1(a.actDiffIdxEBMSig{5}<0.05&a.actDiffIdxEBMSig{7}<0.05)={'Both Sig'};
ax1=nsubplot(1,2,1,2);
gscatter(a.actDiffPostEBM{5}-a.actDiffPreEBM{5},a.actDiffPostEBM{7}-a.actDiffPreEBM{7},sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
[diffCorr,diffP] = corr(a.actDiffPostEBM{5}-a.actDiffPreEBM{5},a.actDiffPostEBM{7}-a.actDiffPreEBM{7});
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
refline(1, 0);
xlabel('Info US AB-CD')
ylabel('Water US Rand Water - Rand No Water')
xlim([-2 2])
ylim([-2 2])
axis equal
title(['Correlation = ' num2str(diffCorr) ' p = ' num2str(diffP)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ActivityCorrelationsUS_EBMPrePost']),'pdf');

%% Choice Forced EBM diff CORRELATION

forcedAct=a.actDiffPostEBM{2}-a.actDiffPreEBM{2};
choiceAct=a.actDiffPostEBM{11}-a.actDiffPreEBM{11};

% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5]; 
% fig.PaperPosition = [0 0 10 8];
% scatter(forcedAct,choiceAct);axis square;xlabel('Info Forced vs No Info Forced Encoding');ylabel('Info Choice vs No Info Forced Encoding')
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ForcedChoiceEBMprepostCorr']),'pdf');
% corr(forcedAct,choiceAct)

[ForcedChoicecorr, ForcedChoicep] = corr(forcedAct,choiceAct);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{2}<=0.05&~a.actDiffIdxEBMSig{11}<=0.05)={'Forced Sig'};
sig1(~a.actDiffIdxEBMSig{2}<=0.05&a.actDiffIdxEBMSig{11}<=0.05)={'Choice Sig'};
sig1(a.actDiffIdxEBMSig{2}<=0.05&a.actDiffIdxEBMSig{11}<=0.05)={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,1,1,1);
gscatter(forcedAct,choiceAct,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Aresp,Bresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Forced EBM Coding Post-Pre')
ylabel('Info Choice EBM Coding Post-Pre')
% xlim([0 5])
% ylim([0 5])
axis square
title(['Correlation = ' num2str(ForcedChoicecorr) ' p = ' num2str(ForcedChoicep)])


saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoForcedandChoiceEBMdiff_correlation']),'pdf');

%% FIGURE 1 VARIANCE EXPLAINED

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');

nsubplot(2,1,1,1);
plot(LIN(1:10),'bo','linewidth',2);
xlabel('Info-NoInfo PC')
ylabel('percent variance')
title(strjoin(mice,' _ '))
xlim([0 10])

nsubplot(2,1,2,1);
plot(LLR(1:10),'bo','linewidth',2);
xlabel('Left-Right PC')
ylabel('percent variance')
title([mice{1} ' _ ' strjoin(days{1},' _ ')])
xlim([0 10])
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_VarianceExplained']),'pdf'); 

%% FIGURE 2 ACTIVITY PROJECTED TO PC

yMax = [5];
yMin = [-5];
figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 8.5 11];
set(fig,'PaperOrientation','portrait');
nsubplot(2,1,1,1);
plot(iStart:iStop,UIN(:,1)'*rI,'Color',a.purple,'linewidth',2);
hold on
plot(iStart:iStop,UIN(:,1)'*rN,'Color',a.orange,'linewidth',2);
plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
plot([40 40],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
plot([44 44],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
hold off;
xlim([iStart iStop]);
% ylim([yMin(1) yMax(1)]);
xlabel('time')
ylabel('PC1 Proejction')
title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
legend('Info','No Info','location','northwest');
nsubplot(2,1,2,1);
plot(iStart:iStop,ULR(:,1)'*rL,'b','linewidth',2);
hold on
plot(iStart:iStop,ULR(:,1)'*rR,'r','linewidth',2);
plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
plot([40 40],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
plot([44 44],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
hold off;
xlim([iStart iStop]);
% ylim([yMin(1) yMax(1)]);
xlabel('time')
ylabel('PC1 Projection')
title(['Left-Right  ' num2str(LLR(1)) '% of variance'])
legend('Left','Right','location','northwest')
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96,[strjoin(mice,' _ ')],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_ActivitybyPC']),'pdf');

%% FIGURE 3 DIFFERENCE VS SIGNIFICANCE

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
nsubplot(2,1,1,1);
bar(NeuronAreas(iASort),'b')
hold on
plot([0 N], [NeuronAreas(iASort(nSig+1)) NeuronAreas(iASort(nSig+1))],...
    'r','linewidth',2);
hold off
xlabel('neuron rank')
ylabel('mean Difference')
nsubplot(2,1,2,1);
bar(pNeurons(iASort),'b')
hold on
plot([0 N], [5 5], 'r','linewidth',2);
hold off
ylim([0 100])
xlabel('neuron rank')
ylabel('p (percent)')
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96,[strjoin(mice,' _ '),' Info-No Info by signficance'],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_INdiffvssig']),'pdf');
    
%% FIGURE 4 WEIGHTS

figure()
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
nsubplot(3,1,1,1);
bar(UINSort)
xlim([0.5 N+0.5])
xlabel('neuron')
ylabel('weight')
title('Info-NoInfo PC1')
nsubplot(3,1,2,1);
bar(ULRSort)
xlim([0.5 N+0.5])
xlabel('neuron')
ylabel('weight')
title('Left-Right PC1')
nsubplot(3,1,3,1);
bar(wSort)
xlim([0.5 N+0.5])
xlabel('neuron')
ylabel('weight')
title('Info-No Info Decode')
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_PC',num2str(PC),'weights']),'pdf');

%% FIGURE 4 CORRELATIONS

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');

ax1=nsubplot(2,2,1,1);
plot(ULR(:,1),UIN(:,1),'bo','linewidth',2)
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Left-Right Weight')
ylabel('Info-NoInfo Weight')
title(['Correlation = ' num2str(correlations(1)) 'p=' num2str(corrpvals(1))])
xlim([-0.5 0.5])
ylim([-0.5 0.5])
ax2=nsubplot(2,2,1,2);
plot(UIN(ismember(a.mouse,okMice),1),wDecode,'bo','linewidth',2)
plot(ax2,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax2,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info-NoInfo Weight')
ylabel('Decode Weight')
xlim([-0.5 0.5])
ylim([-0.5 0.5])
title(['Correlation = ' num2str(correlations(2)) 'p=' num2str(corrpvals(2))])
ax3=nsubplot(2,2,2,1);
plot(ULR(ismember(a.mouse,okMice),1),wDecode,'bo','linewidth',2)
plot(ax3,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax3,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Left-Right Weight')
ylabel('Decode Weight')
xlim([-0.5 0.5])
ylim([-0.5 0.5])
title(['Correlation = ' num2str(correlations(3)) 'p=' num2str(corrpvals(3))])
ax4=nsubplot(2,2,2,2);
plot(UIN(:,1),mean(rIN,2),'bo','linewidth',2)
plot(ax4,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax4,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Difference Amplitude')
ylabel('Info-No Info Weight')
xlim([-0.5 0.5])
ylim([-0.5 0.5])
title(['Correlation = ' num2str(correlations(4)) 'p=' num2str(corrpvals(4))])
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_correlations']),'pdf');

%% FIGURE 7 SIDE ODOR VARIANCE

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');

nsubplot(2,1,1,1);
plot(LAB(1:10),'bo','linewidth',2);
xlabel('Odor A-Odor B PC')
ylabel('percent variance')
title([mice{1} ' _ ' strjoin(days{1},' _ ')])
xlim([0 10])

nsubplot(2,1,2,1);
plot(LCD(1:10),'bo','linewidth',2);
xlabel('Odor C-Odor D PC')
ylabel('percent variance')
title([mice{1} ' _ ' strjoin(days{1},' _ ')])
xlim([0 10])
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_side_VarianceExplained']),'pdf');

%% FIGURE 8 SIDE ODOR PC PROJECTION

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 8.5 11];
set(fig,'PaperOrientation','portrait');
nsubplot(2,1,1,1);
plot(iStart:iStop,UAB(:,1)'*rA,'Color','g','linewidth',2);
hold on
plot(iStart:iStop,UAB(:,1)'*rB,'Color','m','linewidth',2);
plot([40 40],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
plot([44 44],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
hold off;
xlim([iStart iStop]);
y1=ylim;
% ylim([yMin(1) yMax(1)]);
xlabel('time')
ylabel('PC1 Projection')
title(['A-B  ' num2str(LAB(1)) '% of variance']);
legend('Odor A','Odor B','location','northwest');
nsubplot(2,1,2,1);
plot(iStart:iStop,UCD(:,1)'*rC,'b','linewidth',2);
hold on
plot(iStart:iStop,UCD(:,1)'*rD,'r','linewidth',2);
plot([40 40],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
plot([44 44],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
hold off;
xlim([iStart iStop]);
ylim([-inf y1(2)]);
xlabel('time')
ylabel('PC1 Projection')
title(['C-D  ' num2str(LCD(1)) '% of variance'])
legend('Odor C','Odor D','location','northwest')
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96,[mice{1},' _ ',strjoin(days{1},' _ ')],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_side_ActivitybyPC']),'pdf');

%% FIGURE 9 SIDE ODOR WEIGHTS

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
nsubplot(2,1,1,1);
bar(UABSort)
xlim([0.5 N+0.5])
xlabel('neuron')
ylabel('weight')
title('A-B PC1')
nsubplot(2,1,2,1);
bar(UCDSort)
xlim([0.5 N+0.5])
xlabel('neuron')
ylabel('weight')
title('C-D PC1')

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96,[mice{1},' _ ',strjoin(days{1},' _ ')],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_side_PC',num2str(PC),'weights']),'pdf');

%% FIGURE 11 CORRELATIONS

% sNeuronAreas = mean difference for each cell
% pNeurons<5 = diff significant

% [ASort,AIdx] = sort(mean(squeeze(mean(a.C_odor2A(:,40:80,:),3,'omitnan')),2,'omitnan'),'descend');
% [BSort,BIdx] = sort(mean(squeeze(mean(a.C_odor2B(:,40:80,:),3,'omitnan')),2,'omitnan'),'descend');
%


% sNeuronAreas = mean difference for each cell
% pNeurons<5 = diff significant

% [ASort,AIdx] = sort(mean(squeeze(mean(a.C_odor2A(:,40:80,:),3,'omitnan')),2,'omitnan'),'descend');
% [BSort,BIdx] = sort(mean(squeeze(mean(a.C_odor2B(:,40:80,:),3,'omitnan')),2,'omitnan'),'descend');
%

% 44:64 vs 40:65
Aresp=mean(squeeze(mean(a.C_odor2A(:,44:64,:),3,'omitnan')),2,'omitnan');
Bresp=mean(squeeze(mean(a.C_odor2B(:,44:64,:),3,'omitnan')),2,'omitnan');

[ABcorr, ABp] = corr(Aresp,Bresp);

Arespsub=mean(squeeze(mean(a.C_odor2A(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor2A(:,30:40,:),3,'omitnan')),2,'omitnan');
Brespsub=mean(squeeze(mean(a.C_odor2B(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor2B(:,30:40,:),3,'omitnan')),2,'omitnan');

[ABcorrsub, ABpsub] = corr(Arespsub,Brespsub);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,9)==1&~activeCellsRS(:,10)==1)={'A Sig'};
sig1(activeCellsRS(:,10)==1&~activeCellsRS(:,9)==1)={'B Sig'};
sig1(activeCellsRS(:,10)&activeCellsRS(:,9))={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
gscatter(Aresp,Bresp,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Aresp,Bresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Odor A Activity')
ylabel('Odor B Activity')
xlim([0 5])
ylim([0 5])
axis square
title(['Correlation = ' num2str(ABcorr) ' p = ' num2str(ABp)])

ax1=nsubplot(1,2,1,2);
gscatter(Arespsub,Brespsub,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Arespsub,Brespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Odor A Activity - pre-odor mean')
ylabel('Odor B Activity - pre-odor mean')
xlim([0 5])
ylim([0 5])
axis square
title(['Correlation = ' num2str(ABcorrsub) ' p = ' num2str(ABpsub)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_SideOdorAB_correlations']),'pdf');

%% CD

Cresp=mean(squeeze(mean(a.C_odor2C(:,44:64,:),3,'omitnan')),2,'omitnan');
Dresp=mean(squeeze(mean(a.C_odor2D(:,44:64,:),3,'omitnan')),2,'omitnan');

[CDcorr, CDp] = corr(Cresp,Dresp);

Crespsub=mean(squeeze(mean(a.C_odor2C(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor2C(:,30:40,:),3,'omitnan')),2,'omitnan');
Drespsub=mean(squeeze(mean(a.C_odor2D(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor2D(:,30:40,:),3,'omitnan')),2,'omitnan');

[CDcorrsub, CDpsub] = corr(Crespsub,Drespsub);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,11)==1&~activeCellsRS(:,12)==1)={'A Sig'};
sig1(activeCellsRS(:,12)==1&~activeCellsRS(:,11)==1)={'B Sig'};
sig1(activeCellsRS(:,11)&activeCellsRS(:,12))={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
gscatter(Dresp,Cresp,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Dresp,Cresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Odor D Activity')
ylabel('Odor C Activity')
xlim([0 5])
ylim([0 5])
axis square
title(['Correlation = ' num2str(CDcorr) ' p = ' num2str(CDp)])

ax1=nsubplot(1,2,1,2);
gscatter(Drespsub,Crespsub,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Drespsub,Crespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Odor D Activity - pre-odor mean')
ylabel('Odor C Activity - pre-odor mean')
xlim([0 5])
ylim([0 5])
axis square
title(['Correlation = ' num2str(CDcorrsub) ' p = ' num2str(CDpsub)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_SideOdorCD_correlations']),'pdf');

%% AB vs CD

ABresp=mean(squeeze(mean(a.C_odor2info(:,44:64,:),3,'omitnan')),2,'omitnan');
CDresp=mean(squeeze(mean(a.C_odor2rand(:,44:64,:),3,'omitnan')),2,'omitnan');

[ABCDcorr, ABCDp] = corr(ABresp,CDresp);

ABrespsub=mean(squeeze(mean(a.C_odor2info(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor2info(:,30:40,:),3,'omitnan')),2,'omitnan');
CDrespsub=mean(squeeze(mean(a.C_odor2rand(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor2rand(:,30:40,:),3,'omitnan')),2,'omitnan');

[ABCDcorrsub, ABCDpsub] = corr(ABrespsub,CDrespsub);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,9)==1&activeCellsRS(:,10)&~activeCellsRS(:,11)&~activeCellsRS(:,12))={'AB Sig'};
sig1(~activeCellsRS(:,9)&~activeCellsRS(:,10)&activeCellsRS(:,11)&activeCellsRS(:,12))={'CD Sig'};
sig1(activeCellsRS(:,9)&activeCellsRS(:,10)&activeCellsRS(:,11)&activeCellsRS(:,12))={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
gscatter(ABresp,CDresp,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(ABresp,CDresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Odor AB Activity')
ylabel('Odor CD Activity')
xlim([0 5])
ylim([0 5])
axis square
title(['Correlation = ' num2str(ABCDcorr) ' p = ' num2str(ABCDp)])

ax1=nsubplot(1,2,1,2);
gscatter(ABrespsub,CDrespsub,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(ABrespsub,CDrespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Odor AB Activity - pre-odor mean')
ylabel('Odor CD Activity - pre-odor mean')
xlim([0 5])
ylim([0 5])
axis square
title(['Correlation = ' num2str(ABCDcorrsub) ' p = ' num2str(ABCDpsub)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_SideOdorABCD_correlations']),'pdf');

%% CHOICE FORCED CORRELATION

InfoForcedresp=mean(squeeze(mean(a.C_odor1FirstInfoForced(:,44:64,:),3,'omitnan')),2,'omitnan');
InfoChoiceresp=mean(squeeze(mean(a.C_odor1FirstInfoChoice(:,44:64,:),3,'omitnan')),2,'omitnan');

[FCcorr, FCp] = corr(InfoForcedresp,InfoChoiceresp);

InfoForcedrespsub=mean(squeeze(mean(a.C_odor1FirstInfoForced(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstInfoForced(:,30:40,:),3,'omitnan')),2,'omitnan');
InfoChoicerespsub=mean(squeeze(mean(a.C_odor1FirstInfoChoice(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstInfoChoice(:,30:40,:),3,'omitnan')),2,'omitnan');

[FCcorrsub, FCpsub] = corr(InfoForcedrespsub,InfoChoicerespsub);

% if p == 0
%     pstr = 'p<2e-308';
% else
%     pstr = sprintf('p=%.3e', p);
% end

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,5)==1&~activeCellsRS(:,6)==1)={'Forced Sig'};
sig1(activeCellsRS(:,6)==1&~activeCellsRS(:,5)==1)={'Choice Sig'};
sig1(activeCellsRS(:,5)&activeCellsRS(:,6))={'Both Sig'};
% sig1(activeCellsRS(:,5)&activeCellsRS(:,6))={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
gscatter(InfoForcedresp,InfoChoiceresp,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(InfoForcedresp,InfoChoiceresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Forced Activity')
ylabel('Info Choice Activity')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorr) ' p = ' num2str(FCp)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,5)&activeCellsRS(:,6))={'Both Sig'};
sig1(activeCellsRS(:,5)==1&~activeCellsRS(:,6)==1)={'Forced Sig'};
sig1(activeCellsRS(:,6)==1&~activeCellsRS(:,5)==1)={'Choice Sig'};
ax1=nsubplot(1,2,1,2);
gscatter(InfoForcedrespsub,InfoChoicerespsub,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(InfoForcedrespsub,InfoChoicerespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Forced Activity - pre-odor mean')
ylabel('Info Choice Activity - pre-odor mean')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorrsub) ' p = ' num2str(FCpsub)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ChoiceInfoForcedInfo_correlations']),'pdf');

%%

InfoForcedresp=mean(squeeze(mean(a.C_odor1FirstInfoForcedLeft(:,44:64,:),3,'omitnan')),2,'omitnan');
InfoChoiceresp=mean(squeeze(mean(a.C_odor1FirstInfoChoiceLeft(:,44:64,:),3,'omitnan')),2,'omitnan');

[FCcorr, FCp] = corr(InfoForcedresp,InfoChoiceresp);

InfoForcedrespsub=mean(squeeze(mean(a.C_odor1FirstInfoForcedLeft(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstInfoForcedLeft(:,30:40,:),3,'omitnan')),2,'omitnan');
InfoChoicerespsub=mean(squeeze(mean(a.C_odor1FirstInfoChoiceLeft(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstInfoChoiceLeft(:,30:40,:),3,'omitnan')),2,'omitnan');

[FCcorrsub, FCpsub] = corr(InfoForcedrespsub,InfoChoicerespsub);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,17)==1&~activeCellsRS(:,18)==1)={'Forced Sig'};
sig1(activeCellsRS(:,18)==1&~activeCellsRS(:,17)==1)={'Choice Sig'};
sig1(activeCellsRS(:,17)&activeCellsRS(:,18))={'Both Sig'};
% sig1(activeCellsRS(:,5)&activeCellsRS(:,6))={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
gscatter(InfoForcedresp,InfoChoiceresp,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(InfoForcedresp,InfoChoiceresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Forced Activity')
ylabel('Info Choice Activity')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorr) ' p = ' num2str(FCp)])

% sig1=cell(a.neuronCt,1);
% sig1(:)={'NS'};
% sig1(activeCellsRS(:,5)&activeCellsRS(:,6))={'Both Sig'};
% sig1(activeCellsRS(:,5)==1&~activeCellsRS(:,6)==1)={'Forced Sig'};
% sig1(activeCellsRS(:,6)==1&~activeCellsRS(:,5)==1)={'Choice Sig'};
ax1=nsubplot(1,2,1,2);
gscatter(InfoForcedrespsub,InfoChoicerespsub,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(InfoForcedrespsub,InfoChoicerespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Forced Activity - pre-odor mean')
ylabel('Info Choice Activity - pre-odor mean')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorrsub) ' p = ' num2str(FCpsub)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ChoiceInfoForcedInfoLeft_correlations']),'pdf');

%%
InfoForcedresp=mean(squeeze(mean(a.C_odor1FirstInfoForcedRight(:,44:64,:),3,'omitnan')),2,'omitnan');
InfoChoiceresp=mean(squeeze(mean(a.C_odor1FirstInfoChoiceRight(:,44:64,:),3,'omitnan')),2,'omitnan');

[FCcorr, FCp] = corr(InfoForcedresp,InfoChoiceresp);

InfoForcedrespsub=mean(squeeze(mean(a.C_odor1FirstInfoForcedRight(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstInfoForcedRight(:,30:40,:),3,'omitnan')),2,'omitnan');
InfoChoicerespsub=mean(squeeze(mean(a.C_odor1FirstInfoChoiceRight(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstInfoChoiceRight(:,30:40,:),3,'omitnan')),2,'omitnan');

[FCcorrsub, FCpsub] = corr(InfoForcedrespsub,InfoChoicerespsub);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,19)==1&~activeCellsRS(:,20)==1)={'Forced Sig'};
sig1(activeCellsRS(:,20)==1&~activeCellsRS(:,19)==1)={'Choice Sig'};
sig1(activeCellsRS(:,19)&activeCellsRS(:,20))={'Both Sig'};
% sig1(activeCellsRS(:,5)&activeCellsRS(:,6))={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
gscatter(InfoForcedresp,InfoChoiceresp,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(InfoForcedresp,InfoChoiceresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Forced Activity')
ylabel('Info Choice Activity')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorr) ' p = ' num2str(FCp)])

% sig1=cell(a.neuronCt,1);
% sig1(:)={'NS'};
% sig1(activeCellsRS(:,5)&activeCellsRS(:,6))={'Both Sig'};
% sig1(activeCellsRS(:,5)==1&~activeCellsRS(:,6)==1)={'Forced Sig'};
% sig1(activeCellsRS(:,6)==1&~activeCellsRS(:,5)==1)={'Choice Sig'};
ax1=nsubplot(1,2,1,2);
gscatter(InfoForcedrespsub,InfoChoicerespsub,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(InfoForcedrespsub,InfoChoicerespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Forced Activity - pre-odor mean')
ylabel('Info Choice Activity - pre-odor mean')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorrsub) ' p = ' num2str(FCpsub)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ChoiceInfoForcedInfoRight_correlations']),'pdf');

%% CHOICE FORCED INFO RAND CORRELATION

InfoForcedresp=mean(squeeze(mean(a.C_odor1FirstInfoForced(:,44:64,:),3,'omitnan')),2,'omitnan');
RandForcedresp=mean(squeeze(mean(a.C_odor1FirstRandForced(:,44:64,:),3,'omitnan')),2,'omitnan');

[FCcorr, FCp] = corr(InfoForcedresp,RandForcedresp);

InfoForcedrespsub=mean(squeeze(mean(a.C_odor1FirstInfoForced(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstInfoForced(:,30:40,:),3,'omitnan')),2,'omitnan');
RandForcedrespsub=mean(squeeze(mean(a.C_odor1FirstRandForced(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstRandForced(:,30:40,:),3,'omitnan')),2,'omitnan');

[FCcorrsub, FCpsub] = corr(InfoForcedrespsub,RandForcedrespsub);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,5)==1&~activeCellsRS(:,7)==1)={'Info Sig'};
sig1(activeCellsRS(:,7)==1&~activeCellsRS(:,5)==1)={'Rand Sig'};
sig1(activeCellsRS(:,5)&activeCellsRS(:,7))={'Both Sig'};
% sig1(activeCellsRS(:,5)&activeCellsRS(:,6))={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
gscatter(InfoForcedresp,RandForcedresp,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(InfoForcedresp,InfoChoiceresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Forced Activity')
ylabel('Rand Forced Activity')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorr) ' p = ' num2str(FCp)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,5)&activeCellsRS(:,7))={'Both Sig'};
sig1(activeCellsRS(:,5)==1&~activeCellsRS(:,7)==1)={'Info Sig'};
sig1(activeCellsRS(:,7)==1&~activeCellsRS(:,5)==1)={'Rand Sig'};
ax1=nsubplot(1,2,1,2);
gscatter(InfoForcedrespsub,RandForcedrespsub,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(InfoForcedrespsub,InfoChoicerespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Forced Activity - pre-odor mean')
ylabel('Rand Forced Activity - pre-odor mean')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorrsub) ' p = ' num2str(FCpsub)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ForcedInfoForcedRand_correlations']),'pdf');

%%
infoCells=differentCells(:,2)&InfoForcedrespsub>RandForcedrespsub;
randCells=differentCells(:,3)&RandForcedrespsub>InfoForcedrespsub;
figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,1,1,1);
bar([1 2],[sum(infoCells)/a.neuronCt sum(randCells)/a.neuronCt]);
xticks([1 2]);
xticklabels({'Info','NoInfo'});
ylabel('% of cells');
% xlim([0 15]);
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoRandCellsBar']),'pdf');

%% CHOICE FORCED RAND CORRELATION

RandForcedresp=mean(squeeze(mean(a.C_odor1FirstRandForced(:,44:64,:),3,'omitnan')),2,'omitnan');
InfoChoiceresp=mean(squeeze(mean(a.C_odor1FirstInfoChoice(:,44:64,:),3,'omitnan')),2,'omitnan');

[FCcorr, FCp] = corr(RandForcedresp,InfoChoiceresp);

RandForcedrespsub=mean(squeeze(mean(a.C_odor1FirstRandForced(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstRandForced(:,30:40,:),3,'omitnan')),2,'omitnan');
InfoChoicerespsub=mean(squeeze(mean(a.C_odor1FirstInfoChoice(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstInfoChoice(:,30:40,:),3,'omitnan')),2,'omitnan');

[FCcorrsub, FCpsub] = corr(RandForcedrespsub,InfoChoicerespsub);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,6)==1&~activeCellsRS(:,7)==1)={'Choice Info Sig'};
sig1(activeCellsRS(:,7)==1&~activeCellsRS(:,6)==1)={'Rand Forced Sig'};
sig1(activeCellsRS(:,7)&activeCellsRS(:,6))={'Both Sig'};
% sig1(activeCellsRS(:,5)&activeCellsRS(:,6))={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
gscatter(RandForcedresp,InfoChoiceresp,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(InfoForcedresp,InfoChoiceresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Rand Forced Activity')
ylabel('Info Choice Activity')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorr) ' p = ' num2str(FCp)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,7)&activeCellsRS(:,6))={'Both Sig'};
sig1(activeCellsRS(:,7)==1&~activeCellsRS(:,6)==1)={'Forced Sig'};
sig1(activeCellsRS(:,6)==1&~activeCellsRS(:,7)==1)={'Choice Sig'};
ax1=nsubplot(1,2,1,2);
gscatter(RandForcedrespsub,InfoChoicerespsub,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(InfoForcedrespsub,InfoChoicerespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Rand Forced Activity - pre-odor mean')
ylabel('Info Choice Activity - pre-odor mean')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorrsub) ' p = ' num2str(FCpsub)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoChoiceRandForced_correlations']),'pdf');


%% CHOICE FORCED CORRELATION

RandForcedresp=mean(squeeze(mean(a.C_odor1FirstRandForced(:,44:64,:),3,'omitnan')),2,'omitnan');
RandChoiceresp=mean(squeeze(mean(a.C_odor1FirstRandChoice(:,44:64,:),3,'omitnan')),2,'omitnan');

[FCcorr, FCp] = corr(RandForcedresp,RandChoiceresp);

RandForcedrespsub=mean(squeeze(mean(a.C_odor1FirstRandForced(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstRandForced(:,30:40,:),3,'omitnan')),2,'omitnan');
RandChoicerespsub=mean(squeeze(mean(a.C_odor1FirstRandChoice(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstRandChoice(:,30:40,:),3,'omitnan')),2,'omitnan');

[FCcorrsub, FCpsub] = corr(RandForcedrespsub,InfoChoicerespsub);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,7)==1&~activeCellsRS(:,8)==1)={'Rand Forced Sig'};
sig1(activeCellsRS(:,8)==1&~activeCellsRS(:,7)==1)={'Choice Info Sig'};
sig1(activeCellsRS(:,7)&activeCellsRS(:,8))={'Both Sig'};
% sig1(activeCellsRS(:,5)&activeCellsRS(:,6))={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
gscatter(RandForcedresp,RandChoiceresp,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(InfoForcedresp,InfoChoiceresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Rand Forced Activity')
ylabel('Rand Choice Activity')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorr) ' p = ' num2str(FCp)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,7)&activeCellsRS(:,8))={'Both Sig'};
sig1(activeCellsRS(:,7)==1&~activeCellsRS(:,8)==1)={'Forced Sig'};
sig1(activeCellsRS(:,8)==1&~activeCellsRS(:,7)==1)={'Choice Sig'};
ax1=nsubplot(1,2,1,2);
gscatter(RandForcedrespsub,RandChoicerespsub,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(InfoForcedrespsub,InfoChoicerespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Rand Forced Activity - pre-odor mean')
ylabel('Rand Choice Activity - pre-odor mean')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorrsub) ' p = ' num2str(FCpsub)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_RandChoiceRandForced_correlations']),'pdf');

%C_odor1InfoFirst

%% CHOICE FORCED CORRELATION

RandForcedresp=mean(squeeze(mean(a.C_odor1RandFirst(:,44:64,:),3,'omitnan')),2,'omitnan');
choiceresp=mean(squeeze(mean(a.C_odor1ChoiceFirst(:,44:64,:),3,'omitnan')),2,'omitnan');

[FCcorr, FCp] = corr(RandForcedresp,choiceresp);

RandForcedrespsub=mean(squeeze(mean(a.C_odor1RandFirst(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1RandFirst(:,30:40,:),3,'omitnan')),2,'omitnan');
choicerespsub=mean(squeeze(mean(a.C_odor1ChoiceFirst(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1ChoiceFirst(:,30:40,:),3,'omitnan')),2,'omitnan');

[FCcorrsub, FCpsub] = corr(RandForcedrespsub,choicerespsub);

% sig1=cell(a.neuronCt,1);
% sig1(:)={'NS'};
% sig1(activeCellsRS(:,7)==1&~activeCellsRS(:,8)==1)={'Rand Forced Sig'};
% sig1(activeCellsRS(:,8)==1&~activeCellsRS(:,7)==1)={'Choice Info Sig'};
% sig1(activeCellsRS(:,7)&activeCellsRS(:,8))={'Both Sig'};
% sig1(activeCellsRS(:,5)&activeCellsRS(:,6))={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
% gscatter(RandForcedresp,RandChoiceresp,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
scatter(RandForcedresp,choiceresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Rand Forced Activity')
ylabel('Choice Activity')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorr) ' p = ' num2str(FCp)])

% sig1=cell(a.neuronCt,1);
% sig1(:)={'NS'};
% sig1(activeCellsRS(:,7)&activeCellsRS(:,8))={'Both Sig'};
% sig1(activeCellsRS(:,7)==1&~activeCellsRS(:,8)==1)={'Forced Sig'};
% sig1(activeCellsRS(:,8)==1&~activeCellsRS(:,7)==1)={'Choice Sig'};
ax1=nsubplot(1,2,1,2);
% gscatter(RandForcedrespsub,RandChoicerespsub,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
scatter(RandForcedrespsub,choicerespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Rand Forced Activity - pre-odor mean')
ylabel('Choice Activity - pre-odor mean')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorrsub) ' p = ' num2str(FCpsub)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ChoiceAllRandForced_correlations']),'pdf');


InfoForcedresp=mean(squeeze(mean(a.C_odor1InfoFirst(:,44:64,:),3,'omitnan')),2,'omitnan');
choiceresp=mean(squeeze(mean(a.C_odor1ChoiceFirst(:,44:64,:),3,'omitnan')),2,'omitnan');

[FCcorr, FCp] = corr(InfoForcedresp,choiceresp);

InfoForcedrespsub=mean(squeeze(mean(a.C_odor1InfoFirst(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1InfoFirst(:,30:40,:),3,'omitnan')),2,'omitnan');
choicerespsub=mean(squeeze(mean(a.C_odor1ChoiceFirst(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1ChoiceFirst(:,30:40,:),3,'omitnan')),2,'omitnan');

[FCcorrsub, FCpsub] = corr(InfoForcedrespsub,choicerespsub);

% sig1=cell(a.neuronCt,1);
% sig1(:)={'NS'};
% sig1(activeCellsRS(:,7)==1&~activeCellsRS(:,8)==1)={'Rand Forced Sig'};
% sig1(activeCellsRS(:,8)==1&~activeCellsRS(:,7)==1)={'Choice Info Sig'};
% sig1(activeCellsRS(:,7)&activeCellsRS(:,8))={'Both Sig'};
% sig1(activeCellsRS(:,5)&activeCellsRS(:,6))={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
% gscatter(RandForcedresp,RandChoiceresp,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
scatter(InfoForcedresp,choiceresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Forced Activity')
ylabel('Choice Activity')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorr) ' p = ' num2str(FCp)])

% sig1=cell(a.neuronCt,1);
% sig1(:)={'NS'};
% sig1(activeCellsRS(:,7)&activeCellsRS(:,8))={'Both Sig'};
% sig1(activeCellsRS(:,7)==1&~activeCellsRS(:,8)==1)={'Forced Sig'};
% sig1(activeCellsRS(:,8)==1&~activeCellsRS(:,7)==1)={'Choice Sig'};
ax1=nsubplot(1,2,1,2);
% gscatter(RandForcedrespsub,RandChoicerespsub,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
scatter(InfoForcedrespsub,choicerespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Forced Activity - pre-odor mean')
ylabel('Choice Activity - pre-odor mean')
xlim([0 3])
ylim([0 3])
axis square
title(['Correlation = ' num2str(FCcorrsub) ' p = ' num2str(FCpsub)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ChoiceAllInfoForced_correlations']),'pdf');

%% INFO A CORRELATION
Aresp=mean(squeeze(mean(a.C_odor2A(:,44:64,:),3,'omitnan')),2,'omitnan');
Inforesp=mean(squeeze(mean(a.C_odor1FirstInfoForced(:,44:64,:),3,'omitnan')),2,'omitnan');

[InfoAcorr, InfoAp] = corr(Aresp,Inforesp);

Arespsub=mean(squeeze(mean(a.C_odor2A(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor2A(:,30:40,:),3,'omitnan')),2,'omitnan');
Inforespsub=mean(squeeze(mean(a.C_odor1FirstInfoForced(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstInfoForced(:,30:40,:),3,'omitnan')),2,'omitnan');
% InfoForcedrespsub=mean(squeeze(mean(a.C_odor1FirstInfoForced(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstInfoForced(:,30:40,:),3,'omitnan')),2,'omitnan');


[InfoAcorrsub, InfoApsub] = corr(Arespsub,Inforespsub);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,5)==1&~activeCellsRS(:,9)==1)={'Info Sig'};
sig1(activeCellsRS(:,9)==1&~activeCellsRS(:,5)==1)={'A Sig'};
sig1(activeCellsRS(:,5)&activeCellsRS(:,9))={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
gscatter(Inforesp,Aresp,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Aresp,Bresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Activity')
ylabel('Odor A Activity')
xlim([0 5])
ylim([0 5])
axis square
title(['Correlation = ' num2str(InfoAcorr) ' p = ' num2str(InfoAp)])

ax1=nsubplot(1,2,1,2);
gscatter(Inforespsub,Arespsub,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Inforespsub,Arespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Activity - pre-odor mean')
ylabel('Odor A Activity - pre-odor mean')
% xlim([0 5])
% ylim([0 5])
axis square
title(['Correlation = ' num2str(InfoAcorrsub) ' p = ' num2str(InfoApsub)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoA_correlations']),'pdf');

%% INFO CHOICE CROSS-SIDE CORRELATION
ChoiceRresp=mean(squeeze(mean(a.C_odor1FirstInfoChoiceRight(:,44:64,:),3,'omitnan')),2,'omitnan');
InfoLresp=mean(squeeze(mean(a.C_odor1FirstInfoForcedLeft(:,44:64,:),3,'omitnan')),2,'omitnan');

[InfoLChoiceRcorr, InfoLChoiceRp] = corr(ChoiceRresp,InfoLresp);

ChoiceRrespsub=mean(squeeze(mean(a.C_odor1FirstInfoChoiceRight(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor2A(:,30:40,:),3,'omitnan')),2,'omitnan');
InfoLrespsub=mean(squeeze(mean(a.C_odor1FirstInfoForcedLeft(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstInfoForced(:,30:40,:),3,'omitnan')),2,'omitnan');
% InfoForcedrespsub=mean(squeeze(mean(a.C_odor1FirstInfoForced(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstInfoForced(:,30:40,:),3,'omitnan')),2,'omitnan');


[InfoLChoiceRcorrsub, InfoLChoiceRpsub] = corr(ChoiceRrespsub,InfoLrespsub);

% sig1=cell(a.neuronCt,1);
% sig1(:)={'NS'};
% sig1(activeCellsRS(:,5)==1&~activeCellsRS(:,9)==1)={'Info Sig'};
% sig1(activeCellsRS(:,9)==1&~activeCellsRS(:,5)==1)={'A Sig'};
% sig1(activeCellsRS(:,5)&activeCellsRS(:,9))={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
scatter(InfoLresp,ChoiceRresp,20,'Filled');
% gscatter(InfoLresp,ChoiceRresp,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Aresp,Bresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Left Activity')
ylabel('Choice Right Activity')
xlim([0 5])
ylim([0 5])
axis square
title(['Correlation = ' num2str(InfoLChoiceRcorr) ' p = ' num2str(InfoLChoiceRp)])

ax1=nsubplot(1,2,1,2);
scatter(InfoLrespsub,ChoiceRrespsub,20,'Filled');
% gscatter(Inforespsub,Arespsub,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Inforespsub,Arespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Left Activity - pre-odor mean')
ylabel('Choice Right Activity - pre-odor mean')
% xlim([0 5])
% ylim([0 5])
axis square
title(['Correlation = ' num2str(InfoLChoiceRcorrsub) ' p = ' num2str(InfoLChoiceRpsub)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoLChoiceR_correlations']),'pdf');


%% DECODING FOR EACH COMP

%% LEAVING

%% CONDITIONS
% 
% y1=mean(a.C_odor1FirstInfoForced{1},3,'omitnan');
% size(y1)
% y2=mean(a.C_odor1FirstRandForced{1},3,'omitnan');
% y1mean=mean(y1,1);
% y2mean=mean(y2,1);
% ydiff=abs(y1-y2);
% size(ydiff)
% cond1=mean(ydiff,1);
% y1=mean(a.C_odor1FirstInfoForced{2},3,'omitnan');
% y2=mean(a.C_odor1FirstRandForced{2},3,'omitnan');
% ydiff=abs(y1-y2);
% cond2=mean(ydiff,1);
% figure();hold on; plot(cond1);
% plot(cond2)

%% PC PROJECTION

rI=mean(a.C_odor1FirstInfoForced(:,iStart:iStop,:),3,'omitnan');
rN=mean(a.C_odor1FirstRandForced(:,iStart:iStop,:),3,'omitnan');
rI=rI-rI(:,1);
rN=rN-rN(:,1);

rIN = rI-rN;
[UIN SIN VIN] = svd(rIN);
LIN = diag(SIN).^2;
LIN = 100*LIN/sum(LIN);

rI=mean(a.C_odor1FirstInfoForced,3,'omitnan');
rN=mean(a.C_odor1FirstRandForced,3,'omitnan');
rI=rI-mean(rI(:,30:40),2);
rN=rN-mean(rN(:,30:40),2);

yMax = [5];
yMin = [-5];

e=6;

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 8.5 11];
set(fig,'PaperOrientation','portrait');
set(fig,'renderer','painters');

ax = nsubplot(1,1,1,1);
hold on;
h_for_legend=[];

for t=1:size(a.C_odor1FirstInfoForced,3)
   tI=a.C_odor1FirstInfoForced(:,:,t);
   tI=tI-mean(tI(:,30:40),2);
   plot(a.t{e},UIN(:,1)'*tI,'Color','b','Linewidth',0.2)
   tN=a.C_odor1FirstRandForced(:,:,t);
   tN=tN-mean(tN(:,30:40),2);
   plot(a.t{e},UIN(:,1)'*tN,'Color','r','Linewidth',0.2)
end
h_for_legend(end+1)=plot(a.t{e},UIN(:,1)'*rI,'Color','b','linewidth',6);
h_for_legend(end+1)=plot(a.t{e},UIN(:,1)'*rN,'Color','r','linewidth',6);
plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
plot([0+PID 0+PID],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');

xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% plot([0.075 0.075], ylim, '--r');
xlim([-0.5+PID 2])

hold off;
% xlim([-0.2 1.4]);
% ylim([yMin(1) yMax(1)]);
xlabel('Seconds since odor on')
ylabel('PC1 Projection')
% title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
legend(h_for_legend,'Info','No Info','location','northwest');
% axis square;
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96,[strjoin(mice,' _ ')],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% 
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PCprojection_INFO']),'pdf');

% ax = gca;
exportgraphics(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PCprojection2_INFO.pdf']),'ContentType','vector')


%% PC PROJECTION

rAB=mean(a.C_odor2info(:,iStart:iStop,:),3,'omitnan');
rCD=mean(a.C_odor2rand(:,iStart:iStop,:),3,'omitnan');
% rAB=rAB-rAB(:,1);
% rCD=rCD-rCD(:,1);

rABCD = rAB-rCD;
[UABCD SABCD VABCD] = svd(rABCD);
LABCD = diag(SABCD).^2;
LABCD = 100*LABCD/sum(LABCD);

rAB=mean(a.C_odor2info,3,'omitnan');
rCD=mean(a.C_odor2rand,3,'omitnan');
% rAB=rAB-mean(rAB(:,30:40),2);
% rCD=rCD-mean(rCD(:,30:40),2);

yMax = [5];
yMin = [-5];

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 8.5 11];
set(fig,'PaperOrientation','portrait');
set(fig,'renderer','painters');

ax = nsubplot(1,1,1,1);
hold on;
h_for_legend=[];

for t=1:size(a.C_odor2info,3)
   tI=a.C_odor2info(:,:,t);
%    tI=tI-mean(tI(:,30:40),2);
   plot(a.t{e},UABCD(:,1)'*tI,'Color','b','Linewidth',0.2)
   tN=a.C_odor2rand(:,:,t);
%    tN=tN-mean(tN(:,30:40),2);
   plot(a.t{e},UABCD(:,1)'*tN,'Color','r','Linewidth',0.2)
end
h_for_legend(end+1)=plot(a.t{e},UABCD(:,1)'*rAB,'Color','b','linewidth',6);
h_for_legend(end+1)=plot(a.t{e},UABCD(:,1)'*rCD,'Color','r','linewidth',6);
plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
plot([0+PID 0+PID],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');

xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% plot([0.075 0.075], ylim, '--r');
xlim([-0.5+PID 2])
% ylim([yMin(1) yMax(1)]);
xlabel('Seconds since odor on')
ylabel('PC1 Projection')
% title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
legend(h_for_legend,'AB','CD','location','northwest');
% axis square;
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96,[strjoin(mice,' _ ')],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% 
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PCprojection_ABCD']),'pdf');

% ax = gca;
exportgraphics(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PCprojection2_ABCD.pdf']),'ContentType','vector')

%%
figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 8.5 11];
set(fig,'PaperOrientation','portrait');
set(fig,'renderer','painters');

ax = nsubplot(1,1,1,1);
hold on;
h_for_legend=[];

for t=1:size(a.C_odor2info,3)
   tI=a.C_odor2info(:,:,t);
%    tI=tI-mean(tI(:,30:40),2);
   plot(a.t{e},UIN(:,1)'*tI,'Color','b','Linewidth',0.2)
   tN=a.C_odor2rand(:,:,t);
%    tN=tN-mean(tN(:,30:40),2);
   plot(a.t{e},UIN(:,1)'*tN,'Color','r','Linewidth',0.2)
end
h_for_legend(end+1)=plot(a.t{e},UIN(:,1)'*rAB,'Color','b','linewidth',6);
h_for_legend(end+1)=plot(a.t{e},UIN(:,1)'*rCD,'Color','r','linewidth',6);
plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
plot([0+PID 0+PID],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
plot([0.2+PID 0.2+PID],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');

xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
xticks2 = xticks2 + PID;
xticks(xticks2);
xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
set(gca, 'XTickLabel', xticklabels2);
% plot([0.075 0.075], ylim, '--r');
xlim([-0.5+PID 2])
% ylim([yMin(1) yMax(1)]);
xlabel('Seconds since odor on')
ylabel('PC1 Projection')
% title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
legend(h_for_legend,'AB','CD','location','northwest');
% axis square;
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96,[strjoin(mice,' _ ')],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% 
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PCprojection_ABCD_UIN']),'pdf');

% ax = gca;
exportgraphics(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PCprojection2_ABCD_UIN.pdf']),'ContentType','vector')

%% WHOLE TRIAL HEATMAPS

cell_sort_ids=INdiffIdx;
% cell_sort_ids=WNdiffSort;
e=11;
cd = 1;
cutoff=13;
ctitle = a.titles{1};
clabels = {'Info Water','Info No Water','No Info Water','No Info No Water'};
cnames = {'C_trialInfoForcedBig','C_trialInfoForcedSmall','C_trialRandForcedBig','C_trialRandForcedSmall'};

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
    set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

for cd=1:2
    ax = nsubplot(1,6,1,cd);
    cname=cnames{cd};
    y=mean(a.(cname),3,'omitnan');
    t=a.t{e};
    imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
%     colorcet('D1');
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
    plot([1.45 1.45],[-1 +1].*10^10,'w','yliminclude','off');
    plot([1.65 1.65],[-1 +1].*10^10,'w','yliminclude','off');
    plot([11.65 11.65],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
        ax.YAxis.Visible = 'off';
%         end
    xlim([-0.5 cutoff]);
    xlabel('Seconds');
    title(clabels(cd));
    xticks([0:2:cutoff]); 
    ax.FontSize = 8; 
end

ax = nsubplot(1,6,1,3);
y1=mean(a.C_trialInfoForcedSmall,3,'omitnan');
y2=mean(a.C_trialInfoForcedBig,3,'omitnan');
y=y2-y1;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),diff_limits);
% colorcet('D1');
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'w','yliminclude','off');
plot([1.65 1.65],[-1 +1].*10^10,'w','yliminclude','off');
plot([11.65 11.65],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
    ax.YAxis.Visible = 'off';
%         end
xlim([-0.5 cutoff]);
xlabel('Seconds');
title('Info Water-Info No Water');
xticks([0:2:cutoff]); 
ax.FontSize = 8;         

for cd=3:4
    ax = nsubplot(1,6,1,cd+1);
    cname=cnames{cd};
    y=mean(a.(cname),3,'omitnan');
    t=a.t{e};
    imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
%     colorcet('D1');
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
    plot([1.45 1.45],[-1 +1].*10^10,'w','yliminclude','off');
    plot([1.65 1.65],[-1 +1].*10^10,'w','yliminclude','off');
    plot([11.65 11.65],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
        ax.YAxis.Visible = 'off';
%         end
   xlim([-0.5 cutoff]);
    xlabel('Seconds');
    title(clabels(cd));
    xticks([0:2:cutoff]); 
    ax.FontSize = 8; 
end

ax = nsubplot(1,6,1,6);
y1=mean(a.C_trialRandForcedSmall,3,'omitnan');
y2=mean(a.C_trialRandForcedBig,3,'omitnan');
y=y2-y1;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
% colorcet('D1');
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'w','yliminclude','off');
plot([1.65 1.65],[-1 +1].*10^10,'w','yliminclude','off');
plot([11.65 11.65],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
    ax.YAxis.Visible = 'off';
%         end
xlim([-0.5 cutoff]);
xlabel('Seconds');
title('No Info Water-No Info NoWater');
xticks([0:2:cutoff]); 
ax.FontSize = 8;

if RA==1
colormap(a.ckr);
else
colorcet('D1')
end

hold off;   
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.98,[strjoin(mice,' _ '),' Conditional Activity, sort by Info-No Info'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ConditionalActivity_Trial_byinfo-noinfo']),'pdf');