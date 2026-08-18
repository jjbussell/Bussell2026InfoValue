%% DataForDecodanda

% processing data to create the inputs for the Decodanda package:
% https://github.com/lposani/decodanda


%% Housekeeping

mouseCells=histc(a.mouse(:),unique(a.mouse));
mouseCellCts=[0; cumsum(mouseCells)];
nmIR=sum(~isnan(a.C_odor1FirstInfoForcedRight(cumsum(mouseCells),1,:)),3);
nmIL=sum(~isnan(a.C_odor1FirstInfoForcedLeft(cumsum(mouseCells),1,:)),3);
nmNL=sum(~isnan(a.C_odor1FirstRandForcedLeft(cumsum(mouseCells),1,:)),3);
nmNR=sum(~isnan(a.C_odor1FirstRandForcedRight(cumsum(mouseCells),1,:)),3);
nmCIR=sum(~isnan(a.C_odor1FirstInfoChoiceRight(cumsum(mouseCells),1,:)),3);
nmCIL=sum(~isnan(a.C_odor1FirstInfoChoiceLeft(cumsum(mouseCells),1,:)),3);

i1List = 1:5:76;
e=3;
t=a.t{e}(i1List+2);
i1=41;
i2=51;
tt=a.t{e};
t2=[-39:40];

trialsM=sum(~isnan(a.C_events{3}(cumsum(mouseCells),1,:)),3);
trialCts=[0;cumsum(trialsM)];


%% Full trial data - forced trials

for mm=1:numel(okMice)
    m=okMice(mm);

    data1=a.C_odor1FirstInfoForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIL(m));
    dataconcat1=reshape(data1, size(data1,1), []);
    trial1 = repelem(1:size(data1,3), size(data1,2));
    info1=ones(size(trial1));
    side1=-1*ones(size(trial1));
    time1=repmat(t2,1,size(data1,3));
    
    data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
    dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    info2=ones(size(trial2));
    side2=ones(size(trial2));
    time2=repmat(t2,1,size(data2,3));
    
    data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
    dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = repelem(1+max(trial2):size(data3,3)+max(trial2), size(data3,2));
    info3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
    time3=repmat(t2,1,size(data3,3));
    
    data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
    dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = repelem(1+max(trial3):size(data4,3)+max(trial3), size(data4,2));
    info4=-1*ones(size(trial4));
    side4=ones(size(trial4));
    time4=repmat(t2,1,size(data4,3));
    
    mouse.data{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4);
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouse.info{mm}=cat(2,info1,info2,info3,info4);
    mouse.side{mm}=cat(2,side1,side2,side3,side4);
    mouse.time{mm}=cat(2,time1,time2,time3,time4);
end

save('decodeData.mat','-struct','mouse');

%% FULL TRIAL DATA - CHOICE TRIALS

nmCIR=sum(~isnan(a.C_odor1FirstInfoChoiceRight(cumsum(mouseCells),1,:)),3);
nmCIL=sum(~isnan(a.C_odor1FirstInfoChoiceLeft(cumsum(mouseCells),1,:)),3);
nmCNL=sum(~isnan(a.C_odor1FirstRandChoiceLeft(cumsum(mouseCells),1,:)),3);
nmCNR=sum(~isnan(a.C_odor1FirstRandChoiceRight(cumsum(mouseCells),1,:)),3);

for mm=1:numel(okMice)
    m=okMice(mm);

    data1=a.C_odor1FirstInfoChoiceLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmCIL(m));
    dataconcat1=reshape(data1, size(data1,1), []);
    trial1 = repelem(1:size(data1,3), size(data1,2));
    info1=ones(size(trial1));
    side1=-1*ones(size(trial1));
    time1=repmat(t2,1,size(data1,3));
    
    data2=a.C_odor1FirstInfoChoiceRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmCIR(m));
    dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    info2=ones(size(trial2));
    side2=ones(size(trial2));
    time2=repmat(t2,1,size(data2,3));
    
    data3=a.C_odor1FirstRandChoiceLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmCNL(m));
    dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = repelem(1+max(trial2):size(data3,3)+max(trial2), size(data3,2));
    info3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
    time3=repmat(t2,1,size(data3,3));
    
    data4=a.C_odor1FirstRandChoiceRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmCNR(m));
    dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = repelem(1+max(trial3):size(data4,3)+max(trial3), size(data4,2));
    info4=-1*ones(size(trial4));
    side4=ones(size(trial4));
    time4=repmat(t2,1,size(data4,3));
    
    mouse.data{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4);
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouse.info{mm}=cat(2,info1,info2,info3,info4);
    mouse.side{mm}=cat(2,side1,side2,side3,side4);
    mouse.time{mm}=cat(2,time1,time2,time3,time4);
end

save('decodeDataChoice.mat','-struct','mouse');

%% MEAN ACTIVITY POST-CENTER ODOR ON FORCED TRIALS

% 41-51 is original post-odor time period, but 44-54 is "late" used in
% water value decoding

i1=41; % use 44 for comparisons with water value encoding
i2=51; % use 54 for comparisons with water value encoding

t2=[-39:40];
for mm=1:numel(okMice)
    m=okMice(mm);

    data1=squeeze(mean(a.C_odor1FirstInfoForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIL(m)),2));
    dataconcat1=reshape(data1, size(data1,1), []);
    trial1 = [1:size(data1,2)];
    info1=ones(size(trial1));
    side1=-1*ones(size(trial1));
%     time1=repmat(t2,1,size(data1,2));

    data2=squeeze(mean(a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIR(m)),2));    
%     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
    dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
%     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    info2=ones(size(trial2));
    side2=ones(size(trial2));
%     time2=repmat(t2,1,size(data2,3));
    
    data3=squeeze(mean(a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNL(m)),2));    
%     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
    dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
%     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    info3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
%     time3=repmat(t2,1,size(data3,3));
    
    data4=squeeze(mean(a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNR(m)),2));    
%     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
    dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
%     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    info4=-1*ones(size(trial4));
    side4=ones(size(trial4));
%     time4=repmat(t2,1,size(data4,3));
    
    mouse.data{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4);
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouse.info{mm}=cat(2,info1,info2,info3,info4);
    mouse.side{mm}=cat(2,side1,side2,side3,side4);
%     mouse.time{mm}=cat(2,time1,time2,time3,time4);
end

save('decodeDataMeanPost4151.mat','-struct','mouse');

%% MEAN ACTIVITY POST-CENTER ODOR ON CHOICE TRIALS

i1=44;
i2=54;

t2=[-39:40];
for mm=1:numel(okMice)
    m=okMice(mm);

    data1=squeeze(mean(a.C_odor1FirstInfoChoiceLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmCIL(m)),2));
    dataconcat1=reshape(data1, size(data1,1), []);
    trial1 = [1:size(data1,2)];
    info1=ones(size(trial1));
    side1=-1*ones(size(trial1));
%     time1=repmat(t2,1,size(data1,2));

    data2=squeeze(mean(a.C_odor1FirstInfoChoiceRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmCIR(m)),2));    
%     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
    dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
%     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    info2=ones(size(trial2));
    side2=ones(size(trial2));
%     time2=repmat(t2,1,size(data2,3));
    
    data3=squeeze(mean(a.C_odor1FirstRandChoiceLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmCNL(m)),2));    
%     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
    dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
%     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    info3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
%     time3=repmat(t2,1,size(data3,3));
    
    data4=squeeze(mean(a.C_odor1FirstRandChoiceRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmCNR(m)),2));    
%     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
    dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
%     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    info4=-1*ones(size(trial4));
    side4=ones(size(trial4));
%     time4=repmat(t2,1,size(data4,3));
    
    mouse.data{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4);
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouse.info{mm}=cat(2,info1,info2,info3,info4);
    mouse.side{mm}=cat(2,side1,side2,side3,side4);
%     mouse.time{mm}=cat(2,time1,time2,time3,time4);
end

save('decodeDataChoiceMean4454.mat','-struct','mouse');

%% MEAN ACTIVITY POST-CENTER ODOR ON INFO CHOICE AND NO INFO FORCED TRIALS

i1=44; % 29 for pre-odor, 44 - for "late" post-odor
i2=54; % 39 for pre-odor, 54 - for "late" post-odor

t2=[-39:40];

for mm=1:numel(okMice)
    m=okMice(mm);

    data1=squeeze(mean(a.C_odor1FirstInfoChoiceLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmICL(m)),2));
    dataconcat1=reshape(data1, size(data1,1), []);
    trial1 = [1:size(data1,2)];
    info1=ones(size(trial1));
    side1=-1*ones(size(trial1));
%     time1=repmat(t2,1,size(data1,2));

    data2=squeeze(mean(a.C_odor1FirstInfoChoiceRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmICR(m)),2));    
%     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
    dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
%     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    info2=ones(size(trial2));
    side2=ones(size(trial2));
%     time2=repmat(t2,1,size(data2,3));
    
    data3=squeeze(mean(a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNL(m)),2));    
%     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
    dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
%     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    info3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
%     time3=repmat(t2,1,size(data3,3));
    
    data4=squeeze(mean(a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNR(m)),2));    
%     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
    dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
%     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    info4=-1*ones(size(trial4));
    side4=ones(size(trial4));
%     time4=repmat(t2,1,size(data4,3));
    
    mouse.data{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4);
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouse.info{mm}=cat(2,info1,info2,info3,info4);
    mouse.side{mm}=cat(2,side1,side2,side3,side4);
%     mouse.time{mm}=cat(2,time1,time2,time3,time4);
end

save('decodeDataMeanChoiceInfoForcedRandPost4454.mat','-struct','mouse');

