% Description: 
% This code calculates the percentage of change in Kif18B compared to Neg2.
% change (%) = (Kif18B - Neg2)/Neg2 * 100
clc; clear; 
relativeChange = []; 
load Position_Analysis.mat; 
load('Neg2_total_sta.mat')
load('Kif18B_total_sta.mat'); 
%% lifetimes
% All tracks
relativeChange.lt_total_Neg2_Tau = Neg2_total_sta.lifetime.lt_gof.Tau; 
relativeChange.lt_total_Kif18B_Tau = Kif18B_total_sta.lifetime.lt_gof.Tau;
relativeChange.lt_total_change_Tau = 100 * (Kif18B_total_sta.lifetime.lt_gof.Tau - ...
    Neg2_total_sta.lifetime.lt_gof.Tau)/Neg2_total_sta.lifetime.lt_gof.Tau; 
% Aster_lr region
relativeChange.lt_aster_lr_Neg2_Tau = Neg2_aster_lr_sta.lt_gof.Tau; 
relativeChange.lt_aster_lr_Kif18B_Tau = Kif18B_aster_lr_sta.lt_gof.Tau;
relativeChange.lt_aster_lr_change_Tau = 100 * (Kif18B_aster_lr_sta.lt_gof.Tau - ...
    Neg2_aster_lr_sta.lt_gof.Tau)/ Neg2_aster_lr_sta.lt_gof.Tau; 
% Aster_ub region
relativeChange.lt_aster_ub_Neg2_Tau = Neg2_aster_ub_sta.lt_gof.Tau; 
relativeChange.lt_aster_ub_Kif18B_Tau = Kif18B_aster_ub_sta.lt_gof.Tau;
relativeChange.lt_aster_ub_change_Tau = 100 * (Kif18B_aster_ub_sta.lt_gof.Tau - ...
    Neg2_aster_ub_sta.lt_gof.Tau)/ Neg2_aster_ub_sta.lt_gof.Tau;
% Spindle half region
relativeChange.lt_spindle_half_Neg2_Tau = Neg2_spindle_half_sta.lt_gof.Tau; 
relativeChange.lt_spindle_half_Kif18B_Tau = Kif18B_spindle_half_sta.lt_gof.Tau; 
relativeChange.lt_spindle_half_change_Tau = 100 * (Kif18B_spindle_half_sta.lt_gof.Tau - ...
    Neg2_spindle_half_sta.lt_gof.Tau)/ Neg2_spindle_half_sta.lt_gof.Tau;

%% Velocity
% All tracks
relativeChange.vl_total_Neg2_Mean = Neg2_total_sta.velocity.vl_gof.Mean; 
relativeChange.vl_total_Kif18B_Mean = Kif18B_total_sta.velocity.vl_gof.Mean;
relativeChange.vl_total_change_Mean = 100 * (Kif18B_total_sta.velocity.vl_gof.Mean - ...
    Neg2_total_sta.velocity.vl_gof.Mean)/Neg2_total_sta.velocity.vl_gof.Mean; 
% Aster_lr region
relativeChange.vl_aster_lr_Neg2_Mean = Neg2_aster_lr_sta.vl_gof.Mean; 
relativeChange.vl_aster_lr_Kif18B_Mean = Kif18B_aster_lr_sta.vl_gof.Mean;
relativeChange.vl_aster_lr_change_Mean = 100 * (Kif18B_aster_lr_sta.vl_gof.Mean - ...
    Neg2_aster_lr_sta.vl_gof.Mean)/ Neg2_aster_lr_sta.vl_gof.Mean; 
% Aster_ub region
relativeChange.vl_aster_ub_Neg2_Mean = Neg2_aster_ub_sta.vl_gof.Mean; 
relativeChange.vl_aster_ub_Kif18B_Mean = Kif18B_aster_ub_sta.vl_gof.Mean;
relativeChange.vl_aster_ub_change_Mean = 100 * (Kif18B_aster_ub_sta.vl_gof.Mean - ...
    Neg2_aster_ub_sta.vl_gof.Mean)/ Neg2_aster_ub_sta.vl_gof.Mean;
% Spindle half region
relativeChange.vl_spindle_half_Neg2_Mean = Neg2_spindle_half_sta.vl_gof.Mean; 
relativeChange.vl_spindle_half_Kif18B_Mean = Kif18B_spindle_half_sta.vl_gof.Mean; 
relativeChange.vl_spindle_half_change_Mean = 100 * (Kif18B_spindle_half_sta.vl_gof.Mean - ...
    Neg2_spindle_half_sta.vl_gof.Mean)/ Neg2_spindle_half_sta.vl_gof.Mean;

%% SD
% All tracks
relativeChange.vl_total_Neg2_SD = Neg2_total_sta.velocity.vl_gof.SD; 
relativeChange.vl_total_Kif18B_SD = Kif18B_total_sta.velocity.vl_gof.SD;
relativeChange.vl_total_change_SD = 100 * (Kif18B_total_sta.velocity.vl_gof.SD - ...
    Neg2_total_sta.velocity.vl_gof.SD)/Neg2_total_sta.velocity.vl_gof.SD; 
% Aster_lr region
relativeChange.vl_aster_lr_Neg2_SD = Neg2_aster_lr_sta.vl_gof.SD; 
relativeChange.vl_aster_lr_Kif18B_SD = Kif18B_aster_lr_sta.vl_gof.SD;
relativeChange.vl_aster_lr_change_SD = 100 * (Kif18B_aster_lr_sta.vl_gof.SD - ...
    Neg2_aster_lr_sta.vl_gof.SD)/ Neg2_aster_lr_sta.vl_gof.SD; 
% Aster_ub region
relativeChange.vl_aster_ub_Neg2_SD = Neg2_aster_ub_sta.vl_gof.SD; 
relativeChange.vl_aster_ub_Kif18B_SD = Kif18B_aster_ub_sta.vl_gof.SD;
relativeChange.vl_aster_ub_change_SD = 100 * (Kif18B_aster_ub_sta.vl_gof.SD - ...
    Neg2_aster_ub_sta.vl_gof.SD)/ Neg2_aster_ub_sta.vl_gof.SD;
% Spindle half region
relativeChange.vl_spindle_half_Neg2_SD = Neg2_spindle_half_sta.vl_gof.SD; 
relativeChange.vl_spindle_half_Kif18B_SD = Kif18B_spindle_half_sta.vl_gof.SD; 
relativeChange.vl_spindle_half_change_SD = 100 * (Kif18B_spindle_half_sta.vl_gof.SD - ...
    Neg2_spindle_half_sta.vl_gof.SD)/ Neg2_spindle_half_sta.vl_gof.SD;

%% save
save ( 'relativeChange', 'relativeChange' );