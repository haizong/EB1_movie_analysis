function [p_M_nj, p_N_nj, M_nj, N_nj] = bin_assign (antipolar_x1_adj, poleward_x1_adj, nbins, mat_name)

%# random data vector of integers
M = antipolar_x1_adj;
N = poleward_x1_adj;

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

%# plot histogram
figure();
subplot (2,2,1);
hist (antipolar_x1_adj, 0:2:50);
xlim([0,50]);
set(gca, 'XTick', 0:10:50);
set(gca,'position',[0.1 0.6 0.3,0.3]);   %%
xlabel('Spindle length ($\mu$m)','fontsize', 12, 'Fontname', 'arial', 'interpreter','latex');
ylabel('Number of EB1 tracks', 'fontsize', 12, 'Fontname', 'arial');
title('Antipolar-moving MTs','fontsize', 14, 'Fontname', 'arial');

subplot (2,2,3);
hist (poleward_x1_adj, 0:2:50);
xlim([0,50]);
set(gca, 'XTick', 0:10:50);
set(gca,'position',[0.1 0.1 0.3,0.3]);  %%
xlabel('Spindle length ($\mu$m)','fontsize', 12, 'Fontname', 'arial', 'interpreter','latex');
ylabel('Number of EB1 tracks', 'fontsize', 12, 'Fontname', 'arial');
title('Poleward-moving MTs','fontsize', 14, 'Fontname', 'arial');

subplot (2,2,2);
bar(cj, p_M_nj, 'hist');
ylim([0,100]);
set(gca, 'XTick', 0:50:100, 'XLim', [binEdges(1) binEdges(end)]);
set(gca, 'position', [0.6 0.6 0.3,0.3]);
xlabel('Spindle length (%)', 'fontsize', 12, 'Fontname', 'arial');
ylabel('% of comets','fontsize', 12, 'Fontname', 'arial');
title('Antipolar-moving MTs','fontsize', 14, 'Fontname', 'arial');

subplot (2,2,4);
bar(cj, p_N_nj, 'hist');
ylim([0,100]);
set(gca, 'XTick', 0:50:100, 'XLim', [binEdges(1) binEdges(end)]);
set(gca, 'position', [0.6 0.1 0.3,0.3]);
xlabel('Spindle length (%)', 'fontsize', 12, 'Fontname', 'arial');
ylabel('% of comets', 'fontsize', 12, 'Fontname', 'arial');
title('Poleward-moving MTs', 'fontsize', 14, 'Fontname', 'arial');
print_save_figure(gcf, 'Hist_antipolar_vs_poleward_from_bin_assign',[mat_name, '_processed']);

