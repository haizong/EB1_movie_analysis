 

%%
figure();
all_x1 = [antipolar_x1_adj; poleward_x1_adj]; 
hist (all_x1, 0:2:50);
xlim([-2 40]); 
ylim([0 70]);
set(gca, 'XTick', 0:10:40);

xlabel('Spindle length ($\mu$m)','fontsize', 14, 'Fontname', 'arial', 'interpreter','latex');
ylabel('Number of EB1 tracks', 'fontsize', 14, 'Fontname', 'arial');
title('All MTs','fontsize', 14, 'Fontname', 'arial');
print_save_figure(gcf, 'All_MTs', 'supplemental_fig');

%%
figure();
hist (antipolar_x1_adj, 0:2:50);
axis([-2 50 0 50]);
set(gca, 'XTick', 0:10:50);
set(gca, 'YTick', 0:10:50);
xlabel('Spindle length ($\mu$m)','fontsize', 14, 'Fontname', 'arial', 'interpreter','latex');
ylabel('Number of EB1 tracks', 'fontsize', 14, 'Fontname', 'arial');
title('Antipolar-moving MTs','fontsize', 14, 'Fontname', 'arial');
print_save_figure(gcf, 'Antipolar_Moving_MTs', 'supplemental_fig');

%%
M = antipolar_x1_adj;
N = poleward_x1_adj;
nbins = 23; 

binEdges = linspace(min(M),max(M),nbins+1);
aj = binEdges(1:end-1);     % bins lower edge
bj = binEdges(2:end);       % bins upper edge
cj = ( aj + bj ) ./ 2;      % bins center

% assign values to bins
[~,M_binIdx] = histc(M, [binEdges(1:end-1) Inf]); 
[~,N_binIdx] = histc(N, [binEdges(1:end-1) Inf]);

% count number of values in each bin
M_nj = accumarray(M_binIdx, 1, [nbins 1], @sum);
N_nj = accumarray(N_binIdx, 1, [nbins 1], @sum);
p_M_nj = M_nj./(M_nj+N_nj)*100;
p_N_nj = N_nj./(M_nj+N_nj)*100;

%%
figure();
bar(cj, p_M_nj, 'hist');
axis([-10 110 0 100]);
set(gca, 'YTick', 0:25:100);
set(gca, 'XLim', [binEdges(1)-2, binEdges(end)+2]);

xlabel('Spindle length', 'fontsize', 14, 'Fontname', 'arial');
ylabel('% of EB1 tracks','fontsize', 14, 'Fontname', 'arial');
title('Antipolar-moving MTs','fontsize', 14, 'Fontname', 'arial');
print_save_figure(gcf, '%_Antipolar_Moving_MTs', 'supplemental_fig');

%%
mean_vel = mean(All_MT.vel_means); 
sd_vel = std(All_MT.vel_means);
figure();
hist (All_MT.vel_means, 0:2:30);
set(gca, 'XTick', 0:5:30);
xlabel('Velocity ($\mu$m/min)','fontsize', 12, 'interpreter','latex', 'Fontname', 'arial');
ylabel('Number of EB1 tracks', 'fontsize', 12, 'Fontname', 'arial');
xlim([0,30]);
annotation('textbox',...
    [0.75 0.8 0.1 0.1],...
    'String',{['ave = ' num2str(mean_vel)],['std =' num2str(sd_vel)]},...
    'EdgeColor',[1 1 1]);
print_save_figure(gcf, 'Velocity', 'supplemental_fig');