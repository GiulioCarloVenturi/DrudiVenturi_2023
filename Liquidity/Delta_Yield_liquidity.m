clear;
clc;

load dataset_liquidity.mat
days_excl = 2;
for i=1:(size(dataset,2)-3-1)
%% Off-the-run
off_maturity = dataset{1}.Scadenza(i);
off_issue = dataset{3+i}.Dates(1);   
off_coupon = dataset{1}.Cedola(i);

%% On-the-run
on_maturity = dataset{1}.Scadenza(i+1);
on_issue = dataset{3+i+1}.Dates(1); 
on_coupon = dataset{1}.Cedola(i+1);

%% Next On-the-run
if i < (size(dataset,2)-3-1)
next_on = dataset{3+i+2}.Dates(1)+1;
else
next_on = dataset{end}.Dates(end) + 1;
end

%% Coupon Adjustment
zero_maturity = [3/12 6/12 1 2 3 4 5 6 7 8 9 10 15 20 30]';
zero_rates = table2array(dataset{2}(find(dataset{2}.Dates == on_issue),2:end))';
zero_curve = fit(zero_maturity,zero_rates,'smoothingspline');
off_time = (datenum(off_maturity) - datenum(on_issue))/365;
on_time = (datenum(on_maturity) - datenum(on_issue))/365;
off_zero_yld = zero_curve(off_time);       
off_zero = 100*1/((1+off_zero_yld/100).^off_time);
on_zero_yld = zero_curve(on_time);       
on_zero = 100*1/((1+on_zero_yld/100).^on_time);
off_yield = bndyield(off_zero,off_coupon,on_issue,off_maturity,2);
on_yield = bndyield(on_zero,on_coupon,on_issue,on_maturity,2);
off_yld_adj_cpn = on_yield - off_yield;

%% Maturity Adjustment
yield_maturity = [3/12 6/12 1 2 3 4 5 6 7 8 9 10 15 20 25 30]';
yield_rates = table2array(dataset{3}(find(dataset{3}.Dates == on_issue),2:end))';
yield_curve = fit(yield_maturity,yield_rates,'smoothingspline');
off_yld_adj_mat = yield_curve(on_time) - yield_curve(off_time);

%% Yield Adjustment
off_yld_ts = dataset{3+i}.YLD_YTM_MID + off_yld_adj_mat + off_yld_adj_cpn;
on_yld_ts = dataset{3+i+1}.YLD_YTM_MID;
off_left = find(dataset{3+i}.Dates == on_issue)+days_excl;
off_right =  find(dataset{3+i}.Dates == next_on-1);
on_left = find(dataset{3+i+1}.Dates == on_issue)+days_excl;
on_right =  find(dataset{3+i+1}.Dates == next_on-1);
time_off = dataset{3+i}.Dates(off_left:off_right);
time_on = dataset{3+i+1}.Dates(on_left:on_right);
on_ts = timetable(time_on,on_yld_ts(on_left:on_right));
off_ts = timetable(time_off,off_yld_ts(off_left:off_right));
onoff_ts = synchronize(off_ts,on_ts,'intersection');
time = onoff_ts.time_off;
delta_yld = onoff_ts.Var1_off_ts - onoff_ts.Var1_on_ts;
if i==1
delta_yld_ts = timetable(time,delta_yld);
else
ts = timetable(time,delta_yld);
delta_yld_ts = [delta_yld_ts;ts];
end
ts_left(i) = time(1);
ts_right(i) = time(end);

clearvars -except delta_yld_ts dataset ts_left ts_right days_excl
end

save delta_yield_liquidity.mat  delta_yld_ts ts_right ts_left