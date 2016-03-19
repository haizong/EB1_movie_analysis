% Frequency distributiion of Lifetime -> exponential curve fit -> calculate
% important parameters including K and tau. 

%% Resave data separately as Neg2 and 18B2. 

clc; clear;
load TracksInfo_plot.mat; 

 
% Pool all the lifetimes data together. 
lifetimes_total_Neg2 = [];
lifetimes_total_18B2 = [];

for i = 1:length(TracksInfo)
    matches = strfind({TracksInfo(i).name},'Neg'); 
    tf = any(vertcat(matches{:}));
    if tf >0
    lifetimes_total_Neg2 = [lifetimes_total_Neg2; TracksInfo(i).life_times];
    else
    lifetimes_total_18B2 = [lifetimes_total_18B2; TracksInfo(i).life_times];
    end
end 

%% Perform frequency distribution of all the life_times data 
tbl_temp= tabulate(lifetimes_total_Neg2);
tbl = tbl_temp(4:2:end, :); 
clear tbl_temp;

bin = tbl(:,1);
freq_dist = tbl(:,3); 

[fitresult, gof, Best_fit_value] = createFit(bin, freq_dist)

tbl_temp= tabulate(lifetimes_total_18B2);
tbl = tbl_temp(4:2:end, :); 
clear tbl_temp;

bin = tbl(:,1);
freq_dist = tbl(:,3); 

[fitresult, gof, Best_fit_value] = createFit(bin, freq_dist)