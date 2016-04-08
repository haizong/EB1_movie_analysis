%% Description: 
% This script analyzes the number, lifetime, and velocity of MT tracks
% in corresponding subspindle regions in Neg2 and Kif18B spindles. This
% script runs after <splitSpinZone.m>
%
% Steps:  
    % 1) Calculate MT dynamic statistics in different regions (aster_lr, aster_ub, spindle_0.6)
    %     Note: for spindle, I started with 0.5, so some files were named spindle_half historically. 
    % 2) Plot number of tracks in different subspindle regions
    % 3) Pool all the lifetimes in corresponding position together.
    %    Frequency distribution and Exponential fit of lifetimes in
    %    corresponding regions
    % 4) Pool all the velocities in corresponding position together.
    %    Frequency distribution and Gaussian fit of velocity in
    %    corresponding regions
    % 5) Save workspace
    
% HZ 2016-4-4 Bloomington

%% Calculate MT dynamic statistics from different regions
clc; clear;
tic; 
fontsize = 14; 
perSpindle = 0.6;
% aster_lr
load Neg2_aster_lr.mat; load Kif18B_aster_lr.mat;
for i = 1:length( Neg2_aster_lr ) 
    [ Neg2_aster_lr(i).vel_all, Neg2_aster_lr(i).vel_means, ...
        Neg2_aster_lr(i).dist_all,Neg2_aster_lr(i).dist_sum, ...
        Neg2_aster_lr(i).angle_all, Neg2_aster_lr(i).angle_flipped,...
        Neg2_aster_lr(i).life_times]...
        = cal_track_stats( Neg2_aster_lr(i).xCrd, Neg2_aster_lr(i).yCrd, ...
        2, 150, 'Astral_lr_MTs', Neg2_aster_lr(i).name);
    Neg2_aster_lr(i).numTracks = length( Neg2_aster_lr(i).xCrd ); 
end 

for i = 1:length( Kif18B_aster_lr ) 
    [ Kif18B_aster_lr(i).vel_all, Kif18B_aster_lr(i).vel_means, ...
        Kif18B_aster_lr(i).dist_all,Kif18B_aster_lr(i).dist_sum, ...
        Kif18B_aster_lr(i).angle_all, Kif18B_aster_lr(i).angle_flipped,...
        Kif18B_aster_lr(i).life_times]...
        = cal_track_stats( Kif18B_aster_lr(i).xCrd, Kif18B_aster_lr(i).yCrd, ...
        2, 150, 'Astral_lr_MTs', Kif18B_aster_lr(i).name);
    Kif18B_aster_lr(i).numTracks = length( Kif18B_aster_lr(i).xCrd ); 
end 

% aster_ub
load Neg2_aster_ub.mat; load Kif18B_aster_ub.mat;
for i = 1:length( Neg2_aster_ub ) 
    [ Neg2_aster_ub(i).vel_all, Neg2_aster_ub(i).vel_means, ...
        Neg2_aster_ub(i).dist_all,Neg2_aster_ub(i).dist_sum, ...
        Neg2_aster_ub(i).angle_all, Neg2_aster_ub(i).angle_flipped,...
        Neg2_aster_ub(i).life_times]...
        = cal_track_stats( Neg2_aster_ub(i).xCrd, Neg2_aster_ub(i).yCrd, ...
        2, 150, 'Astral_ub_MTs', Neg2_aster_ub(i).name);
    Neg2_aster_ub(i).numTracks = length( Neg2_aster_ub(i).xCrd ); 
end 

for i = 1:length( Kif18B_aster_ub ) 
    [ Kif18B_aster_ub(i).vel_all, Kif18B_aster_ub(i).vel_means, ...
        Kif18B_aster_ub(i).dist_all,Kif18B_aster_ub(i).dist_sum, ...
        Kif18B_aster_ub(i).angle_all, Kif18B_aster_ub(i).angle_flipped,...
        Kif18B_aster_ub(i).life_times]...
        = cal_track_stats( Kif18B_aster_ub(i).xCrd, Kif18B_aster_ub(i).yCrd, ...
        2, 150, 'Astral_ub_MTs', Kif18B_aster_ub(i).name);
    Kif18B_aster_ub(i).numTracks = length( Kif18B_aster_ub(i).xCrd ); 
end 

% spindle_half
load Neg2_spindle_half.mat; load Kif18B_spindle_half.mat;
for i = 1:length( Neg2_spindle_half ) 
    [ Neg2_spindle_half(i).vel_all, Neg2_spindle_half(i).vel_means, ...
        Neg2_spindle_half(i).dist_all,Neg2_spindle_half(i).dist_sum, ...
        Neg2_spindle_half(i).angle_all, Neg2_spindle_half(i).angle_flipped,...
        Neg2_spindle_half(i).life_times]...
        = cal_track_stats( Neg2_spindle_half(i).xCrd, Neg2_spindle_half(i).yCrd, ...
        2, 150, 'Astral_ub_MTs', Neg2_spindle_half(i).name);
    Neg2_spindle_half(i).numTracks = length( Neg2_spindle_half(i).xCrd ); 
end 

for i = 1:length( Kif18B_spindle_half ) 
    [ Kif18B_spindle_half(i).vel_all, Kif18B_spindle_half(i).vel_means, ...
        Kif18B_spindle_half(i).dist_all,Kif18B_spindle_half(i).dist_sum, ...
        Kif18B_spindle_half(i).angle_all, Kif18B_spindle_half(i).Aster_angle_flipped,...
        Kif18B_spindle_half(i).life_times]...
        = cal_track_stats( Kif18B_spindle_half(i).xCrd, Kif18B_spindle_half(i).yCrd, ...
        2, 150, 'Astral_ub_MTs', Kif18B_spindle_half(i).name);
    Kif18B_spindle_half(i).numTracks = length( Kif18B_spindle_half(i).xCrd );
end 


%%  Plot number of tracks in terms of position
figure; hold on;
y1 = [ Neg2_aster_lr.numTracks ];     y2 = [ Kif18B_aster_lr.numTracks ];
y3 = [ Neg2_aster_ub.numTracks ];     y4 = [ Kif18B_aster_ub.numTracks];
y5 = [ Neg2_spindle_half.numTracks ]; y6 = [ Kif18B_spindle_half.numTracks ]; 
y = [ y1'; y2'; y3'; y4'; y5'; y6'];
group = [ones(length(Neg2_aster_lr),1); ones(length(Kif18B_aster_lr),1)*2; ...
    ones(length(Neg2_aster_ub),1)*3; ones(length(Kif18B_aster_ub),1)*4; ...
    ones(length(Neg2_spindle_half),1)*5; ones(length(Kif18B_spindle_half),1)*6];
positions = [1 2 3 4 5 6];
boxplot( y, group, 'positions', positions);
set(gca,'xtick',[1 2 3 4 5 6]);
set(gca,'xticklabel',{'Neg2 aster lr', 'Kif18B aster lr', ...
    'Neg2 aster ub', 'Kif18B aster ub', 'Neg2 spindle 0.6', 'Kif18B spindle 0.6'});
xticklabel_rotate([],45,[],'Fontsize',12, 'fontname', 'arial');
ylabel('Number of tracks', 'fontsize',fontsize, 'fontname', 'arial')
print_save_figure( gcf, 'Number_of_tracks_position', 'Processed' );


%% Pool all the lifetimes in diff position together.
Neg2_aster_lr_sta.lt_total = [];
Neg2_aster_ub_sta.lt_total = [];
Neg2_spindle_half_sta.lt_total = []; 
Kif18B_aster_lr_sta.lt_total = [];
Kif18B_aster_ub_sta.lt_total = [];
Kif18B_spindle_half_sta.lt_total = []; 
Neg2_aster_lr_sta.vl_total = [];
Neg2_aster_ub_sta.vl_total = [];
Neg2_spindle_half_sta.vl_total = []; 
Kif18B_aster_lr_sta.vl_total = [];
Kif18B_aster_ub_sta.vl_total = [];
Kif18B_spindle_half_sta.vl_total = []; 

% for Neg2
for i = 1:length(Neg2_aster_lr)
    Neg2_aster_lr_sta.lt_total = [ Neg2_aster_lr_sta.lt_total; Neg2_aster_lr(i).life_times ];
    Neg2_aster_lr_sta.vl_total = [ Neg2_aster_lr_sta.vl_total; Neg2_aster_lr(i).vel_means ];
end
for i = 1:length(Neg2_aster_ub)
    Neg2_aster_ub_sta.lt_total = [ Neg2_aster_ub_sta.lt_total; Neg2_aster_ub(i).life_times ];
    Neg2_aster_ub_sta.vl_total = [ Neg2_aster_ub_sta.vl_total; Neg2_aster_ub(i).vel_means ];
end
for i = 1:length(Neg2_spindle_half)
    Neg2_spindle_half_sta.lt_total = [ Neg2_spindle_half_sta.lt_total; Neg2_spindle_half(i).life_times ];
    Neg2_spindle_half_sta.vl_total = [ Neg2_spindle_half_sta.vl_total; Neg2_spindle_half(i).vel_means ];
end

% for Kif18B
for i = 1:length(Kif18B_aster_lr)
    Kif18B_aster_lr_sta.lt_total = [ Kif18B_aster_lr_sta.lt_total; Kif18B_aster_lr(i).life_times ];
    Kif18B_aster_lr_sta.vl_total = [ Kif18B_aster_lr_sta.vl_total; Kif18B_aster_lr(i).vel_means ];
end
for i = 1:length(Kif18B_aster_ub)
    Kif18B_aster_ub_sta.lt_total = [ Kif18B_aster_ub_sta.lt_total; Kif18B_aster_ub(i).life_times ];
    Kif18B_aster_ub_sta.vl_total = [ Kif18B_aster_ub_sta.vl_total; Kif18B_aster_ub(i).vel_means ];
end
for i = 1:length(Kif18B_spindle_half)
    Kif18B_spindle_half_sta.lt_total = [ Kif18B_spindle_half_sta.lt_total; Kif18B_spindle_half(i).life_times ];
    Kif18B_spindle_half_sta.vl_total = [ Kif18B_spindle_half_sta.vl_total; Kif18B_spindle_half(i).vel_means ];
end

%% Frequency distribution and Exponential fit of lifetimes data in different positions 

% For aster_lr 
% Neg2
tbl_temp= tabulate( Neg2_aster_lr_sta.lt_total );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Neg2_aster_lr_sta.lt_bin = tbl(:,1);
Neg2_aster_lr_sta.lt_freq_dist = tbl(:,3);
[Neg2_aster_lr_sta.lt_fitresult, Neg2_aster_lr_sta.lt_gof] = ...
    createExpFit( Neg2_aster_lr_sta.lt_bin, Neg2_aster_lr_sta.lt_freq_dist, 'Neg2 aster lr' );

% Kif18B
tbl_temp= tabulate( Kif18B_aster_lr_sta.lt_total );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Kif18B_aster_lr_sta.lt_bin = tbl(:,1);
Kif18B_aster_lr_sta.lt_freq_dist = tbl(:,3);
[Kif18B_aster_lr_sta.lt_fitresult, Kif18B_aster_lr_sta.lt_gof] = ...
    createExpFit( Kif18B_aster_lr_sta.lt_bin, Kif18B_aster_lr_sta.lt_freq_dist, 'Kif18B aster lr' );

%% Pool all the litime in corresponding position together.

% For aster_ub 
% Neg2
tbl_temp= tabulate( Neg2_aster_ub_sta.lt_total );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Neg2_aster_ub_sta.lt_bin = tbl(:,1);
Neg2_aster_ub_sta.lt_freq_dist = tbl(:,3);
[Neg2_aster_ub_sta.lt_fitresult, Neg2_aster_ub_sta.lt_gof] = ...
    createExpFit( Neg2_aster_ub_sta.lt_bin, Neg2_aster_ub_sta.lt_freq_dist, 'Neg2 aster ub' );

% Kif18B
tbl_temp= tabulate( Kif18B_aster_ub_sta.lt_total );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Kif18B_aster_ub_sta.lt_bin = tbl(:,1);
Kif18B_aster_ub_sta.lt_freq_dist = tbl(:,3);
[Kif18B_aster_ub_sta.lt_fitresult, Kif18B_aster_ub_sta.lt_gof] = ...
    createExpFit( Kif18B_aster_ub_sta.lt_bin, Kif18B_aster_ub_sta.lt_freq_dist, 'Kif18B aster ub' );

%% for spindle half

% Neg2
tbl_temp= tabulate( Neg2_spindle_half_sta.lt_total );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Neg2_spindle_half_sta.lt_bin = tbl(:,1);
Neg2_spindle_half_sta.lt_freq_dist = tbl(:,3);
[Neg2_spindle_half_sta.lt_fitresult, Neg2_spindle_half_sta.lt_gof] = ...
    createExpFit( Neg2_spindle_half_sta.lt_bin, Neg2_spindle_half_sta.lt_freq_dist, 'Neg2 spindle 0.6' );

% Kif18B
tbl_temp= tabulate( Kif18B_spindle_half_sta.lt_total );
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Kif18B_spindle_half_sta.lt_bin = tbl(:,1);
Kif18B_spindle_half_sta.lt_freq_dist = tbl(:,3);
[Kif18B_spindle_half_sta.lt_fitresult, Kif18B_spindle_half_sta.lt_gof] = ...
    createExpFit( Kif18B_spindle_half_sta.lt_bin, Kif18B_spindle_half_sta.lt_freq_dist, 'Kif18B spindle 0.6' );

%% Frequency distribution and Exponential fit of lifetimes in corresponding regions
edges = 0:2:38;
% For Neg2 aster lr
[ counts, binValues ] = hist( Neg2_aster_lr_sta.vl_total, edges );
% 'counts' is real number. We normalize it to percentage.
Neg2_aster_lr_sta.vl_normCounts = 100 * counts' / sum(counts);
Neg2_aster_lr_sta.vl_binValues = binValues';
[ Neg2_aster_lr_sta.vl_fitResult, Neg2_aster_lr_sta.vl_gof ] = ...
    createGaussianFit( Neg2_aster_lr_sta.vl_binValues, Neg2_aster_lr_sta.vl_normCounts, 'Neg2 aster lr' );

% For Kif18B aster lr
[ counts, binValues ] = hist( Kif18B_aster_lr_sta.vl_total, edges );
% 'counts' is real number. We normalize it to percentage.
Kif18B_aster_lr_sta.vl_normCounts = 100 * counts' / sum(counts);
Kif18B_aster_lr_sta.vl_binValues = binValues';
[ Kif18B_aster_lr_sta.vl_fitResult, Kif18B_aster_lr_sta.vl_gof ] = ...
    createGaussianFit( Kif18B_aster_lr_sta.vl_binValues, Kif18B_aster_lr_sta.vl_normCounts, 'Kif18B aster lr' );

%% % For Neg2 aster ub
[ counts, binValues ] = hist( Neg2_aster_ub_sta.vl_total, edges );
% 'counts' is real number. We normalize it to percentage.
Neg2_aster_ub_sta.vl_normCounts = 100 * counts' / sum(counts);
Neg2_aster_ub_sta.vl_binValues = binValues';
[ Neg2_aster_ub_sta.vl_fitResult, Neg2_aster_ub_sta.vl_gof ] = ...
    createGaussianFit( Neg2_aster_ub_sta.vl_binValues, Neg2_aster_ub_sta.vl_normCounts, 'Neg2 aster ub' );

% For Kif18B aster ub
[ counts, binValues ] = hist( Kif18B_aster_ub_sta.vl_total, edges );
% 'counts' is real number. We normalize it to percentage.
Kif18B_aster_ub_sta.vl_normCounts = 100 * counts' / sum(counts);
Kif18B_aster_ub_sta.vl_binValues = binValues';
[ Kif18B_aster_ub_sta.vl_fitResult, Kif18B_aster_ub_sta.vl_gof ] = ...
    createGaussianFit( Kif18B_aster_ub_sta.vl_binValues, Kif18B_aster_ub_sta.vl_normCounts, 'Kif18B aster ub' );

%%  For Neg2 spindle 0.6
[ counts, binValues ] = hist( Neg2_spindle_half_sta.vl_total, edges );
% 'counts' is real number. We normalize it to percentage.
Neg2_spindle_half_sta.vl_normCounts = 100 * counts' / sum(counts);
Neg2_spindle_half_sta.vl_binValues = binValues';
[ Neg2_spindle_half_sta.vl_fitResult, Neg2_spindle_half_sta.vl_gof ] = ...
    createGaussianFit( Neg2_spindle_half_sta.vl_binValues, Neg2_spindle_half_sta.vl_normCounts, ['Neg2 spindle ', num2str(perSpindle)] );

% For Kif18B spindle 0.6
[ counts, binValues ] = hist( Kif18B_spindle_half_sta.vl_total, edges );
% 'counts' is real number. We normalize it to percentage.
Kif18B_spindle_half_sta.vl_normCounts = 100 * counts' / sum(counts);
Kif18B_spindle_half_sta.vl_binValues = binValues';
[ Kif18B_spindle_half_sta.vl_fitResult, Kif18B_spindle_half_sta.vl_gof ] = ...
    createGaussianFit( Kif18B_spindle_half_sta.vl_binValues, Kif18B_spindle_half_sta.vl_normCounts, ['Kif18B spindle ',  num2str(perSpindle)] );

%%  Save all vectors in workspace under file <Position_Analysis.m>
clear ('binValues', 'counts', 'edges', 'fontsize', 'group', 'i',...
    'positions', 'tbl', 'y', 'y1', 'y2', 'y3', 'y4', 'y5', 'y6'); 

save ('Position_Analysis'); 
toc; 
close all; 