%% Description
% This script is modified from 'EB1_analysis_v2_0819.m' to do EB1 analysis
% for Claire's Kif18B RNAi movies.
% Process:
% Rotate image and track positions around the center point of the image.
% The function take a series of (x,y) from projData.xCoord and projData.yCoordand
% rotate them for 'theta' around 'center'.'center':image (256,256)
% due to imrotate only rotate around image center
% by HZ, March 2016, Bloomington

%% Self-written functions used here
% plot_tracks, rotate_coordinate, plot_box, cal_track_angle
% direction_left, direction_right, bin_assign, cal_track_stats

%%
close all;
clear; clc;
fontsize = 14;

%% read folder
% get rid of the . files
folders = dir;
DateFolders = folders(arrayfun(@(x) x.name(1), folders) ~= '.');

MovieInfo = [];
RotTracks = [];
for i = 1:length(DateFolders)
    temp = dir(DateFolders(i).name);
    MovieList = temp(arrayfun(@(x) x.name(1), temp) ~= '.');
    MovieInfo = [MovieInfo; MovieList];
    
    for j = 1:length(MovieList)
        % [AsterInfo(n).filename, AsterInfo(n).pathname] = uigetfile('*.tif', 'Select the first tif file');
        dir_name1 = DateFolders(i).name;
        dir_name2 = MovieList(j).name;
        
        fprintf(['Load image from current directory', '/', dir_name2 '/ images\n']);
        load ([dir_name1,'/', dir_name2 '/roi_1/meta/projData.mat']);
       
        n = length(RotTracks)+1;
        RotTracks(n).name = dir_name2;
        RotTracks(n).img1 = imread([dir_name1,'/', dir_name2 '/images', '/', [dir_name2,'0000.tif']]);
        RotTracks(n).xCrd = projData.xCoord; 
        RotTracks(n).yCrd = projData.yCoord; 
        
        figure (); hold on;
        title(dir_name2);
        imshow(RotTracks(n).img1, [ ]); axis on; axis([0 512 0 512]); 
        set(gca,'YDir','reverse'); hold on; 
        % click twice to specify the positions of the two poles
        [ RotTracks(n).Pole_left_x, RotTracks(n).Pole_left_y ] = ginput(1);
        plot(RotTracks(n).Pole_left_x, RotTracks(n).Pole_left_y, '+r', 'markersize',8);
        [ RotTracks(n).Pole_right_x, RotTracks(n).Pole_right_y ] = ginput(1);
        plot( RotTracks(n).Pole_right_x, RotTracks(n).Pole_right_y, '+g', 'markersize',8 );
     
        hold off
        
        % calculate distance between 2 poles and pole angle with horizontal axis
        pole.p2p_dist = pdist([RotTracks(n).Pole_left_x, RotTracks(n).Pole_left_y; ...
            RotTracks(n).Pole_right_x, RotTracks(n).Pole_right_y]);
        pole.center_x = 0.5*(RotTracks(n).Pole_left_x + RotTracks(n).Pole_right_x);
        theta = atan2(RotTracks(n).Pole_right_y - RotTracks(n).Pole_left_y,...
            RotTracks(n).Pole_right_x - RotTracks(n).Pole_left_x);
        rot_angle = theta * 180 / pi;
        
        %% Rotate
        % rotate image and x y coordinates
        img_center = size(RotTracks(n).img1)/2;
        RotTracks(n).img_rot = imrotate(RotTracks(n).img1, rot_angle, 'crop');
        [RotTracks(n).xCoord_r, RotTracks(n).yCoord_r] ...
            = rotate_coordinate(projData.xCoord, projData.yCoord, theta, img_center);
        [RotTracks(n).Pole_left_xr, RotTracks(n).Pole_left_yr] ...
            = rotate_coordinate(RotTracks(n).Pole_left_x, RotTracks(n).Pole_left_y, theta, img_center);
        [RotTracks(n).Pole_right_xr, RotTracks(n).Pole_right_yr] ...
            = rotate_coordinate(RotTracks(n).Pole_right_x, RotTracks(n).Pole_right_y,theta, img_center);
        
%         %% show original, rotated images and tracks (for checking)
%         figure()
%         subplot(2,2,1);
%         imshow(RotTracks(n).img1, []); axis on; hold on;
%         plot(RotTracks(n).Pole_left_x, RotTracks(n).Pole_left_y,'+r',...
%             RotTracks(n).Pole_right_x, RotTracks(n).Pole_right_y,'+g','markersize',8);
%         title('Original image','fontsize',fontsize, 'fontname', 'arial');
%         
%         subplot(2,2,2);
%         imshow(RotTracks(n).img_rot, []); axis on; hold on;
%         plot(RotTracks(n).Pole_left_xr, RotTracks(n).Pole_left_yr, '+r',...
%             RotTracks(n).Pole_right_xr, RotTracks(n).Pole_right_yr,'+g', 'markersize',8);
%         title('Rotated image','fontsize',fontsize, 'fontname', 'arial');
%         
%         subplot(2,2,3);
%         plot_tracks (projData.xCoord, projData.yCoord,'b');
%         plot(RotTracks(n).Pole_left_x, RotTracks(n).Pole_left_y,'.r',...
%             RotTracks(n).Pole_right_x, RotTracks(n).Pole_right_y,'.g','markersize',16);
%         title('Original tracks', 'fontsize',fontsize, 'fontname', 'arial');
%         
%         subplot(2,2,4);
%         plot_tracks (RotTracks(n).xCoord_r, RotTracks(n).yCoord_r,'b');
%         plot(RotTracks(n).Pole_left_xr, RotTracks(n).Pole_left_yr,'.r',...
%             RotTracks(n).Pole_right_xr, RotTracks(n).Pole_right_yr,'.g', 'markersize',16);
%         title('Rotated tracks', 'fontsize',fontsize, 'fontname', 'arial'); hold off;
%         print_save_figure( gcf, 'Images_and_tracks', [ RotTracks(n).name, '_processed' ] );
        
        %% Box out the spindle position. Save information in 'box'
        RotTracks(n).box_perm = struct();
        figure
        plot_tracks (RotTracks(n).xCoord_r, RotTracks(n).yCoord_r,'b');
        plot( RotTracks(n).Pole_left_xr, RotTracks(n).Pole_left_yr,'.r',...
            RotTracks(n).Pole_right_xr, RotTracks(n).Pole_right_yr,'.g', 'markersize',16 );
        
        % set boundary by clicking the upper limit. Left and right limit. Draw a horizontal line.
        gray=[0.4,0.4,0.4];
        fprintf( 'Please click on the top boundary \n' );
        [ ~, RotTracks(n).box_perm.top ] = ginput (1);
        plot (get(gca,'xlim'), [RotTracks(n).box_perm.top, RotTracks(n).box_perm.top], 'Color', gray, 'linewidth',1);
        
        fprintf( 'Please click on the bottom boundary \n' );
        [ ~, RotTracks(n).box_perm.bottom ] = ginput (1);
        plot (get(gca, 'xlim'), [RotTracks(n).box_perm.bottom, RotTracks(n).box_perm.bottom], 'Color', gray, 'linewidth', 1);
        
        fprintf( 'Please click on the left boundary \n' );
        RotTracks(n).box_perm.left = ginput (1);
        plot ([RotTracks(n).box_perm.left(1), RotTracks(n).box_perm.left(1)], get(gca,'ylim'), 'Color', gray, 'linewidth',1 );
        
        fprintf( 'Please click on the right boundary \n' );
        RotTracks(n).box_perm.right = ginput (1);
        plot ([RotTracks(n).box_perm.right(1), RotTracks(n).box_perm.right(1)], get(gca,'ylim'), 'Color', gray, 'linewidth',1 );
     
        RotTracks(n).box_perm.midline = (RotTracks(n).Pole_left_xr + RotTracks(n).Pole_right_xr)/2;
        plot ([RotTracks(n).box_perm.midline, RotTracks(n).box_perm.midline], get(gca,'ylim'), '-.', 'Color', gray, 'linewidth',1 );
        plot ([RotTracks(n).Pole_left_xr, RotTracks(n).Pole_left_xr], get(gca,'ylim'), 'Color', gray, 'linewidth',1 );
        plot ([RotTracks(n).Pole_right_xr, RotTracks(n).Pole_right_xr], get(gca,'ylim'), 'Color', gray, 'linewidth',1 );
        
        title( dir_name2, 'fontsize',fontsize, 'fontname', 'arial' );
        hold off; 
        print_save_figure( gcf, [RotTracks(n).name, '_Spindle_boundary'], 'Processed'  );
        close all; 
    end
end
%%
save('RotTracks', 'RotTracks');  
close all;



