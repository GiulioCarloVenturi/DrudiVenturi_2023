clear;
clc;

load beta.mat
load delta_yield_liquidity.mat ts_left ts_right
load dataset_liquidity.mat
load liquidity_indicators_liquidity.mat liquidity_indicators

nbond = size(dataset,2)-3-1;
% Spot Liquidity Indicators
liq_ind = ["Bid_Ask" "Roll" "Corwin_Schultz" "Abdi_Ranaldo" "Hui_Heubel" "Amihud" "Volume" ];
liq_ind_name = ["Bid Ask" "Roll" "Corwin Schultz" "Abdi Ranaldo" "Hui Heubel" "Amihud" "Volume" ];
nind = size(liq_ind_name,2);

%% Mid-YTM On-the-Run Bonds
yld_on = cell(nbond,1);
for i = 1:nbond
% Yield On-the-Run in BPS
Time = dataset{3+1+i}.Dates; 
yld_on{i} = timetable(Time,dataset{3+1+i}.YLD_YTM_MID*100);
% Time Series
if i == 1
yield_on = yld_on{i}(ts_left(i):ts_right(i),:);
else
yield_on = [yield_on;yld_on{i}(ts_left(i):ts_right(i),:)];
end
end

%% Liquidity Adjustment
beta(5) = beta(5)*1000;
X = cell(nbond,3);
for i = 1 :nbond
% Liquidity Measures
for j = 1:nind
X{i}(:,j) = liquidity_indicators{i+1}(:,liq_ind(j)); 
X{i}.Properties.VariableNames(j) = {char(liq_ind_name(j))};
end
% Liquidity Adjustments
X{i,2} = X{i,1}.Variables.*beta';
Time = X{i,1}.Time;
% Average Liquidity Adjustment
X{i,3} = timetable(Time,mean(X{i,2},2));
% Time Series
if i == 1
liq_premium = X{i,3}(ts_left(i):ts_right(i),:);
else
liq_premium = [liq_premium;X{i,3}(ts_left(i):ts_right(i),:)];
end
end
liq_premium_mm = movmean(liq_premium.Variables,[15 15]);

%% Perfectly-Liquid Yield
Time = yield_on.Time;
yld_liq = timetable(Time,yield_on.Variables - liq_premium.Variables);

COVID = datetime('21-Feb-2020');
PEPP = datetime('18-Mar-2020');
figure;
hold on
plot(Time(4989:5248),liq_premium.Var1(4989:5248),LineWidth=2,Color="black")
plot(Time(4989:5248),liq_premium_mm(4989:5248),LineWidth=3,Color = "red")
xline([COVID PEPP ],'-',{'COVID','PEPP'},'Fontsize',20)
title('Liquidity Premium 2020',FontSize=18)

figure;
hold on
plot(Time(4989:end),liq_premium.Var1(4989:end),LineWidth=2,Color="black")
plot(Time(4989:end),liq_premium_mm(4989:end),LineWidth=3,Color = "red")
xline([COVID PEPP ],'-',{'COVID','PEPP'},'Fontsize',20)
title('Liquidity Premium 2020-2023',FontSize=18)

%% Plots
GFC = datetime('15-Sep-2008');
Greece = datetime('05-May-2010');
ECB = datetime('26-Jul-2012');
PSPP = datetime('09-Mar-2015');
COVID = datetime('21-Feb-2020');
PEPP = datetime('26-Mar-2020');

figure;
hold on
plot(Time,liq_premium.Variables,Color="black")
plot(Time,liq_premium_mm,LineWidth=3,Color = "red")
xline([GFC Greece ECB PSPP PEPP ],'-',{'GFC','Greece','ECB','PSPP','PEPP'},'Fontsize',20)
title('Liquidity Premium',FontSize=18)

figure;
subplot(2,1,1)
hold on
plot(Time,liq_premium.Variables,Color="blue")
plot(Time,liq_premium_mm,LineWidth=3,Color = "red")
xline([GFC Greece ECB PSPP PEPP ],'-',{'GFC','Greece','ECB','PSPP','PEPP'},'Fontsize',20)
xline(COVID,'-',{'COVID'},'LabelHorizontalAlignment','left','Fontsize',20)
title('Liquidity Premium',FontSize=18)
subplot(2,1,2)
plot(Time,yld_liq.Variables/100,LineWidth=2, Color="blue")
xline([GFC Greece ECB PSPP PEPP ],'-',{'GFC','Greece','ECB','PSPP','PEPP'},'Fontsize',20)
xline(COVID,'-',{'COVID'},'LabelHorizontalAlignment','left','Fontsize',20)
ytickformat("percentage")
title('Perfectly-Liquid Yield', FontSize=18)

summary(liq_premium)
mean(liq_premium.Var1)
mean(liq_premium.Var1(1:1531))
mean(liq_premium.Var1(1532:end))
mean(liq_premium(ECB:PSPP,:).Var1)
mean(liq_premium(PSPP:PEPP,:).Var1)
sum(liq_premium.Var1 >= 0)/size(liq_premium,1)
tt = synchronize(liq_premium,timetable(Time,yld_liq.Variables/100),timetable(Time,abs(liq_premium_mm./yld_liq.Variables)*100));
tt.Properties.VariableNames = {'Liquidity Premium', 'Perfectly-Liquid Yield', 'Premium-Yield Ratio'};
writetimetable(tt,'Liquidity_Premium_Analysis.xlsx');

 ID = find(liq_premium.Var1 < 0);
 ID_var = liq_premium(ID,1);