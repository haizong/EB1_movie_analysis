% plot tracks on max proj image of movie (31 frames)
% load '_processed.mat' file you want to plot
% MCAK_20150309_006_processed.mat
% 715aa_focused_20150116_001_processed.mat
% 715aa_unfocused_20150212_004_processed.mat

clear; 
image_name = '715aa_unfocused_20150212_004_processed.mat';
load (image_name);

[file, pathname] = uigetfile('*.tif*');
img_maxproj = imread(file);
maxproj_imadjust = imadjust(img_maxproj);
img_maxrot = imrotate(maxproj_imadjust, rot_angle, 'crop');
name = filename(1:end-4);

figure
imshow(img_maxrot); 
print([name,'_Max_Rotated'], '-dtiff'); 

figure
imshow(img_maxrot); 
plot_tracks (A.antipolar_xCrd, A.antipolar_yCrd, 'r');
plot_tracks (A.poleward_xCrd, A.poleward_yCrd, 'g');

plot_tracks (B.antipolar_xCrd, B.antipolar_yCrd, 'r');
plot_tracks (B.poleward_xCrd, B.poleward_yCrd, 'g');

print([name,'_MaxProj_Tracks'], '-dtiff');