Download the UCLA dataset from OpenfMRI, https://legacy.openfmri.org/dataset/ds000030/, e.g.

```
wget https://s3.amazonaws.com/openneuro/ds000030/ds000030_R1.0.5/compressed/ds000030_R1.0.5_sub10159-10299.zip

```

and repeat for all the 19 zip files containing subjects 10159 - 70086, run 

```
./download.sh 
```

for simplicity. Unzip all files, and for example pick 20 controls and 20 schizophrenics. Now preprocess the diffusion data, using eddy_correct or eddy in FSL, see preprocessall.sh for an example with eddy_correct (which is much faster than eddy)

```
./preprocessall.sh
```

Now run Bayesian FA posterior estimation for every preprocessed subject, using the modified dipy scripts available here https://github.com/jsjol/dipy , this will result in 1000 FA maps per subject (i.e. a lot of data), in our case for example called control_subject_001_dwi_corrected_fa.nii.gz and schz_subject_001_dwi_corrected_fa.nii.gz

----

Now extract a single FA image for each subject, to be used by TBSS, for example using

```
./extract.sh
```

In our case this will generate files called control_subject_001_FA.nii.gz, which contain a single FA map per subject (instead of 1000).
 
Now copy all FA maps (one per subject) to a new directory, e.g. called TBSS, and follow the standard TBSS steps available here, https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/TBSS/UserGuide , i.e.

```
tbss_1_preproc *.nii.gz

tbss_2_reg -T

tbss_3_postreg -S

tbss_4_prestats 0.2

```

Now make a new directory called POSTERIOR under your TBSS directory, and copy/move your large FA nifti files (containing 1000 FA values per subject) to that directory. Run the modified script, my_tbss_non_FA , to transform all FA posterior images (1000 per subject) to the FA skeleton, note that this may take a long time and use a lot of memory. 

```
my_tbss_non_FA POSTERIOR
```

This script will create a skeletonized file for every subject, e.g. control_subject_001_FA_to_target_POSTERIOR_skeletonised.nii, and project the 1000 FA values onto this skeleton. The nifti file for each subject will be of the size 182 x 218 x 182 x 1000. To make the nifti files smaller, for the group analysis, run

```
./roi.sh
```

Finally, we can now run group analyses in Matlab, using GroupAnalysis.m and GroupAnalysisWeighted.m













 
