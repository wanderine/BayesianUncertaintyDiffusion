clear all
close all
clc

load andersdata.mat

numberofsubjects = 20;

x_values = 0.03:0.001:0.99;

% Plot FA posteriors

% Plot first control
for subject = 1:1
    FAposterior = squeeze(smallcontroldata(subject,:));
    pd = fitdist(double(FAposterior'),'Beta');
    y_values = pdf(pd,x_values);
    plot(x_values,y_values,'b');
    hold on
end

% Plot first schz, to get legends right
for subject = 1:1    
    FAposterior = squeeze(smallschzdata(subject,:));
    pd = fitdist(double(FAposterior'),'Beta');
    y_values = pdf(pd,x_values);
    plot(x_values,y_values,'r');
    hold on
end

% Plot controls
for subject = 2:numberofsubjects
    FAposterior = squeeze(smallcontroldata(subject,:));
    pd = fitdist(double(FAposterior'),'Beta');
    y_values = pdf(pd,x_values);
    plot(x_values,y_values,'b');
    hold on
end

% Plot schz
for subject = 2:numberofsubjects
    FAposterior = squeeze(smallschzdata(subject,:));
    pd = fitdist(double(FAposterior'),'Beta');
    y_values = pdf(pd,x_values);
    plot(x_values,y_values,'r');
    hold on    
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

%%

figure(2)

%pdunweighted = fitdist(groupposteriorunweighted,'Normal');
%pdweighted = fitdist(groupposteriorweighted,'Normal');

x_values = 0:0.001:0.15;
y_values_unweighted = pdf(pdunweighted,x_values);
y_values_weighted = pdf(pdweighted,x_values);

plot(x_values,y_values_unweighted,'c')
hold on
plot(x_values,y_values_weighted,'g')
hold off

legend('Unweighted','Weighted')

xlabel('FA group difference')
ylabel('PDF')
title('Posteriors for unweighted and weighted group analysis')
set(gca,'FontSize',15)

print -dpng groupdifference_weighted_unweighted.png
print -depsc groupdifference_weighted_unweighted.eps

%%


meanwc = mean(weightscontrol,4);
meanwc(meanwc > 500) = 0;

meanws = mean(weightsschz,4);
meanws(meanws > 500) = 0;

figure(3)
imagesc(flipud(meanwc(:,:,20)'),[0 100]); colorbar; colormap gray; axis image; axis off
title('Mean weight controls')
set(gca,'FontSize',15)
print -dpng weight_controls.png
print -depsc weight_controls.eps

figure(4)
imagesc(flipud(meanws(:,:,20)'),[0 100]); colorbar; colormap gray; axis image; axis off
title('Mean weight schizophrenics')
set(gca,'FontSize',15)
print -dpng weight_schz.png
print -depsc weight_schz.eps

figure(5)
imagesc([flipud(meanwc(:,:,20)') - flipud(meanws(:,:,20)')],[-20 20]); colorbar; colormap gray; axis image; axis off
title('Weight difference (controls - schizophrenics)')
set(gca,'FontSize',15)
print -dpng weight_differences.png
print -depsc weight_differences.eps

figure(6)
imagesc([flipud(meanwc(:,:,20)') ./( flipud(meanws(:,:,20)') + eps)],[0.5 1.5]); colorbar; colormap gray; axis image; axis off
title('Weight ratio (controls / schizophrenics)')
set(gca,'FontSize',15)
print -dpng weight_ratio.png
print -depsc weight_ratio.eps





