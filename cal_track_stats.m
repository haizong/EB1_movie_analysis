% Specify MT population in input. All MTs or MTs inside the box. 
function [vel_all, vel_means, dist_all, dist_sum, angle_all, angle_flipped, life_times] ...
    = cal_track_stats(xCrd, yCrd, dt, ratio_dist, MT_population, mat_name)

% save data dimentions
[n_tracks, n_frames] = size(xCrd);

% calculate speed and distance for all intervals all tracks
vel_all = nan(n_tracks, n_frames -1);
dist_all = nan(n_tracks, n_frames -1);

for i = 1:n_tracks
    for j = 1:(n_frames - 1)
        if ~any(isnan([xCrd(i,j:j+1), yCrd(i,j:j+1)]));
            dist_all(i,j) = pdist([xCrd(i,j), yCrd(i,j); xCrd(i,j+1), yCrd(i,j+1)])*ratio_dist/1000;
            vel_all(i,j) = dist_all(i,j)/dt*60;
        end;
    end;
end;

% calculate life time, average speed and total distance, angle for each track
life_times = nan(n_tracks, 1);
vel_means = nan(n_tracks, 1);
dist_sum = nan(n_tracks, 1);
for i = 1:n_tracks
    temp = vel_all(i,:);
    vel_means(i) = mean(temp(~isnan(temp)));
    temp = dist_all(i, :);
    dist_sum(i) = sum(temp(~isnan(temp)));
    life_times(i) = 2*length(temp(~isnan(temp)));
end;

angle_all= nan(n_tracks, 1); 
for i = 1:n_tracks
    xCrd_nan = xCrd(i,~isnan(xCrd(i,:)));
    yCrd_nan = yCrd(i,~isnan(yCrd(i,:)));
    xCrd_mean = mean(xCrd_nan(2:end));
    yCrd_mean = mean(yCrd_nan(2:end));
    angle_all(i) = atan2(yCrd_mean-yCrd_nan(1), xCrd_mean-xCrd_nan(1))*180/pi; 
end; 

angle_flipped = nan(n_tracks, 1);  
for i = 1:n_tracks
    if angle_all(i) > -90 && angle_all(i)<90
        angle_flipped (i) = angle_all(i);
    else if angle_all(i) >=90 && angle_all(i)<=180
            angle_flipped (i) = angle_all(i)-90;
        else angle_flipped (i) = angle_all(i)+90;
        end;
    end;
end;

mean_vel = mean(vel_means); sd_vel = std(vel_means);
mean_lifetime = mean(life_times); sd_lifetime = std(life_times);
mean_displacement = mean(dist_sum); sd_displacement = std(dist_sum);

figure(); hold on;
subplot(2,2,1);
hist (life_times, 0:2:50);
set(gca, 'XTick', 0:5:50);
title (mat_name, 'fontsize', 16, 'Fontname', 'arial');
xlabel('Lifetime (s)','fontsize', 12, 'Fontname', 'arial');
ylabel('Number of EB1 tracks', 'fontsize', 12, 'Fontname', 'arial');
xlim([0,50]);
annotation('textbox',...
    [0.3 0.8 0.1 0.1],...
    'String',{['ave = ' num2str(mean_lifetime)],['std =' num2str(sd_lifetime)]},...
    'EdgeColor',[1 1 1]);

subplot(2,2,2);
hist (vel_means, 0:2:30);
set(gca, 'XTick', 0:5:30);
xlabel('Velocity ($\mu$m/min)','fontsize', 12, 'interpreter','latex', 'Fontname', 'arial');
ylabel('Number of EB1 tracks', 'fontsize', 12, 'Fontname', 'arial');
xlim([0,30]);
annotation('textbox',...
    [0.75 0.8 0.1 0.1],...
    'String',{['ave = ' num2str(mean_vel)],['std =' num2str(sd_vel)]},...
    'EdgeColor',[1 1 1]);


subplot(2,2,3);
hist (dist_sum, 0:0.5:6);
set(gca, 'XTick', 0:1:6);
xlabel('Displacement ($\mu$m)', 'fontsize', 12, 'interpreter','latex','Fontname', 'arial');
ylabel('Number of EB1 tracks', 'fontsize', 12, 'Fontname', 'arial');
xlim([0,6]);
annotation('textbox',...
    [0.3 0.3 0.1 0.1],...
    'String',{['ave = ' num2str(mean_displacement)],['std =' num2str(sd_displacement)]},...
    'EdgeColor',[1 1 1]);

subplot(2,2,4);
hist (angle_flipped, -90:6:90);
set(gca, 'XTick', -90:90:90);
xlabel('EB1 commet angle', 'fontsize', 12, 'Fontname', 'arial');
ylabel('Number of comets', 'fontsize', 12, 'Fontname', 'arial');
xlim([-90,90]);
print_save_figure(gcf, [mat_name, MT_population],'Processed');

close; 
