% Descirption:

% This script calculates the basic statistics of ALL the tracks in Neg2
% Kif18B spindles, including pole2pole distance, number of tracks, velocity,
% displacement, angle, lifetimes. Curvefit lifetimes and velocity. 

% This is the step after extCrd.m from which we get the RotTracks.mat for
% saving of original and rotated positional coordinates of all tracks.
%
% This script does the following things:
% 1) Separates Neg2 and Kif18B
% 2) Cal and plot pole-to-pole distance and total number of tracks with
%    descriptive statistics  <getDescriptiveStatistics.m>
% 3) Cal dynamics parameter using <cal_track_stats.m>
% 4) Exponential fit of pooled lifetimes and F test to compare K
% 5) Gaussian fit of pooled velocity and F test to compare mean

% HZ 2016-4-2 Bloomington
%% Pool Neg2 and Kif18b stats.
clc; clear;
load RotTracks.mat;
Neg2 = [];
Kif18B  = [];
fontsize = 14;

for i = 1:length(RotTracks)
    matches = strfind({RotTracks(i).name},'Neg');
    tf = any(vertcat(matches{:}));
    if tf >0
        Neg2 = [ Neg2; RotTracks(i) ];
    else
        Kif18B = [ Kif18B; RotTracks(i) ];
    end
end
Neg2 = Neg2 (2:end);  % Get rid of 20150406-Neg2-001, which only contains 34 frames. Neg2 has 11 spindles.
Kif18B = Kif18B (2:end);  % Get rid of 20150406-18B2-000, which contains 122 frames. 18B2 has 16 spindles.
clear ( 'i', 'tf', 'matches' );

%% Cal and plot pole2pole distance (spindle length) and total number of tracks in each spindle

% Cal pole2pole distance and total number of tracks in each spindle
for i = 1:length( Neg2 )
    Neg2(i).p2p_dist = pdist([Neg2(i).Pole_left(1), Neg2(i).Pole_left(2); ...
        Neg2(i).Pole_right(1), Neg2(i).Pole_right(2)]) * 150/1000;  % convert from pixel to micron
    Neg2(i).NumTracks = length(Neg2(i).xCoord_r);
end

for i = 1:length( Kif18B )
    Kif18B(i).p2p_dist = pdist([Kif18B(i).Pole_left(1), Kif18B(i).Pole_left(2); ...
        Kif18B(i).Pole_right(1), Kif18B(i).Pole_right(2)]) * 150/1000;
    Kif18B(i).NumTracks = length(Kif18B(i).xCoord_r);
end

Neg2_total_sta.ds_p2p_dist = getDescriptiveStatistics([Neg2.p2p_dist]);
Neg2_total_sta.ds_NumTracks = getDescriptiveStatistics([Neg2.NumTracks]);
Kif18B_total_sta.ds_p2p_dist = getDescriptiveStatistics([Kif18B.p2p_dist]);
Kif18B_total_sta.ds_NumTracks = getDescriptiveStatistics([Kif18B.NumTracks]);

%  Plot pole2pole distance in each spindle (box plot & mean+-sd)
figure; hold on;
y = [ [Neg2.p2p_dist]'; [Kif18B.p2p_dist]'];
group = [ones(length(Neg2),1); ones(length(Kif18B),1)*2];
positions = [1 2];
p = boxplot( y, group, 'positions', positions ); hold on
Y = [ Neg2_total_sta.ds_p2p_dist.mean; Kif18B_total_sta.ds_p2p_dist.mean ];
E = [ Neg2_total_sta.ds_p2p_dist.sigma; Kif18B_total_sta.ds_p2p_dist.sigma ];
h = errorbar( Y, E, 'g*', 'linewidth', 1 );
errorbar_tick( h, 40 );
set( gca,'xtick',[1  2 ] );
set( gca,'xticklabel',{'Neg2','Kif18B'}, 'fontsize',fontsize, 'fontname', 'arial' );
ylabel( 'Pole-to-pole Distance (um)', 'fontsize',fontsize, 'fontname', 'arial' )
print_save_figure( gcf, 'Pole_to_pole_distance', 'Statistics' );

%  Plot number of tracks in each spindle (box plot & mean+-sd)
figure; hold on;
y = [ [Neg2.NumTracks]'; [Kif18B.NumTracks]'];
group = [ones(length(Neg2),1); ones(length(Kif18B),1)*2];
positions = [1 2];
boxplot( y, group, 'positions', positions );
Y = [ Neg2_total_sta.ds_NumTracks.mean; Kif18B_total_sta.ds_NumTracks.mean ];
E = [ Neg2_total_sta.ds_NumTracks.sigma; Kif18B_total_sta.ds_NumTracks.sigma ];
h = errorbar( Y, E, 'g*', 'linewidth', 1 );
errorbar_tick( h, 40 );
set(gca,'xtick',[1 2]);
set(gca,'xticklabel',{'Neg2','Kif18B'}, 'fontsize',fontsize, 'fontname', 'arial');
ylabel ('Number of tracks per spindle', 'fontsize',fontsize, 'fontname', 'arial')
print_save_figure( gcf, 'Num_Tracks', 'Statistics' );
close all;
clear( 'E', 'group', 'h', 'i', 'p', 'positions', 'y', 'Y' );

%% Cal MT dynamics using cal_tracks_stats. Pool all lifetime and velocity together while looping.
% for Neg2
Neg2_total_sta.lifetime.lt_total = [];
Neg2_total_sta.velocity.vel_total = [];
for i = 1:length(Neg2)
    [ Neg2(i).vel_all, Neg2(i).vel_means, Neg2(i).dist_all, Neg2(i).dist_sum, ...
        Neg2(i).angle_all, Neg2(i).angle_flipped, Neg2(i).life_times]...
        = cal_track_stats( Neg2(i).xCoord_r, Neg2(i).yCoord_r, 2, 150, 'Total Tracks', Neg2(i).name);
    
    Neg2_total_sta.lifetime.lt_total = [ Neg2_total_sta.lifetime.lt_total; Neg2(i).life_times];
    Neg2_total_sta.velocity.vel_total = [ Neg2_total_sta.velocity.vel_total; Neg2(i).vel_means];
end

% for Kif18B
Kif18B_total_sta.lifetime.lt_total = [];
Kif18B_total_sta.velocity.vel_total = [];
for i = 1:length(Kif18B)
    [ Kif18B(i).vel_all, Kif18B(i).vel_means, Kif18B(i).dist_all, Kif18B(i).dist_sum, ...
        Kif18B(i).angle_all, Kif18B(i).angle_flipped, Kif18B(i).life_times]...
        = cal_track_stats( Kif18B(i).xCoord_r, Kif18B(i).yCoord_r, 2, 150, 'Total Tracks', Kif18B(i).name);
    Kif18B_total_sta.lifetime.lt_total = [ Kif18B_total_sta.lifetime.lt_total; Kif18B(i).life_times];
    Kif18B_total_sta.velocity.vel_total = [ Kif18B_total_sta.velocity.vel_total; Kif18B(i).vel_means];
end

%% Frequency distribution and Exponential fit of lifetimes data
% For Neg2
tbl_temp= tabulate( Neg2_total_sta.lifetime.lt_total );
tbl = tbl_temp( 4:2:52, : );   % 25 bins
clear tbl_temp;
Neg2_total_sta.lifetime.lt_bin = tbl(:,1);
Neg2_total_sta.lifetime.lt_freq_dist = tbl(:,3);
[Neg2_total_sta.lifetime.lt_fitresult, Neg2_total_sta.lifetime.lt_gof] = ...
    createExpFit( Neg2_total_sta.lifetime.lt_bin, Neg2_total_sta.lifetime.lt_freq_dist, 'Neg2' );

% For Kif18B
tbl_temp= tabulate( Kif18B_total_sta.lifetime.lt_total );
tbl = tbl_temp( 4:2:52, : );
clear tbl_temp;
Kif18B_total_sta.lifetime.lt_bin = tbl(:,1);
Kif18B_total_sta.lifetime.lt_freq_dist = tbl(:,3);
[Kif18B_total_sta.lifetime.lt_fitresult, Kif18B_total_sta.lifetime.lt_gof] = ...
    createExpFit( Kif18B_total_sta.lifetime.lt_bin, Kif18B_total_sta.lifetime.lt_freq_dist, 'Kif18B' );

%% Frequency distribution and Gaussian fit of velocity data
edges = 0:2:38;
% For Neg2
[ counts, binValues ] = hist( Neg2_total_sta.velocity.vel_total, edges );
% 'counts' is real number. We normalize it to percentage.
Neg2_total_sta.velocity.vl_normCounts = 100 * counts' / sum(counts);
Neg2_total_sta.velocity.vl_binValues = binValues';
[ Neg2_total_sta.velocity.vl_fitResult, Neg2_total_sta.velocity.vl_gof ] = ...
    createGaussianFit( Neg2_total_sta.velocity.vl_binValues, Neg2_total_sta.velocity.vl_normCounts, 'Neg2' );

% For Kif18B
[ counts, binValues ] = hist( Kif18B_total_sta.velocity.vel_total, edges );
% 'counts' is real number. We normalize it to percentage.
Kif18B_total_sta.velocity.vl_normCounts = 100 * counts' / sum(counts);
Kif18B_total_sta.velocity.vl_binValues = binValues';
[ Kif18B_total_sta.velocity.vl_fitResult, Kif18B_total_sta.velocity.vl_gof ] = ...
    createGaussianFit( Kif18B_total_sta.velocity.vl_binValues, Kif18B_total_sta.velocity.vl_normCounts, 'Kif18B' );

%% Save data in mat file
save ( 'Neg2.mat', 'Neg2' );
save ( 'Kif18B.mat', 'Kif18B' );
