%# random data vector of integers
M = antipolar.x1Crd_reset100; 
N = poleward.x1Crd_reset100; 
%# compute bins
nbins = 25;
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
figure();
subplot (2,1,1); 
bar(cj,p_M_nj,'hist')
set(gca, 'XTick',0:50:100, 'XLim',[binEdges(1) binEdges(end)])
xlabel('Spindle length (%)', 'fontsize', 12, 'Fontname', 'arial');
ylabel('% of Commets','fontsize', 12, 'Fontname', 'arial');
title('Antipolar moving MTs','fontsize', 14, 'Fontname', 'arial');
subplot (2,1,2); 
bar(cj,p_N_nj,'hist')
set(gca, 'XTick',0:50:100, 'XLim',[binEdges(1) binEdges(end)])
xlabel('Spindle length (%)','fontsize', 12, 'Fontname', 'arial'); 
ylabel('% of Commets','fontsize', 12, 'Fontname', 'arial'); 
title('Poleward moving MTs', 'fontsize', 14, 'Fontname', 'arial'); 