%% DATA FOLDER

% LOAD MODEL RESULTS


% datapath=uigetdir('','Choose data directory');
% datapath = 'D:\Dropbox\BpodInfoseek\Analysis\CombinedPipeline';

% datapath = 'D:\Bussell Dropbox\Jennifer Bussell\RajanCollaboration';
datapath = 'D:\Bussell Dropbox\Jennifer Bussell\BpodInfoseek\BehaviorModel\psycho';
% datapath = 'C:\Users\Axel\Bussell Dropbox\Bussell Lab\BpodInfoseek\';
% datapath = 'C:\Users\jbuss\Bussell Dropbox\Jennifer Bussell\RajanCollaboration';

plotfolder=fullfile(datapath,'Psychophysics');
pathname=plotfolder;

% % plotfolder
% if exist(fullfile(datapath,'plots'))
%     plotfolder=fullfile(datapath,'plots');
% else
%     mkdir(fullfile(datapath,'plots'))
%     plotfolder=fullfile(datapath,'plots');
% end

output_dir = plotfolder;

set(0,'DefaultFigureWindowStyle','docked'); % plot in docked window

%%
model = 5
isSEM = 0
testMice=[6 7 8 9 31 32 33 28 29 30];
%testMice=[31 32 33];
ymax = 1;
delayDiff = [1 4 6 10];
waterDiff = [1 2 3 4 5];
valDiff = [-3 -2 -1 0 1];

%%
addFitLines = 0
realChoicesAll=[]; modelChoicesAll=[];
vals=[];
valList=[];
valPref=[]; valErr=[]; valN=[];
valModelPref=[]; valModelErr=[];
mouseValPref=[];mouseValModel=[];
for v=1:numel(waterDiff)
    waterval=waterDiff(v);
    mouseRealChoices=[];realChoices=[];
    mouseModelChoices=[];modelChoices=[];
    waterValList=[];
    for mm=1:numel(testMice)
        m=testMice(mm);
        if m < 10
            mouseModelChoices=results.modelChoices{m}(results.waterValue{m}==waterval&results.delay{m}==10);
            mouseRealChoices=results.realChoices{m}(results.waterValue{m}==waterval&results.delay{m}==10);
        end
        if m > 10
            mouseModelChoices=results.modelChoices{m}(results.waterValue{m}==waterval&results.delay{m}==10);
            mouseRealChoices=results.realChoices{m}(results.waterValue{m}==waterval&results.delay{m}==10);
        end
        modelChoices=[modelChoices; mouseModelChoices];
        realChoices=[realChoices; mouseRealChoices];
        mouseValPref(mm,v)=mean(mouseRealChoices,'omitnan');
        mouseValModel(mm,v)=mean(mouseModelChoices,'omitnan');
    end
    realChoicesAll=[realChoicesAll; realChoices]; % add all trials across mice for that value
    modelChoicesAll=[modelChoicesAll;modelChoices];
    valList(1:numel(realChoices),1)=valDiff(v);
    vals=[vals; valList]; % add a value for all trials across mice

    valPref(v,1)=mean(realChoices);
    ts = tinv([0.025  0.975],length(realChoices)-1);
    valErr(v,1)=ts(2)*std(realChoices)/sqrt(length(realChoices));
    valErr(v,1)=std(realChoices);
    %[valPref(v,1),valErr(v,1:2)]=binofit(sum(realChoices==1),sum(~isnan(realChoices)));
    
    valModelPref(v,1)=mean(modelChoices);
    ts = tinv([0.025  0.975],length(modelChoices)-1);
    valModelErr(v,1)=ts(2)*std(modelChoices)/sqrt(length(modelChoices));
    valModelErr(v,1)=std(modelChoices);
    %[valModelPref(v,1),valModelErr(v,1:2)]=binofit(sum(modelChoices==1),sum(~isnan(modelChoices)));    
    valN(v,1)=sum(~isnan(realChoices));
end



%%

% % Create a new xAxis with higher resolution
% fineX = 0:1;
% % % Generate curve from fit
% curve = glmval(coeffs, fineX, 'logit');
% curve = [fineX', curve];
SPs = [0.6, 0.3, 1, 1; % Upper limits for g, l, u ,v
    0.1, 0.1, 0.5, 0.2; % Start points for g, l, u ,v
    0, 0.05, 0, 0]; % Lower limits for  g, l, u ,v
SPs = [0.9, 0.5, inf, inf;
    0.01, 0.01, 0.5, 0.1;
    0.2, 0, 0, 0];
[cfit, curve] = fitPsycheCurveWH (valDiff, valPref, SPs);
coeffs = coeffvalues(cfit);


modelSPs = [0.6, 0.3, 1, 1; % Upper limits for g, l, u ,v
    0.01, 0.05, 0.6, 0.2; % Start points for g, l, u ,v
    0, 0.05, 0, 0]; % Lower limits for  g, l, u ,v

SP2 = [0.5, 0.6, -1, 1;
    0.3, 0.2, -1.5, 0.1;
    0, 0, -1.5, 0.2];



modelSPs2 = [0.35, 0.1, 10, 10; % Upper limits for g, l, u ,v
    0.01, 0.05, 5, 1; % Start points for g, l, u ,v
    0, 0, 0, 0]; % Lower limits for  g, l, u ,v


[modelcfit, modelcurve] = fitPsycheCurveWH (valDiff(1:5), valModelPref(1:5), SP2);
[cfit, curve] = fitPsycheCurveWH (valDiff, valPref, SP2);
coeffs = coeffvalues(cfit);
h_for_legend=[];
figure();
fig = gcf;
hAx=gca;                    % create an axes
hAx.LineWidth=4;            % set the axis linewidth for box/ticks
%hAx.FontSize = 24;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');
nsubplot(1,1,1,1);
% scatter(valRatio,valPref)
hold on;
if addFitLines == 1
h_for_legend(end+1)=plot(curve(:,1),curve(:,2),'Color','k','LineWidth',5)
h_for_legend(end+1)=plot(modelcurve(:,1),modelcurve(:,2),'Color','r','LineWidth',5)
end
% for m=1:numel(a.valueMice)
for m=1:numel(testMice)
   if addFitLines == 1
   scatter(valDiff,mouseValPref(m,:),20,'filled','MarkerFaceColor','k') 
   scatter(valDiff,mouseValModel(m,:),20,'filled','MarkerFaceColor','r') 
   end
end

ts = tinv([0.025  0.975],7-1);
for v=1:numel(valDiff)
    if addFitLines == 1
    scatter(valDiff(v),mean(mouseValPref(1:(numel(testMice)-3),v)),40,'filled','MarkerFaceColor','k') 
    scatter(valDiff(v),mean(mouseValModel(1:(numel(testMice)-3),v)),40,'filled','MarkerFaceColor','r') 
    end

if isSEM == 0
    if addFitLines == 1
    errorbar(valDiff(v),mean(mouseValPref(1:(numel(testMice)-3),v)),ts(2)*std(mouseValPref(1:(numel(testMice)-3),v))/sqrt(numel(testMice)),"ok","MarkerSize",7,'MarkerFaceColor','k',"CapSize",10,'LineWidth',3)
    errorbar(valDiff(v),mean(mouseValModel(1:(numel(testMice)-3),v)),ts(2)*std(mouseValPref(1:(numel(testMice)-3),v))/sqrt(numel(testMice)),"ok","MarkerSize",7,'MarkerFaceColor','r',"CapSize",10,'LineWidth',3,'Color','r')
    end
    if addFitLines == 0
    errorbar(valDiff(v),mean(mouseValPref(1:(numel(testMice)-3),v)),ts(2)*std(mouseValPref(1:(numel(testMice)-3),v))/sqrt(numel(testMice)),"ok","MarkerSize",7,'MarkerFaceColor','k',"CapSize",10,'LineWidth',3)
    errorbar(valDiff(v),mean(mouseValModel(1:(numel(testMice)-3),v)),ts(2)*std(mouseValPref(1:(numel(testMice)-3),v))/sqrt(numel(testMice)),"ok","MarkerSize",7,'MarkerFaceColor','r',"CapSize",10,'LineWidth',3,'Color','r')
    end
end

if isSEM == 1
    if addFitLines == 1
    errorbar(valDiff(v),mean(mouseValPref(1:(numel(testMice)-3),v)),std(mouseValPref(1:(numel(testMice)-3),v))/sqrt(numel(testMice)),"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',3)
    errorbar(valDiff(v),mean(mouseValModel(1:(numel(testMice)-3),v)),std(mouseValPref(1:(numel(testMice)-3),v))/sqrt(numel(testMice)),"ok","MarkerSize",5,'MarkerFaceColor','r',"CapSize",10,'LineWidth',3,'Color','r')
    end
    if addFitLines == 0
    errorbar(valDiff(v),mean(mouseValPref(1:(numel(testMice)-3),v)),std(mouseValPref(1:(numel(testMice)-3),v))/sqrt(numel(testMice)),"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',3)
    errorbar(valDiff(v),mean(mouseValModel(1:(numel(testMice)-3),v)),std(mouseValPref(1:(numel(testMice)-3),v))/sqrt(numel(testMice)),"ok","MarkerSize",5,'MarkerFaceColor','r',"CapSize",10,'LineWidth',3,'Color','r')
    end
end

end
'Here'
valDiff
mouseValModel
% scatter(valRatio,valPref,40,'filled')
% errorbar(valRatio,valPref,valErr,"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
%errorbar(valDiff,valPref,valPref-valErr(:,1),valErr(:,2)-valPref,"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
%errorbar(valDiff,valModelPref,valModelPref-valModelErr(:,1),valModelErr(:,2)-valModelPref,"ok","MarkerSize",5,'MarkerFaceColor','r',"CapSize",10,'LineWidth',1,'Color','r')
%errorbar(valDiff,valPref,valErr,"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
%errorbar(valDiff,valModelPref,valModelErr,"ok","MarkerSize",5,'MarkerFaceColor','r',"CapSize",10,'LineWidth',1,'Color','r')
% di=refline([0 0.5]);
% d=refline([coeffs(3)]);
plot([-1 +1].*10^10,[0.5 0.5],'color','k','xliminclude','off');
xticks(valDiff)
xlim([min(valDiff)-0.25 max(valDiff)+0.25])
ylim([0 ymax])
axis square
xlabel('Water Value Differences','fontsize',26,'FontWeight','bold')
ylabel('Probability of Choosing Info','fontsize',26,'FontWeight','bold')
legend(h_for_legend,{'Real','Model'},'Orientation','vertical','Location','southeast','Box','off');
ax = gca;
ax.FontSize = 24; 
saveas(fig,fullfile(plotfolder,'ModeledWaterValue'),'pdf');


%%

% valDiff = [-3 -2 -1 0 1];
nMice_val = numel(testMice) - 3;
% ts = tinv([0.025 0.975], 7-1);

valDiff = [-3 -2 -1 0 1];  % reset to water value axis
waterDiff = [1 2 3 4 5];   % these are the actual filter values

wv_x         = valDiff;
wv_real_y    = mean(mouseValPref(1:nMice_val, :), 1);
wv_real_err  = ts(2) * std(mouseValPref(1:nMice_val, :), 0, 1) / sqrt(numel(testMice));
wv_model_y   = mean(mouseValModel(1:nMice_val, :), 1);
wv_model_err = ts(2) * std(mouseValPref(1:nMice_val, :), 0, 1) / sqrt(numel(testMice));

T_waterval = table(wv_x', wv_real_y', wv_real_err', wv_model_y', wv_model_err', ...
    'VariableNames', {'WaterValDiff', 'Real_mean', 'Real_err', 'Model_mean', 'Model_err'});
disp(T_waterval)

%%
% 
% for m=1:numel(testMice)
%     h_for_legend=[];
%     if sum(~isnan(mouseValPref(m,:)))>4
%     [cfit, curve] = fitPsycheCurveWH (valDiff(~isnan(mouseValPref(m,1:5))), mouseValPref(m,~isnan(mouseValPref(m,1:5))),SP2);
%     [cfit2, curve2] = fitPsycheCurveWH (valDiff(~isnan(mouseValModel(m,1:5))), mouseValModel(m,~isnan(mouseValModel(m,1:5))),SP2);
% 
%     figure();
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0 0 11 8.5];
%     %     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     nsubplot(1,1,1,1);
% %     scatter(valRatio,valPref)
%     hold on;
%     if addFitLines == 1
%     h_for_legend(end+1)=plot(curve(:,1),curve(:,2),'Color','k','LineWidth',5)
%     h_for_legend(end+1)=plot(curve2(:,1),curve2(:,2),'Color','r','LineWidth',5)
%     end
% %     for m=1:numel(a.valueMice)
%        scatter(valDiff,mouseValPref(m,:),20,'Filled','MarkerFaceColor','k')
%        scatter(valDiff,mouseValModel(m,:),20,'Filled','MarkerFaceColor','r')
% %     end
%     plot([-1 +1].*10^10,[0.5 0.5],'color','k','xliminclude','off');
%     xticks(valDiff)
%     xlim([min(valDiff)-0.25 max(valDiff)+0.25])
%     ylim([0 ymax])
%     axis square
%     xlabel('Water Difference')
%     ylabel('Probability of Choosing Info')
%     %title(a.mouseList(testMice(m)))
%     title(testMice(m))
%     legend(h_for_legend,{'Real','Model'},'Orientation','vertical','Location','southeast','Box','off');
% 
%     saveas(fig,fullfile(plotfolder,[num2str(testMice(m)),'_ModeledWaterValue']),'pdf');
%     end
% end

%%
valDiff = [1 4 6 10];

realChoicesAll=[]; modelChoicesAll=[];
vals=[];
valList=[];
valPref=[]; valErr=[]; valN=[];
valModelPref=[]; valModelErr=[];
mouseValPref=[];mouseValModel=[];

permouseMeanModelChoices = [];

for v=1:numel(delayDiff)
    delayval=delayDiff(v);
    mouseRealChoices=[];realChoices=[];
    mouseModelChoices=[];modelChoices=[];
    waterValList=[];
    for mm=1:numel(testMice)
        m=testMice(mm);
        mouseModelChoices=results.modelChoices{m}(results.delay{m}==delayval&results.waterValue{m}==4);
        mouseRealChoices=results.realChoices{m}(results.delay{m}==delayval&results.waterValue{m}==4);
        modelChoices=[modelChoices; mouseModelChoices];
        realChoices=[realChoices; mouseRealChoices];
        mouseValPref(mm,v)=mean(mouseRealChoices,'omitnan');
        mouseValModel(mm,v)=mean(mouseModelChoices,'omitnan');        

    end
    realChoicesAll=[realChoicesAll; realChoices]; % add all trials across mice for that value
    modelChoicesAll=[modelChoicesAll;modelChoices];
    valList(1:numel(realChoices),1)=valDiff(v);
    vals=[vals; valList]; % add a value for all trials across mice

    valPref(v,1)=mean(realChoices);
    ts = tinv([0.025  0.975],length(realChoices)-1);
    valErr(v,1)=ts(2)*std(realChoices)/sqrt(length(realChoices));
    valErr(v,1)=std(realChoices);
    %[valPref(v,1),valErr(v,1:2)]=binofit(sum(realChoices==1),sum(~isnan(realChoices)));
    
    valModelPref(v,1)=mean(modelChoices);
    ts = tinv([0.025  0.975],length(modelChoices)-1);
    valModelErr(v,1)=ts(2)*std(modelChoices)/sqrt(length(modelChoices));
    valModelErr(v,1)=std(modelChoices);
    %[valModelPref(v,1),valModelErr(v,1:2)]=binofit(sum(modelChoices==1),sum(~isnan(modelChoices)));    
    valN(v,1)=sum(~isnan(realChoices));
end



%%

% % Create a new xAxis with higher resolution
% fineX = 0:1;
% % % Generate curve from fit
% curve = glmval(coeffs, fineX, 'logit');
% curve = [fineX', curve];
% SPs = [0.6, 0.1, 0.8, 1; % Upper limits for g, l, u ,v
%     0.1, 0.1, 0.5, 0.2; % Start points for g, l, u ,v
%     0, 0, 0, 0]; % Lower limits for  g, l, u ,v
%SPs = [0.5, 0.5, inf, inf;
%    0.01, 0.01, 0.5, 0.1;
%    0, 0, 0, 0];
[cfit, curve] = fitPsycheCurveWH (valDiff, valPref, SPs);
coeffs = coeffvalues(cfit);

modelSPs = [0.4, 0.15, 1, 1; % Upper limits for g, l, u ,v
    0.01, 0.05, 0.6, 0.2; % Start points for g, l, u ,v
    0, 0.1, 0, 0]; % Lower limits for  g, l, u ,v
[modelcfit, modelcurve] = fitPsycheCurveWH (valDiff, valModelPref, SPs);

h_for_legend=[];
figure();
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 11 8.5];
fig = gcf;
hAx=gca;                    % create an axes
%hAx.FontSize = 24;
hAx.LineWidth=4;            % set the axis linewidth for box/ticks

%     set(fig,'renderer','painters');
set(fig,'PaperOrientation','landscape');
nsubplot(1,1,1,1);
% scatter(valRatio,valPref)
hold on;
if addFitLines == 1
h_for_legend(end+1)=plot(curve(:,1),curve(:,2),'Color','k','LineWidth',5)
h_for_legend(end+1)=plot(modelcurve(:,1),modelcurve(:,2),'Color','r','LineWidth',5)
end
% for m=1:numel(a.valueMice)
for m=5:numel(testMice)
   if addFitLines == 1
   scatter(valDiff,mouseValPref(m,:),20,'filled','MarkerFaceColor','k') 
   scatter(valDiff,mouseValModel(m,:),20,'filled','MarkerFaceColor','r') 
   end

end
ts = tinv([0.025  0.975],6-1);
for v=1:numel(valDiff)
    if addFitLines == 1
    scatter(valDiff(v),mean(mouseValPref(5:numel(testMice),v)),60,'filled','MarkerFaceColor','k') 
    scatter(valDiff(v),mean(mouseValModel(5:numel(testMice),v)),60,'filled','MarkerFaceColor','r') 
    end

if isSEM == 0
    if addFitLines == 1
    errorbar(valDiff(v),mean(mouseValPref(5:numel(testMice),v)),ts(2)*std(mouseValPref(5:numel(testMice),v))/sqrt(numel(testMice)),"ok","MarkerSize",7,'MarkerFaceColor','k',"CapSize",10,'LineWidth',3)
    errorbar(valDiff(v),mean(mouseValModel(5:numel(testMice),v)),ts(2)*std(mouseValModel(5:numel(testMice),v))/sqrt(numel(testMice)),"ok","MarkerSize",7,'MarkerFaceColor','r',"CapSize",10,'LineWidth',3,'Color','r')
    end
    if addFitLines == 0
    errorbar(valDiff(v),mean(mouseValPref(5:numel(testMice),v)),ts(2)*std(mouseValPref(5:numel(testMice),v))/sqrt(numel(testMice)),"ok","MarkerSize",7,'MarkerFaceColor','k',"CapSize",10,'LineWidth',3)
    errorbar(valDiff(v),mean(mouseValModel(5:numel(testMice),v)),ts(2)*std(mouseValModel(5:numel(testMice),v))/sqrt(numel(testMice)),"ok","MarkerSize",7,'MarkerFaceColor','r',"CapSize",10,'LineWidth',3,'Color','r')
    end
end

if isSEM ==1 
    if addFitLines == 1
    errorbar(valDiff(v),mean(mouseValPref(5:numel(testMice),v)),std(mouseValPref(5:numel(testMice),v))/sqrt(numel(testMice)),"ok","MarkerSize",7,'MarkerFaceColor','k',"CapSize",10,'LineWidth',3)
    errorbar(valDiff(v),mean(mouseValModel(5:numel(testMice),v)),std(mouseValModel(5:numel(testMice),v))/sqrt(numel(testMice)),"ok","MarkerSize",7,'MarkerFaceColor','r',"CapSize",10,'LineWidth',3,'Color','r')
    end
    if addFitLines == 0
    errorbar(valDiff(v),mean(mouseValPref(5:numel(testMice),v)),std(mouseValPref(5:numel(testMice),v))/sqrt(numel(testMice)),"ok","MarkerSize",7,'MarkerFaceColor','k',"CapSize",10,'LineWidth',3)
    errorbar(valDiff(v),mean(mouseValModel(5:numel(testMice),v)),std(mouseValModel(5:numel(testMice),v))/sqrt(numel(testMice)),"ok","MarkerSize",7,'MarkerFaceColor','r',"CapSize",10,'LineWidth',3,'Color','r')
    end
end

end

% scatter(valRatio,valPref,40,'filled')
% errorbar(valRatio,valPref,valErr,"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
%errorbar(valDiff,valPref,valPref-valErr(:,1),valErr(:,2)-valPref,"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
%errorbar(valDiff,valModelPref,valModelPref-valModelErr(:,1),valModelErr(:,2)-valModelPref,"ok","MarkerSize",5,'MarkerFaceColor','r',"CapSize",10,'LineWidth',1,'Color','r')
%errorbar(valDiff,valPref,valPref-valErr(:,1),valErr(:,2)-valPref,"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
%errorbar(valDiff,valModelPref,valModelPref-valModelErr(:,1),valModelErr(:,2)-valModelPref,"ok","MarkerSize",5,'MarkerFaceColor','r',"CapSize",10,'LineWidth',1,'Color','r')
%errorbar(valDiff,valPref,valErr,"ok","MarkerSize",5,'MarkerFaceColor','k',"CapSize",10,'LineWidth',1)
%errorbar(valDiff,valModelPref,valModelErr,"ok","MarkerSize",5,'MarkerFaceColor','r',"CapSize",10,'LineWidth',1,'Color','r')
% di=refline([0 0.5]);
% d=refline([coeffs(3)]);
plot([-1 +1].*10^10,[0.5 0.5],'color','k','xliminclude','off');
xticks(valDiff)
xlim([min(valDiff)-0.25 max(valDiff)+0.25])
ylim([0 ymax])
axis square
xlabel('Delay (s)','fontsize',26,'FontWeight','bold')
ylabel('Probability of Choosing Info','fontsize',26,'FontWeight','bold')
legend(h_for_legend,{'Real','Model'},'Orientation','vertical','Location','southeast','Box','off');
ax = gca;
ax.FontSize = 24; 

saveas(fig,fullfile(plotfolder,'ModeledDelay'),'pdf');

%%
% Run this AFTER the delay loop has populated mouseValPref and mouseValModel
nMice_delay = numel(testMice) - 4; % indices 5:numel(testMice)
ts = tinv([0.025 0.975], 6-1);

delay_x         = delayDiff;                                      % [1 4 6 10]
delay_real_y    = mean(mouseValPref(5:numel(testMice), :), 1);
delay_real_err  = ts(2) * std(mouseValPref(5:numel(testMice), :), 0, 1) / sqrt(numel(testMice));
delay_model_y   = mean(mouseValModel(5:numel(testMice), :), 1);
delay_model_err = ts(2) * std(mouseValModel(5:numel(testMice), :), 0, 1) / sqrt(numel(testMice));

T_delay = table(delay_x', delay_real_y', delay_real_err', delay_model_y', delay_model_err', ...
    'VariableNames', {'Delay_s', 'Real_mean', 'Real_err', 'Model_mean', 'Model_err'});
disp(T_delay)

%%
% 
% for m=1:numel(testMice)
%     h_for_legend=[];
%     if sum(~isnan(mouseValPref(m,:)))>=4
%     [cfit, curve] = fitPsycheCurveWH (valDiff(~isnan(mouseValPref(m,:))), mouseValPref(m,~isnan(mouseValPref(m,:))),SPs);
%     [cfit2, curve2] = fitPsycheCurveWH (valDiff(~isnan(mouseValModel(m,:))), mouseValModel(m,~isnan(mouseValModel(m,:))),SPs);
% 
%     figure();
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0 0 11 8.5];
%     %     set(fig,'renderer','painters');
%     set(fig,'PaperOrientation','landscape');
%     nsubplot(1,1,1,1);
% %     scatter(valRatio,valPref)
%     hold on;
%     if addFitLines == 1
%         h_for_legend(end+1)=plot(curve(:,1),curve(:,2),'Color','k','LineWidth',5);
%         h_for_legend(end+1)=plot(curve2(:,1),curve2(:,2),'Color','r','LineWidth',5);
%     end
% %     for m=1:numel(a.valueMice)
% 
%        scatter(valDiff,mouseValPref(m,:),20,'Filled','MarkerFaceColor','k')
%        scatter(valDiff,mouseValModel(m,:),20,'Filled','MarkerFaceColor','r')
% %     end
%     plot([-1 +1].*10^10,[0.5 0.5],'color','k','xliminclude','off');
%     xticks(valDiff)
%     xlim([min(valDiff)-0.25 max(valDiff)+0.25])
%     ylim([0 ymax])
%     axis square
%     xlabel('Delay (s)')
%     ylabel('Probability of Choosing Info')
%     title(testMice(m))
%     legend(h_for_legend,{'Real','Model'},'Orientation','vertical','Location','southeast','Box','off');
% 
%     saveas(fig,fullfile(plotfolder,[num2str(testMice(m)),'_ModeledDelay']),'pdf');
%     end
% end


%%
% x=choices;
% y=vals;
% [logitCoef,dev]  = glmfit(x,y,'binomial','link','logit');
% 
% logitFit = glmval(logitCoef,[0.25 0.5 0.75 1],'logit');
% % plot(x,y,'bs', x,logitFit,'r-');
% 
% %% FIND ALL VALUE DAYS
% 
% 
% for mm=1:numel(a.delayMice)
%     m=a.delayMice(mm);
%     delayDays=[];
%     for v=1:numel(a.delayDays{mm})
%         delayDays=[delayDays;cell2mat(a.delayDays{mm}{v})'];
%     end
%     a.daysForDelay{mm}=delayDays;
% end
% 
% % unique(a.rewardParams(a.mice(:,6)==1&ismember(a.mouseDay,min(daysForVal{1}):1:max(daysForVal{1})),:),'rows')

set(0,'DefaultFigureWindowStyle','normal');