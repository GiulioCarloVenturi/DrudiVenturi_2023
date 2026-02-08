clear;
clc;
% Regression Table 1 (Goldreich, Hanke, Nath; 2005, p.16)

%% Data Preparation
load dataset_final_std.mat
liq_ind = ["Bid_Ask_m" "Roll_m" "Corwin_Schultz_m" "Abdi_Ranaldo_m" "Hui_Heubel_m" "Amihud_m" "Volume_m" ];
liq_ind_name = ["Bid Ask" "Roll" "Corwin Schultz" "Abdi Ranaldo" "Hui Heubel" "Amihud" "Volume" ];
liq_ind_label = ["Bid Ask" "Roll" "Corwin Schultz" "Abdi Ranaldo" "Hui Heubel" "Amihud" "Volume" ];
nind = size(liq_ind,2);
time = dataset_final.time;

%% Dependent Variable
y = table2array(dataset_final(:,"delta_yld"))*100;

%% Independent Variable
% On-Off Fixed Effect
dummy = dataset_final(:,28:end);
% Independent Variable
X = cell(nind,1);
for i = 1:nind
    X{i,1} = table2array([dataset_final(:,liq_ind(i)) dummy]);
end

%% Linear Model
lm = cell(size(X,1),3);
for i = 1:size(lm,1)
lm{i,1} = fitlm(X{i,1},y,'Intercept',false);
lm{i,3} = lm{i,1}.Residuals.Raw;
end

lm_OLS = cell(nind+1,3);
lm_OLS{1,1} = 'OLS';
lm_OLS{1,2} = 'Coefficient';
lm_OLS{1,3} = 'SE';
for i = 1:nind
lm_OLS{i+1,1} = liq_ind_name(i);
lm_OLS{i+1,2} = table2array(lm{i,1}.Coefficients(1,1));
lm_OLS{i+1,3} = table2array(lm{i,1}.Coefficients(1,2));
end

%% Heteroskedasticity and Autocorrelation Analysis
% Residuals
figure;
for i = 1:nind
subplot(4,2,i)
plot(time,lm{i,3},'b*')
ylabel('Residuals')
title(liq_ind_name(i))
end
% Lagged Residuals
figure;
for i = 1:nind
subplot(4,2,i)
plotResiduals(lm{i,1},"lagged")
title(liq_ind_name(i))
end
% Autocorrelations
figure;
for i = 1:nind
subplot(8,2,i+1*(i-1))
autocorr(lm{i,3});
ylabel('SACF')
title(liq_ind_name(i))
subplot(8,2,i*2);
parcorr(lm{i,3});
ylabel('SPACF')
title(liq_ind_name(i))
end

%% HAC
lm_HAC = cell(nind+1,3);
lm_HAC{1,1} = 'HAC';
lm_HAC{1,2} = 'Coefficient';
lm_HAC{1,3} = 'SE';
for i = 1:nind
[EstCoeffCov,se,coeff] = hac(X{i},y,Type='HAC',Bandwidth=4,Intercept=false,Display="off");
lm_HAC{i+1,1} = liq_ind_name(i);
lm_HAC{i+1,2} = coeff(1);
lm_HAC{i+1,3} = se(1);
end

%% FGLS
lm_fgls=cell(nind+1,1);
beta = zeros(nind,1);
lm_fgls{1,1} = 'FGLS';
lm_fgls{1,2} = 'Coefficient';
lm_fgls{1,3} = 'SE';
for i = 1:nind
lm_fgls{i+1,1} = liq_ind_name(i);
[coeff,SE] = fgls(X{i,1},y,'intercept',false,ARLags=4,InnovMdl="HC0");
lm_fgls{i+1,2} = coeff(1);
beta(i,1) = coeff(1);
lm_fgls{i+1,3} = SE(1);
end

%% Summarize Models
nmodels = 3;
lm_summary = cell(nind+1,7);
for i = 1:(nind+1)
lm_summary{i,1} = lm_OLS{i,1};   
lm_summary{i,2} = lm_OLS{i,2};
lm_summary{i,3} = lm_OLS{i,3};
lm_summary{i,4} = lm_HAC{i,2};
lm_summary{i,5} = lm_HAC{i,3};
lm_summary{i,6} = lm_fgls{i,2};
lm_summary{i,7} = lm_fgls{i,3};
end
lm_summary{1,1} = '';
lm_summary{1,2} = 'Coefficient OLS';
lm_summary{1,4} = 'Coefficient HAC';
lm_summary{1,6} = 'Coefficient FGLS';

for i = 1:nind
    for j = 1:nmodels
    if 1-normcdf(abs(lm_summary{i+1,2*j}./lm_summary{i+1,2*j+1})) > 0.05 && 1-normcdf(abs(lm_summary{i+1,2*j}./lm_summary{i+1,2*j+1})) <= 0.10
lm_summary{i+1,2*j} = strcat(num2str(round(lm_summary{i+1,2*j},5)),'*  ');
    elseif 1-normcdf(abs(lm_summary{i+1,2*j}./lm_summary{i+1,2*j+1})) > 0.01 && 1-normcdf(abs(lm_summary{i+1,2*j}./lm_summary{i+1,2*j+1})) <= 0.05
lm_summary{i+1,2*j} = strcat(num2str(round(lm_summary{i+1,2*j},5)),'** ');
    elseif 1-normcdf(abs(lm_summary{i+1,2*j}./lm_summary{i+1,2*j+1})) <= 0.01 
lm_summary{i+1,2*j} = strcat(num2str(round(lm_summary{i+1,2*j},5)),'***');
    else
lm_summary{i+1,2*j} = strcat(num2str(round(lm_summary{i+1,2*j},5)),'   ');
    end
    end
end

lm_summary_Tab1 = lm_summary;

save Regression_results.mat lm_summary_Tab1 beta