#!/bin/bash

for subject in 1 2 3 6 9
do

    fslroi control_subject_00${subject}_FA_to_target_POSTERIOR_skeletonised.nii control_subject_00${subject}_FA_to_target_POSTERIOR_skeletonised_cut.nii 30 120 40 140 45 100 &

done

wait

for subject in 10 12 13 14 
do

    fslroi control_subject_0${subject}_FA_to_target_POSTERIOR_skeletonised.nii control_subject_0${subject}_FA_to_target_POSTERIOR_skeletonised_cut.nii 30 120 40 140 45 100 &

done

wait

for subject in 15 16 17 18 
do

    fslroi control_subject_0${subject}_FA_to_target_POSTERIOR_skeletonised.nii control_subject_0${subject}_FA_to_target_POSTERIOR_skeletonised_cut.nii 30 120 40 140 45 100 &

done

wait

for subject in 22 23 24 25 
do

    fslroi control_subject_0${subject}_FA_to_target_POSTERIOR_skeletonised.nii control_subject_0${subject}_FA_to_target_POSTERIOR_skeletonised_cut.nii 30 120 40 140 45 100 &

done

wait

for subject in 26 27 28
do

    fslroi control_subject_0${subject}_FA_to_target_POSTERIOR_skeletonised.nii control_subject_0${subject}_FA_to_target_POSTERIOR_skeletonised_cut.nii 30 120 40 140 45 100 &

done





for subject in 1 3 5 6
do                                                                                                                 

    fslroi schz_subject_00${subject}_FA_to_target_POSTERIOR_skeletonised.nii schz_subject_00${subject}_FA_to_target_POSTERIOR_skeletonised_cut.nii 30 120 40 140 45 100 &

done                                                                                                               

wait 

for subject in  7 8 9                                                     
do                                                                                                                 

    fslroi schz_subject_00${subject}_FA_to_target_POSTERIOR_skeletonised.nii schz_subject_00${subject}_FA_to_target_POSTERIOR_skeletonised_cut.nii 30 120 40 140 45 100 &

done                                                                                                               

wait

for subject in 10 11 12 13 14 
do                                                                                                                 

    fslroi schz_subject_0${subject}_FA_to_target_POSTERIOR_skeletonised.nii schz_subject_0${subject}_FA_to_target_POSTERIOR_skeletonised_cut.nii 30 120 40 140 45 100 &

done

wait


for subject in  15 16 18 19 
do                                                                                                                 

    fslroi schz_subject_0${subject}_FA_to_target_POSTERIOR_skeletonised.nii schz_subject_0${subject}_FA_to_target_POSTERIOR_skeletonised_cut.nii 30 120 40 140 45 100 &

done

wait


for subject in 20 21 22 23 
do                                                                                                                 

    fslroi schz_subject_0${subject}_FA_to_target_POSTERIOR_skeletonised.nii schz_subject_0${subject}_FA_to_target_POSTERIOR_skeletonised_cut.nii 30 120 40 140 45 100 &

done



