%% Motion correcting to "base day"

% uses normcorre algorithm to motion correct each frame of current imaging
% session to the template of a "base" or anchor day to improve
% registration of ROIs across sessions

clear;

if isdir('F:\1PMC')
    MCdir = 'F:\1PMC';
else
    MCdir = 'D:\1PMC';
end

datadir = findInfoseekData();

% designated the data set/experiment to load the sessions table that labels
% the base day
dataset='ImagingJB424'; %'ImagingJB'
% dataset = 'JB509';
% dataset = 'WaterValEarly';
% dataset = 'Stay';

load(fullfile(datadir,['BpodInfoseekSessions_',dataset,'.mat']));

files = dir(fullfile(MCdir,'JB*PP4X_MC.tiff'));
for f=1:numel(files)
    tic;
    parts=strsplit(files(f).name,{'_','-'});
    tiff_name = fullfile(MCdir,[parts{1} '_' parts{2} '_PP4X_MC_MCmid.tiff']);
    if isempty(dir(tiff_name)) % only run if haven't done yet
    mouse=parts{1};
    baseloc= find(strcmp(session.mouse,mouse)&session.anchor==1);
    basepattern=fullfile(MCdir,[session.mouse{baseloc} '_' session.date{baseloc} '*_PP*_MC.mat']);
    basefile=dir(basepattern);
    if ~isempty(basefile) % only run if have basefile
    load(fullfile(MCdir,basefile.name));
    name=fullfile(MCdir,files(f).name);
    
    Y = bigread2(name);
    Y = single(Y);
    [d1,d2,T] = size(Y);
    showpic(mean(Y,3)); % mean pre-MC
    
    %% filter

    s1=2; %3 %2
    s2=6; %8 %12
    th=4; %4%8 %6

    for t = 1:T
        Ys = imgaussfilt(-Y(:,:,t),s1) - imgaussfilt(-Y(:,:,t),s2); %difference of gaussians
        Ys(Ys<th)=th;
        Yf(:,:,t)=Ys;
    end
    
    meanFilt=mean(Yf,3);
    showpic(meanFilt);  % mean filtered pre-MC 

    %% rigid motion correction

    options_r = NoRMCorreSetParms('d1',d1,'d2',d2,'bin_width',500,'init_batch',1000,'max_shift',10,'iter',2,'boundary','zero','correct_bidir',false);

    % can try non-rigid motion correction if field of view has changed
    % across sessions
    options_nr = NoRMCorreSetParms('d1',d1,'d2',d2,'bin_width',2000, ...
        'grid_size',[32,32],'mot_uf',4,'correct_bidir',false,'max_dev',[8,8], ...
        'overlap_pre',24,'overlap_post',24,'max_shift',40,'use_parallel',true,'upd_template',false,'boundary','zero');    
    
    %% register using the filtered data to base day template, generates template 2 for this motion corrected video

    [~,shifts2,template2] = normcorre_batch(Yf,options_r,template1);  
    
    % if using non-rigid normcorre
%     [~,shifts2,template2] = normcorre_batch(Yf,options_nr,template1);  

    clear Yf;
    
    showpic(template2);
    fig=gcf;
    saveas(fig,fullfile(MCdir,[mouse '_' parts{2} '_MCmid_template2']),'tif');
    
    %%  apply shifts to original data
    
    Mr = apply_shifts(Y,shifts2,options_r); % apply shifts to full dataset
    clear Y;
    
    showpic(mean(Mr,3));
    fig=gcf;
    saveas(fig,fullfile(MCdir,[mouse '_' parts{2} '_MCmid_mean']),'tif');  
    
    meanMCmid = mean(Mr,3);
    meanMCmidfilt=imgaussfilt(-meanMCmid,s1) - imgaussfilt(-meanMCmid,s2);
    meanMCmidfilt(meanMCmidfilt<th)=th;
    showpic(meanMCmidfilt);
    fig=gcf;
    saveas(fig,fullfile(MCdir,[mouse '_' parts{2} '_MCmid_meanfilt']),'tif');    
    
    %% Save template, filtered vid, registered vid, shifts    

%     tiff_name = fullfile(MCdir,[parts{1} '_' parts{2} '_PP4X_MC_MCmid.tiff']);
    fTIF = Fast_BigTiff_Write(tiff_name);
    for t = 1:T
       fTIF.WriteIMG(uint16(flipud(rot90(Mr(:,:,t))))); 
    end
    fTIF.close;
    
    clear Mr;

    %%
    save(fullfile(MCdir,[parts{1} '_' parts{2} '_PP4X_MC_MCmid.mat']),'basefile','template2','shifts2','template1','options_r','s1','s2','th','meanFilt','meanMCmid','meanMCmidfilt');
    disp('Finished file: ')
    [parts{1} '_' parts{2} '_PP4X_MC_MCmid']
    toc
    end
    end
end


exit()