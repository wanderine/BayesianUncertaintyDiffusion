close all
clear all
clc

draws = 1000;

addpath('/home/andek67/Research_projects/nifti_matlab')

numberofsubjects = 20;

controlsubjects = [1 2 3 6 9 10 12 13 14 15 16 17 18 22 23 24 25 26 27 28];
schzsubjects =    [1 3 5 6 7 8 9 10 11 12 13 14 15 16 18 19 20 21 22 23];

sy = 120; sx = 140; sz = 100;

controlgreaterppm = zeros(sy,sx,sz,'single');
schzgreaterppm = zeros(sy,sx,sz,'single');

controlmean = zeros(sy,sx,sz,'single');
schzmean = zeros(sy,sx,sz,'single');

posteriorcontrolgreater = zeros(sy,sx,sz,draws,'single');
posteriorschzgreater = zeros(sy,sx,sz,draws,'single');

for slicegroup = 2:2
    
    if slicegroup == 1
        slices = 1:25;
    elseif slicegroup == 2
        slices = 26:50;
    elseif slicegroup == 3
        slices = 51:75;
    elseif slicegroup == 4
        slices = 76:100;
    end 
    
    slicegroup
    
    disp('Loading control data')
    
    allcontroldata = zeros(sy,sx,length(slices),numberofsubjects,draws,'single');
    
    for subject = 1:numberofsubjects
        currentsubject = controlsubjects(subject);
        if currentsubject < 10
            subjectstring = ['00' num2str(currentsubject)];
        else
            subjectstring = ['0' num2str(currentsubject)];
        end
        controldata = load_untouch_nii(['control_subject_' subjectstring '_FA_to_target_POSTERIOR_skeletonised_cut.nii' ]);
        controldata = single(controldata.img);
        allcontroldata(:,:,:,subject,:) = squeeze(controldata(:,:,slices,:));
    end
    
    disp('Loading schz data')
    
    allschzdata = zeros(sy,sx,length(slices),numberofsubjects,draws,'single');
    
    for subject = 1:numberofsubjects
        currentsubject = schzsubjects(subject);
        if currentsubject < 10
            subjectstring = ['00' num2str(currentsubject)];
        else
            subjectstring = ['0' num2str(currentsubject)];
        end
        schzdata = load_untouch_nii(['schz_subject_' subjectstring '_FA_to_target_POSTERIOR_skeletonised_cut.nii' ]);
        schzdata = single(schzdata.img);
        allschzdata(:,:,:,subject,:) = squeeze(schzdata(:,:,slices,:));
    end
    
    disp('Doing calculations')
    
    allcontrolstds = zeros(sy,sx,length(slices),numberofsubjects,'single');        
    allschzstds = zeros(sy,sx,length(slices),numberofsubjects,'single');        
        
    for s = 1:numberofsubjects
        allcontrolstds(:,:,:,s) = std(squeeze(allcontroldata(:,:,:,s,:)),0,4);    
        allschzstds(:,:,:,s) = std(squeeze(allschzdata(:,:,:,s,:)),0,4);    
    end

    weightscontrol = 1 ./ (allcontrolstds + eps);
    weightsschz = 1 ./ (allschzstds + eps);
        
    for mcmc = 1:draws
        
        mcmcmean_control = zeros(sy,sx,length(slices),'single');
        mcmcmean_schz = zeros(sy,sx,length(slices),'single');
 
        for subject = 1:numberofsubjects
	        mcmcmean_control = mcmcmean_control + allcontroldata(:,:,:,subject,mcmc) .* weightscontrol(:,:,:,subject);
            mcmcmean_schz = mcmcmean_schz + allschzdata(:,:,:,subject,mcmc) .* weightsschz(:,:,:,subject);
        end
        
        %mcmcmean_control = mcmcmean_control / numberofsubjects;
        %mcmcmean_schz = mcmcmean_schz / numberofsubjects;
        
        mcmcmean_control = mcmcmean_control ./ (sum(weightscontrol,4) + eps);
        mcmcmean_schz = mcmcmean_schz ./ (sum(weightsschz,4) + eps);
        
        posteriorcontrolgreater(:,:,slices,mcmc) = mcmcmean_control - mcmcmean_schz;
        posteriorschzgreater(:,:,slices,mcmc) = mcmcmean_schz - mcmcmean_control;

        
        controlgreaterppm(:,:,slices) = controlgreaterppm(:,:,slices) + single((mcmcmean_control - mcmcmean_schz) > 0.01);
        schzgreaterppm(:,:,slices) = schzgreaterppm(:,:,slices) + single((mcmcmean_schz - mcmcmean_control) > 0.01);
        
        controlmean(:,:,slices) = controlmean(:,:,slices) + mcmcmean_control;
        schzmean(:,:,slices) = schzmean(:,:,slices) + mcmcmean_schz;
        
    end
    
    
    controlgreaterppm(:,:,slices) = controlgreaterppm(:,:,slices) / draws;
    schzgreaterppm(:,:,slices) = schzgreaterppm(:,:,slices) / draws;
    
    controlmean(:,:,slices) = controlmean(:,:,slices) / draws;
    schzmean(:,:,slices) = schzmean(:,:,slices) / draws;
    

    
end

%for z = 1:91
%    for y = 1:91
%        for x = 1:109
%            if controlmean(y,x,z) < 0.2
%                controlgreaterppm(y,x,z) = 0;
%                schzgreaterppm(y,x,z) = 0;
%            end
%        end
%    end
%end

tscorescontrolgreater = mean(posteriorcontrolgreater,4) ./ (std(posteriorcontrolgreater,0,4) + eps);
tscoresschzgreater = mean(posteriorschzgreater,4) ./ (std(posteriorschzgreater,0,4) + eps);

%tscorescontrolgreater = tscorescontrolgreater / max(tscorescontrolgreater(:));
%tscoresschzgreater = tscoresschzgreater / max(tscoresschzgreater(:));

%mask = load_untouch_nii(['MNI152_T1_2mm_brain_mask.nii.gz']);
%mask = double(mask.img);

nii = load_untouch_nii(['template.nii.gz']);
template = double(nii.img);
% 
% nii.img = single(controlgreaterppm);
% save_untouch_nii(nii,['controlgreaterppm_MNI_weighted_2.nii.gz']);
% 
% nii.img = single(schzgreaterppm);
% save_untouch_nii(nii,['schzgreaterppm_MNI_weighted_2.nii.gz']);
% 
% nii.img = single(controlmean);
% save_untouch_nii(nii,['controlmean_MNI_weighted_2.nii.gz']);
% 
% nii.img = single(schzmean);
% save_untouch_nii(nii,['schzmean_MNI_weighted_2.nii.gz']);
% 
nii.img = single(tscorescontrolgreater);
save_untouch_nii(nii,['tscorescontrolgreater_MNI_weighted.nii.gz']);
 
nii.img = single(tscoresschzgreater);
save_untouch_nii(nii,['tscoresschzgreater_MNI_weighted.nii.gz']);

%%

figure(1)
x = 126;
y = 91;
z = 25;
x_values = 0.03:0.001:0.99;

%pd = fitdist(x,'Normal')
%x_values = ;
%y_values = pdf(pd,x_values);

% Plot control FA posteriors
for subject = 1:1
    subject
    FAposterior = squeeze(allcontroldata(y,x,z,subject,:));
    pd = fitdist(double(FAposterior),'Beta');
    y_values = pdf(pd,x_values);
    plot(x_values,y_values,'b');
    hold on        
end

for subject = 1:1
    subject
    FAposterior = squeeze(allschzdata(y,x,z,subject,:));
    pd = fitdist(double(FAposterior),'Beta');
    y_values = pdf(pd,x_values);
    plot(x_values,y_values,'r');
    hold on        
end

for subject = 2:numberofsubjects
    subject
    FAposterior = squeeze(allcontroldata(y,x,z,subject,:));
    pd = fitdist(double(FAposterior),'Beta');
    y_values = pdf(pd,x_values);
    plot(x_values,y_values,'b');
    hold on        
end

% Plot schz FA posteriors
for subject = 1:numberofsubjects
    subject
    FAposterior = squeeze(allschzdata(y,x,z,subject,:));
    pd = fitdist(double(FAposterior),'Beta');
    y_values = pdf(pd,x_values);
    plot(x_values,y_values,'r');
    hold on    
    std(FAposterior)
end
hold off
axis([0 1 0.05 40])
xlabel('FA')
ylabel('PDF')
title('Posteriors for controls and schizophrenics')
set(gca,'FontSize',15)
legend('Controls','Schizophrenics')

print -dpng posteriors_all_subjects.png
print -depsc posteriors_all_subjects.eps

figure(2)
groupposterior = posteriorcontrolgreater(y,x,z,:);
  pdf = hist(groupposterior,20)
  plot(pdf,'g')
  hold on
  groupposterior = posteriorcontrolgreaterweighted(y,x,z,:);
  pdf = hist(groupposterior,20)
  plot(pdf,'c')
  hold off
  title('Group difference posteriors for unweighted and weighted analyses')
  set(gca,'FontSize',15)
  legend('Unweighted','Weighted')
  














