clear;
clc;

dataset = cell(1,46);  
%% Descriptive and Curves
dataset{1} = readtable("BTP_MTS_new.xlsx","Sheet","List");
dataset{2} = readtable("BTP_MTS_new.xlsx","Sheet","Zero Curve");
dataset{3} = readtable("BTP_MTS_new.xlsx","Sheet","Yield Curve");

%% Securities
dataset{4} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EC1394237"),'linear');
dataset{5} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EC2421971"),'linear');
dataset{6} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EC3518288"),'linear');
dataset{7} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EC4704507"),'linear');
dataset{8} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EC6667322"),'linear');
dataset{9} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EC9522912"),'linear');
dataset{10} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","ED3032684"),'linear');
dataset{11} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","ED5901696"),'linear');
dataset{12} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","ED9117117"),'linear');
dataset{13} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EF2951483"),'linear');
dataset{14} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EG0648527"),'linear');
dataset{15} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EG7660475"),'linear');
dataset{16} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EH3265541"),'linear');
dataset{17} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EH6038325"),'linear');
dataset{18} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EH8025973"),'linear');
dataset{19} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EH9863067"),'linear');
dataset{20} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EI2018063"),'linear');
dataset{21} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EI3856339"),'linear');
dataset{22} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EI5863861"),'linear');
dataset{23} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EI7933985"),'linear');
dataset{24} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EJ0420566"),'linear');
dataset{25} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EJ3416900"),'linear');
dataset{26} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EJ5688621"),'linear');
dataset{27} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EJ7704418"),'linear');
dataset{28} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EK0933524"),'linear');
dataset{29} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EK4572963"),'linear');
dataset{30} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","EK7691190"),'linear');
dataset{31} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","UV6569569"),'linear');
dataset{32} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","JK2344014"),'linear');
dataset{33} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","QZ0167556"),'linear');
dataset{34} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","AM2936822"),'linear');
dataset{35} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","AO1479572"),'linear');
dataset{36} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","AQ9353915"),'linear');
dataset{37} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","AT7587708"),'linear');
dataset{38} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","AX3905822"),'linear');
dataset{39} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","ZR3437988"),'linear');
dataset{40} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","BG2593013"),'linear');
dataset{41} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","BJ8379114"),'linear');
dataset{42} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","ZO6504153"),'linear');
dataset{43} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","BO0961645"),'linear');
dataset{44} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","BP9688410"),'linear');
dataset{45} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","BS1324091"),'linear');
dataset{46} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","BW1525672"),'linear');
dataset{47} = fillmissing(readtimetable("BTP_MTS_new.xlsx","Sheet","BZ9605404"),'linear');

%% Generate dataset
save dataset_liquidity.mat