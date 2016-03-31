% This code goes through the folders to find the projData.mat file for each
% movie / image series analyzed by plusTipTracker.  Resaved them in a cell
% that contains the image name with xCrd and yCrd.
% Can run each part individually. 

%% Go to the upper level where movies are stored by days. 
%  Directory: /Users/hailingzong/Documents/MATLAB/18b_m

% dir list everything, including . files
clc; clear; 
folders = dir;
% get rid of the . files
DateFolders = folders(arrayfun(@(x) x.name(1), folders) ~= '.');

MovieInfo = [];
TracksInfo = [];
for i = 1:length(DateFolders)
    temp = dir(DateFolders(i).name);
    MovieList = temp(arrayfun(@(x) x.name(1), temp) ~= '.');
    MovieInfo = [MovieInfo; MovieList];
    
    for j = 1:length(MovieList)
        dir_name1 = DateFolders(i).name;
        dir_name2 = MovieList(j).name;
        load ([dir_name1,'/', dir_name2 '/roi_1/meta/projData.mat']);
        
        n = length(TracksInfo)+1;
        TracksInfo(n).name = dir_name2;
        TracksInfo(n).xCrd = projData.xCoord;
        TracksInfo(n).yCrd = projData.yCoord;
    end 
end


%% Calculate statistics on all tracks.  Save histograms
for i = 1:length(TracksInfo)
[TracksInfo(i).vel_all, TracksInfo(i).vel_means, TracksInfo(i).dist_all,... 
    TracksInfo(i).dist_sum, TracksInfo(i).angle_all, ~, TracksInfo(i).life_times]...
    = cal_track_stats(TracksInfo(i).xCrd, TracksInfo(i).yCrd, 2, 150, 'All_tracks', TracksInfo(i).name);
end 

save('TracksInfo.mat', 'TracksInfo');

%% Plot tracks and assign color based on their velocity/lifetime
for i = 1:length(TracksInfo)
plot_tracks_color(TracksInfo(i).xCrd, TracksInfo(i).yCrd, TracksInfo(i).vel_means,...
    TracksInfo(i).life_times, TracksInfo(i).name, 20);
end

% %% Find the center of the aster by manually clicking on the two centrosomes
% 
% % dir list everything, including . files
% folders = dir;
% % get rid of the . files
% DateFolders = folders(arrayfun(@(x) x.name(1), folders) ~= '.');
% 
% MovieInfo = [];
% AsterInfo = [];
% 
% for i = 1:length(DateFolders)
%     temp = dir(DateFolders(i).name);
%     MovieList = temp(arrayfun(@(x) x.name(1), temp) ~= '.');
%     MovieInfo = [MovieInfo; MovieList];
%     
%     for j = 1:length(MovieList)
%         dir_name1 = DateFolders(i).name;
%         dir_name2 = MovieList(j).name;
%         n = length(AsterInfo)+1;
%         %[AsterInfo(n).filename, AsterInfo(n).pathname] = uigetfile('*.tif', 'Select the first tif file');
%         AsterInfo(n).name = dir_name2;
%         AsterInfo(n).img1 = imread([dir_name1,'/', dir_name2 '/images', '/', [dir_name2,'0000.tif']]);
%         
%         figure (); hold on; 
%         imshow(AsterInfo(n).img1, [ ]); axis on; axis([0 512 0 512]); hold on;
%         [AsterInfo(n).center_x, AsterInfo(n).center_y] = ginput(1);
%         plot(AsterInfo(n).center_x, AsterInfo(n).center_y, '+r', 'markersize',8);
%         title(dir_name2);
%         print_save_figure(gcf, dir_name2,'Aster_center');
%     end  
% save('AsterInfo.mat', 'AsterInfo');    
% end
% 
% close all; 
% 
% %% 
% for i = 1:length(TracksInfo)
%     TracksInfo(i).img1 = AsterInfo(i).img1;
%     TracksInfo(i).center_x = AsterInfo(i).center_x;
%     TracksInfo(i).center_y = AsterInfo(i).center_y;
% end
% 
% save ('TracksInfo_center', 'TracksInfo');