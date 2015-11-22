% Rotate image and track positions around the center point of the image.
% The function take a series of (x,y) from projData.xCoord and projData.yCoordand
% rotate them for 'theta' around 'center'.'center':image (256,256)
% due to imrotate only rotate around image center
close all;
clear; clc;
%%
img = struct();
% import the first image
[file, pathname] = uigetfile('*.tif*');
img.img_ori = imread(file);
img.min_value = min(img.img_ori(:));
img.max_value = max(img.img_ori(:));
imshow(img.img_ori, [img.min_value, img.max_value]);
set(gca,'YDir','reverse');
axis on; hold on;

%% click twice to specify the positions of the two poles
pole = struct();
[pole.left_x,pole.left_y] = ginput(1);
plot(pole.left_x,pole.left_y, '+r', 'markersize',8);
[pole.right_x,pole.right_y] = ginput(1);
plot(pole.right_x,pole.right_y, '+g', 'markersize',8);
hold off
% calculate the distance between 2 poles and angle vs horizontal axis
pole.p2p_dist = pdist([pole.left_x,pole.left_y;pole.right_x,pole.right_y]);
pole.x_center = 0.5*(pole.left_x + pole.right_x);
theta = atan2(pole.right_y-pole.left_y,pole.right_x-pole.left_x);
rot_angle=theta*180/pi;

load ('projData.mat');
% rotate image and x y coordinates
img.img_rot = imrotate(img.img_ori, rot_angle, 'crop');
[xCoord_rs, yCoord_rs] = rotate_coordinate(projData.xCoord, projData.yCoord, theta, size(img.img_ori)/2);
[pole.left_xr, pole.left_yr] = rotate_coordinate(pole.left_x,pole.left_y,theta, size(img.img_ori)/2);
[pole.right_xr, pole.right_yr] = rotate_coordinate(pole.right_x, pole.right_y,theta, size(img.img_ori)/2);

% show original and rotated images
figure();
subplot(1,2,1);
imshow(img.img_ori, [img.min_value, img.max_value]); axis on; hold on;
plot(pole.left_x, pole.left_y,'+r',pole.right_x, pole.right_y,'+g','markersize',8);
title('Original','fontsize',12);
subplot(1,2,2);
imshow(img.img_rot, [img.min_value, img.max_value]); axis on; hold on;
plot(pole.left_xr, pole.left_yr,'+r',pole.right_xr, pole.right_yr,'+g', 'markersize',8);
title('After rotation','fontsize',12);
print_save_figure(gcf, 'fig1.Ori_rot_image');

% plot original tracks and poles
figure(); hold on;
plot_tracks (projData.xCoord, projData.yCoord,'b');
title('Original', 'fontsize',12);
plot(pole.left_x, pole.left_y,'.r',pole.right_x, pole.right_y,'.g','markersize',16);
hold off;
print_save_figure(gcf, 'fig2.Ori_tracks');

% plot rotated tracks,rotated poles,and boundary lines
figure(); hold on;
plot_tracks (xCoord_rs, yCoord_rs,'b');
plot(pole.left_xr, pole.left_yr,'.r',pole.right_xr, pole.right_yr,'.g','markersize',16);
box = struct();
[box.x_ginput,box.top] = ginput (1);
box.bottom = 2*pole.left_yr-box.top;
box.left = pole.left_xr;
box.right = pole.right_xr;
box.midline = (pole.left_xr+pole.right_xr)/2;

plot_box (box.top, box.bottom, box.left, box.right, box.midline);
title('After rotation','fontsize',12); hold off;
print_save_figure(gcf, 'fig3.Rotated_tracks');

% divide racks in the box into 2 sides:left,right. Record the xCrd of the
% first comet in each track and its angle (-pi, pi).
Left.xCrd = []; Left.yCrd = [];
Right.xCrd = []; Right.yCrd = [];
[n_tracks, n_frames] = size(xCoord_rs);
% count tracks between/out up and bottom lines,out left and right lines.
tracks_box = struct();
tracks_box.btn_ub=0;
tracks_box.out_ub=0;
tracks_box.out_lr=0;
tracks_box.xCrd = [];
tracks_box.yCrd = [];
for i = 1:n_tracks
    if all(yCoord_rs(i, ~isnan(yCoord_rs(i,:))) > box.top) && ...
            all(yCoord_rs(i, ~isnan(yCoord_rs(i,:))) < box.bottom)
        tracks_box.btn_ub = tracks_box.btn_ub+1; % count tracks between up and bottom limits
        tracks_box.xCrd(size(tracks_box.xCrd,1)+1,:) = xCoord_rs(i,:);
        tracks_box.yCrd(size(tracks_box.yCrd,1)+1,:) = yCoord_rs(i,:);
        if all(xCoord_rs(i, ~isnan(xCoord_rs(i,:))) >= box.left) && ...
                all(xCoord_rs(i, ~isnan(xCoord_rs(i,:))) <= box.midline)
            Left.xCrd (size(Left.xCrd,1)+1,:) = xCoord_rs(i,:); % assign
            Left.yCrd (size(Left.yCrd,1)+1,:) = yCoord_rs(i,:);
        elseif any(xCoord_rs(i, ~isnan(xCoord_rs(i,:))) > box.midline) && ...
                all(xCoord_rs(i, ~isnan(xCoord_rs(i,:))) <= box.right)
            Right.xCrd(size(Right.xCrd,1)+1,:) = xCoord_rs(i,:);
            Right.yCrd(size(Right.yCrd,1)+1,:) = yCoord_rs(i,:);
        else tracks_box.out_lr = tracks_box.out_lr +1;
        end;
    else tracks_box.out_ub = tracks_box.out_ub+1;
    end;
end;
tracks_box.btn_lr = length(Left.xCrd(:,1))+length(Right.xCrd(:,1));

for i = 1:size(Left.xCrd,1);
    xCrd_nan = Left.xCrd(i,~isnan(Left.xCrd(i,:)));
    yCrd_nan = Left.yCrd(i,~isnan(Left.yCrd(i,:)));
    Left.track_pst_ang (i,1) = xCrd_nan(1);
    Left.track_pst_ang (i,2) = yCrd_nan(1);
    Left.track_pst_ang (i,3) = mean(Left.xCrd(i,~isnan(Left.xCrd(i,:))));
    Left.track_pst_ang (i,4) = mean(Left.yCrd(i,~isnan(Left.xCrd(i,:))));
    Left.track_pst_ang (i,5) = atan2(Left.track_pst_ang (i,4)-Left.track_pst_ang (i,2),Left.track_pst_ang (i,3)-Left.track_pst_ang (i,1));
    Left.track_pst_ang (i,6) = Left.track_pst_ang (i,5)*180/pi;
end;
for i = 1:size(Right.xCrd,1);
    xCrd_nan = Right.xCrd(i,~isnan(Right.xCrd(i,:)));
    yCrd_nan = Right.yCrd(i,~isnan(Right.yCrd(i,:)));
    Right.track_pst_ang (i,1) = xCrd_nan(1);
    Right.track_pst_ang (i,2) = yCrd_nan(1);
    Right.track_pst_ang (i,3) = mean(Right.xCrd(i,~isnan(Right.xCrd(i,:))));
    Right.track_pst_ang (i,4) = mean(Right.yCrd(i,~isnan(Right.xCrd(i,:))));
    Right.track_pst_ang (i,5) = atan2(Right.track_pst_ang (i,4) - Right.track_pst_ang(i,2), Right.track_pst_ang(i,3)-Right.track_pst_ang(i,1));
    Right.track_pst_ang (i,6) = Right.track_pst_ang (i,5)*180/pi;
end;

Left.antipolar_x1Crd = []; Left.antipolar_y1Crd = [];
Left.antipolar_xCrd = [];  Left.antipolar_yCrd = [];
Left.poleward_x1Crd = [];  Left.poleward_y1Crd = [];
Left.poleward_xCrd = [];   Left.poleward_yCrd = [];
for i = 1:size(Left.track_pst_ang,1)
    if  Left.track_pst_ang (i,6) >= -90 && Left.track_pst_ang (i,6) <= 90
        Left.antipolar_x1Crd(size(Left.antipolar_x1Crd,1)+1,1) =  Left.track_pst_ang (i,1);
        Left.antipolar_y1Crd(size(Left.antipolar_y1Crd,1)+1,1) =  Left.track_pst_ang (i,2);
        Left.antipolar_xCrd(size(Left.antipolar_xCrd,1)+1,:) = Left.xCrd(i,:);
        Left.antipolar_yCrd(size(Left.antipolar_yCrd,1)+1,:) = Left.yCrd(i,:);
    else
        Left.poleward_x1Crd(size(Left.poleward_x1Crd,1)+1,1) =  Left.track_pst_ang (i,1);
        Left.poleward_y1Crd(size(Left.poleward_y1Crd,1)+1,1) =  Left.track_pst_ang (i,2);
        Left.poleward_xCrd(size(Left.poleward_xCrd,1)+1,:) = Left.xCrd(i,:);
        Left.poleward_yCrd(size(Left.poleward_yCrd,1)+1,:) = Left.yCrd(i,:);
    end;
end;

figure(); axis ([0 500 0 500]); axis equal; hold on;
plot(pole.left_xr, pole.left_yr,'.r',pole.right_xr, pole.right_yr,'.g','markersize',16);
plot_box (box.top, box.bottom, box.left, box.right, box.midline);
plot_tracks (Left.antipolar_xCrd, Left.antipolar_yCrd, 'r');
plot_tracks (Left.poleward_xCrd, Left.poleward_yCrd, 'b');
pause(1);

Right.antipolar_x1Crd = []; Right.antipolar_y1Crd = [];
Right.antipolar_xCrd = [];  Right.antipolar_yCrd = [];
Right.poleward_x1Crd = [];  Right.poleward_y1Crd = [];
Right.poleward_xCrd = [];   Right.poleward_yCrd = [];
for i = 1:size(Right.track_pst_ang,1)
    if  Right.track_pst_ang (i,6) >= -90 && Right.track_pst_ang (i,6) <= 90
        Right.poleward_x1Crd(size(Right.poleward_x1Crd,1)+1,1) =  Right.track_pst_ang (i,1);
        Right.poleward_y1Crd(size(Right.poleward_y1Crd,1)+1,1) =  Right.track_pst_ang (i,2);
        Right.poleward_xCrd(size(Right.poleward_xCrd,1)+1,:) = Right.xCrd(i,:);
        Right.poleward_yCrd(size(Right.poleward_yCrd,1)+1,:) = Right.yCrd(i,:);
    else
        Right.antipolar_x1Crd(size(Right.antipolar_x1Crd,1)+1,1) =  Right.track_pst_ang (i,1);
        Right.antipolar_y1Crd(size(Right.antipolar_y1Crd,1)+1,1) =  Right.track_pst_ang (i,2);
        Right.antipolar_xCrd(size(Right.antipolar_xCrd,1)+1,:) = Right.xCrd(i,:);
        Right.antipolar_yCrd(size(Right.antipolar_yCrd,1)+1,:) = Right.yCrd(i,:);
    end;
end;
plot_tracks (Right.antipolar_xCrd, Right.antipolar_yCrd, 'r');
plot_tracks (Right.poleward_xCrd, Right.poleward_yCrd, 'b');

hold off;
print_save_figure(gcf, 'fig4. Tracks_polar_barrel_by_angle');

% combine the array of Crd in left and right based on antipolar or
% poleward. Convert xCrd from pixel to micron (1 pixel =0,.15 micron) to
% set x-axis of histogram to spindle length. Set bin size to 2 micron. 
antipolar.x1Crd = [Left.antipolar_x1Crd; Right.antipolar_x1Crd];
antipolar.y1Crd = [Left.antipolar_y1Crd; Right.antipolar_y1Crd];
poleward.x1Crd = [Left.poleward_x1Crd; Right.poleward_x1Crd];
poleward.y1Crd = [Left.poleward_y1Crd; Right.poleward_y1Crd];

antipolar.x1Crd_reset = 0.15*(antipolar.x1Crd-min(antipolar.x1Crd));
poleward.x1Crd_reset = 0.15*(poleward.x1Crd-min(poleward.x1Crd));
antipolar.x1Crd_reset100 = antipolar.x1Crd_reset*(100/max(antipolar.x1Crd_reset)); 
poleward.x1Crd_reset100 = poleward.x1Crd_reset*(100/max(poleward.x1Crd_reset)); 

figure();
subplot (2,2,1); 
hist (antipolar.x1Crd_reset, 0:2:50);
xlim([0,50]); 
set(gca, 'XTick', 0:10:50);
set(gca,'position',[0.1 0.6 0.3,0.3]);   %%
xlabel('Spindle length ($\mu$m)','fontsize', 12, 'Fontname', 'arial', 'interpreter','latex');
ylabel('Number of EB1 tracks', 'fontsize', 12, 'Fontname', 'arial'); 
title('Antipolar-moving MTs','fontsize', 14, 'Fontname', 'arial');

subplot (2,2,3);  
hist (poleward.x1Crd_reset, 0:2:50); 
xlim([0,50]); 
set(gca, 'XTick', 0:10:50);
set(gca,'position',[0.1 0.1 0.3,0.3]);  %% 
xlabel('Spindle length ($\mu$m)','fontsize', 12, 'Fontname', 'arial', 'interpreter','latex');
ylabel('Number of EB1 tracks', 'fontsize', 12, 'Fontname', 'arial'); 
title('Poleward-moving MTs','fontsize', 14, 'Fontname', 'arial');

% normalize spindle length to 25 bins 
%# random data vector of integers
M = antipolar.x1Crd_reset100; 
N = poleward.x1Crd_reset100; 
%# compute bins
nbins = 15;
binEdges = linspace(min(M),max(M),nbins+1);
aj = binEdges(1:end-1);     %# bins lower edge
bj = binEdges(2:end);       %# bins upper edge
cj = ( aj + bj ) ./ 2;      %# bins center

%# assign values to bins
[~,M_binIdx] = histc(M, [binEdges(1:end-1) Inf]);
[~,N_binIdx] = histc(N, [binEdges(1:end-1) Inf]);
%# count number of values in each bin
M_nj = accumarray(M_binIdx, 1, [nbins 1], @sum);
N_nj = accumarray(N_binIdx, 1, [nbins 1], @sum);
p_M_nj = M_nj./(M_nj+N_nj)*100; 
p_N_nj = N_nj./(M_nj+N_nj)*100; 

%# plot histogram
subplot (2,2,2); 
bar(cj,p_M_nj,'hist');
ylim([0,100]);
set(gca, 'XTick',0:50:100, 'XLim',[binEdges(1) binEdges(end)]);
set(gca,'position',[0.6 0.6 0.3,0.3]);
xlabel('Spindle length (%)', 'fontsize', 12, 'Fontname', 'arial');
ylabel('% of comets','fontsize', 12, 'Fontname', 'arial');
title('Antipolar-moving MTs','fontsize', 14, 'Fontname', 'arial');
subplot (2,2,4); 
bar(cj,p_N_nj,'hist');
ylim([0,100]);
set(gca, 'XTick',0:50:100, 'XLim',[binEdges(1) binEdges(end)]);
set(gca,'position',[0.6 0.1 0.3,0.3]);
xlabel('Spindle length (%)','fontsize', 12, 'Fontname', 'arial'); 
ylabel('% of comets','fontsize', 12, 'Fontname', 'arial'); 
title('Poleward-moving MTs', 'fontsize', 14, 'Fontname', 'arial'); 
print_save_figure(gcf, 'fig5.Histogram_antipolar_vs_poleward_moving_MTs');


% plot histogram of all MTs
[vel_all, vel_means, dist_all, dist_sum, angle_all, angle_flipped, life_times] ...
    = cal_track_stats(tracks_box.xCrd, tracks_box.yCrd, 2, 150);

mean_vel = mean(vel_means); sd_vel = std(vel_means);
mean_lifetime = mean(life_times); sd_lifetime = std(life_times); 
mean_displacement = mean(dist_sum); sd_displacement = std(dist_sum); 

figure(); hold on;
text (0,0, 'Histogram_all_MTs');
subplot(2,2,1); 
hist (life_times, 0:2:20);
set(gca, 'XTick', 0:2:20);
xlabel('Lifetime (s)','fontsize', 12, 'Fontname', 'arial'); 
ylabel('Number of EB1 tracks', 'fontsize', 12, 'Fontname', 'arial'); 
xlim([0,20]); 
annotation('textbox',...
    [0.3 0.8 0.1 0.1],...
    'String',{['ave = ' num2str(mean_lifetime)],['std =' num2str(sd_lifetime)]},...
    'EdgeColor',[1 1 1]);
subplot(2,2,2); 
hist (vel_means, 0:2:30);
set(gca, 'XTick', 0:5:30);
xlabel('Velocity ($\mu$m/min)','fontsize', 12, 'interpreter','latex', 'Fontname', 'arial'); 
ylabel('Number of EB1 tracks', 'fontsize', 12, 'Fontname', 'arial'); 
xlim([0,30]);
annotation('textbox',...
    [0.75 0.8 0.1 0.1],...
    'String',{['ave = ' num2str(mean_vel)],['std =' num2str(sd_vel)]},...
    'EdgeColor',[1 1 1]);

subplot(2,2,3); 
hist (dist_sum, 0:0.5:6);
set(gca, 'XTick', 0:1:6);
xlabel('Displacement ($\mu$m)', 'fontsize', 12, 'interpreter','latex','Fontname', 'arial'); 
ylabel('Number of EB1 tracks', 'fontsize', 12, 'Fontname', 'arial'); 
xlim([0,6]); 
annotation('textbox',...
    [0.3 0.3 0.1 0.1],...
    'String',{['ave = ' num2str(mean_displacement)],['std =' num2str(sd_displacement)]},...
    'EdgeColor',[1 1 1]);

subplot(2,2,4); 
hist (angle_flipped, -90:6:90);
set(gca, 'XTick', -90:90:90);
xlabel('EB1 commet angle', 'fontsize', 12, 'Fontname', 'arial'); 
ylabel('Number of comets', 'fontsize', 12, 'Fontname', 'arial'); 
xlim([-90,90]); 
print_save_figure(gcf, 'fig6.Histogram_all_MTs');

clear ('xCrd_nan', 'yCrd_nan', 'i');
save('track_pst_angle');
close all;
