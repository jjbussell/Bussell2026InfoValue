function DAQOn()

DAQ=1;

if DAQ==1
    global dq
    dq = daq('ni'); 
    try
        ch = addinput(dq, 'Dev1', 0:3, 'Voltage');
    catch
        ch = addinput(dq, 'Dev2', 0:3, 'Voltage');
    end
    ch(1).TerminalConfig = 'Differential';
    ch(2).TerminalConfig = 'Differential';
    ch(3).TerminalConfig = 'Differential';
    ch(4).TerminalConfig = 'Differential';
   
    createDAQFileName();
    dq.Rate = 5000;
    dq.ScansAvailableFcn = @(src,evt) recordDataAvailable(src,evt);
    dq.ScansAvailableFcnCount = 5000;
    start(dq,'continuous')
end

function createDAQFileName()
%     global BpodSystem
    global DataFolder
    DateInfo = datestr(now,30);
    DateInfo(DateInfo == 'T') = '_';
    DataFolder = ('C:\Users\Bussell\DAQSync6\'); % Modify as needed
    global DAQFileName
    DAQFileName = string([DateInfo 'DAQout.csv']);
end

function recordDataAvailable(src,~)
    global DataFolder
    global DAQFileName
    fprintf("While loop: Scans acquired = %d\n", src.NumScansAcquired)
    tic
    [data,timestamps,~] = read(src, 'all', 'OutputFormat','Matrix');
    dlmwrite(strcat(DataFolder, DAQFileName), [data,timestamps],'-append','precision', 16);
    toc
end

function plotDataAvailable(src, ~)
    [data, timestamps, ~] = read(src, src.ScansAvailableFcnCount, "OutputFormat", "Matrix");
    plot(timestamps, data);
end
end