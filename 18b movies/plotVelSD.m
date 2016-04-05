%% Description
% This script plot the velocity and SD from curve fitting data of Neg2 and
% Kif18B in correspoinding subspindle locations. It's using the errobar (X,
% Y, E) to plot X as position, Y as Velocity and E as SD. 
fontsize = 12; 
load Position_Analysis.mat; 
%% velocity

figure ()  
hold on;
positions = [ 1 2 4 5 7 8 ];
Y = [ Neg2_aster_lr_sta.vl_gof.Mean;  Kif18B_aster_lr_sta.vl_gof.Mean;...
      Neg2_aster_ub_sta.vl_gof.Mean;  Kif18B_aster_ub_sta.vl_gof.Mean;...
      Neg2_spindle_half_sta.vl_gof.Mean;  Kif18B_spindle_half_sta.vl_gof.Mean ];
E = [ Neg2_aster_lr_sta.vl_gof.SD;  Kif18B_aster_lr_sta.vl_gof.SD;...
      Neg2_aster_ub_sta.vl_gof.SD;  Kif18B_aster_ub_sta.vl_gof.SD;...
      Neg2_spindle_half_sta.vl_gof.SD;  Kif18B_spindle_half_sta.vl_gof.SD ] ;

h = errorbar( positions, Y, E,'*', 'linewidth', 1 ); 
ylim ([4 14]);
set( gca,'xtick',[ 1 2 4 5 7 8 ] ); 
set( gca,'xticklabel', {'Neg2 aster lr', 'Kif18B aster lr', ...
    'Neg2 aster ub', 'Kif18B aster ub', 'Neg2 spindle 0.6', ...
    'Kif18B spindle 0.6'}, 'fontsize',fontsize, 'fontname', 'arial' );
xticklabel_rotate([],45,[],'Fontsize',fontsize, 'fontname', 'arial');
errorbar_tick( h, 40 );
ylabel( 'Mean velocity with SD', 'fontsize',fontsize, 'fontname', 'arial' )
print_save_figure( gcf, 'Mean_velocity_SD', 'Statistics' );