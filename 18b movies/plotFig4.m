% Descirption
% Script for Plot Fig4 EB1 analysis for Claire's Neg2 and Kif18B RNAi
% movies.  Choose representative image: '20150420-Neg2-003' -- Neg2(9) &
% '20150406-18B2-003' -- Kif18B(3)

% HZ 2016-4-4 Bloomington
%%
clc; clear; 
fontsize = 12; titlesize = 14; fontname = 'arial'; 
load 'Neg2.mat'; 
load Kif18B.mat;
%% 
figure();
set_print_page(gcf,1);
subplot(2,2,1);
subNeg2 = Neg2(9).img_rot(76:325, 151:500 );  % choose subregion with size 250 * 350
imshow( subNeg2, [4800 12000] ); hold on;   % images were scaled differently to see the tracks. 

subplot(2,2,2);
subKif18B = Kif18B(3).img_rot(101:350, 76:425 ); 
imshow(subKif18B, [4800 6400]); hold on;  
 
%%
subplot(2,2,3);
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
axis ([ 151 500 76 325 ]); axis off; 
rectangle ('Position', [ 151 76  349 249 ]);

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
gray = [0.4,0.4,0.4];

hold on; 
for i = 1:size(xCrd,1);
    a = xCrd(i, ~isnan(xCrd(i,:)));
    b = yCrd(i, ~isnan(yCrd(i,:)));
    for j = 1:length(a)-1;
        plot( a([j,j+1]),b([j,j+1]), '-', 'color', gray, 'linewidth', 0.5 ); 
    end;
end;

%%
subplot(2,2,4);
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
axis ([ 76 425 101 350 ]);  axis off;  
rectangle ( 'Position',[ 76 101 349 249 ] );

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
        plot( a([j,j+1]), b([j,j+1]), ['-',color], 'linewidth', 0.5 ); 
    end;
end;

% Spindle_out
xCrd = [ Kif18B(3).Mid_out_xCrd; Kif18B(3).Mid_out_xCrd ];
yCrd = [ Kif18B(3).Mid_out_yCrd; Kif18B(3).Mid_out_yCrd ]; 
gray = [0.4,0.4,0.4];
hold on; 
for i = 1:size(xCrd,1);
    a = xCrd(i, ~isnan(xCrd(i,:)));
    b = yCrd(i, ~isnan(yCrd(i,:)));
    for j = 1:length(a)-1;
        plot( a([j,j+1]),b([j,j+1]), '-', 'color', gray, 'linewidth', 0.5 ); 
    end;
end;

print_save_figure( gcf, 'Figure_4_A2D', 'EB1_figures' );

%%
figure();
