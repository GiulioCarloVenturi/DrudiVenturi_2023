clear;
clc;
load dataset_liquidity.mat
load delta_yield_liquidity.mat 

%% Dummy Variables
d = zeros(size(delta_yld_ts,1),size(ts_right,2));
for i = 1 : size(ts_right,2)
d(:,i) = ts_left(i)<= delta_yld_ts.time & delta_yld_ts.time <= ts_right(i);
end
d = array2table(d);
time = array2table(delta_yld_ts.time);
d = [time,d];
dummy = table2timetable(d,'RowTimes','Var1');

%% CUSIP Codes
time = delta_yld_ts.time;

for i = 1 : (size(ts_right,2))
time_left = find(time == ts_left(i));
time_right = find(time == ts_right(i));
CUSIP_off(time_left:time_right,1) = dataset{1}.CUSIP(i);
CUSIP_on(time_left:time_right,1) = dataset{1}.CUSIP(i+1);
end
CUSIP_off = cell2table(CUSIP_off);
CUSIP_on = cell2table(CUSIP_on);
time = array2table(time);
CUSIP = [time,CUSIP_off,CUSIP_on];
CUSIP = table2timetable(CUSIP,'RowTimes','time');

clearvars -except dummy CUSIP
save dummy_liquidity.mat