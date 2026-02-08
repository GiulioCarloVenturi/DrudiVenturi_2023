clear;
clc;
% Regression Table 3 (Goldreich, Hanke, Nath; 2005, p.20)

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
dummy = dataset_final(:,28:end);
% Independent Variable
X = cell(nind,4);
for i = 1:nind
% Liquidity Indicators t --> T
X{i,1} = table2array(dataset_final(:,liq_ind(i)));
% Dummy
X{i,3} = table2array(dummy);
end

%% Time
for j = 1 : size(ts_left,2)
left = find(time == ts_left(j));
right = find(time == ts_right(j));
for i = left : right
tau(i,1) = (datenum(time(i)) - datenum(time(left)))./365;
end
end
for i = 1: nind
X{i,2} = tau;
end

%% Orthogonalize Liquidity Indicators Future Mean
lm_orth = cell(nind,1);
for i = 1 : nind
lm_orth{i} = fitlm([X{i,2} X{i,3}], X{i,1},'Intercept',false);
X{i,4} = table2array(lm_orth{i}.Residuals(:,1));
end

%% Linear Model
lm = cell(nind,3);
for i = 1:nind
lm{i,1} = fitlm([X{i,4} X{i,2} X{i,3}],y,'Intercept',false);
lm{i,3} = lm{i,1}.Residuals.Raw;
end

lm_OLS = cell(nind+1,5);
lm_OLS{1,1} = 'OLS';
lm_OLS{1,2} = 'Coeff. Liq.';
lm_OLS{1,3} = 'SE';
lm_OLS{1,4} = 'Coeff. Time';
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
lm_FGLS{1,2} = 'Coeff. Liq.';
lm_FGLS{1,3} = 'SE';
lm_FGLS{1,4} = 'Coeff. Time';
lm_FGLS{1,5} = 'SE';
for i= 1 : nind
lm_FGLS{i+1,1} = liq_ind_name(i);
[coeff,SE] = fgls([X{i,4} X{i,2} X{i,3}],y,'intercept',false,ARLags=4,InnovMdl="HC0");
lm_FGLS{i+1,2} = coeff(1);
lm_FGLS{i+1,3} = SE(1);
lm_FGLS{i+1,4} = coeff(2);
lm_FGLS{i+1,5} = SE(2);
end

%% HAC
lm_HAC = cell(nind+1,5);
lm_HAC{1,1} = 'HAC';
lm_HAC{1,2} = 'Coeff. Liq.';
lm_HAC{1,3} = 'SE';
lm_HAC{1,4} = 'Coeff. Time.';
lm_HAC{1,5} = 'SE';
for i = 1:nind
[EstCoeffCov,se,coeff] = hac([X{i,4} X{i,2} X{i,3}],y,Type='HAC',Bandwidth=4,Intercept=false,Display="off");
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

lm_summary_Tab3 = lm_summary;
save Regression_results.mat lm_summary_Tab3 -append