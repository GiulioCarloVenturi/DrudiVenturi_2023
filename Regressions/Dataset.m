clear;
clc;

dataset = cell(1,44);  
%% Descriptive and Curves
dataset{1} = readtable("BTP_MTS.xlsx","Sheet","List");
dataset{2} = readtable("BTP_MTS.xlsx","Sheet","Zero Curve");
dataset{3} = readtable("BTP_MTS.xlsx","Sheet","Yield Curve");

%% Securities
dataset{4} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EC1394237"),'linear');
dataset{5} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EC2421971"),'linear');
dataset{6} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EC3518288"),'linear');
dataset{7} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EC4704507"),'linear');
dataset{8} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EC6667322"),'linear');
dataset{9} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EC9522912"),'linear');
dataset{10} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","ED3032684"),'linear');
dataset{11} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","ED5901696"),'linear');
dataset{12} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","ED9117117"),'linear');
dataset{13} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EF2951483"),'linear');
dataset{14} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EG0648527"),'linear');
dataset{15} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EG7660475"),'linear');
dataset{16} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EH3265541"),'linear');
dataset{17} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EH6038325"),'linear');
dataset{18} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EH8025973"),'linear');
dataset{19} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EH9863067"),'linear');
dataset{20} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EI2018063"),'linear');
dataset{21} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EI3856339"),'linear');
dataset{22} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EI5863861"),'linear');
dataset{23} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EI7933985"),'linear');
dataset{24} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EJ0420566"),'linear');
dataset{25} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EJ3416900"),'linear');
dataset{26} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EJ5688621"),'linear');
dataset{27} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EJ7704418"),'linear');
dataset{28} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EK0933524"),'linear');
dataset{29} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EK4572963"),'linear');
dataset{30} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","EK7691190"),'linear');
dataset{31} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","UV6569569"),'linear');
dataset{32} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","JK2344014"),'linear');
dataset{33} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","QZ0167556"),'linear');
dataset{34} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","AM2936822"),'linear');
dataset{35} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","AO1479572"),'linear');
dataset{36} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","AQ9353915"),'linear');
dataset{37} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","AT7587708"),'linear');
dataset{38} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","AX3905822"),'linear');
dataset{39} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","ZR3437988"),'linear');
dataset{40} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","BG2593013"),'linear');
dataset{41} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","BJ8379114"),'linear');
dataset{42} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","ZO6504153"),'linear');
dataset{43} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","BO0961645"),'linear');
dataset{44} = fillmissing(readtimetable("BTP_MTS.xlsx","Sheet","BP9688410"),'linear');

%% Generate dataset
save dataset.mat