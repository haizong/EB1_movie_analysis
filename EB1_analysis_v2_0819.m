%% Description
% Rotate image and track positions around the center point of the image.
% The function take a series of (x,y) from projData.xCoord and projData.yCoordand
% rotate them for 'theta' around 'center'.'center':image (256,256)
% due to imrotate only rotate around image center
% by HZ, Aug 2015, Bloomington

%% Self-written functions used here
% plot_tracks, rotate_coordinate, plot_tracks, plot_box, cal_track_angle
% direction_left, direction_right, bin_assign, cal_track_stats

%%
close all;
clear; clc; 
fontsize = 14;

%% read folder
TIFF_list_all = dir('*.TIF');
TIFF_list = {};
for i = 1:length(TIFF_list_all);
    if isempty(strfind(TIFF_list_all(i).name, 'thumb'));
        TIFF_list = [TIFF_list, TIFF_list_all(i).name];
    end;
end;
fprintf('Load files from current directory');

%% Read each image in the folder
for i = 1:length(TIFF_list)
    filename = TIFF_list_all(i).name; %%  image read the first frame
    img_ori = imread(filename);
    imshow(img_ori, []);
    set(gca,'YDir','reverse');
    axis on; hold on;
    
    %% click twice to specify the positions of the two poles
    pole = struct();
    [pole.A_x, pole.A_y] = ginput(1);
    plot(pole.A_x, pole.A_y, '+r', 'markersize',8);
    [pole.B_x, pole.B_y] = ginput(1);
    plot(pole.B_x, pole.B_y, '+g', 'markersize',8);
    hold off
    
    %% calculate distance between 2 poles and pole angle with horizontal axis
    pole.p2p_dist = pdist([pole.A_x, pole.A_y; pole.B_x, pole.B_y]);
    pole.center_x = 0.5*(pole.A_x + pole.B_x);
    theta = atan2(pole.B_y - pole.A_y, pole.B_x - pole.A_x);
    rot_angle = theta * 180 / pi;
    
    %% load image and rotate
    mat_name = filename(1:end-4);
    load ([mat_name,'.mat']);
    % rotate image and x y coordinates
    img_center = size(img_ori)/2;
    img_rot = imrotate(img_ori, rot_angle, 'crop');
    [xCoord_r, yCoord_r] = rotate_coordinate(projData.xCoord, projData.yCoord, theta, img_center);
    [pole.A_xr, pole.A_yr] = rotate_coordinate(pole.A_x, pole.A_y, theta, img_center);
    [pole.B_xr, pole.B_yr] = rotate_coordinate(pole.B_x, pole.B_y,theta, img_center);
    
    %% show original, rotated images and tracks
    figure()
    subplot(2,2,1);
    imshow(img_ori, []); axis on; hold on;
    plot(pole.A_x, pole.A_y,'+r',pole.B_x, pole.B_y,'+g','markersize',8);
    title('Original image','fontsize',fontsize, 'fontname', 'arial');
    
    subplot(2,2,2);
    imshow(img_rot, []); axis on; hold on;
    plot(pole.A_xr, pole.A_yr,'+r',pole.B_xr, pole.B_yr,'+g', 'markersize',8);
    title('Rotated image','fontsize',fontsize, 'fontname', 'arial');
    
    subplot(2,2,3);
    plot_tracks (projData.xCoord, projData.yCoord,'b');
    plot(pole.A_x, pole.A_y,'.r',pole.B_x, pole.B_y,'.g','markersize',16);
    title('Original tracks', 'fontsize',fontsize, 'fontname', 'arial');
    
    subplot(2,2,4);
    plot_tracks (xCoord_r, yCoord_r,'b');
    plot(pole.A_xr, pole.A_yr,'.r',pole.B_xr, pole.B_yr,'.g','markersize',16);
    title('Rotated tracks', 'fontsize',fontsize, 'fontname', 'arial'); hold off;
    print_save_figure(gcf, 'Original_and _rotated_images_and_tracks', [mat_name, '_processed']);
    
    %% Box out the spindle position. Save information in 'box'
    box_perm = struct();
    figure
    plot_tracks (xCoord_r, yCoord_r,'b');
    plot(pole.A_xr, pole.A_yr,'.r',pole.B_xr, pole.B_yr,'.g','markersize',16);
    title('Rotated tracks', 'fontsize',fontsize, 'fontname', 'arial');
    
    % set boundary by clicking the upper limit. Draw a horizontal line.
    [box_perm.x_ginput,box_perm.top] = ginput (1);
    box_perm.bottom = 2 * pole.A_yr - box_perm.top;
    box_perm.left = pole.A_xr;
    box_perm.right = pole.B_xr;
    box_perm.midline = (pole.A_xr + pole.B_xr)/2;
    
    plot_box (box_perm.top, box_perm.bottom, box_perm.left, box_perm.right, box_perm.midline);
    title('Click the upper boundary','fontsize',fontsize, 'fontname', 'arial');
    hold off; print_save_figure(gcf, 'Spindle_boundary', [mat_name, '_processed']);
    
    %% Divide racks in the box into 2 sides: A & B.
    % Record the xCrd of the first comet in each track and its angle (-pi, pi).
    [A.xCrd, A.yCrd, B.xCrd, B.yCrd, xCrd_insideBox, yCrd_insideBox]...
        = Decide_lr (xCoord_r, yCoord_r, box_perm.top, box_perm.bottom, ...
        box_perm.midline, box_perm.left, box_perm.right);
    
    %%  Determine the direction (antipolar or poleward) of tracks in A and B boxes.
    % Note that the function for A and B is different. Left for A and right for B
    
    [A.track_ang] = cal_track_angle (A.xCrd, A.yCrd);
    [B.track_ang] = cal_track_angle (B.xCrd, B.yCrd);
    
    [A.antipolar_x1, A.antipolar_y1, A.antipolar_xCrd, A.antipolar_yCrd, ...
        A.poleward_x1, A.poleward_y1, A.poleward_xCrd, A.poleward_yCrd] = ...
        direction_left (A.track_ang, A.xCrd, A.yCrd);
    
    [B.antipolar_x1, B.antipolar_y1, B.antipolar_xCrd, B.antipolar_yCrd, ...
        B.poleward_x1, B.poleward_y1, B.poleward_xCrd, B.poleward_yCrd] = ...
        direction_right (B.track_ang, B.xCrd, B.yCrd);
    
    %% plot tracks divied into antipolar and poleward moving groups
    figure(); axis ([0 500 0 500]); axis equal; hold on;
    title ('Tracks plotted based on color', 'fontsize',fontsize, 'fontname', 'arial');
    plot(pole.A_xr, pole.A_yr,'.r',pole.B_xr, pole.B_yr,'.g','markersize',16);
    plot_box (box_perm.top, box_perm.bottom, box_perm.left, box_perm.right, box_perm.midline);
    plot_tracks (A.antipolar_xCrd, A.antipolar_yCrd, 'r');
    plot_tracks (A.poleward_xCrd, A.poleward_yCrd, 'b');
    legend('Antipolar', 'Poleward');
    pause(1);
    plot_tracks (B.antipolar_xCrd, B.antipolar_yCrd, 'r');
    plot_tracks (B.poleward_xCrd, B.poleward_yCrd, 'b');
    hold off;
    print_save_figure(gcf, 'Antipole_poleward_moving_tracks', [mat_name, '_processed']);
    
    %% combine the array of Crd in A and B based on antipolar or poleward.
    % use the first frame of the comet for localization [Sid]
    antipolar_x1 = [A.antipolar_x1; B.antipolar_x1];
    antipolar_y1 = [A.antipolar_y1; B.antipolar_y1];
    poleward_x1 = [A.poleward_x1; B.poleward_x1];
    poleward_y1 = [A.poleward_y1; B.poleward_y1];
    
    %% Convert pixel to micron (1 pixel =0.15 micron). Set bin size to 2 micron.
    antipolar_x1_adj = (antipolar_x1-min(antipolar_x1)) * 0.15;  % set start point to 0
    poleward_x1_adj = (poleward_x1-min(poleward_x1)) * 0.15; % set start point to 0
    antipolar_x1_per = antipolar_x1_adj / max(antipolar_x1_adj) *100;
    poleward_x1_per = poleward_x1_adj / max(poleward_x1_adj) * 100;
    
    %% calculate and plot followiong parameters of all MTs
    [All_MT.vel_all, All_MT.vel_means, All_MT.dist_all, All_MT.dist_sum, ...
        All_MT.angle_all, All_MT.angle_flipped, All_MT.life_times] ...
        = cal_track_stats(projData.xCoord, projData.yCoord, 2, 150, 'all_MTs', mat_name);
    
    %% calculate and plot followiong parameters of selected MTs within the box
    [Box_MT.vel_all, Box_MT.vel_means, Box_MT.dist_all, Box_MT.dist_sum, ...
        Box_MT.angle_all, Box_MT.angle_flipped, Box_MT.life_times] ...
        = cal_track_stats(xCrd_insideBox, yCrd_insideBox, 2, 150, 'MTs_insdie_box', mat_name);
    
    %% save under folder specified by image name
    save([mat_name, '_processed']);  %under folder specified by image name
    close all;
end;


