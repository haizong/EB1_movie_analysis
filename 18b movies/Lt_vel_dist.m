%% Calculate the distance between the first comet in each track and the center of the aster

for i = 1:length(TracksInfo)
    [n_tracks, n_frames] = size(TracksInfo(i).xCrd);
    dist = [];
    dist_max = [];
    
    for j = 1:n_tracks
        xCrd_nan = TracksInfo(i).xCrd(j,~isnan(TracksInfo(i).xCrd(j,:)));
        yCrd_nan = TracksInfo(i).yCrd(j,~isnan(TracksInfo(i).xCrd(j,:)));
        temp_dist = pdist([xCrd_nan(1), yCrd_nan(1); TracksInfo(i).center_x, TracksInfo(i).center_y]);
        dist = [dist;temp_dist];
    end
    
    temp_max = max(dist);
    TracksInfo(i).dist = dist;
    TracksInfo(i).dist_max  = [dist_max; temp_max];
    TracksInfo(i).lifetime_max = max(TracksInfo(i).life_times);  % lifetime limit
    TracksInfo(i).vel_max = max(TracksInfo(i).vel_means);  % velocity limit
end

%% Find x,y limit for making plots
dist_limit = max([TracksInfo.dist_max]);  % need to use [] to put filed array into a matrix
lifetime_limit = max([TracksInfo.lifetime_max]);
vel_limit = max([TracksInfo.vel_max]);

%% Plot statistics against distance
% plot lifetime against distance
for i = 1:length(TracksInfo)
    figure (); hold on;
    scatter(TracksInfo(i).dist, TracksInfo(i).life_times);
    xlim ([0,dist_limit]);
    ylim ([0,lifetime_limit]);
    xlabel('Distance (pixels)', 'fontsize', 12,'Fontname', 'arial');
    ylabel('Lifetime (sec)','fontsize', 12,'Fontname', 'arial');
    title([TracksInfo(i).name, '  Lifetime'],'fontsize', 14,'Fontname', 'arial');
    print_save_figure(gcf, [TracksInfo(i).name, '_Lifetime'],'Plot_lifetime_distance');
    
    figure (); hold on;
    scatter(TracksInfo(i).dist, TracksInfo(i).vel_means);
    xlim ([0,dist_limit]);
    ylim ([0,vel_limit]);
    xlabel('Distance (pixels)', 'fontsize', 12,'Fontname', 'arial');
    ylabel('Velocity (um/min)', 'fontsize', 12,'Fontname', 'arial');
    title([TracksInfo(i).name, '  Velocity'], 'fontsize', 14,'Fontname', 'arial');
    print_save_figure(gcf, [TracksInfo(i).name, '_Velocity'],'Plot_velocity_distance');
end