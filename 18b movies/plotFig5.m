% Descirption
% Script for Plot Fig5 EB1 analysis for Claire's Neg2 and Kif18B RNAi
% movies. Plot each panel separately.
% Choose representative image: '20150420-Neg2-003' -- Neg2(9) &
% '20150406-18B2-003' -- Kif18B(3)

% HZ 2016-4-4 Bloomington
%%
clc; clear; 
fontsize = 12; titlesize = 14; fontname = 'arial'; 
load 'Neg2.mat'; 
load Kif18B.mat;
%% 5A 
figure();
subNeg2 = Neg2(9).img_rot( 51:351, 113:512 );  % choose subregion with size 300 * 400
imshow( subNeg2, [4800 10000] ); hold on;   % images were scaled differently to see the tracks.  
plot ([323.33 390], [ 290 290 ], '-w', 'linewidth', 2);  
% plot error bar 10 um = 10, 000 nm = 10, 000/150 = 66.67 pixels
print_save_figure( gcf, 'Figure_5A_sb', 'EB1_figures' );
fprintf ('Making Fig 5A \n');

%% 5B
figure();
subKif18B = Kif18B(3).img_rot( 76:375, 46:445 ); 
imshow(subKif18B, [4800 5800]); hold on;  
print_save_figure( gcf, 'Figure_5B', 'EB1_figures' ); 
fprintf ('Making Fig 5B \n');

%% 5C
figure();
set(gcf, 'Color', 'black');
fprintf ('Plotting tracks of Neg2 spindle \n'); tic; 
% Aster_lr
xCrd = [ Neg2(9).Left_xCrd; Neg2(9).Right_xCrd ];
yCrd = [ Neg2(9).Left_yCrd; Neg2(9).Right_yCrd ]; 
color = 'm'; 
hold on; 
for i = 1:size(xCrd,1);
    a = xCrd(i, ~isnan(xCrd(i,:)));
    b = yCrd(i, ~isnan(yCrd(i,:)));
    for j = 1:length(a)-1;
        plot( a([j,j+1]),b([j,j+1]),['-',color],'linewidth', 0.5 ); 
    end;
end;
set (gca,'Ydir','reverse');
axis ([ 113 512 51 351 ]);  
axis off; 

% Aster_ub
xCrd = [ Neg2(9).Mid_up_xCrd; Neg2(9).Mid_btm_xCrd ];
yCrd = [ Neg2(9).Mid_up_yCrd; Neg2(9).Mid_btm_yCrd ]; 
color = 'g'; 
hold on; 
for i = 1:size(xCrd,1);
    a = xCrd(i, ~isnan(xCrd(i,:)));
    b = yCrd(i, ~isnan(yCrd(i,:)));
    for j = 1:length(a)-1;
        plot( a([j,j+1]),b([j,j+1]),['-',color],'linewidth', 0.5 ); 
    end;
end;

% Spindle_middle_half 
xCrd = [ Neg2(9).Mid_mid_half_xCrd; Neg2(9).Mid_mid_half_xCrd ];
yCrd = [ Neg2(9).Mid_mid_half_yCrd; Neg2(9).Mid_mid_half_yCrd ]; 
color = 'c'; 
hold on; 
for i = 1:size(xCrd,1);
    a = xCrd(i, ~isnan(xCrd(i,:)));
    b = yCrd(i, ~isnan(yCrd(i,:)));
    for j = 1:length(a)-1;
        plot( a([j,j+1]),b([j,j+1]),['-',color],'linewidth', 0.5 ); 
    end;
end;

% Spindle_out
xCrd = [ Neg2(9).Mid_out_xCrd; Neg2(9).Mid_out_xCrd ];
yCrd = [ Neg2(9).Mid_out_yCrd; Neg2(9).Mid_out_yCrd ]; 
gray = [0.7,0.7,0.7];

hold on; 
for i = 1:size(xCrd,1);
    a = xCrd(i, ~isnan(xCrd(i,:)));
    b = yCrd(i, ~isnan(yCrd(i,:)));
    for j = 1:length(a)-1;
        plot( a([j,j+1]),b([j,j+1]), '-', 'color', gray, 'linewidth', 0.5 ); 
    end;
end;
toc; 
%% Plot boundaries and pole
fprintf ('Plotting boundaries of Neg2 spindle \n'); tic; 
% plot ([Neg2(9).box_perm.left(1), Neg2(9).box_perm.right(1)], ...  % up 
%     [Neg2(9).box_perm.top, Neg2(9).box_perm.top], '-w', 'linewidth',1);
% plot ([Neg2(9).box_perm.left(1), Neg2(9).box_perm.right(1)], ...  % bottom
%     [Neg2(9).box_perm.bottom, Neg2(9).box_perm.bottom], '-w', 'linewidth',1);
% plot ([Neg2(9).box_perm.left(1), Neg2(9).box_perm.left(1)], ... % left 
%     [Neg2(9).box_perm.top, Neg2(9).box_perm.bottom], '-w', 'linewidth',1);
% plot ([Neg2(9).box_perm.right(1), Neg2(9).box_perm.right(1)],... % right
%     [Neg2(9).box_perm.top, Neg2(9).box_perm.bottom], '-w', 'linewidth',1);
plot ([Neg2(9).Pole_left_r(1), Neg2(9).Pole_left_r(1)], ... % pole left
    [Neg2(9).box_perm.top, Neg2(9).box_perm.bottom], '--w', 'linewidth',1);
plot ([Neg2(9).Pole_right_r(1), Neg2(9).Pole_right_r(1)], ... % pole right
    [Neg2(9).box_perm.top, Neg2(9).box_perm.bottom], '--w', 'linewidth',1);
plot ([Neg2(9).Pole_left_r(1), Neg2(9).Pole_right_r(1)],... % 2-1 
    [Neg2(9).width_top(2), Neg2(9).width_top(2)], '--w', 'linewidth',1);
plot ([Neg2(9).Pole_left_r(1), Neg2(9).Pole_right_r(1)],... % 2-3
    [Neg2(9).width_bottom(2), Neg2(9).width_bottom(2)], '--w', 'linewidth',1);
% middle box
plot ([Neg2(9).p3, Neg2(9).p4], [Neg2(9).p1, Neg2(9).p1], '-y', 'linewidth',1);
plot ([Neg2(9).p3, Neg2(9).p4], [Neg2(9).p2, Neg2(9).p2], '-y', 'linewidth',1);
plot ([Neg2(9).p3, Neg2(9).p3], [Neg2(9).p1, Neg2(9).p2], '-y', 'linewidth',1);
plot ([Neg2(9).p4, Neg2(9).p4], [Neg2(9).p1, Neg2(9).p2], '-y', 'linewidth',1);
% pole 
plot( Neg2(9).Pole_left_r(1), Neg2(9).Pole_left_r(2), '.b', 'markersize', 30);
plot( Neg2(9).Pole_right_r(1), Neg2(9).Pole_right_r(2), '.b', 'markersize',30);
toc; 
print_save_figure( gcf, 'Figure_5C', 'EB1_figures' );

%% 5D
figure();
set(gcf, 'Color', 'black');
fprintf ('Plotting tracks of Neg2 spindle \n'); tic; 
% Aster_lr
xCrd = [ Kif18B(3).Left_xCrd; Kif18B(3).Right_xCrd ];
yCrd = [ Kif18B(3).Left_yCrd; Kif18B(3).Right_yCrd ]; 
color = 'm'; 
hold on; 
for i = 1:size(xCrd,1);
    a = xCrd(i, ~isnan(xCrd(i,:)));
    b = yCrd(i, ~isnan(yCrd(i,:)));
    for j = 1:length(a)-1;
        plot( a([j,j+1]),b([j,j+1]),['-',color],'linewidth', 0.5 ); 
    end;
end;
set (gca,'Ydir','reverse');
axis ([ 46 445 76 375 ]);  
axis off; 

% Aster_ub
xCrd = [ Kif18B(3).Mid_up_xCrd; Kif18B(3).Mid_btm_xCrd ];
yCrd = [ Kif18B(3).Mid_up_yCrd; Kif18B(3).Mid_btm_yCrd ]; 
color = 'g'; 
hold on; 
for i = 1:size(xCrd,1);
    a = xCrd(i, ~isnan(xCrd(i,:)));
    b = yCrd(i, ~isnan(yCrd(i,:)));
    for j = 1:length(a)-1;
        plot( a([j,j+1]),b([j,j+1]),['-',color],'linewidth', 0.5 ); 
    end;
end;

% Spindle_middle_half 
xCrd = [ Kif18B(3).Mid_mid_half_xCrd; Kif18B(3).Mid_mid_half_xCrd ];
yCrd = [ Kif18B(3).Mid_mid_half_yCrd; Kif18B(3).Mid_mid_half_yCrd ]; 
color = 'c'; 
hold on; 
for i = 1:size(xCrd,1);
    a = xCrd(i, ~isnan(xCrd(i,:)));
    b = yCrd(i, ~isnan(yCrd(i,:)));
    for j = 1:length(a)-1;
        plot( a([j,j+1]),b([j,j+1]),['-',color],'linewidth', 0.5 ); 
    end;
end;

% Spindle_out
xCrd = [ Kif18B(3).Mid_out_xCrd; Kif18B(3).Mid_out_xCrd ];
yCrd = [ Kif18B(3).Mid_out_yCrd; Kif18B(3).Mid_out_yCrd ]; 
gray = [0.7,0.7,0.7];

hold on; 
for i = 1:size(xCrd,1);
    a = xCrd(i, ~isnan(xCrd(i,:)));
    b = yCrd(i, ~isnan(yCrd(i,:)));
    for j = 1:length(a)-1;
        plot( a([j,j+1]),b([j,j+1]), '-', 'color', gray, 'linewidth', 0.5 ); 
    end;
end;
toc; 
%% Plot boundaries and pole
fprintf ('Plotting boundaries of Neg2 spindle \n'); tic; 
% plot ([Kif18B(3).box_perm.left(1), Kif18B(3).box_perm.right(1)], ...  % up 
%     [Kif18B(3).box_perm.top, Kif18B(3).box_perm.top], '-w', 'linewidth',1);
% plot ([Kif18B(3).box_perm.left(1), Kif18B(3).box_perm.right(1)], ...  % bottom
%     [Kif18B(3).box_perm.bottom, Kif18B(3).box_perm.bottom], '-w', 'linewidth',1);
% plot ([Kif18B(3).box_perm.left(1), Kif18B(3).box_perm.left(1)], ... % left 
%     [Kif18B(3).box_perm.top, Kif18B(3).box_perm.bottom], '-w', 'linewidth',1);
% plot ([Kif18B(3).box_perm.right(1), Kif18B(3).box_perm.right(1)],... % right
%     [Kif18B(3).box_perm.top, Kif18B(3).box_perm.bottom], '-w', 'linewidth',1);
plot ([Kif18B(3).Pole_left_r(1), Kif18B(3).Pole_left_r(1)], ... % pole left
    [Kif18B(3).box_perm.top, Kif18B(3).box_perm.bottom], '--w', 'linewidth',1);
plot ([Kif18B(3).Pole_right_r(1), Kif18B(3).Pole_right_r(1)], ... % pole right
    [Kif18B(3).box_perm.top, Kif18B(3).box_perm.bottom], '--w', 'linewidth',1);
plot ([Kif18B(3).Pole_left_r(1), Kif18B(3).Pole_right_r(1)],... % 2-1 
    [Kif18B(3).width_top(2), Kif18B(3).width_top(2)], '--w', 'linewidth',1);
plot ([Kif18B(3).Pole_left_r(1), Kif18B(3).Pole_right_r(1)],... % 2-3
    [Kif18B(3).width_bottom(2), Kif18B(3).width_bottom(2)], '--w', 'linewidth',1);
% middle box
plot ([Kif18B(3).p3, Kif18B(3).p4], [Kif18B(3).p1, Kif18B(3).p1], '-y', 'linewidth',1);
plot ([Kif18B(3).p3, Kif18B(3).p4], [Kif18B(3).p2, Kif18B(3).p2], '-y', 'linewidth',1);
plot ([Kif18B(3).p3, Kif18B(3).p3], [Kif18B(3).p1, Kif18B(3).p2], '-y', 'linewidth',1);
plot ([Kif18B(3).p4, Kif18B(3).p4], [Kif18B(3).p1, Kif18B(3).p2], '-y', 'linewidth',1);
% pole 
plot( Kif18B(3).Pole_left_r(1), Kif18B(3).Pole_left_r(2), '.b', 'markersize', 30);
plot( Kif18B(3).Pole_right_r(1), Kif18B(3).Pole_right_r(2), '.b', 'markersize',30);
toc; 
print_save_figure( gcf, 'Figure_5D', 'EB1_figures' );

%% Fig 4E - lifetime with ci
load Position_Analysis.mat; 
figure ()  
hold on;
positions = [ 1 2 4 5 7 8 ];
Y = [ Neg2_aster_lr_sta.lt_gof.Tau;  Kif18B_aster_lr_sta.lt_gof.Tau;...
      Neg2_aster_ub_sta.lt_gof.Tau;  Kif18B_aster_ub_sta.lt_gof.Tau;...
      Neg2_spindle_half_sta.lt_gof.Tau;  Kif18B_spindle_half_sta.lt_gof.Tau ];
E1 = [ Neg2_aster_lr_sta.lt_gof.Tau_ci(1);  Kif18B_aster_lr_sta.lt_gof.Tau_ci(1);...
      Neg2_aster_ub_sta.lt_gof.Tau_ci(1);  Kif18B_aster_ub_sta.lt_gof.Tau_ci(1);...
      Neg2_spindle_half_sta.lt_gof.Tau_ci(1);  Kif18B_spindle_half_sta.lt_gof.Tau_ci(1) ] - Y;
E2 = [ Neg2_aster_lr_sta.lt_gof.Tau_ci(2);  Kif18B_aster_lr_sta.lt_gof.Tau_ci(2);...
      Neg2_aster_ub_sta.lt_gof.Tau_ci(2);  Kif18B_aster_ub_sta.lt_gof.Tau_ci(2);...
      Neg2_spindle_half_sta.lt_gof.Tau_ci(2);  Kif18B_spindle_half_sta.lt_gof.Tau_ci(2) ] - Y;
 
h = errorbar( positions, Y, E1, E2,'*', 'linewidth', 1 ); 
set( gca,'xtick',[ 1 2 4 5 7 8 ] ); 
set( gca,'xticklabel', {'Neg2 aster lr', 'Kif18B aster lr', ...
    'Neg2 aster ub', 'Kif18B aster ub', 'Neg2 spindle 0.6', ...
    'Kif18B spindle 0.6'}, 'fontsize',fontsize, 'fontname', 'arial' );
xticklabel_rotate([],45,[],'Fontsize',fontsize, 'fontname', 'arial');
xlim ([0 9]);
ylim ([3 6]);
errorbar_tick( h, 20 );
ylabel( 'Tau with confidence interval', 'fontsize',fontsize, 'fontname', 'arial' )
print_save_figure( gcf, 'Figure_5E', 'EB1_figures' );

%% velocity
figure ()  
hold on;
positions = [ 1 2 4 5 7 8 ];
Y = [ Neg2_aster_lr_sta.vl_gof.Mean;  Kif18B_aster_lr_sta.vl_gof.Mean;...
      Neg2_aster_ub_sta.vl_gof.Mean;  Kif18B_aster_ub_sta.vl_gof.Mean;...
      Neg2_spindle_half_sta.vl_gof.Mean;  Kif18B_spindle_half_sta.vl_gof.Mean ];
E = [ Neg2_aster_lr_sta.vl_gof.SD;  Kif18B_aster_lr_sta.vl_gof.SD;...
      Neg2_aster_ub_sta.vl_gof.SD;  Kif18B_aster_ub_sta.vl_gof.SD;...
      Neg2_spindle_half_sta.vl_gof.SD;  Kif18B_spindle_half_sta.vl_gof.SD ] ;

h = errorbar( positions, Y, E,'*', 'linewidth', 1 ); 
xlim ([0 9]);
ylim ([0 15]);
set( gca,'xtick',[ 1 2 4 5 7 8 ] ); 
set( gca,'xticklabel', {'Neg2 aster lr', 'Kif18B aster lr', ...
    'Neg2 aster ub', 'Kif18B aster ub', 'Neg2 spindle 0.6', ...
    'Kif18B spindle 0.6'}, 'fontsize',fontsize, 'fontname', 'arial' );
xticklabel_rotate([],45,[],'Fontsize',fontsize, 'fontname', 'arial');
errorbar_tick( h, 20 );
ylabel( 'Mean velocity with SD', 'fontsize',fontsize, 'fontname', 'arial' )
print_save_figure( gcf, 'Figure_5F', 'EB1_figures');