clear;
clc;

%% Run Codes to Create Dataset
run("Dataset.m");
run("Delta_Yield_liquidity.m");
run("Liquidity_Indicators_liquidity.m");
run("Table_Summary.m");
run("Dummy_liquidity.m");
clear;
load delta_yield_liquidity.mat delta_yld_ts ts_right ts_left
load liquidity_indicators_liquidity.mat ts_indicators
load dummy_liquidity.mat
dataset_final = synchronize(delta_yld_ts,CUSIP,'intersection');
dataset_final = synchronize(dataset_final,ts_indicators,'intersection');
dataset_final = synchronize(dataset_final,dummy,'intersection');
save dataset_final_liquidity.mat dataset_final ts_right ts_left

%% Create Dataset.xlsx
load dummy_liquidity.mat
load delta_yield_liquidity.mat delta_yld_ts ts_right ts_left
load liquidity_indicators_liquidity.mat 
dataset_final = synchronize(delta_yld_ts,CUSIP,'intersection');
dataset_final = synchronize(dataset_final,ts_indicators,'intersection');
dataset_final = synchronize(dataset_final,dummy,'intersection');
writetimetable(dataset_final,'Dataset.xlsx')

dataset_final = synchronize(delta_yld_ts,CUSIP,'intersection');
dataset_final = synchronize(dataset_final,ts_indicators_on,'intersection');
dataset_final = synchronize(dataset_final,dummy,'intersection');
writetimetable(dataset_final,'Dataset_on.xlsx')

dataset_final = synchronize(delta_yld_ts,CUSIP,'intersection');
dataset_final = synchronize(dataset_final,ts_indicators_off,'intersection');
dataset_final = synchronize(dataset_final,dummy,'intersection');
writetimetable(dataset_final,'Dataset_off.xlsx')

%% Analyisis of Liquidity Premium
run("Liquidity_Premium.m");