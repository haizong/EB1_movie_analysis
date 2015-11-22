% Rotate image and track positions around the center point of the image.
% The function take a series of (x,y) from projData.xCoord and projData.yCoordand
% rotate them for 'theta' around 'center'.'center':image (256,256)
% due to imrotate only rotate around image center
close all;
clear; clc;
prompt = 'What is the ratio for dividing spindle?\n';
ratio = input(prompt);
img = struct();
% import the first image
[file, pathname] = uigetfile('*.tif*', 'multiselect', 'on');
img.img_ori = imread(file);
img.min_value = min(img.img_ori(:));
img.max_value = max(img.img_ori(:));
imshow(img.img_ori, [img.min_value, img.max_value]);
set(gca,'YDir','reverse');
axis on; hold on;

pole = struct();
% click twice to specify the positions of the two poles
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
bound = struct();
[bound.x_ginput,bound.y_top] = ginput (1);  
bound.y_bottom = 2*pole.left_yr-bound.y_top;
bound.x_left = pole.left_xr-ratio*pole.p2p_dist; 
bound.x_right = pole.right_xr+ratio*pole.p2p_dist;
bound.x_ml = pole.left_xr+ratio*pole.p2p_dist;
bound.x_mr = pole.right_xr-ratio*pole.p2p_dist;
plot_bound (bound.y_top, bound.y_bottom, bound.x_left, bound.x_right,bound.x_ml, bound.x_mr);
title('After rotation','fontsize',12); hold off;
print_save_figure(gcf, 'fig3.Rotated_tracks');

% divide allt racks into 3 buckets:left,middle,right
x_bucketA = []; y_bucketA = [];
x_bucketB = []; y_bucketB = [];
x_bucketC = []; y_bucketC = [];
[n_tracks, n_frames] = size(xCoord_rs);
tracks_bound = struct();
tracks_bound.btn_ub=0; tracks_bound.out_ub=0; tracks_bound.out_lr=0; % count tracks between/out up and bottom lines,out left and right lines.
for i = 1:n_tracks
    if any(yCoord_rs(i,:)>bound.y_top) && any(yCoord_rs(i,:)<bound.y_bottom)
        tracks_bound.btn_ub = tracks_bound.btn_ub+1; % count tracks between up and bottom limits
        if any(xCoord_rs(i,:) >= bound.x_left) && any(xCoord_rs(i,:)<bound.x_ml)
            x_bucketA(size(x_bucketA,1)+1,:) = xCoord_rs(i,:); % assign 
            y_bucketA(size(y_bucketA,1)+1,:) = yCoord_rs(i,:);
        elseif any(xCoord_rs(i,:)>=bound.x_ml) && any(xCoord_rs(i,:)<=bound.x_mr)
            x_bucketB(size(x_bucketB,1)+1,:) = xCoord_rs(i,:);
            y_bucketB(size(y_bucketB,1)+1,:) = yCoord_rs(i,:);
        elseif any(xCoord_rs(i,:)>bound.x_mr) && any(xCoord_rs(i,:)<bound.x_right)
            x_bucketC(size(x_bucketC,1)+1,:) = xCoord_rs(i,:);
            y_bucketC(size(y_bucketC,1)+1,:) = yCoord_rs(i,:);
        else tracks_bound.out_lr = tracks_bound.out_lr+1;
        end;
    else tracks_bound.out_ub = tracks_bound.out_ub+1;
    end;
end;

% calculate percentage of tracks in each region and plot
num_3regions = [size(x_bucketA,1), size(x_bucketB,1), size(x_bucketC,1)];
total_n_tracks_bucket = size(x_bucketA,1)+size(x_bucketB,1)+size(x_bucketC,1);
percentA = size(x_bucketA,1)/total_n_tracks_bucket;
percentB = size(x_bucketB,1)/total_n_tracks_bucket;
percentC = size(x_bucketC,1)/total_n_tracks_bucket;
percent_3regions = [percentA,percentB,percentC];
figure();hold on; 
subplot (1,2,1); 
bar (num_3regions, 0.5);
set(gca,'position',[0.2  0.2 0.3 0.5]);
title('Number of tracks','fontsize',12);
set(gca,'XTick',[1,2,3],'xticklabel',{'Left','Middle','Right'},'fontsize',12);
subplot (1,2,2); 
bar (percent_3regions,0.5); ylim([0, 1.0]);
set(gca,'position',[0.6 0.2 0.3 0.5]);
title('Percentage of tracks','fontsize',12);
set(gca,'XTick',[1,2,3],'xticklabel',{'Left','Middle','Right'},'fontsize',12);
print_save_figure(gcf, 'fig4.Percent_tracks_3regions');

figure(); axis ([0 500 0 500]); axis equal; hold on;
plot(pole.left_xr, pole.left_yr,'.r',pole.right_xr, pole.right_yr,'.g','markersize',16);
plot_bound (bound.y_top, bound.y_bottom, bound.x_left, bound.x_right,bound.x_ml, bound.x_mr);
% For each region, determine tracks from pole or chromatin, store xCrd,yCrd
% seperately. Plot tracks in each region on a single graph by pausing 1 sec.
dist = struct('A',[],'B',[],'C',[]);
bucketA = struct(struct('pole_xCrd',[],'pole_yCrd',[],'chromatin_xCrd',[],'chromatin_yCrd',[]));
for i = 1:size(x_bucketA,1);
    a = x_bucketA(i,~isnan(x_bucketA(i,:)));
    b = y_bucketA(i,~isnan(y_bucketA(i,:)));
    dist.A(size(dist.A,1)+1,:) = bsxfun(@minus,...
        pdist([a(end), b(end); pole.left_xr, pole.left_yr]),...
        pdist([a(1), b(1); pole.left_xr, pole.left_yr]));
    if dist.A(i,1) > 0; % grow from pole
        bucketA.pole_xCrd(size(bucketA.pole_xCrd,1)+1,:) = x_bucketA(i,:); % assign 
        bucketA.pole_yCrd(size(bucketA.pole_yCrd,1)+1,:) = y_bucketA(i,:);
            
    elseif dist.A(i,1) < 0; % grow from chromatin
       bucketA.chromatin_xCrd(size(bucketA.chromatin_xCrd,1)+1,:) = x_bucketA(i,:); % assign 
       bucketA.chromatin_yCrd(size(bucketA.chromatin_yCrd,1)+1,:) = y_bucketA(i,:);
    else fprintf('delta distance is 0!');
    end;
end;
clear ('a','b');
plot_tracks (bucketA.pole_xCrd, bucketA.pole_yCrd, 'r'); 
plot_tracks (bucketA.chromatin_xCrd, bucketA.chromatin_yCrd, 'b');
pause(1); 
[vel_all, vel_means, dist_all, dist_sum, angle_all, angle_mean, life_times] = cal_track_stats(bucketA.pole_xCrd,bucketA.pole_yCrd,2,150);
bucketA.pole_velc_f2f = vel_all; 
bucketA.pole_velc_mean = vel_means;
bucketA.pole_dist_f2f = dist_all;
bucketA.pole_dist_sum = dist_sum;
bucketA.pole_angle_f2f = angle_all;
bucketA.pole_angle_mean = angle_mean; 
bucketA.pole_lifetime = life_times;  
[vel_all, vel_means, dist_all, dist_sum, angle_all, angle_mean, life_times] = cal_track_stats(bucketA.chromatin_xCrd,bucketA.chromatin_yCrd,2,150);
bucketA.chromatin_velc_f2f = vel_all;
bucketA.chromatin_velc_mean = vel_means;
bucketA.chromatin_dist_f2f = dist_all;
bucketA.chromatin_dist_sum =  dist_sum;
bucketA.chromatin_angle_f2f = angle_all;
bucketA.chromatin_angle_mean = angle_mean; 
bucketA.chromatin_lifetime = life_times; 

bucketB = struct('pole_xCrd',[],'pole_yCrd',[],'chromatin_xCrd',[],'chromatin_yCrd',[]); 
for i = 1:size(x_bucketB,1);
    a = x_bucketB(i,~isnan(x_bucketB(i,:)));
    b = y_bucketB(i,~isnan(y_bucketB(i,:)));
    dist.B(size(dist.B,1)+1,:) = bsxfun(@minus,...
        pdist([a(end),b(end); pole.x_center,b(end)]),...
        pdist([a(1),b(1); pole.x_center,b(1)]));
    if dist.B(i,1) > 0; % grow from chromatin
       bucketB.chromatin_xCrd(size(bucketB.chromatin_xCrd,1)+1,:) = x_bucketB(i,:); % assign 
       bucketB.chromatin_yCrd(size(bucketB.chromatin_yCrd,1)+1,:) = y_bucketB(i,:);
    elseif dist.B(i,1) < 0; % grow from pole
       bucketB.pole_xCrd(size(bucketB.pole_xCrd,1)+1,:) = x_bucketB(i,:); % assign 
       bucketB.pole_yCrd(size(bucketB.pole_yCrd,1)+1,:) = y_bucketB(i,:); 
    else fprintf('delta distance is 0!');
    end;
end;
plot_tracks (bucketB.pole_xCrd, bucketB.pole_yCrd, 'r'); 
plot_tracks (bucketB.chromatin_xCrd, bucketB.chromatin_yCrd, 'b');
pause(1); 
[vel_all, vel_means, dist_all, dist_sum, angle_all, angle_mean, life_times] = cal_track_stats(bucketB.pole_xCrd,bucketB.pole_yCrd,2,150);
bucketB.pole_velc_f2f = vel_all; 
bucketB.pole_velc_mean = vel_means;
bucketB.pole_dist_f2f = dist_all;
bucketB.pole_dist_sum =  dist_sum;
bucketB.pole_angle_f2f = angle_all;
bucketB.pole_angle_mean = angle_mean; 
bucketB.pole_lifetime = life_times;  
[vel_all, vel_means, dist_all, dist_sum, angle_all, angle_mean, life_times] = cal_track_stats(bucketB.chromatin_xCrd,bucketB.chromatin_yCrd,2,150);
bucketB.chromatin_velc_f2f = vel_all;
bucketB.chromatin_velc_mean = vel_means;
bucketB.chromatin_dist_f2f = dist_all;
bucketB.chromatin_dist_sum =  dist_sum;
bucketB.chromatin_angle_f2f = angle_all;
bucketB.chromatin_angle_mean = angle_mean; 
bucketB.chromatin_lifetime = life_times; 

bucketC = struct('pole_xCrd',[],'pole_yCrd',[],'chromatin_xCrd',[],'chromatin_yCrd',[]); 
for i = 1:size(x_bucketC,1);
    a = x_bucketC(i,~isnan(x_bucketC(i,:)));
    b = y_bucketC(i,~isnan(y_bucketC(i,:)));
    dist.C(size(dist.C,1)+1,:) = bsxfun(@minus,...
        pdist([a(end),b(end);pole.right_xr, pole.right_yr]),...
        pdist([a(1),b(1); pole.right_xr, pole.right_yr]));
    if dist.C(i,1) > 0; % grow from pole
        bucketC.pole_xCrd(size(bucketC.pole_xCrd,1)+1,:) = x_bucketC(i,:); % assign 
        bucketC.pole_yCrd(size(bucketC.pole_yCrd,1)+1,:) = y_bucketC(i,:);
    elseif dist.C(i,1) < 0; % grow from chromatin
       bucketC.chromatin_xCrd(size(bucketC.chromatin_xCrd,1)+1,:)=x_bucketC(i,:); % assign 
       bucketC.chromatin_yCrd(size(bucketC.chromatin_yCrd,1)+1,:)=y_bucketC(i,:);
    else fprintf('delta distance is 0!');
    end;
end;
clear ('a','b');
plot_tracks (bucketC.pole_xCrd, bucketC.pole_yCrd, 'r'); 
plot_tracks (bucketC.chromatin_xCrd, bucketC.chromatin_yCrd, 'b');
[vel_all, vel_means, dist_all, dist_sum, angle_all, angle_mean, life_times] = cal_track_stats(bucketC.pole_xCrd,bucketC.pole_yCrd,2,150);
bucketC.pole_velc_f2f = vel_all; 
bucketC.pole_velc_mean = vel_means;
bucketC.pole_dist_f2f = dist_all;
bucketC.pole_dist_sum =  dist_sum;
bucketC.pole_angle_f2f = angle_all;
bucketC.pole_angle_mean = angle_mean; 
bucketC.pole_lifetime = life_times;  
[vel_all, vel_means, dist_all, dist_sum, angle_all, angle_mean, life_times] = cal_track_stats(bucketC.chromatin_xCrd,bucketC.chromatin_yCrd,2,150);
bucketC.chromatin_velc_f2f = vel_all;
bucketC.chromatin_velc_mean = vel_means;
bucketC.chromatin_dist_f2f = dist_all;
bucketC.chromatin_dist_sum =  dist_sum;
bucketC.chromatin_angle_f2f = angle_all;
bucketC.chromatin_angle_mean = angle_mean; 
bucketC.chromatin_lifetime = life_times; 
clear ('vel_all', 'vel_means', 'dist_all', 'dist_sum', 'life_times');

text(10,20,'Red: MT grow from pole','fontsize',12);
text(10,40,'Blue:MT grow from chromatin','fontsize',12); hold off;
print_save_figure(gcf, 'fig5.Tracks_poles_vs_chromatin');

% plot tracks grow from pole/chromatin_3 regions
subplot(2,1,1); hold on; 
track_orientation=[];% 1st row pole; 2nd row chromatin; Column 123-ABC
track_orientation(1,1) = size(bucketA.pole_xCrd,1);
track_orientation(1,2) = size(bucketA.chromatin_xCrd,1);
track_orientation(2,1) = size(bucketB.pole_xCrd,1);
track_orientation(2,2) = size(bucketB.chromatin_xCrd,1);
track_orientation(3,1) = size(bucketC.pole_xCrd,1);
track_orientation(3,2) = size(bucketC.chromatin_xCrd,1);
h=bar(track_orientation, 0.5); 
set(gca,'XTick',[1,2,3],'xticklabel',{'Left','Middle','Right'},'fontsize',15); 
title('Tracks from pole/chromatin', 'fontsize', 20);
ylabel('number of tracks','fontsize',15);
legend(h,{'pole','chromatin'},'fontsize',12);

% plot tracks grow from pole/chromatin_all tracks
subplot(2,1,2);hold on;
percent_polevschrom(1,1) = sum(track_orientation(:,1))/sum(track_orientation(:));%pole 
percent_polevschrom(1,2) = sum(track_orientation(:,2))/sum(track_orientation(:));%chromatin
h=bar(percent_polevschrom, 0.5); 
ylim([0 1.0]);
title('Percentage of tracks','fontsize',16); 
set(gca,'XTick',[1,2],'xticklabel',{'Pole','Chromatin'},'fontsize',12);
set(gca,'position',[0.2 0.1 0.3,0.3]);
hold off; 
print_save_figure(gcf, 'fig6.Track_orientation_plot');

% fig7.Histogram_MT_from_pole in 3 regions
figure(); hold on;  
subplot(3,4,1); hist (bucketA.pole_lifetime); 
title ('pole lifetime (s)'); ylabel('A. Number of EB1 tracks'); xlim([0,30]);
subplot(3,4,2); hist (bucketA.pole_velc_mean);  
title ('pole mean velocity (um/min)'); ylabel('Number of EB1 tracks'); xlim([0,30]);
subplot(3,4,3); hist (bucketA.pole_dist_sum); 
title ('pole displacement (um)'); ylabel('Number of EB1 tracks'); xlim([0,10]);
subplot(3,4,4); hist (bucketA.pole_angle_mean); 
title ('pole angle of tracks (degree)'); ylabel('Number of EB1 tracks'); xlim([0,200]); 

subplot(3,4,5); hist (bucketB.pole_lifetime); 
title ('pole lifetime (s)'); ylabel('B. Number of EB1 tracks'); xlim([0,30]);
subplot(3,4,6); hist (bucketB.pole_velc_mean);  
title ('pole mean velocity (um/min)'); ylabel('Number of EB1 tracks'); xlim([0,30]);
subplot(3,4,7); hist (bucketB.pole_dist_sum); 
title ('pole displacement (um)'); ylabel('Number of EB1 tracks'); xlim([0,10]);
subplot(3,4,8); hist (bucketB.pole_angle_mean); 
title ('pole angle of tracks (degree)'); ylabel('Number of EB1 tracks'); xlim([0,200]);

subplot(3,4,9); hist (bucketC.pole_lifetime); 
title ('pole lifetime (s)'); ylabel('C. Number of EB1 tracks'); xlim([0,30]);
subplot(3,4,10); hist (bucketC.pole_velc_mean);  
title ('pole mean velocity (um/min)'); ylabel('Number of EB1 tracks'); xlim([0,30]);
subplot(3,4,11); hist (bucketC.pole_dist_sum); 
title ('pole displacement (um)'); ylabel('Number of EB1 tracks'); xlim([0,10]);
subplot(3,4,12); hist (bucketC.pole_angle_mean); 
title ('pole angle of tracks (degree)'); ylabel('Number of EB1 tracks'); xlim([0,200]);
print_save_figure(gcf, 'fig7.Histogram_MT_from_pole');

% fig8.Histogram_MT_from_chromatin in 3 regions

figure(); hold on;  
subplot(3,4,1); hist (bucketA.chromatin_lifetime); 
title ('chrm lifetime (s)'); ylabel('A. Number of EB1 tracks'); xlim([0,30]);
subplot(3,4,2); hist (bucketA.chromatin_velc_mean);  
title ('chrm mean velocity (um/min)'); ylabel('Number of EB1 tracks'); xlim([0,30]);
subplot(3,4,3); hist (bucketA.chromatin_dist_sum); 
title ('chrm displacement (um)'); ylabel('Number of EB1 tracks'); xlim([0,10]);
subplot(3,4,4); hist (bucketA.chromatin_angle_mean); 
title ('chrm angle of tracks (degree)'); ylabel('Number of EB1 tracks'); xlim([0,200]); 

subplot(3,4,5); hist (bucketB.chromatin_lifetime); 
title ('chrm lifetime (s)'); ylabel('B. Number of EB1 tracks'); xlim([0,30]);
subplot(3,4,6); hist (bucketB.chromatin_velc_mean);  
title ('chrm mean velocity (um/min)'); ylabel('Number of EB1 tracks'); xlim([0,30]);
subplot(3,4,7); hist (bucketB.chromatin_dist_sum); 
title ('chrm displacement (um)'); ylabel('Number of EB1 tracks'); xlim([0,10]);
subplot(3,4,8); hist (bucketB.chromatin_angle_mean); 
title ('chrm angle of tracks (degree)'); ylabel('Number of EB1 tracks'); xlim([0,200]);

subplot(3,4,9); hist (bucketC.chromatin_lifetime); 
title ('chrm lifetime (s)'); ylabel('C. Number of EB1 tracks'); xlim([0,30]);
subplot(3,4,10); hist (bucketC.chromatin_velc_mean);  
title ('chrm mean velocity (um/min)'); ylabel('Number of EB1 tracks'); xlim([0,30]);
subplot(3,4,11); hist (bucketC.chromatin_dist_sum); 
title ('chrm displacement (um)'); ylabel('Number of EB1 tracks'); xlim([0,10]);
subplot(3,4,12); hist (bucketC.chromatin_angle_mean); 
title ('chrm angle of tracks (degree)'); ylabel('Number of EB1 tracks'); xlim([0,200]);
print_save_figure(gcf, 'fig8.Histogram_MT_from_chromatin');

% plot histogram of all MTs
[vel_all, vel_means, dist_all, dist_sum, angle_all, life_times] = cal_track_stats(xCoord_rs,yCoord_rs,2,150);
all_tracks.xCoord_rs = xCoord_rs; 
all_tracks.yCoord_rs = yCoord_rs;
all_tracks.velc_f2f = vel_all; 
all_tracks.velc_mean = vel_means;
all_tracks.dist_f2f = dist_all;
all_tracks.dist_sum =  dist_sum;
all_tracks.angle = angle_all;
all_tracks.lifetime = life_times;  

figure(); hold on;  
text (0,0, 'Histogram_all_MTs'); 
subplot(2,2,1); hist (all_tracks.lifetime); 
title ('Lifetime (s)'); ylabel('Number of EB1 tracks'); xlim([0,30]);
subplot(2,2,2); hist (all_tracks.velc_mean);  
title ('Mean velocity (um/min)'); ylabel('Number of EB1 tracks'); xlim([0,30]);
subplot(2,2,3); hist (all_tracks.dist_sum); 
title ('Displacement (um)'); ylabel('Number of EB1 tracks'); xlim([0,10]);
subplot(2,2,4); hist (all_tracks.angle); 
title ('Angle of tracks (degree)'); ylabel('Number of EB1 tracks'); xlim([0,200]); 
print_save_figure(gcf, 'fig9.Histogram_all_MTs');

save ('movie_analysis'); 
close all; 
