
%% PARAMS

PC=1;

% diffsSorted = ASort;
% cellsByDiff=iASort;
% sdiffsSorted=sASort;
% scellsByDiff=isASort;
% weightsSorted=UINSort;
% cellsByWeights=iINSort;
% weightsLRSorted=ULRSort;
% cellsByLRWeights=iLRSort;
% pvals=pNeurons(iASort);
% idx=cellsByWeights;

a.grey = [.8 .8 .8];
a.purple = [121 32 196] ./ 255;
a.lightPurple = [204 204 255] ./ 255;
a.orange = [251 139 6] ./ 255;
a.lightOrange = [255 204 153] ./ 255;
a.cornflower = [100 149 237] ./ 255;
a.teal = [0 128 128] ./ 255;
a.darkcyan = [0 139 139] ./ 255;

% color_limits = [-1.1 1.1];
% % diff_limits = [-0.65 0.65]; 
% diff_limits = color_limits;

% color_limits = [-1.2 1.2];
color_limits=[-2.5 2.5];
side_limits = [-1.4 1.4];
% diff_limits = [-0.6 0.6];
% diff_limits = [-0.8 0.8];
diff_limits = [-1.25 1.25];

heatLim = [-0.2 1];

RA=0;

width = 2;

tss=[0 1.45 11.45];

%%

a.decodeNames={'Info','Side','Water'};
a.decodeLabels= {{'Info','No Info'},{'Left','Right'},{'Big','Small'}};

a.resp_win=params.resp_win;
a.colors = {{a.purple,a.lightPurple,a.orange,a.lightOrange};
    {'r',a.orange,'y','g'};...
    {a.purple,a.orange,'r','y'};...
    {'g','m',a.cornflower,a.cornflower,'b'};...
    {'g','m','b','c'};...
    {'g','m','b','c','r','y'}};
a.namesFirst = {{'C_odor1FirstInfoLeft','C_odor1FirstInfoRight','C_odor1FirstRandLeft','C_odor1FirstRandRight'};...
    {'C_odor1FirstBigLeft','C_odor1FirstBigRight','C_odor1FirstSmallLeft','C_odor1FirstSmallRight'};...
    {'C_odor1InfoFirst','C_odor1RandFirst','C_odor1BigFirst','C_odor1SmallFirst'};...
    {'C_odor2A','C_odor2B','C_odor2C','C_odor2D','C_odor2Water'};... 
    {'C_toneInfoBig','C_toneInfoSmall','C_toneRandBig','C_toneRandSmall'};...
    {'C_outcomeInfoBig','C_outcomeInfoSmall','C_outcomeRandBig','C_outcomeRandSmall','C_outcomeBig','C_outcomeSmall'}};
a.titles = {'Center Odor Side Info','Center Odor Side Amount','Center Odor Info Amount',...
    'Side Odor','Tone','Outcome'};
a.labels = {{'Center Odor Info Left','Center Odor Info Right','Center Odor No Info Left','Center Odor No Info Right'};...
    {'Center Odor Big Left','Center Odor Big Right','Center Odor Small Left','Center Odor Small Right'};...
    {'Center Odor Info','Center Odor Rand','Center Odor Big','Center Odor Small'};...
    {'Side Odor A Info Water','Side Odor B Info No Water','Side Odor No Info C','Side Odor No Info D','Side Odor Water'};...
    {'Tone Info Water','Tone Info No Water','Tone Rand Water','Tone Rand No Water'};...
    {'Outcome Info Water','Outcome Info No Water','Outcome Rand Water','Outcome Rand No Water','Outcome Big Water','Outcome Small Water'}};
a.conditionLabels = {{'Info Left','Info Right','No Info Left','No Info Right'};...
    {'Big Left','Big Right','Small Left','Small Right'};...
    {'Info','Rand','Big','Small'};...
    {'A Info Water','B Info No Water','No Info C','No Info D','Water'};...
    {'Info Water','Info No Water','No Info Water','No Info No Water'};...
    {'Info Water','Info No Water','No Info Water','No Info No Water','Big Water','Small Water'}};
% a.compNamesFirst = {{'C_odor1FirstLeft','C_odor1FirstRight'};{'C_odor1InfoFirst','C_odor1RandFirst'};...
%     {'C_odor1BigFirst','C_odor1SmallFirst'};...
%     {'C_odor2A','C_odor2B'};{'C_odor2C','C_odor2D'};...
%     {'C_odor2info','C_odor2rand'};{'C_toneInfoBig','C_toneInfoSmall'};...
%     {'C_toneRandBig','C_toneRandSmall'};...
%     {'C_outcomeInfoBig','C_outcomeInfoSmall'};{'C_outcomeRandBig',...
%     'C_outcomeRandSmall'};{'C_odor2B','C_odor2C'};{'C_odor2A','C_odor2D'}};
a.compOrder = {{1,2,3},{4,5,6},{7,8},{9,10},{11,12}};
a.compLabels = {'Left - Right'; 'Info - No Info'; 'Big - Small';...
    'Info Water A - Info No Water B';'No Info C - No Info D';'InfoAB - No InfoCD';...                                                   
    'Info Water Tone - Info No Water Tone';'No Info Water Tone - No Info No Water Tone';...
    'Info Water - Info No Water';'No Info Water - No Info No Water';...
    'Info No Water B - No Info C';'Info Water A - No Info D'};
a.compTitles = {'Center Odor', 'Side Odor', 'Tone', 'Outcome', 'Side Odor Controls'};
a.legendnames = {'Info','No Info','Big','Small','Info Water','Info No Water','No Info C','No Info D','No Info Water','No Info No Water'};
a.legendcolors = {a.purple,a.orange,'r','y','g','m',a.cornflower,a.cornflower,'b','c'};

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


%% MATCHING TO TONES TASK INFO CODING
% load('TonesInfoCells.mat')
% a.infoTonesCells=infoCells;
% a.infoTonesLabels=infoLabels;
% a.infoTonesAct=infoAct;

differentCellsEBM=[a.actDiffIdxEBMSig{:}]<0.05;

% %%
% infoCells = differentCellsEBM(:,2);
% toneCells = a.infoTonesCells(:,8)<0.05;
% 
% vennPlot{1}=find(infoCells);
% vennPlot{2}=find(toneCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % nsubplot(1,1,1,1);
% % [H,S]=venn([sum(infoCells) sum(waterCells)],sum(overlapCells));
% %   for i = 1:2
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
% %   end
% % text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % % axis square;
% 
% [tbl,chi2,p] = crosstab(infoCells,toneCells);
% 
% % pause(10);
% h=vennEulerDiagram(vennPlot, {'InfoEBMCS','InfoToneEBMCS'}, 'drawProportional', true,'showintersectioncounts',true);
% title(['EBM CS diff, p= ' num2str(p)])
% 
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoToneEBMVenn']),'pdf');
% 
% 
% %% EBM HEATMAP CENTER ODOR VS ORIG TONES TASK
% 
% e=9;
% t=a.t{e};
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 11 8.5];
% %     set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% ax=nsubplot(1,2,1,1);
% y=a.activityDifferenceEBM{2};
% [~, maxIndices] = max(y, [], 2);
% [~, cell_sort_ids] = sort(maxIndices);
% imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
% colorcet('D1');
% colorbar()    
% plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'w','yliminclude','off');
% plot([1.65 1.65],[-1 +1].*10^10,'w','yliminclude','off');      
% axis tight;
%     set(gca,'YDir','reverse')
% %         if cd == 1
% %             ylabel('Cell');
% %         end
% %         if cd > 1
%     ax.YAxis.Visible = 'off';
% %         end
% xlim([-0.5 1.5]);
% xlabel('Seconds');
% title('Info - No Info Coding Index in joint value task');
% xticks([-2:0.2:1.45]); 
% ax.FontSize = 8; 
% 
% ax=nsubplot(1,2,1,2);
% y=a.infoTonesAct{2};
% imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
% colorcet('D1');
% colorbar()    
% plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'w','yliminclude','off');
% plot([1.65 1.65],[-1 +1].*10^10,'w','yliminclude','off');      
% axis tight;
% set(gca,'YDir','reverse')
% ax.YAxis.Visible = 'off';
% xlim([-0.5 1.5]);
% xlabel('Seconds');
% title('Info - No Info Coding Index in orig task');
% xticks([-2:0.2:1.45]); 
% ax.FontSize = 8; 
% 
% saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_heatmap_TonesvsVal_EBMIdxbyInfo']),'pdf');
% 
% % Tones orig task
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 11 8.5];
% %     set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% ax=nsubplot(1,2,1,2);
% y=a.infoTonesAct{2};
% [~, maxIndices] = max(y, [], 2);
% [~, cell_sort_ids] = sort(maxIndices);
% imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
% colorcet('D1');
% colorbar()    
% plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'w','yliminclude','off');
% plot([1.65 1.65],[-1 +1].*10^10,'w','yliminclude','off');      
% axis tight;
% set(gca,'YDir','reverse')
% ax.YAxis.Visible = 'off';
% xlim([-0.5 1.5]);
% xlabel('Seconds');
% title('Info - No Info Coding Index in orig task');
% xticks([-2:0.2:1.45]); 
% ax.FontSize = 8; 
% 
% ax=nsubplot(1,2,1,1);
% y=a.activityDifferenceEBM{2};
% imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
% colorcet('D1');
% colorbar()    
% plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'w','yliminclude','off');
% plot([1.65 1.65],[-1 +1].*10^10,'w','yliminclude','off');      
% axis tight;
%     set(gca,'YDir','reverse')
% %         if cd == 1
% %             ylabel('Cell');
% %         end
% %         if cd > 1
%     ax.YAxis.Visible = 'off';
% %         end
% xlim([-0.5 1.5]);
% xlabel('Seconds');
% title('Info - No Info Coding Index in joint value task');
% xticks([-2:0.2:1.45]); 
% ax.FontSize = 8; 
% 
% saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_heatmap_TonesvsVal_EBMIdxbyWater']),'pdf');


%% STUFF ABOUT PREVIOUS TRIAL

% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 11 8.5];
% %     set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% t=a.t{11};
% nsubplot(1,1,1,1);
% hold on;
% plot(t,mean(a.activityDifferenceTrialEBM{1}),'Color','g','LineWidth',5)
% for j=1:100; plot(t,mean(squeeze(a.activityDifferenceTrialEBMShuffle{1}(:,:,j))),'Color',[0.2 0.2 0.2],'LineWidth',0.2);end
% for i=1:3
% plot([tss(i) tss(i)],[-1 +1].*10^10,'k','yliminclude','off');
% end
% plot(t,mean(mean(a.activityDifferenceTrialEBMShuffle{1},3)),'Color','r','LineWidth',5);
% axis tight;
% xlim([-3 14]);
% 
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_EBMInfoTrial']),'pdf');
% 
% %%
% figure();hold on;
% plot(t,mean(mean(a.C_trialInfoPrevInfo,3,'omitnan')),'Color',a.purple,'LineWidth',5)
% plot(t,mean(mean(a.C_trialRandPrevInfo,3,'omitnan')),'Color',a.orange,'LineWidth',5)
% for i=1:3
% plot([tss(i) tss(i)],[-1 +1].*10^10,'k','yliminclude','off');
% end
% % plot(t,mean(mean(a.activityDifferenceTrialEBMShuffle{1},3)),'Color','r','LineWidth',5);
% axis tight;
% % xlim([-3 14]);
% 
% %%
% figure();hold on;
% for i=1:size(a.C_trialInfoPrevInfo,3)
% plot(t,mean(squeeze(a.C_trialInfoPrevInfo(:,:,i))),'Color',a.purple,'LineWidth',1)
% end
% for i=1:size(a.C_trialRandPrevInfo,3)
% plot(t,mean(squeeze(a.C_trialRandPrevInfo(:,:,i))),'Color',a.orange,'LineWidth',1)
% end
% for i=1:3
% plot([tss(i) tss(i)],[-1 +1].*10^10,'k','yliminclude','off');
% end
% % plot(t,mean(mean(a.activityDifferenceTrialEBMShuffle{1},3)),'Color','r','LineWidth',5);
% axis tight;
% % xlim([-3 14]);


%% INFO WATER CORRELATION

infoIdx = a.actDiffPostEBM{2};
waterIdx = a.actDiffPostEBM{3};

[InfoWatercorr, InfoWaterp] = corr(infoIdx,waterIdx);

infoAbsIdx = a.absActivityPostDiff{2};
waterAbsIdx = a.absActivityPostDiff{3};

[InfoWaterRScorr, InfoWaterRSp] = corr(infoAbsIdx,waterAbsIdx);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{2}<=0.05&~a.actDiffIdxEBMSig{3}<=0.05)={'Info Sig'};
sig1(~a.actDiffIdxEBMSig{2}<=0.05&a.actDiffIdxEBMSig{3}<=0.05)={'Water Sig'};
sig1(a.actDiffIdxEBMSig{2}<=0.05&a.actDiffIdxEBMSig{3}<=0.05)={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
gscatter(infoIdx,waterIdx,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Aresp,Bresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info EBM Coding')
ylabel('Water EBM Coding')
% xlim([0 5])
% ylim([0 5])
axis square
title(['Correlation = ' num2str(InfoWatercorr) ' p = ' num2str(InfoWaterp)])

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.RSpvalsmean{2,1}<=0.05&~a.RSpvalsmean{3,1}<=0.05)={'Info Sig'};
sig1(~a.RSpvalsmean{2,1}<=0.05&a.RSpvalsmean{3,1}<=0.05)={'Water Sig'};
sig1(a.RSpvalsmean{2,1}<=0.05&a.RSpvalsmean{3,1}<=0.05)={'Both Sig'};

ax1=nsubplot(1,2,1,2);
gscatter(infoAbsIdx,waterAbsIdx,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Inforespsub,Arespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Abs Coding')
ylabel('Water Coding')
% xlim([0 5])
% ylim([0 5])
axis square
title(['Correlation = ' num2str(InfoWaterRScorr) ' p = ' num2str(InfoWaterRSp)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoWaterIdx_correlation']),'pdf');


%% INFO WATER EBM diff CORRELATION

infoIdx = a.actDiffPostEBM{2}-a.actDiffPreEBM{2};
waterIdx = a.actDiffPostEBM{3}-a.actDiffPreEBM{3};

[InfoWatercorr, InfoWaterp] = corr(infoIdx,waterIdx);

infoAbsIdx = a.absActivityPostDiff{2};
waterAbsIdx = a.absActivityPostDiff{3};

[InfoWaterRScorr, InfoWaterRSp] = corr(infoAbsIdx,waterAbsIdx);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{2}<=0.05&~a.actDiffIdxEBMSig{3}<=0.05)={'Info Sig'};
sig1(~a.actDiffIdxEBMSig{2}<=0.05&a.actDiffIdxEBMSig{3}<=0.05)={'Water Sig'};
sig1(a.actDiffIdxEBMSig{2}<=0.05&a.actDiffIdxEBMSig{3}<=0.05)={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
gscatter(infoIdx,waterIdx,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Aresp,Bresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info EBM Coding Post-Pre')
ylabel('Water EBM Coding Post-Pre')
xlim([-3 4])
ylim([-3 4])
axis square
title(['Correlation = ' num2str(InfoWatercorr) ' p = ' num2str(InfoWaterp)])

ax1=nsubplot(1,2,1,2);
gscatter(infoAbsIdx,waterAbsIdx,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Inforespsub,Arespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Abs Coding')
ylabel('Water AbsCoding')
% xlim([0 5])
% ylim([0 5])
axis square
title(['Correlation = ' num2str(InfoWaterRScorr) ' p = ' num2str(InfoWaterRSp)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoWaterEBMdiff_correlation']),'pdf');


%% INFO VS SIDE CODING

infoIdx = a.actDiffPostEBM{2}-a.actDiffPreEBM{2};
sideIdx = a.actDiffPostEBM{1}-a.actDiffPreEBM{1};

[InfoSidecorr, InfoSidep] = corr(infoIdx,sideIdx);

infoAbsIdx = a.absActivityPostDiff{2};
sideAbsIdx = a.absActivityPostDiff{1};

[InfoSideRScorr, InfoSideRSp] = corr(infoAbsIdx,sideAbsIdx);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(a.actDiffIdxEBMSig{2}<=0.05&~a.actDiffIdxEBMSig{1}<=0.05)={'Info Sig'};
sig1(~a.actDiffIdxEBMSig{2}<=0.05&a.actDiffIdxEBMSig{1}<=0.05)={'Side Sig'};
sig1(a.actDiffIdxEBMSig{2}<=0.05&a.actDiffIdxEBMSig{1}<=0.05)={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
gscatter(infoIdx,sideIdx,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Aresp,Bresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info EBM Coding Post-Pre')
ylabel('Side EBM Coding Post-Pre')
% xlim([0 5])
% ylim([0 5])
axis square
title(['Correlation = ' num2str(InfoSidecorr) ' p = ' num2str(InfoSidep)])

ax1=nsubplot(1,2,1,2);
gscatter(infoAbsIdx,waterAbsIdx,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Inforespsub,Arespsub,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Abs Coding')
ylabel('Side AbsCoding')
% xlim([0 5])
% ylim([0 5])
axis square
title(['Correlation = ' num2str(InfoSideRScorr) ' p = ' num2str(InfoSideRSp)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoSideEBMdiff_correlation']),'pdf');

%% PC PROJECTION

rI=mean(a.C_odor1InfoFirst(:,iStart:iStop,:),3,'omitnan');
rN=mean(a.C_odor1RandFirst(:,iStart:iStop,:),3,'omitnan');
rI=rI-rI(:,1);
rN=rN-rN(:,1);

rIN = rI-rN;
[UIN SIN VIN] = svd(rIN);
LIN = diag(SIN).^2;
LIN = 100*LIN/sum(LIN);

rI=mean(a.C_odor1InfoFirst,3,'omitnan');
rN=mean(a.C_odor1RandFirst,3,'omitnan');
rI=rI-mean(rI(:,30:40),2);
rN=rN-mean(rN(:,30:40),2);

yMax = [5];
yMin = [-5];

e=3;

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 8.5 11];
set(fig,'PaperOrientation','portrait');
set(fig,'renderer','painters');

ax = nsubplot(1,1,1,1);
hold on;
h_for_legend=[];

for t=1:size(a.C_odor1InfoFirst,3)
   tI=a.C_odor1InfoFirst(:,:,t);
   tI=tI-mean(tI(:,30:40),2);
   plot(a.t{e},UIN(:,1)'*tI,'Color','b','Linewidth',0.2)
   tN=a.C_odor1RandFirst(:,:,t);
   tN=tN-mean(tN(:,30:40),2);
   plot(a.t{e},UIN(:,1)'*tN,'Color','r','Linewidth',0.2)
end
h_for_legend(end+1)=plot(a.t{e},UIN(:,1)'*rI,'Color','b','linewidth',6);
h_for_legend(end+1)=plot(a.t{e},UIN(:,1)'*rN,'Color','r','linewidth',6);
plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
plot([0 0],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
hold off;
xlim([-0.2 1.4]);
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

%% WATER PCA PROJECTION

rB=mean(a.C_odor1BigFirst(:,iStart:iStop,:),3,'omitnan');
rS=mean(a.C_odor1SmallFirst(:,iStart:iStop,:),3,'omitnan');
rB=rB-rB(:,1);
rS=rS-rS(:,1);

rW = rB-rS;
[UW SW VW] = svd(rW);
LW = diag(SW).^2;
LW = 100*LW/sum(LW);

rB=mean(a.C_odor1BigFirst,3,'omitnan');
rS=mean(a.C_odor1SmallFirst,3,'omitnan');
rB=rB-mean(rB(:,30:40),2);
rS=rS-mean(rS(:,30:40),2);

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

for t=1:size(a.C_odor1BigFirst,3)
   tB=a.C_odor1BigFirst(:,:,t);
   tB=tB-mean(tB(:,30:40),2);
   plot(a.t{e},UW(:,1)'*tB,'Color','g','Linewidth',0.2)
   tS=a.C_odor1SmallFirst(:,:,t);
   tS=tS-mean(tS(:,30:40),2);
   plot(a.t{e},UW(:,1)'*tS,'Color','m','Linewidth',0.2)
end
h_for_legend(end+1)=plot(a.t{e},UW(:,1)'*rB,'Color','g','linewidth',6);
h_for_legend(end+1)=plot(a.t{e},UW(:,1)'*rS,'Color','m','linewidth',6);
plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
plot([0 0],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
hold off;
xlim([-0.2 1.4]);
% ylim([yMin(1) yMax(1)]);
xlabel('Seconds since odor on')
ylabel('PC1 Projection')
% title(['Info-NoInfo  ' num2str(LW(1)) '% of variance',' p = ',num2str(pPC)]);
legend(h_for_legend,'Big Water','Small Water','location','northwest');
% axis square;
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96,[strjoin(mice,' _ ')],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% 
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PCprojection_Water']),'pdf');

% ax = gca;
exportgraphics(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PCprojection2_Water.pdf']),'ContentType','vector')

%% INFO WATER PCA CORRELATION

infoIdx = UIN(:,1);
waterIdx = UW(:,1);

[InfoWatercorr, InfoWaterp] = corr(infoIdx,waterIdx);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(pNeurons<5&~pNeuronsW<5)={'Info Sig'};
sig1(~pNeurons<5&pNeuronsW<5)={'Water Sig'};
sig1(pNeurons<5&pNeuronsW<5)={'Both Sig'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,1,1,1);
gscatter(infoIdx,waterIdx,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Aresp,Bresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Coding')
ylabel('Water Coding')
% xlim([0 5])
% ylim([0 5])
axis square
title(['Correlation = ' num2str(InfoWatercorr) ' p = ' num2str(InfoWaterp)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PCAWeights_correlation']),'pdf');

%% INFO WATER DECODE CORRELATION

infoIdx = a.decodeweights{1}(:,12);
waterIdx = a.decodeweights{2}(:,12);

[InfoWatercorr, InfoWaterp] = corr(infoIdx,waterIdx);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
% sig1(a.actDiffIdxEBMSig{2}<=0.05&~a.actDiffIdxEBMSig{3}<=0.05)={'Info Sig'};
% sig1(~a.actDiffIdxEBMSig{2}<=0.05&a.actDiffIdxEBMSig{3}<=0.05)={'Water Sig'};
% sig1(a.actDiffIdxEBMSig{2}<=0.05&a.actDiffIdxEBMSig{3}<=0.05)={'Both Sig'};
[~,infoTopIdx]=sort(infoDecodeIdx,'descend');
topInfoCells=infoTopIdx(1:round(0.1*a.neuronCt));
infoCells=ismember(1:a.neuronCt,topInfoCells);
[~,waterTopIdx]=sort(waterDecodeIdx,'descend');
topWaterCells=waterTopIdx(1:round(0.1*a.neuronCt));
waterCells=ismember(1:a.neuronCt,topWaterCells);
sig1(infoCells&~waterCells)={'Info top 10%'};
sig1(~infoCells&waterCells)={'Water top 10%'};
sig1(infoCells&waterCells)={'Both top 10%'};


figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,1,1,1);
gscatter(infoIdx,waterIdx,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Aresp,Bresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Decoder Weight')
ylabel('Water Decoder Weight')
% xlim([0 5])
% ylim([0 5])
axis square
title(['Correlation = ' num2str(InfoWatercorr) ' p = ' num2str(InfoWaterp)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_decodeWeights_correlation']),'pdf');

%% INFO WATER DECODE CORRELATION

infoIdx = abs(a.decodeweights{1}(:,12));
waterIdx = abs(a.decodeweights{2}(:,12));

[InfoWatercorr, InfoWaterp] = corr(infoIdx,waterIdx);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
% sig1(a.actDiffIdxEBMSig{2}<=0.05&~a.actDiffIdxEBMSig{3}<=0.05)={'Info Sig'};
% sig1(~a.actDiffIdxEBMSig{2}<=0.05&a.actDiffIdxEBMSig{3}<=0.05)={'Water Sig'};
% sig1(a.actDiffIdxEBMSig{2}<=0.05&a.actDiffIdxEBMSig{3}<=0.05)={'Both Sig'};
[~,infoTopIdx]=sort(infoDecodeIdx,'descend');
topInfoCells=infoTopIdx(1:round(0.1*a.neuronCt));
infoCells=ismember(1:a.neuronCt,topInfoCells);
[~,waterTopIdx]=sort(waterDecodeIdx,'descend');
topWaterCells=waterTopIdx(1:round(0.1*a.neuronCt));
waterCells=ismember(1:a.neuronCt,topWaterCells);
sig1(infoCells&~waterCells)={'Info top 10%'};
sig1(~infoCells&waterCells)={'Water top 10%'};
sig1(infoCells&waterCells)={'Both top 10%'};


figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,1,1,1);
gscatter(infoIdx,waterIdx,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Aresp,Bresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Decoder Weight')
ylabel('Water Decoder Weight')
% xlim([0 5])
% ylim([0 5])
axis square
title(['Correlation = ' num2str(InfoWatercorr) ' p = ' num2str(InfoWaterp)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_decodeWeightsAbs_correlation']),'pdf');

%%

infoIdx = infoDecodeIdx;
waterIdx = waterDecodeIdx;

[InfoWatercorr, InfoWaterp] = corr(infoIdx,waterIdx);

[~,infoTopIdx]=sort(infoDecodeIdx,'descend');
topInfoCells=infoTopIdx(1:round(0.1*a.neuronCt));
infoCells=ismember(1:a.neuronCt,topInfoCells);
[~,waterTopIdx]=sort(waterDecodeIdx,'descend');
topWaterCells=waterTopIdx(1:round(0.1*a.neuronCt));
waterCells=ismember(1:a.neuronCt,topWaterCells);
sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(infoCells&~waterCells)={'Info top 10%'};
sig1(~infoCells&waterCells)={'Water top 10%'};
sig1(infoCells&waterCells)={'Both top 10%'};

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,1,1,1);
gscatter(infoIdx,waterIdx,sig1,[0.8 0.8 0.8;1 0 0;0 1 0;0 0 1;],'.',15)
% scatter(Aresp,Bresp,20,'Filled');
di=refline(1);
set(di,'Color','k');
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Decoder Weight Idx')
ylabel('Water Decoder Weight Idx')
% xlim([0 5])
% ylim([0 5])
axis square
title(['Correlation = ' num2str(InfoWatercorr) ' p = ' num2str(InfoWaterp)])

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_decodeIdx_correlation']),'pdf');

%% HEATMAPS

%% EBM

% INFO

t=a.t{11};

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');
ax=nsubplot(1,2,1,1);
y=a.activityDifferenceTrialEBM{1};
[~, maxIndices] = max(y(:,364:640), [], 2);
[~, cell_sort_ids] = sort(maxIndices);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorcet('D1');
colorbar()
for i=1:3
plot([tss(i) tss(i)],[-1 +1].*10^10,'k','yliminclude','off');
end
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-1 14]);
xlabel('Seconds');
ylabel('Cells');
title('Info-No Info Coding Index (sort)');
ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')

ax=nsubplot(1,2,1,2);
y=a.activityDifferenceTrialEBM{2};
% [~, maxIndices] = max(y, [], 2);
% [~, cell_sort_ids] = sort(maxIndices);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorcet('D1');
colorbar()
for i=1:3
plot([tss(i) tss(i)],[-1 +1].*10^10,'k','yliminclude','off');
end
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-1 14]);
xlabel('Seconds');
ylabel('Cells');
title('Water Big-Small Coding Index');
% xticks([-2:0.2:2]); 
ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')
saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_heatmapInfoandWaterCodingEBMIdxbyInfo']),'pdf');

% Water

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');
ax=nsubplot(1,2,1,2);
y=a.activityDifferenceTrialEBM{2};
[~, maxIndices] = max(y(:,364:640), [], 2);
[~, cell_sort_ids] = sort(maxIndices);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorcet('D1');
colorbar()
for i=1:3
plot([tss(i) tss(i)],[-1 +1].*10^10,'k','yliminclude','off');
end
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-1 14]);
xlabel('Seconds');
ylabel('Cells');
title('Water Big-Small Coding Index (sort)');
ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')

ax=nsubplot(1,2,1,1);
y=a.activityDifferenceTrialEBM{1};
% [~, maxIndices] = max(y, [], 2);
% [~, cell_sort_ids] = sort(maxIndices);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorcet('D1');
colorbar()
for i=1:3
plot([tss(i) tss(i)],[-1 +1].*10^10,'k','yliminclude','off');
end
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-1 14]);
xlabel('Seconds');
ylabel('Cells');
title('Info-No Info Coding Index');
% xticks([-2:0.2:2]); 
ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')
saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_heatmapInfoandWaterCodingEBMIdxbyWater']),'pdf');

%% EBM MEAN FULL TRIAL

% a.trialColors = {'g','m','c','b'};
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
%     ypop=a.absActivityTimeDiffTrial{cd}-mean(a.absActivityTimeDiffTrial{cd}(:,30:40),2);
%     ypop=a.activityDifferenceTrialEBM{cd}-mean(a.activityDifferenceTrialEBM{cd}(:,30:40),2);
ypop=a.activityDifferenceTrialEBM{cd};
    ymean=mean(ypop);
    ysem = nanstd(ypop,[],1) ./ sqrt(size(ypop,1));
    t=a.t{e}(cebrastart:cebrastop);
    ymean=ymean(cebrastart:cebrastop);
    ysem=ysem(cebrastart:cebrastop);
%     t=t(cebrastart:cebrastop);
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
            xticks2 = get(gca, 'XTick'); % Get current x-axis ticks
            xticks2 = xticks2 + PID;
            xticks(xticks2);
            xticklabels2 = xticks2 - PID; % Adjust labels so that zero is at 0.075
            set(gca, 'XTickLabel', xticklabels2);
set(gca,'fontsize',8);
setlim('ylim','tight');
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



%% EBM HEATMAP CENTER ODOR

% color_limits=[-2.25 2.25];
color_limits=[-2.5 2.5];

e=9;
t=a.t{e};

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax=nsubplot(1,4,1,1);
y=a.activityDifferenceEBM{2};
y2=y-mean(y(:,30:41),2);
% [~, maxIndices] = max(y2(:,44:end), [], 2);
[~, maxIndices] = max(y, [], 2);
allOnsets = maxIndices;
maskPostOnset=maxIndices>42;
allOnsets(~maskPostOnset) = Inf+randperm(sum(~maskPostOnset));   % force pre-active to the end
[~, cell_sort_ids] = sort(allOnsets);
% [~, maxIndices] = max(y(:,44:end)-mean(y(:,37:40),2), [], 2);
% [~, cell_sort_ids] = sort(maxIndices);
% [infoSort,infoIdx] = sort(mean(y(:,40:50,:),2,'omitnan'),'descend');
% cell_sort_ids=infoIdx;
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorcet('D1');
colorbar()    
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
% xlim([-0.5 1.5]);
xlim(heatLim);
xlabel('Seconds');
title('Info - No Info Coding Index');
xticks([-2:0.2:1.45]); 
ax.FontSize = 8; 

ax=nsubplot(1,4,1,2);
y=a.activityDifferenceEBM{3};
% y=y-mean(y(:,36:41),2);
% y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorcet('D1');
colorbar()    
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'w','yliminclude','off');
plot([1.65 1.65],[-1 +1].*10^10,'w','yliminclude','off');      
axis tight;
set(gca,'YDir','reverse')
ax.YAxis.Visible = 'off';
% xlim([-0.5 1.5]);
xlim(heatLim);
xlabel('Seconds');
title('Water Big-Small Coding Index');
xticks([-2:0.2:1.45]); 
ax.FontSize = 8; 

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_heatmap_CenterOdor_EBMIdxbyInfo']),'pdf');

% Water

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax=nsubplot(1,4,1,2);
y=a.activityDifferenceEBM{3};
y2=y-mean(y(:,36:41),2);
[~, maxIndices] = max(y(:,42:end), [], 2);
[~, cell_sort_ids] = sort(maxIndices);
[~, maxIndices] = max(y, [], 2);
allOnsets = maxIndices;
maskPostOnset=maxIndices>42;
allOnsets(~maskPostOnset) = Inf+randperm(sum(~maskPostOnset));   % force pre-active to the end
[~, cell_sort_ids] = sort(allOnsets);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorcet('D1');
colorbar()    
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'w','yliminclude','off');
plot([1.65 1.65],[-1 +1].*10^10,'w','yliminclude','off');      
axis tight;
set(gca,'YDir','reverse')
ax.YAxis.Visible = 'off';
% xlim([-0.5 1.5]);
xlim(heatLim);
xlabel('Seconds');
title('Water Big-Small Coding Index');
xticks([-2:0.2:1.45]); 
ax.FontSize = 8; 

ax=nsubplot(1,4,1,1);
y=a.activityDifferenceEBM{2};
% y=y-mean(y(:,30:40),2);
imagesc(t,1:size(y,1),y(cell_sort_ids,:),color_limits);
colorcet('D1');
colorbar()    
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
% xlim([-0.5 1.5]);
xlim(heatLim);
xlabel('Seconds');
title('Info - No Info Coding Index');
xticks([-2:0.2:1.45]); 
ax.FontSize = 8; 

saveas(fig,fullfile(output_dir,[strjoin(mice, '_'),'_heatmap_CenterOdor_EBMIdxbyWater']),'pdf');


%% ALL 4 BY INFO-NO INFO DIFF

% color_limits = [-1 1];
% diff_limits=[-0.7 0.7];

e=9;
cd = 1;

% [infoSort,infoIdx] = sort(mean(squeeze(mean(a.C_odor1InfoFirst(:,40:56,:),2,'omitnan')),2,'omitnan'),'descend');
y_info=mean(a.C_odor1InfoFirst,3,'omitnan');
y_info=y_info-mean(y_info(:,30:40),2);
y_rand=mean(a.C_odor1RandFirst,3,'omitnan');
y_rand=y_rand-mean(y_rand(:,30:40),2);
[INdiffSort,INdiffIdx] = sort(mean(y_info(:,40:60),2)-mean(y_rand(:,40:60),2),'descend');
% cell_sort_ids=isASort;
cell_sort_ids=INdiffIdx;
% [~, maxIndices] = max(mean(y_info,2)-mean(y_rand,2), [], 2);
% [~, cell_sort_ids] = sort(maxIndices);

ctitle = a.titles{2};
clabels = {'Info','No Info','Big','Small'};
cnames = {'C_odor1InfoFirst','C_odor1RandFirst','C_odor1BigFirst','C_odor1SmallFirst'};
figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax=nsubplot(1,7,1,1);
% barh(sASort,'Facecolor','k');
barh(INdiffSort,'Facecolor','k');
ylabel('Cells')
xlabel('Info - No Info');
set(ax, 'Ydir', 'reverse')
ax.FontSize = 8;

for cd=1:2
    ax = nsubplot(1,7,1,cd+1);
    cname=cnames{cd};
    y=mean(a.(cname),3,'omitnan');
    y=y-mean(y(:,30:40),2);
    t=a.t{e};
    imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
%     colorcet('D1');
%     colormap(a.rbt);
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
    xlim(heatLim);
    xlabel('Seconds');
    title(clabels(cd));
    xticks([-2:0.2:1.45]); 
    ax.FontSize = 8; 
    colorbar()
end

ax = nsubplot(1,7,1,4);
y1=mean(a.C_odor1InfoFirst,3,'omitnan');
y2=mean(a.C_odor1RandFirst,3,'omitnan');
y=y1-y2;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),diff_limits);
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
xlim([heatLim]);
xlabel('Seconds');
title('Info-No Info');
xticks([-2:0.2:1.45]); 
ax.FontSize = 8;   
colorbar()

for cd=3:4
    ax = nsubplot(1,7,1,cd+2);
    cname=cnames{cd};
    y=mean(a.(cname),3,'omitnan');
    y=y-mean(y(:,30:40),2);
    t=a.t{e};
    imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
%     colorcet('D1');
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
%     plot([1.45 1.45],[-1 +1].*10^10,'k','yliminclude','off');
%     plot([1.65 1.65],[-1 +1].*10^10,'k','yliminclude','off');      
    axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
        ax.YAxis.Visible = 'off';
%         end
   xlim([heatLim]);
    xlabel('Seconds');
    title(clabels(cd));
    xticks([-2:0.2:1.45]); 
    ax.FontSize = 8; 
    colorbar()
end

ax = nsubplot(1,7,1,7);
y1=mean(a.C_odor1SmallFirst,3,'omitnan');
y2=mean(a.C_odor1BigFirst,3,'omitnan');
y=y2-y1;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),diff_limits);
% colorcet('D1');
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
xlim([heatLim]);
xlabel('Seconds');
title('Big-Small');
xticks([-2:0.2:1.45]); 
ax.FontSize = 8;
colorbar()

if RA==1
colormap(a.ckr);
else
colorcet('D1')
end

hold off;   
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.98,[strjoin(mice,' _ '),' Conditional Activity, sort by Info-NoInfo'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ConditionalActivity_CenterOdorAll4_byInfoNoInfoDiff']),'pdf');

%% All 4 BY BIG-SMALL DIFF

% color_limits = [-1 1];
% diff_limits=[-0.7 0.7];

e=9;
cd = 1;

% [infoSort,infoIdx] = sort(mean(squeeze(mean(a.C_odor1InfoFirst(:,40:56,:),2,'omitnan')),2,'omitnan'),'descend');
y_big=mean(a.C_odor1BigFirst,3,'omitnan');
y_big=y_big-mean(y_big(:,30:40),2);
y_small=mean(a.C_odor1RandFirst,3,'omitnan');
y_small=y_small-mean(y_small(:,30:40),2);
[BSdiffSort,BSdiffIdx] = sort(mean(y_big(:,40:60),2)-mean(y_small(:,40:60),2),'descend');
% cell_sort_ids=isASort;
cell_sort_ids=BSdiffIdx;

ctitle = a.titles{2};
clabels = {'Info','No Info','Big','Small'};
cnames = {'C_odor1InfoFirst','C_odor1RandFirst','C_odor1BigFirst','C_odor1SmallFirst'};
figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

ax=nsubplot(1,7,1,1);
% barh(sASort,'Facecolor','k');
barh(BSdiffSort,'Facecolor','k');
ylabel('Cells')
xlabel('Info - No Info');
set(ax, 'Ydir', 'reverse')
ax.FontSize = 8;

for cd=1:2
    ax = nsubplot(1,7,1,cd+1);
    cname=cnames{cd};
    y=mean(a.(cname),3,'omitnan');
    y=y-mean(y(:,30:40),2);
    t=a.t{e};
    imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
%     colorcet('D1');
%     colormap(a.rbt);
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
    xlim(heatLim);
    xlabel('Seconds');
    title(clabels(cd));
    xticks([-2:0.2:1.45]); 
    ax.FontSize = 8; 
end

ax = nsubplot(1,7,1,4);
y1=mean(a.C_odor1InfoFirst,3,'omitnan');
y2=mean(a.C_odor1RandFirst,3,'omitnan');
y=y1-y2;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),diff_limits);
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
xlim([heatLim]);
xlabel('Seconds');
title('Info-No Info');
xticks([-2:0.2:1.45]); 
ax.FontSize = 8;         

for cd=3:4
    ax = nsubplot(1,7,1,cd+2);
    cname=cnames{cd};
    y=mean(a.(cname),3,'omitnan');
    y=y-mean(y(:,30:40),2);
    t=a.t{e};
    imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),side_limits);
%     colorcet('D1');
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
%     plot([1.45 1.45],[-1 +1].*10^10,'k','yliminclude','off');
%     plot([1.65 1.65],[-1 +1].*10^10,'k','yliminclude','off');      
    axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
        ax.YAxis.Visible = 'off';
%         end
   xlim([heatLim]);
    xlabel('Seconds');
    title(clabels(cd));
    xticks([-2:0.2:1.45]); 
    ax.FontSize = 8; 
end

ax = nsubplot(1,7,1,7);
y1=mean(a.C_odor1SmallFirst,3,'omitnan');
y2=mean(a.C_odor1BigFirst,3,'omitnan');
y=y2-y1;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),diff_limits);
% colorcet('D1');
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
xlim([heatLim]);
xlabel('Seconds');
title('Big-Small');
xticks([-2:0.2:1.45]); 
ax.FontSize = 8;

if RA==1
colormap(a.ckr);
else
colorcet('D1')
end

hold off;   
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.98,[strjoin(mice,' _ '),' Conditional Activity, sort by Big-Small'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ConditionalActivity_CenterOdorAll4_byBigSmallDiff']),'pdf');

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


% RIGHT
ax = nsubplot(1,3,1,1); 
y_right=mean(a.C_odor1FirstRight,3,'omitnan');
% y_right=y_right-y_right(:,36);
y_right=y_right-mean(y_right(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_right,1),y_right(cell_sort_ids,:),color_limits);
% colorcet('D1');
colorbar()
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim(heatLim);
xlabel('Seconds');
title('Right');
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
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title('Left');
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
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
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

% color_limits = [-1.2 1.2];
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
% cell_sort_ids=infoIdx;
cell_sort_ids = INdiffIdx;
% [~,cell_sort_ids] = sort(y_info,'descend');


figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 8];
    set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

% INFO
ax = nsubplot(1,3,1,1);
% y_info=mean(a.C_odor1InfoFirst,3,'omitnan');
% y_left=y_left-y_left(:,36);
% y_info=y_info-mean(y_info(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_info,1),y_info(cell_sort_ids,:),color_limits);
colorbar()
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title('Info');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse');

% NO INFO
ax = nsubplot(1,3,1,2); 
% y_rand=mean(a.C_odor1RandFirst,3,'omitnan');
% y_right=y_right-y_right(:,36);
% y_rand=y_rand-mean(y_rand(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_rand,1),y_rand(cell_sort_ids,:),color_limits);
% colorcet('D1');
colorbar()
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title('No Info');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')

ax = nsubplot(1,3,1,3);
y_info=mean(a.C_odor1InfoFirst,3,'omitnan');
y_rand=mean(a.C_odor1RandFirst,3,'omitnan');
y=y_info-y_rand;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
% colorcet('D1');
colorbar()
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
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

%% CENTER ODOR INFO/NO INFO BY INFO

% color_limits = [-1.2 1.2];
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
% cell_sort_ids=infoIdx;
% cell_sort_ids = INdiffIdx;
[~,cell_sort_ids] = sort(mean(y_info(:,40:60),2),'descend');


figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 8];
    set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

clabels = a.decodeLabels{1};

% INFO
ax = nsubplot(1,3,1,1);
% y_info=mean(a.C_odor1InfoFirst,3,'omitnan');
% y_left=y_left-y_left(:,36);
% y_info=y_info-mean(y_info(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_info,1),y_info(cell_sort_ids,:),color_limits);
colorbar()
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title(clabels(1));
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')

% NO INFO
ax = nsubplot(1,3,1,2); 
% y_rand=mean(a.C_odor1RandFirst,3,'omitnan');
% y_right=y_right-y_right(:,36);
% y_rand=y_rand-mean(y_rand(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_rand,1),y_rand(cell_sort_ids,:),color_limits);
% colorcet('D1');
colorbar()
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title(clabels(2));
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')

ax = nsubplot(1,3,1,3);
y_info=mean(a.C_odor1InfoFirst,3,'omitnan');
y_rand=mean(a.C_odor1RandFirst,3,'omitnan');
y=y_info-y_rand;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids,:),diff_limits);
% colorcet('D1');
colorbar()
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title('Difference');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')
hold off;   
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.98,[strjoin(mice,' _ '),' Conditional Activity Center Odor, sort by info'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

if RA==1
colormap(a.ckr);
else
colorcet('D1')
end

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ConditionalActivity_CenterOdorbyInfo_byInfo_meansub']),'pdf');

%% SIDE ODOR A/B BY A-B

e=6;

y_A=mean(a.C_odor2A,3,'omitnan');
y_A=y_A-mean(y_A(:,30:40),2);
y_B=mean(a.C_odor2B,3,'omitnan');
y_B=y_B-mean(y_B(:,30:40),2);
[~,ABdiffSort] = sort(mean(y_A(:,40:60),2)-mean(y_B(:,40:60),2),'descend');
% cell_sort_ids=isASort;
% cell_sort_ids=infoIdx;
cell_sort_ids = ABdiffSort;
% [~,cell_sort_ids] = sort(y_info,'descend');


figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 8];
    set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

clabels = a.decodeLabels{1};

ax = nsubplot(1,3,1,1);
% y_info=mean(a.C_odor1InfoFirst,3,'omitnan');
% y_left=y_left-y_left(:,36);
% y_info=y_info-mean(y_info(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_A,1),y_A(cell_sort_ids,:),side_limits);
colorbar()
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title('A');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')

ax = nsubplot(1,3,1,2); 
% y_rand=mean(a.C_odor1RandFirst,3,'omitnan');
% y_right=y_right-y_right(:,36);
% y_rand=y_rand-mean(y_rand(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_B,1),y_B(cell_sort_ids,:),side_limits);
% colorcet('D1');
colorbar()
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
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
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title('Difference');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')
hold off;   
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.98,[strjoin(mice,' _ '),' Conditional Activity Side Odor, sort by A-B'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

if RA==1
colormap(a.ckr);
else
colorcet('D1')
end

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ConditionalActivity_SideOdorAB_byABDiff_meansub']),'pdf');

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
% y_info=mean(a.C_odor1InfoFirst,3,'omitnan');
% y_left=y_left-y_left(:,36);
% y_info=y_info-mean(y_info(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_A,1),y_A(cell_sort_ids,:),side_limits);
colorbar()
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title('A');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')

ax = nsubplot(1,3,1,2); 
% y_rand=mean(a.C_odor1RandFirst,3,'omitnan');
% y_right=y_right-y_right(:,36);
% y_rand=y_rand-mean(y_rand(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_B,1),y_B(cell_sort_ids,:),side_limits);
% colorcet('D1');
colorbar()
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
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
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
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

%% SIDE ODOR A/B BY A

e=6;

y_A=mean(a.C_odor2A,3,'omitnan');
y_A=y_A-mean(y_A(:,30:40),2);
y_B=mean(a.C_odor2B,3,'omitnan');
y_B=y_B-mean(y_B(:,30:40),2);
[~,ABdiffSort] = sort(mean(y_A(:,40:60),2)-mean(y_B(:,40:60),2),'descend');
[~,Asort] = sort(mean(y_A(:,40:60),2),'descend');
% cell_sort_ids=isASort;
% cell_sort_ids=infoIdx;
cell_sort_ids = Asort;
% [~,cell_sort_ids] = sort(y_info,'descend');


figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 6 8];
    set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

clabels = a.decodeLabels{1};

ax = nsubplot(1,3,1,1);
% y_info=mean(a.C_odor1InfoFirst,3,'omitnan');
% y_left=y_left-y_left(:,36);
% y_info=y_info-mean(y_info(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_A,1),y_A(cell_sort_ids,:),side_limits);
colorbar()
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
% ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title('A');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')

ax = nsubplot(1,3,1,2); 
% y_rand=mean(a.C_odor1RandFirst,3,'omitnan');
% y_right=y_right-y_right(:,36);
% y_rand=y_rand-mean(y_rand(:,30:40),2);
t=a.t{e};
imagesc(t,1:size(y_B,1),y_B(cell_sort_ids,:),side_limits);
% colorcet('D1');
colorbar()
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
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
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
ax.YAxis.Visible = 'off';
xlim([-0.2 1]);
xlabel('Seconds');
title('Difference');
% xticks([-2:0.2:2]); 
% ax.FontSize = 8;
set(ax, 'Ydir', 'reverse')
hold off;   
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.98,[strjoin(mice,' _ '),' Conditional Activity Side Odor, sort by A'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

if RA==1
colormap(a.ckr);
else
colorcet('D1')
end

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ConditionalActivity_SideOdorAB_byA_meansub']),'pdf');

%% TONES HEATMAP

e=14;
cd = 1;
% color_limits = [-1.2 1.2];
% diff_limits = [-0.6 0.6];

% [ASort,AIdx] = sort(mean(squeeze(mean(a.C_odor2A(:,40:80,:),2,'omitnan')-mean(a.C_odor2A(:,30:40,:),2,'omitnan')),2,'omitnan'),'descend');
% [CSort,CIdx] = sort(mean(squeeze(mean(a.C_odor2C(:,40:80,:),3,'omitnan')),2,'omitnan'),'descend');
% [DSort,DIdx] = sort(mean(squeeze(mean(a.C_odor2D(:,40:80,:),3,'omitnan')),2,'omitnan'),'descend');
% y_A=mean(a.C_toneInfoBig,3,'omitnan');
% y_A=y_A-mean(y_A(:,30:40),2);
y_C=mean(a.C_toneRandBig,3,'omitnan');
y_C=y_C-mean(y_C(:,30:40),2);
% [~,ABdiffSort] = sort(mean(y_A(:,40:60),2)-mean(y_B(:,40:60),2),'descend');
% [~,Asort] = sort(mean(y_A(:,40:60),2),'descend');
[~,Csort] = sort(mean(y_C(:,40:60),2),'descend');
% [~, maxIndices] = max(y_C(:,40:60), [], 2);
% [~, cell_sort_ids] = sort(maxIndices);
% cell_sort_ids=DIdx;
cell_sort_ids = Csort;
% isASortAB

ctitle = a.titles{4};
clabels = a.conditionLabels{5};
cnames = {'C_toneInfoBig','C_toneInfoSmall','C_toneRandBig',...
    'C_toneRandSmall'};
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
    plot([0 0],[-1 +1].*10^10,'k','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'k','yliminclude','off');
    plot([1.45 1.45],[-1 +1].*10^10,'k','yliminclude','off');
    plot([1.65 1.65],[-1 +1].*10^10,'k','yliminclude','off');      
    axis tight;
    colorbar()
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
        ax.YAxis.Visible = 'off';
%         end
    xlim(heatLim);
    xlabel('Seconds');
    title(clabels(cd));
%     xticks([-2:0.2:1.45]); 
    ax.FontSize = 8; 
end

ax = nsubplot(1,6,1,3);
y1=mean(a.C_toneInfoSmall,3,'omitnan');
y2=mean(a.C_toneInfoBig,3,'omitnan');
y=y2-y1;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),diff_limits);
% colorcet('D1');
plot([0 0],[-1 +1].*10^10,'k','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'k','yliminclude','off');
plot([1.45 1.45],[-1 +1].*10^10,'k','yliminclude','off');
plot([1.65 1.65],[-1 +1].*10^10,'k','yliminclude','off');
axis tight;
colorbar()
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
    ax.YAxis.Visible = 'off';
%         end
xlim(heatLim);
xlabel('Seconds');
title('Info Big - Info Small');
% xticks([-2:0.2:1.45]); 
ax.FontSize = 8;         

for cd=3:4
    ax = nsubplot(1,6,1,cd+1);
    cname=cnames{cd};
    y=mean(a.(cname),3,'omitnan');
    y=y-mean(y(:,30:40),2);
    t=a.t{e};
    imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
%     colorcet('D1');
    plot([0 0],[-1 +1].*10^10,'k','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'k','yliminclude','off');
%     plot([1.45 1.45],[-1 +1].*10^10,'k','yliminclude','off');
%     plot([1.65 1.65],[-1 +1].*10^10,'k','yliminclude','off');      
    axis tight;
    colorbar()
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
        ax.YAxis.Visible = 'off';
%         end
   xlim(heatLim);
    xlabel('Seconds');
    title(clabels(cd));
%     xticks([-2:0.2:1.45]); 
    ax.FontSize = 8; 
end

ax = nsubplot(1,6,1,6);
y1=mean(a.C_toneRandSmall,3,'omitnan');
y2=mean(a.C_toneRandBig,3,'omitnan');
y=y2-y1;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),diff_limits);
% colorcet('D1');
plot([0 0],[-1 +1].*10^10,'k','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'k','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'k','yliminclude','off');
% plot([1.65 1.65],[-1 +1].*10^10,'k','yliminclude','off');
axis tight;
colorbar()
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
    ax.YAxis.Visible = 'off';
%         end
xlim(heatLim);
xlabel('Seconds');
title('Rand Big - Rand Small');
% xticks([-2:0.2:1.45]); 
ax.FontSize = 8;

if RA==1
colormap(a.ckr);
else
colorcet('D1')
end

hold off;   
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.98,[strjoin(mice,' _ '),' Tones Conditional Activity, sort by Rand Big'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ConditionalActivity_Tones_byRandBig']),'pdf');

%% OUTCOME HEATMAPS

e=7;
cd = 1;

[NBigSort,NBigIdx] = sort(mean(squeeze(mean(a.C_outcomeRandBig(:,40:80,:),3,'omitnan')),2,'omitnan'),'descend');
[NSmallSort,NsmallIdx] = sort(mean(squeeze(mean(a.C_outcomeRandSmall(:,40:80,:),3,'omitnan')),2,'omitnan'),'descend');
y_water=mean(a.C_outcomeRandBig,3,'omitnan');
y_nowater=mean(a.C_outcomeRandSmall,3,'omitnan');
[~,WNdiffSort] = sort(mean(y_water(:,40:60),2)-mean(y_nowater(:,40:60),2),'descend');
cell_sort_ids=WNdiffSort;

ctitle = a.titles{5};
clabels = a.conditionLabels{5};
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
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
        set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
        ax.YAxis.Visible = 'off';
%         end
    xlim([heatLim]);
    xlabel('Seconds');
    title(clabels(cd));
    xticks([-2:0.2:2]); 
    ax.FontSize = 8;
end

ax = nsubplot(1,6,1,3);
y1=mean(a.C_outcomeInfoBig,3,'omitnan');
y2=mean(a.C_outcomeInfoSmall,3,'omitnan');
y=y1-y2;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),diff_limits);
% colorcet('D1');
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
    ax.YAxis.Visible = 'off';
%         end
xlim([heatLim]);
xlabel('Seconds');
title('Info, Water - No Water');
xticks([-2:0.2:2]); 
ax.FontSize = 8;         

for cd=3:4
    ax = nsubplot(1,6,1,cd+1);
    cname=cnames{cd};
    y=mean(a.(cname),3,'omitnan');
    y=y-mean(y(:,30:40),2);
    t=a.t{e};
    imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
%     colorcet('D1');
    plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
    plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
    set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
        ax.YAxis.Visible = 'off';
%         end
    xlim([heatLim]);
    xlabel('Seconds');
    title(clabels(cd));
    xticks([-2:0.2:2]); 
    ax.FontSize = 8; 
end

ax = nsubplot(1,6,1,6);
y1=mean(a.C_outcomeRandBig,3,'omitnan');
y2=mean(a.C_outcomeRandSmall,3,'omitnan');
y=y1-y2;
t=a.t{e};
imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),diff_limits);
% colorcet('D1');
plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
axis tight;
set(gca,'YDir','reverse')
%         if cd == 1
%             ylabel('Cell');
%         end
%         if cd > 1
    ax.YAxis.Visible = 'off';
%         end
xlim([heatLim]);
xlabel('Seconds');
title('No Info, Water - No Water');
xticks([-2:0.2:2]); 
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


%% POPULATION ACTIVITY

% mean conditional activity

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

width = 2;


for cd = 1:numel(a.namesFirst)
    e = a.nameEventsFirst(cd);
    ctitle = a.titles{cd};
    cname = a.namesFirst{cd,1};
    clabels = a.conditionLabels{cd,1};
    ccolor = a.colors{cd,1};        

    cy = cellfun(@(z) a.(z),cname,'uniform',0);

    ax(cd) = nsubplot(1,numel(a.namesFirst),1,cd);
    hold on;
    h_for_legend = [];
   cn = [];
    for ci = 1:numel(cname) % for each condition
        curcolor = ccolor{ci}; % color
        % conditional activity in this condition cells x frames x trials
        if sum(a.condActive{cd}{ci}==1)>0
%             y = cy{ci}(a.C_condBasePostRSActive{cd}{ci}==1,:,:);
            y=cy{ci};
            ypop = mean(y,3,'omitnan');
            ypop = ypop-mean(ypop(:,30:40),2);
            ymean = nanmean(ypop,1);
            ysem = nanstd(ypop,[],1) ./ sqrt(size(ypop,1));

            t=a.t{e};

        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)], curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.1);
%         plot(a.t{e},ymean-ysem,'color',curcolor,'linewidth',1);
%         plot(a.t{e},ymean+ysem,'color',curcolor,'linewidth',1);
        if cd==4 & ci==3
            h_for_legend(end+1)=plot(ax(cd),t,ymean,'color',curcolor,'linewidth',width,'linestyle','--'); % only this plot is used for legend!!
        else
            h_for_legend(end+1)=plot(ax(cd),t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        end
            
            cn{end+1} = clabels{ci}; % name
            xlim(t([1 end]));
        end
            if ci == numel(cname)
                plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
                plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
                plot([a.resp_win(1) a.resp_win(1)],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
                plot([a.resp_win(2) a.resp_win(2)],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');            
                if cd==1
                    ylabel('Population mean calcium activity','FontWeight','bold');
                end
                set(gca,'fontsize',8);
                leg = legend(h_for_legend,cn,'Orientation','vertical','Location','southoutside','Box','off');
                leg.FontSize = 6;
                title(ctitle);
                xlim([-0.5 1.2]);
                xticks([-2:0.2:2]);
%                 ylim([-0.05 0.1]);
    %             setlim(ax(cd),'ylim','tight');
                hold off;
            end
    end
    axis square;
end

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');

text(0.51, 0.98,[strjoin(mice,' _ '),' Mean Activity ALL CELLS'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_Population_SUMMARY_Mean_First']),'pdf');

%% POPULATION SUMMARY FIGURE

cell_sort_ids=[];
figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 8.5 11];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','portrait');

toPlot = 5;
width = 1;

ax1=[];ax2=[];ax3=[];ax4=[];ax5=[];ax6=[];ax9=[];

% sort by odor 1 response
for ci = 1:numel(a.namesFirst)
    e = a.nameEventsFirst(ci);
%     y = a.eventActivity{e};
    y = a.C_events{e};

    if sorting == 1
%         if e == 3
            yresp = mean(mean(y(:,a.okt{e},:),3),2);
            [~,cell_sort_ids(:,ci)] = sort(yresp);
%         end
    else cell_sort_ids(:,ci) = 1:size(y,1);
    end

    checkmin(ci) = min(y(:));
    checkmax(ci) = max(y(:));
end

% color_limits = max(abs([min(checkmin(:)) max(checkmax(:))])).*[-1 1];

% color_limits = [-1.1 1.1];

% cell_sort_ids = 1:a.neuronCt; 

% 1st row: population mean-subtracted heatmap for event
for ee = 1:numel(a.namesFirst)
    
    e = a.nameEventsFirst(ee);
    eventLabel = a.titles{ee};    
    plotData = [];
%     plotData = a.eventActivity{e}; 
    plotData = nanmean(a.C_events{e},3);
   
    t = a.t{e};

    imAlpha=ones(size(plotData));
    imAlpha(isnan(plotData))=0;         

    ax1 = nsubplot(toPlot,numel(a.namesFirst),1,ee);
%     hold on;
%     imagesc(ax1,t,(1:size(plotData,1)),plotData(cell_sort_ids,:),'AlphaData',imAlpha,color_limits);
    imagesc(ax1,t,(1:size(plotData,1)),plotData(cell_sort_ids(:,ee),:),'AlphaData',imAlpha,color_limits);
%     imagesc(ax1,t,(1:size(plotData,1)),plotData(cell_sort_ids,:),'AlphaData',imAlpha);
if RA==1
colormap(a.ckr);
else
colorcet('D1')
end
    plot(ax1,[0 0],[-1 +1].*10^10,'k','yliminclude','off');
    plot(ax1,[a.resp_win(1) a.resp_win(1)],[-1 +1].*10^10,'w','yliminclude','off');
    plot(ax1,[a.resp_win(2) a.resp_win(2)],[-1 +1].*10^10,'w','yliminclude','off');
    axis tight;
    xticks([-2:0.2:2]);
    set(gca,'ytick',[]);
    set(gca,'yticklabel',[]);
    ax1.FontSize = 6;
    if ee==1
        ylabel('Cell','FontWeight','bold');   
    end
    title(eventLabel);
    hold off;
end


% 2nd row: population mean response  
for cd = 1:numel(a.namesFirst)
    e = a.nameEventsFirst(cd);

    cname = a.namesFirst{cd,1};
    clabel = a.labels{cd,1};
    ccolor = a.colors{cd,1};        

    cy = cellfun(@(z) a.(z),cname,'uniform',0);

    ax2(cd) = nsubplot(toPlot,numel(a.namesFirst),2,cd);
    hold on;

    for ci = 1:numel(cname) % for each condition

        cn = clabel{ci}; % name
        curcolor = ccolor{ci}; % color

        % conditional activity in this condition cells x frames x trials
%         y = cy{ci}(a.condActive{cd}{ci}==1,:,:);
        y=cy{ci};
        ypop = nanmean(y,3);
        ypop = ypop-mean(ypop(:,30:40),2);
        ymean = nanmean(ypop,1);
%         ymean = ymean-mean(ymean(:,30:40),2);
        ysem = nanstd(ypop,[],1) ./ sqrt(size(ypop,1));

            t=a.t{e};

%         plot(a.t{e},ymean-ysem,'color',curcolor,'linewidth',1);
%         plot(a.t{e},ymean+ysem,'color',curcolor,'linewidth',1);
        plot(ax2(cd),t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        xlim(t([1 end])); 
        if ci == numel(cname)
            plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
            plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
            plot([a.resp_win(1) a.resp_win(1)],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
            plot([a.resp_win(2) a.resp_win(2)],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');            
            if cd==1
                ylabel('Population mean calcium activity ALL CELLS','FontWeight','bold');
            end
            set(gca,'fontsize',6);    
            xticks([-2:0.2:2]);            
            setlim(ax2,'ylim','tight');
            hold off;
        end;
    end;
end


% 3rd row: population mean ABSOLUTE activity difference
for cd = 1:numel(a.compOrder)
    corder = a.compOrder{cd};
    ax4 = nsubplot(toPlot,numel(a.compOrder),3,cd);
    hold on; 
    h_for_legend = [];
    clabel = [];
    for cm = 1:numel(corder)
        ci = corder{cm};
        e = a.compEventsFirst(ci);
        
        if ~isnan(a.absActivityTimeDiff{ci})
            y = a.absActivityTimeDiff{ci};
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
            xlim(t([1 end])); 
    %             ylim([0 0.75]);
            setlim(ax4,'ylim','tight',[0 0.7]);
            xticks([-2:0.2:2]);
%             yticks([0 0.25 0.5]);
            set(gca,'fontsize',6); 
            plot([0 0],[-1*10^10 .75],'color','k','yliminclude','off');
            plot([-1 +1].*10^10,[0 0],'color',a.grey,'yliminclude','off');
            plot([a.resp_win(1) a.resp_win(1)],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
            plot([a.resp_win(2) a.resp_win(2)],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
            if ~isempty(h_for_legend)
            leg = legend(h_for_legend,clabel{:},'Location','northwest','Orientation','vertical');
            legend('boxoff')
            leg.FontSize = 6;
            end
    %             xlabel('Seconds relative to event start');
            if cd==1
                ylabel({'Mean ABSOLUTE ALL CELLS'; 'difference in activity'},'FontWeight','bold');
            end
            hold off;
        end; 
    end;
end


% 4th row: percent cells with significant activity differences over time (per shuffle)
for cd = 1:numel(a.compOrder)
    corder = a.compOrder{cd};
    ax5 = nsubplot(toPlot,numel(a.compOrder),4,cd);
    hold on; 
    h_for_legend = [];
    clabel = [];
    for cm = 1:numel(corder)
        ci = corder{cm};
        e = a.compEventsFirst(ci);
        t=a.t{e};
        if ~isnan(a.pNeuronsPost{ci})
%             y = a.pcellsROC{ci};
            y=a.nSigTime{ci};
                        clabel{end+1} = a.compLabels{ci};
            if cm == 1
                h_for_legend(end+1)=plot(ax5,t,y,'color','k','linewidth',width); % only this plot is used for legend!!
            elseif cm == 2
                h_for_legend(end+1)=plot(ax5,t,y,'color','k','linewidth',width,'linestyle',':'); % only this plot is used for legend!!
            else
                h_for_legend(end+1)=plot(ax5,t,y,'color','k','linewidth',width,'linestyle','--'); % only this plot is used for legend!!
            end

        end
            
        if cm == numel(corder)
            xlim(t([1 end])); 
    %             ylim([0 0.75]);
            setlim(ax5,'ylim','tight',[0 0.7]);
            xticks([-2:0.2:2]);
%             yticks([0 0.25 0.5]);
            set(gca,'fontsize',6); 
            plot([0 0],[-1*10^10 .75],'color','k','yliminclude','off');
            plot([a.resp_win(1) a.resp_win(1)],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
            plot([a.resp_win(2) a.resp_win(2)],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');             
            %             plot([-1 +1].*10^10,[0.5 0.5],'color',a.grey,'yliminclude','off');
            if ~isempty(h_for_legend)
                        leg = legend(h_for_legend,clabel{:},'Location','northwest','Orientation','vertical');
                        legend('boxoff')
                        leg.FontSize = 6;
            end
    %             xlabel('Seconds relative to event start');
            if cd==1
                ylabel('Percent cells with differential activity (shuffle)','FontWeight','bold');
            end
            hold off;
        end 
    end
end

% 5th row: PERCENT CELLS BEFORE AND AFTER
for cd = 1:numel(a.compOrder)
    corder = a.compOrder{cd};
    h_for_legend = [];
    clabel = [];
    pre = [];
    post = [];
    ax6(cd) = nsubplot(toPlot,numel(a.namesFirst),5,cd);
    hold on;    
    for cm = 1:numel(corder)
        ci = corder{cm};    
        clabel{cm} = a.compLabels{ci};
        if isnan(a.nSigPost{ci})
            pre=0;
            post=0;
        elseif isempty(a.nSigPost{ci})
            pre=0;
            post=0;
        else
            pre(cm) = a.nSigPre{ci};
            post(cm) = a.nSigPost{ci};
        end
    end
    pre(end+1) = NaN;
    post(end+1) = NaN;
    h = bar([pre' post']);
    plot([-1 +1].*10^10,[0.05 0.05],'color',a.grey,'xliminclude','off');
    if cd==1
        ylabel({'Percent of cells with'; 'differential activity'},'FontWeight','bold');
    end
    xtickk = 1:numel(corder);
    xticks(xtickk);
%     if cd == numel(a.compOrder)
        setlim(ax6,'ylim',[0 1]);    
%     end
    xlim([0.5 numel(clabel)+0.5]);
    set(gca,'fontsize',6);
    yticks([0:.1:1]);
    if ~isnan(pre(1))
    h(1).FaceColor = a.grey;
    h(2).FaceColor = 'k';
    h(1).EdgeColor = 'none'; h(2).EdgeColor = 'none';
    end
    xticklabels(clabel);
    leg = legend(ax6(cd),{'Pre-event','Post-event'},'Location','northwest','Orientation','vertical','Box','off');
    leg.FontSize = 6;
end


ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
h_for_legend = [];
hold on;
for l = 1:numel(a.legendnames)
    legcolor = a.legendcolors{l};
	h_for_legend(end+1) = plot(ha,0,0,'color',legcolor','linewidth',2);
end
hold off;
% leg = legend(a.legendnames,'Position',[0.3,0.41,.5,.5],'Orientation','horizontal','Box','off');
leg = legend(a.legendnames,'Position',[0.3,0.35,.5,.5],'Orientation','horizontal','Box','off');
leg.FontSize = 6;

text(0.51, 0.98,[strjoin(mice,' _ ')],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_Population_SUMMARY']),'pdf');


%% POWER

% pop activity for "active" cells

figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');

width = 2;


for cd = 1:numel(a.namesFirst)
    e = a.nameEventsFirst(cd);
    ctitle = a.titles{cd};
    cname = a.namesFirst{cd,1};
    clabels = a.conditionLabels{cd,1};
    ccolor = a.colors{cd,1};        

    cy = cellfun(@(z) a.(z),cname,'uniform',0);

    ax(cd) = nsubplot(1,numel(a.namesFirst),1,cd);
    hold on;
    h_for_legend = [];
   cn = [];
    for ci = 1:numel(cname) % for each condition
        curcolor = ccolor{ci}; % color
        % conditional activity in this condition cells x frames x trials
        if sum(a.condActive{cd}{ci}==1)>0
            y = cy{ci}(a.C_condBasePostRSActiveExpPos{cd}{ci}==1,:,:);;
            ypop = mean(y,3,'omitnan');
            ypop = ypop-mean(ypop(:,30:40),2);
            ymean = nanmean(ypop,1);
            ysem = nanstd(ypop,[],1) ./ sqrt(size(ypop,1));

            t=a.t{e};

        h = fill([a.t{e}, fliplr(a.t{e})], [ymean-ysem, fliplr(ymean+ysem)], curcolor,'EdgeColor','none');
        set(h, 'FaceAlpha', 0.1);
%         plot(a.t{e},ymean-ysem,'color',curcolor,'linewidth',1);
%         plot(a.t{e},ymean+ysem,'color',curcolor,'linewidth',1);
        if cd==4 & ci==3
            h_for_legend(end+1)=plot(ax(cd),t,ymean,'color',curcolor,'linewidth',width,'linestyle','--'); % only this plot is used for legend!!
        else
            h_for_legend(end+1)=plot(ax(cd),t,ymean,'color',curcolor,'linewidth',width); % only this plot is used for legend!!
        end
            cn{end+1} = clabels{ci}; % name
            xlim(t([1 end]));
        end
            if ci == numel(cname)
                plot([0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
                plot([-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
                plot([a.resp_win(1) a.resp_win(1)],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');
                plot([a.resp_win(2) a.resp_win(2)],[-1 +1].*10^10,'color',a.grey,'yliminclude','off');            
                if cd==1
                    ylabel({'Response Power'; 'Mean calcium activity of active cells'},'FontWeight','bold');
                end
                set(gca,'fontsize',8);
                leg = legend(h_for_legend,cn,'Orientation','vertical','Location','southoutside','Box','off');
                leg.FontSize = 6;
                title(ctitle);
                xlim([-0.5 1.2]);
                xticks([-2:0.2:2]);
%                 ylim([-0.05 1]);
%                 setlim(ax(cd),'ylim','tight');
                hold off;
            end
    end
    axis square
end

ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');

text(0.51, 0.98,[strjoin(mice,' _ '),' Response Power First Center Entry'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_Population_SUMMARY_POWER_First']),'pdf');


%% PERCENT CELL BARS AND VENN DIAGRAMS

% want matrix of whether cell differentiates each in compNames

% differentCells = [a.RSpvalsmean{:}]<0.05; %a.RSpvalsmean
% differentCells= [a.C_condRSdifferent{:}]; %RS
% differentCells= [a.C_condROCdifferent{:}]; %ROC
differentCells= [a.C_condShuffleDifferent{:}]; %shuffle
% differentCells = [a.pNeuronsPost{:}]<5; % PCA
differentCellsEBM=[a.actDiffIdxEBMSig{:}]<0.05;

a.differentCells=differentCells;
a.differentCellsEBM=differentCellsEBM;
% activeCells=[a.C_condBasePostActive{:}];

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
                ylabel({'Mean ABSOLUTE'; 'difference in activity'},'FontWeight','bold');
            end
            title(a.compTitles{cd});
            hold off
            axis square;
        end 
    end
end

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AbsDiffSigCells']),'pdf');

%% EBM INDEX ACTIVITY

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

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_EBMIdx']),'pdf');

%%
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

%% SIGNIFICANT OVERLAP

infoCells = differentCellsEBM(:,2);
waterCells = differentCellsEBM(:,3);
overlapCells = infoCells&waterCells;
totalCells = infoCells|waterCells;

infoOfCells=infoCells(totalCells);
waterOfCells=waterCells(totalCells);

trueOverlap=sum(overlapCells)/sum(totalCells);
% 
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

totalCells = infoCells|waterCells;

inA=infoCells(totalCells);
inB=waterCells(totalCells);

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

fprintf('Observed overlap across all cells %d, two-tailed p = %.4f\nhigh p = %.4f low p = %.4f\n', overlapObs, pTwo, pHigh, pLow);

% chanceOverlap=(sum(inA)/a.neuronCt)*(sum(inB)/a.neuronCt)*100;
% vsChance=((overlapObs/a.neuronCt*100)-chanceOverlap)/chanceOverlap

chanceOverlap=(sum(inA)/a.neuronCt)*(sum(inB)/a.neuronCt);
vsChance=((overlapObs/a.neuronCt)-chanceOverlap)/chanceOverlap

%%
infoCells = differentCellsEBM(:,2);
waterCells = differentCellsEBM(:,3);
sideCells = differentCellsEBM(:,1);


vennPlot{1}=find(infoCells);
vennPlot{2}=find(sideCells);

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

[tbl,chi2,p] = crosstab(infoCells,sideCells);

% pause(10);
h=vennEulerDiagram(vennPlot, {'InfoDiffCS','SideDiffCS'}, 'drawProportional', true,'showintersectioncounts',true);
title(['EBM CS diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoSideEBMVenn']),'pdf');


vennPlot{1}=find(waterCells);
vennPlot{2}=find(sideCells);

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

[tbl,chi2,p] = crosstab(waterCells,sideCells);

% pause(10);
h=vennEulerDiagram(vennPlot, {'WaterDiffCS','SideDiffCS'}, 'drawProportional', true,'showintersectioncounts',true);
title(['EBM CS diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_WaterSideEBMVenn']),'pdf');

%%
infoCells = activeCells(:,5);
waterCells = activeCells(:,9);


setLabels = {'Info', 'Water'};
cells=sum([infoValCells waterValCells])/a.neuronCt;

vennPlot{1}=find(infoCells);
vennPlot{2}=find(waterCells);

[tbl,chi2,p] = crosstab(infoCells,waterCells);

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
title(['p= ' num2str(p)]);

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoValue2Venn']),'pdf');

%%
infoUSCells = differentCellsEBM(:,6);
waterUSCells = differentCellsEBM(:,9);

vennPlot{1}=find(infoUSCells);
vennPlot{2}=find(waterUSCells);

figure();
fig = gcf;
fig.PaperUnits = 'inches';
set(fig,'PaperOrientation','landscape');
fig.PaperSize = [11 8.5];
fig.PaperPosition = [0 0 10 8];

[tbl,chi2,p] = crosstab(infoUSCells,waterUSCells);

h=vennEulerDiagram(vennPlot, {'InfoDiffUS','WaterDiffUS'}, 'drawProportional', true,'showintersectioncounts',true);
title(['EBM US diff, p= ' num2str(p)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoWaterUSEBMVenn']),'pdf');

%% INFO CELL OVERLAP
info1Cells = activeCells(:,1);
info2Cells = activeCells(:,2);


setLabels = {'Info 1', 'Info 2'};
cells=sum([info1Cells info2Cells])/a.neuronCt;

vennPlot{1}=find(info1Cells);
vennPlot{2}=find(info2Cells);

[tbl,chi2,p] = crosstab(info1Cells,info2Cells);

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
h=vennEulerDiagram(vennPlot, {'Info 1','Info 2'}, 'drawProportional', true,'showintersectioncounts',true);
title(['p= ' num2str(p)]);

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_Info12Venn']),'pdf');
%% INFO CS US VENN
% 
% ACells = activeCellsRS(:,9);
% BCells = activeCellsRS(:,10);
% USCells = ACells&BCells;
% 
% infoCells = differentCells(:,2);
% 
% vennPlot{1}=find(infoCells);
% vennPlot{2}=find(USCells);
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
% h=vennEulerDiagram(vennPlot, {'InfoCSDiff','InfoUS'}, 'drawProportional', true,'showintersectioncounts',true);
% 
% title('Info CS US cells by infovnoinfo and active for A&B')
% % axis square;
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoUSVennbyDiff']),'pdf');
% 
% %% INFO CS US VENN 2
% 
% ACells = activeCellsRS(:,9);
% BCells = activeCellsRS(:,10);
% USCells = ACells&BCells;
% % USCells = BCells;
% 
% infoCells = activeCellsRS(:,5);
% 
% vennPlot{1}=find(infoCells);
% vennPlot{2}=find(USCells);
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
% h=vennEulerDiagram(vennPlot, {'InfoCSActive','InfoUS'}, 'drawProportional', true,'showintersectioncounts',true);
% title('Info CS US cells by info active and active for A&B')
% 
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoUSVennbyActive']),'pdf');
% 
% %% INFO CS US VENN 2
% 
% CCells = activeCellsRS(:,11);
% DCells = activeCellsRS(:,12);
% USCells = CCells&DCells;
% 
% infoCells = activeCellsRS(:,5);
% 
% vennPlot{1}=find(infoCells);
% vennPlot{2}=find(USCells);
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
% h=vennEulerDiagram(vennPlot, {'InfoCSActive','CD'}, 'drawProportional', true,'showintersectioncounts',true);
% title('Info CS US cells by info active and active for C&D')
% 
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoCDUSVennbyActive']),'pdf');
% 
% %% INFO CS US VENN 3
% 
% USCells = differentCells(:,5);
% infoCells = differentCells(:,2);
% 
% vennPlot{1}=find(infoCells);
% vennPlot{2}=find(USCells);
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
% h=vennEulerDiagram(vennPlot, {'InfoCSDiff','InfoUSDiff'}, 'drawProportional', true,'showintersectioncounts',true);
% title('Info CS US cells by info diff and diff AB vs CD')
% 
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoUSVennbyBoth Diff']),'pdf');
% 
% %% INFO US Pos Neg Venn
% 
% % USPosCells=differentCells(:,5)&a.activityPostDiff{5}>0;
% % USNegCells=differentCells(:,5)&a.activityPostDiff{5}<0;
% % 
% % vennPlot{1}=find(USPosCells);
% % vennPlot{2}=find(USPosCells);
% % 
% % figure();
% % fig = gcf;
% % fig.PaperUnits = 'inches';
% % set(fig,'PaperOrientation','landscape');
% % fig.PaperSize = [11 8.5];
% % fig.PaperPosition = [0 0 10 8];
% % % nsubplot(1,1,1,1);
% % % [H,S]=venn([sum(infoValCells) sum(USCells)],sum(overlapCells));
% % %   for i = 1:2
% % %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
% % %   end
% % % text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % % axis square;
% % h=vennEulerDiagram(vennPlot, {'InfoUSPos','InfoUSNeg'}, 'drawProportional', true,'showintersectioncounts',true);
% % title('Info US cells by info vs no info greater')
% % 
% % saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoUSVennbyPosNeg']),'pdf');
% 
% %% INFO AND SIDE VENN
% 
% infoCells = differentCells(:,2);
% sideCells = differentCells(:,1);
% infoOnlyCells = infoCells&~sideCells;
% sideOnlyCells = sideCells&~infoCells;
% overlapCells = infoCells&sideCells;
% 
% setLabels = {"Info"; "Side";};
% cells=sum([infoOnlyCells sideOnlyCells])/a.neuronCt;
% 
% vennPlot{1}=find(infoCells);
% vennPlot{2}=find(sideCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % nsubplot(1,1,1,1);
% % [H,S]=venn([sum(infoCells) sum(sideCells)],sum(overlapCells));
% %   for i = 1:2
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
% %   end
% % text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % axis square;
% h=vennEulerDiagram(vennPlot, {'Info','Side'}, 'drawProportional', true,'showintersectioncounts',true);
% 
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoSideVenn']),'pdf');
% 
% %%
% ACells = activeCells(:,9);
% BCells = activeCells(:,10);
% AonlyCells=ACells&~BCells;
% BonlyCells=BCells&~ACells;
% overlapCells = ACells&BCells;
% 
% setLabels = {"A:Water"; "B:No Water";};
% cells=sum([AonlyCells BonlyCells])/a.neuronCt;
% 
% vennPlot{1}=find(ACells);
% vennPlot{2}=find(BCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% 
% % nsubplot(1,1,1,1);
% % [H,S]=venn([sum(ACells) sum(BCells)],sum(overlapCells));
% %   for i = 1:2
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
% %   end
% % text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % % axis square;
% 
% h=vennEulerDiagram(fig,vennPlot, {'A','B'}, 'drawProportional', true,'showintersectioncounts',true);
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ABVenn']),'pdf');
% 
% %%
% 
% CCells = activeCells(:,11);
% DCells = activeCells(:,12);
% ConlyCells=CCells&~DCells;
% DonlyCells=DCells&~CCells;
% overlapCells = CCells&DCells;
% 
% setLabels = {"C:No Info"; "D:No Info";};
% cells=sum([ConlyCells DonlyCells])/a.neuronCt;
% 
% vennPlot{1}=find(CCells);
% vennPlot{2}=find(DCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % nsubplot(1,1,1,1);
% % [H,S]=venn([sum(CCells) sum(DCells)],sum(overlapCells));
% %   for i = 1:2
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
% %   end
% % text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % % axis square;
% 
% h=vennEulerDiagram(fig,vennPlot, {'C','D'}, 'drawProportional', true,'showintersectioncounts',true);
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_CDVenn']),'pdf');
% 
% %%
% 
% ACells = activeCells(:,9);
% BCells = activeCells(:,10);
% CCells = activeCells(:,11);
% DCells = activeCells(:,12);
% CDCells = CCells&DCells;
% ABCells = ACells&BCells;
% 
% vennPlot{1}=find(ABCells);
% vennPlot{2}=find(CDCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % nsubplot(1,1,1,1);
% % [H,S]=venn([sum(CCells) sum(DCells)],sum(overlapCells));
% %   for i = 1:2
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
% %   end
% % text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % % axis square;
% 
% h=vennEulerDiagram(fig,vennPlot, {'AB','CD'}, 'drawProportional', true,'showintersectioncounts',true);
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ABCDVenn']),'pdf');
% %%
% 
% USPosCells=differentCells(:,5)&a.activityPostDiff{5}>0;
% USNegCells=differentCells(:,5)&a.activityPostDiff{5}<0;
% 
% vennPlot{1}=find(ACells);
% vennPlot{2}=find(BCells);
% vennPlot{3}=find(CCells);
% vennPlot{4}=find(DCells);
% % vennPlot{5}=USPosCells;
% % vennPlot{6} = USNegCells;
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % nsubplot(1,1,1,1);
% % [H,S]=venn([sum(CCells) sum(DCells)],sum(overlapCells));
% %   for i = 1:2
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
% %   end
% % text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % % axis square;
% 
% h=vennEulerDiagram(fig,vennPlot, {'A','B','C','D'}, 'drawProportional', true,'showintersectioncounts',true);
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ABCDVenn2']),'pdf');
% 
% %%
% 
% h=[];vennPlot=[];
% USPosCells=differentCells(:,5)&a.activityPostDiff{5}>0;
% USNegCells=differentCells(:,5)&a.activityPostDiff{5}<0;
% 
% vennPlot{1}=find(ACells);
% vennPlot{2}=find(BCells);
% % vennPlot{3}=find(CCells);
% % vennPlot{4}=find(DCells);
% vennPlot{3}=find(USPosCells);
% % vennPlot{6} = USNegCells;
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % nsubplot(1,1,1,1);
% % [H,S]=venn([sum(CCells) sum(DCells)],sum(overlapCells));
% %   for i = 1:2
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
% %   end
% % text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % % axis square;
% 
% h=vennEulerDiagram(fig,vennPlot, {'A','B','ABUS'}, 'drawProportional', true,'showintersectioncounts',true);
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ABUSVenn']),'pdf');
% 
% 
% %% BC and CD Venn
% 
% CCells = activeCells(:,11);
% BCells = activeCells(:,10);
% ConlyCells=CCells&~BCells;
% BonlyCells=BCells&~CCells;
% overlapCells = CCells&BCells;
% 
% setLabels = {"C:No Info"; "B:Info No Water";};
% cells=sum([ConlyCells BonlyCells])/a.neuronCt;
% 
% vennPlot{1}=find(CCells);
% vennPlot{2}=find(BCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % nsubplot(1,1,1,1);
% % [H,S]=venn([sum(CCells) sum(DCells)],sum(overlapCells));
% %   for i = 1:2
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
% %   end
% % text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % % axis square;
% 
% h=vennEulerDiagram(fig,vennPlot, {'C','B'}, 'drawProportional', true,'showintersectioncounts',true);
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_BCVenn']),'pdf');
% 
% ACells = activeCells(:,9);
% DCells = activeCells(:,12);
% AonlyCells=ACells&~DCells;
% DonlyCells=DCells&~ACells;
% overlapCells = ACells&DCells;
% 
% setLabels = {"A:Info Water"; "D:No Info";};
% cells=sum([AonlyCells DonlyCells])/a.neuronCt;
% 
% vennPlot{1}=find(ACells);
% vennPlot{2}=find(DCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % nsubplot(1,1,1,1);
% % [H,S]=venn([sum(CCells) sum(DCells)],sum(overlapCells));
% %   for i = 1:2
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
% %   end
% % text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % % axis square;
% 
% h=vennEulerDiagram(fig,vennPlot, {'A','D'}, 'drawProportional', true,'showintersectioncounts',true);
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ADVenn']),'pdf');
% 
% BDiffCells = differentCells(:,8);
% ADiffCells = differentCells(:,9);
% 
% vennPlot{1}=find(BDiffCells);
% vennPlot{2}=find(ADiffCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % nsubplot(1,1,1,1);
% % [H,S]=venn([sum(CCells) sum(DCells)],sum(overlapCells));
% %   for i = 1:2
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
% %   end
% % text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % % axis square;
% 
% h=vennEulerDiagram(fig,vennPlot, {'B-C','A-D'}, 'drawProportional', true,'showintersectioncounts',true);
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_SideOdorsVenn']),'pdf');
% 
% %% INFO WATER
% 
% bigCells = activeCells(:,13);
% smallCells = activeCells(:,14);
% 
% setLabels = {"Water"; "No Water";};
% 
% vennPlot{1}=find(bigCells);
% vennPlot{2}=find(smallCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% 
% h=vennEulerDiagram(fig,vennPlot, setLabels, 'drawProportional', true,'showintersectioncounts',true);
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoWaterVenn']),'pdf');
% 
% %% RAND WATER
% 
% bigCells = activeCells(:,15);
% smallCells = activeCells(:,16);
% 
% setLabels = {"Water"; "No Water";};
% 
% vennPlot{1}=find(bigCells);
% vennPlot{2}=find(smallCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% 
% h=vennEulerDiagram(fig,vennPlot, setLabels, 'drawProportional', true,'showintersectioncounts',true);
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_RandWaterVenn']),'pdf');
% 
% %% WATER DIFFERENCE
% 
% infowaterCells = differentCells(:,6);
% randwaterCells = differentCells(:,7);
% 
% setLabels = {"Info Water"; "No Info Water";};
% 
% vennPlot{1}=find(infowaterCells);
% vennPlot{2}=find(randwaterCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% 
% h=vennEulerDiagram(fig,vennPlot, setLabels, 'drawProportional', true,'showintersectioncounts',true);
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_WaterVenn']),'pdf');
% 
% %% WATER
% infowaterCells = activeCells(:,13);
% randwaterCells = activeCells(:,15);
% 
% setLabels = {"Info Water"; "No Info Water";};
% 
% vennPlot{1}=find(infowaterCells);
% vennPlot{2}=find(randwaterCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% 
% h=vennEulerDiagram(fig,vennPlot, setLabels, 'drawProportional', true,'showintersectioncounts',true);
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_WaterVenn']),'pdf');
% 
% %%
% forcedCells = activeCellsRS(:,5);
% choiceCells = activeCellsRS(:,6);
% forcedOnlyCells=forcedCells&~choiceCells;
% choiceOnlyCells=choiceCells&~forcedCells;
% overlapCells = forcedCells&choiceCells;
% 
% setLabels = {"Info Forced"; "Info Choice";};
% cells=sum([forcedOnlyCells choiceOnlyCells])/a.neuronCt;
% 
% vennPlot{1}=find(forcedCells);
% vennPlot{2}=find(choiceCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % nsubplot(1,1,1,1);
% % [H,S]=venn([sum(forcedCells) sum(choiceCells)],sum(overlapCells));
% %   for i = 1:2
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
% %   end
% % text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % axis square;
% h=vennEulerDiagram(vennPlot, {'InfoForced','InfoChoice'}, 'drawProportional', true,'showintersectioncounts',true);
% 
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ForcedChoiceVenn']),'pdf');
% 
% 
% %%
% infoCells = activeCells(:,5);
% randCells = activeCells(:,7);
% infoOnlyCells=infoCells&~randCells;
% randOnlyCells=randCells&~infoCells;
% overlapCells = infoCells&randCells;
% 
% setLabels = {"Info Forced"; "No Info Forced";};
% % cells=sum([infoOnlyCells randOnlyCells])/a.neuronCt;
% % 
% % figure();
% % fig = gcf;
% % fig.PaperUnits = 'inches';
% % set(fig,'PaperOrientation','landscape');
% % fig.PaperSize = [11 8.5];
% % fig.PaperPosition = [0 0 10 8];
% % nsubplot(1,1,1,1);
% % [H,S]=venn([sum(infoCells) sum(randCells)],sum(overlapCells));
% %   for i = 1:2
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
% %   end
% % text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells)/a.neuronCt)])
% % % axis square;
% % saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoNoInfoVenn']),'pdf');
% 
% % %%
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % ax=nsubplot(1,1,1,1); hold off;
% 
% vennPlot{1}=find(infoCells);
% vennPlot{2}=find(randCells);
% 
% h=vennEulerDiagram(fig,vennPlot, {'Info','No Info'}, 'drawProportional', true,'showintersectioncounts',true);
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoNoInfoVenn']),'pdf');
% 
% %%
% infoLeftCells = activeCells(:,1);
% infoRightCells = activeCells(:,2);
% randLeftCells = activeCells(:,3);
% randRightCells = activeCells(:,4);
% ILonly=sum(infoLeftCells&~infoRightCells&~randLeftCells&~randRightCells)
% IRonly=sum(~infoLeftCells&infoRightCells&~randLeftCells&~randRightCells)
% NLonly=sum(~infoLeftCells&~infoRightCells&randLeftCells&~randRightCells)
% NRonly=sum(~infoLeftCells&~infoRightCells&~randLeftCells&randRightCells)
% 
% % %%
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % ax=nsubplot(1,1,1,1); hold off;
% 
% vennPlot{1}=find(infoLeftCells);
% vennPlot{2}=find(infoRightCells);
% vennPlot{3}=find(randLeftCells);
% vennPlot{4}=find(randRightCells);
% 
% h=vennEulerDiagram(fig,vennPlot, {'InfoL','InfoR','NoInfoL','NoInfoR'}, 'drawProportional', true,'showintersectioncounts',true);
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoNoInfobySideVenn']),'pdf');
% 
% %%
% 
% shuffleCells= [a.C_condShuffleDifferent{:}];
% shuffleCells=shuffleCells(:,2);
% RSCells= [a.C_condRSdifferent{:}];
% RSCells=RSCells(:,2);
% 
% RSOnly=RSCells&~shuffleCells;
% shuffleOnly=shuffleCells&~RSCells;
% overlapCells = shuffleCells&RSCells;
% 
% setLabels = {"RS"; "Shuffle";};
% cells=sum([RSOnly shuffleOnly]);
% 
% vennPlot{1}=find(RSCells);
% vennPlot{2}=find(shuffleCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % nsubplot(1,1,1,1);
% % [H,S]=venn([sum(RSCells) sum(shuffleCells)],sum(overlapCells));
% %   for i = 1:2
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))])
% %   end
% % text(S.ZoneCentroid(3,1), S.ZoneCentroid(3,2), ['Both ' num2str(sum(overlapCells))])
% 
% h=vennEulerDiagram(fig,vennPlot, {'RS','Shuffle'}, 'drawProportional', true,'showintersectioncounts',true);
% 
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_DiffInfoVenn']),'pdf');
% 
% 
% %%
% 
% diffCells = shuffleCells;
% infoCells = activeCells(:,5);
% randCells = activeCells(:,7);
% infoOnly=infoCells&~randCells&~diffCells;
% randOnly=randCells&~infoCells&~diffCells;
% diffOnly=diffCells&~infoCells&~randCells;
% overlap3Cells = diffCells&infoCells&randCells;
% overlap12Cells = diffCells&infoCells&~randCells;
% overlap13Cells = diffCells&randCells&~infoCells;
% overlap23Cells = infoCells&randCells&~diffCells;
% 
% setLabels = {"Difference"; "Info"; "No Info"};
% cells=sum([diffOnly infoOnly randOnly]);
% 
% vennPlot{1}=find(infoCells);
% vennPlot{2}=find(randCells);
% vennPlot{3}=find(diffCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% 
% % [H,S]=venn([sum(diffCells) sum(infoCells) sum(randCells)],[sum(overlap12Cells),sum(overlap13Cells),sum(overlap23Cells),sum(overlap3Cells)]);
% %   for i = 1:3
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))]);
% %   end
% % text(S.ZoneCentroid(4,1), S.ZoneCentroid(4,2), num2str(sum(overlap12Cells)));
% % text(S.ZoneCentroid(5,1), S.ZoneCentroid(5,2), num2str(sum(overlap13Cells)));
% % text(S.ZoneCentroid(6,1), S.ZoneCentroid(6,2), num2str(sum(overlap23Cells)));
% % text(S.ZoneCentroid(7,1), S.ZoneCentroid(7,2), num2str(sum(overlap3Cells)));
% 
% h=vennEulerDiagram(fig,vennPlot, {'Info','No Info','Different'}, 'drawProportional', true,'showintersectioncounts',true);
% 
% % axis square;
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AllInfoVenn']),'pdf');
% 
% vennPlot=[];
% 
% %%
% infoCSCells = differentCells(:,2);
% waterCSCells = differentCells(:,3);
% waterUSCells = differentCells(:,7);
% 
% vennPlot{1}=find(infoCSCells);
% vennPlot{2}=find(waterCSCells);
% vennPlot{3}=find(waterUSCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % 
% % [H,S]=venn([sum(infoCells) sum(waterCSCells) sum(waterCells)],[sum(overlap12Cells),sum(overlap13Cells),sum(overlap23Cells),sum(overlap3Cells)]);
% %   for i = 1:3
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))]);
% %   end
% % text(S.ZoneCentroid(4,1), S.ZoneCentroid(4,2), num2str(sum(overlap12Cells)/a.neuronCt));
% % text(S.ZoneCentroid(5,1), S.ZoneCentroid(5,2), num2str(sum(overlap13Cells)/a.neuronCt));
% % text(S.ZoneCentroid(6,1), S.ZoneCentroid(6,2), num2str(sum(overlap23Cells)/a.neuronCt));
% % text(S.ZoneCentroid(7,1), S.ZoneCentroid(7,2), num2str(sum(overlap3Cells)/a.neuronCt));
% % % axis square;
% h=vennEulerDiagram(fig,vennPlot, {'InfoCS','WaterCS','WaterUS'}, 'drawProportional', true,'showintersectioncounts',true);
% vennPlot=[];
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AllValuesVenn']),'pdf');
% 
% 
% ACells = activeCells(:,9);
% BCells = activeCells(:,10);
% infoCSCells = differentCells(:,2);
% % infoCSCells = activeCellsRS(:,5);
% waterCSCells = differentCells(:,3);
% waterUSCells = differentCells(:,7);
% infoUSCells = ACells&BCells;
% 
% vennPlot{1}=find(infoCSCells);
% vennPlot{2}=find(waterCSCells);
% vennPlot{3}=find(waterUSCells);
% vennPlot{4}=find(infoUSCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % 
% % [H,S]=venn([sum(infoCells) sum(waterCSCells) sum(waterCells)],[sum(overlap12Cells),sum(overlap13Cells),sum(overlap23Cells),sum(overlap3Cells)]);
% %   for i = 1:3
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))]);
% %   end
% % text(S.ZoneCentroid(4,1), S.ZoneCentroid(4,2), num2str(sum(overlap12Cells)/a.neuronCt));
% % text(S.ZoneCentroid(5,1), S.ZoneCentroid(5,2), num2str(sum(overlap13Cells)/a.neuronCt));
% % text(S.ZoneCentroid(6,1), S.ZoneCentroid(6,2), num2str(sum(overlap23Cells)/a.neuronCt));
% % text(S.ZoneCentroid(7,1), S.ZoneCentroid(7,2), num2str(sum(overlap3Cells)/a.neuronCt));
% % % axis square;
% h=vennEulerDiagram(fig,vennPlot, {'InfoCS','WaterCS','WaterUS','InfoUS'}, 'drawProportional', true,'showintersectioncounts',true);
% vennPlot=[];
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AllValuesVenn']),'pdf');
% 
% 
% %% ALL VALUES 2
% infoCSCells = activeCells(:,5); % infoforced
% waterCSCells = activeCells(:,9); %A
% infoUSCells = activeCells(:,10); %B
% waterUSCells = activeCells(:,15); % no info water
% 
% vennPlot{1}=find(infoCSCells);
% vennPlot{3}=find(waterCSCells);
% vennPlot{2}=find(infoUSCells);
% vennPlot{4}=find(waterUSCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % 
% % [H,S]=venn([sum(infoCells) sum(waterCSCells) sum(waterCells)],[sum(overlap12Cells),sum(overlap13Cells),sum(overlap23Cells),sum(overlap3Cells)]);
% %   for i = 1:3
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))]);
% %   end
% % text(S.ZoneCentroid(4,1), S.ZoneCentroid(4,2), num2str(sum(overlap12Cells)/a.neuronCt));
% % text(S.ZoneCentroid(5,1), S.ZoneCentroid(5,2), num2str(sum(overlap13Cells)/a.neuronCt));
% % text(S.ZoneCentroid(6,1), S.ZoneCentroid(6,2), num2str(sum(overlap23Cells)/a.neuronCt));
% % text(S.ZoneCentroid(7,1), S.ZoneCentroid(7,2), num2str(sum(overlap3Cells)/a.neuronCt));
% % % axis square;
% h=vennEulerDiagram(fig,vennPlot, {'Info act','A act','B act','Water act'}, 'drawProportional', true,'showintersectioncounts',true);
% vennPlot=[];
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AllValuesVenn2']),'pdf');
% 
% %% ALL VALUES 3
% infoCSCells = differentCells(:,2); % infoforced
% waterCSCells = differentCells(:,3); %A
% infoUSCells = activeCells(:,10); %B
% waterUSCells = activeCells(:,15); % no info water
% 
% vennPlot{1}=find(infoCSCells);
% vennPlot{3}=find(waterCSCells);
% vennPlot{2}=find(infoUSCells);
% vennPlot{4}=find(waterUSCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % 
% % [H,S]=venn([sum(infoCells) sum(waterCSCells) sum(waterCells)],[sum(overlap12Cells),sum(overlap13Cells),sum(overlap23Cells),sum(overlap3Cells)]);
% %   for i = 1:3
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))]);
% %   end
% % text(S.ZoneCentroid(4,1), S.ZoneCentroid(4,2), num2str(sum(overlap12Cells)/a.neuronCt));
% % text(S.ZoneCentroid(5,1), S.ZoneCentroid(5,2), num2str(sum(overlap13Cells)/a.neuronCt));
% % text(S.ZoneCentroid(6,1), S.ZoneCentroid(6,2), num2str(sum(overlap23Cells)/a.neuronCt));
% % text(S.ZoneCentroid(7,1), S.ZoneCentroid(7,2), num2str(sum(overlap3Cells)/a.neuronCt));
% % % axis square;
% h=vennEulerDiagram(fig,vennPlot, {'InfoDiff','A diff','B act','Water act'}, 'drawProportional', true,'showintersectioncounts',true);
% vennPlot=[];
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AllValuesVenn3']),'pdf');
% 
% %% ALL VALUES 4
% infoCSCells = differentCells(:,2); % infoforced
% waterCSCells = differentCells(:,3); %A
% infoUSCells = differentCells(:,9)&a.activityPostDiff{5}>0; % AB v CD
% waterUSCells = differentCells(:,7); % no info water
% 
% vennPlot{1}=find(infoCSCells);
% vennPlot{3}=find(waterCSCells);
% vennPlot{2}=find(infoUSCells);
% vennPlot{4}=find(waterUSCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % 
% % [H,S]=venn([sum(infoCells) sum(waterCSCells) sum(waterCells)],[sum(overlap12Cells),sum(overlap13Cells),sum(overlap23Cells),sum(overlap3Cells)]);
% %   for i = 1:3
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))]);
% %   end
% % text(S.ZoneCentroid(4,1), S.ZoneCentroid(4,2), num2str(sum(overlap12Cells)/a.neuronCt));
% % text(S.ZoneCentroid(5,1), S.ZoneCentroid(5,2), num2str(sum(overlap13Cells)/a.neuronCt));
% % text(S.ZoneCentroid(6,1), S.ZoneCentroid(6,2), num2str(sum(overlap23Cells)/a.neuronCt));
% % text(S.ZoneCentroid(7,1), S.ZoneCentroid(7,2), num2str(sum(overlap3Cells)/a.neuronCt));
% % % axis square;
% h=vennEulerDiagram(fig,vennPlot, {'InfoDiff','AB>CD','A diff','Water diff'}, 'drawProportional', true,'showintersectioncounts',true);
% vennPlot=[];
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AllValuesVenn4']),'pdf');
% 
% %% ALL VALUES 5
% infoCSCells = differentCells(:,2); % infoforced
% waterCSCells = differentCells(:,3); %A
% infoUSPosCells = differentCells(:,9)&a.activityPostDiff{5}>0; % AB v CD
% infoUSNegCells = differentCells(:,9)&a.activityPostDiff{5}<0; % AB v CD
% waterUSCells = differentCells(:,7); % no info water
% 
% vennPlot{1}=find(infoCSCells);
% vennPlot{3}=find(waterCSCells);
% vennPlot{2}=find(infoUSPosCells);
% vennPlot{4}=find(infoUSNegCells);
% vennPlot{5}=find(waterUSCells);
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% set(fig,'PaperOrientation','landscape');
% fig.PaperSize = [11 8.5];
% fig.PaperPosition = [0 0 10 8];
% % 
% % [H,S]=venn([sum(infoCells) sum(waterCSCells) sum(waterCells)],[sum(overlap12Cells),sum(overlap13Cells),sum(overlap23Cells),sum(overlap3Cells)]);
% %   for i = 1:3
% %       text(S.ZoneCentroid(i,1), S.ZoneCentroid(i,2), [setLabels{i} num2str(cells(i))]);
% %   end
% % text(S.ZoneCentroid(4,1), S.ZoneCentroid(4,2), num2str(sum(overlap12Cells)/a.neuronCt));
% % text(S.ZoneCentroid(5,1), S.ZoneCentroid(5,2), num2str(sum(overlap13Cells)/a.neuronCt));
% % text(S.ZoneCentroid(6,1), S.ZoneCentroid(6,2), num2str(sum(overlap23Cells)/a.neuronCt));
% % text(S.ZoneCentroid(7,1), S.ZoneCentroid(7,2), num2str(sum(overlap3Cells)/a.neuronCt));
% % % axis square;
% h=vennEulerDiagram(fig,vennPlot, {'InfoDiff','AB>CD','A diff','CD>AB','Water diff'}, 'drawProportional', true,'showintersectioncounts',true);
% vennPlot=[];
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_AllValuesVenn5']),'pdf');
% 
% %% CORRELATIONS
% 
% %% FIGURE 1 VARIANCE EXPLAINED
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 11 8.5];
% set(fig,'PaperOrientation','landscape');
% 
% nsubplot(2,1,1,1);
% plot(LIN(1:10),'bo','linewidth',2);
% xlabel('Info-NoInfo PC')
% ylabel('percent variance')
% title(strjoin(mice,' _ '))
% xlim([0 10])
% 
% nsubplot(2,1,2,1);
% plot(LLR(1:10),'bo','linewidth',2);
% xlabel('Left-Right PC')
% ylabel('percent variance')
% title([mice{1} ' _ ' strjoin(days{1},' _ ')])
% xlim([0 10])
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_VarianceExplained']),'pdf'); 
% 
% %% FIGURE 2 ACTIVITY PROJECTED TO PC
% 
% yMax = [5];
% yMin = [-5];
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 8.5 11];
% set(fig,'PaperOrientation','portrait');
% nsubplot(2,1,1,1);
% plot(iStart:iStop,UIN(:,1)'*rI,'Color',a.purple,'linewidth',2);
% hold on
% plot(iStart:iStop,UIN(:,1)'*rN,'Color',a.orange,'linewidth',2);
% plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
% plot([40 40],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% plot([44 44],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% hold off;
% xlim([iStart iStop]);
% % ylim([yMin(1) yMax(1)]);
% xlabel('time')
% ylabel('PC1 Proejction')
% title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
% legend('Info','No Info','location','northwest');
% nsubplot(2,1,2,1);
% plot(iStart:iStop,ULR(:,1)'*rL,'b','linewidth',2);
% hold on
% plot(iStart:iStop,ULR(:,1)'*rR,'r','linewidth',2);
% plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
% plot([40 40],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% plot([44 44],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% hold off;
% xlim([iStart iStop]);
% % ylim([yMin(1) yMax(1)]);
% xlabel('time')
% ylabel('PC1 Projection')
% title(['Left-Right  ' num2str(LLR(1)) '% of variance'])
% legend('Left','Right','location','northwest')
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.96,[strjoin(mice,' _ ')],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_ActivitybyPC']),'pdf');
% 
% %% FIGURE 3 DIFFERENCE VS SIGNIFICANCE
% 
% figure()
% fig=gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 11 8.5];
% set(fig,'PaperOrientation','landscape');
% nsubplot(2,1,1,1);
% bar(NeuronAreas(iASort),'b')
% hold on
% plot([0 N], [NeuronAreas(iASort(nSig+1)) NeuronAreas(iASort(nSig+1))],...
%     'r','linewidth',2);
% hold off
% xlabel('neuron rank')
% ylabel('mean Difference')
% nsubplot(2,1,2,1);
% bar(pNeurons(iASort),'b')
% hold on
% plot([0 N], [5 5], 'r','linewidth',2);
% hold off
% ylim([0 100])
% xlabel('neuron rank')
% ylabel('p (percent)')
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.96,[strjoin(mice,' _ '),' Info-No Info by signficance'],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_INdiffvssig']),'pdf');
%     
% %% FIGURE 4 WEIGHTS
% 
% figure()
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 11 8.5];
% set(fig,'PaperOrientation','landscape');
% nsubplot(3,1,1,1);
% bar(UINSort)
% xlim([0.5 N+0.5])
% xlabel('neuron')
% ylabel('weight')
% title('Info-NoInfo PC1')
% nsubplot(3,1,2,1);
% bar(ULRSort)
% xlim([0.5 N+0.5])
% xlabel('neuron')
% ylabel('weight')
% title('Left-Right PC1')
% nsubplot(3,1,3,1);
% bar(wSort)
% xlim([0.5 N+0.5])
% xlabel('neuron')
% ylabel('weight')
% title('Info-No Info Decode')
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_PC',num2str(PC),'weights']),'pdf');
% 
% %% FIGURE 4 CORRELATIONS
% 
% figure()
% fig=gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 11 8.5];
% set(fig,'PaperOrientation','landscape');
% 
% ax1=nsubplot(2,2,1,1);
% plot(ULR(:,1),UIN(:,1),'bo','linewidth',2)
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% xlabel('Left-Right Weight')
% ylabel('Info-NoInfo Weight')
% title(['Correlation = ' num2str(correlations(1)) 'p=' num2str(corrpvals(1))])
% xlim([-0.5 0.5])
% ylim([-0.5 0.5])
% ax2=nsubplot(2,2,1,2);
% plot(UIN(ismember(a.mouse,okMice),1),wDecode,'bo','linewidth',2)
% plot(ax2,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax2,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% xlabel('Info-NoInfo Weight')
% ylabel('Decode Weight')
% xlim([-0.5 0.5])
% ylim([-0.5 0.5])
% title(['Correlation = ' num2str(correlations(2)) 'p=' num2str(corrpvals(2))])
% ax3=nsubplot(2,2,2,1);
% plot(ULR(ismember(a.mouse,okMice),1),wDecode,'bo','linewidth',2)
% plot(ax3,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax3,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% xlabel('Left-Right Weight')
% ylabel('Decode Weight')
% xlim([-0.5 0.5])
% ylim([-0.5 0.5])
% title(['Correlation = ' num2str(correlations(3)) 'p=' num2str(corrpvals(3))])
% ax4=nsubplot(2,2,2,2);
% plot(UIN(:,1),mean(rIN,2),'bo','linewidth',2)
% plot(ax4,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax4,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
% xlabel('Difference Amplitude')
% ylabel('Info-No Info Weight')
% xlim([-0.5 0.5])
% ylim([-0.5 0.5])
% title(['Correlation = ' num2str(correlations(4)) 'p=' num2str(corrpvals(4))])
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.96, strjoin(mice,' _ '),'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_correlations']),'pdf');
% 
% %% FIGURE 7 SIDE ODOR VARIANCE
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 11 8.5];
% set(fig,'PaperOrientation','landscape');
% 
% nsubplot(2,1,1,1);
% plot(LAB(1:10),'bo','linewidth',2);
% xlabel('Odor A-Odor B PC')
% ylabel('percent variance')
% title([mice{1} ' _ ' strjoin(days{1},' _ ')])
% xlim([0 10])
% 
% nsubplot(2,1,2,1);
% plot(LCD(1:10),'bo','linewidth',2);
% xlabel('Odor C-Odor D PC')
% ylabel('percent variance')
% title([mice{1} ' _ ' strjoin(days{1},' _ ')])
% xlim([0 10])
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_side_VarianceExplained']),'pdf');
% 
% %% FIGURE 8 SIDE ODOR PC PROJECTION
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 8.5 11];
% set(fig,'PaperOrientation','portrait');
% nsubplot(2,1,1,1);
% plot(iStart:iStop,UAB(:,1)'*rA,'Color','g','linewidth',2);
% hold on
% plot(iStart:iStop,UAB(:,1)'*rB,'Color','m','linewidth',2);
% plot([40 40],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% plot([44 44],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% hold off;
% xlim([iStart iStop]);
% y1=ylim;
% % ylim([yMin(1) yMax(1)]);
% xlabel('time')
% ylabel('PC1 Projection')
% title(['A-B  ' num2str(LAB(1)) '% of variance']);
% legend('Odor A','Odor B','location','northwest');
% nsubplot(2,1,2,1);
% plot(iStart:iStop,UCD(:,1)'*rC,'b','linewidth',2);
% hold on
% plot(iStart:iStop,UCD(:,1)'*rD,'r','linewidth',2);
% plot([40 40],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% plot([44 44],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% hold off;
% xlim([iStart iStop]);
% ylim([-inf y1(2)]);
% xlabel('time')
% ylabel('PC1 Projection')
% title(['C-D  ' num2str(LCD(1)) '% of variance'])
% legend('Odor C','Odor D','location','northwest')
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.96,[mice{1},' _ ',strjoin(days{1},' _ ')],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_side_ActivitybyPC']),'pdf');
% 
% %% FIGURE 9 SIDE ODOR WEIGHTS
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 11 8.5];
% set(fig,'PaperOrientation','landscape');
% nsubplot(2,1,1,1);
% bar(UABSort)
% xlim([0.5 N+0.5])
% xlabel('neuron')
% ylabel('weight')
% title('A-B PC1')
% nsubplot(2,1,2,1);
% bar(UCDSort)
% xlim([0.5 N+0.5])
% xlabel('neuron')
% ylabel('weight')
% title('C-D PC1')
% 
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.96,[mice{1},' _ ',strjoin(days{1},' _ ')],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PC+decode_side_PC',num2str(PC),'weights']),'pdf');

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
Aresp=mean(squeeze(mean(a.C_odor2A(:,44:64,:),3,'omitnan')),2,'omitnan');
Bresp=mean(squeeze(mean(a.C_odor2B(:,44:64,:),3,'omitnan')),2,'omitnan');

[ABcorr, ABp] = corr(Aresp,Bresp);

Arespsub=mean(squeeze(mean(a.C_odor2A(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor2A(:,30:40,:),3,'omitnan')),2,'omitnan');
Brespsub=mean(squeeze(mean(a.C_odor2B(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor2B(:,30:40,:),3,'omitnan')),2,'omitnan');

[ABcorrsub, ABpsub] = corr(Arespsub,Brespsub);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,13)==1&~activeCellsRS(:,14)==1)={'A Sig'};
sig1(activeCellsRS(:,14)==1&~activeCellsRS(:,13)==1)={'B Sig'};
sig1(activeCellsRS(:,14)&activeCellsRS(:,3))={'Both Sig'};

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
sig1(activeCellsRS(:,15)==1&~activeCellsRS(:,16)==1)={'A Sig'};
sig1(activeCellsRS(:,16)==1&~activeCellsRS(:,15)==1)={'B Sig'};
sig1(activeCellsRS(:,15)&activeCellsRS(:,16))={'Both Sig'};

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
sig1(activeCellsRS(:,13)==1&activeCellsRS(:,14)&~activeCellsRS(:,15)&~activeCellsRS(:,16))={'AB Sig'};
sig1(~activeCellsRS(:,13)&~activeCellsRS(:,14)&activeCellsRS(:,15)&activeCellsRS(:,16))={'CD Sig'};
sig1(activeCellsRS(:,13)&activeCellsRS(:,14)&activeCellsRS(:,15)&activeCellsRS(:,16))={'Both Sig'};

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



%% INFO A CORRELATION
Aresp=mean(squeeze(mean(a.C_odor2A(:,44:64,:),3,'omitnan')),2,'omitnan');
Inforesp=mean(squeeze(mean(a.C_odor1InfoFirst(:,44:64,:),3,'omitnan')),2,'omitnan');

[InfoAcorr, InfoAp] = corr(Aresp,Inforesp);

Arespsub=mean(squeeze(mean(a.C_odor2A(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor2A(:,30:40,:),3,'omitnan')),2,'omitnan');
Inforespsub=mean(squeeze(mean(a.C_odor1InfoFirst(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1InfoFirst(:,30:40,:),3,'omitnan')),2,'omitnan');
% InfoForcedrespsub=mean(squeeze(mean(a.C_odor1InfoFirst(:,44:64,:),3,'omitnan')),2,'omitnan')-mean(squeeze(mean(a.C_odor1InfoFirst(:,30:40,:),3,'omitnan')),2,'omitnan');


[InfoAcorrsub, InfoApsub] = corr(Arespsub,Inforespsub);

sig1=cell(a.neuronCt,1);
sig1(:)={'NS'};
sig1(activeCellsRS(:,9)==1&~activeCellsRS(:,13)==1)={'Info Sig'};
sig1(activeCellsRS(:,13)==1&~activeCellsRS(:,9)==1)={'A Sig'};
sig1(activeCellsRS(:,13)&activeCellsRS(:,9))={'Both Sig'};

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

% %% DECODING FOR EACH COMP
% 
% %% LEAVING
% 
% %% CONDITIONS
% % 
% % y1=mean(a.C_odor1InfoFirst{1},3,'omitnan');
% % size(y1)
% % y2=mean(a.C_odor1RandFirst{1},3,'omitnan');
% % y1mean=mean(y1,1);
% % y2mean=mean(y2,1);
% % ydiff=abs(y1-y2);
% % size(ydiff)
% % cond1=mean(ydiff,1);
% % y1=mean(a.C_odor1InfoFirst{2},3,'omitnan');
% % y2=mean(a.C_odor1RandFirst{2},3,'omitnan');
% % ydiff=abs(y1-y2);
% % cond2=mean(ydiff,1);
% % figure();hold on; plot(cond1);
% % plot(cond2)
% 
% %% PC PROJECTION
% 
% rI=mean(a.C_odor1InfoFirst(:,iStart:iStop,:),3,'omitnan');
% rN=mean(a.C_odor1RandFirst(:,iStart:iStop,:),3,'omitnan');
% rI=rI-rI(:,1);
% rN=rN-rN(:,1);
% 
% rIN = rI-rN;
% [UIN SIN VIN] = svd(rIN);
% LIN = diag(SIN).^2;
% LIN = 100*LIN/sum(LIN);
% 
% rI=mean(a.C_odor1InfoFirst,3,'omitnan');
% rN=mean(a.C_odor1RandFirst,3,'omitnan');
% rI=rI-mean(rI(:,30:40),2);
% rN=rN-mean(rN(:,30:40),2);
% 
% yMax = [5];
% yMin = [-5];
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 8.5 11];
% set(fig,'PaperOrientation','portrait');
% set(fig,'renderer','painters');
% 
% ax = nsubplot(1,1,1,1);
% hold on;
% h_for_legend=[];
% 
% for t=1:size(a.C_odor1InfoFirst,3)
%    tI=a.C_odor1InfoFirst(:,:,t);
%    tI=tI-mean(tI(:,30:40),2);
%    plot(a.t{e},UIN(:,1)'*tI,'Color','b','Linewidth',0.2)
%    tN=a.C_odor1RandFirst(:,:,t);
%    tN=tN-mean(tN(:,30:40),2);
%    plot(a.t{e},UIN(:,1)'*tN,'Color','r','Linewidth',0.2)
% end
% h_for_legend(end+1)=plot(a.t{e},UIN(:,1)'*rI,'Color','b','linewidth',6);
% h_for_legend(end+1)=plot(a.t{e},UIN(:,1)'*rN,'Color','r','linewidth',6);
% plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
% plot([0 0],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% hold off;
% xlim([-0.2 1.4]);
% % ylim([yMin(1) yMax(1)]);
% xlabel('Seconds since odor on')
% ylabel('PC1 Projection')
% % title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
% legend(h_for_legend,'Info','No Info','location','northwest');
% % axis square;
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.96,[strjoin(mice,' _ ')],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% % 
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PCprojection_INFO']),'pdf');
% 
% % ax = gca;
% exportgraphics(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PCprojection2_INFO.pdf']),'ContentType','vector')
% 
% 
% %% PC PROJECTION
% 
% rAB=mean(a.C_odor2info(:,iStart:iStop,:),3,'omitnan');
% rCD=mean(a.C_odor2rand(:,iStart:iStop,:),3,'omitnan');
% % rAB=rAB-rAB(:,1);
% % rCD=rCD-rCD(:,1);
% 
% rABCD = rAB-rCD;
% [UABCD SABCD VABCD] = svd(rABCD);
% LABCD = diag(SABCD).^2;
% LABCD = 100*LABCD/sum(LABCD);
% 
% rAB=mean(a.C_odor2info,3,'omitnan');
% rCD=mean(a.C_odor2rand,3,'omitnan');
% % rAB=rAB-mean(rAB(:,30:40),2);
% % rCD=rCD-mean(rCD(:,30:40),2);
% 
% yMax = [5];
% yMin = [-5];
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 8.5 11];
% set(fig,'PaperOrientation','portrait');
% set(fig,'renderer','painters');
% 
% ax = nsubplot(1,1,1,1);
% hold on;
% h_for_legend=[];
% 
% for t=1:size(a.C_odor2info,3)
%    tI=a.C_odor2info(:,:,t);
% %    tI=tI-mean(tI(:,30:40),2);
%    plot(a.t{e},UABCD(:,1)'*tI,'Color','b','Linewidth',0.2)
%    tN=a.C_odor2rand(:,:,t);
% %    tN=tN-mean(tN(:,30:40),2);
%    plot(a.t{e},UABCD(:,1)'*tN,'Color','r','Linewidth',0.2)
% end
% h_for_legend(end+1)=plot(a.t{e},UABCD(:,1)'*rAB,'Color','b','linewidth',6);
% h_for_legend(end+1)=plot(a.t{e},UABCD(:,1)'*rCD,'Color','r','linewidth',6);
% plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
% plot([0 0],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
% hold off;
% xlim([-0.2 1.4]);
% % ylim([yMin(1) yMax(1)]);
% xlabel('Seconds since odor on')
% ylabel('PC1 Projection')
% % title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
% legend(h_for_legend,'AB','CD','location','northwest');
% % axis square;
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.96,[strjoin(mice,' _ ')],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
% % 
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PCprojection_ABCD']),'pdf');
% 
% % ax = gca;
% exportgraphics(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PCprojection2_ABCD.pdf']),'ContentType','vector')
% 
% %% WHOLE TRIAL HEATMAPS
% 
% cell_sort_ids=INdiffIdx;
% % cell_sort_ids=WNdiffSort;
% e=11;
% cd = 1;
% cutoff=13;
% ctitle = a.titles{1};
% clabels = {'Info Water','Info No Water','No Info Water','No Info No Water'};
% cnames = {'C_trialInfoForcedBig','C_trialInfoForcedSmall','C_trialRandForcedBig','C_trialRandForcedSmall'};
% 
% figure();
% fig = gcf;
% fig.PaperUnits = 'inches';
% fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
% set(fig,'PaperOrientation','landscape');
% 
% for cd=1:2
%     ax = nsubplot(1,6,1,cd);
%     cname=cnames{cd};
%     y=mean(a.(cname),3,'omitnan');
%     t=a.t{e};
%     imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
% %     colorcet('D1');
%     plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
%     plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
%     plot([1.45 1.45],[-1 +1].*10^10,'w','yliminclude','off');
%     plot([1.65 1.65],[-1 +1].*10^10,'w','yliminclude','off');
%     plot([11.65 11.65],[-1 +1].*10^10,'w','yliminclude','off');
%     axis tight;
%         set(gca,'YDir','reverse')
% %         if cd == 1
% %             ylabel('Cell');
% %         end
% %         if cd > 1
%         ax.YAxis.Visible = 'off';
% %         end
%     xlim([-0.5 cutoff]);
%     xlabel('Seconds');
%     title(clabels(cd));
%     xticks([0:2:cutoff]); 
%     ax.FontSize = 8; 
% end
% 
% ax = nsubplot(1,6,1,3);
% y1=mean(a.C_trialInfoForcedSmall,3,'omitnan');
% y2=mean(a.C_trialInfoForcedBig,3,'omitnan');
% y=y2-y1;
% t=a.t{e};
% imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),diff_limits);
% % colorcet('D1');
% plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'w','yliminclude','off');
% plot([1.65 1.65],[-1 +1].*10^10,'w','yliminclude','off');
% plot([11.65 11.65],[-1 +1].*10^10,'w','yliminclude','off');
% axis tight;
%         set(gca,'YDir','reverse')
% %         if cd == 1
% %             ylabel('Cell');
% %         end
% %         if cd > 1
%     ax.YAxis.Visible = 'off';
% %         end
% xlim([-0.5 cutoff]);
% xlabel('Seconds');
% title('Info Water-Info No Water');
% xticks([0:2:cutoff]); 
% ax.FontSize = 8;         
% 
% for cd=3:4
%     ax = nsubplot(1,6,1,cd+1);
%     cname=cnames{cd};
%     y=mean(a.(cname),3,'omitnan');
%     t=a.t{e};
%     imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
% %     colorcet('D1');
%     plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
%     plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
%     plot([1.45 1.45],[-1 +1].*10^10,'w','yliminclude','off');
%     plot([1.65 1.65],[-1 +1].*10^10,'w','yliminclude','off');
%     plot([11.65 11.65],[-1 +1].*10^10,'w','yliminclude','off');
%     axis tight;
%         set(gca,'YDir','reverse')
% %         if cd == 1
% %             ylabel('Cell');
% %         end
% %         if cd > 1
%         ax.YAxis.Visible = 'off';
% %         end
%    xlim([-0.5 cutoff]);
%     xlabel('Seconds');
%     title(clabels(cd));
%     xticks([0:2:cutoff]); 
%     ax.FontSize = 8; 
% end
% 
% ax = nsubplot(1,6,1,6);
% y1=mean(a.C_trialRandForcedSmall,3,'omitnan');
% y2=mean(a.C_trialRandForcedBig,3,'omitnan');
% y=y2-y1;
% t=a.t{e};
% imagesc(t,1:size(y,1),y(cell_sort_ids(:,1),:),color_limits);
% % colorcet('D1');
% plot([0 0],[-1 +1].*10^10,'w','yliminclude','off');
% plot([0.2 0.2],[-1 +1].*10^10,'w','yliminclude','off');
% plot([1.45 1.45],[-1 +1].*10^10,'w','yliminclude','off');
% plot([1.65 1.65],[-1 +1].*10^10,'w','yliminclude','off');
% plot([11.65 11.65],[-1 +1].*10^10,'w','yliminclude','off');
% axis tight;
%         set(gca,'YDir','reverse')
% %         if cd == 1
% %             ylabel('Cell');
% %         end
% %         if cd > 1
%     ax.YAxis.Visible = 'off';
% %         end
% xlim([-0.5 cutoff]);
% xlabel('Seconds');
% title('No Info Water-No Info NoWater');
% xticks([0:2:cutoff]); 
% ax.FontSize = 8;
% 
% if RA==1
% colormap(a.ckr);
% else
% colorcet('D1')
% end
% 
% hold off;   
% ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
% text(0.5, 0.98,[strjoin(mice,' _ '),' Conditional Activity, sort by Info-No Info'],'FontSize',14,'FontWeight','bold','HorizontalAlignment','center');
% 
% saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_ConditionalActivity_Trial_byinfo-noinfo']),'pdf');


%%
y1=a.C_odor1InfoFirst;
e=3;
ypost1 = squeeze(mean(y1(:,a.okt{e},:),2,'omitnan'));
yactI=[];
y2=a.C_odor1RandFirst;
ypost2 = squeeze(mean(y2(:,a.okt{e},:),2,'omitnan'));
yactNI=[];
for m=1:max(a.mouse)
%    ym1=ypost1(a.mouse==m,:);
   ym1=mean(ypost1(a.mouse==m & a.differentCellsEBM(:,2)==1 ,:)); % info cells
   ym1=ym1(~isnan(ym1))';
   yactI=[yactI; ym1];
%    ym2=ypost2(a.mouse==m,:);
%    ym2=ypost2(a.mouse==m,:);
   ym2=mean(ypost2(a.mouse==m & a.differentCellsEBM(:,2)==1,:));
   ym2=ym2(~isnan(ym2))';
   yactNI=[yactNI; ym2];   
end

[r2I,pI]=corr(yactI,a.rxn(a.imagingChoice==2 & a.imagingPrevCorrect == 1),'Type','Spearman')
[r2NI,pNI]=corr(yactNI,a.rxn(a.imagingChoice==3 & a.imagingPrevCorrect == 1),'Type','Spearman')

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
scatter(a.rxn(a.imagingChoice==2 & a.imagingPrevCorrect == 1),yactI)
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Reaction Time')
ylabel('Mean Population Activity for Info Coding Cells')
xlim([0.2 4])
% ylim([0 1])
axis square
title(['Information Forced, Correlation = ' num2str(r2I) ' p = ' num2str(pI)])

ax1=nsubplot(1,2,1,2);
scatter(a.rxn(a.imagingChoice==3 & a.imagingPrevCorrect == 1),yactNI)
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Reaction Time')
ylabel('Mean Population Activity  for Info Coding Cells')
xlim([0.2 4])
% ylim([0 1])
axis square

title(['No Information Forced, Correlation = ' num2str(r2NI) ' p = ' num2str(pNI)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_RxnCorrelationInfoCellsSpearman']),'pdf');
%%

y1=a.C_odor1BigFirst;
e=3;
ypost1 = squeeze(mean(y1(:,a.okt{e},:),2,'omitnan'));
yactI=[];
y2=a.C_odor1SmallFirst;
ypost2 = squeeze(mean(y2(:,a.okt{e},:),2,'omitnan'));
yactNI=[];
for m=1:max(a.mouse)
%    ym1=ypost1(a.mouse==m,:);
   ym1=mean(ypost1(a.mouse==m & a.differentCellsEBM(:,2)==1 ,:)); % info cells
   ym1=ym1(~isnan(ym1))';
   yactI=[yactI; ym1];
%    ym2=ypost2(a.mouse==m,:);
%    ym2=ypost2(a.mouse==m,:);
   ym2=mean(ypost2(a.mouse==m & a.differentCellsEBM(:,2)==1,:));
   ym2=ym2(~isnan(ym2))';
   yactNI=[yactNI; ym2];   
end

[r2I,pI]=corr(yactI,a.rxn(a.imagingChoice==4 & a.imagingPrevCorrect == 1),'Type','Spearman')
[r2NI,pNI]=corr(yactNI,a.rxn(a.imagingChoice==1 & a.imagingPrevCorrect == 1),'Type','Spearman')

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');
ax1=nsubplot(1,2,1,1);
scatter(a.rxn(a.imagingChoice==4 & a.imagingPrevCorrect == 1),yactI)
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Reaction Time')
ylabel('Mean Population Activity for Info Coding Cells')
xlim([0.2 4])
% ylim([0 1])
axis square
title(['Big Water, Correlation = ' num2str(r2I) ' p = ' num2str(pI)])

ax1=nsubplot(1,2,1,2);
scatter(a.rxn(a.imagingChoice==1 & a.imagingPrevCorrect == 1),yactNI)
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Reaction Time')
ylabel('Mean Population Activity  for Info Coding Cells')
xlim([0.2 4])
% ylim([0 1])
axis square

title(['Small Water, Correlation = ' num2str(r2NI) ' p = ' num2str(pNI)])

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_RxnCorrelationInfoCellsWaterSpearman']),'pdf');

%% REPRESENTATION SIMILARITIES

infoR=mean(mean(a.C_odor1FirstInfoRight(:,a.okt{3},:),2,'omitnan'),3,'omitnan');
infoL=mean(mean(a.C_odor1FirstInfoLeft(:,a.okt{3},:),2,'omitnan'),3,'omitnan');
bigL=mean(mean(a.C_odor1FirstBigLeft(:,a.okt{3},:),2,'omitnan'),3,'omitnan');
bigR=mean(mean(a.C_odor1FirstBigRight(:,a.okt{3},:),2,'omitnan'),3,'omitnan');

%%
figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');

ax1=nsubplot(1,2,1,1);
[cc,p]=corr(infoL,bigL);
scatter(infoL,bigL);
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Left')
ylabel('Big Left')
% xlim([0.2 4])
% ylim([0 1])
axis square
title({'Info Left (preRev) vs Big Water Left (postRev),', 'Correlation = ' num2str(cc) ' p = ' num2str(p)})

ax1=nsubplot(1,2,1,2);
[cc,p]=corr(infoL,infoR);
scatter(infoL,infoR);
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Left')
ylabel('Info Right')
% xlim([0.2 4])
% ylim([0 1])
axis square
title({'Info Left (preRev) vs Info Right (postRev),', 'Correlation = ' num2str(cc) ' p = ' num2str(p)})

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoLBigCorrel']),'pdf');

figure()
fig=gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
set(fig,'PaperOrientation','landscape');

ax1=nsubplot(1,2,1,1);
[cc,p]=corr(infoR,bigR);
scatter(infoR,bigR);
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Right')
ylabel('Big Right')
% xlim([0.2 4])
% ylim([0 1])
axis square
title({'Info Right (preRev) vs Big Water Right (postRev),', 'Correlation = ' num2str(cc) ' p = ' num2str(p)})

ax1=nsubplot(1,2,1,2);
[cc,p]=corr(infoR,infoL);
scatter(infoR,infoL);
% plot(ax1,[0 0],[-1 +1].*10^10,'color','k','yliminclude','off');
% plot(ax1,[-1 +1].*10^10,[0 0],'color','k','xliminclude','off');
xlabel('Info Right')
ylabel('Info Left')
% xlim([0.2 4])
% ylim([0 1])
axis square
title({'Info Right (preRev) vs Info Left (postRev),', 'Correlation = ' num2str(cc) ' p = ' num2str(p)})

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_InfoRBigCorrel']),'pdf');

%% PCprojection PCA

e=3;
rI=mean(a.C_odor1InfoFirst(:,iStart:iStop,:),3,'omitnan');
rN=mean(a.C_odor1RandFirst(:,iStart:iStop,:),3,'omitnan');
rI=rI-rI(:,1);
rN=rN-rN(:,1);
rIN = rI-rN;
[UIN SIN VIN] = svd(rIN);
LIN = diag(SIN).^2;
LIN = 100*LIN/sum(LIN);
rI=mean(a.C_odor1InfoFirst,3,'omitnan');
rN=mean(a.C_odor1RandFirst,3,'omitnan');
rI=rI-mean(rI(:,30:40),2);
rN=rN-mean(rN(:,30:40),2);
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
for t=1:size(a.C_odor1InfoFirst,3)
tI=a.C_odor1InfoFirst(:,:,t);
tI=tI-mean(tI(:,30:40),2);
plot(a.t{e},UIN(:,1)'*tI,'Color','b','Linewidth',0.2)
tN=a.C_odor1RandFirst(:,:,t);
tN=tN-mean(tN(:,30:40),2);
plot(a.t{e},UIN(:,1)'*tN,'Color','r','Linewidth',0.2)
end
h_for_legend(end+1)=plot(a.t{e},UIN(:,1)'*rI,'Color','b','linewidth',6);
h_for_legend(end+1)=plot(a.t{e},UIN(:,1)'*rN,'Color','r','linewidth',6);
plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
plot([0 0],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
hold off;
xlim([-0.2 1.4]);
% ylim([yMin(1) yMax(1)]);
xlabel('Seconds since odor on')
ylabel('PC1 Projection')
% title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
legend(h_for_legend,'Info','No Info','location','northwest');
% axis square;
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96,[strjoin(mice,' _ ')],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PCprojection_INFO']),'pdf');

%%
rB=mean(a.C_odor1BigFirst(:,iStart:iStop,:),3,'omitnan');
rS=mean(a.C_odor1SmallFirst(:,iStart:iStop,:),3,'omitnan');
rB=rB-rB(:,1);
rS=rS-rS(:,1);
rBS = rB-rS;
[UBS SBS VBS] = svd(rBS);
LBS = diag(SBS).^2;
LBS = 100*LBS/sum(LBS);
rB=mean(a.C_odor1BigFirst,3,'omitnan');
rS=mean(a.C_odor1SmallFirst,3,'omitnan');
rB=rB-mean(rB(:,30:40),2);
rS=rS-mean(rS(:,30:40),2);
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
for t=1:size(a.C_odor1BigFirst,3)
tB=a.C_odor1BigFirst(:,:,t);
tB=tB-mean(tB(:,30:40),2);
plot(a.t{e},UBS(:,1)'*tB,'Color','b','Linewidth',0.2)
tS=a.C_odor1SmallFirst(:,:,t);
tS=tS-mean(tS(:,30:40),2);
plot(a.t{e},UBS(:,1)'*tS,'Color','r','Linewidth',0.2)
end
h_for_legend(end+1)=plot(a.t{e},UBS(:,1)'*rB,'Color','b','linewidth',6);
h_for_legend(end+1)=plot(a.t{e},UBS(:,1)'*rS,'Color','r','linewidth',6);
plot([-1 +1].*10^10,[0 0],'k','linewidth',1,'xliminclude','off');
plot([0 0],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
plot([0.2 0.2],[-1 +1].*10^10,'k','linewidth',1,'yliminclude','off');
hold off;
xlim([-0.2 1.4]);
% ylim([yMin(1) yMax(1)]);
xlabel('Seconds since odor on')
ylabel('PC1 Projection')
% title(['Info-NoInfo  ' num2str(LIN(1)) '% of variance',' p = ',num2str(pPC)]);
legend(h_for_legend,'Big','Small','location','northwest');
% axis square;
ha = axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0  1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text(0.5, 0.96,[strjoin(mice,' _ ')],'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
text(0.5, 0.04, alldays,'FontSize',12,'FontWeight','bold','HorizontalAlignment','center');
%
saveas(fig,fullfile(output_dir,[strjoin(mice,'_'),'_PCprojection_WATER']),'pdf');e