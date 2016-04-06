% Descirption
% Script for Plot Supplemental Fig2 EB1 analysis for Claire's Neg2 and 
% Kif18B RNAi movies. 
% Plot 3X3 panels. Include TotalnumTracks, LifetimeFitTotal, VelocityFitTotal, 
% and lifetime velocity fit in individual regions (aster_lr, aster_ub, spindle_0.6). 
% Overlay Neg2 and 18B. 

% HZ 2016-4-5 Bloomington

%% Initialize
clc; clear; 
fontsize = 12; titlesize = 14; fontname = 'arial'; 
load 'Neg2.mat'; 
load Kif18B.mat;
load Position_Analysis.mat; 
%%  SupFig_2A Plot number of tracks in each spindle (box plot & mean+-sd)
figure(); hold on;
y = [ [Neg2.NumTracks]'; [Kif18B.NumTracks]'];
group = [ones(length(Neg2),1); ones(length(Kif18B),1)*2];
positions = [1 3];
boxplot( y, group, 'positions', positions );
set(gca,'xtick',[1 3]);
set(gca,'xticklabel',{'Neg2','Kif18B'}, 'fontsize',fontsize, 'fontname', 'arial');
ylabel ('Number of tracks per spindle', 'fontsize',fontsize, 'fontname', 'arial')
print_save_figure( gcf, 'SupFig_2A_numTracks', 'Supplemental' );

%%  SupFig_2B  Exponential fit of lifetimes from all tracks 
% Pool all lifetime and velocity together while looping. 
% for Neg2
Neg2_total_sta.lifetime.lt_total = [];
Neg2_total_sta.velocity.vel_total = [];
for i = 1:length(Neg2)    
    Neg2_total_sta.lifetime.lt_total = [ Neg2_total_sta.lifetime.lt_total; Neg2(i).life_times];
    Neg2_total_sta.velocity.vel_total = [ Neg2_total_sta.velocity.vel_total; Neg2(i).vel_means];
end

% for Kif18B
Kif18B_total_sta.lifetime.lt_total = [];
Kif18B_total_sta.velocity.vel_total = [];
for i = 1:length(Kif18B)
    Kif18B_total_sta.lifetime.lt_total = [ Kif18B_total_sta.lifetime.lt_total; Kif18B(i).life_times];
    Kif18B_total_sta.velocity.vel_total = [ Kif18B_total_sta.velocity.vel_total; Kif18B(i).vel_means];
end

%% Frequency distribution and Exponential fit of lifetimes data
% For Neg2
figure(); hold on; 
tbl_temp= tabulate( Neg2_total_sta.lifetime.lt_total );
tbl = tbl_temp( 4:2:52, : );   % 25 bins
clear tbl_temp;
Neg2_total_sta.lifetime.lt_bin = tbl(:,1);
Neg2_total_sta.lifetime.lt_freq_dist = tbl(:,3);
[Neg2_total_sta.lifetime.lt_fitresult, Neg2_total_sta.lifetime.lt_gof] = ...
    createExpFit( Neg2_total_sta.lifetime.lt_bin, ...
    Neg2_total_sta.lifetime.lt_freq_dist, 'Neg2', 'b' );

% For Kif18B
tbl_temp= tabulate( Kif18B_total_sta.lifetime.lt_total );
tbl = tbl_temp( 4:2:52, : );
clear tbl_temp;
Kif18B_total_sta.lifetime.lt_bin = tbl(:,1);
Kif18B_total_sta.lifetime.lt_freq_dist = tbl(:,3);
[Kif18B_total_sta.lifetime.lt_fitresult, Kif18B_total_sta.lifetime.lt_gof] = ...
    createExpFit( Kif18B_total_sta.lifetime.lt_bin, ...
    Kif18B_total_sta.lifetime.lt_freq_dist, 'Kif18B', 'r' );
box on; 
print_save_figure( gcf, 'SupFig_2B_ExpFit_lifetimes', 'Supplemental' ); 

%% SupFig_2C
% Frequency distribution and Gaussian fit of velocity data
figure(); hold on; 
edges = 0:1:38;
% For Neg2
[ counts, binValues ] = hist( Neg2_total_sta.velocity.vel_total, edges );
% 'counts' is real number. We normalize it to percentage.
Neg2_total_sta.velocity.vl_normCounts = 100 * counts' / sum(counts);
Neg2_total_sta.velocity.vl_binValues = binValues';
[ Neg2_total_sta.velocity.vl_fitResult, Neg2_total_sta.velocity.vl_gof ] = ...
    createGaussianFit( Neg2_total_sta.velocity.vl_binValues, ...
    Neg2_total_sta.velocity.vl_normCounts, 'Neg2', 'b' );

% For Kif18B
[ counts, binValues ] = hist( Kif18B_total_sta.velocity.vel_total, edges );
% 'counts' is real number. We normalize it to percentage.
Kif18B_total_sta.velocity.vl_normCounts = 100 * counts' / sum(counts);
Kif18B_total_sta.velocity.vl_binValues = binValues';
[ Kif18B_total_sta.velocity.vl_fitResult, Kif18B_total_sta.velocity.vl_gof ] = ...
    createGaussianFit( Kif18B_total_sta.velocity.vl_binValues,...
    Kif18B_total_sta.velocity.vl_normCounts, 'Kif18B', 'r' );
box on; 
print_save_figure( gcf, 'SupFig_2C_GauFit_vel', 'Supplemental' ); 
save ( 'Neg2_total_sta', 'Neg2_total_sta' ); 
save ( 'Kif18B_total_sta', 'Kif18B_total_sta' ); 

%% SupFig_2D  Aster_lr 
% Frequency distribution and Exponential fit of lifetimes data in different positions 
figure (); hold on; 
% Neg2
tbl_temp= tabulate( Neg2_aster_lr_sta.lt_total );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Neg2_aster_lr_sta.lt_bin = tbl(:,1);
Neg2_aster_lr_sta.lt_freq_dist = tbl(:,3);
[Neg2_aster_lr_sta.lt_fitresult, Neg2_aster_lr_sta.lt_gof] = ...
    createExpFit( Neg2_aster_lr_sta.lt_bin, Neg2_aster_lr_sta.lt_freq_dist, ...
    'Neg2 aster lr', 'b' );

% Kif18B
tbl_temp= tabulate( Kif18B_aster_lr_sta.lt_total );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Kif18B_aster_lr_sta.lt_bin = tbl(:,1);
Kif18B_aster_lr_sta.lt_freq_dist = tbl(:,3);
[Kif18B_aster_lr_sta.lt_fitresult, Kif18B_aster_lr_sta.lt_gof] = ...
    createExpFit( Kif18B_aster_lr_sta.lt_bin, Kif18B_aster_lr_sta.lt_freq_dist, ...
    'Kif18B aster lr', 'r');
box on; 
print_save_figure( gcf, 'SupFig_2D_ExpFit_lt_Aster_lr', 'Supplemental' ); 

%% SupFig_2E  Aster_ub 
figure (); hold on; 
% Neg2
tbl_temp= tabulate( Neg2_aster_ub_sta.lt_total );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Neg2_aster_ub_sta.lt_bin = tbl(:,1);
Neg2_aster_ub_sta.lt_freq_dist = tbl(:,3);
[Neg2_aster_ub_sta.lt_fitresult, Neg2_aster_ub_sta.lt_gof] = ...
    createExpFit( Neg2_aster_ub_sta.lt_bin, Neg2_aster_ub_sta.lt_freq_dist, ...
    'Neg2 aster ub', 'b' );

% Kif18B
tbl_temp= tabulate( Kif18B_aster_ub_sta.lt_total );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Kif18B_aster_ub_sta.lt_bin = tbl(:,1);
Kif18B_aster_ub_sta.lt_freq_dist = tbl(:,3);
[Kif18B_aster_ub_sta.lt_fitresult, Kif18B_aster_ub_sta.lt_gof] = ...
    createExpFit( Kif18B_aster_ub_sta.lt_bin, Kif18B_aster_ub_sta.lt_freq_dist,...
    'Kif18B aster ub', 'r' );
box on; 
print_save_figure( gcf, 'SupFig_2E_ExpFit_lt_Aster_ub', 'Supplemental' ); 
%% SupFig_2F   Spindle 0.6 region
figure (); hold on; 
% Neg2
tbl_temp= tabulate( Neg2_spindle_half_sta.lt_total );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Neg2_spindle_half_sta.lt_bin = tbl(:,1);
Neg2_spindle_half_sta.lt_freq_dist = tbl(:,3);
[Neg2_spindle_half_sta.lt_fitresult, Neg2_spindle_half_sta.lt_gof] = ...
    createExpFit( Neg2_spindle_half_sta.lt_bin, Neg2_spindle_half_sta.lt_freq_dist, ...
    'Neg2 spindle 0.6', 'b' );

% Kif18B
tbl_temp= tabulate( Kif18B_spindle_half_sta.lt_total );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Kif18B_spindle_half_sta.lt_bin = tbl(:,1);
Kif18B_spindle_half_sta.lt_freq_dist = tbl(:,3);
[Kif18B_spindle_half_sta.lt_fitresult, Kif18B_spindle_half_sta.lt_gof] = ...
    createExpFit( Kif18B_spindle_half_sta.lt_bin, Kif18B_spindle_half_sta.lt_freq_dist, ...
    'Kif18B spindle 0.6', 'r' );
box on; 
print_save_figure( gcf, 'SupFig_2F_ExpFit_lt_spindle_0.6', 'Supplemental' ); 

%% SupFig_2G   Aster lr
% Frequency distribution and Exponential fit of lifetimes in corresponding regions
figure (); hold on; 
edges = 0:1:38;
% For Neg2 
[ counts, binValues ] = hist( Neg2_aster_lr_sta.vl_total, edges );
% 'counts' is real number. We normalize it to percentage.
Neg2_aster_lr_sta.vl_normCounts = 100 * counts' / sum(counts);
Neg2_aster_lr_sta.vl_binValues = binValues';
[ Neg2_aster_lr_sta.vl_fitResult, Neg2_aster_lr_sta.vl_gof ] = ...
    createGaussianFit( Neg2_aster_lr_sta.vl_binValues, Neg2_aster_lr_sta.vl_normCounts, ...
    'Neg2 aster lr', 'b' );

% For Kif18B aster lr
[ counts, binValues ] = hist( Kif18B_aster_lr_sta.vl_total, edges );
% 'counts' is real number. We normalize it to percentage.
Kif18B_aster_lr_sta.vl_normCounts = 100 * counts' / sum(counts);
Kif18B_aster_lr_sta.vl_binValues = binValues';
[ Kif18B_aster_lr_sta.vl_fitResult, Kif18B_aster_lr_sta.vl_gof ] = ...
    createGaussianFit( Kif18B_aster_lr_sta.vl_binValues, Kif18B_aster_lr_sta.vl_normCounts, ...
    'Kif18B aster lr', 'r' );
box on; 
print_save_figure( gcf, 'SupFig_2G_GauFit_vel_Aster_lr', 'Supplemental' ); 

%% SupFig_2H Aster ub
figure (); hold on; 
% For Neg2
[ counts, binValues ] = hist( Neg2_aster_ub_sta.vl_total, edges );
% 'counts' is real number. We normalize it to percentage.
Neg2_aster_ub_sta.vl_normCounts = 100 * counts' / sum(counts);
Neg2_aster_ub_sta.vl_binValues = binValues';
[ Neg2_aster_ub_sta.vl_fitResult, Neg2_aster_ub_sta.vl_gof ] = ...
    createGaussianFit( Neg2_aster_ub_sta.vl_binValues, Neg2_aster_ub_sta.vl_normCounts, ...
    'Neg2 aster ub', 'b' );

% For Kif18B aster ub
[ counts, binValues ] = hist( Kif18B_aster_ub_sta.vl_total, edges );
% 'counts' is real number. We normalize it to percentage.
Kif18B_aster_ub_sta.vl_normCounts = 100 * counts' / sum(counts);
Kif18B_aster_ub_sta.vl_binValues = binValues';
[ Kif18B_aster_ub_sta.vl_fitResult, Kif18B_aster_ub_sta.vl_gof ] = ...
    createGaussianFit( Kif18B_aster_ub_sta.vl_binValues, Kif18B_aster_ub_sta.vl_normCounts, ...
    'Kif18B aster ub', 'r' );
box on; 
print_save_figure( gcf, 'SupFig_2H_GauFit_vel_Aster_ub', 'Supplemental' ); 

%% SupFig_2H Spindle 0.6 region
figure (); hold on; 
% For Neg2
[ counts, binValues ] = hist( Neg2_spindle_half_sta.vl_total, edges );
% 'counts' is real number. We normalize it to percentage.
Neg2_spindle_half_sta.vl_normCounts = 100 * counts' / sum(counts);
Neg2_spindle_half_sta.vl_binValues = binValues';
[ Neg2_spindle_half_sta.vl_fitResult, Neg2_spindle_half_sta.vl_gof ] = ...
    createGaussianFit( Neg2_spindle_half_sta.vl_binValues, Neg2_spindle_half_sta.vl_normCounts, ...
    ['Neg2 spindle ', num2str(perSpindle)], 'b' );

% For Kif18B spindle 0.6
[ counts, binValues ] = hist( Kif18B_spindle_half_sta.vl_total, edges );
% 'counts' is real number. We normalize it to percentage.
Kif18B_spindle_half_sta.vl_normCounts = 100 * counts' / sum(counts);
Kif18B_spindle_half_sta.vl_binValues = binValues';
[ Kif18B_spindle_half_sta.vl_fitResult, Kif18B_spindle_half_sta.vl_gof ] = ...
    createGaussianFit( Kif18B_spindle_half_sta.vl_binValues, Kif18B_spindle_half_sta.vl_normCounts, ...
    ['Kif18B spindle ',  num2str(perSpindle)], 'r' );
box on; 
print_save_figure( gcf, 'SupFig_2I_GauFit_vel_Spindle_0.6', 'Supplemental' ); 