clear;
clc;
% Regression Table 1 (Goldreich, Hanke, Nath; 2005, p.16)

%% Data Preparation
load dataset_final_liquidity.mat
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
    if i == 5
        X{i,1}(:,1) = X{i,1}(:,1).*1000;
    else
    end
end

%% FGLS
beta = zeros(nind,1);
for i = 1:nind
[coeff,SE] = fgls(X{i,1},y,'intercept',false,ARLags=4,InnovMdl="HC0");
beta(i,1) = coeff(1);
end

save beta.mat beta