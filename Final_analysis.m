%% calculate the important parameters that will be used for plotting figures. 
% Useful matrixes include antipolar_per, poleward_per, 
% ave_midzone(antipolar-moving, average from TwoPole_value), 
% ave_pole_region(antipolar-moving, average from Midzone_vaue), 
% angle_all_MT, angle_box_MT, distance_all_MT, distance_box_MT, 
% lifetime_all_MT, lifetime_box_MT, velocity_all_MT, velocity_box_MT, 

clear;
n = 3;
nbins = 23;

%% read folder
MAT_list_all = dir('*_processed.mat');
MAT_list = {};
for i = 1:length(MAT_list_all);
    if isempty(strfind(MAT_list_all(i).name, 'thumb'));
        MAT_list = [MAT_list, MAT_list_all(i).name];
    end;
end;
fprintf('Load all mat files from current directory\n');


%% Loop through all mat files  in the folder
for num = 1:length(MAT_list_all)
    filename = MAT_list_all(num).name;
    Data = load (filename);
    mat_name = filename(1:end-14); 
    [p_M_nj, p_N_nj] = ...
    bin_assign (Data.antipolar_x1_adj, Data.poleward_x1_adj, nbins, mat_name);

    antipolar_per (:,num) = p_M_nj;
    poleward_per (:,num) = p_N_nj;
    
    velocity_all_MT {num,1} = Data.All_MT.vel_means;
    distance_all_MT {num,1} = Data.All_MT.dist_sum; 
    angle_all_MT {num,1} = Data.All_MT.angle_flipped; 
    lifetime_all_MT {num,1} = Data.All_MT.life_times; 
    
    velocity_box_MT {num,1} = Data.Box_MT.vel_means;
    distance_box_MT {num,1} = Data.Box_MT.dist_sum; 
    angle_box_MT {num,1} = Data.Box_MT.angle_flipped; 
    lifetime_box_MT {num,1} = Data.Box_MT.life_times; 
    
    bin_num = length(p_M_nj);
    half = bin_num/2;
    TwoPole_value = [antipolar_per(1:n,:); antipolar_per(end-n+1:end,:)]; % two columns because of two poles
    ave_pole_region (num,:) = mean(TwoPole_value(:));  
    
    Midzone_value = antipolar_per(half - n/2+1 : half + n/2, :); 
    ave_midzone (num,:) = mean(Midzone_value(:));
    clear ('Data'); 
    fprintf('num = %d, filename is %s\n', num, mat_name);
end;

save('Parameter_Analysis'); 
close all; 