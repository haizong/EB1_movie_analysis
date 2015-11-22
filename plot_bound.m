% plot boundary lines and rotated poles on the spindle
function plot_bound (y_top, y_bottom, x_left, x_right, x_ml, x_mr)
gray=[0.4,0.4,0.4];
plot (get(gca,'xlim'),[y_top, y_top],'Color', gray, 'linewidth',2);
plot (get(gca, 'xlim'), [y_bottom,y_bottom], 'Color', gray, 'linewidth', 2);
plot ([x_left, x_left],get(gca,'ylim'), 'Color', gray, 'linewidth',2 );
plot ([x_right, x_right],get(gca,'ylim'), 'Color', gray, 'linewidth',2 );
plot ([x_ml, x_ml],get(gca,'ylim'), '-.', 'Color', gray, 'linewidth',2 );
plot ([x_mr, x_mr],get(gca,'ylim'), '-.', 'Color', gray, 'linewidth',2 );

