% plot boundary lines and rotated poles on the spindle
function plot_box (y_top, y_bottom, x_left, x_right, x_center, pole_left_xr, pole_right_xr)
gray=[0.4,0.4,0.4];
plot (get(gca,'xlim'), [y_top, y_top],'Color', gray, 'linewidth',2);
plot (get(gca, 'xlim'), [y_bottom,y_bottom], 'Color', gray, 'linewidth', 2);
plot ([x_left, x_left], get(gca,'ylim'), 'Color', gray, 'linewidth',2 );
plot ([x_right, x_right], get(gca,'ylim'), 'Color', gray, 'linewidth',2 );
plot ([x_center, x_center], get(gca,'ylim'), '-.', 'Color', gray, 'linewidth',2 );
plot ([pole_left_xr, pole_left_xr], get(gca,'ylim'), 'Color', gray, 'linewidth',2 );
plot ([pole_right_xr, pole_right_xr], get(gca,'ylim'), 'Color', gray, 'linewidth',2 );
