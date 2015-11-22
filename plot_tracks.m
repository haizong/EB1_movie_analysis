% This function plots all the tracks based on xCoord and yCoord.
function [] = plot_tracks (xCrd, yCrd, color)
hold on; 
for i = 1:size(xCrd,1);
    a = xCrd(i, ~isnan(xCrd(i,:)));
    b = yCrd(i, ~isnan(yCrd(i,:)));
    for j = 1:length(a)-1;
        plot(a([j,j+1]),b([j,j+1]),['-',color],'linewidth',2); 
    end;
end;
set (gca,'Ydir','reverse');
axis ([0 500 0 500]); axis equal;
clear ('a','b','i','j'); 