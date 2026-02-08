clear;
clc;

load dataset_liquidity.mat

    for j = 4 : size(dataset,2)

    %% Bid-Ask Spread
    bid_ask_spread = (dataset{j}.YLD_YTM_BID(2:end) - dataset{j}.YLD_YTM_ASK(2:end));
    for i=1:(size(bid_ask_spread,1)-1)
    bid_ask_spread_mean(i,1) = mean(bid_ask_spread(i:end),'omitnan');
    end
    for i=1:(size(bid_ask_spread,1)-1)
    bid_ask_spread_ftmean(i,1) = mean(bid_ask_spread(i+1:end),'omitnan');
    end
    %% Roll
    Delta_t1 = diff(dataset{j}.PX_LAST(2:end));
    Delta_t = diff(dataset{j}.PX_LAST(1:end-1));
    for i= 1:size(Delta_t,1)-4
    C = cov(Delta_t(i:i+4),Delta_t1(i:i+4));
    S(i,1) = C(2,1)*(-1);
    if S(i,1)<=0
    S(i,1)=NaN;
    else
    S(i,1) = S(i,1);
    end
    end
    S = fillmissing(S,'linear','EndValues','nearest');
    roll = [ones(5,1)*NaN; 2*sqrt(S)];
    for i = 1:(size(roll,1)-1)
    roll_mean(i,1) = mean(roll(i:end),'omitnan');
    end
    for i = 1:(size(roll,1)-1)
    roll_ftmean(i,1) = mean(roll(i+1:end),'omitnan');
    end
    %% Corwin & Schultz
    for i = 1:size(dataset{j},1)-1
    gamma = (log((dataset{j}.PX_HIGH(i)+dataset{j}.PX_HIGH(i+1))/(dataset{j}.PX_LOW(i)+dataset{j}.PX_LOW(i+1))))^2;
    beta = log(dataset{j}.PX_HIGH(i)/dataset{j}.PX_LOW(i))^2 + log(dataset{j}.PX_HIGH(i+1)/dataset{j}.PX_LOW(i+1))^2;
    alpha = ((sqrt(2*beta)-sqrt(beta))/(3-2*sqrt(2)))-sqrt(gamma/(3-2*sqrt(2)));
    corwin_schultz(i,1) = (2*(exp(alpha)-1))/(1+exp(alpha));
    if corwin_schultz(i) == 0
        corwin_schultz(i)=NaN;
    else 
        corwin_schultz(i) = corwin_schultz(i);
    end
    end
    corwin_schultz = fillmissing(corwin_schultz,'linear','EndValues','nearest');
    %corwin_schultz = log(corwin_schultz.^-1);
    for i = 1:(size(corwin_schultz,1)-1)
    corwin_schultz_mean(i,1) = mean(corwin_schultz(i:end),'omitnan');
    end
    for i = 1:(size(corwin_schultz,1)-1)
    corwin_schultz_ftmean(i,1) = mean(corwin_schultz(i+1:end),'omitnan');
    end
    %% Abdi & Ranaldo
    for i = 1:size(dataset{j},1)-1
    eta_t(i,1) = (dataset{j}.PX_HIGH(i) + dataset{j}.PX_LOW(i))/2;
    eta_t1(i,1) = (dataset{j}.PX_HIGH(i+1) + dataset{j}.PX_LOW(i+1))/2;
    end
    for i = 1:size(dataset{j},1)-1
    s(i,1) = (dataset{j}.PX_LAST(i)-eta_t(i))*(dataset{j}.PX_LAST(i)-eta_t1(i));
    if s(i,1)<0
    s(i,1) = 0;
    else
    s(i,1) = s(i,1);
    end
    end
    abdi_ranaldo = zeros(size(s,1),1);
    for i = 1:size(dataset{j},1)-1
    if i<20
        abdi_ranaldo(i,1)=NaN;
    else
    abdi_ranaldo(i,1) = 2*sqrt(mean(s(i-19:i)));
    end
    if abdi_ranaldo(i) <= 0
        abdi_ranaldo(i) = NaN;
    else
    abdi_ranaldo(i) = abdi_ranaldo(i);
    end
    end
    abdi_ranaldo(20:end) = fillmissing(abdi_ranaldo(20:end),'linear','EndValues','nearest');
    %abdi_ranaldo = log(abdi_ranaldo);
    for i = 1:(size(abdi_ranaldo,1)-1)
    abdi_ranaldo_mean(i,1) = mean(abdi_ranaldo(i:end),'omitnan');
    end
    for i = 1:(size(abdi_ranaldo,1)-1)
    abdi_ranaldo_ftmean(i,1) = mean(abdi_ranaldo(i+1:end),'omitnan');
    end
    %% Hui & Heubel
    for i = 1:size(dataset{j},1)-1
    if i<5
        H(i,1)=NaN;
        L(i,1)=NaN;
        T(i,1)=NaN;
    else
        H(i,1) = mean(dataset{j}.PX_HIGH(i-4:i));
        L(i,1) = mean(dataset{j}.PX_LOW(i-4:i));
        T(i,1) = mean(dataset{j}.PX_VOLUME(i-4:i));
    end
    hui_heubel(i,1) = ((H(i,1)-L(i,1))./L(i,1))./T(i,1);
    if hui_heubel(i) <= 0
        hui_heubel(i) = NaN;
    else
        hui_heubel(i)=hui_heubel(i);
    end
    end
    hui_heubel(5:end) = fillmissing(hui_heubel(5:end),'linear','EndValues','nearest');
    %hui_heubel = log(hui_heubel);
    for i = 1:(size(hui_heubel,1)-1)
    hui_heubel_mean(i,1) = mean(hui_heubel(i:end),'omitnan');
    end
    for i = 1:(size(hui_heubel,1)-1)
    hui_heubel_ftmean(i,1) = mean(hui_heubel(i+1:end),'omitnan');
    end
    %% Amihud
    ret = abs(diff(dataset{j}.YLD_YTM_MID)./dataset{j}.YLD_YTM_MID(1:end-1));
    volume = dataset{j}.PX_VOLUME(2:end);
    ratio = ret./volume;
    for i = 1 : size(ratio,1)
    if ratio(i) == 0 | ratio(i)== Inf 
        ratio(i) = NaN ;
    else
        ratio(i) = ratio(i);
    end
    end
    ratio = fillmissing(ratio,'linear','EndValues','nearest');
    amihud = zeros(size(ratio,1),1);
    for i = 1:size(amihud,1)
    if i<20
        amihud(i,1)=NaN;
    else
    amihud(i,1) = mean(ratio(i-19:i));
    end
    end
    %amihud = log(amihud);
    for i = 1:(size(amihud,1)-1)
    amihud_mean(i,1)= mean(amihud(i:end),'omitnan');
    end
    for i = 1:(size(amihud,1)-1)
    amihud_ftmean(i,1)= mean(amihud(i+1:end),'omitnan');
    end

    %% Volatility
    Last_change = diff(dataset{j}.PX_LAST);
    Max_change = diff(dataset{j}.PX_HIGH);
    Min_change = diff(dataset{j}.PX_LOW);
    for i = 1:size(dataset{j},1)-1
    if i<20
    Last(i,1) = NaN;
    Max(i,1) = NaN;
    Min(i,1) = NaN;
    else
    Last(i,1) = std(Last_change(i-19:i));
    Max(i,1) = std(Max_change(i-19:i));
    Min(i,1) = std(Min_change(i-19:i));
    end
    end
    volatility = (Last+Max+Min)./3;
    for i = 1:(size(volatility,1)-1)
    volatility_mean(i,1) = mean(volatility(i:end),'omitnan');
    end
    for i = 1:(size(volatility,1)-1)
    volatility_ftmean(i,1) = mean(volatility(i+1:end),'omitnan');
    end

    %% Volume
    volume = dataset{j}.PX_VOLUME(2:end);
    volume = 1./volume;
    for i = 1:(size(volume,1)-1)
    volume_mean(i,1) = mean(volume(i:end),'omitnan');
    end
    for i = 1:(size(volume,1)-1)
    volume_ftmean(i,1) = mean(volume(i+1:end),'omitnan');
    end
   
    %% Liquidity Indicators
    Time = dataset{j}.Dates(3:end);
    liquidity_indicators{j-3} = fillmissing(timetable(Time,bid_ask_spread(2:end),...
        bid_ask_spread_mean,bid_ask_spread_ftmean,roll(2:end),roll_mean,roll_ftmean,...
        corwin_schultz(2:end),corwin_schultz_mean,corwin_schultz_ftmean,...
        abdi_ranaldo(2:end),abdi_ranaldo_mean,abdi_ranaldo_ftmean,...
        hui_heubel(2:end),hui_heubel_mean,hui_heubel_ftmean,...
        amihud(2:end),amihud_mean,amihud_ftmean,volatility(2:end),...
        volatility_mean,volatility_ftmean,volume(2:end),volume_mean,volume_ftmean),"linear"); 
    liquidity_indicators{j-3}.Properties.VariableNames = {'Bid_Ask',...
        'Bid_Ask_m','Bid_Ask_ftm','Roll','Roll_m','Roll_ftm',...
        'Corwin_Schultz','Corwin_Schultz_m','Corwin_Schultz_ftm',...
        'Abdi_Ranaldo','Abdi_Ranaldo_m','Abdi_Ranaldo_ftm',...
        'Hui_Heubel','Hui_Heubel_m','Hui_Heubel_ftm',...
        'Amihud','Amihud_m','Amihud_ftm','Volatility','Volatility_m',...
        'Volatility_ftm','Volume','Volume_m','Volume_ftm'};
    clearvars -except liquidity_indicators dataset
    end
    
    %% Independent Variable 
    load delta_yield_liquidity.mat
    for i = 1 : (size(liquidity_indicators,2)-1)
    on_indicators_left = find(liquidity_indicators{i+1}.Time == ts_left(i));
    on_indicators_right = find(liquidity_indicators{i+1}.Time == ts_right(i));
    on_indicators_time = liquidity_indicators{i+1}.Time(on_indicators_left:on_indicators_right);
    off_indicators_left = find(liquidity_indicators{i}.Time == ts_left(i));
    off_indicators_right = find(liquidity_indicators{i}.Time == ts_right(i));
    off_indicators_time = liquidity_indicators{i}.Time(off_indicators_left:off_indicators_right);
    on_indicators = liquidity_indicators{i+1}.Variables;
    on_indicators = on_indicators(on_indicators_left:on_indicators_right,:);
    off_indicators = liquidity_indicators{i}.Variables;
    off_indicators = off_indicators(off_indicators_left:off_indicators_right,:);
    on_indicators = timetable(on_indicators_time,on_indicators);
    off_indicators = timetable(off_indicators_time,off_indicators);
    onoff_indicators = synchronize(off_indicators,on_indicators,'intersection');
    time = onoff_indicators.off_indicators_time;
    if i==1
    ts_indicators = onoff_indicators.off_indicators - onoff_indicators.on_indicators;
    ts_indicators = timetable(time,ts_indicators(:,1),ts_indicators(:,2),...
        ts_indicators(:,3),ts_indicators(:,4),ts_indicators(:,5),...
        ts_indicators(:,6),ts_indicators(:,7),ts_indicators(:,8),...
        ts_indicators(:,9),ts_indicators(:,10),ts_indicators(:,11),...
        ts_indicators(:,12),ts_indicators(:,13),ts_indicators(:,14),...
        ts_indicators(:,15),ts_indicators(:,16),ts_indicators(:,17),...
        ts_indicators(:,18),ts_indicators(:,19),ts_indicators(:,20),...
        ts_indicators(:,21),ts_indicators(:,22),ts_indicators(:,23),...
        ts_indicators(:,24));
    else
    ts = onoff_indicators.off_indicators - onoff_indicators.on_indicators;
    ts = timetable(time,ts(:,1),ts(:,2),ts(:,3),ts(:,4),ts(:,5),ts(:,6),...
        ts(:,7),ts(:,8),ts(:,9),ts(:,10),ts(:,11),ts(:,12),ts(:,13),...
        ts(:,14),ts(:,15),ts(:,16),ts(:,17),ts(:,18),ts(:,19),ts(:,20),...
        ts(:,21),ts(:,22),ts(:,23),ts(:,24));
    ts_indicators = [ts_indicators;ts];
    end
    end
    ts_indicators.Properties.VariableNames = liquidity_indicators{1}.Properties.VariableNames;
    
    %% Data for On-Off Dataset
        for i = 1 : (size(liquidity_indicators,2)-1)
    on_indicators_left = find(liquidity_indicators{i+1}.Time == ts_left(i));
    on_indicators_right = find(liquidity_indicators{i+1}.Time == ts_right(i));
    on_indicators_time = liquidity_indicators{i+1}.Time(on_indicators_left:on_indicators_right);
    off_indicators_left = find(liquidity_indicators{i}.Time == ts_left(i));
    off_indicators_right = find(liquidity_indicators{i}.Time == ts_right(i));
    off_indicators_time = liquidity_indicators{i}.Time(off_indicators_left:off_indicators_right);
    on_indicators = liquidity_indicators{i+1}.Variables;
    on_indicators = on_indicators(on_indicators_left:on_indicators_right,:);
    off_indicators = liquidity_indicators{i}.Variables;
    off_indicators = off_indicators(off_indicators_left:off_indicators_right,:);
    on_indicators = timetable(on_indicators_time,on_indicators);
    off_indicators = timetable(off_indicators_time,off_indicators);
    onoff_indicators = synchronize(off_indicators,on_indicators,'intersection');
    time = onoff_indicators.off_indicators_time;
    if i==1
    ts_indicators_on = onoff_indicators.on_indicators;
    ts_indicators_on = timetable(time,ts_indicators_on(:,1),ts_indicators_on(:,2),...
        ts_indicators_on(:,3),ts_indicators_on(:,4),ts_indicators_on(:,5),...
        ts_indicators_on(:,6),ts_indicators_on(:,7),ts_indicators_on(:,8),...
        ts_indicators_on(:,9),ts_indicators_on(:,10),ts_indicators_on(:,11),...
        ts_indicators_on(:,12),ts_indicators_on(:,13),ts_indicators_on(:,14),...
        ts_indicators_on(:,15),ts_indicators_on(:,16),ts_indicators_on(:,17),...
        ts_indicators_on(:,18),ts_indicators_on(:,19),ts_indicators_on(:,20),...
        ts_indicators_on(:,21),ts_indicators_on(:,22),ts_indicators_on(:,23),...
        ts_indicators_on(:,24));
    ts_indicators_off = onoff_indicators.off_indicators;
    ts_indicators_off = timetable(time,ts_indicators_off(:,1),ts_indicators_off(:,2),...
        ts_indicators_off(:,3),ts_indicators_off(:,4),ts_indicators_off(:,5),...
        ts_indicators_off(:,6),ts_indicators_off(:,7),ts_indicators_off(:,8),...
        ts_indicators_off(:,9),ts_indicators_off(:,10),ts_indicators_off(:,11),...
        ts_indicators_off(:,12),ts_indicators_off(:,13),ts_indicators_off(:,14),...
        ts_indicators_off(:,15),ts_indicators_off(:,16),ts_indicators_off(:,17),...
        ts_indicators_off(:,18),ts_indicators_off(:,19),ts_indicators_off(:,20),...
        ts_indicators_off(:,21),ts_indicators_off(:,22),ts_indicators_off(:,23),...
        ts_indicators_off(:,24));
    else
    ts_on = onoff_indicators.on_indicators;
    ts_on = timetable(time,ts_on(:,1),ts_on(:,2),ts_on(:,3),ts_on(:,4),ts_on(:,5),ts_on(:,6),...
        ts_on(:,7),ts_on(:,8),ts_on(:,9),ts_on(:,10),ts_on(:,11),ts_on(:,12),ts_on(:,13),...
        ts_on(:,14),ts_on(:,15),ts_on(:,16),ts_on(:,17),ts_on(:,18),ts_on(:,19),ts_on(:,20),...
        ts_on(:,21),ts_on(:,22),ts_on(:,23),ts_on(:,24));
    ts_indicators_on = [ts_indicators_on;ts_on];
     ts_off = onoff_indicators.off_indicators;
    ts_off = timetable(time,ts_off(:,1),ts_off(:,2),ts_off(:,3),ts_off(:,4),ts_off(:,5),ts_off(:,6),...
        ts_off(:,7),ts_off(:,8),ts_off(:,9),ts_off(:,10),ts_off(:,11),ts_off(:,12),ts_off(:,13),...
        ts_off(:,14),ts_off(:,15),ts_off(:,16),ts_off(:,17),ts_off(:,18),ts_off(:,19),ts_off(:,20),...
        ts_off(:,21),ts_off(:,22),ts_off(:,23),ts_off(:,24));
    ts_indicators_off = [ts_indicators_off;ts_off];
   end
    end
    ts_indicators_on.Properties.VariableNames = liquidity_indicators{1}.Properties.VariableNames;
    ts_indicators_off.Properties.VariableNames = liquidity_indicators{1}.Properties.VariableNames;

    save liquidity_indicators_liquidity.mat liquidity_indicators ts_indicators ts_indicators_on ts_indicators_off