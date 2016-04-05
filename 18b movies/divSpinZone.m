% Description:

% This script separate the tracks in a spindle into 5 zones.
% Zone 1 is the region of left spindle boundary to left pole.
% Zone 2 is the region of left pole to right pole.
% Zone 3 is the region of right pole to right spindle boundary.
% Zone 2 is further divided into upper, middle and bottom zones by manual
% input of upper and bottom position of spindle width.
% Zone 2_1 is the upper regin of zone 2.
% Zone 2_2 is the middle regin of zone 2.
% Zone 2_3 is the bottom regin of zone 2.

% HZ 2016-4-3 Bloomington

%% Initiate
clc; clear;
load Neg2.mat; load Kif18B.mat;

%% Input upper and bottom position of spindle width.
% Neg2: Input the width of spindle
for n = 1: length (Neg2)
    imshow(Neg2(n).img_rot, []); hold on;
    title (Neg2(n).name);
    fprintf ('Click on the top spindle boundary \n');
    Neg2(n).width_top = ginput(1);  % what i need later is y, the second number
    plot( Neg2(n).width_top(1), Neg2(n).width_top(2), '+r', 'markersize', 15); hold on;
    
    fprintf ('Click on the top spindle boundary \n');
    Neg2(n).width_bottom = ginput(1);
    plot( Neg2(n).width_bottom(1), Neg2(n).width_bottom(2), '+g', 'markersize', 15);
end
close; 
%% Calculate spindle length, width, and theta
for n = 1: length (Neg2)
    Neg2(n).spindle_length = pdist([Neg2(n).Pole_left_r(1), Neg2(n).Pole_left_r(2); ...
        Neg2(n).Pole_right_r(1), Neg2(n).Pole_right_r(2)]);
    Neg2(n).spindle_width = pdist([Neg2(n).width_top(1), Neg2(n).width_top(2); ...
        Neg2(n).width_bottom(1), Neg2(n).width_bottom(2)]);
    Neg2(n).theta = atan2( 0.5 * Neg2(n).spindle_width, 0.5 * Neg2(n).spindle_length ) * 180 / pi;
end
Neg2_mean_theta = mean ([Neg2.theta]);

%% Kif18B: Input the width of spindle
for n = 1: length (Kif18B)
    imshow(Kif18B(n).img_rot, []); hold on;
    title (Kif18B(n).name);
    fprintf ('Click on the top spindle boundary \n');
    Kif18B(n).width_top = ginput(1);  % what i need later is y, the second number
    plot( Kif18B(n).width_top(1), Kif18B(n).width_top(2), '+r', 'markersize', 15); hold on;
    
    fprintf ('Click on the top spindle boundary \n');
    Kif18B(n).width_bottom = ginput(1);
    plot( Kif18B(n).width_bottom(1), Kif18B(n).width_bottom(2), '+g', 'markersize', 15);
end
close; 
%% Calculate spindle length, width, and theta
for n = 1: length (Kif18B)
    Kif18B(n).spindle_length = pdist([Kif18B(n).Pole_left_r(1), Kif18B(n).Pole_left_r(2); ...
        Kif18B(n).Pole_right_r(1), Kif18B(n).Pole_right_r(2)]);
    Kif18B(n).spindle_width = pdist([Kif18B(n).width_top(1), Kif18B(n).width_top(2); ...
        Kif18B(n).width_bottom(1), Kif18B(n).width_bottom(2)]);
    Kif18B(n).theta = atan2( 0.5 * Kif18B(n).spindle_width, 0.5 * Kif18B(n).spindle_length ) * 180 / pi;
end
Kif18B_mean_theta = mean ([Kif18B.theta]);

%% Pool tracks in different spindle regions based on the first comet in each track.
% for Neg2
for n = 1:length( Neg2 )
    Neg2(n).Left_xCrd= [];   Neg2(n).Left_yCrd = [];  % Zone1
    Neg2(n).Right_xCrd = []; Neg2(n).Right_yCrd = []; % Zone3
    Neg2(n).Mid_xCrd = [];   Neg2(n).Mid_yCrd = [];   % Zone2
    Neg2(n).Mid_up_xCrd = [];   Neg2(n).Mid_up_yCrd = [];  % Zone2_1
    Neg2(n).Mid_mid_xCrd = [];   Neg2(n).Mid_mid_yCrd = [];  % Zone2_1
    Neg2(n).Mid_btm_xCrd = [];   Neg2(n).Mid_btm_yCrd = [];  % Zone2_3
     
    n_tracks = length(Neg2(n).xCoord_r);
    
    % count tracks between/out up and bottom left and right lines.
    tracks_left = 0;   tracks_middle = 0;  tracks_right = 0;
    tracks_btn_ub = 0; tracks_out_lr = 0;  tracks_out_ub = 0;
    tracks_middle_up = 0; tracks_middle_mid = 0; tracks_middle_btm = 0; 
    
    for i = 1:n_tracks
        % decide if tracks are within the up_bottom boundary
        if any( Neg2(n).yCoord_r(i, ~isnan(Neg2(n).yCoord_r(i,:))) > Neg2(n).box_perm.top ) && ...
                any( Neg2(n).yCoord_r(i, ~isnan(Neg2(n).yCoord_r(i,:))) < Neg2(n).box_perm.bottom )
            tracks_btn_ub = tracks_btn_ub +1;
            % decide if tracks fall into zone 1 (left boundary to left pole)
            if any( Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) >= Neg2(n).box_perm.left(1) ) && ...
                    all( Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) <= Neg2(n).Pole_left_r(1) )
                Neg2(n).Left_xCrd(size(Neg2(n).Left_xCrd,1)+1,:) = Neg2(n).xCoord_r(i,:);
                Neg2(n).Left_yCrd(size(Neg2(n).Left_yCrd,1)+1,:) = Neg2(n).yCoord_r(i,:);
                tracks_left = tracks_left +1;
                % decide if tracks fall into zone 2 (left pole to right pole)
            elseif any( Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) > Neg2(n).Pole_left_r(1) ) && ...
                    all( Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) <= Neg2(n).Pole_right_r(1) )
                Neg2(n).Mid_xCrd(size(Neg2(n).Mid_xCrd,1)+1,:) = Neg2(n).xCoord_r(i,:);
                Neg2(n).Mid_yCrd(size(Neg2(n).Mid_yCrd,1)+1,:) = Neg2(n).yCoord_r(i,:);
                tracks_middle = tracks_middle +1;
                % If tracks falls into zone 2, decide if they are in zone 2_1
                if any( Neg2(n).yCoord_r(i, ~isnan(Neg2(n).yCoord_r(i,:))) >= Neg2(n).box_perm.top ) && ...
                        all( Neg2(n).yCoord_r(i, ~isnan(Neg2(n).yCoord_r(i,:))) < Neg2(n).width_top(2) )
                    Neg2(n).Mid_up_xCrd(size(Neg2(n).Mid_up_xCrd,1)+1,:) = Neg2(n).xCoord_r(i,:);
                    Neg2(n).Mid_up_yCrd(size(Neg2(n).Mid_up_yCrd,1)+1,:) = Neg2(n).yCoord_r(i,:);
                    tracks_middle_up = tracks_middle_up +1;
                    % If tracks falls into zone 2, decide if they are in zone 2_2
                elseif any( Neg2(n).yCoord_r(i, ~isnan(Neg2(n).yCoord_r(i,:))) >= Neg2(n).width_top(2) ) && ...
                        all( Neg2(n).yCoord_r(i, ~isnan(Neg2(n).yCoord_r(i,:))) < Neg2(n).width_bottom(2) )
                    Neg2(n).Mid_mid_xCrd(size(Neg2(n).Mid_mid_xCrd,1)+1,:) = Neg2(n).xCoord_r(i,:);
                    Neg2(n).Mid_mid_yCrd(size(Neg2(n).Mid_mid_yCrd,1)+1,:) = Neg2(n).yCoord_r(i,:);
                    tracks_middle_mid = tracks_middle_mid +1;
                    % If tracks falls into zone 2, decide if they are in zone2_3
                elseif any( Neg2(n).yCoord_r(i, ~isnan(Neg2(n).yCoord_r(i,:))) >= Neg2(n).width_bottom(2) ) && ...
                        any( Neg2(n).yCoord_r(i, ~isnan(Neg2(n).yCoord_r(i,:))) <= Neg2(n).box_perm.bottom  )
                    Neg2(n).Mid_btm_xCrd(size(Neg2(n).Mid_btm_xCrd,1)+1,:) = Neg2(n).xCoord_r(i,:);
                    Neg2(n).Mid_btm_yCrd(size(Neg2(n).Mid_btm_yCrd,1)+1,:) = Neg2(n).yCoord_r(i,:);
                    tracks_middle_btm = tracks_middle_btm +1;
                end
                % decide if tracks fall into zone 3 (right pole to right boundary)
            elseif any( Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) > Neg2(n).Pole_right_r(1) ) && ...
                    all( Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) <= Neg2(n).box_perm.right(1) )
                Neg2(n).Right_xCrd(size(Neg2(n).Right_xCrd,1)+1,:) = Neg2(n).xCoord_r(i,:);
                Neg2(n).Right_yCrd(size(Neg2(n).Right_yCrd,1)+1,:) = Neg2(n).yCoord_r(i,:);
                tracks_right = tracks_right +1;
                % count tracks that falls outside of the perm boundary
            elseif all( Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) < Neg2(n).box_perm.left(1) ) || ...
                    all( Neg2(n).xCoord_r(i, ~isnan(Neg2(n).xCoord_r(i,:))) > Neg2(n).box_perm.right(1) )
                tracks_out_lr = tracks_out_lr + 1;
            end
        else tracks_out_ub = tracks_out_ub + 1;
        end
    end
end
% For Neg2, I double checked the number of tracks in each zones to make sure that all tracks falls into specified regions.


%% for Kif18B
for n = 1:length( Kif18B )
    Kif18B(n).Left_xCrd= [];   Kif18B(n).Left_yCrd = [];  % Zone1
    Kif18B(n).Right_xCrd = []; Kif18B(n).Right_yCrd = []; % Zone3
    Kif18B(n).Mid_xCrd = [];   Kif18B(n).Mid_yCrd = [];   % Zone2
    Kif18B(n).Mid_up_xCrd = [];   Kif18B(n).Mid_up_yCrd = [];  % Zone2_1
    Kif18B(n).Mid_mid_xCrd = [];   Kif18B(n).Mid_mid_yCrd = [];  % Zone2_1
    Kif18B(n).Mid_btm_xCrd = [];   Kif18B(n).Mid_btm_yCrd = [];  % Zone2_3
    Kif18B(n).Mid_mid_half_xCrd = [];   Kif18B(n).Mid_mid_half_yCrd = []; 
 
    n_tracks = length(Kif18B(n).xCoord_r);
    
    % count tracks between/out up and bottom left and right lines.
    tracks_left = 0;   tracks_middle = 0;  tracks_right = 0;
    tracks_btn_ub = 0; tracks_out_lr = 0;  tracks_out_ub = 0;
    tracks_middle_up = 0; tracks_middle_mid = 0; tracks_middle_btm = 0; 
    
    for i = 1:n_tracks
        % decide if tracks are within the up_bottom boundary
        if any( Kif18B(n).yCoord_r(i, ~isnan(Kif18B(n).yCoord_r(i,:))) > Kif18B(n).box_perm.top ) && ...
                any( Kif18B(n).yCoord_r(i, ~isnan(Kif18B(n).yCoord_r(i,:))) < Kif18B(n).box_perm.bottom )
            tracks_btn_ub = tracks_btn_ub +1;
            % decide if tracks fall into zone 1 (left boundary to left pole)
            if any( Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) >= Kif18B(n).box_perm.left(1) ) && ...
                    all( Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) <= Kif18B(n).Pole_left_r(1) )
                Kif18B(n).Left_xCrd(size(Kif18B(n).Left_xCrd,1)+1,:) = Kif18B(n).xCoord_r(i,:);
                Kif18B(n).Left_yCrd(size(Kif18B(n).Left_yCrd,1)+1,:) = Kif18B(n).yCoord_r(i,:);
                tracks_left = tracks_left +1;
                % decide if tracks fall into zone 2 (left pole to right pole)
            elseif any( Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) > Kif18B(n).Pole_left_r(1) ) && ...
                    all( Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) <= Kif18B(n).Pole_right_r(1) )
                Kif18B(n).Mid_xCrd(size(Kif18B(n).Mid_xCrd,1)+1,:) = Kif18B(n).xCoord_r(i,:);
                Kif18B(n).Mid_yCrd(size(Kif18B(n).Mid_yCrd,1)+1,:) = Kif18B(n).yCoord_r(i,:);
                tracks_middle = tracks_middle +1;
                % If tracks fall into zone 2, decide if they are in zone 2_1
                if any( Kif18B(n).yCoord_r(i, ~isnan(Kif18B(n).yCoord_r(i,:))) >= Kif18B(n).box_perm.top ) && ...
                        all( Kif18B(n).yCoord_r(i, ~isnan(Kif18B(n).yCoord_r(i,:))) < Kif18B(n).width_top(2) )
                    Kif18B(n).Mid_up_xCrd(size(Kif18B(n).Mid_up_xCrd,1)+1,:) = Kif18B(n).xCoord_r(i,:);
                    Kif18B(n).Mid_up_yCrd(size(Kif18B(n).Mid_up_yCrd,1)+1,:) = Kif18B(n).yCoord_r(i,:);
                    tracks_middle_up = tracks_middle_up +1;
                    % If tracks fall into zone 2, decide if they are in zone 2_2
                elseif any( Kif18B(n).yCoord_r(i, ~isnan(Kif18B(n).yCoord_r(i,:))) >= Kif18B(n).width_top(2) ) && ...
                        all( Kif18B(n).yCoord_r(i, ~isnan(Kif18B(n).yCoord_r(i,:))) < Kif18B(n).width_bottom(2) )
                    Kif18B(n).Mid_mid_xCrd(size(Kif18B(n).Mid_mid_xCrd,1)+1,:) = Kif18B(n).xCoord_r(i,:);
                    Kif18B(n).Mid_mid_yCrd(size(Kif18B(n).Mid_mid_yCrd,1)+1,:) = Kif18B(n).yCoord_r(i,:);
                    tracks_middle_mid = tracks_middle_mid +1;
                    % If tracks falls into zone 2, decide if they are in zone2_3
                elseif any( Kif18B(n).yCoord_r(i, ~isnan(Kif18B(n).yCoord_r(i,:))) >= Kif18B(n).width_bottom(2) ) && ...
                        any( Kif18B(n).yCoord_r(i, ~isnan(Kif18B(n).yCoord_r(i,:))) <= Kif18B(n).box_perm.bottom  )
                    Kif18B(n).Mid_btm_xCrd(size(Kif18B(n).Mid_btm_xCrd,1)+1,:) = Kif18B(n).xCoord_r(i,:);
                    Kif18B(n).Mid_btm_yCrd(size(Kif18B(n).Mid_btm_yCrd,1)+1,:) = Kif18B(n).yCoord_r(i,:);
                    tracks_middle_btm = tracks_middle_btm +1;
                end
                % decide if tracks fall into zone 3 (right pole to right boundary)
            elseif any( Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) > Kif18B(n).Pole_right_r(1) ) && ...
                    all( Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) <= Kif18B(n).box_perm.right(1) )
                Kif18B(n).Right_xCrd(size(Kif18B(n).Right_xCrd,1)+1,:) = Kif18B(n).xCoord_r(i,:);
                Kif18B(n).Right_yCrd(size(Kif18B(n).Right_yCrd,1)+1,:) = Kif18B(n).yCoord_r(i,:);
                tracks_right = tracks_right +1;
                % count tracks that falls outside of the perm boundary
            elseif all( Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) < Kif18B(n).box_perm.left(1) ) || ...
                    all( Kif18B(n).xCoord_r(i, ~isnan(Kif18B(n).xCoord_r(i,:))) > Kif18B(n).box_perm.right(1) )
                tracks_out_lr = tracks_out_lr + 1;
            end
        else tracks_out_ub = tracks_out_ub + 1;
        end
    end
end
% For Kif18B, I double checked the number of tracks in each zones to make sure that all tracks falls into specified regions.

%% Save original data 
save ( 'Neg2.mat', 'Neg2', 'Neg2_mean_theta' );
save ( 'Kif18B.mat', 'Kif18B', 'Kif18B_mean_theta' );

