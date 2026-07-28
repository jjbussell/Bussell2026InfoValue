mouseCells=histc(a.mouse(:),unique(a.mouse));
mouseCellCts=[0; cumsum(mouseCells)];
nmIL=sum(~isnan(a.C_odor1FirstInfoLeft(cumsum(mouseCells),1,:)),3);
nmIR=sum(~isnan(a.C_odor1FirstInfoRight(cumsum(mouseCells),1,:)),3);
nmNL=sum(~isnan(a.C_odor1FirstRandLeft(cumsum(mouseCells),1,:)),3);
nmNR=sum(~isnan(a.C_odor1FirstRandRight(cumsum(mouseCells),1,:)),3);
nmBL=sum(~isnan(a.C_odor1FirstBigLeft(cumsum(mouseCells),1,:)),3);
nmBR=sum(~isnan(a.C_odor1FirstBigRight(cumsum(mouseCells),1,:)),3);
nmSL=sum(~isnan(a.C_odor1FirstSmallLeft(cumsum(mouseCells),1,:)),3);
nmSR=sum(~isnan(a.C_odor1FirstSmallRight(cumsum(mouseCells),1,:)),3);



i1List = 1:5:76;
e=3;
t=a.t{e}(i1List+2);
i1=41;
i2=51;
tt=a.t{e};
t2=[-39:40];

%% INFO OVER TIME

t2=[-39:40];
for mm=1:numel(okMice)
    m=okMice(mm);

    data1=a.C_odor1FirstInfoLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIL(m));
    dataconcat1=reshape(data1, size(data1,1), []);
    trial1 = repelem(1:size(data1,3), size(data1,2));
    info1=ones(size(trial1));
    side1=-1*ones(size(trial1));
    time1=repmat(t2,1,size(data1,3));
    
    data2=a.C_odor1FirstInfoRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
    dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    info2=ones(size(trial2));
    side2=ones(size(trial2));
    time2=repmat(t2,1,size(data2,3));
    
    data3=a.C_odor1FirstRandLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
    dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = repelem(1+max(trial2):size(data3,3)+max(trial2), size(data3,2));
    info3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
    time3=repmat(t2,1,size(data3,3));
    
    data4=a.C_odor1FirstRandRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
    dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = repelem(1+max(trial3):size(data4,3)+max(trial3), size(data4,2));
    info4=-1*ones(size(trial4));
    side4=ones(size(trial4));
    time4=repmat(t2,1,size(data4,3));
    
    mouse.raster{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4);
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouse.info{mm}=cat(2,info1,info2,info3,info4);
    mouse.side{mm}=cat(2,side1,side2,side3,side4);
    mouse.time{mm}=cat(2,time1,time2,time3,time4);
end

save('decodeDataWaterValInfo.mat','-struct','mouse');

%% INFO MEAN

i1=44; %41
i2=54; %51

for mm=1:numel(okMice)
    m=okMice(mm);

    data1=squeeze(mean(a.C_odor1FirstInfoLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIL(m)),2));
    dataconcat1=reshape(data1, size(data1,1), []);
    trial1 = [1:size(data1,2)];
    info1=ones(size(trial1));
    side1=-1*ones(size(trial1));
%     time1=repmat(t2,1,size(data1,2));

    data2=squeeze(mean(a.C_odor1FirstInfoRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIR(m)),2));    
%     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
    dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
%     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    info2=ones(size(trial2));
    side2=ones(size(trial2));
%     time2=repmat(t2,1,size(data2,3));
    
    data3=squeeze(mean(a.C_odor1FirstRandLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNL(m)),2));    
%     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
    dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
%     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    info3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
%     time3=repmat(t2,1,size(data3,3));
    
    data4=squeeze(mean(a.C_odor1FirstRandRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNR(m)),2));    
%     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
    dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
%     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    info4=-1*ones(size(trial4));
    side4=ones(size(trial4));
%     time4=repmat(t2,1,size(data4,3));
    
    mouse.raster{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4);
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouse.info{mm}=cat(2,info1,info2,info3,info4);
    mouse.side{mm}=cat(2,side1,side2,side3,side4);
%     mouse.time{mm}=cat(2,time1,time2,time3,time4);
end

save('decodeDataWaterValInfoMeanPostLate.mat','-struct','mouse');


%% CLUSTER DATA

i1=41;
i2=51;

for mm=1:numel(okMice)
    m=okMice(mm);

    data1=squeeze(mean(a.C_odor1FirstInfoLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIL(m)),2));
    dataconcat1=reshape(data1, size(data1,1), []);

    data2=squeeze(mean(a.C_odor1FirstInfoRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIR(m)),2));    
    dataconcat2=reshape(data2, size(data2,1), []);
    
    data3=squeeze(mean(a.C_odor1FirstRandLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNL(m)),2));    
    dataconcat3=reshape(data3, size(data3,1), []);

    data4=squeeze(mean(a.C_odor1FirstRandRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNR(m)),2));    
    dataconcat4=reshape(data4, size(data4,1), []);

    data5=squeeze(mean(a.C_odor1FirstBigLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmBL(m)),2));    
    dataconcat5=reshape(data5, size(data5,1), []);

    data6=squeeze(mean(a.C_odor1FirstBigRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmBR(m)),2));    
    dataconcat6=reshape(data6, size(data6,1), []);

    data7=squeeze(mean(a.C_odor1FirstSmallLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmSL(m)),2));    
    dataconcat7=reshape(data7, size(data7,1), []);

    data8=squeeze(mean(a.C_odor1FirstSmallRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmSR(m)),2));    
    dataconcat8=reshape(data8, size(data8,1), []);    
    
    
%     raster.infoL{mm}=dataconcat1;
%     raster.infoR{mm}=dataconcat2;
%     raster.randL{mm}=dataconcat3;
%     raster.randR{mm}=dataconcat4;
%     raster.bigL{mm}=dataconcat5;
%     raster.bigR{mm}=dataconcat6;
%     raster.smallL{mm}=dataconcat7;
%     raster.smallR{mm}=dataconcat8;
    raster.infoL{mm}=data1';
    raster.infoR{mm}=data2';
    raster.randL{mm}=data3';
    raster.randR{mm}=data4';
    raster.bigL{mm}=data5';
    raster.bigR{mm}=data6';
    raster.smallL{mm}=data7';
    raster.smallR{mm}=data8';
    
%     mouse.raster{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4,...
%         dataconcat5,dataconcat6,dataconcat7,dataconcat8);

end

save('clusterDataWaterValInfoMeanPostLate.mat','-struct','raster');


%% INFO WITHOUT CELLS
cells=infoCells;
% cells=infoCells;
cells=~cells;
cells = cells(:);

% i=10;
% cells=randomAngleCells(i,:)';
% cells = cells(:);

i1=44;
i2=54;

for mm=1:numel(okMice)
    m=okMice(mm);

    data1=squeeze(mean(a.C_odor1FirstInfoLeft(a.mouse==m&~cells,i1:i2,1:nmIL(m)),2));
    dataconcat1=reshape(data1, size(data1,1), []);
    trial1 = [1:size(data1,2)];
    info1=ones(size(trial1));
    side1=-1*ones(size(trial1));
%     time1=repmat(t2,1,size(data1,2));

    data2=squeeze(mean(a.C_odor1FirstInfoRight(a.mouse==m&~cells,i1:i2,1:nmIR(m)),2));    
%     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
    dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
%     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    info2=ones(size(trial2));
    side2=ones(size(trial2));
%     time2=repmat(t2,1,size(data2,3));
    
    data3=squeeze(mean(a.C_odor1FirstRandLeft(a.mouse==m&~cells,i1:i2,1:nmNL(m)),2));    
%     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
    dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
%     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    info3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
%     time3=repmat(t2,1,size(data3,3));
    
    data4=squeeze(mean(a.C_odor1FirstRandRight(a.mouse==m&~cells,i1:i2,1:nmNR(m)),2));    
%     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
    dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
%     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    info4=-1*ones(size(trial4));
    side4=ones(size(trial4));
%     time4=repmat(t2,1,size(data4,3));
    
    mouse.raster{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4);
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouse.info{mm}=cat(2,info1,info2,info3,info4);
    mouse.side{mm}=cat(2,side1,side2,side3,side4);
%     mouse.time{mm}=cat(2,time1,time2,time3,time4);
end

save('decodeDataWaterValInfoMeanPostLateOnlyInfoCellsEBM.mat','-struct','mouse');


%% WATER MEAN
i1=44;
i2=54;

for mm=1:numel(okMice)
    m=okMice(mm);

    data1=squeeze(mean(a.C_odor1FirstBigLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmBL(m)),2));
    dataconcat1=reshape(data1, size(data1,1), []);
    trial1 = [1:size(data1,2)];
    water1=ones(size(trial1));
    side1=-1*ones(size(trial1));
%     time1=repmat(t2,1,size(data1,2));

    data2=squeeze(mean(a.C_odor1FirstBigRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmBR(m)),2));    
%     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
    dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
%     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    water2=ones(size(trial2));
    side2=ones(size(trial2));
%     time2=repmat(t2,1,size(data2,3));
    
    data3=squeeze(mean(a.C_odor1FirstSmallLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmSL(m)),2));    
%     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
    dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
%     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    water3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
%     time3=repmat(t2,1,size(data3,3));
    
    data4=squeeze(mean(a.C_odor1FirstSmallRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmSR(m)),2));    
%     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
    dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
%     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    water4=-1*ones(size(trial4));
    side4=ones(size(trial4));
%     time4=repmat(t2,1,size(data4,3));
    
    mouse.raster{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4);
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouse.water{mm}=cat(2,water1,water2,water3,water4);
    mouse.side{mm}=cat(2,side1,side2,side3,side4);
%     mouse.time{mm}=cat(2,time1,time2,time3,time4);
end

save('decodeDataWaterValWaterMeanPostLateNORMZ.mat','-struct','mouse');

%% WATER MEAN certain cells

i1=44;
i2=54;

% cells=waterAngleCells;
cells=waterCells;

i=10;
% cells=randomAngleCells(i,:)';

cells=~cells;
cells = cells(:);

for mm=1:numel(okMice)
    m=okMice(mm);

    data1=squeeze(mean(a.C_odor1FirstBigLeft(a.mouse==m&~cells,i1:i2,1:nmBL(m)),2));
    dataconcat1=reshape(data1, size(data1,1), []);
    trial1 = [1:size(data1,2)];
    water1=ones(size(trial1));
    side1=-1*ones(size(trial1));
%     time1=repmat(t2,1,size(data1,2));

    data2=squeeze(mean(a.C_odor1FirstBigRight(a.mouse==m&~cells,i1:i2,1:nmBR(m)),2));    
%     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
    dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
%     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    water2=ones(size(trial2));
    side2=ones(size(trial2));
%     time2=repmat(t2,1,size(data2,3));
    
    data3=squeeze(mean(a.C_odor1FirstSmallLeft(a.mouse==m&~cells,i1:i2,1:nmSL(m)),2));    
%     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
    dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
%     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    water3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
%     time3=repmat(t2,1,size(data3,3));
    
    data4=squeeze(mean(a.C_odor1FirstSmallRight(a.mouse==m&~cells,i1:i2,1:nmSR(m)),2));    
%     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
    dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
%     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    water4=-1*ones(size(trial4));
    side4=ones(size(trial4));
%     time4=repmat(t2,1,size(data4,3));
    
    mouse.raster{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4);
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouse.water{mm}=cat(2,water1,water2,water3,water4);
    mouse.side{mm}=cat(2,side1,side2,side3,side4);
%     mouse.time{mm}=cat(2,time1,time2,time3,time4);
end

save('decodeDataWaterValWaterMeanPostLateOnlyWaterCellsEBM.mat','-struct','mouse');

%% WATER OVER TIME

t2=[-39:40];
for mm=1:numel(okMice)
    m=okMice(mm);

    data1=a.C_odor1FirstBigLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmBL(m));
    dataconcat1=reshape(data1, size(data1,1), []);
    trial1 = repelem(1:size(data1,3), size(data1,2));
    info1=ones(size(trial1));
    side1=-1*ones(size(trial1));
    time1=repmat(t2,1,size(data1,3));
    
    data2=a.C_odor1FirstBigRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmBR(m));
    dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    info2=ones(size(trial2));
    side2=ones(size(trial2));
    time2=repmat(t2,1,size(data2,3));
    
    data3=a.C_odor1FirstSmallLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmSL(m));
    dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = repelem(1+max(trial2):size(data3,3)+max(trial2), size(data3,2));
    info3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
    time3=repmat(t2,1,size(data3,3));
    
    data4=a.C_odor1FirstSmallRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmSR(m));
    dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = repelem(1+max(trial3):size(data4,3)+max(trial3), size(data4,2));
    info4=-1*ones(size(trial4));
    side4=ones(size(trial4));
    time4=repmat(t2,1,size(data4,3));
    
    mouse.raster{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4);
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4);
    mouse.water{mm}=cat(2,info1,info2,info3,info4);
    mouse.side{mm}=cat(2,side1,side2,side3,side4);
    mouse.time{mm}=cat(2,time1,time2,time3,time4);
end

save('decodeDataWaterValWater.mat','-struct','mouse');

%% WATER AND INFO MEAN, TOGETHER, WITH CONTEXT
i1=44;
i2=54;

for mm=1:numel(okMice)
    m=okMice(mm);

    data1=squeeze(mean(a.C_odor1FirstBigLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmBL(m)),2));
    dataconcat1=reshape(data1, size(data1,1), []);
    trial1 = [1:size(data1,2)];
    value1=ones(size(trial1));
    side1=-1*ones(size(trial1));
%     time1=repmat(t2,1,size(data1,2));
    context1 = -1*ones(size(trial1));

    data2=squeeze(mean(a.C_odor1FirstBigRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmBR(m)),2));    
%     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
    dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
%     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    value2=ones(size(trial2));
    side2=ones(size(trial2));
%     time2=repmat(t2,1,size(data2,3));
    context2 = -1*ones(size(trial2));
    
    data3=squeeze(mean(a.C_odor1FirstSmallLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmSL(m)),2));    
%     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
    dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
%     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    value3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
%     time3=repmat(t2,1,size(data3,3));
    context3 = -1*ones(size(trial3));
    
    data4=squeeze(mean(a.C_odor1FirstSmallRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmSR(m)),2));    
%     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
    dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
%     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    value4=-1*ones(size(trial4));
    side4=ones(size(trial4));
%     time4=repmat(t2,1,size(data4,3));
    context4 = -1*ones(size(trial4));
    
    data5=squeeze(mean(a.C_odor1FirstInfoLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIL(m)),2));
    dataconcat5=reshape(data5, size(data5,1), []);
    trial5 = [1+max(trial4):size(data5,2)+max(trial4)];
    value5=ones(size(trial5));
    side5=-1*ones(size(trial5));
%     time1=repmat(t2,1,size(data1,2));
    context5 = ones(size(trial5));   

    data6=squeeze(mean(a.C_odor1FirstInfoRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIR(m)),2));    
%     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
    dataconcat6=reshape(data6, size(data6,1), []);
    trial6 = [1+max(trial5):size(data6,2)+max(trial5)];
%     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    value6=ones(size(trial6));
    side6=ones(size(trial6));
%     time2=repmat(t2,1,size(data2,3));
    context6 = ones(size(trial6));
    
    data7=squeeze(mean(a.C_odor1FirstRandLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNL(m)),2));    
%     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
    dataconcat7=reshape(data7, size(data7,1), []);
    trial7 = [1+max(trial6):size(data7,2)+max(trial6)];
%     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    value7=-1*ones(size(trial7));
    side7=-1*ones(size(trial7));
%     time3=repmat(t2,1,size(data3,3));
    context7 = ones(size(trial7));
    
    data8=squeeze(mean(a.C_odor1FirstRandRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNR(m)),2));    
%     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
    dataconcat8=reshape(data8, size(data8,1), []);
    trial8 = [1+max(trial7):size(data8,2)+max(trial7)];
%     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    value8=-1*ones(size(trial8));
    side8=ones(size(trial8));
%     time4=repmat(t2,1,size(data4,3));
    context8 = ones(size(trial8));
       
    
    mouse.raster{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4,dataconcat5,dataconcat6,dataconcat7,dataconcat8);
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4,trial5,trial6,trial7,trial8);
    mouse.value{mm}=cat(2,value1,value2,value3,value4,value5,value6,value7,value8);
    mouse.side{mm}=cat(2,side1,side2,side3,side4,side5,side6,side7,side8);
    mouse.context{mm}=cat(2,context1,context2,context3,context4,context5,context6,context7,context8);
end

save('decodeDataWaterValWaterMeanPostContextAllLate.mat','-struct','mouse');

% res, null = dec.CCGP_with_nullmodel(dichotomy='value', split_rule='context', ndata=100)

%% WATER AND INFO MEAN FOR CVI
i1=41;
i2=51;

for mm=1:numel(okMice)
    m=okMice(mm);

    data1=squeeze(mean(a.C_odor1FirstBigLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmBL(m)),2));
    dataconcat1=reshape(data1, size(data1,1), []);
    trial1 = [1:size(data1,2)];
    value1=ones(size(trial1));
    side1=-1*ones(size(trial1));
%     time1=repmat(t2,1,size(data1,2));
%     context1 = -1*ones(size(trial1));

    data2=squeeze(mean(a.C_odor1FirstBigRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmBR(m)),2));    
%     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
    dataconcat2=reshape(data2, size(data2,1), []);
    trial2 = [1+max(trial1):size(data2,2)+max(trial1)];
%     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    value2=ones(size(trial2));
    side2=ones(size(trial2));
%     time2=repmat(t2,1,size(data2,3));
%     context2 = -1*ones(size(trial2));
    
    data3=squeeze(mean(a.C_odor1FirstSmallLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmSL(m)),2));    
%     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
    dataconcat3=reshape(data3, size(data3,1), []);
    trial3 = [1+max(trial2):size(data3,2)+max(trial2)];
%     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    value3=-1*ones(size(trial3));
    side3=-1*ones(size(trial3));
%     time3=repmat(t2,1,size(data3,3));
%     context3 = -1*ones(size(trial3));
    
    data4=squeeze(mean(a.C_odor1FirstSmallRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmSR(m)),2));    
%     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
    dataconcat4=reshape(data4, size(data4,1), []);
    trial4 = [1+max(trial3):size(data4,2)+max(trial3)];
%     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    value4=-1*ones(size(trial4));
    side4=ones(size(trial4));
%     time4=repmat(t2,1,size(data4,3));
%     context4 = -1*ones(size(trial4));
    
    data5=squeeze(mean(a.C_odor1FirstInfoLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIL(m)),2));
    dataconcat5=reshape(data5, size(data5,1), []);
    trial5 = [1+max(trial4):size(data5,2)+max(trial4)];
    value5=ones(size(trial5));
    side5=-1*ones(size(trial5));
%     time1=repmat(t2,1,size(data1,2));
%     context5 = ones(size(trial5));   

    data6=squeeze(mean(a.C_odor1FirstInfoRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmIR(m)),2));    
%     data2=a.C_odor1FirstInfoForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmIR(m));
    dataconcat6=reshape(data6, size(data6,1), []);
    trial6 = [1+max(trial5):size(data6,2)+max(trial5)];
%     trial2 = repelem(1+max(trial1):size(data2,3)+max(trial1), size(data2,2));
    value6=ones(size(trial6));
    side6=ones(size(trial6));
%     time2=repmat(t2,1,size(data2,3));
%     context6 = ones(size(trial6));
    
    data7=squeeze(mean(a.C_odor1FirstRandLeft(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNL(m)),2));    
%     data3=a.C_odor1FirstRandForcedLeft(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNL(m));
    dataconcat7=reshape(data7, size(data7,1), []);
    trial7 = [1+max(trial6):size(data7,2)+max(trial6)];
%     trial3 = repelem(1+max(trial1)+max(trial2):size(data3,3)+max(trial1)+max(trial2), size(data3,2));
    value7=-1*ones(size(trial7));
    side7=-1*ones(size(trial7));
%     time3=repmat(t2,1,size(data3,3));
%     context7 = ones(size(trial7));
    
    data8=squeeze(mean(a.C_odor1FirstRandRight(mouseCellCts(m)+1:mouseCellCts(m+1),i1:i2,1:nmNR(m)),2));    
%     data4=a.C_odor1FirstRandForcedRight(mouseCellCts(m)+1:mouseCellCts(m+1),:,1:nmNR(m));
    dataconcat8=reshape(data8, size(data8,1), []);
    trial8 = [1+max(trial7):size(data8,2)+max(trial7)];
%     trial4 = repelem(1+max(trial1)+max(trial2)+max(trial3):size(data4,3)+max(trial1)+max(trial2)+max(trial3), size(data4,2));
    value8=-1*ones(size(trial8));
    side8=ones(size(trial8));
%     time4=repmat(t2,1,size(data4,3));
%     context8 = ones(size(trial8));
       
    
    mouse.raster{mm}=cat(2,dataconcat1,dataconcat2,dataconcat3,dataconcat4,dataconcat5,dataconcat6,dataconcat7,dataconcat8);
    mouse.trial{mm}=cat(2,trial1,trial2,trial3,trial4,trial5,trial6,trial7,trial8);
    mouse.value{mm}=cat(2,value1,value2,value3,value4,value5,value6,value7,value8);
    mouse.side{mm}=cat(2,side1,side2,side3,side4,side5,side6,side7,side8);
%     mouse.context{mm}=cat(2,context1,context2,context3,context4,context5,context6,context7,context8);
end

save('decodeDataWaterValMeanPostValueAll.mat','-struct','mouse');

