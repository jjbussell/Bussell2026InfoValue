function datapath=findInfoseekData()
    desktoppath = 'D:\Bussell Dropbox\Jennifer Bussell\BpodInfoseek\Data';
    laptoppath = 'C:\Users\jbuss\Dropbox\BpodInfoseek\Data';
    desktop2path = 'D:\Bussell Dropbox\Bussell Lab\BpodInfoseek\Data';
    desktop3path = 'C:\Users\Bussell\Bussell Dropbox\Bussell Lab\BpodInfoseek\Data';
    if exist(desktoppath)
      datapath = desktoppath;
    elseif exist(laptoppath)
        datapath = laptoppath;
    elseif exist(desktop2path)
        datapath = desktop2path;
    elseif exist(desktop3path)
        datapath = desktop3path;        
    else   
      datapath=uigetdir('','Choose Bpod data directory');
    end
end