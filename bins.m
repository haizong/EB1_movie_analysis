clear; 
cd roi_1; 
cd meta; 
load ('track_pst_angle'); 
% normalize spindle length to 25 bins 
%# random data vector of integers
M = antipolar.x1Crd_reset100; 
N = poleward.x1Crd_reset100; 
%# compute bins
nbins = 23;
binEdges = linspace(min(M),max(M),nbins+1);
aj = binEdges(1:end-1);     %# bins lower edge
bj = binEdges(2:end);       %# bins upper edge
cj = ( aj + bj ) ./ 2;      %# bins center

%# assign values to bins
[~,M_binIdx] = histc(M, [binEdges(1:end-1) Inf]);
[~,N_binIdx] = histc(N, [binEdges(1:end-1) Inf]);
%# count number of values in each bin
M_nj = accumarray(M_binIdx, 1, [nbins 1], @sum);
N_nj = accumarray(N_binIdx, 1, [nbins 1], @sum);
p_M_nj = M_nj./(M_nj+N_nj)*100; 
p_N_nj = N_nj./(M_nj+N_nj)*100; 

%# plot histogram
subplot (2,1,1); 
bar(cj,p_M_nj,'hist');
ylim([0,100]);
set(gca, 'XTick',0:50:100, 'XLim',[binEdges(1) binEdges(end)]);
xlabel('Spindle length (%)', 'fontsize', 12, 'Fontname', 'arial');
ylabel('% of comets','fontsize', 12, 'Fontname', 'arial');
title('Antipolar-moving MTs','fontsize', 14, 'Fontname', 'arial');
subplot (2,1,2); 
bar(cj,p_N_nj,'hist');
ylim([0,100]);
set(gca, 'XTick',0:50:100, 'XLim',[binEdges(1) binEdges(end)]);
xlabel('Spindle length (%)','fontsize', 12, 'Fontname', 'arial'); 
ylabel('% of comets','fontsize', 12, 'Fontname', 'arial'); 
title('Poleward-moving MTs', 'fontsize', 14, 'Fontname', 'arial'); 
print_save_figure(gcf, 'Fig7.23bins_Histogram_antipolar_vs_poleward_moving_MTs');

% tracks fall into the box
tracks_box.xCrd = [Left.xCrd; Right.xCrd]; 
tracks_box.yCrd = [Left.yCrd; Right.yCrd];
% plot histogram of all MTs
[vel_all, vel_means, dist_all, dist_sum, angle_all, angle_flipped, life_times] ...
    = cal_track_stats(tracks_box.xCrd, tracks_box.yCrd, 2, 150);

mean_vel = mean(vel_means); sd_vel = std(vel_means);
mean_lifetime = mean(life_times); sd_lifetime = std(life_times); 
mean_displacement = mean(dist_sum); sd_displacement = std(dist_sum); 

figure(); hold on;
text (0,0, 'Histogram_all_MTs');
subplot(2,2,1); 
hist (life_times, 0:2:20);
set(gca, 'XTick', 0:2:20);
xlabel('Lifetime (s)','fontsize', 12, 'Fontname', 'arial'); 
ylabel('Number of EB1 tracks', 'fontsize', 12, 'Fontname', 'arial'); 
xlim([0,20]); 
annotation('textbox',...
    [0.3 0.8 0.1 0.1],...
    'String',{['ave = ' num2str(mean_lifetime)],['std = ' num2str(sd_lifetime)],...
    ['# tracks = ' num2str(tracks_box.btn_lr)]}, 'EdgeColor',[1 1 1]);
subplot(2,2,2); 
hist (vel_means, 0:2:30);
set(gca, 'XTick', 0:5:30);
xlabel('Velocity ($\mu$m/min)','fontsize', 12, 'interpreter','latex', 'Fontname', 'arial'); 
ylabel('Number of EB1 tracks', 'fontsize', 12, 'Fontname', 'arial'); 
xlim([0,30]);
annotation('textbox',...
    [0.75 0.8 0.1 0.1],...
    'String',{['ave = ' num2str(mean_vel)],['std = ' num2str(sd_vel)]},...
    'EdgeColor',[1 1 1]);

subplot(2,2,3); 
hist (dist_sum, 0:0.5:6);
set(gca, 'XTick', 0:1:6);
xlabel('Displacement ($\mu$m)', 'fontsize', 12, 'interpreter','latex','Fontname', 'arial'); 
ylabel('Number of EB1 tracks', 'fontsize', 12, 'Fontname', 'arial'); 
xlim([0,6]); 
annotation('textbox',...
    [0.3 0.3 0.1 0.1],...
    'String',{['ave = ' num2str(mean_displacement)],['std = ' num2str(sd_displacement)]},...
    'EdgeColor',[1 1 1]);

subplot(2,2,4); 
hist (angle_flipped, -90:6:90);
set(gca, 'XTick', -90:90:90);
xlabel('EB1 commet angle', 'fontsize', 12, 'Fontname', 'arial'); 
ylabel('Number of comets', 'fontsize', 12, 'Fontname', 'arial'); 
xlim([-90,90]); 
print_save_figure(gcf, 'fig8.Histogram_all_MTs');

clear ('xCrd_nan', 'yCrd_nan', 'i');
save('track_pst_angle');

