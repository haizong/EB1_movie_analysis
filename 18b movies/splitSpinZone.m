%% Description
% Resave coordinates based on position:
% Combine Zone 1 and 3 into Neg2_Aster & Kif18B_Aster.
% Combine Zone 2_1 and 2_3 into Neg2_Mid_aster & Kif18B_Mid_Asters.
% Zone 2_2 is Neg2_spindle & Kif18B_spindle.

% HZ 2016-4-4 Bloomington
%%  Cal stat for MTs in diff regions
%% Initiate
clc; clear;
load Neg2.mat; load Kif18B.mat;
perSpindle = 0.6;   % I started with 0.5, so files were named spindle_half historically.

%% For Neg2 spindle midzone
% In Neg2, if tracks fall into half spindle length, half spindle width region ->
% Save as spindle_half (a purer population of spindle MTs with less aster MTs)

tracks_middle_mid_half = 0;
tracks_middle_out = 0;
for n = 1:length ( Neg2 )
    Neg2(n).Mid_mid_half_xCrd = [];
    Neg2(n).Mid_mid_half_yCrd = [];
    Neg2(n).Mid_out_xCrd = [];
    Neg2(n).Mid_out_yCrd = [];
    
    n_tracks = length(Neg2(n).Mid_mid_xCrd);
    
    Neg2(n).mid_width = 0.5 * ( Neg2(n).width_top + Neg2(n).width_bottom );
    Neg2(n).mid_length = 0.5 * ( Neg2(n).Pole_left_r + Neg2(n).Pole_right_r);
    Neg2(n).p1 = Neg2(n).mid_width (2) - 0.5 * perSpindle * Neg2(n).spindle_width;   % 0.5 * perSpindle = 0.3
    Neg2(n).p2 = Neg2(n).mid_width (2) + 0.5 * perSpindle * Neg2(n).spindle_width;
    Neg2(n).p3 = Neg2(n).mid_length (1) - 0.5 * perSpindle * Neg2(n).spindle_length;
    Neg2(n).p4 = Neg2(n).mid_length (1) + 0.5 * perSpindle * Neg2(n).spindle_length;
    for i = 1: n_tracks;
        if all( Neg2(n).Mid_mid_yCrd(i, ~isnan(Neg2(n).Mid_mid_yCrd(i,:))) >= Neg2(n).p1 ) && ...
                all( Neg2(n).Mid_mid_yCrd(i, ~isnan(Neg2(n).Mid_mid_yCrd(i,:))) <= Neg2(n).p2) && ...
                all( Neg2(n).Mid_mid_xCrd(i, ~isnan(Neg2(n).Mid_mid_xCrd(i,:))) >= Neg2(n).p3 ) && ...
                all( Neg2(n).Mid_mid_xCrd(i, ~isnan(Neg2(n).Mid_mid_xCrd(i,:))) <= Neg2(n).p4 )
            Neg2(n).Mid_mid_half_xCrd(size(Neg2(n).Mid_mid_half_xCrd,1)+1,:) = Neg2(n).Mid_mid_xCrd(i,:);
            Neg2(n).Mid_mid_half_yCrd(size(Neg2(n).Mid_mid_half_yCrd,1)+1,:) = Neg2(n).Mid_mid_yCrd(i,:);
            tracks_middle_mid_half = tracks_middle_mid_half +1;
        else  Neg2(n).Mid_out_xCrd(size(Neg2(n).Mid_out_xCrd,1)+1,:) = Neg2(n).Mid_mid_xCrd(i,:);
            Neg2(n).Mid_out_yCrd(size(Neg2(n).Mid_out_yCrd,1)+1,:) = Neg2(n).Mid_mid_yCrd(i,:);
            tracks_middle_out = tracks_middle_out +1;
        end
    end
end

%% Save positional data for analysis
Neg2_aster_lr = [];
Neg2_aster_ub = [];
Neg2_spindle_mix = [];

for i = 1:length(Neg2)
    Neg2_aster_lr(i).name = Neg2(i).name;
    Neg2_aster_lr(i).xCrd = [ Neg2(i).Left_xCrd; Neg2(i).Right_xCrd ];
    Neg2_aster_lr(i).yCrd = [ Neg2(i).Left_yCrd; Neg2(i).Right_yCrd ];
    Neg2_aster_ub(i).name = Neg2(i).name;
    Neg2_aster_ub(i).xCrd = [ Neg2(i).Mid_up_xCrd; Neg2(i).Mid_btm_xCrd ];
    Neg2_aster_ub(i).yCrd = [ Neg2(i).Mid_up_yCrd; Neg2(i).Mid_btm_yCrd ];
    Neg2_spindle_mix(i).name = Neg2(i).name;
    Neg2_spindle_mix(i).xCrd = [ Neg2(i).Mid_mid_xCrd; Neg2(i).Mid_mid_xCrd ];
    Neg2_spindle_mix(i).yCrd = [ Neg2(i).Mid_mid_yCrd; Neg2(i).Mid_mid_yCrd ];
    Neg2_spindle_half(i).name = Neg2(i).name;
    Neg2_spindle_half(i).xCrd = [ Neg2(i).Mid_mid_half_xCrd; Neg2(i).Mid_mid_half_xCrd ];
    Neg2_spindle_half(i).yCrd = [ Neg2(i).Mid_mid_half_yCrd; Neg2(i).Mid_mid_half_yCrd ];
end
save ('Neg2_aster_lr', 'Neg2_aster_lr');
save ('Neg2_aster_ub', 'Neg2_aster_ub');
save ('Neg2_spindle_half', 'Neg2_spindle_half');

%% For Kif18B spindle midzone
% In Kif18B, if tracks fall into half spindle length, half spindle width region ->
% Save as spindle_half (a purer population of spindle MTs with less aster MTs)

tracks_middle_mid_half = 0;
tracks_middle_out = 0;
for n = 1:length ( Kif18B )
    Kif18B(n).Mid_mid_half_xCrd = [];
    Kif18B(n).Mid_mid_half_yCrd = [];
    Kif18B(n).Mid_out_xCrd = [];
    Kif18B(n).Mid_out_yCrd = [];
    
    n_tracks = length(Kif18B(n).Mid_mid_xCrd);
    
    Kif18B(n).mid_width = 0.5 * ( Kif18B(n).width_top + Kif18B(n).width_bottom );
    Kif18B(n).mid_length = 0.5 * ( Kif18B(n).Pole_left_r + Kif18B(n).Pole_right_r);
    Kif18B(n).p1 = Kif18B(n).mid_width (2) - 0.5 * perSpindle * Kif18B(n).spindle_width;   % 0.5 * perSpindle = 0.3
    Kif18B(n).p2 = Kif18B(n).mid_width (2) + 0.5 * perSpindle * Kif18B(n).spindle_width;
    Kif18B(n).p3 = Kif18B(n).mid_length (1) - 0.5 * perSpindle * Kif18B(n).spindle_length;
    Kif18B(n).p4 = Kif18B(n).mid_length (1) + 0.5 * perSpindle * Kif18B(n).spindle_length;
    for i = 1: n_tracks;
        if all( Kif18B(n).Mid_mid_yCrd(i, ~isnan(Kif18B(n).Mid_mid_yCrd(i,:))) >= Kif18B(n).p1 ) && ...
                all( Kif18B(n).Mid_mid_yCrd(i, ~isnan(Kif18B(n).Mid_mid_yCrd(i,:))) <= Kif18B(n).p2) && ...
                all( Kif18B(n).Mid_mid_xCrd(i, ~isnan(Kif18B(n).Mid_mid_xCrd(i,:))) >= Kif18B(n).p3 ) && ...
                all( Kif18B(n).Mid_mid_xCrd(i, ~isnan(Kif18B(n).Mid_mid_xCrd(i,:))) <= Kif18B(n).p4 )
            Kif18B(n).Mid_mid_half_xCrd(size(Kif18B(n).Mid_mid_half_xCrd,1)+1,:) = Kif18B(n).Mid_mid_xCrd(i,:);
            Kif18B(n).Mid_mid_half_yCrd(size(Kif18B(n).Mid_mid_half_yCrd,1)+1,:) = Kif18B(n).Mid_mid_yCrd(i,:);
            tracks_middle_mid_half = tracks_middle_mid_half +1;
        else  Kif18B(n).Mid_out_xCrd(size(Kif18B(n).Mid_out_xCrd,1)+1,:) = Kif18B(n).Mid_mid_xCrd(i,:);
            Kif18B(n).Mid_out_yCrd(size(Kif18B(n).Mid_out_yCrd,1)+1,:) = Kif18B(n).Mid_mid_yCrd(i,:);
            tracks_middle_out = tracks_middle_out +1;
        end
    end
end

save ('Neg2', 'Neg2');  save ('Kif18B', 'Kif18B'); 
%% Save positional data for analysis
Kif18B_aster_lr = [];
Kif18B_aster_ub = [];
Kif18B_spindle_mix = [];
for i = 1:length(Kif18B)
    Kif18B_aster_lr(i).name = Kif18B(i).name;
    Kif18B_aster_lr(i).xCrd = [ Kif18B(i).Left_xCrd; Kif18B(i).Right_xCrd ];
    Kif18B_aster_lr(i).yCrd = [ Kif18B(i).Left_yCrd; Kif18B(i).Right_yCrd ];
    Kif18B_aster_ub(i).name = Kif18B(i).name;
    Kif18B_aster_ub(i).xCrd = [ Kif18B(i).Mid_up_xCrd; Kif18B(i).Mid_btm_xCrd ];
    Kif18B_aster_ub(i).yCrd = [ Kif18B(i).Mid_up_yCrd; Kif18B(i).Mid_btm_yCrd ];
    Kif18B_spindle_mix(i).name = Kif18B(i).name;
    Kif18B_spindle_mix(i).xCrd = [ Kif18B(i).Mid_mid_xCrd; Kif18B(i).Mid_mid_xCrd ];
    Kif18B_spindle_mix(i).yCrd = [ Kif18B(i).Mid_mid_yCrd; Kif18B(i).Mid_mid_yCrd ];
    Kif18B_spindle_half(i).name = Kif18B(i).name;
    Kif18B_spindle_half(i).xCrd = [ Kif18B(i).Mid_mid_half_xCrd; Kif18B(i).Mid_mid_half_xCrd ];
    Kif18B_spindle_half(i).yCrd = [ Kif18B(i).Mid_mid_half_yCrd; Kif18B(i).Mid_mid_half_yCrd ];
end
save ('Kif18B_aster_lr', 'Kif18B_aster_lr');
save ('Kif18B_aster_ub', 'Kif18B_aster_ub');
save ('Kif18B_spindle_half', 'Kif18B_spindle_half');

