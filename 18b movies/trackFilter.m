
% This script is the filter for EB1 movie analysis to throw out
%     1. Mean intensity of detected particles within a single track is above 99th
%        percentile of the intensity distribution of all detected particles.
%        This is to filter out tracks associated with centrosome beads,
%        bright aggregates and hot pixels that are not stationary because
%        of image registration.
%     2. Tracks with lifetime longer than 1 min.
%        This is to filter out tracks associated with less bright hot pixels.
%     3. Tracks with lifetime longer than 20 sec and with mean speed lower than 5 ?m/min. ?
%        This is to filter out tracks associated with less bright hot pixels.

clc; clear;
load ('/Users/hailingzong/Documents/MATLAB/18b_m_Processed/TracksInfo_plot.mat');
per_th = 100;  % 100 means no filter.  99 means filter out top 1% brightest comets. 
%% Go to the upper level where movies are stored by days.
%  Directory: /Users/hailingzong/Documents/MATLAB/18b_m

% dir list everything, including . files
folders = dir;
% get rid of the . files
DateFolders = folders(arrayfun(@(x) x.name(1), folders) ~= '.');

MovieInfo = [];
n = 0;
for i = 1:length(DateFolders)
    temp = dir(DateFolders(i).name);
    MovieList = temp(arrayfun(@(x) x.name(1), temp) ~= '.');
    MovieInfo = [MovieInfo; MovieList];
    
    for j = 1:length(MovieList)
        dir_name1 = DateFolders(i).name;
        dir_name2 = MovieList(j).name;
        % Read eacg image in the folder. Store the pixel intensity at each (xCrd, yCrd)
        n = n+1;
        imgFiles = dir( [dir_name1,'/', dir_name2 '/images/*.tif'] );
        [ n_Tracks, n_Frames ] = size( TracksInfo(n).xCrd);
        
        TracksInfo(n).intmap = NaN( n_Tracks, n_Frames );
        for ii = 1 : length(imgFiles)
            filename = imgFiles(ii).name;
            I = imread(filename);
            for jj = 1:n_Tracks
                xCrd = round(TracksInfo(n).xCrd(jj,ii));
                yCrd = round(TracksInfo(n).yCrd(jj,ii));
                if ~isnan(xCrd)
                    TracksInfo(n).intmap(jj,ii) = I ( xCrd, yCrd );
                    
                end
            end
        end
        fprintf (['Currently @ ',dir_name1,'/', dir_name2, '\n'] );
    end
end

%% Calculate the mean intesnity of each track

for i = 1:length(TracksInfo)
    [ n_Tracks, n_Frames ] = size( TracksInfo(i).intmap);
    for j = 1:n_Tracks
        TracksInfo(i).int_mean(j,1) = nanmean(TracksInfo(i).intmap(j,:));  % mean ignoring nan
    end
end

%% Calculate the top x % of intensity. Change those track crd as Nan
% Now the filtered crd are saved as xCrd_filter, yCrd_filter. 

for i = 1:length(TracksInfo)
    Int_mod = TracksInfo(i).intmap(~isnan(TracksInfo(i).intmap));
    th = prctile(Int_mod,per_th);  % intensity of the threshold of top 5%
    [row,~] = find(TracksInfo(i).int_mean > th);  % get the row number of those 5% brightest
    TracksInfo(i).xCrd_filter = TracksInfo(i).xCrd;
    TracksInfo(i).yCrd_filter = TracksInfo(i).yCrd;
    for j = 1:length(row)
        TracksInfo(i).xCrd_filter(row(j),:) = NaN;
        TracksInfo(i).yCrd_filter(row(j),:) = NaN;
    end
end

%% %% Calculate statistics on all tracks.  Save histograms
% replace the previous statistics for now. 


for i = 1:length(TracksInfo)

[TracksInfo(i).vel_all, TracksInfo(i).vel_means, TracksInfo(i).dist_all,... 
    TracksInfo(i).dist_sum, TracksInfo(i).life_times]...
    = cal_track_stats(TracksInfo(i).xCrd_filter, TracksInfo(i).yCrd_filter, 2, 150, 'Filtered_tracks', TracksInfo(i).name);

end 

save('TracksInfo.mat', 'TracksInfo');
