%% Plots for single cells

sorting = 1;

set(0,'DefaultFigureWindowStyle','docked')

output_dir=plotfolder;
pathname=output_dir;
cellpath = fullfile(pathname,'Cells');
if ~isdir(cellpath)
mkdir(cellpath);
end

% weightsSorted = [UINSort ULRSort];
% cellsByWeights = [iINSort iLRSort];
diffsSorted = ASort;
cellsByDiff=iASort;
weightsSorted=UINSort;
cellsByWeights=iINSort;
pvals=pNeurons(iASort);
idx=cellsByWeights;

y_info=mean(a.C_odor1FirstInfoForced,3,'omitnan');
y_info=y_info-mean(y_info(:,30:40),2);
y_rand=mean(a.C_odor1FirstRandForced,3,'omitnan');
y_rand=y_rand-mean(y_rand(:,30:40),2);
[~,INdiffIdx] = sort(mean(y_info(:,40:60),2)-mean(y_rand(:,40:60),2),'descend');

idx=INdiffIdx;

%%

% a.names = {{'C_odor1InfoForced','C_odor1InfoChoice',...
%     'C_odor1RandForced','C_odor1RandChoice'};...
%     {'C_odor2A','C_odor2B','C_odor2C','C_odor2D'};... 
%     {'C_outcomeInfoBig','C_outcomeInfoSmall','C_outcomeRandBig',...
%     'C_outcomeRandSmall'}};
% a.nameEvents = [3,6,7];
a.nameEventsFirst = [9,9,6,7];
a.titles = {'Center Odor Side','Center Odor Info',...
    'Side Odor','Outcome'};
a.labels = {{'Center Odor Info Left','Center Odor Info Right','Center Odor No Info Left','Center Odor No Info Right'};...
    {'Center Odor Info Forced','Center Odor Info Choice','Center Odor No Info Forced','Center Odor No Info Choice'};...
    {'Side Odor A Info Water','Side Odor B Info No Water','Side Odor No Info C','Side Odor No Info D'};...
    {'Outcome Info Water','Outcome Info No Water','Outcome Rand Water','Outcome Rand No Water'}};
a.conditionLabels = {{'Info Left','Info Right','No Info Left','No Info Right'};...
    {'Info Forced','Info Choice','No Info Forced','No Info Choice'};...
    {'A Info Water','B Info No Water','No Info C','No Info D'};...
    {'Info Water','Info No Water','Rand Water','Rand No Water'}};
a.colors = {{a.purple,a.lightPurple,a.orange,a.lightOrange};{a.purple,a.lightPurple,a.orange,a.lightOrange};...
    {'g','m',a.cornflower,a.cornflower};...
    {'g','m','b','c'}};
a.namesFirst = {{'C_odor1FirstInfoLeft','C_odor1FirstInfoRight',...
    'C_odor1FirstRandLeft','C_odor1FirstRandRight'};
    {'C_odor1FirstInfoForced','C_odor1FirstInfoChoice',...
    'C_odor1FirstRandForced','C_odor1FirstRandRight'};...
    {'C_odor2A','C_odor2B','C_odor2C','C_odor2D'};... 
    {'C_outcomeInfoBig','C_outcomeInfoSmall','C_outcomeRandBig',...
    'C_outcomeRandSmall'}};
a.namesOnly = {{'C_odor1OnlyInfoForced','C_odor1OnlyInfoChoice',...
    'C_odor1OnlyRandForced','C_odor1OnlyRandChoice'};...
    {'C_odor2A','C_odor2B','C_odor2C','C_odor2D'};... 
    {'C_outcomeInfoBig','C_outcomeInfoSmall','C_outcomeRandBig',...
    'C_outcomeRandSmall'}};
% a.namesAll = {{'C_odor1AllInfoForced','C_odor1AllInfoChoice',...
%     'C_odor1AllRandForced','C_odor1AllRandChoice'};...
%     {'C_odor2A','C_odor2B','C_odor2C','C_odor2D'};... 
%     {'C_outcomeInfoBig','C_outcomeInfoSmall','C_outcomeRandBig',...
%     'C_outcomeRandSmall'}};
a.namesExit = {{'C_centerExitInfoForced','C_centerExitInfoChoice',...
    'C_centerExitRandForced','C_centerExitRandChoice'};...
    {'C_sideEntryInfoForced','C_sideEntryInfoChoice',...
    'C_sideEntryRandForced','C_sideEntryRandChoice'}};
a.exitEvents = [4,5];
a.exitTitles = {'Center Exit','Side Entry'};
a.exitLabels={{'Center Exit Info Forced','Center Exit Info Choice',...
    'Center Exit No Info Forced','Center Exit No Info Choice'},...
    {'Side Entry Info Forced','Side Entry Info Choice','Side Entry No Info Forced',...
    'Side Entry No Info Choice'}};

% a.wholeTrialNames = {'C_trialInfoForcedBig','C_trialInfoForcedSmall','C_trialInfoChoiceBig'...
%     'C_trialInfoChoiceSmall','C_trialRandForcedBig','C_trialRandForcedSmall',...
%     'C_trialRandChoiceBig','C_trialRandChoiceSmall'};
% a.wholeTrialLabels = {'InfoForced - Water','InfoForced - No Water','InfoChoice - Water',...
%     'InfoChoice - No Water','NoInfoForced - Water','NoInfoForced - No Water',...
%     'NoInfoChoice - Water','NoInfoChoice - No Water'};
% 
% a.wholeNames = {'C_InfoForcedBig','C_InfoForcedSmall','C_InfoChoiceBig'...
%     'C_InfoChoiceSmall','C_RandForcedBig','C_RandForcedSmall',...
%     'C_RandChoiceBig','C_RandChoiceSmall'};
% a.wholeLabels = {'InfoForced - Water','InfoForced - No Water','InfoChoice - Water',...
%     'InfoChoice - No Water','NoInfoForced - Water','NoInfoForced - No Water',...
%     'NoInfoChoice - Water','NoInfoChoice - No Water'};

a.legendnames = {'Info Forced','Info Choice','No Info Forced','No Info Choice','Info Water','Info No Water','No Info C','No Info D','No Info Water','No Info No Water'};
a.legendcolors = {a.purple,a.lightPurple,a.orange,a.lightOrange,'g','m',a.cornflower,a.cornflower,'b','c'};
a.allNames = {'C_odor1FirstInfoForced','C_odor1FirstInfoChoice',...
    'C_odor1FirstRandForced','C_odor1FirstRandChoice','C_odor2A','C_odor2B',...
    'C_odor2C','C_odor2D','C_outcomeInfoBig','C_outcomeInfoSmall',...
    'C_outcomeRandBig','C_outcomeRandSmall'};
a.allLabels = {{'Center Odor','Info Forced'},{'Center Odor', 'Info Choice'},...
    {'Center Odor', 'No Info Forced'},{'Center Odor' 'No Info Choice'},...
    {'Side Odor', 'A Info Water'},{'Side Odor', 'B Info No Water'},{'Side Odor', 'No Info C'},...
    {'Side Odor', 'No Info D'},{'Outcome', 'Info Water'},{'Outcome', 'Info No Water'},...
    {'Outcome', 'Rand Water'},{'Outcome', 'Rand No Water'}};
a.allEvents = [3,3,3,3,6,6,6,6,7,7,7,7];

% a.compNames = {{'C_odor1Info','C_odor1Rand'};...
%     {'C_odor2A','C_odor2B'};{'C_odor2C','C_odor2D'};...
%     {'C_odor2info','C_odor2rand'};
%     {'C_outcomeInfoBig','C_outcomeInfoSmall'};{'C_outcomeRandBig',...
%     'C_outcomeRandSmall'}};
% a.compNamesFirst = {{'C_odor1FirstInfoLeft','C_odor1FirstRandLeft'};{'C_odor1FirstInfoRight','C_odor1FirstRandRight'};{'C_odor1InfoFirst','C_odor1RandFirst'};...
%     {'C_odor2A','C_odor2B'};{'C_odor2C','C_odor2D'};...
%     {'C_odor2info','C_odor2rand'};
%     {'C_outcomeInfoBig','C_outcomeInfoSmall'};{'C_outcomeRandBig',...
%     'C_outcomeRandSmall'}};
a.compEvents = [3,6,6,6,7,7];
a.compEventsFirst = [9,9,9,6,6,6,7,7];
a.compOrder = {{1,2},{3},{4,5,6},{5,6}};
a.compTitles = {'Center Odor','Center Odor','Side Odor','Outcome'};
a.compLabels = {'Info Left - No Info Left';'Info Right - No Info Right';'Info Forced - No Info Forced';...
    'Info Water - Info No Water';'No Info C - No Info D';'Info - No Info';...                                                   
    'Info Water - Info No Water';'No Info Water - No Info No Water'};
a.compLabels4 = {
    {'Center Odor:\newlineInfo Forced - No Info Forced'},{'Center Odor Early:\newlineInfo Forced - No Info Forced'},...
    {'Center Odor Late:\newlineInfo Forced - No Info Forced'},{'Side Odor Info:\newlineA - B'},...
    {'Side Odor No Info:\newlineC - D'},    {'Side Odor:\newlineInfo - No Info'},...
    {'Outcome Info:\newlineWater - No Waterl'},...
    {'Outcome No Info:\newlineWater - No Water'}};

ccolor = a.colors{1,1};
color_limits=[-2 2];

%% CELL SUMMARIES (between conditions) - needs ROCs, abs difference, stats

% 
% % uu = a.neuronCt-1;
% uu=1;
% % idx = flip(a.ROCidx);
% % idx = flip(a.respIdx);
% 
% % for uu = 1:a.neuronCt
% 
%     u = idx(uu);
% 
%     figure();
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0 0 8.5 11];
%     %     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','portrait');
% 
%     toPlot = 5;
%     width = 1;
%     color_limits = [-2 2];
%     ax1=[];ax2=[];ax3=[];ax4=[];ax5=[];ax6=[];ax9=[];
% 
%     % 1st row: mean conditional activity  
%     for cd = 1:numel(a.namesFirst)
%         e = a.nameEventsFirst(cd);
% 
%         cname = a.namesFirst{cd,1};
%         clabel = a.labels{cd,1};
%         ccolor = a.colors{cd,1};
%         ctitle = a.titles{cd};
% 
%         cy = cellfun(@(z) a.(z),cname,'uniform',0);
% 
%         ax2(cd) = nsubplot(toPlot,numel(a.namesFirst),1,cd);
%         hold on;
%         if cd ==2
%             legpos = get(ax2(cd),'position');
%         end
% 
%         for ci = 1:numel(cname) % for each condition
% 
%             cn = clabel{ci}; % name
%             curcolor = ccolor{ci}; % color
% 
%             % conditional activity in this condition cells x frames x trials
%             y = cy{ci};
%             ycell = y(u,:,:);
%             ymean = mean(ycell,3,'omitnan');
%             ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
%             t=a.t{e};
%     %         plot(a.t{e},ymean-ysem,'color',curcolor,'linewidth',1);
%     %         plot(a.t{e},ymean+ysem,'color',curcolor,'linewidth',1);
%             plot(ax2(cd),t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
%             xlim(t([1 end])); 
%             if ci == numel(cname)
%                 plot(ax2(cd),[0 0],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
%                 plot(ax2(cd),[1.2 1.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
%                 if cd==1
%                     ylabel('Mean calcium activity','FontWeight','bold');
%                 end
%                 set(gca,'fontsize',6);    
%                 xticks([-2 -1 0 1 2]);            
%                 setlim(ax2,'ylim','tight');
%                 hold off;
%                 title(ctitle);
%             end
%         end
%     end
% 
%     cb={};
%     % 2nd row: ROC vs baseline by condition    
%     for cd = 1:numel(a.namesFirst)
%         cnames=a.namesFirst{cd};
%         e = a.nameEventsFirst(cd);
%         ctitle = a.titles{cd};
%         clabels = a.labels{cd};
%         ccolor = a.colors{cd,1};
%         t=a.t{e};    
%         ax2 = nsubplot(toPlot,numel(a.namesFirst),2,cd);
%         ci=1;
%         h_for_legend = [];
%         cn = [];
%         for ci = 1:numel(cnames)
%             cb(end+1)=clabels(ci);
%             cname = cnames(ci);
%             curcolor = ccolor{ci};
%             if numel(a.ROCsmooth{cd})>=ci
%             if ~isempty(a.ROCsmooth{cd}{ci})
%                 y = a.ROCsmooth{cd}{ci}(u,:);
%                 p = a.pvalsmooth{cd}{ci}(u,:);
%                 plot(t(p<a.pcrit & y-0.5>a.ROCcrit),y(p<a.pcrit & y-0.5>a.ROCcrit),'Color',curcolor,'MarkerFaceColor',curcolor,'LineStyle','none','Marker','o','MarkerSize',3*width);
%                 h_for_legend(end+1) = plot(t,y,'Color',curcolor,'linewidth',width);
%                 cn{end+1} = clabels{ci};
%             end
%             end
%         end
%         plot([0 0],[-1 +1].*10^10,'Color','k','yliminclude','off'); 
%         plot([-1 +1].*10^10,[.5 .5],'Color','r','xliminclude','off');
%         plot([-1 +1].*10^10,[.5+a.ROCcrit .5+a.ROCcrit],'Color',a.grey,'LineStyle',':','xliminclude','off');
%         plot([-1 +1].*10^10,[.5-a.ROCcrit .5-a.ROCcrit],'Color',a.grey,'LineStyle',':','xliminclude','off');    
%         ylim([0 1]); yticks([0:.25:1]);
%         ax2.XAxis.Visible = 'off';
%         if cd == 1
%         ylabel('ROC vs baseline','FontWeight','bold');
%         end
%         xlabel('Seconds');
%         ax2.FontSize = 6;
%     end
% 
% 
%     % 3rd row: mean ABSOLUTE activity difference
%     for cd = 1:numel(a.compOrder)
%         corder = a.compOrder{cd};
%         ax4 = nsubplot(toPlot,numel(a.compOrder),3,cd);
%         hold on; 
%         h_for_legend = [];
%         clabel = [];
%         for cm = 1:numel(corder)
%             ci = corder{cm};
%             e = a.compEvents(ci);
%             if size(a.absActivityTimeDiff,2)>=ci
%             if ~isempty(a.absActivityTimeDiff{ci})
%                 clabel{end+1} = a.compLabels{ci};
%                 y = a.absActivityTimeDiff{ci}(u,:);
%                 t=a.t{e};
%             %         plot(t,ymean-ysem,'color',a.grey,'linewidth',1);
%             %         plot(t,ymean+ysem,'color',a.grey,'linewidth',1);
%                 if cm == 1
%                     h_for_legend(end+1)=plot(ax4,t,y,'color','k','linewidth',width); % only this plot is used for legend!!
%                 else
%                     h_for_legend(end+1)=plot(ax4,t,y,'color','k','linewidth',width,'linestyle',':'); % only this plot is used for legend!!
%                 end
%             end
%             end
%             if cm == numel(corder)
%                 xlim(t([1 end])); 
%                     ylim([0 6]);
% %                 setlim(ax4,'ylim','tight');
%                 xticks([-2 -1 0 1 2]);
% %                 yticks([0 0.25 0.5]);
%                 set(gca,'fontsize',6);
%                 plot([1.2 1.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
%                  plot([0 0],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
% %                 plot([-1 +1].*10^10,[0 0],'color',a.grey,'yliminclude','off');
%                 if ~isempty(clabel)
%                 leg = legend(h_for_legend,clabel{:},'Location','northwest','Orientation','vertical');
%                 legend('boxoff')
%                 leg.FontSize = 6;
%                 end
%         %             xlabel('Seconds relative to event start');
%                 if cd==1
%                     ylabel({'Mean ABSOLUTE'; 'difference in activity'},'FontWeight','bold');
%                 end
%                 hold off;
%             end; 
%         end;
%     end
% 
% 
%     % 4th row: ROC
%     for cd = 1:numel(a.compOrder)
%         corder = a.compOrder{cd};
%         ax5 = nsubplot(toPlot,numel(a.compOrder),4,cd);
%         hold on; 
%         h_for_legend = [];
%         clabel = [];
%         for cm = 1:numel(corder)
%             ci = corder{cm};
%             e = a.compEvents(ci);
%             
%             if numel(a.rocs)>=ci
%             if ~isempty(a.rocs{ci})
%             y = a.rocs{ci}(u,:);
%             ypval = a.ROCpvals{ci}(u,:);
% 
%                 t=a.t{e};
% 
%         %         plot(t,ymean-ysem,'color',a.grey,'linewidth',1);
%         %         plot(t,ymean+ysem,'color',a.grey,'linewidth',1);
%                 clabel{end+1} = a.compLabels{ci};
%             if cm == 1
%                 h_for_legend(end+1)=plot(ax5,t,y,'color','k','linewidth',width); % only this plot is used for legend!!
%             else
%                 h_for_legend(end+1)=plot(ax5,t,y,'color','k','linewidth',width,'linestyle',':'); % only this plot is used for legend!!
%             end
%             end
%             end
%             if cm == numel(corder)
%                 xlim(t([1 end])); 
%         %             ylim([0 0.75]);
%                 setlim(ax5,'ylim',[0 1]);
%                 xticks([-2 -1 0 1 2]);
%                 yticks([0 0.5 1]);
%                 set(gca,'fontsize',6); 
%                 plot([1.2 1.2],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
%                 plot([0 0],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
%                 plot([-1 +1].*10^10,[0.5 0.5],'color','r','yliminclude','off');
%                 plot([-1 +1].*10^10,[1 1],'color',a.grey,'yliminclude','off');
%                 if ~isempty(clabel)
%                 leg = legend(h_for_legend,clabel{:},'Location','northwest','Orientation','vertical');
%                 legend('boxoff')
%                 leg.FontSize = 6;
%                 end
%         %             xlabel('Seconds relative to event start');
%                 if cd==1
%                     ylabel('ROC','FontWeight','bold');
%                 end
%                 hold off;
%             end; 
%         end;
%     end
% 
%     % 5th row: MEAN ROC BEFORE AND AFTER
%     for cd = 1:numel(a.compOrder)
%         corder = a.compOrder{cd};
%         h_for_legend = [];
%         clabel = [];
%         ax6(cd) = nsubplot(toPlot,numel(a.namesFirst),5,cd);
%         hold on;
%         pre = [];
%         post = [];
%         plabel = [];
%         for cm = 1:numel(corder)
%             ci = corder{cm};   
%             clabel{cm} = a.compLabels{ci};
%             if numel(a.rocsmean)>=ci
%                 if ~isempty(a.rocsmeanbase{ci})
%             pre(cm) = a.rocsmeanbase{ci}(u);
%             post(cm) = a.rocsmean{ci}(u);
%             preP(cm) = a.ROCpvalsbasemean{ci}(u);
%             postP(cm) = a.ROCpvalsmean{ci}(u);
%             else
%                 pre(cm)=NaN;
%                 post(cm)=NaN;
%                 preP(cm) = NaN;
%                 postP(cm)=NaN;
%                 end 
%             end
%         end
%         pre(end+1) = NaN;
%         post(end+1) = NaN;
%         if and(~all(isnan(pre)),~all(isnan(post)))
%         h = bar([pre' post']);
%         plot([-1 +1].*10^10,[0.5 0.5],'color','r','xliminclude','off');
%         plot([-1 +1].*10^10,[1 1],'color',a.grey,'xliminclude','off');
%         for cm = 1:numel(corder)
%             if preP(cm)<0.05
%             text(cm-0.08,1.05,['p = ' num2str(preP(cm))],'FontSize',6,'vert','bottom','horiz','center');
%             end
%             if postP(cm)<0.05
%             text(cm+0.08,1.05,['p = ' num2str(postP(cm))],'FontSize',6,'vert','bottom','horiz','center');
%             end
%         end
%         if cd==1
%             ylabel('Mean ROC','FontWeight','bold');
%         end
%         setlim(ax6,'ylim',[0 1]);
%         yticks([0 0.5 1]);
%         set(gca,'fontsize',6); 
%         xticks([1:numel(clabel)]);
%         xlim([0.5 numel(clabel)+0.5]);
%         h(1).FaceColor = a.grey;
%         h(2).FaceColor = 'k';
%         h(1).EdgeColor = 'none'; h(2).EdgeColor = 'none';
%         xticklabels(clabel);
%         leg = legend(ax6(cd),{'Baseline','Post-event'},'Location','northwest','Orientation','vertical','Box','off');
%         leg.FontSize = 6;
%         end
%     end
% 
%     ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
%     h_for_legend = [];
%     hold on;
%     for l = 1:numel(a.legendnames)
%         legcolor = a.legendcolors{l};
%         h_for_legend(end+1) = plot(ha,0,0,'color',legcolor','linewidth',2);
%     end
%     hold off;
%     % leg = legend(a.legendnames,'Position',[0.3,0.41,.5,.5],'Orientation','horizontal','Box','off');
%     leg = legend(a.legendnames,'Position',[0.3,0.35,.5,.5],'Orientation','horizontal','Box','off');
%     leg.FontSize = 6;
% 
%     text(0.51, 0.98,[strjoin(mice,' _ '),' Cell ',num2str(u),' PC1 sort ',num2str(uu)],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');
% 
% %     saveas(fig,fullfile(cellpath,[strjoin(mice,' _ '),'_SUMMARY_',num2str(uu),'_Cell ',num2str(u)]),'pdf');
% %     close;
% % end

%% CONDITIONAL RAW ACTIVITY - ACROSS CONDITION SUMMARY FOR EACH NEURON

% idx=flip(cellsByWeights);

uu = 1;
% idx = flip(a.respIdx);

for uu = 1:a.neuronCt
    u = idx(uu);

    figure();
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 8.5 11];
    %     set(fig,'renderer','painters');
    set(fig,'PaperOrientation','portrait');
    fs = 6;
    width = 2;
    color_limits = [-3 3];
    
    
   for cd = 1:numel(a.namesFirst)
        e = a.nameEventsFirst(cd);
        ctitle = a.titles{cd};
        cname = a.namesFirst{cd,1};
        clabel = a.labels{cd,1};
        ccolor = a.colors{cd,1};        

        cy = cellfun(@(z) a.(z),cname,'uniform',0);

        ax1(cd) = nsubplot(6,4,1,cd);
        hold on;
        if cd ==2
            legpos = get(ax1(cd),'position');
        end

        for ci = 1:numel(cname) % for each condition

            cn = clabel{ci}; % name
            curcolor = ccolor{ci}; % color

            % conditional activity in this condition cells x frames x trials
            y = cy{ci};
            ycell = y(u,:,:);
            ymean = mean(ycell,3,'omitnan');
            ysem = std(ycell,[],3) ./ sqrt(size(ycell,3));
            t=a.t{e};
            h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)], curcolor,'EdgeColor','none');
            set(h, 'FaceAlpha', 0.1);
            plot(ax1(cd),t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
            xlim([-1.2 1.2]);
            ylim([0 7]);
            if ci == numel(cname)
                plot(ax1(cd),[0 0],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
                if cd==1
                    ylabel('Mean calcium activity');
                end
                title(ctitle);
                set(gca,'fontsize',6);    
%                 xticks([-2 -1 0 1 2]);            
%                 setlim(gca,'ylim','tight');
                hold off;
            end;
        end;
   end

   cb={};
   for cd = 1:numel(a.namesFirst)
    cnames=a.namesFirst{cd};
    e = a.nameEventsFirst(cd);
    ctitle = a.titles{cd};
    clabels = a.labels{cd};
    ccolor = a.colors{cd,1};
    t=a.t{e};
    
    ax2 = nsubplot(6,4,1,cd);

    h_for_legend = [];
    cn = [];
    ci=1;
    for ci = 1:numel(cnames)
        ax = nsubplot(6,4,ci+1,cd);
        cb(end+1)=clabels(ci);
        cname = cnames(ci);
        cy = cellfun(@(z) a.(z),cname,'uniform',0);
        y = squeeze(cy{1}(u,:,:))';
        y=y(1:sum(~isnan(sum(y,2))),:);
        imagesc(t,1:size(y,1),y,color_limits);
        colorcet('D1');
        curcolor = ccolor{ci};
        set(gca,'YDir','reverse')
        plot([0 0],[-1 +1].*10^10,'k','yliminclude','off');
        axis tight;
        if ci<numel(cnames)
            ax.XAxis.Visible = 'off';
        end
        xlim([-1.2 1.2]);
        set(gca,'fontsize',6);
        ylabel('Trial');
        xlabel('Seconds');
        title(clabels{ci},'FontWeight','bold','Color',curcolor);
    end 
   end

%     h6_for_legend = [];
%     ax6 = nsubplot(6,4,6,1);
%     odor1 = [cell2mat(a.C_condBasePostROC{1}(u,[1 3]));cell2mat(a.C_condBasePostEarlyROC{1}(u,[1 3]));...
%     cell2mat(a.C_condBasePostLateROC{1}(u,[1 3]))];
%     odor1sig = [cell2mat(a.C_condBasePostROCP{1}(u,[1 3]));cell2mat(a.C_condBasePostEarlyROCP{1}(u,[1 3]));...
%         cell2mat(a.C_condBasePostLateROCP{1}(u,[1 3]))];
%     if numel(cell2mat(a.C_condBasePostROC{2}(u,:)))==4
%         odor2 = [cell2mat(a.C_condBasePostROC{2}(u,:))',NaN(4,1),NaN(4,1)]';
%         odor2sig = [cell2mat(a.C_condBasePostROCP{2}(u,:))',NaN(4,1),NaN(4,1)]';
%     else
%         odor2flag = cellfun(@isempty,a.C_condBasePostROC{2}(u,:));
%         odor2vals = a.C_condBasePostROC{2}(u,:);
%         odor2vals(odor2flag)=({NaN});
%         odor2 = [cell2mat(odor2vals)',NaN(4,1),NaN(4,1)]';
%         odor2sigvals = a.C_condBasePostROCP{2}(u,:);
%         odor2sigvals(odor2flag) = ({0});
%         odor2sig = [cell2mat(odor2sigvals)',NaN(4,1),NaN(4,1)]';
%     end
%     if numel(cell2mat(a.C_condBasePostROC{3}(u,:)))==4
%         outcome = [cell2mat(a.C_condBasePostROC{3}(u,:))',NaN(4,1),NaN(4,1)]';
%         outcomesig = [cell2mat(a.C_condBasePostROCP{3}(u,:))',NaN(4,1),NaN(4,1)]';
%     else
%        outcomeflag =  cellfun(@isempty,a.C_condBasePostROC{3}(u,:));
%        outcomevals = a.C_condBasePostROC{3}(u,:);
%        outcomevals(outcomeflag) = ({NaN});
%        outcome = [cell2mat(outcomevals)',NaN(4,1),NaN(4,1)]';
%        outcomesigvals = a.C_condBasePostROCP{3}(u,:);
%        outcomesigvals(outcomeflag)=({0});
%        outcomesig = [cell2mat(outcomesigvals)',NaN(4,1),NaN(4,1)]';
%     end
%     plotPercents = [odor1,odor2,outcome]';    
%     plotSig = [odor1sig,odor2sig,outcomesig]';
%     x1 = 1:length(plotPercents)';
%     x = NaN(3,length(plotPercents));
%     x(1,:) = x1-0.2;
%     x(2,:) = x1;
%     x(3,:) = x1+0.2;
%     x=x';
%     cdata = [a.purple;a.orange;[0 1 0];[1 0 1];[0 0 1];[0 1 1];[0 1 0];[1 0 1];[0 0 1];[0 1 1]];
%     h6_for_legend(end+1) = scatter(x(:,1),plotPercents(:,1),100,'Marker','s','MarkerFaceColor','flat','CData',cdata(1:numel(x1),:));
%     h6_for_legend(end+1) = scatter(x(:,2),plotPercents(:,2),100,'Marker','^','MarkerFaceColor','flat','CData',cdata(1:numel(x1),:));
%     h6_for_legend(end+1) = scatter(x(:,3),plotPercents(:,3),100,'Marker','p','MarkerFaceColor','flat','CData',cdata(1:numel(x1),:));
%     scatter(x(plotSig<a.pcrit & abs(plotPercents-.5)>a.ROCcrit),plotPercents(plotSig<a.pcrit & abs(plotPercents-.5)>a.ROCcrit),225,'Marker','o','MarkerEdgeColor','r');  
%     plot([-1 +1].*10^10,[0.5 0.5],'color',a.grey,'xliminclude','off');
%     plot([-1 +1].*10^10,[.5+a.ROCcrit .5+a.ROCcrit],'Color',a.grey,'LineStyle',':','xliminclude','off');
%     plot([-1 +1].*10^10,[.5-a.ROCcrit .5-a.ROCcrit],'Color',a.grey,'LineStyle',':','xliminclude','off');     
%     plot([2.5 2.5],[-1 +1].*10^10,'color','k','yliminclude','off');
%     plot([6.5 6.5],[-1 +1].*10^10,'color','k','yliminclude','off');
%     ylabel({'Mean Response:';'ROC vs baseline'},'FontWeight','bold');    
%     xlim([0 size(plotPercents,1)+.5]);
%     set(gca,'fontsize',6);
%     yticks([0:.25:1]);
%     ylim([0 1]);
%     leg = legend(ax6,h6_for_legend,{'Overall','Early','Late'},'Location','southoutside','Orientation','horizontal','Box','off');
%     leg.FontSize = 6;
%     ax6.XAxis.Visible = 'off';
%     text(1.5,0,'Center Odor','HorizontalAlignment','center','FontWeight','bold','FontSize',8);
%     text(4.5,0,'Side Odor','HorizontalAlignment','center','FontWeight','bold','FontSize',8);
%     text(8.5,0,'Outcome','HorizontalAlignment','center','FontWeight','bold','FontSize',8);
%     
%     h=[];
%     ax7 = nsubplot(6,4,6,2);
%     rocmatdata = NaN(8,1);
%     rocmatdata(1:size(a.ROCMatrix(u,:),2))=a.ROCMatrix(u,:);    
%     scatter(ax7,1:8,rocmatdata,100,'Marker','o','MarkerFaceColor','k')
%     plot([-1 +1].*10^10,[0.5 0.5],'color',a.grey,'xliminclude','off');
%     plot([-1 +1].*10^10,[.5+a.ROCcrit .5+a.ROCcrit],'Color',a.grey,'LineStyle',':','xliminclude','off');
%     plot([-1 +1].*10^10,[.5-a.ROCcrit .5-a.ROCcrit],'Color',a.grey,'LineStyle',':','xliminclude','off');     
%     plot([3.5 3.5],[-1 +1].*10^10,'color','k','yliminclude','off');
%     plot([6.5 6.5],[-1 +1].*10^10,'color','k','yliminclude','off');
%     ylabel('Conditional ROC','FontWeight','bold');
%     xtickk = 1:size(a.ROCMatrix(u,:),2);
%     xticks(xtickk);
%     xticklabels(a.ROClabelmatrixEarlyLate);
%     ax7.XTickLabelRotation = 45;
%     xlim([0 9]);
%     set(gca,'fontsize',6);
%     yticks([0:.25:1]);
%     ylim([0 1]);
%     
%     ax8 = nsubplot(6,4,6,3);
%     active=a.condActiveAll(u,:);
%     active(isnan(active))=0;
%     bar(active,'FaceColor','k');
%     set(gca,'fontsize',6);
%     xticks([1:12]);
%     xticklabels(cb);
%     ylabel('Cell is "Active"','FontWeight','bold');
%     
    
    % BIG TITLE!!!!!!!!!!
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 0.98,[strjoin(mice,' _ '),' Cell ',num2str(u),' by weight ',num2str(uu),' p=',num2str(pvals(uu))],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');
    
    saveas(fig,fullfile(cellpath,[strjoin(mice,' _ '),'_ConditionalActivity_PC1sort_',num2str(uu),'_Cell ',num2str(u)]),'pdf');
    close;
end

%% CONDITIONAL RAW ACTIVITY - CENTER, INFO BY SIDE

idx=flip(cellsByWeights);
uu = 1;
% idx = flip(a.respIdx);

% for uu = 1:a.neuronCt
    u = idx(uu);

    figure();
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 8.5 11];
    %     set(fig,'renderer','painters');
    set(fig,'PaperOrientation','portrait');
    fs = 6;
    width = 2;
    color_limits = [-3 3];
    
    
   cd=1;
   ci=1;
    e = a.nameEventsFirst(cd);
    ctitle = a.titles{cd};
    cnames = a.namesFirst{cd,1};
    clabels = a.labels{cd,1};
    ccolor = a.colors{cd,1};        

    cy = cellfun(@(z) a.(z),cnames,'uniform',0);

    ax1(cd) = nsubplot(5,1,1,cd);
    hold on;
    if cd ==2
        legpos = get(ax1(cd),'position');
    end

    for ci = 1:numel(cnames) % for each condition

        cn = clabels{ci}; % name
        curcolor = ccolor{ci}; % color

        % conditional activity in this condition cells x frames x trials
        y = cy{ci};
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
        t=a.t{e};
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)], curcolor,'EdgeColor','none');
%         set(h, 'FaceAlpha', 0.5);
        plot(ax1(cd),t,ymean,'color',curcolor,'linewidth',1); % only this plot is used for legend!!

        if ci == numel(cnames)
            plot(ax1(cd),[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
            for i = 1:5
            plot(ax1(cd),[0.2*i 0.2*i],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
            end
            if cd==1
                ylabel('Mean calcium activity');
            end
                    xlim([-0.4 1.4]);
%         ylim([0 7]);
%             title(ctitle);
            set(gca,'fontsize',6);    
                xticks(-2:0.2:2);            
%                 setlim(gca,'ylim','tight');
            hold off;
        end;
    end;


    ci=1;
    for ci = 1:numel(cnames)
        ax = nsubplot(5,1,ci+1,cd);
        cname = cnames(ci);
        cy = cellfun(@(z) a.(z),cname,'uniform',0);
        y = squeeze(cy{1}(u,:,:))';
        y=y(1:sum(~isnan(sum(y,2))),:);
        imagesc(t,1:size(y,1),y,color_limits);
        colorcet('D1');
        curcolor = ccolor{ci};
        set(gca,'YDir','reverse')
        plot([0 0],[-1 +1].*10^10,'k','yliminclude','off');
        for i = 1:5
            plot([0.2*i 0.2*i],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
        end        
        axis tight;
        if ci<numel(cnames)
            ax.XAxis.Visible = 'off';
        end
        xlim([-0.4 1.4]);
        xticks(-2:0.2:2); 
        set(gca,'fontsize',6);
        ylabel('Trial');
        xlabel('Seconds');
        title(clabels{ci},'FontWeight','bold','Color',curcolor);
    end 
        
    % BIG TITLE!!!!!!!!!!
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 0.98,[strjoin(mice,' _ '),' Cell ',num2str(u),' PC1sort ',num2str(uu),' p=',num2str(pvals(uu))],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');
    
    saveas(fig,fullfile(cellpath,[strjoin(mice,' _ '),'_ConditionalActivityCenter_PC1sort_',num2str(uu),'_Cell ',num2str(u)]),'pdf');
%     close;
% end

%% CENTER ODOR BY SIDE

e=3;
t=a.t{e};
uu = 1;
idx=flip(cellsByWeights);

cnames = a.namesFirst{1};

% for uu = 1:a.neuronCt
    u = idx(uu);

    figure();
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 8.5 11];
    %     set(fig,'renderer','painters');
    set(fig,'PaperOrientation','portrait');
    fs = 8;
    width = 0.5;
    
    ax1=nsubplot(4,3,1,1);
    t=a.t{e};
    hold on;
    curcolor=a.purple;
    y=cat(3,a.(cnames{1}),a.(cnames{2}));
    ycell = y(u,:,:);
    ymean = mean(ycell,3,'omitnan');
    ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));    
    h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
    set(h, 'FaceAlpha', 0.25);
    plot(ax1,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
    plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
    plot(ax1,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
    y=cat(3,a.(cnames{3}),a.(cnames{4}));
    ycell = y(u,:,:);
    ymean = mean(ycell,3,'omitnan');
    ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
    curcolor=a.orange;
    h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
    set(h, 'FaceAlpha', 0.25);    
    plot(ax1,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
    plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
    plot(ax1,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
    if cd==1
        ylabel('Mean calcium activity');
    end
    xlim([-0.4 1.4]);
    xlabel('Seconds');
%         ylim([0 7]);
    ylim('tight')
    y1=ylim(ax1);
    set(gca,'fontsize',fs);    
    xticks(-2:0.2:2);            
    hold off;
    title('Combined');
    
    ax2=nsubplot(4,3,1,2);
    t=a.t{e};
    hold on;
    curcolor=a.purple;
    y=a.(cnames{1});
    ycell = y(u,:,:);
    ymean = mean(ycell,3,'omitnan');
    ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));    
    h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
    set(h, 'FaceAlpha', 0.25);
    plot(ax2,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
    plot(ax2,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
    plot(ax2,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
    y=a.(cnames{3});
    ycell = y(u,:,:);
    ymean = mean(ycell,3,'omitnan');
    ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
    curcolor=a.orange;
    h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
    set(h, 'FaceAlpha', 0.25);    
    plot(ax2,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
    plot(ax2,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
    plot(ax2,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
    if cd==1
        ylabel('Mean calcium activity');
    end
    xlim([-0.4 1.4]);
    xlabel('Seconds');
%         ylim([0 7]);
    set(gca,'fontsize',fs);    
    xticks(-2:0.2:2);            
    ylim('tight')
    y2=ylim(ax2);
    hold off;
    title('Went Left');
    
    ax3=nsubplot(4,3,1,3);
    t=a.t{e};
    hold on;
    curcolor=a.purple;
    y=a.(cnames{2});
    ycell = y(u,:,:);
    ymean = mean(ycell,3,'omitnan');
    ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));    
    h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
    set(h, 'FaceAlpha', 0.25);
    plot(ax3,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
    plot(ax3,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
    plot(ax3,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
    y=a.(cnames{4});
    ycell = y(u,:,:);
    ymean = mean(ycell,3,'omitnan');
    ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
    curcolor=a.orange;
    h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
    set(h, 'FaceAlpha', 0.25);    
    plot(ax3,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
    plot(ax3,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
    plot(ax3,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
    if cd==1
        ylabel('Mean calcium activity');
    end
    xlim([-0.4 1.4]);
    xlabel('Seconds');
%         ylim([0 7]);
    set(gca,'fontsize',fs);    
    xticks(-2:0.2:2);            
    ylim('tight')
    y3=ylim(ax3);
    hold off;
    title('Went Right');    
    
    ymax=max([y1;y2;y3]);
    ymin=min([y1;y2;y3]);
    
    setlim(ax1,'ylim',[ymin(1)-0.1 ymax(2)+0.1]);
    setlim(ax2,'ylim',[ymin(1)-0.1 ymax(2)+0.1]);
    setlim(ax3,'ylim',[ymin(1)-0.1 ymax(2)+0.1]);
    
        % BIG TITLE!!!!!!!!!!
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 0.95,[strjoin(mice,' _ '),' Cell ',num2str(u),' PC1sort ',num2str(uu),' p=',num2str(pvals(uu))],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');
    
    saveas(fig,fullfile(cellpath,[strjoin(mice,' _ '),'_ConditionalActivityCenterbySide_PC1sort_',num2str(uu),'_Cell ',num2str(u)]),'pdf');

%     close;
% end


%% INCLUDING AB

uu = 1;
cnames = a.namesFirst{1};
idx=cellsByWeights;
numplot=5;
nrange=1:numplot:a.neuronCt;

n=1;
for n=1:numel(nrange)

    figure();
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 8.5 11];
    %     set(fig,'renderer','painters');
    set(fig,'PaperOrientation','portrait');
    fs = 8;
    width = 0.5;

    % for uu = 1:a.neuronCt
    us=nrange(n):nrange(n)+numplot-1;
    for i=1:numplot
        
        uu=us(i);
        if uu<=a.neuronCt
        u = idx(uu);
        ax1=nsubplot(numplot,4,i,1);
        e=3;
        t=a.t{e};
        hold on;
        curcolor=a.purple;
        y=cat(3,a.(cnames{1}),a.(cnames{2}));
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));    
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);
        plot(ax1,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
        plot(ax1,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
        y=cat(3,a.(cnames{3}),a.(cnames{4}));
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
        curcolor=a.orange;
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);    
        plot(ax1,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
        plot(ax1,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
        ylabel({[' Cell ',num2str(u)],[' INloading=',num2str(UINSort(uu))]});
        xlim([-0.4 1.4]);
        xlabel('Seconds');
    %         ylim([0 7]);
        ylim('tight')
        y1=ylim(ax1);
        set(gca,'fontsize',fs);    
        xticks(-2:0.2:2);            
        hold off;
        title(['Combined',' p=',num2str(pvals(find(iASort==iINSort(uu))))]);

        ax2=nsubplot(numplot,4,i,2);
        t=a.t{e};
        hold on;
        curcolor=a.purple;
        y=a.(cnames{1});
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));    
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);
        plot(ax2,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        plot(ax2,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
        plot(ax2,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
        y=a.(cnames{3});
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
        curcolor=a.orange;
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);    
        plot(ax2,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        plot(ax2,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
        plot(ax2,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
        xlim([-0.4 1.4]);
        xlabel('Seconds');
    %         ylim([0 7]);
        set(gca,'fontsize',fs);    
        xticks(-2:0.2:2);            
        ylim('tight')
        y2=ylim(ax2);
        hold off;
        title('Went Left');

        ax3=nsubplot(numplot,4,i,3);
        t=a.t{e};
        hold on;
        curcolor=a.purple;
        y=a.(cnames{2});
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));    
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);
        plot(ax3,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        plot(ax3,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
        plot(ax3,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
        y=a.(cnames{4});
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
        curcolor=a.orange;
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);    
        plot(ax3,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        plot(ax3,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
        plot(ax3,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
        xlim([-0.4 1.4]);
        xlabel('Seconds');
    %         ylim([0 7]);
        set(gca,'fontsize',fs);    
        xticks(-2:0.2:2);            
        ylim('tight')
        y3=ylim(ax3);
        hold off;
        title('Went Right');    

        ymax=max([y1;y2;y3]);
        ymin=min([y1;y2;y3]);

        setlim(ax1,'ylim',[ymin(1)-0.1 ymax(2)+0.1]);
        setlim(ax2,'ylim',[ymin(1)-0.1 ymax(2)+0.1]);
        setlim(ax3,'ylim',[ymin(1)-0.1 ymax(2)+0.1]);

        ax4=nsubplot(numplot,4,i,4);
        e=6;
        t=a.t{e};
        hold on;
        curcolor='g';
        y=a.C_odor2A;
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));    
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);
        plot(ax4,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        plot(ax4,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
        plot(ax4,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
        y=a.C_odor2B;
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
        curcolor='m';
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);    
        plot(ax4,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        plot(ax4,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
        plot(ax4,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
        xlim([-0.4 1.4]);
        xlabel('Seconds');
    %         ylim([0 7]);
        set(gca,'fontsize',fs);    
        xticks(-2:0.2:2);            
        ylim('tight')
        y3=ylim(ax3);
        hold off;
        title(['Side Odor, ABloading=' num2str(UABSort(uu))]);
        end
    end
        % BIG TITLE!!!!!!!!!!
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 0.95,[strjoin(mice,' _ ') ' sort by INFO PC1 loading, cells ' num2str(nrange(n)) '-' num2str(nrange(n)+numplot-1)],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');
    
    saveas(fig,fullfile(cellpath,[strjoin(mice,' _ '),'_ConditionalActivityCenterbySide_INFOPC1sort_Cells ',num2str(nrange(n)),'-',num2str(nrange(n)+numplot-1)]),'pdf');
    close; 
end

%% BY AB
% 
% uu = 1;
% cnames = a.namesFirst{1};
% idx=iABSort;
% numplot=5;
% 
%     figure();
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0 0 8.5 11];
%     %     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','portrait');
%     fs = 8;
%     width = 0.5;
% 
% % for uu = 1:a.neuronCt
% 
% for uu=1:numplot
%     u = idx(uu);
%  
%     ax1=nsubplot(numplot,4,uu,1);
%     e=3;
%     t=a.t{e};
%     hold on;
%     curcolor=a.purple;
%     y=cat(3,a.(cnames{1}),a.(cnames{2}));
%     ycell = y(u,:,:);
%     ymean = mean(ycell,3,'omitnan');
%     ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));    
%     h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
%     set(h, 'FaceAlpha', 0.25);
%     plot(ax1,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
%     plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
%     plot(ax1,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
%     y=cat(3,a.(cnames{3}),a.(cnames{4}));
%     ycell = y(u,:,:);
%     ymean = mean(ycell,3,'omitnan');
%     ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
%     curcolor=a.orange;
%     h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
%     set(h, 'FaceAlpha', 0.25);    
%     plot(ax1,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
%     plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
%     plot(ax1,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
%     ylabel({[' Cell ',num2str(u)],[' INloading=',num2str(UINSort(uu))]});
%     xlim([-0.4 1.4]);
%     xlabel('Seconds');
% %         ylim([0 7]);
%     ylim('tight')
%     y1=ylim(ax1);
%     set(gca,'fontsize',fs);    
%     xticks(-2:0.2:2);            
%     hold off;
%     title(['Combined',' p=',num2str(pvals(find(iASort==iABSort(uu))))]);
%     
%     ax2=nsubplot(numplot,4,uu,2);
%     t=a.t{e};
%     hold on;
%     curcolor=a.purple;
%     y=a.(cnames{1});
%     ycell = y(u,:,:);
%     ymean = mean(ycell,3,'omitnan');
%     ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));    
%     h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
%     set(h, 'FaceAlpha', 0.25);
%     plot(ax2,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
%     plot(ax2,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
%     plot(ax2,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
%     y=a.(cnames{3});
%     ycell = y(u,:,:);
%     ymean = mean(ycell,3,'omitnan');
%     ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
%     curcolor=a.orange;
%     h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
%     set(h, 'FaceAlpha', 0.25);    
%     plot(ax2,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
%     plot(ax2,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
%     plot(ax2,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
%     xlim([-0.4 1.4]);
%     xlabel('Seconds');
% %         ylim([0 7]);
%     set(gca,'fontsize',fs);    
%     xticks(-2:0.2:2);            
%     ylim('tight')
%     y2=ylim(ax2);
%     hold off;
%     title('Went Left');
%     
%     ax3=nsubplot(numplot,4,uu,3);
%     t=a.t{e};
%     hold on;
%     curcolor=a.purple;
%     y=a.(cnames{2});
%     ycell = y(u,:,:);
%     ymean = mean(ycell,3,'omitnan');
%     ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));    
%     h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
%     set(h, 'FaceAlpha', 0.25);
%     plot(ax3,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
%     plot(ax3,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
%     plot(ax3,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
%     y=a.(cnames{4});
%     ycell = y(u,:,:);
%     ymean = mean(ycell,3,'omitnan');
%     ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
%     curcolor=a.orange;
%     h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
%     set(h, 'FaceAlpha', 0.25);    
%     plot(ax3,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
%     plot(ax3,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
%     plot(ax3,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
%     xlim([-0.4 1.4]);
%     xlabel('Seconds');
% %         ylim([0 7]);
%     set(gca,'fontsize',fs);    
%     xticks(-2:0.2:2);            
%     ylim('tight')
%     y3=ylim(ax3);
%     hold off;
%     title('Went Right');    
%     
%     ymax=max([y1;y2;y3]);
%     ymin=min([y1;y2;y3]);
%     
%     setlim(ax1,'ylim',[ymin(1)-0.1 ymax(2)+0.1]);
%     setlim(ax2,'ylim',[ymin(1)-0.1 ymax(2)+0.1]);
%     setlim(ax3,'ylim',[ymin(1)-0.1 ymax(2)+0.1]);
%     
%     ax4=nsubplot(numplot,4,uu,4);
%     e=6;
%     t=a.t{e};
%     hold on;
%     curcolor='g';
%     y=a.C_odor2A;
%     ycell = y(u,:,:);
%     ymean = mean(ycell,3,'omitnan');
%     ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));    
%     h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
%     set(h, 'FaceAlpha', 0.25);
%     plot(ax4,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
%     plot(ax4,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
%     plot(ax4,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
%     y=a.C_odor2B;
%     ycell = y(u,:,:);
%     ymean = mean(ycell,3,'omitnan');
%     ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
%     curcolor='m';
%     h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
%     set(h, 'FaceAlpha', 0.25);    
%     plot(ax4,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
%     plot(ax4,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
%     plot(ax4,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
%     xlim([-0.4 1.4]);
%     xlabel('Seconds');
% %         ylim([0 7]);
%     set(gca,'fontsize',fs);    
%     xticks(-2:0.2:2);            
%     ylim('tight')
%     y3=ylim(ax3);
%     hold off;
%     title(['Side Odor, ABloading=' num2str(UABSort(uu))]);     
% end
%         % BIG TITLE!!!!!!!!!!
%     ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
%     text(0.5, 0.95,[strjoin(mice,' _ ') ' sort by AB PC1 loading'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');
%     
%     saveas(fig,fullfile(cellpath,[strjoin(mice,' _ '),'_ConditionalActivityCenterbySide_SIDEODORPC1sort_Cells 1-',num2str(numplot)]),'pdf');
% %     close;    

%% MEAN ACTIVITY ALL EVENTS

uu = 1;
idx=INdiffIdx;
numplot=5;
nrange=1:numplot:a.neuronCt;

n=1;
for n=1:numel(nrange)

    figure();
    fig = gcf;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 8.5 11];
    %     set(fig,'renderer','painters');
    set(fig,'PaperOrientation','portrait');
    fs = 8;
    width = 0.5;

    % for uu = 1:a.neuronCt
    us=nrange(n):nrange(n)+numplot-1;
    for i=1:numplot
        
        uu=us(i);
        if uu<=a.neuronCt
        u = idx(uu);
        
        ax1=nsubplot(numplot,3,i,1);
        e=3;
        t=a.t{e};
        hold on;
        curcolor=a.purple;
        y=a.C_odor1FirstInfoForced;
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));    
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);
        plot(ax1,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
        plot(ax1,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
        y=a.C_odor1FirstRandForced;
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
        curcolor=a.orange;
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);    
        plot(ax1,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
        plot(ax1,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
        ylabel({[' Cell ',num2str(u)]});
        xlim([-0.4 1.4]);
        xlabel('Seconds');
        ylim([0 5]);
        yticks(0:5);
        set(gca,'fontsize',fs);    
        xticks(-2:0.2:2);            
        hold off;
        title(['Center Odor',' p=',num2str(a.RSpvalsmean{2}(u))]);

        ax2=nsubplot(numplot,3,i,2);
        e=6;
        t=a.t{e};
        hold on;
        curcolor='g';
        y=a.C_odor2A;
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));    
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);
        plot(ax2,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        y=a.C_odor2B;
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
        curcolor='m';
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);    
        plot(ax2,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        y=a.C_odor2C;
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
        curcolor=a.cornflower;
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);    
        plot(ax2,t,ymean,'color',curcolor,'linewidth',width,'linestyle','--'); % only this plot is used for legend!!   
        y=a.C_odor2D;
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
        curcolor=a.cornflower;
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);    
        plot(ax2,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!        
        plot(ax2,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
        plot(ax2,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
        xlim([-0.4 1.4]);
        xlabel('Seconds');
        ylim([0 5]);
        yticks(0:5);
        set(gca,'fontsize',fs);    
        xticks(-2:0.2:2);            
        hold off;
        title(['Side Odor, p = ' num2str(a.RSpvalsmean{3}(u))]);
        
        ax3=nsubplot(numplot,3,i,3);
        e=7;
        t=a.t{e};
        hold on;
        curcolor='g';
        y=a.C_outcomeInfoBig;
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));    
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);
        plot(ax3,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        y=a.C_outcomeInfoSmall;
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
        curcolor='m';
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);    
        plot(ax3,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        y=a.C_outcomeRandBig;
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
        curcolor='b';
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);    
        plot(ax3,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!! 
        y=a.C_outcomeRandSmall;
        ycell = y(u,:,:);
        ymean = mean(ycell,3,'omitnan');
        ysem = nanstd(ycell,[],3) ./ sqrt(size(ycell,3));
        curcolor='c';
        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)],curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.25);    
        plot(ax3,t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!        
        plot(ax3,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
        plot(ax3,[0.2 0.2],[-1 +1].*10^10,'color','k','yliminclude','off');
        ylabel({[' Cell ',num2str(u)]});
        xlim([-0.4 1.4]);
        xlabel('Seconds');
        ylim([0 5]);
        yticks(0:5);
%         setlim(ax3,'ylim','tight');
        set(gca,'fontsize',fs);    
        xticks(-2:0.2:2);            
        hold off;
        title(['Outcome',' p=',num2str(a.RSpvalsmean{7}(u))]);        
        
        end
    end
        % BIG TITLE!!!!!!!!!!
    ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
    text(0.5, 0.95,[strjoin(mice,' _ ') ' sort by INFO-No INFO, cells ' num2str(nrange(n)) '-' num2str(nrange(n)+numplot-1)],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');
    
    saveas(fig,fullfile(cellpath,[strjoin(mice,' _ '),'_MeanConditionalActivity_INFODiffsort_Cells ',num2str(nrange(n)),'-',num2str(nrange(n)+numplot-1)]),'pdf');
    close; 
end