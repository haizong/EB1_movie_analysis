%% Save useful data in Neg2 and Kif18B
clear; clc;
load Neg2.mat;  load Kif18B.mat;
% Find first position of each comet (x1,y1). Convert to percentage.
for n = 1: length (Neg2)
    for i = 1:size(Neg2(n).xCoord_r,1);
        xCrd_nan = Neg2(n).xCoord_r(i,~isnan(Neg2(n).xCoord_r(i,:)));
        yCrd_nan = Neg2(n).yCoord_r(i,~isnan(Neg2(n).yCoord_r(i,:)));
        Neg2(n).xyCrd1 (i,1) = xCrd_nan(1);
        Neg2(n).xyCrd1 (i,2) = yCrd_nan(1);
    end
    [Neg2(n).vel_all, Neg2(n).vel_means, Neg2(n).dist_all,...
        Neg2(n).dist_sum, Neg2(n).angle_all, Neg2(n).angle_flipped, Neg2(n).life_times]...
        = cal_track_stats(Neg2(n).xCoord_r, Neg2(n).yCoord_r, 2, 150, 'All MTs', Neg2(n).name);
end

for n = 1: length (Kif18B)
    for i = 1:size(Kif18B(n).xCoord_r,1);
        xCrd_nan = Kif18B(n).xCoord_r(i,~isnan(Kif18B(n).xCoord_r(i,:)));
        yCrd_nan = Kif18B(n).yCoord_r(i,~isnan(Kif18B(n).yCoord_r(i,:)));
        Kif18B(n).xyCrd1 (i,1) = xCrd_nan(1);
        Kif18B(n).xyCrd1 (i,2) = yCrd_nan(1);
    end
    [Kif18B(n).vel_all, Kif18B(n).vel_means, Kif18B(n).dist_all,...
        Kif18B(n).dist_sum, Kif18B(n).angle_all, Kif18B(n).angle_flipped, Kif18B(n).life_times]...
        = cal_track_stats(Kif18B(n).xCoord_r, Kif18B(n).yCoord_r, 2, 150, 'All MTs', Kif18B(n).name);
end

%% plot for Neg2

for n = 1:length(Neg2)
    figure ()
    % [xx, yy] = meshgrid(Neg2(n).xyCrd1 (:,1), Neg2(n).xyCrd1 (:,2));
    xx = Neg2(n).xyCrd1 (:,1);
    yy = Neg2(n).xyCrd1 (:,2);
    zz = Neg2(n).life_times;
    % Scatter3, size 5, color based on zz
    scatter3( xx(:), yy(:), zz(:), 10, zz(:), 'filled'); hold on;
    plot( Neg2(n).Pole_left_xr, Neg2(n).Pole_left_yr, '+r', 'markersize', 15);
    plot( Neg2(n).Pole_right_xr, Neg2(n).Pole_right_yr, '+g', 'markersize', 15 );
    
    view(-30,10)
    % colomap and bar
    colormap(jet);
    colorbar;
    title (['Heat Map of lifetime  ', Neg2(n).name], 'Fontsize', 14, 'FontName', 'Arial' );
    xlabel ( 'x Cooridnate', 'Fontsize', 14, 'FontName', 'Arial' );
    ylabel ( 'y Cooridnate', 'FontSize', 14, 'FontName', 'Arial' );
    zlabel ( 'Lifetime', 'Fontsize', 14, 'FontName', 'Arial' );
    print_save_figure( gcf, [Neg2(n).name, '_lt_heatmap'], 'Processed'  );
end
close all; 

%% plot for Kif18B
for n = 1:length(Kif18B)
    figure ()
    % [xx, yy] = meshgrid(Kif18B(n).xyCrd1 (:,1), Kif18B(n).xyCrd1 (:,2));
    xx = Kif18B(n).xyCrd1 (:,1);
    yy = Kif18B(n).xyCrd1 (:,2);
    zz = Kif18B(n).life_times;
    % Scatter3, size 5, color based on zz
    scatter3(xx(:),yy(:),zz(:),10,zz(:), 'filled' ); hold on;
    plot( Kif18B(n).Pole_left_xr, Kif18B(n).Pole_left_yr, '+r', 'markersize', 15);
    plot( Kif18B(n).Pole_right_xr, Kif18B(n).Pole_right_yr, '+g', 'markersize', 15 );
    
    view(-30,10)
    % colomap and bar
    colormap(jet);
    colorbar;
    title (['Heat Map of lifetime  ', Kif18B(n).name], 'Fontsize', 14, 'FontName', 'Arial' );
    xlabel ( 'x Cooridnate', 'Fontsize', 14, 'FontName', 'Arial' );
    ylabel ( 'y Cooridnate', 'FontSize', 14, 'FontName', 'Arial' );
    zlabel ( 'Lifetime', 'Fontsize', 14, 'FontName', 'Arial' );
    print_save_figure( gcf, [Kif18B(n).name, '_lt_heatmap'], 'Processed'  );
end
close all;

%% 
for n = 1:length(Neg2)
    figure ()
    % [xx, yy] = meshgrid(Neg2(n).xyCrd1 (:,1), Neg2(n).xyCrd1 (:,2));
    yy = Neg2(n).xyCrd1 (:,2);
    zz = Neg2(n).life_times;
    % Scatter3, size 5, color based on zz
    scatter( yy(:), zz(:), 'filled'); hold on;
    plot( Neg2(n).Pole_left_yr, 25, '+r', 'markersize', 15); hold on;
    ylim([0 70]); 
    
    title (['Lifetime vs yCrd ', Neg2(n).name], 'Fontsize', 14, 'FontName', 'Arial' );
    xlabel ( 'y Cooridnate', 'Fontsize', 14, 'FontName', 'Arial' );
    ylabel ( 'Lifetime', 'FontSize', 14, 'FontName', 'Arial' );
   
    print_save_figure( gcf, [Neg2(n).name, '_lt_vs_y'], 'Processed'  );
end

%%
for n = 1:length(Kif18B)
    figure ()
    % [xx, yy] = meshgrid(Kif18B(n).xyCrd1 (:,1), Kif18B(n).xyCrd1 (:,2));
    yy = Kif18B(n).xyCrd1 (:,2);
    zz = Kif18B(n).life_times;
    % Scatter3, size 5, color based on zz
    scatter( yy(:), zz(:), 'filled'); hold on;
    ylim([0 70]); 
    plot( Kif18B(n).Pole_left_yr, 25, '+r', 'markersize', 15); hold on;
    
    title (['Lifetime vs yCrd ', Kif18B(n).name], 'Fontsize', 14, 'FontName', 'Arial' );
    xlabel ( 'y Cooridnate', 'Fontsize', 14, 'FontName', 'Arial' );
    ylabel ( 'Lifetime', 'FontSize', 14, 'FontName', 'Arial' );
   
    print_save_figure( gcf, [Kif18B(n).name, '_lt_vs_y'], 'Processed'  );
end
