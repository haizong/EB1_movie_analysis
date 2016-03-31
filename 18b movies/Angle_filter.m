% Kif18B RNAi has a lot of MTs that are in the spindle body (in between the two poles) ,
% but they are actually astral MTs directing out toward the cell cortex because their angle
% is bigger when compared to angles of spindle MTs who are directed toward the metaphase plate.
% I've caldulated the angles of each track by getting the angle of the vector from the first
% position of the commet and the mean position of the comet.
% Claire suggested to find the range of 90% of angles in the Neg2 and use that to cut off
% the ones in the Kif18B RNAi that are bigger than that range.

% To run the script, go to directory: /Users/hailingzong/Documents/MATLAB/18b
% HZ 2016-3-31

%% Frequency distribution of Neg2 angles in spindle body region
clear; clc;
load Neg2_spinBody.mat;  load Kif18B_spinBody.mat;

Neg2_angle.Spin_angle_flipped = [];
Neg2_angle.lifetime_total = [];
for i = 1:length(Neg2_spinBody)
    Neg2_angle.Spin_angle_flipped = [ Neg2_angle.Spin_angle_flipped; Neg2_spinBody(i).Spin_angle_flipped ];
    Neg2_angle.lifetime_total = [Neg2_angle.lifetime_total; Neg2_spinBody(i).Spin_life_times];
end

Kif18B_angle.Spin_angle_flipped = [];
Kif18B_angle.lifetime_total = [];
for i = 1:length(Kif18B_spinBody)
    Kif18B_angle.Spin_angle_flipped = [ Kif18B_angle.Spin_angle_flipped; Kif18B_spinBody(i).Spin_angle_flipped ];
    Kif18B_angle.lifetime_total = [Kif18B_angle.lifetime_total; Kif18B_spinBody(i).Spin_life_times];
end

[Neg2_angle.bin_count, Neg2_angle.relativefreq] = ...
    histnorm(Neg2_angle.Spin_angle_flipped, 20, 'Track angle in spindle body of Neg2', 'Angle of Tracks');

[Kif18B_angle.bin_count, Kif18B_angle.relativefreq] = ...
    histnorm(Kif18B_angle.Spin_angle_flipped, 20, 'Track angle in spindle body of Kif18B', 'Angle of Tracks');

%% Take absolute value and plot histogram.
Neg2_angle.Abs_Spin_angle_flipped = abs( Neg2_angle.Spin_angle_flipped );
Kif18B_angle.Abs_Spin_angle_flipped = abs( Kif18B_angle.Spin_angle_flipped );

[Neg2_angle.Abs_bin_count, Neg2_angle.Abs_relativefreq] = ...
    histnorm(Neg2_angle.Abs_Spin_angle_flipped, 20, 'Track angle in spindle body of Neg2', 'Angle of Tracks (Abs)');

[Kif18B_angle.Abs_bin_count, Kif18B_angle.Abs_relativefreq] = ...
    histnorm(Kif18B_angle.Abs_Spin_angle_flipped, 20, 'Track angle in spindle body of Kif18B', 'Angle of Tracks (Abs)');

%%  Calculate the angle by tan (half width/half length)
% Jane's paper "we partitioned the EB1 comets ... We then calculated the angle between the pole axis
% and one-half of the spindle width, and used this value to partition the EB1 comets as being either
% outside or inside the control spindle dimensions.".

load Neg2.mat; load Kif18B.mat

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

for n = 1: length (Neg2)
    Neg2(n).spindle_length = pdist([Neg2(n).Pole_left_x, Neg2(n).Pole_left_y; ...
        Neg2(n).Pole_right_x, Neg2(n).Pole_right_y]);
    Neg2(n).spindle_width = pdist([Neg2(n).width_top(1), Neg2(n).width_top(2); ...
        Neg2(n).width_bottom(1), Neg2(n).width_bottom(2)]);
    Neg2(n).theta = atan2( 0.5 * Neg2(n).spindle_width, 0.5 * Neg2(n).spindle_length ) * 180 / pi;
end
Neg2_mean_theta = mean ([Neg2.theta]);

% %% Kif18B: Input the width of spindle
% for n = 1: length (Kif18B)
%     imshow(Kif18B(n).img_rot, []); hold on;
%     title (Kif18B(n).name);
%     fprintf ('Click on the top spindle boundary \n');
%     Kif18B(n).width_top = ginput(1);  % what i need later is y, the second number
%     plot( Kif18B(n).width_top(1), Kif18B(n).width_top(2), '+r', 'markersize', 15); hold on;
%
%     fprintf ('Click on the top spindle boundary \n');
%     Kif18B(n).width_bottom = ginput(1);
%     plot( Kif18B(n).width_bottom(1), Kif18B(n).width_bottom(2), '+g', 'markersize', 15);
% end
%
% for n = 1: length (Kif18B)
% Kif18B(n).spindle_length = pdist([Kif18B(n).Pole_left_x, Kif18B(n).Pole_left_y; ...
%             Kif18B(n).Pole_right_x, Kif18B(n).Pole_right_y]);
% Kif18B(n).spindle_width = pdist([Kif18B(n).width_top(1), Kif18B(n).width_top(2); ...
%             Kif18B(n).width_bottom(1), Kif18B(n).width_bottom(2)]);
% Kif18B(n).theta = atan2( 0.5 * Kif18B(n).spindle_width, 0.5 * Kif18B(n).spindle_length ) * 180 / pi;
% end
% Kif18B_mean_theta = mean ([Kif18B.theta]);

%% Use 44 as threshold.  Find anlges that are smaller than 44 in Neg2_anlge and Kif18B_anlge.
% Save corresponding lifetimes. Curvefit and compare.
Neg2_angle.thr44_Index = find ( abs( Neg2_angle.Spin_angle_flipped ) < 44 );
Neg2_angle.Spin_anlge_thr44 = [];
Neg2_angle.Lifetime_thr44 = [];
for i = 1: length(Neg2_angle.thr44_Index)
    Neg2_angle.Spin_anlge_thr44 = [Neg2_angle.Spin_anlge_thr44; Neg2_angle.Spin_angle_flipped( Neg2_angle.thr44_Index(i))];
    Neg2_angle.Lifetime_thr44 = ...
        [Neg2_angle.Lifetime_thr44; Neg2_angle.lifetime_total( Neg2_angle.thr44_Index(i))];
end

Kif18B_angle.thr44_Index = find ( abs( Kif18B_angle.Spin_angle_flipped ) < 44 );
Kif18B_angle.Spin_anlge_thr44 = [];
Kif18B_angle.Lifetime_thr44 = [];
for i = 1: length(Kif18B_angle.thr44_Index)
    Kif18B_angle.Spin_anlge_thr44 = [Kif18B_angle.Spin_anlge_thr44; Kif18B_angle.Spin_angle_flipped( Kif18B_angle.thr44_Index(i))];
    Kif18B_angle.Lifetime_thr44 = ...
        [Kif18B_angle.Lifetime_thr44; Kif18B_angle.lifetime_total( Kif18B_angle.thr44_Index(i))];
end

%% Frequency distribution and Exponential fit of lifetimes data
% For Neg2 spindle body region
tbl_temp= tabulate( Neg2_angle.Lifetime_thr44);
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Neg2_angle.lt_bin_thr44 = tbl(:,1);
Neg2_angle.lt_freq_dist_thr44 = tbl(:,3);
[Neg2_angle.lt_fitresult_thr44, Neg2_angle.lt_gof_thr44] = createExpFit( Neg2_angle.lt_bin_thr44, Neg2_angle.lt_freq_dist_thr44, 'Neg2 spindle body' );

% For 18B spindleBody region
tbl_temp= tabulate( Kif18B_angle.Lifetime_thr44);
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Kif18B_angle.lt_bin_thr44 = tbl(:,1);
Kif18B_angle.lt_freq_dist_thr44 = tbl(:,3);
[Kif18B_angle.lt_fitresult_thr44, Kif18B_angle.lt_gof_thr44] = createExpFit( Kif18B_angle.lt_bin_thr44, Kif18B_angle.lt_freq_dist_thr44, 'Kif18B spindle body' );

Neg2_angle_thr44 = Neg2_angle; 
Kif18B_angle_thr44 = Kif18B_angle; 
save ('Neg2_angle_thr44', 'Neg2_angle_thr44'); 
save ('Kif18B_angle_thr44', 'Kif18B_angle_thr44'); 

%% %% Use 26 as threshold.  Find anlges that are smaller than 26 in Neg2_anlge and Kif18B_anlge.
% Save corresponding lifetimes. Curvefit and compare.
Neg2_angle.thr26_Index = find ( abs( Neg2_angle.Spin_angle_flipped ) < 26 );
Neg2_angle.Spin_anlge_thr26 = [];
Neg2_angle.Lifetime_thr26 = [];
for i = 1: length(Neg2_angle.thr26_Index)
    Neg2_angle.Spin_anlge_thr26 = [Neg2_angle.Spin_anlge_thr26; Neg2_angle.Spin_angle_flipped( Neg2_angle.thr26_Index(i))];
    Neg2_angle.Lifetime_thr26 = ...
        [Neg2_angle.Lifetime_thr26; Neg2_angle.lifetime_total( Neg2_angle.thr26_Index(i))];
end

Kif18B_angle.thr26_Index = find ( abs( Kif18B_angle.Spin_angle_flipped ) < 26 );
Kif18B_angle.Spin_anlge_thr26 = [];
Kif18B_angle.Lifetime_thr26 = [];
for i = 1: length(Kif18B_angle.thr26_Index)
    Kif18B_angle.Spin_anlge_thr26 = [Kif18B_angle.Spin_anlge_thr26; Kif18B_angle.Spin_angle_flipped( Kif18B_angle.thr26_Index(i))];
    Kif18B_angle.Lifetime_thr26 = ...
        [Kif18B_angle.Lifetime_thr26; Kif18B_angle.lifetime_total( Kif18B_angle.thr26_Index(i))];
end

%% Frequency distribution and Exponential fit of lifetimes data
% For Neg2 spindle body region
tbl_temp= tabulate( Neg2_angle.Lifetime_thr26);
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Neg2_angle.lt_bin_thr26 = tbl(:,1);
Neg2_angle.lt_freq_dist_thr26 = tbl(:,3);
[Neg2_angle.lt_fitresult_thr26, Neg2_angle.lt_gof_thr26] = createExpFit( Neg2_angle.lt_bin_thr26, Neg2_angle.lt_freq_dist_thr26, 'Neg2 spindle body' );

% For 18B spindleBody region
tbl_temp= tabulate( Kif18B_angle.Lifetime_thr26);
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Kif18B_angle.lt_bin_thr26 = tbl(:,1);
Kif18B_angle.lt_freq_dist_thr26 = tbl(:,3);
[Kif18B_angle.lt_fitresult_thr26, Kif18B_angle.lt_gof_thr26] = createExpFit( Kif18B_angle.lt_bin_thr26, Kif18B_angle.lt_freq_dist_thr26, 'Kif18B spindle body' );

Neg2_angle_thr26 = Neg2_angle; 
Kif18B_angle_thr26 = Kif18B_angle; 
save ('Neg2_angle_thr26', 'Neg2_angle_thr26'); 
save ('Kif18B_angle_thr26', 'Kif18B_angle_thr26'); 

%% %% Use 26 as threshold.  Find anlges that are bigger than 26 in Neg2_anlge and Kif18B_anlge.
% Save corresponding lifetimes. Curvefit and compare.
Neg2_angle.thr26_90_Index = find ( abs( Neg2_angle.Spin_angle_flipped ) >= 26 );
Neg2_angle.Spin_anlge_thr26_90 = [];
Neg2_angle.Lifetime_thr26_90 = [];
for i = 1: length(Neg2_angle.thr26_90_Index)
    Neg2_angle.Spin_anlge_thr26_90 = [Neg2_angle.Spin_anlge_thr26_90; Neg2_angle.Spin_angle_flipped( Neg2_angle.thr26_90_Index(i))];
    Neg2_angle.Lifetime_thr26_90 = ...
        [Neg2_angle.Lifetime_thr26_90; Neg2_angle.lifetime_total( Neg2_angle.thr26_90_Index(i))];
end

Kif18B_angle.thr26_90_Index = find ( abs( Kif18B_angle.Spin_angle_flipped ) >= 26 );
Kif18B_angle.Spin_anlge_thr26_90 = [];
Kif18B_angle.Lifetime_thr26_90 = [];
for i = 1: length(Kif18B_angle.thr26_90_Index)
    Kif18B_angle.Spin_anlge_thr26_90 = [Kif18B_angle.Spin_anlge_thr26_90; Kif18B_angle.Spin_angle_flipped( Kif18B_angle.thr26_90_Index(i))];
    Kif18B_angle.Lifetime_thr26_90 = ...
        [Kif18B_angle.Lifetime_thr26_90; Kif18B_angle.lifetime_total( Kif18B_angle.thr26_90_Index(i))];
end

%% Frequency distribution and Exponential fit of lifetimes data
% For Neg2 spindle body region
tbl_temp= tabulate( Neg2_angle.Lifetime_thr26_90);
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Neg2_angle.lt_bin_thr26_90 = tbl(:,1);
Neg2_angle.lt_freq_dist_thr26_90 = tbl(:,3);
[Neg2_angle.lt_fitresult_thr26_90, Neg2_angle.lt_gof_thr26_90] = createExpFit( Neg2_angle.lt_bin_thr26_90, Neg2_angle.lt_freq_dist_thr26_90, 'Neg2 spindle body' );

% For 18B spindleBody region
tbl_temp= tabulate( Kif18B_angle.Lifetime_thr26_90);
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Kif18B_angle.lt_bin_thr26_90 = tbl(:,1);
Kif18B_angle.lt_freq_dist_thr26_90 = tbl(:,3);
[Kif18B_angle.lt_fitresult_thr26_90, Kif18B_angle.lt_gof_thr26_90] = createExpFit( Kif18B_angle.lt_bin_thr26_90, Kif18B_angle.lt_freq_dist_thr26_90, 'Kif18B spindle body' );

Neg2_angle_thr26_90 = Neg2_angle; 
Kif18B_angle_thr26_90 = Kif18B_angle; 
save ('Neg2_angle_thr26_90', 'Neg2_angle_thr26_90'); 
save ('Kif18B_angle_thr26_90', 'Kif18B_angle_thr26_90'); 

%% Use 44_90 as threshold.  Find anlges that are bigger than 44_90 in Neg2_anlge and Kif18B_anlge.
% Save corresponding lifetimes. Curvefit and compare.
Neg2_angle.thr44_90_Index = find ( abs( Neg2_angle.Spin_angle_flipped ) >= 44 );
Neg2_angle.Spin_anlge_thr44_90 = [];
Neg2_angle.Lifetime_thr44_90 = [];

for i = 1: length(Neg2_angle.thr44_90_Index)
    Neg2_angle.Spin_anlge_thr44_90 = [Neg2_angle.Spin_anlge_thr44_90; Neg2_angle.Spin_angle_flipped( Neg2_angle.thr44_90_Index(i))];
    Neg2_angle.Lifetime_thr44_90 = ...
        [Neg2_angle.Lifetime_thr44_90; Neg2_angle.lifetime_total( Neg2_angle.thr44_90_Index(i))];
end

Kif18B_angle.thr44_90_Index = find ( abs( Kif18B_angle.Spin_angle_flipped ) >= 44 );
Kif18B_angle.Spin_anlge_thr44_90 = [];
Kif18B_angle.Lifetime_thr44_90 = [];
for i = 1: length(Kif18B_angle.thr44_90_Index)
    Kif18B_angle.Spin_anlge_thr44_90 = [Kif18B_angle.Spin_anlge_thr44_90; Kif18B_angle.Spin_angle_flipped( Kif18B_angle.thr44_90_Index(i))];
    Kif18B_angle.Lifetime_thr44_90 = ...
        [Kif18B_angle.Lifetime_thr44_90; Kif18B_angle.lifetime_total( Kif18B_angle.thr44_90_Index(i))];
end

%% Frequency distribution and Exponential fit of lifetimes data
% For Neg2 spindle body region
tbl_temp= tabulate( Neg2_angle.Lifetime_thr44_90);
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Neg2_angle.lt_bin_thr44_90 = tbl(:,1);
Neg2_angle.lt_freq_dist_thr44_90 = tbl(:,3);
[Neg2_angle.lt_fitresult_thr44_90, Neg2_angle.lt_gof_thr44_90] = createExpFit( Neg2_angle.lt_bin_thr44_90, Neg2_angle.lt_freq_dist_thr44_90, 'Neg2 spindle body' );

% For 18B spindleBody region
tbl_temp= tabulate( Kif18B_angle.Lifetime_thr44_90);
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Kif18B_angle.lt_bin_thr44_90 = tbl(:,1);
Kif18B_angle.lt_freq_dist_thr44_90 = tbl(:,3);
[Kif18B_angle.lt_fitresult_thr44_90, Kif18B_angle.lt_gof_thr44_90] = createExpFit( Kif18B_angle.lt_bin_thr44_90, Kif18B_angle.lt_freq_dist_thr44_90, 'Kif18B spindle body' );

Neg2_angle_thr44_90 = Neg2_angle; 
Kif18B_angle_thr44_90 = Kif18B_angle; 
save ('Neg2_angle_thr44_90', 'Neg2_angle_thr44_90'); 
save ('Kif18B_angle_thr44_90', 'Kif18B_angle_thr44_90'); 

%% Use 55_90 as threshold.  Find anlges that are bigger than 55_90 in Neg2_anlge and Kif18B_anlge.
% Save corresponding lifetimes. Curvefit and compare.
Neg2_angle.thr55_90_Index = find ( abs( Neg2_angle.Spin_angle_flipped ) >= 55 );
Neg2_angle.Spin_anlge_thr55_90 = [];
Neg2_angle.Lifetime_thr55_90 = [];

for i = 1: length(Neg2_angle.thr55_90_Index)
    Neg2_angle.Spin_anlge_thr55_90 = [Neg2_angle.Spin_anlge_thr55_90; Neg2_angle.Spin_angle_flipped( Neg2_angle.thr55_90_Index(i))];
    Neg2_angle.Lifetime_thr55_90 = ...
        [Neg2_angle.Lifetime_thr55_90; Neg2_angle.lifetime_total( Neg2_angle.thr55_90_Index(i))];
end

Kif18B_angle.thr55_90_Index = find ( abs( Kif18B_angle.Spin_angle_flipped ) >= 55 );
Kif18B_angle.Spin_anlge_thr55_90 = [];
Kif18B_angle.Lifetime_thr55_90 = [];
for i = 1: length(Kif18B_angle.thr55_90_Index)
    Kif18B_angle.Spin_anlge_thr55_90 = [Kif18B_angle.Spin_anlge_thr55_90; Kif18B_angle.Spin_angle_flipped( Kif18B_angle.thr55_90_Index(i))];
    Kif18B_angle.Lifetime_thr55_90 = ...
        [Kif18B_angle.Lifetime_thr55_90; Kif18B_angle.lifetime_total( Kif18B_angle.thr55_90_Index(i))];
end

%% Frequency distribution and Exponential fit of lifetimes data
% For Neg2 spindle body region
tbl_temp= tabulate( Neg2_angle.Lifetime_thr55_90);
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Neg2_angle.lt_bin_thr55_90 = tbl(:,1);
Neg2_angle.lt_freq_dist_thr55_90 = tbl(:,3);
[Neg2_angle.lt_fitresult_thr55_90, Neg2_angle.lt_gof_thr55_90] = createExpFit( Neg2_angle.lt_bin_thr55_90, Neg2_angle.lt_freq_dist_thr55_90, 'Neg2 spindle body' );

% For 18B spindleBody region
tbl_temp= tabulate( Kif18B_angle.Lifetime_thr55_90);
tbl = tbl_temp( 4:2:end, : );
clear tbl_temp;
Kif18B_angle.lt_bin_thr55_90 = tbl(:,1);
Kif18B_angle.lt_freq_dist_thr55_90 = tbl(:,3);
[Kif18B_angle.lt_fitresult_thr55_90, Kif18B_angle.lt_gof_thr55_90] = createExpFit( Kif18B_angle.lt_bin_thr55_90, Kif18B_angle.lt_freq_dist_thr55_90, 'Kif18B spindle body' );

Neg2_angle_thr55_90 = Neg2_angle; 
Kif18B_angle_thr55_90 = Kif18B_angle; 
save ('Neg2_angle_thr55_90', 'Neg2_angle_thr55_90'); 
save ('Kif18B_angle_thr55_90', 'Kif18B_angle_thr55_90'); 