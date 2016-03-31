% This code is to do curveFit on data from individual spindles and
% calculate the mean and ci of stat of interst.
% The goal is to figure out if there is outlier and throw them out.
% I'll plot Tau/Mean of Velocity as circle and ci as circle radius.
% lt = lifetime;  vl = velocity; gof = goodness of fit

% Frequency distributiion of Lifetime/Velocity -> exponential curve fit -> calculate
% important parameters including K and tau and their confidence interval (ci).

%% Resave data separately as Neg2 and 18B2.

clc; clear;
load TracksInfo.mat;

%% Frequency distribution and Exponential fit of lifetimes for each sample

for i = 1: length( TracksInfo )
    tbl_temp= tabulate( TracksInfo(i).life_times(~isnan(TracksInfo(i).life_times)) );
    tbl = tbl_temp( 4:2:end, : );
    clear tbl_temp;
    lt_bin = tbl(:,1);
    lt_freq_dist = tbl(:,3);
    [~, TracksInfo(i).lt_gof] = createExpFit( lt_bin, lt_freq_dist, TracksInfo(i).name );
    close; 
end


%% Frequency distribution and Gaussian fit of velocity for each sample
edges = 0:2:38;

for i = 1: length( TracksInfo )
    [ counts, binValues ] = hist( TracksInfo(i).vel_means(~isnan(TracksInfo(i).vel_means)), edges );
    % 'counts' is real number. We normalize it to percentage.
    vl_normCounts = 100 * counts' / sum(counts);
    vl_binValues = binValues';
    [ ~, TracksInfo(i).vl_gof ] = createGaussianFit( vl_binValues, vl_normCounts, TracksInfo(i).name );
    close; 
end
%% Save data in mat file
for i = 1: length( TracksInfo )
    TracksInfo(i).Tau = TracksInfo(i).lt_gof.Tau; 
    TracksInfo(i).Tau_ci = TracksInfo(i).lt_gof.Tau_ci; 
    TracksInfo(i).Vel = TracksInfo(i).vl_gof.Mean;
    TracksInfo(i).Vel_ci = TracksInfo(i).vl_gof.Mean_ci;
end

%% Group Neg2 and 18B2 separately 

Neg2.name = [];   n1 = 0;       
Neg2.Tau = [];    Neg2.Tau_ci = [];
Neg2.Vel = [];    Neg2.Vel_ci = [];
Kif18B.name = []; n2 = 0; 
Kif18B.Tau = [];  Kif18B.Tau_ci = [];
Kif18B.Vel = [];  Kif18B.Vel_ci = [];

for i = 1:length(TracksInfo)
    matches = strfind({TracksInfo(i).name},'Neg'); 
    tf = any(vertcat(matches{:}));
    if tf >0
    n1 = n1 + 1; 
    Neg2(n1).name = TracksInfo(i).name; 
    Neg2(n1).Tau = TracksInfo(i).Tau;
    Neg2(n1).Tau_ci = TracksInfo(i).Tau_ci;
    Neg2(n1).Vel = TracksInfo(i).Vel;
    Neg2(n1).Vel_ci = TracksInfo(i).Vel_ci;
    else
    n2 = n2 + 1; 
    Kif18B(n2).name = TracksInfo(i).name; 
    Kif18B(n2).Tau = TracksInfo(i).Tau;
    Kif18B(n2).Tau_ci = TracksInfo(i).Tau_ci;
    Kif18B(n2).Vel = TracksInfo(i).Vel;
    Kif18B(n2).Vel_ci = TracksInfo(i).Vel_ci;
    end
end 
clear ( 'i', 'tf', 'matches', 'n1', 'n2' ); 

save ('TracksInfo_indi');
struct2csv(Neg2, 'Neg2_indi.csv');
struct2csv(Kif18B, 'Kif18B_indi.csv');

%% Plot stat 
figure (); hold on; 
hh_Neg2 = scatter_patches( [Neg2.Vel], [Neg2.Tau], 12, 'r','FaceAlpha',0.4,'EdgeColor','none' ); 
hh_Kif18B = scatter_patches( [Kif18B.Vel] ,[Kif18B.Tau], 12, 'b','FaceAlpha',0.4,'EdgeColor','none' ); 
legend( [hh_Neg2(1),hh_Kif18B(1)], {'Neg2', 'Kif18B'}); legend('boxoff');
xlabel ( 'Velocity (um/min)', 'fontsize', 12, 'Fontname', 'arial'); 
ylabel ( 'Tau (sec)', 'fontsize', 12, 'Fontname', 'arial'); 
print_save_figure( gcf, 'Lifetime_velocity_dotPlot', 'curve_fit_indi' ); 
