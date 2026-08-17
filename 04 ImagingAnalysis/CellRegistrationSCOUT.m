% navigate to SCOUT code base dir, run
% 	addpath(genpath('.'))

% load cells to track one day each into neurons.{day}
neurons{1}=neuron;

% Add dimensions of images to each neuron object
neurons{1}.imageSize=[200,320];
neurons{2}.imageSize=[200,320];
neurons{3}.imageSize=[200,320];
neurons{4}.imageSize=[200,320];

% output is neuron.cell_register

%cell tracking options (fully defined in cellTracking_SCOUT)
cell_tracking_options.chain_prob=.5; %(Chain probability threshold)
cell_tracking_options.min_prob=.5; %(individual identification probability threshold)
cell_tracking_options.overlap=0; %(Overlap size on each recording, 1/2 the length of the connecting recording)
cell_tracking_options.weights=[4,5,5,0,0,0]; %Ensemble weights (correspond to temporal correlation, centroid distance, overlap, Jensen-Shannon divergence, SNR, decay respectively) Set weight to 0
                                                %to ignore associated metric.
cell_tracking_options.probability_assignment_method='Kmeans'; %(Probabilistic method for assigning identification probabilities)
cell_tracking_options.max_gap=0; %(Number of allowed gaps for cell tracking, set to 0 to only extract neurons through full recording set)
cell_tracking_options.max_dist=40; %(maximum distance between neurons, larger values preferred, this value is corrected, so don't worry about making it too big)
cell_tracking_options.links=[]; %Defaults to no connecting recordings. If activity has been extracted for connecting recordings, this should be a cell array of Sources2D objects


%neurons is a cell array of Sources2D objects containing extracted data
%from recordings. Specify path to variable here, or just load the variable
%and name it neurons. Assumes base folder is SCOUT/Demos
try
    load(fullfile('..','motion_corrected','registered','extraction_1','neurons.mat'))
end

neuron=cellTracking_SCOUT(neurons,cell_tracking_options);

MATCHED_ROIS=neuron.cell_register;
probs=full(neuron.probabilities);
% save('JB483_4days_20240516_20240517_20240524_20240529_SCOUTreg_stab.mat','MATCHED_ROIS','probs')
% save('JB483_4days_20240516_20240517_20240524_20240529_SCOUTreg2.mat','MATCHED_ROIS')
% save('JB509_6days_20250109_20250110_20250114_20250115_20250124_20250127_SCOUTreg.mat','MATCHED_ROIS')