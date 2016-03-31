clc; clear; 

load Neg2_aster.mat; 
load Kif18B_aster.mat; 
load Neg2_spinBody.mat; 
load Kif18B_spinBody.mat; 
%% Pool all the lifetimes data together.
Neg2_sta.aster_lt_total = [];
Neg2_sta.spinBody_lt_total = [];
Kif18B_sta.aster_lt_total = [];
Kif18B_sta.spinBody_lt_total = [];

for i = 1:length(Neg2_aster)
    Neg2_sta.aster_lt_total = [ Neg2_sta.aster_lt_total; Neg2_aster(i).Aster_life_times ];
end
for i = 1:length(Neg2_spinBody)
    Neg2_sta.spinBody_lt_total = [ Neg2_sta.spinBody_lt_total; Neg2_spinBody(i).Spin_life_times ];
end
for i = 1:length(Kif18B_aster)
    Kif18B_sta.aster_lt_total = [ Kif18B_sta.aster_lt_total; Kif18B_aster(i).Aster_life_times ];
end
for i = 1:length(Kif18B_spinBody)
    Kif18B_sta.spinBody_lt_total = [ Kif18B_sta.spinBody_lt_total; Kif18B_spinBody(i).Spin_life_times ];
end
%% Frequency distribution and Exponential fit of lifetimes data

% For Neg2 aster region
tbl_temp= tabulate( Neg2_sta.aster_lt_total(~isnan(Neg2_sta.aster_lt_total)) );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Neg2_sta.aster_lt_bin = tbl(:,1);
Neg2_sta.aster_lt_freq_dist = tbl(:,3);
[Neg2_sta.aster_lt_fitresult, Neg2_sta.aster_lt_gof] = createExpFit( Neg2_sta.aster_lt_bin, Neg2_sta.aster_lt_freq_dist, 'Neg2 aster' );

% For 18B aster region
tbl_temp= tabulate( Kif18B_sta.aster_lt_total(~isnan(Kif18B_sta.aster_lt_total)) );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Kif18B_sta.aster_lt_bin = tbl(:,1);
Kif18B_sta.aster_lt_freq_dist = tbl(:,3);
[ Kif18B_sta.aster_lt_fitResult, Kif18B_sta.aster_lt_gof ] = createExpFit( Kif18B_sta.aster_lt_bin, Kif18B_sta.aster_lt_freq_dist, '18B2 aster' );

% For Neg2 spindle body region
tbl_temp= tabulate( Neg2_sta.spinBody_lt_total(~isnan(Neg2_sta.spinBody_lt_total)) );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Neg2_sta.spin_lt_bin = tbl(:,1);
Neg2_sta.spin_lt_freq_dist = tbl(:,3);
[Neg2_sta.spin_lt_fitresult, Neg2_sta.spin_lt_gof] = createExpFit( Neg2_sta.spin_lt_bin, Neg2_sta.spin_lt_freq_dist, 'Neg2 spindle body' );

% For 18B spindleBody region
tbl_temp= tabulate( Kif18B_sta.spinBody_lt_total(~isnan(Kif18B_sta.spinBody_lt_total)) );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Kif18B_sta.spin_lt_bin = tbl(:,1);
Kif18B_sta.spin_lt_freq_dist = tbl(:,3);
[ Kif18B_sta.spin_lt_fitResult, Kif18B_sta.spin_lt_gof ] = createExpFit( Kif18B_sta.spin_lt_bin, Kif18B_sta.spin_lt_freq_dist, '18B2 spindle body' );

close all;
save ( 'Neg2_sta', 'Neg2_sta' )
save ( 'Kif18B_sta', 'Kif18B_sta' ); 
% %% plot lifetime against x position and relative x position
% 
% figure (); hold on; 
% hh_Neg2 = scatter_patches( [Neg2.Vel], [Neg2.Tau], 12, 'r','FaceAlpha',0.4,'EdgeColor','none' ); 
% hh_Kif18B = scatter_patches( [Kif18B.Vel] ,[Kif18B.Tau], 12, 'b','FaceAlpha',0.4,'EdgeColor','none' ); 
% legend( [hh_Neg2(1),hh_Kif18B(1)], {'Neg2', 'Kif18B'}); legend('boxoff');
% xlabel ( 'Velocity (um/min)', 'fontsize', 12, 'Fontname', 'arial'); 
% ylabel ( 'Tau (sec)', 'fontsize', 12, 'Fontname', 'arial'); 
% print_save_figure( gcf, 'Lifetime_velocity_dotPlot', 'curve_fit_indi' ); 

%% Pool all the velocity data together.
% Neg2_sta.vl_total = [];
% Kif18B_sta.vl_total = [];
% 
% for i = 1:length(TracksInfo)
%     matches = strfind({TracksInfo(i).name},'Neg');
%     tf = any(vertcat(matches{:}));
%     if tf >0
%         Neg2_sta.vl_total  = [ Neg2_sta.vl_total;  TracksInfo(i).vel_means ];
%     else
%         Kif18B_sta.vl_total  = [ Kif18B_sta.vl_total;  TracksInfo(i).vel_means ];
%     end
% end
% clear ( 'i', 'tf', 'matches' );

% %% Frequency distribution and Gaussian fit of velocity data
% edges = 0:2:38;
% 
% % For Neg2 aster region
% [ counts, binValues ] = hist( Neg2_sta.vl_total(~isnan(Neg2_sta.vl_total)), edges );
% % 'counts' is real number. We normalize it to percentage.
% Neg2_sta.vl_normCounts = 100 * counts' / sum(counts);
% Neg2_sta.vl_binValues = binValues';
% [ Neg2_sta.vl_fitResult, Neg2_sta.vl_gof ] = createGaussianFit( Neg2_sta.vl_binValues, Neg2_sta.vl_normCounts, 'Neg2' );
% 
% % For Kif18B
% [ counts, binValues ] = hist( Kif18B_sta.vl_total(~isnan(Kif18B_sta.vl_total)), edges );
% % 'counts' is real number. We normalize it to percentage.
% Kif18B_sta.vl_normCounts = 100 * counts' / sum(counts);
% Kif18B_sta.vl_binValues = binValues';
% [ Kif18B_sta.vl_fitResult, Kif18B_sta.vl_gof ] = createGaussianFit( Kif18B_sta.vl_binValues, Kif18B_sta.vl_normCounts, 'Kif18B' );
