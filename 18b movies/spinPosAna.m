
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
clear ( 'i', 'tf', 'matches' );

%% Cal and plot distance between two poles. I did not save this in previous step 'SpindlePosition_analysis'.
for i = 1:length( Neg2 )
    Neg2(i).p2p_dist = pdist([Neg2(i).Pole_left_x, Neg2(i).Pole_left_y; ...
        Neg2(i).Pole_right_x, Neg2(i).Pole_right_y]);
    Neg2(i).NumTracks = length(Neg2(i).xCoord_r);
end

for i = 1:length( Kif18B )
    Kif18B(i).p2p_dist = pdist([Kif18B(i).Pole_left_x, Kif18B(i).Pole_left_y; ...
        Kif18B(i).Pole_right_x, Kif18B(i).Pole_right_y]);
    Kif18B(i).NumTracks = length(Kif18B(i).xCoord_r);
end

%  Plot pole2pole distance and total number of tracks
figure; hold on; 
y1 = [Neg2.p2p_dist] * 150/1000; 
y2 = [Kif18B.p2p_dist] * 150/1000; 
y = [ y1'; y2'];
group = [ones(12,1); ones(17,1)*2];
positions = [1 1.5];
boxplot( y, group, 'positions', positions); 
set(gca,'xtick',[1  1.5 ]);
set(gca,'xticklabel',{'Neg2','Kif18B'}, 'fontsize',fontsize, 'fontname', 'arial');
ylabel('Pole-to-pole Distance (um)', 'fontsize',fontsize, 'fontname', 'arial')
print_save_figure( gcf, 'Pole_to_pole_distance', 'Processed' );

figure; hold on; 
y = [ [Neg2.NumTracks]'; [Kif18B.NumTracks]'];
group = [ones(12,1); ones(17,1)*2];
positions = [1 1.5];
boxplot( y, group, 'positions', positions); 
ylabel ('Number of tracks', 'fontsize',fontsize, 'fontname', 'arial')
set(gca,'xtick',[1  1.5 ]);
set(gca,'xticklabel',{'Neg2','Kif18B'}, 'fontsize',fontsize, 'fontname', 'arial'); 
print_save_figure( gcf, 'Num_Tracks_total', 'Processed' );
close all; 
%% Pool tracks in the aster (left + right zone) and middle zone of the spindle based on the position of the first comet. 

% for Neg2
for n = 1:length( Neg2 )
    Neg2(n).Left_xCrd= [];   Neg2(n).Left_yCrd = [];
    Neg2(n).Right_xCrd = []; Neg2(n).Right_yCrd = []; 
    Neg2(n).Mid_xCrd = [];   Neg2(n).Mid_yCrd = []; 
    n_tracks = length(Neg2(n).xCoord_r);

% count tracks between/out up and bottom left and right lines.
tracks_left = 0;   tracks_middle = 0;  tracks_right = 0; 
tracks_btn_ub = 0; tracks_out_lr = 0;  tracks_out_ub = 0; 
for i = 1:n_tracks
    % decide if tracks are within the up_bottom boundary
    if any(Neg2(n).yCoord_r(i, ~isnan(Neg2(n).yCoord_r(i,:))) > Neg2(n).box_perm.top) && ...
            any(Neg2(n).yCoord_r(i, ~isnan(Neg2(n).yCoord_r(i,:))) < Neg2(n).box_perm.bottom)
        tracks_btn_ub = tracks_btn_ub +1;
        % decide if tracks fall into left or right
        if any(Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) >= Neg2(n).box_perm.left(1)) && ...
                all(Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) <= Neg2(n).Pole_left_xr)
            Neg2(n).Left_xCrd(size(Neg2(n).Left_xCrd,1)+1,:) = Neg2(n).xCoord_r(i,:);
            Neg2(n).Left_yCrd(size(Neg2(n).Left_yCrd,1)+1,:) = Neg2(n).yCoord_r(i,:);
            tracks_left = tracks_left +1; 
        elseif any(Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) > Neg2(n).Pole_left_xr) && ...
                any(Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) <= Neg2(n).Pole_right_xr)
            Neg2(n).Mid_xCrd(size(Neg2(n).Mid_xCrd,1)+1,:) = Neg2(n).xCoord_r(i,:);
            Neg2(n).Mid_yCrd(size(Neg2(n).Mid_yCrd,1)+1,:) = Neg2(n).yCoord_r(i,:);
            tracks_middle = tracks_middle +1;
        elseif any(Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) > Neg2(n).Pole_right_xr) && ...
                any(Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) <= Neg2(n).box_perm.right(1))
            Neg2(n).Right_xCrd(size(Neg2(n).Right_xCrd,1)+1,:) = Neg2(n).xCoord_r(i,:);
            Neg2(n).Right_yCrd(size(Neg2(n).Right_yCrd,1)+1,:) = Neg2(n).yCoord_r(i,:);
            tracks_right = tracks_right +1;
        elseif all(Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) < Neg2(n).box_perm.left(1)) || ...
                all(Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) > Neg2(n).box_perm.right(1))
            tracks_out_lr = tracks_out_lr + 1;
        end
    else tracks_out_ub = tracks_out_ub + 1;
    end
end
end 

%% for Kif18B
for n = 1:length( Kif18B )
    Kif18B(n).Left_xCrd= [];   Kif18B(n).Left_yCrd = [];
    Kif18B(n).Right_xCrd = []; Kif18B(n).Right_yCrd = []; 
    Kif18B(n).Mid_xCrd = [];   Kif18B(n).Mid_yCrd = []; 
    n_tracks = length(Kif18B(n).xCoord_r);

% count tracks between/out up and bottom left and right lines.
tracks_left = 0;   tracks_middle = 0;  tracks_right = 0; 
tracks_btn_ub = 0; tracks_out_lr = 0;  tracks_out_ub = 0; 
for i = 1:n_tracks
    % decide if tracks are within the up_bottom boundary
    if any(Kif18B(n).yCoord_r(i, ~isnan(Kif18B(n).yCoord_r(i,:))) > Kif18B(n).box_perm.top) && ...
            any(Kif18B(n).yCoord_r(i, ~isnan(Kif18B(n).yCoord_r(i,:))) < Kif18B(n).box_perm.bottom)
        tracks_btn_ub = tracks_btn_ub +1;
        % decide if tracks fall into left or right
        if any(Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) >= Kif18B(n).box_perm.left(1)) && ...
                all(Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) <= Kif18B(n).Pole_left_xr)
            Kif18B(n).Left_xCrd(size(Kif18B(n).Left_xCrd,1)+1,:) = Kif18B(n).xCoord_r(i,:);
            Kif18B(n).Left_yCrd(size(Kif18B(n).Left_yCrd,1)+1,:) = Kif18B(n).yCoord_r(i,:);
            tracks_left = tracks_left +1; 
        elseif any(Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) > Kif18B(n).Pole_left_xr) && ...
                any(Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) <= Kif18B(n).Pole_right_xr)
            Kif18B(n).Mid_xCrd(size(Kif18B(n).Mid_xCrd,1)+1,:) = Kif18B(n).xCoord_r(i,:);
            Kif18B(n).Mid_yCrd(size(Kif18B(n).Mid_yCrd,1)+1,:) = Kif18B(n).yCoord_r(i,:);
            tracks_middle = tracks_middle +1;
        elseif any(Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) > Kif18B(n).Pole_right_xr) && ...
                any(Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) <= Kif18B(n).box_perm.right(1))
            Kif18B(n).Right_xCrd(size(Kif18B(n).Right_xCrd,1)+1,:) = Kif18B(n).xCoord_r(i,:);
            Kif18B(n).Right_yCrd(size(Kif18B(n).Right_yCrd,1)+1,:) = Kif18B(n).yCoord_r(i,:);
            tracks_right = tracks_right +1;
        elseif all(Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) < Kif18B(n).box_perm.left(1)) || ...
                all(Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) > Kif18B(n).box_perm.right(1))
            tracks_out_lr = tracks_out_lr + 1;
        end
    else tracks_out_ub = tracks_out_ub + 1;
    end
end
end 

%%  Cal and plot number of tracks in left + right zone (Aster population) and middle region (spindle MTs + K-fibers). 
for i = 1:length( Neg2 )
    [row_left, ~] = size(Neg2(i).Left_xCrd);
    [row_right, ~] = size(Neg2(i).Right_xCrd);
    Neg2(i).NumAster = row_left + row_right;
    [row_mid, ~] = size(Neg2(i).Mid_xCrd);
    Neg2(i).NumSpinBody = row_mid;
end

for i = 1:length( Kif18B )
    Kif18B(i).NumAster = size( Kif18B(i).Left_xCrd, 1 ) + size( Kif18B(i).Right_xCrd, 1 );
    Kif18B(i).NumSpinBody = size( Kif18B(i).Mid_xCrd, 1 );
end

%%  Plot number of tracks in terms of position
figure; hold on; 
y1 = [Neg2.NumAster];   y2 = [Neg2.NumSpinBody]; 
y3 = [Kif18B.NumAster]; y4 = [Kif18B.NumSpinBody]; 
y = [ y1'; y2'; y3'; y4']; 
group = [ones(12,1); ones(12,1)*2; ones(17,1)*3; ones(17,1)*4];
positions = [1 1.25 2 2.25];
boxplot( y, group, 'positions', positions); 
set(gca,'xtick',[1 1.25 2 2.25]);
set(gca,'xticklabel',{'Neg2 aster', 'Neg2 spinBody', 'Kif18B aster', 'Kif18B spinBody'});
xticklabel_rotate([],45,[],'Fontsize',12, 'fontname', 'arial');
ylabel('Number of tracks', 'fontsize',fontsize, 'fontname', 'arial')
print_save_figure( gcf, 'Number_of_tracks_position', 'Processed' );

%%
save ('Neg2', 'Neg2'); save ('Kif18B', 'Kif18B'); 

%%  Cal stat for MTs in diff regions. 
Neg2_aster = [];
for i = 2:length(Neg2)  % First Neg2 only has 34 frames. Throw out. 
    Neg2_aster(i).name = Neg2(i).name;
    Neg2_aster(i).Pole_left_xr = Neg2(i).Pole_left_xr; 
    Neg2_aster(i).Pole_left_yr = Neg2(i).Pole_left_yr; 
    Neg2_aster(i).Pole_right_xr = Neg2(i).Pole_right_xr; 
    Neg2_aster(i).Pole_right_yr = Neg2(i).Pole_right_yr; 
    [Neg2_aster(i).Aster_vel_all, Neg2_aster(i).Aster_vel_means, Neg2_aster(i).Aster_dist_all,...
        Neg2_aster(i).Aster_dist_sum, Neg2_aster(i).Aster_angle_all, Neg2_aster(i).Aster_angle_flipped, Neg2_aster(i).Aster_life_times]...
        = cal_track_stats([Neg2(i).Left_xCrd; Neg2(i).Right_xCrd], ...
        [Neg2(i).Left_yCrd; Neg2(i).Right_yCrd  ], 2, 150, 'Astral_MTs', Neg2(i).name);
end
Neg2_aster = Neg2_aster (2:end); 

Neg2_spinBody = [];
for i = 2:length(Neg2)
    Neg2_spinBody(i).name = Neg2(i).name;
    Neg2_spinBody(i).Mid_xCrd = Neg2(i).Mid_xCrd; 
    Neg2_spinBody(i).Mid_yCrd = Neg2(i).Mid_yCrd; 

    [Neg2_spinBody(i).Spin_vel_all, Neg2_spinBody(i).Spin_vel_means, Neg2_spinBody(i).Spin_dist_all,...
        Neg2_spinBody(i).Spin_dist_sum, Neg2_spinBody(i).Spin_angle_all, Neg2_spinBody(i).Spin_angle_flipped, Neg2_spinBody(i).Spin_life_times]...
        = cal_track_stats(Neg2(i).Mid_xCrd, Neg2(i).Mid_yCrd, 2, 150, 'Spindle_MTs', Neg2(i).name);
end
Neg_spinBody = Neg2_spinBody (2:end);

Kif18B_aster = [];
for i = 2:length(Kif18B)   % First 18B has 122 frames instead of 61. Cannot figure out wehre went wrong Throw out.
    Kif18B_aster(i).name = Kif18B(i).name;
    Kif18B_aster(i).Pole_left_xr = Kif18B(i).Pole_left_xr; 
    Kif18B_aster(i).Pole_left_yr = Kif18B(i).Pole_left_yr; 
    Kif18B_aster(i).Pole_right_xr = Kif18B(i).Pole_right_xr; 
    Kif18B_aster(i).Pole_right_yr = Kif18B(i).Pole_right_yr; 
    [Kif18B_aster(i).Aster_vel_all, Kif18B_aster(i).Aster_vel_means, Kif18B_aster(i).Aster_dist_all,...
        Kif18B_aster(i).Aster_dist_sum, Kif18B_aster(i).Aster_angle_all, Kif18B_aster(i).Aster_angle_flipped, Kif18B_aster(i).Aster_life_times]...
        = cal_track_stats([Kif18B(i).Left_xCrd; Kif18B(i).Right_xCrd], ...
        [Kif18B(i).Left_yCrd; Kif18B(i).Right_yCrd  ], 2, 150, 'Astral_MTs', Kif18B(i).name);
end
Kif18B_aster = Kif18B_aster (2:end); 

Kif18B_spinBody = []; 
for i = 2:length(Kif18B)
    Kif18B_spinBody(i).name = Kif18B(i).name;
    Kif18B_spinBody(i).Mid_xCrd = Kif18B(i).Mid_xCrd; 
    Kif18B_spinBody(i).Mid_yCrd = Kif18B(i).Mid_yCrd; 

    [Kif18B_spinBody(i).Spin_vel_all, Kif18B_spinBody(i).Spin_vel_means, Kif18B_spinBody(i).Spin_dist_all,...
        Kif18B_spinBody(i).Spin_dist_sum, Kif18B_spinBody(i).Spin_angle_all, Kif18B_spinBody(i).Spin_angle_flipped, Kif18B_spinBody(i).Spin_life_times]...
         = cal_track_stats(Kif18B(i).Mid_xCrd, Kif18B(i).Mid_yCrd, 2, 150, 'Spindle_MTs', Kif18B(i).name);
end
Kif18B_spinBody = Kif18B_spinBody (2:end);

save('Neg2_aster', 'Neg2_aster'); save('Neg2_spinBody', 'Neg2_spinBody'); 
save('Kif18B_aster', 'Kif18B_aster'); save('Kif18B_spinBody', 'Kif18B_spinBody'); 

%% Pool all the lifetimes data together. 
Neg2_aster.lt_total = [];
Neg2_spinBody.lt_total = [];
Kif18B_aster.lt_total = [];
Kif18B_spinBody.lt_total = [];

for i = 1:length(Neg2_aster)
    Neg2_aster.lt_total = [ Neg2_aster.lt_total; Neg2_aster(i).Aster_life_times ]; 
end 
for i = 1:length(Neg2_spinBody)
     Neg2_spinBody.lt_total = [ Neg2_spinBody.lt_total; Neg2_spinBody(i).Spin_life_times ];
end 
for i = 1:length(Kif18B_aster)
Kif18B_aster.lt_total = [ Kif18B_aster.lt_total; Kif18B_aster(i).Aster_life_times ];
end 
for i = 1:length(Kif18B_spinBody)
    Kif18B.lt_total = [ Kif18B.lt_total; TracksInfo(i).life_times ];
end 
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
