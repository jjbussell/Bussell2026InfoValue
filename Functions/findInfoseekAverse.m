function datapath=findInfoseekAverse()
    desktoppath = 'D:\Bussell Dropbox\Jennifer Bussell\InfoseekAverse\Data';
    laptoppath = 'C:\Users\Jen\Bussell Dropbox\Jennifer Bussell\InfoseekAverse\Data';
    desktop2path = 'D:\Bussell Dropbox\Bussell Lab\InfoseekAverse\Data';
	desktop3path = 'C:\Users\Bussell\Dropbox\InfoseekAverse\Data';
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