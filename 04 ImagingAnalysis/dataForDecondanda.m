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


%%


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

%% FULL TIME CHOICE

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

%% MEAN FORCED

% 41-51 is original post, but 44-54 is "late" used in water val

i1=41; %29
i2=51; %39

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

%% MEAN CHOICE

i1=44; % 29 44 pre=26
i2=54; %39 54 pre=36

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

%% MEAN FORCED CHOICE POST

% i1=39; % 29 44
% i2=54; %39 54
% 
% t2=[-39:40];
% 
% for mm=1:numel(okMice)
%     m=okMice(mm);
% 
%     data1=squeeze(mean(a.C_odor1FirstInfoForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIL(m)),2));
%     dataconcat1=reshape(data1, size(data1,1), []);
%     trial1 = [1:size(data1,2)];
%     info1=ones(size(trial1));
%     side1=-1*ones(size(trial1));
% %     time1=repmat(t2,1,size(data1,2));
% 
%     data2=squeeze(mean(a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIR(m)),2));    
% %     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
%     dataconcat2=reshape(data2, size(data2,1), []);
%     trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
% %     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
%     info2=ones(size(trial2));
%     side2=ones(size(trial2));
% %     time2=repmat(t2,1,size(data2,3));
%     
%     data3=squeeze(mean(a.C_odor1FirstInfoChoiceLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmICL(m)),2));    
% %     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
%     dataconcat3=reshape(data3, size(data3,1), []);
%     trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
% %     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
%     info3=-1*ones(size(trial3));
%     side3=-1*ones(size(trial3));
% %     time3=repmat(t2,1,size(data3,3));
%     
%     data4=squeeze(mean(a.C_odor1FirstInfoChoiceRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmICR(m)),2));    
% %     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
%     dataconcat4=reshape(data4, size(data4,1), []);
%     trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
% %     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
%     info4=-1*ones(size(trial4));
%     side4=ones(size(trial4));
% %     time4=repmat(t2,1,size(data4,3));
%     
%     mouse.data{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4);
%     mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
%     mouse.info{mm}=cat(2,info1,info2,info3,info4);
%     mouse.side{mm}=cat(2,side1,side2,side3,side4);
% %     mouse.time{mm}=cat(2,time1,time2,time3,time4);
% end
% 
% save('decodeDataMeanChoiceForcedPost.mat','-struct','mouse');

%%
% i1=44; % 29 44
% i2=54; %39 54
% 
% t2=[-39:40];
% 
% for mm=1:numel(okMice)
%     m=okMice(mm);
% 
%     data1=squeeze(mean(a.C_odor1FirstInfoChoiceLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmICL(m)),2));
%     dataconcat1=reshape(data1, size(data1,1), []);
%     trial1 = [1:size(data1,2)];
%     info1=ones(size(trial1));
%     side1=-1*ones(size(trial1));
% %     time1=repmat(t2,1,size(data1,2));
% 
%     data2=squeeze(mean(a.C_odor1FirstInfoChoiceRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmICR(m)),2));    
% %     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
%     dataconcat2=reshape(data2, size(data2,1), []);
%     trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
% %     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
%     info2=ones(size(trial2));
%     side2=ones(size(trial2));
% %     time2=repmat(t2,1,size(data2,3));
%     
%     data3=squeeze(mean(a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNL(m)),2));    
% %     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
%     dataconcat3=reshape(data3, size(data3,1), []);
%     trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
% %     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
%     info3=-1*ones(size(trial3));
%     side3=-1*ones(size(trial3));
% %     time3=repmat(t2,1,size(data3,3));
%     
%     data4=squeeze(mean(a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNR(m)),2));    
% %     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
%     dataconcat4=reshape(data4, size(data4,1), []);
%     trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
% %     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
%     info4=-1*ones(size(trial4));
%     side4=ones(size(trial4));
% %     time4=repmat(t2,1,size(data4,3));
%     
%     mouse.data{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4);
%     mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
%     mouse.info{mm}=cat(2,info1,info2,info3,info4);
%     mouse.side{mm}=cat(2,side1,side2,side3,side4);
% %     mouse.time{mm}=cat(2,time1,time2,time3,time4);
% end
% 
% save('decodeDataMeanChoiceInfoForcedRandPost4454.mat','-struct','mouse');

%% Info choice no info forced certain cells

cells=infoCells;
% cells=infoCells;
cells=~cells;
cells = cells(:);

% i=10;
% cells=randomAngleCells(i,:)';
% cells = cells(:);

i1=41; % 29 44
i2=51; %39 54

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

save('decodeDataMeanChoiceInfoForcedRandPost4151.mat','-struct','mouse');

%% MEAN PREP FOR REVERSE BALANCE

i1=29;
i2=39;

initInfoSide=[0 1 0 1 1 1 1]; %0=left

t2=[-39:40];
for mm=1:numel(okMice)
    m=okMice(mm);
    minT=min([nmIR(m) nmIL(m) nmNR(m) nmNL(m)]);    

    data1=squeeze(mean(a.C_odor1FirstInfoForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIL(m)),2));
%     data1=reshape(data1, size(data1,1), []);
    ts=randperm(size(data1,2));
    data1=data1(:,ts(1:minT));
    trial1 = [1:size(data1,2)];
    info1=ones(size(trial1));
    side1=-1*ones(size(trial1));
%     time1=repmat(t2,1,size(data1,2));
    if initInfoSide(m)==0
        session1=zeros(size(trial1)); % pre-reverse
    else
        session1=ones(size(trial1));
    end

    data2=squeeze(mean(a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIR(m)),2));    
%     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
%     data2=reshape(data2, size(data2,1), []);
    ts=randperm(size(data2,2));
    data2=data2(:,ts(1:minT));    
    trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
%     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    info2=ones(size(trial2));
    side2=ones(size(trial2));
%     time2=repmat(t2,1,size(data2,3));
    if initInfoSide(mm)==1
        session2=zeros(size(trial2));
    else
        session2=ones(size(trial2));
    end
    
    data3=squeeze(mean(a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNL(m)),2));    
%     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
%     data3=reshape(data3, size(data3,1), []);
    ts=randperm(size(data3,2));
    data3=data3(:,ts(1:minT));    
    trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
%     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    info3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
%     time3=repmat(t2,1,size(data3,3));
    if initInfoSide(mm)==1
        session3=zeros(size(trial3));
    else
        session3=ones(size(trial3));
    end
    
    data4=squeeze(mean(a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNR(m)),2));    
%     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
%     data4=reshape(data4, size(data4,1), []);
    ts=randperm(size(data4,2));
    data4=data4(:,ts(1:minT));    
    trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
%     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    info4=-1*ones(size(trial4));
    side4=ones(size(trial4));
%     time4=repmat(t2,1,size(data4,3));
    if initInfoSide(mm)==0
        session4=zeros(size(trial4));
    else
        session4=ones(size(trial4));
    end
    
    mouseAdj.data{mm}=cat(2,data1,data2,data3,data4);
    mouseAdj.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouseAdj.info{mm}=cat(2,info1,info2,info3,info4);
    mouseAdj.side{mm}=cat(2,side1,side2,side3,side4);
%     mouse.time{mm}=cat(2,time1,time2,time3,time4);
    mouseAdj.session{mm}=cat(2,session1,session2,session3,session4);
end

% save('decodeDataMeanPre.mat','-struct','mouse');

%

for mm=1:numel(okMice)
    m=okMice(mm);
    Y=mouseAdj.data{mm}'; % trials x cells
    [nTrials, nNeurons] = size(Y);
    residuals = zeros(size(Y));
    session = mouseAdj.session{mm}';% trials x 1

    % Design matrix with intercept and session indicator
    X = [ones(nTrials, 1), session];

    % Loop over neurons
    for i = 1:nNeurons
        betas{m}([1 2],i) = X \ Y(:, i);  % Linear regression
        predicted = X * beta;
        residuals(:, i) = Y(:, i) - predicted;
    end  
end

%

% i1=44;
% i2=54;

t2=[-39:40];
for mm=1:numel(okMice)
    m=okMice(mm);

    data1=squeeze(mean(a.C_odor1FirstInfoForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIL(m)),2));
    trial1 = [1:size(data1,2)];
    info1=ones(size(trial1));
    side1=-1*ones(size(trial1));
%     time1=repmat(t2,1,size(data1,2));
    if initInfoSide(mm)==0
        session1=zeros(size(trial1)); % pre-reverse
    else
        session1=ones(size(trial1));
    end

    data2=squeeze(mean(a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIR(m)),2));    
%     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
%     dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
%     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    info2=ones(size(trial2));
    side2=ones(size(trial2));
%     time2=repmat(t2,1,size(data2,3));
    if initInfoSide(mm)==1
        session2=zeros(size(trial2));
    else
        session2=ones(size(trial2));
    end
    
    data3=squeeze(mean(a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNL(m)),2));    
%     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
%     dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
%     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    info3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
%     time3=repmat(t2,1,size(data3,3));
    if initInfoSide(mm)==1
        session3=zeros(size(trial3));
    else
        session3=ones(size(trial3));
    end
    
    data4=squeeze(mean(a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNR(m)),2));    
%     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
%     dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
%     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    info4=-1*ones(size(trial4));
    side4=ones(size(trial4));
%     time4=repmat(t2,1,size(data4,3));
    if initInfoSide(mm)==0
        session4=zeros(size(trial4));
    else
        session4=ones(size(trial4));
    end


    Y=cat(2,data1,data2,data3,data4)';
    [nTrials, nNeurons] = size(Y);
    residuals = zeros(size(Y));
    session = cat(2,session1,session2,session3,session4)';% trials x 1   
    % Design matrix with intercept and session indicator
    X = [ones(nTrials, 1), session];

    % Loop over neurons
    for i = 1:nNeurons
        beta=betas{m}([1 2],i);  % Linear regression
        predicted = X * beta;
        residuals(:, i) = Y(:, i) - predicted;
    end      
    
    mouse.data{mm}=residuals';
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouse.info{mm}=cat(2,info1,info2,info3,info4);
    mouse.side{mm}=cat(2,side1,side2,side3,side4);
%     mouse.time{mm}=cat(2,time1,time2,time3,time4);
end

save('decodeDataMeanPreAdj.mat','-struct','mouse');

%% REVERSE BALANCE ACROSS TIME

initInfoSide=[0 1 0 1 1 1 1]; %0=left

t2=[-39:40];
for mm=1:numel(okMice)
    m=okMice(mm);
    
    %take a balanced number of trials (minimum across types)
    minT=min([nmIR(m) nmIL(m) nmNR(m) nmNL(m)]);    

    data1=a.C_odor1FirstInfoForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIL(m));
    ts=randperm(size(data1,3));
    data1=data1(:,:,ts(1:minT));
    if initInfoSide(m)==0 % initInfoSide==left
        session1 = zeros(size(data1,3),1);
    else
        session1 = ones(size(data1,3),1);
    end 
    
    data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
    ts=randperm(size(data2,3));
    data2=data2(:,:,ts(1:minT));
    if initInfoSide(m)==1 % initInfoSide==right
        session2 = zeros(size(data2,3),1);
    else
        session2 = ones(size(data2,3),1);
    end 
    
    data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
    ts=randperm(size(data3,3));
    data3=data3(:,:,ts(1:minT));
    if initInfoSide(m)==1 % initInfoSide==right
        session3 = zeros(size(data3,3),1);
    else
        session3 = ones(size(data3,3),1);
    end 
    
    data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
    ts=randperm(size(data4,3));
    data4=data4(:,:,ts(1:minT));
    if initInfoSide(m)==0 % initInfoSide==left
        session4 = zeros(size(data4,3),1);
    else
        session4 = ones(size(data4,3),1);
    end 
    
    
    Y=cat(3,data1,data2,data3,data4); % cells x time x trials
    [nNeurons, nTime, nTrials] = size(Y);
    residuals = zeros(size(Y));
%     residuals = zeros(size(Y)); % trials x cells
    session=cat(1,session1,session2,session3,session4); % trials x 1
    
    % Design matrix with intercept and session indicator
    X = [ones(nTrials, 1), session]; % trials x 2

    betas=[];
    % Loop over time and neurons
    for t = 1:nTime
        for n = 1:nNeurons
            y_tn = squeeze(Y(n, t, :));       % Trial vector for this timepoint and neuron
            betas{m}(n,t,:) = X \ y_tn;                  % Linear regression
        end
    end

    % APPLY BETA TO FULL DATASET
    data1=a.C_odor1FirstInfoForcedLeft(a.mouse==m,:,1:nmIL(m));
    data2=a.C_odor1FirstInfoForcedRight(a.mouse==m,:,1:nmIR(m));
    data3=a.C_odor1FirstRandForcedLeft(a.mouse==m,:,1:nmNL(m));
    data4=a.C_odor1FirstRandForcedRight(a.mouse==m,:,1:nmNR(m));
    
    if initInfoSide(m)==-1 % initInfoSide==left
        session1 = zeros(size(data1,3),1);
        session2 = ones(size(data2,3),1);
        session3 = ones(size(data3,3),1);
        session4 = zeros(size(data4,3),1);
    else
        session1 = ones(size(data1,3),1);
        session2 = zeros(size(data2,3),1);
        session3 = zeros(size(data3,3),1);
        session4 = ones(size(data4,3),1);
    end
       
    trial1 = repelem(1:size(data1,3), size(data1,2));
    info1=ones(size(trial1));
    side1=-1*ones(size(trial1));
    time1=repmat(t2,1,size(data1,3));
    
    trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    info2=ones(size(trial2));
    side2=ones(size(trial2));
    time2=repmat(t2,1,size(data2,3));
    
    trial3 = repelem(1+max(trial2):size(data3,3)+max(trial2), size(data3,2));
    info3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
    time3=repmat(t2,1,size(data3,3));
    
    trial4 = repelem(1+max(trial3):size(data4,3)+max(trial3), size(data4,2));
    info4=-1*ones(size(trial4));
    side4=ones(size(trial4));
    time4=repmat(t2,1,size(data4,3));
    
    
    % data1 cells x time x trials
    % betas cells x time (2 vals)
    sessions=[]; data=[]; Yresid=[]; beta=[];
    data{1}=data1; data{2}=data2; data{3}=data3; data{4}=data4; % cells x time x trials
    sessions{1}=session1; sessions{2}=session2; sessions{3}=session3; sessions{4}=session4;
    for i=1:4
        Y=data{i};
        [nNeurons, nTime, nTrials] = size(Y);
        session = sessions{i};
        Yresid=zeros(size(Y));
        % Design matrix with intercept and session indicator
        X = [ones(nTrials, 1), session]; % trials x 2
        for t = 1:nTime
            for n = 1:nNeurons
                beta=squeeze(betas{m}(n,t,:));  % Linear regression, beta for intercept and session for this cell
                predicted = X * beta; % session + intercept times coeff to predict activity for each trial for that cell
                Yresid(n, t, :) = squeeze(Y(n,t,:)) - predicted;
            end
        end
        dataResid{m,i}=Yresid;
        dataResidConcat{i}=reshape(Yresid,size(Yresid,1),[]);
    end  
    
    % INFO DATA
    mouseInfoAdj.raster{mm}=[dataResidConcat{1:4}];
    mouseInfoAdj.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouseInfoAdj.info{mm}=cat(2,info1,info2,info3,info4);
    mouseInfoAdj.side{mm}=cat(2,side1,side2,side3,side4);
    mouseInfoAdj.time{mm}=cat(2,time1,time2,time3,time4);    
        
end

save('decodeDataInfoTimeAdj.mat','-struct','mouseInfoAdj');

%% MEAN PREP FOR REVERSE BALANCE

i1=29;
i2=39;

initInfoSide=[0 1 0 1 1 1 1]; %0=left

t2=[-39:40];
for mm=1:numel(okMice)
    m=okMice(mm);
    minT=min([nmIR(m) nmIL(m) nmNR(m) nmNL(m)]);    

    data1=squeeze(mean(a.C_odor1FirstInfoForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIL(m)),2));
    data1=reshape(data1, size(data1,1), []);
    ts=randperm(size(data1,2));
    data1=data1(:,ts(1:minT));
    trial1 = [1:size(data1,2)];
    info1=ones(size(trial1));
    side1=-1*ones(size(trial1));
    time1=repmat(t2,1,size(data1,2));
    if initInfoSide(m)==0
        session1=zeros(size(trial1)); % pre-reverse
    else
        session1=ones(size(trial1));
    end

    data2=squeeze(mean(a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIR(m)),2));    
    data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
    data2=reshape(data2, size(data2,1), []);
    ts=randperm(size(data2,2));
    data2=data2(:,ts(1:minT));    
    trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
    trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    info2=ones(size(trial2));
    side2=ones(size(trial2));
    time2=repmat(t2,1,size(data2,3));
    if initInfoSide(mm)==1
        session2=zeros(size(trial2));
    else
        session2=ones(size(trial2));
    end
    
    data3=squeeze(mean(a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNL(m)),2));    
    data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
    data3=reshape(data3, size(data3,1), []);
    ts=randperm(size(data3,2));
    data3=data3(:,ts(1:minT));    
    trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
    trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    info3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
    time3=repmat(t2,1,size(data3,3));
    if initInfoSide(mm)==1
        session3=zeros(size(trial3));
    else
        session3=ones(size(trial3));
    end
    
    data4=squeeze(mean(a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNR(m)),2));    
    data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
    data4=reshape(data4, size(data4,1), []);
    ts=randperm(size(data4,2));
    data4=data4(:,ts(1:minT));    
    trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
    trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    info4=-1*ones(size(trial4));
    side4=ones(size(trial4));
    time4=repmat(t2,1,size(data4,3));
    if initInfoSide(mm)==0
        session4=zeros(size(trial4));
    else
        session4=ones(size(trial4));
    end
    
    mouseAdj.data{mm}=cat(2,data1,data2,data3,data4);
    mouseAdj.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouseAdj.info{mm}=cat(2,info1,info2,info3,info4);
    mouseAdj.side{mm}=cat(2,side1,side2,side3,side4);
    mouse.time{mm}=cat(2,time1,time2,time3,time4);
    mouseAdj.session{mm}=cat(2,session1,session2,session3,session4);
end

save('decodeDataMeanPre.mat','-struct','mouse');



for mm=1:numel(okMice)
    m=okMice(mm);
    Y=mouseAdj.data{mm}'; % trials x cells
    [nTrials, nNeurons] = size(Y);
    residuals = zeros(size(Y));
    session = mouseAdj.session{mm}';% trials x 1

    Design matrix with intercept and session indicator
    X = [ones(nTrials, 1), session];

    Loop over neurons
    for i = 1:nNeurons
        betas{m}([1 2],i) = X \ Y(:, i);  % Linear regression
        predicted = X * beta;
        residuals(:, i) = Y(:, i) - predicted;
    end  
end

%

% i1=44;
% i2=54;

t2=[-39:40];
for mm=1:numel(okMice)
    m=okMice(mm);

    data1=squeeze(mean(a.C_odor1FirstInfoForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIL(m)),2));
    trial1 = [1:size(data1,2)];
    info1=ones(size(trial1));
    side1=-1*ones(size(trial1));
%     time1=repmat(t2,1,size(data1,2));
    if initInfoSide(mm)==0
        session1=zeros(size(trial1)); % pre-reverse
    else
        session1=ones(size(trial1));
    end

    data2=squeeze(mean(a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIR(m)),2));    
%     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
%     dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
%     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    info2=ones(size(trial2));
    side2=ones(size(trial2));
%     time2=repmat(t2,1,size(data2,3));
    if initInfoSide(mm)==1
        session2=zeros(size(trial2));
    else
        session2=ones(size(trial2));
    end
    
    data3=squeeze(mean(a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNL(m)),2));    
%     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
%     dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
%     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    info3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
%     time3=repmat(t2,1,size(data3,3));
    if initInfoSide(mm)==1
        session3=zeros(size(trial3));
    else
        session3=ones(size(trial3));
    end
    
    data4=squeeze(mean(a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNR(m)),2));    
%     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
%     dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
%     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    info4=-1*ones(size(trial4));
    side4=ones(size(trial4));
%     time4=repmat(t2,1,size(data4,3));
    if initInfoSide(mm)==0
        session4=zeros(size(trial4));
    else
        session4=ones(size(trial4));
    end


    Y=cat(2,data1,data2,data3,data4)';
    [nTrials, nNeurons] = size(Y);
    residuals = zeros(size(Y));
    session = cat(2,session1,session2,session3,session4)';% trials x 1   
    % Design matrix with intercept and session indicator
    X = [ones(nTrials, 1), session];

    % Loop over neurons
    for i = 1:nNeurons
        beta=betas{m}([1 2],i);  % Linear regression
        predicted = X * beta;
        residuals(:, i) = Y(:, i) - predicted;
    end      
    
    mouse.data{mm}=residuals';
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouse.info{mm}=cat(2,info1,info2,info3,info4);
    mouse.side{mm}=cat(2,side1,side2,side3,side4);
%     mouse.time{mm}=cat(2,time1,time2,time3,time4);
end

save('decodeDataMeanPostAdj.mat','-struct','mouse');

%% NEW PREP FOR REVERSE BALANCE WITH FULL TRIAL DATA

betas=[];
for mm=1:numel(okMice)
    m=okMice(mm);
    mouseDays=a.day(trialCts(m)+1:trialCts(m+1));
    [~, a.mouseDays{m}] = ismember(mouseDays,unique(mouseDays));
    
    session=zeros(size(mouseDays));
    session(ismember(a.mouseDays{m},[3 4]))=1;
    
    Y=squeeze(mean(a.C_trial(a.mouse==m,:,1:trialsM(m)),2,'omitnan'))';
    [nTrials, nNeurons] = size(Y);
    
    % Design matrix with intercept and session indicator
    X = [ones(nTrials, 1), session]; % trials x 2

    % Loop over neurons
    for n = 1:nNeurons  
        betas{m}([1 2],n) = X \ Y(:, n);  % Linear regression, beta for intercept and session for this cell
    end

end

i1=44;
i2=54;

t2=[-39:40];
for mm=1:numel(okMice)
    m=okMice(mm);

    data1=squeeze(mean(a.C_odor1FirstInfoForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIL(m)),2));
    trial1 = [1:size(data1,2)];
    info1=ones(size(trial1));
    side1=-1*ones(size(trial1));
%     time1=repmat(t2,1,size(data1,2));
    if initInfoSide(mm)==0
        session1=zeros(size(trial1)); % pre-reverse
    else
        session1=ones(size(trial1));
    end

    data2=squeeze(mean(a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIR(m)),2));    
%     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
%     dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
%     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    info2=ones(size(trial2));
    side2=ones(size(trial2));
%     time2=repmat(t2,1,size(data2,3));
    if initInfoSide(mm)==1
        session2=zeros(size(trial2));
    else
        session2=ones(size(trial2));
    end
    
    data3=squeeze(mean(a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNL(m)),2));    
%     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
%     dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
%     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    info3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
%     time3=repmat(t2,1,size(data3,3));
    if initInfoSide(mm)==1
        session3=zeros(size(trial3));
    else
        session3=ones(size(trial3));
    end
    
    data4=squeeze(mean(a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNR(m)),2));    
%     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
%     dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
%     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    info4=-1*ones(size(trial4));
    side4=ones(size(trial4));
%     time4=repmat(t2,1,size(data4,3));
    if initInfoSide(mm)==0
        session4=zeros(size(trial4));
    else
        session4=ones(size(trial4));
    end


    Y=cat(2,data1,data2,data3,data4)';
    [nTrials, nNeurons] = size(Y);
    residuals = zeros(size(Y));
    session = cat(2,session1,session2,session3,session4)';% trials x 1   
    % Design matrix with intercept and session indicator
    X = [ones(nTrials, 1), session];

    % Loop over neurons
    for i = 1:nNeurons
        beta=betas{m}([1 2],i);  % Linear regression
        predicted = X * beta;
        residuals(:, i) = Y(:, i) - predicted;
    end      
    
    mouse.data{mm}=residuals';
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouse.info{mm}=cat(2,info1,info2,info3,info4);
    mouse.side{mm}=cat(2,side1,side2,side3,side4);
%     mouse.time{mm}=cat(2,time1,time2,time3,time4);
end

save('decodeDataMeanPostAdj2.mat','-struct','mouse');