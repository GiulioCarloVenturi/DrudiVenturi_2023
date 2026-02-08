clear;
clc;
% Regression Table 2 (Goldreich, Hanke, Nath; 2005, p.19)

%% Data Preparation
load dataset_final_std.mat
liq_ind = ["Bid_Ask" "Roll" "Corwin_Schultz" "Abdi_Ranaldo" "Hui_Heubel" "Amihud" "Volume" ];
liq_ind_ftm = ["Bid_Ask_ftm" "Roll_ftm" "Corwin_Schultz_ftm" "Abdi_Ranaldo_ftm" "Hui_Heubel_ftm" "Amihud_ftm" "Volume_ftm" ];
liq_ind_name = ["Bid Ask" "Roll" "Corwin Schultz" "Abdi Ranaldo" "Hui Heubel" "Amihud" "Volume" ];
nind = size(liq_ind,2);
time = dataset_final.time;
 
%% Dependent Variable
y = table2array(dataset_final(:,"delta_yld"))*100;

%% Independent Variable
% On-Off Fixed Effect
dummy = dataset_final(:,28:end);
% Independent Variable
X = cell(nind,4);
for i = 1:nind
% Liquidity Indicators t
X{i,1} = table2array(dataset_final(:,liq_ind(i)));
% Liquidity Indicators Future Mean t+1 --> T
X{i,2} = table2array(dataset_final(:,liq_ind_ftm(i)));
% Dummy
X{i,3} = table2array(dummy);
end

%% Orthogonalize Liquidity Indicators Future Mean
lm_orth = cell(nind,1);
for i = 1 : nind
lm_orth{i} = fitlm([X{i,1} X{i,3}], X{i,2},'Intercept',false);
X{i,4} = table2array(lm_orth{i}.Residuals(:,1));
end

%% Linear Model
lm = cell(nind,3);
for i = 1:nind
lm{i,1} = fitlm([X{i,1} X{i,4} X{i,3}],y,'Intercept',false);
lm{i,3} = lm{i,1}.Residuals.Raw;
end

lm_OLS = cell(nind+1,5);
lm_OLS{1,1} = 'OLS';
lm_OLS{1,2} = 'Coeff. Pres.';
lm_OLS{1,3} = 'SE';
lm_OLS{1,4} = 'Coeff. Fut.';
lm_OLS{1,5} = 'SE';
for i = 1:nind
lm_OLS{i+1,1} = liq_ind_name(i);
lm_OLS{i+1,2} = table2array(lm{i,1}.Coefficients(1,1));
lm_OLS{i+1,3} = table2array(lm{i,1}.Coefficients(1,2));
lm_OLS{i+1,4} = table2array(lm{i,1}.Coefficients(2,1));
lm_OLS{i+1,5} = table2array(lm{i,1}.Coefficients(2,2));
end

%% FGLS
lm_FGLS=cell(nind+1,5);
lm_FGLS{1,1} = 'FGLS';
lm_FGLS{1,2} = 'Coeff. Pres.';
lm_FGLS{1,3} = 'SE';
lm_FGLS{1,4} = 'Coeff. Fut.';
lm_FGLS{1,5} = 'SE';
for i= 1 : nind
lm_FGLS{i+1,1} = liq_ind_name(i);
[coeff,SE] = fgls([X{i,1} X{i,4} X{i,3}],y,'intercept',false,ARLags=4,InnovMdl="HC0");
lm_FGLS{i+1,2} = coeff(1);
lm_FGLS{i+1,3} = SE(1);
lm_FGLS{i+1,4} = coeff(2);
lm_FGLS{i+1,5} = SE(2);
end

%% HAC
lm_HAC = cell(nind+1,5);
lm_HAC{1,1} = 'HAC';
lm_HAC{1,2} = 'Coeff. Pres.';
lm_HAC{1,3} = 'SE';
lm_HAC{1,4} = 'Coeff. Fut.';
lm_HAC{1,5} = 'SE';
for i = 1:nind
[EstCoeffCov,se,coeff] = hac([X{i,1} X{i,4} X{i,3}],y,Type='HAC',Bandwidth=4,Intercept=false,Display="off");
lm_HAC{i+1,1} = liq_ind_name(i);
lm_HAC{i+1,2} = coeff(1);
lm_HAC{i+1,3} = se(1);
lm_HAC{i+1,4} = coeff(2);
lm_HAC{i+1,5} = se(2);
end

%% Summarize Models
lm_summary = cell(3*(nind+1)+2,5);
ncoeff = 2;
for i = 1:(nind+1)
lm_summary{i,1} = lm_OLS{i,1};   
lm_summary{i,2} = lm_OLS{i,2};
lm_summary{i,3} = lm_OLS{i,3};
lm_summary{i,4} = lm_OLS{i,4};
lm_summary{i,5} = lm_OLS{i,5};
lm_summary{9+i,1} = lm_HAC{i,1};   
lm_summary{9+i,2} = lm_HAC{i,2};
lm_summary{9+i,3} = lm_HAC{i,3};
lm_summary{9+i,4} = lm_HAC{i,4};
lm_summary{9+i,5} = lm_HAC{i,5};
lm_summary{18+i,1} = lm_FGLS{i,1};
lm_summary{18+i,2} = lm_FGLS{i,2};
lm_summary{18+i,3} = lm_FGLS{i,3};
lm_summary{18+i,4} = lm_FGLS{i,4};
lm_summary{18+i,5} = lm_FGLS{i,5};
end

for i = 1:nind
    for j = 1:ncoeff
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
for i = 1+(nind+2):nind+(nind+2)
    for j = 1:ncoeff
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
for i = 1+(nind*2+4):nind*3+4
    for j = 1:ncoeff
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
lm_summary_Tab2 = lm_summary;
save Regression_results.mat lm_summary_Tab2 -append