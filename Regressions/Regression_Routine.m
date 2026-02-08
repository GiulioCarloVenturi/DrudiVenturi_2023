%% REGRESSION ROUTINE %%
clear;
clc;

%% Create Dataset
run("Dataset.m");
run("Delta_Yield.m");
run("Liquidity_Indicators.m");
run("Dummy.m");
run("Table_Summary.m")

clear;
load delta_yield.mat delta_yld_ts ts_right ts_left
load liquidity_indicators.mat ts_indicators_std
load dummy.mat
dataset_final = synchronize(delta_yld_ts,CUSIP,'intersection');
dataset_final = synchronize(dataset_final,ts_indicators_std,'intersection');
dataset_final = synchronize(dataset_final,dummy,'intersection');
save dataset_final_std.mat dataset_final ts_right ts_left

%%  %%  %%  %%  %%  %%  %%  %% %%  %%  %%  %%  %%  %%  %%  %%
%% 1.1: Replication %%
run("Regression_baseline.m")
run("Regression_cont_vs_fut.m")
run("Regression_time_vs_fut.m")
run("Regression_comparison.m")

%% 1.2: Summarize Results
clear;
clc;
load Regression_results.mat

% Regression Table 1 (Goldreich, Hanke, Nath; 2005, p.16)
openvar('lm_summary_Tab1')
% Regression Table 2 (Goldreich, Hanke, Nath; 2005, p.19)
openvar('lm_summary_Tab2')
% Regression Table 3 (Goldreich, Hanke, Nath; 2005, p.20)
openvar('lm_summary_Tab3')
% Regression Table 5 (Goldreich,Hanke,Nath; 2005, p.26)
openvar('lm_summary_Tab5')

%% Compute betas for Liquidity Premium
clear;
run("Delta_Yield_liquidity.m")
run("Liquidity_Indicators_liquidity.m");
run("Dummy_liquidity.m");

load delta_yield_liquidity.mat delta_yld_ts ts_right ts_left
load liquidity_indicators_liquidity.mat ts_indicators
load dummy_liquidity.mat
dataset_final = synchronize(delta_yld_ts,CUSIP,'intersection');
dataset_final = synchronize(dataset_final,ts_indicators,'intersection');
dataset_final = synchronize(dataset_final,dummy,'intersection');
save dataset_final_liquidity.mat dataset_final ts_right ts_left
run("Regression_baseline_liquidity.m")