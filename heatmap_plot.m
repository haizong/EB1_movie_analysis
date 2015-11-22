% To count how many spots appeared at each pixel - heat map
% serialize all coordinates
x = reshape(projData.xCoord, size(projData.xCoord,1)*size(projData.xCoord,2), 1);
y = reshape(projData.yCoord, size(projData.yCoord,1)*size(projData.yCoord,2), 1);
% remove NaN
x = round(x(~isnan(x)));
y = round(y(~isnan(y)));


% count in to each pixel
dens = zeros(512,512);
for i = 1:length(x);
    dens(y(i), x(i)) = dens(y(i), x(i)) + 1;
end;
imagesc(dens); 
% blur by a 7x7 box
% because it's too 'sparse'
dens_blur = zeros(512,512);
% blur box 'diameter', [-3:+3] = 7
blur = 3;
for i = 1:512;
    for j = 1:512;
        % sum, not average
        dens_blur(i,j) = sum(sum( dens(max(1,i-blur):min(i+blur,512), max(1,j-blur):min(j+blur,512)) ));
    end;
end;
% advanced alternative, using linear algebra
kernel = ones(blur*2+1,blur*2+1);
dens_blur = conv2(dens, kernel, 'same' );

% draw heatmap
imagesc(dens_blur); colormap(hot);
%  %% look up this
set(gca, 'tickdir','out');
xlabel('xCoord', 'fontsize',16,'fontweight','bold');
ylabel('yCoord', 'fontsize',16,'fontweight','bold');
%  %% look up this
hc = colorbar('location','eastoutside');
hcm = max(get(hc,'YLim'));
set(hc,'YTick',[0 hcm/2 hcm]);
set(hc,'YTickLabel',{'0', num2str(max(dens_blur(:))/2), num2str(max(dens_blur(:))) });


% different kernel, use 'cross'
dens_blur2 = smooth2d(dens, 25);
imagesc(dens_blur2); colormap(hot);
set(gca, 'tickdir','out');
xlabel('xCoord', 'fontsize',16,'fontweight','bold');
ylabel('yCoord', 'fontsize',16,'fontweight','bold');
hc = colorbar('location','eastoutside');
hcm = max(get(hc,'YLim'));
set(hc,'YTick',[0 hcm/2 hcm]);
set(hc,'YTickLabel',{'0', num2str(max(dens_blur2(:))/2), num2str(max(dens_blur2(:))) });

