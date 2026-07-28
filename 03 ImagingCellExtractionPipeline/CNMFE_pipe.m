%% clear the workspace and select data 
clear; clc; close all;

cnmfe_setup;

if isdir('F:\1PMC')
    MCdir = 'F:\1PMC';
else
    MCdir = 'D:\1PMC';
end

% MCdir = uigetdir('','Choose data directory');

datadir = findInfoseekData();

files = dir(fullfile(MCdir,'JB*PP4X_MC_MCmid.tiff'));
% files = dir(fullfile(MCdir,'JB*PP4X_MC.tiff'));
% files = dir(fullfile(MCdir,'JB999_20230501_PP4X_MC_51083-end.tiff'));

for f=1:numel(files)
%% choose data 
neuron = Sources2D(); 
nam = neuron.select_data(fullfile(MCdir,files(f).name));  %if nam is [], then select data interactively

tic

%% parameters  
% -------------------------    COMPUTATION    -------------------------  %
 pars_envs = struct('memory_size_to_use', 64, ...   % GB, memory space you allow to use in MATLAB 
    'memory_size_per_patch', 64, ...   % GB, space for loading data within one patch 
    'patch_dims', [64, 64]);  %GB, patch size 
   
% -------------------------      SPATIAL      -------------------------  %
gSig = 3; %3           % pixel, gaussian width of a gaussian kernel for filtering the data. 0 means no filtering
gSiz = 11;  %13        % pixel, neuron diameter 
ssub = 1;           % spatial downsampling factor
with_dendrites = false;   % with dendrites or not 
if with_dendrites
    % determine the search locations by dilating the current neuron shapes
    updateA_search_method = 'dilate';  %#ok<UNRCH>
    updateA_bSiz = 20;
    updateA_dist = neuron.options.dist; 
else
    % determine the search locations by selecting a round area
    updateA_search_method = 'ellipse';
    updateA_dist = 5; %5
    updateA_bSiz = neuron.options.dist;
end
spatial_constraints = struct('connected', true, 'circular', false);  % you can include following constraints: 'circular'
spatial_algorithm = 'hals_thresh';

% -------------------------      TEMPORAL     -------------------------  %
Fs = 20;             % frame rate
tsub = 2;           % temporal downsampling factor
deconv_flag = true;     % run deconvolution or not 
deconv_options = struct('type', 'ar1', ... % model of the calcium traces. {'ar1', 'ar2'}
    'method', 'foopsi', ... % method for running deconvolution {'foopsi', 'constrained', 'thresholded'}
    'smin', -5, ...         % minimum spike size. When the value is negative, the actual threshold is abs(smin)*noise level
    'optimize_pars', true, ...  % optimize AR coefficients
    'optimize_b', true, ...% optimize the baseline);
    'max_tau', 100);    % maximum decay time (unit: frame);

nk = 3;             % detrending the slow fluctuation. usually 1 is fine (no detrending)
% when changed, try some integers smaller than total_frame/(Fs*30)
detrend_method = 'spline';  % compute the local minimum as an estimation of trend.

% -------------------------     BACKGROUND    -------------------------  %
bg_model = 'ring';  % model of the background {'ring', 'svd'(default), 'nmf'}
nb = 1;             % number of background sources for each patch (only be used in SVD and NMF model)
ring_radius = 18; % 18  % when the ring model used, it is the radius of the ring used in the background model.
%otherwise, it's just the width of the overlapping area
num_neighbors = []; % number of neighbors for each neuron
bg_ssub = 2;        % downsample background for a faster speed 

% -------------------------      MERGING      -------------------------  %
show_merge = false;  % if true, manually verify the merging step 
merge_thr = 0.7;     % thresholds for merging neurons; [spatial overlap ratio, temporal correlation of calcium traces, spike correlation]
method_dist = 'max';   % method for computing neuron distances {'mean', 'max'}
dmin = 5;       % minimum distances between two neurons. it is used together with merge_thr
dmin_only = 2;  % merge neurons if their distances are smaller than dmin_only.
merge_thr_spatial = [0.8, 0.1, -inf];  % merge components with highly correlated spatial shapes (corr=0.8) and small temporal correlations (corr=0.1)

% -------------------------  INITIALIZATION   -------------------------  %
K = [];             % maximum number of neurons per patch. when K=[], take as many as possible. 
min_corr = 0.8; %JB432 0.8 %0.7 for 424 or 425? % 0.55 %8 0.85    % minimum local correlation for a seeding pixel
min_pnr = 9; %JB432 9 %7 %8 10 %8 %9   % minimum peak-to-noise ratio for a seeding pixel
min_pixel = 25; % 25%20 %25      % minimum number of nonzero pixels for each neuron
bd = 0;             % number of rows/columns to be ignored in the boundary (mainly for motion corrected data)
frame_range = [];   % when [], uses all frames 
save_initialization = false;    % save the initialization procedure as a video. 
use_parallel = true;    % use parallel computation for parallel computing 
show_init = true;   % show initialization results 
choose_params = false; % manually choose parameters 
center_psf = true;  % set the value as true when the background fluctuation is large (usually 1p data) 
                    % set the value as false when the background fluctuation is small (2p)

% -------------------------  Residual   -------------------------  %
min_corr_res = 0.8; %0.8 %0.85
min_pnr_res = 9; %9
seed_method_res = 'auto';  % method for initializing neurons from the residual
update_sn = true;

% ----------------------  WITH MANUAL INTERVENTION  --------------------  %
with_manual_intervention = true;

% -------------------------  FINAL RESULTS   -------------------------  %
save_demixed = true;    % save the demixed file or not
kt = 3;                 % frame intervals

% -------------------------    UPDATE ALL    -------------------------  %
neuron.updateParams('gSig', gSig, ...       % -------- spatial --------
    'gSiz', gSiz, ...
    'ring_radius', ring_radius, ...
    'ssub', ssub, ...
    'search_method', updateA_search_method, ...
    'bSiz', updateA_bSiz, ...
    'dist', updateA_bSiz, ...
    'spatial_constraints', spatial_constraints, ...
    'spatial_algorithm', spatial_algorithm, ...
    'tsub', tsub, ...                       % -------- temporal --------
    'deconv_flag', deconv_flag, ...
    'deconv_options', deconv_options, ...
    'nk', nk, ...
    'detrend_method', detrend_method, ...
    'background_model', bg_model, ...       % -------- background --------
    'nb', nb, ...
    'ring_radius', ring_radius, ...
    'num_neighbors', num_neighbors, ...
    'bg_ssub', bg_ssub, ...
    'merge_thr', merge_thr, ...             % -------- merging ---------
    'dmin', dmin, ...
    'method_dist', method_dist, ...
    'min_corr', min_corr, ...               % ----- initialization -----
    'min_pnr', min_pnr, ...
    'min_pixel', min_pixel, ...
    'bd', bd, ...
    'center_psf', center_psf);
neuron.Fs = Fs;

%% distribute data and be ready to run source extraction
neuron.getReady(pars_envs);

%% initialize neurons from the video data within a selected temporal range
if choose_params
    % change parameters for optimized initialization
    [gSig, gSiz, ring_radius, min_corr, min_pnr] = neuron.set_parameters();
end

[center, Cn, PNR] = neuron.initComponents_parallel(K, frame_range, save_initialization, use_parallel);
neuron.compactSpatial();
if show_init
    figure();
    ax_init= axes();
    imagesc(Cn, [0, 1]); colormap gray;
    hold on;
    plot(center(:, 2), center(:, 1), '.r', 'markersize', 10);
end

%% estimate the background components
neuron.update_background_parallel(use_parallel);
neuron_init = neuron.copy();

%%  merge neurons and update spatial/temporal components
neuron.merge_neurons_dist_corr(show_merge);
neuron.merge_high_corr(show_merge, merge_thr_spatial);

%% pick neurons from the residual
[center_res, Cn_res, PNR_res] =neuron.initComponents_residual_parallel([], save_initialization, use_parallel, min_corr_res, min_pnr_res, seed_method_res);
if show_init
    axes(ax_init);
    plot(center_res(:, 2), center_res(:, 1), '.g', 'markersize', 10);
    savename=fullfile(neuron.P.log_folder,['init' '.fig'])
    savefig(savename)
end
neuron_init_res = neuron.copy();

%% udpate spatial&temporal components, delete false positives and merge neurons
% update spatial
if update_sn
    neuron.update_spatial_parallel(use_parallel, true);
    udpate_sn = false;
else
    neuron.update_spatial_parallel(use_parallel);
end
% merge neurons based on correlations 
neuron.merge_high_corr(show_merge, merge_thr_spatial);

for m=1:2
    % update temporal
    neuron.update_temporal_parallel(use_parallel);
    
    % delete bad neurons
    neuron.remove_false_positives();
    
    % merge neurons based on temporal correlation + distances 
    neuron.merge_neurons_dist_corr(show_merge);
end

% merge closeby neurons
neuron.merge_close_neighbors(false, dmin_only);


%% save the workspace for future analysis
neuron.orderROIs('snr');
cnmfe_path = neuron.save_workspace();
toc

% %% show neuron contours
Coor = neuron.show_contours(0.6); % saves contours pre-filter

%% IMPLEMENT FILTERS TO REMOVE BAD NEURONS BUT SAVE FOR REVIEW

del_ids={};
badids=[];
tempspars_min=0.003;
pnr_min=8.5;
baseDiff_max=3;
% sort by snr
snrs = var(neuron.C, 0, 2)./var(neuron.C_raw-neuron.C, 0, 2);
% temporal sparsity:
tempspars = sqrt(sum(neuron.C_raw.^2, 2))./sum(abs(neuron.C_raw), 2);
del_ids{1,1}=find(tempspars<tempspars_min);
% pnr:
pnrs = max(neuron.C, [], 2)./std(neuron.C_raw-neuron.C, 0, 2);
del_ids{1,2}=find(pnrs<pnr_min);
% flat baseline:
baseDiff=mean(neuron.C_raw(:,1:round(0.1*size(neuron.C_raw,2))),2)-mean(neuron.C_raw(:,end-round(0.1*size(neuron.C_raw,2)):end),2);
del_ids{1,3}=find(abs(baseDiff)>baseDiff_max);

badids2=union(del_ids{1},del_ids{2});
badids=union(badids2,del_ids{3});
goodids=setdiff(1:size(neuron.C,1),badids);

%%
save(fullfile(neuron.P.log_folder,[strrep(get_date(), ' ', '_'),'_filteredneurons.mat']),'neuron','badids','goodids');

% DELETE BAD NEURONS
neuron.delete(badids);

% %% add a manual intervention and run the whole procedure for a second time
% 
% if with_manual_intervention
%     neuron.orderROIs('snr');   % order neurons in different ways {'snr', 'decay_time', 'mean', 'circularity'}
%     neuron.viewNeurons([], neuron.C_raw);
%     
%     % delete neurons
%     tags = neuron.tag_neurons_parallel();  % find neurons with fewer nonzero pixels than min_pixel and silent calcium transients
%     ids = find(tags>0); 
%     if ~isempty(ids)
%         neuron.viewNeurons(ids, neuron.C_raw);
%     end
%     
% end


%% show neuron contours
Coor = neuron.show_contours(0.6);

%% save the workspace for future analysis
neuron.orderROIs('snr');
cnmfe_path = neuron.save_workspace();

% save(fullfile(neuron.P.log_folder,[strrep(get_date(), ' ', '_'),'_finalneurons.mat']),'neuron');

% %% run more iterations
% neuron.options.spatial_algorithm = 'nnls';
% neuron.update_background_parallel(use_parallel);
% neuron.update_spatial_parallel(use_parallel);
% neuron.update_temporal_parallel(use_parallel);
% 
% K = size(neuron.A,2);
% tags = neuron.tag_neurons_parallel();  % find neurons with fewer nonzero pixels than min_pixel and silent calcium transients
% neuron.remove_false_positives();
% neuron.merge_neurons_dist_corr(show_merge);
% neuron.merge_high_corr(show_merge, merge_thr_spatial);
% % 
% if K~=size(neuron.A,2)
%     neuron.update_spatial_parallel(use_parallel);
%     neuron.update_temporal_parallel(use_parallel);
%     neuron.remove_false_positives();
% end
% 
% %% save the workspace for future analysis
% neuron.orderROIs('snr');
% cnmfe_path = neuron.save_workspace();
% 
% %% show neuron contours
% Coor = neuron.show_contours(0.6);

% Coor = neuron.show_contours(0.4,~,~,~,true);
% plot_coutours(neuron.A,Cn,0.4,1);


% %% create a video for displaying the
% amp_ac = 140;
% range_ac = 5+[0, amp_ac];
% multi_factor = 10;
% range_Y = 1300+[0, amp_ac*multi_factor];
% 
% avi_filename = neuron.show_demixed_video(save_demixed, kt, [], amp_ac, range_ac, range_Y, multi_factor);

%% save neurons shapes
% neuron.save_neurons();

close all;

clearvars -except files MCdir datadir f;

end

exit()