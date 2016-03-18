function [] = plot_tracks_color(xCrd, yCrd, vel_means, life_times, mat_name, clr_accu)

% % Example
% xCrd = TracksInfo(2).xCrd;
% yCrd = TracksInfo(2).yCrd;
% life_times = TracksInfo(2).life_times;
% vel_means = TracksInfo(2).vel_means;
% mat_name = TracksInfo(2).name;

if ~exist('clr_accu', 'var') || isempty(clr_accu); clr_accu = 20; end;

% get color map range for 50 bins
clr_map = jet(clr_accu);
cmin = min(life_times(:)); cmax = max(life_times(:));
% get bin width by lifetime
cstep = (cmax - cmin) / (clr_accu - 1);
n_tracks = length(xCrd);

% FIGURE traces plot
% colored tracks by their lifetime

figure(); hold on
for i = 1:n_tracks;
    c_temp = round((life_times(i) - cmin) / cstep + 1);
    plot(xCrd(i,:), yCrd(i,:), 'color', clr_map(c_temp,:));
end;
axis square; xlabel('x coordinate'); ylabel('y coordinate'); set(gca, 'Ydir', 'reverse');
colorbar; title([mat_name, 'Tracks colored by lifetimes'],'fontsize',12,'fontweight','bold');
print_save_figure(gcf, [mat_name,'_lifetime_color']);
hold off

figure(); hold on
cmin = min(vel_means(:)); cmax = max(vel_means(:));
% get bin width by speed
cstep = (cmax - cmin) / (clr_accu - 1);
for i = 1:n_tracks;
    c_temp = round((vel_means(i) - cmin) / cstep + 1);
    plot(xCrd(i,:), yCrd(i,:), 'color', clr_map(c_temp,:));
end;
axis square; xlabel('x coordinate'); ylabel('y coordinate'); set(gca, 'Ydir', 'reverse');
colorbar; title([mat_name, 'Tracks colored by velocity'],'fontsize',12,'fontweight','bold');
print_save_figure(gcf, [mat_name,'_velocity_color']);
hold off

close all; 