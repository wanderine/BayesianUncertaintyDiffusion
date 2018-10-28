#!/bin/bash

# Loop over all subjects

threads=0
MaximumThreads=10  #subjects to process in parallel

for i in /flush/andek/Data/DTI/ds000030_R1.0.5/* ; do

    cd $i
    # Get subject name
    Subject=${PWD##*/}
    echo "Processing" $Subject
    cd dwi

    eddy_correct ${Subject}_dwi.nii.gz  ${Subject}_dwi_corrected.nii.gz 0 &

    ((threads++))

    if [ "$threads" -eq "$MaximumThreads" ]; then
    	wait
        threads=0
    fi

done
