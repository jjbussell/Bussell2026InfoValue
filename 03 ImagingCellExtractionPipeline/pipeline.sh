#!/bin/bash
echo "Beginning imaging processing pipeline"

# # base_dir = 

source C:\\Users\\Axel\\anaconda3\\etc\\profile.d\\conda.sh
conda activate isxenv
echo "Pre-procssing isx video"
python isxpp.py
echo "Preprocessed and downsampled (4X spatial) Tiff files now in the 1PMC folder"

echo "Concatenating same-day sessions and motion correcting"
matlab -wait -nodesktop -r "run motioncorrect.m"
echo "Concatenation and motion correction complete"

echo "Motion correcting to base day"
matlab -wait -nodesktop -r "run motioncorrect_tobase.m"
echo "Motion correction to base complete"

echo "Finding cells with CNMF-E"
matlab -wait -nodesktop -r "run CNMFE_pipe.m"
echo "Cells in CNMFE complete"
