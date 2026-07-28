import os
import isx
import argparse
from glob import glob

if __name__ == '__main__':
    

    
    if os.path.isdir(os.path.join(r'F:\1PMC')):
        data_dir = os.path.join(r'F:\1PData')
        output_dir = os.path.join(r'F:\1PMC')
        GPIO_output_dir = os.path.join(r'F:\1PFinal')
        GPIO_temp_dir = os.path.join(r'F:','1PData')
    else:
        data_dir = os.path.join(r'D:\1PData')
        output_dir = os.path.join(r'D:\1PMC')
        GPIO_output_dir = os.path.join(r'D:\1PFinal')
        GPIO_temp_dir = os.path.join(r'D:','1PData')
        
    filenames = glob(os.path.join(data_dir,'*', '*.isxd'))
    GPIOnames = glob(os.path.join(data_dir,'*','*.gpio'))
    
    for file in filenames:
        # filename = (file.split('\\')[-2]) #Name of the files with extension
        print(file)
#         output_dir = os.path.join(r'D:\1PMC')
        # print(output_dir)
        output_files = isx.make_output_file_paths([file], output_dir,'PP')
        # print(output_files)
        if not os.path.isfile(output_files[0]):
            if (file.split('\\')[-2]).split('_')[-2]=='JB413':
                isx.preprocess([file], output_files, spatial_downsample_factor=4, crop_rect=(32,0,800,997))
                print("JB413. Cropping")
            else:
                # isx.preprocess([file], output_files)
                isx.preprocess([file], output_files, spatial_downsample_factor=4)
        else:
            print("PP isxd file already exists")
        tiff_name=(file.split('\\')[-2]).split('-')[-2]+'_'+''.join((file.split('\\')[-1]).split('_')[-2].split('-')[3:6])+'_PP4X.tiff'
        tiff_movie_file = os.path.join(output_dir, tiff_name)
        if not os.path.isfile(tiff_movie_file):
            isx.export_movie_to_tiff(output_files,tiff_movie_file, write_invalid_frames=True)
        else:
            print("Tiff file already exists")
        if os.path.exists(output_files[0]):
            os.remove(output_files[0])
            print('deleting isx PP file')
            print(output_files[0])
        else:
            print("isxd PP file does not exist")
        
    for GPIOfile in GPIOnames:
        GPIOname=(GPIOfile.split('\\')[-2]).split('-')[-2]+'_'+''.join((GPIOfile.split('\\')[-1]).split('_')[-2].split('-')[3:6])+'_GPIO.csv'
    #         GPIO_output_dir=os.path.join(r'D:','1PFinal')
        GPIO_output_file=os.path.join(GPIO_output_dir,GPIOname)
        print(GPIO_output_file)
    #         GPIO_temp_dir = os.path.join(r'D:','1PData')
        if not os.path.isfile(GPIO_output_file):
            isx.export_gpio_set_to_csv(GPIOfile, GPIO_output_file, GPIO_temp_dir)
        else:
            print("GPIO file already exists")
        GPIO_temp_file = os.path.join(GPIO_temp_dir,(GPIOfile.split('\\')[-2]),(GPIOfile.split('\\')[-1]).split('.')[-2]+'_GPIO.isxd')
        if os.path.exists(GPIO_temp_file):
            os.remove(GPIO_temp_file)
        else:
            print("GPIO isxd temp file does not exist") 