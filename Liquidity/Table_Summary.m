clear;
clc;

load dataset_liquidity.mat
load delta_yield_liquidity.mat ts_left ts_right
format bank
nbond = size(dataset,2)-3;

ISIN = dataset{1}(1:nbond,"ISIN");
ISIN = table2array(ISIN);
CUSIP = dataset{1}(1:nbond,"CUSIP");
Maturity = dataset{1}(1:nbond,"Scadenza");
Maturity = datestr(datenum(table2array(Maturity)));
Benchmark = dataset{1}(1:nbond,"DataBenchmark");
Benchmark = datestr(datenum(table2array(Benchmark)));
Coupon = dataset{1}(1:nbond,"Cedola");
Coupon = table2array(Coupon);
for i = 1:nbond
Issue(i,1) = dataset{3+i}.Dates(1);
end
Issue = datestr(datenum(Issue));
Left = ['dd-mmm-yyyy';datestr(datenum(ts_left))];
Right = ['dd-mmm-yyyy';datestr(datenum(ts_right))];

summary = table(Issue,Maturity,Benchmark,Coupon,Left,Right,'RowNames',ISIN,...
    'VariableNames',{'Issue','Maturity','Benchmark','Coupon','ON-Start','ON-End'});
openvar("summary")
writetable(summary,'Summary_Table_liquidity.xlsx','WriteRowNames',true)