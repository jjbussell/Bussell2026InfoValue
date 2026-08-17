%% regMulti

% registration of ROI locations across multiple sessions
% uses 'register_multisession.m' from CaImAn-MATLAB implementation:
% https://github.com/flatironinstitute/CaImAn-MATLAB

%%
clear; close all;

set(0,'DefaultFigureWindowStyle','normal');


% manually enter mouse, base day, and days to register
% mouse='JB426';
% days={'20220126','20220127','20220131','20220201','20220302','20220303'};
% days={'20220406','20220411','20220504','20220505'};
% days={'20220711','20220713','20220728','20220729'};
% days={'20220131','20220201','20220302','20220303'};
% days={'20220616','20220617','20220804','20220805'};
% days={'20220302','20220303','20220316','20220317'};
% days={'20220302','20220316','20220303','20220317'};
% base='20220302';
% mouse='JB425';
% days={'20220321','20220322','20220331','20220401'};
% days={'20220518','20220519','20220616','20220617'};
% base='20220131';
% mouse='JB424';
% % days={'20220105','20220106','20220121','20220124'};
% % days={'20220210','20220211','20220224','20220225'};
% days={'20220328','20220329','20220413','20220414'};
% days={'20220210','20220211','20220224','20220225'};
% days={'20220328','20220329','20220421','20220422'};
% base='20220211';
% base='20220225';
% mouse='JB413';
% days={'20220119','20220120','20220127','20220128'};
% base='20211124';
% mouse='JB432';
% days={'20220526','20220613','20220527','20220614'};
% days={'20220526','20220527','20220613','20220614'};
% days={'20220428','20220429','20220502','20220503'};
% days={'20220623','20220627','20220706','20220707'};
% days={'20220526','20220527','20220706','20220707'};
% days={'20220914','20220915','20220926','20220927'};
% base='20220520';
% mouse='JB431'
% base='20220711';
% days={'20220519','20220524'};
% mouse='JB433'
% base='20220527';
% days={'20220811','20220817','20220908','20220909'};
% mouse='JB434'
% base='20220520';
% days={'20220914','20220915','20220926','20220927'};
% mouse='JB484';
% base='20240517';
% days={'20240614','20240619','20240628','20240701'};
% mouse='JB507';
% base='20241125';
% days={'20241205','20241206','20241212','20241213','20250109','20250110'};


datapath=fullfile('D:\Bussell Dropbox\Jennifer Bussell\BpodInfoseek\Analysis',[mouse '_pipeline']);

for d=1:numel(days)
    neurofile=dir(fullfile(datapath,[mouse '_' days{d} '*cells*.mat']));
    load(fullfile(datapath,neurofile.name),'neuron');
    A{d}=neuron.A;

    Coor{d} = neuron.show_contours(0.6);
   
    templatefile=dir(fullfile(datapath,[mouse '_' days{d} '*MC*.mat']));
    if isempty(templatefile)
        if ~isempty(templateFromNeuron)
            templates{d}=templateFromNeuron;
        else
            error(['Template file not found and neuron.Cn missing for ' mouse ' ' days{d}]);
        end
    else
        load(fullfile(datapath,templatefile(1).name));
        if exist('template1','var')
            templates{d}=template1;
            clear template1;
        elseif exist('template2','var')
            templates{d}=template2;
            clear template2;
        elseif ~isempty(templateFromNeuron)
            templates{d}=templateFromNeuron;
        else
            error(['No template1/template2 and neuron.Cn missing for ' mouse ' ' days{d}]);
        end
    end
end

%%

% need to add the path to CaImAn-MATLAB for this script but then remove
% from standard matlab path to run original CNMFE implementation

% addpath('C:\Users\Axel\Code\CaImAn-MATLAB\utilities');
% addpath('C:\Users\Axel\Code\CaImAn-MATLAB\');

addpath('D:\Code\CaImAn-MATLAB\utilities');
addpath('D:\Code\CaImAn-MATLAB\');

% options.d1=size(templates{1},1);
% options.d2=size(templates{1},2);
% d1=options.d1;
% d2=options.d2;
% options.dist_maxthr=0.22; %0.22
% options.dist_thr=0.6; %0.6
% options.maxthr=[];
% % options.dist_overlap_thr = 0.75;

options.d1=size(templates{1},1);
options.d2=size(templates{1},2);
d1=options.d1;
d2=options.d2;
options.dist_maxthr=0.2;
options.dist_thr=0.6;
% options.dist_overlap_thr = 0.75;
options_mc = NoRMCorreSetParms('d1',options.d1,'d2',options.d2,'max_shift',1000,'iter',1,'correct_bidir',false);

% to use non-rigid normcorre to align sessions
% options_nr = NoRMCorreSetParms('d1',d1,'d2',d2,'bin_width',1000, ...
%     'grid_size',[32,32],'mot_uf',4,'correct_bidir',false,'max_dev',[8,8], ...
%     'overlap_pre',24,'overlap_post',24,'max_shift',40,'use_parallel',true,'upd_template',false,'boundary','zero');


[A_union, assignments, matchings] = register_multisession(A, options, templates, options_mc);
% [A_union, assignments, matchings] = register_multisession(A, options, options_mc);

rmpath('D:\Code\CaImAn-MATLAB\utilities');
rmpath('D:\Code\CaImAn-MATLAB\');
% rmpath('C:\Users\Axel\CaImAn-MATLAB\utilities');
% rmpath('C:\Users\Axel\CaImAn-MATLAB\');

MATCHED_ROIS=assignments(sum(isnan(assignments),2)==0,:);
regmouse=mouse;

save(fullfile(datapath,[mouse '_' num2str(numel(days)) 'days_' strjoin(days,'_') '_reg.mat']),'MATCHED_ROIS','regmouse','days','base');