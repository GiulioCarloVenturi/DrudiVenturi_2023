clear;
clc;
% Regression Table 5 (Goldreich,Hanke,Nath; 2005, p.26)

%% Data Preparation
load dataset_final_std.mat
liq_ind = ["Bid_Ask_m" "Roll_m" "Corwin_Schultz_m" "Abdi_Ranaldo_m" "Hui_Heubel_m" "Amihud_m" "Volume_m" ];
liq_ind_name = ["Bid Ask" "Roll" "Corwin Schultz" "Abdi Ranaldo" "Hui Heubel" "Amihud" "Volume" ];
nind = size(liq_ind,2);
time = dataset_final.time;
 
%% Dependent Variable
y = table2array(dataset_final(:,"delta_yld"))*100;

%% Independent Variable
% On-Off Fixed Effect
dummy = dataset_final(:,28:(end-1));
% Independent Variable
X = cell(nind,4);
for i = 1:nind
% Liquidity Indicators Future Mean t --> T
X{i,1} = table2array(dataset_final(:,liq_ind(i)));
% Dummy
X{i,2} = table2array(dummy);
end

%% Orthogonalize Liquidity Indicators Future Mean
X_orth = cell(nind,nind);
lm_orth = cell(nind,nind);
for j = 1 : nind
    for i = 1:nind
        lm_orth{j,i} = fitlm([X{i,1},X{j,2}],X{j,1},'Intercept',false); %%
        X_orth{j,i} = lm_orth{j,i}.Residuals.Raw;
    end
end

%% Linear Model
lm = cell(nind,nind);
coefficients_lm = cell(nind+1,nind+1);
coefficients_lm{1,1} = 'OLS';
for i = 1 : nind
    coefficients_lm{1,i+1} = liq_ind_name(i);
    coefficients_lm{i+1,1} = liq_ind_name(i);
    for j = 1 : nind
lm{i,j} = fitlm([X{i,1} X_orth{i,j} X{i,2}],y,'Intercept',false);
coefficients_lm{i+1,j+1} = table2array(lm{i,j}.Coefficients(1:2,1:2));
if j==i
    coefficients_lm{i+1,j+1} = [];
end
    end
end
% Summarize Coefficients
lm_summary = cell(nind+1,nind+1);
lm_summary{1,1} = 'OLS';
for i = 1:nind
    lm_summary{1,i+1} = liq_ind_name(i);
    lm_summary{i+1,1} = liq_ind_name(i);
for j = 1:nind
    if j == i
lm_summary{i+1,j+1} = '';   
    elseif 1-normcdf(abs(coefficients_lm{i+1,j+1}(1,1)./coefficients_lm{i+1,j+1}(1,2))) > 0.05 && 1-normcdf(abs(coefficients_lm{i+1,j+1}(1,1)./coefficients_lm{i+1,j+1}(1,2))) <= 0.10
lm_summary{i+1,j+1} = strcat(num2str(round(coefficients_lm{i+1,j+1}(1,1),5)),'*  ');
    elseif 1-normcdf(abs(coefficients_lm{i+1,j+1}(1,1)./coefficients_lm{i+1,j+1}(1,2))) > 0.01 && 1-normcdf(abs(coefficients_lm{i+1,j+1}(1,1)./coefficients_lm{i+1,j+1}(1,2))) <= 0.05
lm_summary{i+1,j+1} = strcat(num2str(round(coefficients_lm{i+1,j+1}(1,1),5)),'** ');
    elseif 1-normcdf(abs(coefficients_lm{i+1,j+1}(1,1)./coefficients_lm{i+1,j+1}(1,2))) <= 0.01
lm_summary{i+1,j+1} = strcat(num2str(round(coefficients_lm{i+1,j+1}(1,1),5)),'***');
    else
lm_summary{i+1,j+1} = strcat(num2str(round(coefficients_lm{i+1,j+1}(1,1),5)),'   ');
    end
    if j == i
lm_summary{i+1,j+1} = ''; 
    elseif 1-normcdf(abs(coefficients_lm{i+1,j+1}(2,1)./coefficients_lm{i+1,j+1}(2,2))) > 0.05 && 1-normcdf(abs(coefficients_lm{i+1,j+1}(2,1)./coefficients_lm{i+1,j+1}(2,2))) <= 0.10
lm_summary{i+1,j+1} = strcat(lm_summary{i+1,j+1},', ',num2str(round(coefficients_lm{i+1,j+1}(2,1),5)),'*  ');
    elseif 1-normcdf(abs(coefficients_lm{i+1,j+1}(2,1)./coefficients_lm{i+1,j+1}(2,2))) > 0.01 && 1-normcdf(abs(coefficients_lm{i+1,j+1}(2,1)./coefficients_lm{i+1,j+1}(2,2))) <= 0.05
lm_summary{i+1,j+1} = strcat(lm_summary{i+1,j+1},', ',num2str(round(coefficients_lm{i+1,j+1}(2,1),5)),'** ');
    elseif 1-normcdf(abs(coefficients_lm{i+1,j+1}(2,1)./coefficients_lm{i+1,j+1}(2,2))) <= 0.01 
lm_summary{i+1,j+1} = strcat(lm_summary{i+1,j+1},', ',num2str(round(coefficients_lm{i+1,j+1}(2,1),5)),'***');
    else
lm_summary{i+1,j+1} = strcat(lm_summary{i+1,j+1},', ',num2str(round(coefficients_lm{i+1,j+1}(2,1),5)),'');
    end   
end
end
    
%% FGLS
fgls_lm = cell(nind,nind);
coefficients_fgls = cell(nind+1,nind+1);
coefficients_fgls{1,1} = 'FGLS';
for i = 1 : nind
 coefficients_fgls{1,i+1} = liq_ind_name(i);
 coefficients_fgls{i+1,1} = liq_ind_name(i);
    for j = 1 : nind
[fgls_lm{i,j}(:,1),fgls_lm{i,j}(:,2)] = fgls([X{i,1} X_orth{i,j} X{i,2}],y,'Intercept',false,ARLags=4,InnovMdl="HC0");
coefficients_fgls{i+1,j+1} = fgls_lm{i,j}(1:2,1:2);
if j==i
    coefficients_fgls{i+1,j+1} = [];
end
    end
end

% Summarize Coefficients
fgls_summary = cell(nind+1,nind+1);
fgls_summary{1,1} = 'FGLS';
for i = 1:nind
    fgls_summary{1,i+1} = liq_ind_name(i);
    fgls_summary{i+1,1} = liq_ind_name(i);
for j = 1:nind
    if j == i
fgls_summary{i+1,j+1} = '';   
    elseif 1-normcdf(abs(coefficients_fgls{i+1,j+1}(1,1)./coefficients_fgls{i+1,j+1}(1,2))) > 0.05 && 1-normcdf(abs(coefficients_fgls{i+1,j+1}(1,1)./coefficients_fgls{i+1,j+1}(1,2))) <= 0.10
fgls_summary{i+1,j+1} = strcat(num2str(round(coefficients_fgls{i+1,j+1}(1,1),5)),'*  ');
    elseif 1-normcdf(abs(coefficients_fgls{i+1,j+1}(1,1)./coefficients_fgls{i+1,j+1}(1,2))) > 0.01 && 1-normcdf(abs(coefficients_fgls{i+1,j+1}(1,1)./coefficients_fgls{i+1,j+1}(1,2))) <= 0.05
fgls_summary{i+1,j+1} = strcat(num2str(round(coefficients_fgls{i+1,j+1}(1,1),5)),'** ');
    elseif 1-normcdf(abs(coefficients_fgls{i+1,j+1}(1,1)./coefficients_fgls{i+1,j+1}(1,2))) <= 0.01
fgls_summary{i+1,j+1} = strcat(num2str(round(coefficients_fgls{i+1,j+1}(1,1),5)),'***');
    else
fgls_summary{i+1,j+1} = strcat(num2str(round(coefficients_fgls{i+1,j+1}(1,1),5)),'   ');
    end
    if j == i
fgls_summary{i+1,j+1} = ''; 
    elseif 1-normcdf(abs(coefficients_fgls{i+1,j+1}(2,1)./coefficients_fgls{i+1,j+1}(2,2))) > 0.05 && 1-normcdf(abs(coefficients_fgls{i+1,j+1}(2,1)./coefficients_fgls{i+1,j+1}(2,2))) <= 0.10
fgls_summary{i+1,j+1} = strcat(fgls_summary{i+1,j+1},', ',num2str(round(coefficients_fgls{i+1,j+1}(2,1),5)),'*  ');
    elseif 1-normcdf(abs(coefficients_fgls{i+1,j+1}(2,1)./coefficients_fgls{i+1,j+1}(2,2))) > 0.01 && 1-normcdf(abs(coefficients_fgls{i+1,j+1}(2,1)./coefficients_fgls{i+1,j+1}(2,2))) <= 0.05
fgls_summary{i+1,j+1} = strcat(fgls_summary{i+1,j+1},', ',num2str(round(coefficients_fgls{i+1,j+1}(2,1),5)),'** ');
    elseif 1-normcdf(abs(coefficients_fgls{i+1,j+1}(2,1)./coefficients_fgls{i+1,j+1}(2,2))) <= 0.01 
fgls_summary{i+1,j+1} = strcat(fgls_summary{i+1,j+1},', ',num2str(round(coefficients_fgls{i+1,j+1}(2,1),5)),'***');
    else
fgls_summary{i+1,j+1} = strcat(fgls_summary{i+1,j+1},', ',num2str(round(coefficients_fgls{i+1,j+1}(2,1),5)),'');
    end   
end
end

lm_summary_Tab5 = [lm_summary; cell(1,nind+1); fgls_summary];
save Regression_results.mat lm_summary_Tab5 -append