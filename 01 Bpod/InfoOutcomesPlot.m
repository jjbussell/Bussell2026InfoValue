
function InfoOutcomesPlot(AxesHandle, Action, varargin)

    global BpodSystem

    outcomeLabels = {'ChoiceNoChoice','ChoiceInfoBig','ChoiceInfoBigNP',...
    'ChoiceInfoSmall','ChoiceInfoSmallNP','ChoiceRandBig','ChoiceRandBigNP',...
    'ChoiceRandSmall','ChoiceRandSmallNP','InfoNoChoice','InfoBig',...
    'InfoBigNP','InfoSmall','InfoSmallNP','InfoIncorrect','RandNoChoice',...
    'RandBig','RandBigNP','RandSmall','RandSmallNP',...
    'RandIncorrect'};

    CC = [0.6,0.6,0.6; %choice no choice 1 
    0.474509803921569,0.125490196078431,0.768627450980392; %choice info big 2
    171/255,130/255,1; % choice info big NP 3
    0.9490, 0.8, 1.0; %choiceinfosmall 4
    238/255,224/255,229/255; %choiceinfoNPsmall 5
    0.984313725490196,0.545098039215686,0.0235294117647059; %choice rand big 6
    245/255,222/255,179/255; % choice rand big NP 7
    1, 0.8, 0.0; %choice rand small 8
    244/255, 164/255, 96/255; %choice rand small NP 9
    0.6,0.6,0.6; %info no choice 10
    0,1,0; %info big 11
    152/255,251/255,152/255;% info big NP 12
    1,0,1; %infosmall 13
    1,192/255,203/255; %info small not present 14
    0.0,0.0,0.0; %infoincorrect 15 
    0.6,0.6,0.6;% rand no choice 16
    0,0,1; %rand big 17
    135/255,206/255,1; % rand big NP 18
    0,1,1; %rand small 19
    187/255,1,1; %rand small NP 20
    0,0,0]; %rand incorrect 21


    switch Action
        case 'init'
            outcomes = ones(1,21);
            outcomesToPlot = [outcomes; outcomes];        
            ax = AxesHandle;
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
            [outcomeCountsNorm,outcomeBins] = histcounts(outcomes,[0.5:1:21.5],'Normalization','probability');
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