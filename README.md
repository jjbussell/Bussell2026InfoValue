Code for collection and analysis of data contained in Bussell et al. 2026.

01 Bpod contains Matlab and Arduino code to run the information seeking mouse behavioral task using Bpod microcontroller systems (Sanworks). Synchronization TTL pulses from the Bpod system and Inscopix nVista system are recorded on a National Instruments DAQ using DAQOn.m and DAQOff.m. The folder contains three Bpod protocols. InfoseekSyncSignal2 runs the main information seeking task, InfoseekSyncToneGo runs the task with a tone cue on all trials that reveals the reward outcome, and InfoseekWaterVal runs the task with four center port odors, two for information/no information and two for high/low water value.

02 BehaviorAnalysis contains Matlab code for the processing, analysis, and plotting of the behavioral data. BpodProcessSession.m and BpodProcessSessionWaterVal.m pre-process the raw .mat file data collected by Bpod to a per-trial data structure of all variables.
