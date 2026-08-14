% MOTION CORRECTION
% motion correction within a given session
% using the normcorre algorithm on video filtered to extract stationary
% landmarks

clear all;

% Checks for the 1PMC directory with motion-corrected imaging files
if isdir('F:\1PMC')
    basedir = 'F:\1PMC';
else
    basedir = 'D:\1PMC';
end

% tiff files may have been automatically split due to size
basefiles = dir(fullfile(basedir,'JB*PP4X.tiff'));
suppfiles = dir(fullfile(basedir,'JB*PP4X*00*.tiff'));
files=cat(1,basefiles,suppfiles);
for f=1:numel(files)
    filelist{f,1}=files(f).name;
    parts=strsplit(files(f).name,{'_','-'});
    filelist{f,2}=parts{1};
    filelist{f,3}=parts{2};
    filelist{f,4}=parts{3};
    filelist{f,5}=parts{4};
    filelist{f,6}=[parts{1} '_' parts{2}];
end

days=unique(filelist(:,6));


%%
for d=1:numel(days)
    % find files to concatenate 
    dayfiles=strcmp(days{d},filelist(:,6));
    fnames=sort(filelist(dayfiles,1));

    % load and concatenate
    for f=1:numel(fnames)
      disp('Reading file ')
      fnames{f}      
      Y{f}=read_file(fullfile(basedir,fnames{f}));
      Ycat=cat(3,Y{:});
    end
    
    clear Y;
    
    Ycat = single(Ycat);
    [d1,d2,T] = size(Ycat);
    origmean=mean(Ycat,3);

    % FILTER
    s1=2; %2 %3 %2 3 1
    s2=6; %15 %8 %12 8 10
    th=4; % 12 %4 %6 4 10
    
    days{d};
    
    for t = 1:T
        Ys = imgaussfilt(-Ycat(:,:,t),s1) - imgaussfilt(-Ycat(:,:,t),s2); %difference of gaussians
        Ys(Ys<th)=th;
        Yf(:,:,t)=Ys;
    end
    
    origfiltmean=mean(Yf,3);

    %% rigid motion correction

    options_r = NoRMCorreSetParms('d1',d1,'d2',d2,'bin_width',500,'init_batch',1000,'max_shift',10,'iter',2,'correct_bidir',false,'boundary','zero');

    %% register using the filtered data
    
    disp('calculating shifts')
    [~,shifts1,template1] = normcorre_batch(Yf,options_r);
    
    clear Yf;

    %%  apply shifts to original data
    
    disp('applying shifts')
%     options_r = NoRMCorreSetParms('d1',d1,'d2',d2,'bin_width',500,'init_batch',1000,'max_shift',10,'iter',2,'correct_bidir',false);
    Mr = apply_shifts(Ycat,shifts1,options_r);
    
    meanMC = mean(Mr,3);
    clear Ycat;

    %% Save motion corrected vid, template, shifts, concat files  
    disp('saving')
    fname = [days{d} '_PP4X_MC'];
    tiff_name = fullfile(basedir,[fname '.tiff']);
    fTIF = Fast_BigTiff_Write(tiff_name,1,0);
    for t = 1:T
       fTIF.WriteIMG(uint16(flipud(rot90(Mr(:,:,t))))); 
    end
    fTIF.close;
    
    clear Mr;

    %%
    
    meanMCfilt=imgaussfilt(-meanMC,s1) - imgaussfilt(-meanMC,s2);
    meanMCfilt(meanMCfilt<th)=th;  
    
    showpic(meanMC);
    fig=gcf;
    saveas(fig,fullfile(basedir,[fname '_mean']),'tif');
    
    showpic(meanMCfilt);
    fig=gcf;
    saveas(fig,fullfile(basedir,[fname '_meanfilt']),'tif');    
    
    showpic(template1);
    fig=gcf;
    saveas(fig,fullfile(basedir,[fname '_template1']),'tif');    

    %%
    save(fullfile(basedir,[fname '.mat']),'fnames','template1','shifts1','options_r','s1','s2','th','meanMCfilt','meanMC','origmean','origfiltmean');
       
    for fd=1:numel(fnames)
       delete (fullfile(basedir,fnames{fd})) 
    end
end

exit()
% quit