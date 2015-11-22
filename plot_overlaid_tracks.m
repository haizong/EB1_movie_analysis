% plot antipolar vs poleward moving tracks on the first frame of movie (1 frame)
% load '_processed.mat' file you want to plot
% MCAK_20150309_006_processed.mat
% 715aa_focused_20150116_001_processed.mat
% 715aa_unfocused_20150212_004_processed.mat
% MCAK_20150324_006_processed.mat

clear; 
image_name = '715aa_unfocused_20150212_004_processed.mat';
load (image_name);
name = filename(1:end-4);
min = min(img_ori(:)); 
max = max(img_ori(:));

figure
imshow(img_rot, [min max]); 
print([name,'_1_Rotated'], '-dtiff'); 

figure
imshow(img_rot, [min max]); 
plot_tracks (A.antipolar_xCrd, A.antipolar_yCrd, 'r');
plot_tracks (A.poleward_xCrd, A.poleward_yCrd, 'g');

plot_tracks (B.antipolar_xCrd, B.antipolar_yCrd, 'r');
plot_tracks (B.poleward_xCrd, B.poleward_yCrd, 'g');

print([name,'_1_Tracks_on_image'], '-dtiff');