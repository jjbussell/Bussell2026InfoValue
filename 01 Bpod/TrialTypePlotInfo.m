%{
----------------------------------------------------------------------------

This file is modified from the Sanworks Bpod repository
Copyright (C) 2017 Sanworks LLC, Stony Brook, New York, USA

----------------------------------------------------------------------------

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3.

This program is distributed  WITHOUT ANY WARRANTY and without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
%}
function TrialTypePlotInfo(AxesHandle, Action, varargin)
%% 
% Plug in to Plot trial type and trial outcome.
% AxesHandle = handle of axes to plot on
% Action = specific action for plot, "init" - initialize OR "update" -  update plot

%Example usage:
% TrialTypePlotInfo(AxesHandle,'init',TrialTypes)
% TrialTypePlotInfo(AxesHandle,'init',TrialTypes,'ntrials',90)
% TrialTypePlotInfo(AxesHandle,'update',CurrentTrial,TrialTypes,OutcomeRecord)

% varargins:
% TrialTypes: Vector of trial types (integers)
% OutcomeRecord:  Vector of trial outcomes

%                 Info: 
%                               NaN: future trial (blue)
%                                -1: Not Present (black circle)
%                                 0: correct choice rand (orange dot)
%                                 1: correct choice info (purple dot)
%                                 2: did not choose (blue X)
%                                 3: incorrect choice (red X)
% OutcomeRecord can also be empty
% Current trial: the current trial number

% Adapted from BControl (SidesPlotSection.m) 
% Kachi O. 2014.Mar.17
% J. Sanders. 2015.Jun.6 - adapted to display trial types instead of sides
% J Bussell - adapted for trial types from the Information Seeking Task

%% Code Starts Here
global nTrialsToShow %this is for convenience
global BpodSystem

switch Action
    case 'init'
        %initialize pokes plot
        TrialTypeList = varargin{1};
        nTrialsToShow = 40; %default number of trials to display
        if nargin > 3 %custom number of trials
            nTrialsToShow = varargin{2};
        end
        yticklabelsinfo = {'RandForced','InfoForced','Choice'};
        labelFontSize = 16;
        axes(AxesHandle);
        MaxTrialType = numel(yticklabelsinfo);
        %plot in specified axes
        Xdata = 1:nTrialsToShow;
        if ~isrow(TrialTypeList)
            Ydata = -TrialTypeList(Xdata)';
        else
            Ydata = -TrialTypeList(Xdata);
        end
        BpodSystem.GUIHandles.FutureTrialLine = line([Xdata,Xdata],[Ydata,Ydata],'LineStyle','none','Marker','o','MarkerEdge','b','MarkerFace','b', 'MarkerSize',6);
        BpodSystem.GUIHandles.CurrentTrialCircle = line([0,0],[0,0], 'LineStyle','none','Marker','o','MarkerEdge','k','MarkerFace',[1 1 1], 'MarkerSize',6);
        BpodSystem.GUIHandles.CurrentTrialCross = line([0,0],[0,0], 'LineStyle','none','Marker','+','MarkerEdge','k','MarkerFace',[1 1 1], 'MarkerSize',6);
        BpodSystem.GUIHandles.IncorrectLine = line([0,0],[0,0], 'LineStyle','none','Marker','x','MarkerEdge','r','MarkerFace','r', 'MarkerSize',6);
        BpodSystem.GUIHandles.InfoCorrectBigLine = line([0,0],[0,0], 'LineStyle','none','Marker','o','MarkerEdge',[128 0 128]./255,'MarkerFace',[128   0 128]./255, 'MarkerSize',6);
        BpodSystem.GUIHandles.InfoCorrectSmallLine = line([0,0],[0,0], 'LineStyle','none','Marker','o','MarkerEdge',[0.8 0.6 1],'MarkerFace',[0.8 0.6 1], 'MarkerSize',6);
        BpodSystem.GUIHandles.RandCorrectBigLine = line([0,0],[0,0], 'LineStyle','none','Marker','o','MarkerEdge',[255 140 0]./255,'MarkerFace',[255 140 0]./255, 'MarkerSize',6);
        BpodSystem.GUIHandles.RandCorrectSmallLine = line([0,0],[0,0], 'LineStyle','none','Marker','o','MarkerEdge',[1.0 0.8 0.4],'MarkerFace',[1.0 0.8 0.4], 'MarkerSize',6);
        BpodSystem.GUIHandles.NotPresentInfoBigLine = line([0,0],[0,0], 'LineStyle','none','Marker','o','MarkerEdge',[128 0 128]./255,'MarkerFace',[1 1 1], 'MarkerSize',6);
        BpodSystem.GUIHandles.NotPresentInfoSmallLine = line([0,0],[0,0], 'LineStyle','none','Marker','o','MarkerEdge',[0.8 0.6 1],'MarkerFace',[1 1 1], 'MarkerSize',6);
        BpodSystem.GUIHandles.NotPresentRandBigLine = line([0,0],[0,0], 'LineStyle','none','Marker','o','MarkerEdge',[255 140 0]./255,'MarkerFace',[1 1 1], 'MarkerSize',6);
        BpodSystem.GUIHandles.NotPresentRandSmallLine = line([0,0],[0,0], 'LineStyle','none','Marker','o','MarkerEdge',[1.0 0.8 0.4],'MarkerFace',[1 1 1], 'MarkerSize',6);
        BpodSystem.GUIHandles.NoChoiceLine = line([0,0],[0,0], 'LineStyle','none','Marker','x','MarkerEdge','b','MarkerFace','b', 'MarkerSize',6);
%         BpodSystem.GUIHandles.TTOP_Ylabel = strsplit(num2str(MaxTrialType:-1:-1));
        BpodSystem.GUIHandles.TTOP_Ylabel = split(num2str(MaxTrialType:-1:-1));
        if numel(unique(TrialTypeList)) == 3
            set(AxesHandle,'TickDir', 'out','YLim', [-MaxTrialType-.5, -.5], 'YTick', -MaxTrialType:1:-1, 'YTickLabel', yticklabelsinfo, 'FontSize', 16);
        else
            set(AxesHandle,'TickDir', 'out','YLim', [-MaxTrialType-.5, -.5], 'YTick', -MaxTrialType:1:-1,'YTickLabel', BpodSystem.GUIHandles.TTOP_Ylabel, 'FontSize', 16);
        end
        set(AxesHandle,'TickDir', 'out','YLim', [-MaxTrialType-.5, -.5], 'YTick', -MaxTrialType:1:-1,'FontSize', 16);
        xlabel(AxesHandle, 'Trial#', 'FontSize', labelFontSize);
        ylabel(AxesHandle, 'Trial Type', 'FontSize', 16);

        hold(AxesHandle, 'on');
        
    case 'update'
        CurrentTrial = varargin{1};
        TrialTypeList = varargin{2};
        if ~isrow(TrialTypeList)
            TrialTypeList = TrialTypeList';
        end
        if nargin>4
            OutcomeRecord = varargin{3};
        else
            OutcomeRecord = BpodSystem.Data.PlotOutcomes;
        end
        MaxTrialType = 3;
        yticklabelsinfo = {'RandForced','InfoForced','Choice'};
        if numel(unique(TrialTypeList)) == 3
            set(AxesHandle,'YLim',[-MaxTrialType-.5, -.5], 'YTick', -MaxTrialType:1:-1,'YTickLabel', yticklabelsinfo);
        else
            set(AxesHandle,'YLim',[-MaxTrialType-.5, -.5], 'YTick', -MaxTrialType:1:-1,'YTickLabel', BpodSystem.GUIHandles.TTOP_Ylabel);
        end
        if CurrentTrial<1
            CurrentTrial = 1;
        end
        TrialTypeList  = -TrialTypeList;
        
        % recompute xlim
        [mn, mx] = rescaleX(AxesHandle,CurrentTrial,nTrialsToShow);
        
        %plot future trials
        offset = mn-1;
        FutureTrialsIndx = CurrentTrial+1:mx;
        Xdata = FutureTrialsIndx; Ydata = TrialTypeList(Xdata);
        DisplayXdata = Xdata-offset;
        set(BpodSystem.GUIHandles.FutureTrialLine, 'xdata', [DisplayXdata,DisplayXdata], 'ydata', [Ydata,Ydata]);
        %Plot current trial
        displayCurrentTrial = CurrentTrial-offset+1;
        set(BpodSystem.GUIHandles.CurrentTrialCircle, 'xdata', [displayCurrentTrial,displayCurrentTrial], 'ydata', [TrialTypeList(CurrentTrial+1),TrialTypeList(CurrentTrial+1)]);
        set(BpodSystem.GUIHandles.CurrentTrialCross, 'xdata', [displayCurrentTrial,displayCurrentTrial], 'ydata', [TrialTypeList(CurrentTrial+1),TrialTypeList(CurrentTrial+1)]);
        
        %Plot past trials
        if numel(OutcomeRecord) == CurrentTrial
            indxToPlot = mn:CurrentTrial;
%         if ~isempty(OutcomeRecord)
%             if numel(OutcomeRecord) == CurrentTrial
%                 indxToPlot = mn:CurrentTrial;
%             else
%                 indxToPlot = mn:CurrentTrial-1;
%             end

           for i = 1:10
               trialIdx = OutcomeRecord(indxToPlot) == i;
               Xdatapast{i,1} = indxToPlot(trialIdx); Ydatapast{i,1} = TrialTypeList(Xdatapast{i,1});
               DispDatapast{i,1} = Xdatapast{i,1}-offset;
           end
           
           % INFO BIG
           set(BpodSystem.GUIHandles.InfoCorrectBigLine, 'xdata', [DispDatapast{1,1},DispDatapast{1,1}], 'ydata', [Ydatapast{1,1},Ydatapast{1,1}]);
           % INFO SMALL
           set(BpodSystem.GUIHandles.InfoCorrectSmallLine, 'xdata', [DispDatapast{2,1},DispDatapast{2,1}], 'ydata', [Ydatapast{2,1},Ydatapast{2,1}]);
           % RAND BIG
           set(BpodSystem.GUIHandles.RandCorrectBigLine, 'xdata', [DispDatapast{5,1},DispDatapast{5,1}], 'ydata', [Ydatapast{5,1},Ydatapast{5,1}]);
           % RAND SMALL
           set(BpodSystem.GUIHandles.RandCorrectSmallLine, 'xdata', [DispDatapast{6,1},DispDatapast{6,1}], 'ydata', [Ydatapast{6,1},Ydatapast{6,1}]);
           % INFO BIG NP
           set(BpodSystem.GUIHandles.NotPresentInfoBigLine, 'xdata', [DispDatapast{3,1},DispDatapast{3,1}], 'ydata', [Ydatapast{3,1},Ydatapast{3,1}]);
           % INFO SMALL NP
           set(BpodSystem.GUIHandles.NotPresentInfoSmallLine, 'xdata', [DispDatapast{4,1},DispDatapast{4,1}], 'ydata', [Ydatapast{4,1},Ydatapast{4,1}]);
           % RAND BIG NP
           set(BpodSystem.GUIHandles.NotPresentRandBigLine, 'xdata', [DispDatapast{7,1},DispDatapast{7,1}], 'ydata', [Ydatapast{7,1},Ydatapast{7,1}]);
           % RAND SMALL NP
           set(BpodSystem.GUIHandles.NotPresentRandSmallLine, 'xdata', [DispDatapast{8,1},DispDatapast{8,1}], 'ydata', [Ydatapast{8,1},Ydatapast{8,1}]);
           % INCORRECT
           set(BpodSystem.GUIHandles.IncorrectLine, 'xdata', [DispDatapast{9,1},DispDatapast{9,1}], 'ydata', [Ydatapast{9,1},Ydatapast{9,1}]);
           % NO CHOICE
           set(BpodSystem.GUIHandles.NoChoiceLine, 'xdata', [DispDatapast{10,1},DispDatapast{10,1}], 'ydata', [Ydatapast{10,1},Ydatapast{10,1}]);
        end
end

end

function [mn,mx] = rescaleX(AxesHandle,CurrentTrial,nTrialsToShow)
FractionWindowStickpoint = .5; % After this fraction of visible trials, the trial position in the window "sticks" and the window begins to slide through trials.
mn = max(round(CurrentTrial - FractionWindowStickpoint*nTrialsToShow),1);
mx = mn + nTrialsToShow - 1;
tickLabels = sprintfc('%d',(mn-1:10:mx));
set(AxesHandle, 'Xtick', 0:10:nTrialsToShow, 'XtickLabel', tickLabels);
%set(AxesHandle,'XLim',[mn-1 mx+1]); Replaced this with a trimmed "display" copy of the data 
                                    % and an xticklabel update for speed - JS 2018
end
