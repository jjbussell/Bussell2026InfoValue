%% InfoseekNeuralPlots

%% PARAMETERS/LABELS

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


%% TRIAL CODING INDEX - RUN IF FULL-TRIAL MEASURES COMPUTED
% 
% % INFO
% 
% t=a.t{11};
% color_limitsEBM=[-1 1];
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% ax=nsubplot(1,1,1,1);
% y=a.activityDifferenceTrialEBM{1};
% % ytosort=mean(y(
% [~, maxIndices] = max(y(:,364:640), [], 2);
% [~, cell_sort_ids] = sort(maxIndices);
% imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limitsEBM);
% colorcet('D1');
% colorbar()
% plot([0+PID 0+PID],[-1 +1].*10^10,'k','yliminclude','off');
% plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'k','yliminclude','off');
% axis tight;
% % ax.YAxis.Visible = 'off';
% xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% xticks2 = xticks2 + PID;
% xticks(xticks2);
% xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% set(gca, 'XTickLabel', xticklabels2);
% xlim([-1 14]);
% xlabel('Seconds');
% ylabel('Cells');
% title('Info-No Info Coding Index (sort)');
% ax.FontSize = 8;
% set(ax, 'Ydir', 'reverse')
% saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_heatmapInfoandWaterCodingIdxbyinfo1']),'pdf');
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% ax=nsubplot(1,1,1,1);
% y=a.activityDifferenceTrialEBM{2};
% % [~, maxIndices] = max(y, [], 2);
% % [~, cell_sort_ids] = sort(maxIndices);
% imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limitsEBM);
% colorcet('D1');
% colorbar()
% plot([0+PID 0+PID],[-1 +1].*10^10,'k','yliminclude','off');
% plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'k','yliminclude','off');
% axis tight;
% xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% xticks2 = xticks2 + PID;
% xticks(xticks2);
% xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% set(gca, 'XTickLabel', xticklabels2);
% % ax.YAxis.Visible = 'off';
% xlim([-1 14]);
% xlabel('Seconds');
% ylabel('Cells');
% title('Water Big-Small Coding Index, sort info');
% % xticks([-2:0.2:2]); 
% ax.FontSize = 8;
% set(ax, 'Ydir', 'reverse')
% saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_heatmapInfoandWaterCodingIdxbyinfo2']),'pdf');
% 
% % Water
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% ax=nsubplot(1,1,1,1);
% y=a.activityDifferenceTrialEBM{2};
% [~, maxIndices] = max(y(:,392:640), [], 2);
% [~, cell_sort_ids] = sort(maxIndices);
% imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limitsEBM);
% colorcet('D1');
% colorbar()
% plot([0+PID 0+PID],[-1 +1].*10^10,'k','yliminclude','off');
% plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'k','yliminclude','off');
% axis tight;
% xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% xticks2 = xticks2 + PID;
% xticks(xticks2);
% xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% set(gca, 'XTickLabel', xticklabels2);
% % ax.YAxis.Visible = 'off';
% xlim([-1 14]);
% xlabel('Seconds');
% ylabel('Cells');
% title('Water Big-Small Coding Index (sort)');
% ax.FontSize = 8;
% set(ax, 'Ydir', 'reverse')
% saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_heatmapInfoandWaterCodingIdxbyWater1']),'pdf');
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% ax=nsubplot(1,1,1,1);
% y=a.activityDifferenceTrialEBM{1};
% % [~, maxIndices] = max(y, [], 2);
% % [~, cell_sort_ids] = sort(maxIndices);
% imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limitsEBM);
% colorcet('D1');
% colorbar()
% plot([0+PID 0+PID],[-1 +1].*10^10,'k','yliminclude','off');
% plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'k','yliminclude','off');
% plot([11.45 11.45],[-1 +1].*10^10,'k','yliminclude','off');
% axis tight;
% xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% xticks2 = xticks2 + PID;
% xticks(xticks2);
% xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% set(gca, 'XTickLabel', xticklabels2);
% % ax.YAxis.Visible = 'off';
% xlim([-1 14]);
% xlabel('Seconds');
% ylabel('Cells');
% title('Info-No Info Coding Index sort water');
% % xticks([-2:0.2:2]); 
% ax.FontSize = 8;
% set(ax, 'Ydir', 'reverse')
% saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_heatmapInfoandWaterCodingIdxbyWater2']),'pdf');
%

% FULL TRIAL ACTIVITY DIFFERENCE PLOT
% a.trialColors = {a.purple,'b','g',a.orange,'c','r'};
% cebrastart=320;
% cebrastop=640;
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 11 8.5];
% %     set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% width = 1;
% 
% e=11;
% hold on;
% 
% nsubplot(1,1,1,1);
% h_for_legend=[];
% for cd=1:numel(a.trialCompNames)
%     curcolor=a.trialColors{cd};
% 
%     ypop=a.activityDifferenceTrialEBM{cd};
%     ymean=mean(ypop);
%     ysem = nanstd(ypop,[],1) ./ sqrt(size(ypop,1));
%     t=a.t{e}(cebrastart:cebrastop);
%     ymean=ymean(cebrastart:cebrastop);
%     ysem=ysem(cebrastart:cebrastop);
%       h = fill([t, fliplr(t)], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
%     set(h, 'FaceAlpha', 0.1);
%     h_for_legend(end+1)=plot(t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
% end
% plot([0+PID 0+PID],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
% plot([1.2 1.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
% plot([1.65 1.65],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
% plot([2.65 2.65],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
% plot([12.85 12.85],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
% plot([11.85 11.85],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
% plot([0+PID 0+PID],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([1.45+PID 1.45+PID],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot([11.65 11.65],[-1 +1].*10^10,'color','k','yliminclude','off');
% xticks([-1:1:14])
% xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
% xticks2 = xticks2 + PID;
% xticks(xticks2);
% xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
% set(gca, 'XTickLabel', xticklabels2);
% set(gca,'fontsize',8);
% setlim('ylim','tight');
% xlim([-1 14])
% hold off;
% %     end
% %     axis square
% ylabel('Calcium activity');
% xlabel('Time from Odor 1 Onset (s)');
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% leg = legend(h_for_legend,{'Info v No Info','Water all v No Water all','A v B','C v D','No Info Water v None','Left v Right'},'Orientation','horizontal','Location','southoutside','Box','off');
% 
% % text(0.51, 0.98,[strjoin(mice,' _ '),' Response Power First Center Entry'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');
% % 
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_TrialMeanActivityDiffEBM']),'pdf');

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

%% CENTER AND SIDE ODOR HEATMAPS EBM

% INFO AND AB HEATMAPS BY INFO DIFF

color_limitsEBM=[-0.8 0.8];

e=6;
cd = 1;
figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
    set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

y_A=mean(a.C_odor2A,3,'omitnan');
y_A=y_A-mean(y_A(:,30:40),2);
y_B=mean(a.C_odor2B,3,'omitnan');
y_B=y_B-mean(y_B(:,30:40),2);
[~,ABdiffSort] = sort(mean(y_A(:,40:60),2)-mean(y_B(:,40:60),2),'descend');
% cell_sort_ids=isASort;
% cell_sort_ids=infoIdx;
cell_sort_ids = ABdiffSort;
% [~,cell_sort_ids] = sort(y_info,'descend');



ax = nsubplot(1,7,1,1);
y=a.activityDifferenceEBM{2};
[~, maxIndices] = max(y(:,48:end), [], 2);
[~, cell_sort_ids] = sort(maxIndices);
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limitsEBM);
% colorcet('D1');
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'w','yliminclude','off');
plot([1.65 1.65],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
    ax.YAxis.Visible = 'off';
%         end
xlim([-0.2 1]);
xlabel('Seconds');
title('Info-No Info');
xticks([-2:0.2:1.45]); 
ax.FontSize = 8;         


ax = nsubplot(1,7,1,2);
y=a.activityDifferenceEBM{3};
% [~, maxIndices] = max(y(:,48:end), [], 2);
% [~, cell_sort_ids] = sort(maxIndices);
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limitsEBM);
colorcet('D1');
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'k','yliminclude','off');
% plot([1.65 1.65],[-1 +1].*10^10,'k','yliminclude','off');
axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
    ax.YAxis.Visible = 'off';
%         end
xlim([-0.2 1]);
xlabel('Seconds');
title('A-B');
xticks([-2:0.2:1.45]); 
ax.FontSize = 8; 


if RA==1
colormap(a.ckr);
else
colorcet('D1')
end

hold off;   
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.98,[strjoin(mice,' _ '),' Conditional Activity, sort by A-B'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ConditionalActivity_CenterSideCSIdxEBM_byInfoIdx']),'pdf');

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

%% INFORMATION CODING BY MOVEMENT, ENTRY/EXIT

e=3;
t=a.t{e};
t2=t+PID-0.2;

y1=a.activityTimeDiffCenterExit;
y1mean = nanmean(y1,1);
y1mean=y1mean-mean(y1mean(1:10));
y1sem = nanstd(y1,[],1) ./ sqrt(size(y1,1));

y2=a.activityDifferenceEBM{2};
y2mean = nanmean(y2,1);
y2mean=y2mean-mean(y2mean(1:10));
y2sem = nanstd(y2,[],1) ./ sqrt(size(y2,1));

y3=a.activityTimeDiffSideEntry;
y3mean = nanmean(y3,1);
y3mean=y3mean-mean(y3mean(1:10));
y3sem = nanstd(y3,[],1) ./ sqrt(size(y3,1));

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

h_for_legend=[];
ax=nsubplot(1,2,1,1);
h = fill([t, fliplr(t)], [y1mean-y1sem, fliplr(y1mean+ y1sem)], 'r','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(ax,t,y1mean,'color','r','linewidth',2);

h = fill([t2, fliplr(t2)], [y2mean-y2sem, fliplr(y2mean+ y2sem)], 'k','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(ax,t2,y2mean,'color','k','linewidth',2);

h = fill([t, fliplr(t)], [y3mean-y3sem, fliplr(y3mean+ y3sem)], 'b','EdgeColor','none');
set(h, 'FaceAlpha', 0.1);
h_for_legend(end+1)=plot(ax,t,y3mean,'color','b','linewidth',2);

xlim(t([1 end]));
plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');    
if cd==1
    ylabel({'Response Power'; 'Mean calcium activity of active cells'},'FontWeight','bold');
end
set(gca,'fontsize',8);
leg = legend(h_for_legend,{'Center Exit','Center Odor','Side Entry'},'Orientation','vertical','Location','northwest','Box','off');
leg.FontSize = 6;
title('Info Forced - No Info Forced');
xlim([-0.5 1.2]);
xticks([-2:0.2:2]);
ylim([-0.05 0.15]);
xlabel('Time (seconds)');
ylabel('Mean absolute difference in activity');
hold off;
axis square;

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_CenterPortMovementActivity']),'pdf');

%% CORRELATE RT with CENTER ODOR ACTIVITY

y1=a.C_odor1FirstInfoForced;
e=3;
ypost1 = squeeze(mean(y1(:,a.okt{e},:),2,'omitnan'));
yactI=[];
y2=a.C_odor1FirstRandForced;
ypost2 = squeeze(mean(y2(:,a.okt{e},:),2,'omitnan'));
yactNI=[];
for m=1:max(a.mouse)
%    ym1=ypost1(a.mouse==m,:);
   ym1=mean(ypost1(a.mouse==m & a.differentCellsEBM(:,12)==1 ,:));
   ym1=ym1(~isnan(ym1))';
   yactI=[yactI; ym1];
%    ym2=ypost2(a.mouse==m,:);
%    ym2=ypost2(a.mouse==m,:);
   ym2=mean(ypost2(a.mouse==m & a.differentCellsEBM(:,12)==1,:));
   ym2=ym2(~isnan(ym2))';
   yactNI=[yactNI; ym2];   
end

[r2I,pI]=corr(yactI,a.rxn(a.imagingChoice==1 & a.imagingPrevCorrect == 1))
[r2NI,pNI]=corr(yactNI,a.rxn(a.imagingChoice==3 & a.imagingPrevCorrect == 1))

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
scatter(a.rxn(a.imagingChoice==1 & a.imagingPrevCorrect == 1),yactI)
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Reaction Time')
ylabel('Mean Population Activity for Info Coding Cells')
xlim([0.2 1.5])
ylim([0 2])
axis square
title(['Information Forced, Correlation = ' num2str(r2I) ' p = ' num2str(pI)])

ax1=nsubplot(1,2,1,2);
scatter(a.rxn(a.imagingChoice==3 & a.imagingPrevCorrect == 1),yactNI)
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Reaction Time')
ylabel('Mean Population Activity  for Info Coding Cells')
xlim([0.2 1.5])
ylim([0 2])
axis square

title(['No Information Forced, Correlation = ' num2str(r2NI) ' p = ' num2str(pNI)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_RxnCorrelationInfoCells']),'pdf');


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


%% INFO CS US VENN BY CODING IDX

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


%% CORRELATIONS

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

%% INFO US VS WATER US

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
ax1=nsubplot(1,1,1,1);
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

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ActivityCorrelationsUS_EBMPrePost']),'pdf');


%% CORRELATION BETWEEN ODOR A AND ODOR B RESPONSES

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

ax1=nsubplot(1,1,1,1);
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


%% CHOICE FORCED CORRELATION

InfoForcedrespsub=mean(squeeze(mean(a.C_odor1FirstInfoForced(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstInfoForced(:,30:40,:),3,'omitnan')),2,'omitnan');
InfoChoicerespsub=mean(squeeze(mean(a.C_odor1FirstInfoChoice(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1FirstInfoChoice(:,30:40,:),3,'omitnan')),2,'omitnan');

[FCcorrsub, FCpsub] = corr(InfoForcedrespsub,InfoChoicerespsub);

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,5)&activeCellsRS(:,6))={'Both Sig'};
sig1(activeCellsRS(:,5)==1&~activeCellsRS(:,6)==1)={'Forced Sig'};
sig1(activeCellsRS(:,6)==1&~activeCellsRS(:,5)==1)={'Choice Sig'};
ax1=nsubplot(1,1,1,1);
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


%% PC PROJECTION

iStart = 40;
iStop = 56;

rI=mean(a.C_odor1FirstInfoForced(:,iStart:iStop,:),3,'omitnan');
rN=mean(a.C_odor1FirstRandForced(:,iStart:iStop,:),3,'omitnan');
rI=rI-rI(:,1);
rN=rN-rN(:,1);

rIN = rI-rN;
[UIN SIN VIN] = svd(rIN);
LIN = diag(SIN).^2;
LIN = 100*LIN/sum(LIN); % VARIANCE EXPLAINED BY PRINCIPLE COMPONENTS OF INFO-NO INFO

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


