%% plot color-coded tracks based on their speed on the first frame of movie (1 frame)
% load '_processed.mat' file you want to plot
% MCAK_20150309_006_processed.mat
% 715aa_focused_20150116_001_processed.mat
% 715aa_unfocused_20150212_004_processed.mat
% MCAK_20150324_006_processed.mat

%% load mat file
clear; 
image_name = 'MCAK_20150324_006_processed.mat';
load (image_name);

name = filename(1:end-4);
img_min = min(img_ori(:)); 
img_max = max(img_ori(:));

figure
imshow(img_rot, [img_min img_max]); 
print_save_figure(gcf, [name, '_rotated_image'],[name, '_processed']);

%%
figure
imshow(img_rot, [img_min img_max]); hold on; 

% get color map range for 7 bins
clr_accu = 7; 
cmin = min(All_MT.vel_means(:)); 
cmax = max(All_MT.vel_means(:));  
mycolor_map = jet(clr_accu);
% get bin width by speed
cstep = (cmax - cmin) / (clr_accu - 1);
n_tracks = length(xCoord_r); 
n_frames = 31; 

% FIGURE traces plot
% colored tracks by their speed at each interval

for i = 1:n_tracks;
    for j = 1:n_frames - 1;
            c_temp = round((All_MT.vel_means(i,1) - cmin) / cstep + 1);
            plot(xCoord_r(i,j:j+1), yCoord_r(i,j:j+1), 'color', mycolor_map(c_temp,:),'LineWidth',2);
    end;
end;
axis square; 
set(gca, 'Ydir', 'reverse');
print_save_figure(gcf, [name, '_track_color_speed'],[name, '_processed']);
