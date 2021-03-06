#!/bin/bash

for subject in 1 2 3 6 9 
do

    fslroi control_subject_00${subject}_dwi_corrected_fa.nii.gz control_subject_00${subject}_FA.nii.gz 0 1

done

for subject in 10 12 13 14 15 16 17 18 22 23 24 25 26 27 28
do

    fslroi control_subject_0${subject}_dwi_corrected_fa.nii.gz control_subject_0${subject}_FA.nii.gz 0 1

done

for subject in 1 3 5 6 7 8 9                                                     
do                                                                                                                 

    fslroi schz_subject_00${subject}_dwi_corrected_fa.nii.gz schz_subject_00${subject}_FA.nii.gz 0 1         

done                                                                                                               

for subject in 10 11 12 13 14 15 16 18 19 20 21 22 23 
do                                                                                                                 

    fslroi schz_subject_0${subject}_dwi_corrected_fa.nii.gz schz_subject_0${subject}_FA.nii.gz 0 1           

done

