% lt = lifetime;  vl = velocity; gof = goodness of fit
% Frequency distributiion of Lifetime -> exponential curve fit -> calculate
% important parameters including K and tau. 

%% Resave data separately as Neg2 and 18B2. 

clc; clear;
load TracksInfo.mat; 

 
%% Pool all the lifetimes data together. 
Neg2.lt_total = [];
Kif18B.lt_total = [];

for i = 1:length(TracksInfo)
    matches = strfind({TracksInfo(i).name},'Neg'); 
    tf = any(vertcat(matches{:}));
    if tf >0
    Neg2.lt_total = [ Neg2.lt_total; TracksInfo(i).life_times ];
    else
    Kif18B.lt_total = [ Kif18B.lt_total; TracksInfo(i).life_times ];
    end
end 
clear ( 'i', 'tf', 'matches' ); 

%% Frequency distribution and Exponential fit of lifetimes data 

% For Neg2
tbl_temp= tabulate( Neg2.lt_total(~isnan(Neg2.lt_total)) );
tbl = tbl_temp( 4:2:52, : ); 
clear tbl_temp;
Neg2.lt_bin = tbl(:,1);
Neg2.lt_freq_dist = tbl(:,3); 
[Neg2.lt_fitresult, Neg2.lt_gof] = createExpFit( Neg2.lt_bin, Neg2.lt_freq_dist, 'Neg2' );

% For 18B
tbl_temp= tabulate( Kif18B.lt_total(~isnan(Kif18B.lt_total)) );
tbl = tbl_temp( 4:2:52, : ); 
clear tbl_temp;
Kif18B.lt_bin = tbl(:,1);
Kif18B.lt_freq_dist = tbl(:,3); 
[ Kif18B.lt_fitResult, Kif18B.lt_gof ] = createExpFit( Kif18B.lt_bin, Kif18B.lt_freq_dist, '18B2' );

% close all; 

%% Pool all the velocity data together. 
Neg2.vl_total = []; 
Kif18B.vl_total = []; 

for i = 1:length(TracksInfo)
    matches = strfind({TracksInfo(i).name},'Neg'); 
    tf = any(vertcat(matches{:}));
    if tf >0
    Neg2.vl_total  = [ Neg2.vl_total;  TracksInfo(i).vel_means ];
    else
    Kif18B.vl_total  = [ Kif18B.vl_total;  TracksInfo(i).vel_means ];
    end
end 
clear ( 'i', 'tf', 'matches' ); 

%% Frequency distribution and Gaussian fit of velocity data 
edges = 0:2:38;

% For Neg2
[ counts, binValues ] = hist( Neg2.vl_total(~isnan(Neg2.vl_total)), edges );
% 'counts' is real number. We normalize it to percentage. 
Neg2.vl_normCounts = 100 * counts' / sum(counts); 
Neg2.vl_binValues = binValues';
[ Neg2.vl_fitResult, Neg2.vl_gof ] = createGaussianFit( Neg2.vl_binValues, Neg2.vl_normCounts, 'Neg2' );

% For Kif18B
[ counts, binValues ] = hist( Kif18B.vl_total(~isnan(Kif18B.vl_total)), edges );
% 'counts' is real number. We normalize it to percentage. 
Kif18B.vl_normCounts = 100 * counts' / sum(counts); 
Kif18B.vl_binValues = binValues';
[ Kif18B.vl_fitResult, Kif18B.vl_gof ] = createGaussianFit( Kif18B.vl_binValues, Kif18B.vl_normCounts, 'Kif18B' );

%% Save data in mat file and csv file
save ( 'Neg2_EB1_analysis.mat', 'Neg2' );
save ( 'Kif18B_EB1_analysis.mat', 'Kif18B' );

struct2csv(Neg2, 'Neg2.csv');
struct2csv(Kif18B, 'Kif18B.csv');
struct2csv(Neg2.lt_gof, 'Neg2_lifetime_fit.csv');
struct2csv(Neg2.vl_gof, 'Neg2_velocity_fit.csv');
struct2csv(Kif18B.lt_gof, 'Kif18B_lifetime_fit.csv');
struct2csv(Kif18B.vl_gof, 'Kif18B_velocity_fit.csv');