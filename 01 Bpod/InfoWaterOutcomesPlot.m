
function InfoWaterOutcomesPlot(AxesHandle, Action, varargin)

global BpodSystem

outcomeLabels = {'SmallNoChoice','Small','SmallNP','SmallIncorrect',...
'InfoNoChoice','InfoBig',...
'InfoBigNP','InfoSmall','InfoSmallNP','InfoIncorrect','RandNoChoice',...
'RandBig','RandBigNP','RandSmall','RandSmallNP',...
'RandIncorrect','BigNoChoice','Big','BigNP','BigIncorrect'};

CC = [0.6,0.6,0.6; %small no choice
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

switch Action
    case 'init'
        outcomes = ones(1,20);
        outcomesToPlot = [outcomes; outcomes];        
        ax = AxesHandle;

%         outcomesToPlot = outcomes;
        b = bar(ax,outcomesToPlot,'stacked');
        for i = 1:numel(outcomes)
            b(i).FaceColor = CC(i,:);
        end
        set(ax, 'ydir', 'reverse');
        ax.FontSize = 10;
        ax.YLabel.String = 'Trial Outcomes (% of trials)';
        ax.YLim = [0 1];
        ax.YTick = [0:0.25:1];
        ax.XLim = [0 1.5];
        lgd = legend(ax,outcomeLabels,'Location','eastoutside');
        lgd.Box = 'off';
        lgd.FontWeight = 'bold';
        
    case 'update'
        outcomes = BpodSystem.Data.Outcomes;
        [outcomeCountsNorm,outcomeBins] = histcounts(outcomes,[0.5:1:20.5],'Normalization','probability');
        outcomesToPlot = [outcomeCountsNorm; outcomeCountsNorm];
        ax = AxesHandle;
%         colormap(ax,CC);
        b = bar(ax,outcomesToPlot,'stacked');
        for i = 1:numel(outcomeCountsNorm)
            b(i).FaceColor = CC(i,:);
        end
        set(ax, 'ydir', 'reverse');
        ax.FontSize = 10;
        ax.YLabel.String = 'Trial Outcomes (% of trials)';
        ax.YLim = [0 1];
        ax.YTick = [0:0.25:1];
        ax.XLim = [0 1.5];
        lgd = legend(ax,outcomeLabels,'Location','eastoutside');
        lgd.Box = 'off';
        lgd.FontWeight = 'bold';
        
end

end