%% Calculate the important parameters that will be used for final figure.
% Useful matrixes include antipolar_per, poleward_per,
% ave_midzone(antipolar-moving, average from TwoPole_value),
% ave_pole_region(antipolar-moving, average from Midzone_vaue),
% angle_all_MT, angle_box_MT, distance_all_MT, distance_box_MT,
% lifetime_all_MT, lifetime_box_MT, velocity_all_MT, velocity_box_MT,
% n = 3;   average 3 bins for poles and spindle midzone
% nbins = 23;   divide the spindle into 23 bins

%%
clear;
n = 3;
nbins = 23;

%% read folder and get directory with all '*_processed.mat'
MAT_list_all = dir('*_processed.mat');
MAT_list = {};
for i = 1:length(MAT_list_all);
    if isempty(strfind(MAT_list_all(i).name, 'thumb'));
        MAT_list = [MAT_list, MAT_list_all(i).name];
    end;
end;
fprintf('Load all mat files from current directory\n');


%% Loop through all mat files in the folder, save important information (vel,dist,angle,lifetime)
for num = 1:length(MAT_list_all)
    filename = MAT_list_all(num).name;
    Data = load (filename);
    mat_name = filename(1:end-14);
    [p_M_nj, p_N_nj, M_nj, N_nj] = ... % percentage of antipolar and poleward-moving tracks
        bin_assign (Data.antipolar_x1_adj, Data.poleward_x1_adj, nbins, mat_name);
    
    antipolar_per (:,num) = p_M_nj;
    poleward_per (:,num) = p_N_nj;
    
    antipolar_num (:,num) = M_nj; 
    poleward_num (:,num) = N_nj;
    total_num (:, num) = M_nj + N_nj; 
    
    velocity_all_MT {num,1} = Data.All_MT.vel_means;
    distance_all_MT {num,1} = Data.All_MT.dist_sum;
    angle_all_MT {num,1} = Data.All_MT.angle_flipped;
    lifetime_all_MT {num,1} = Data.All_MT.life_times;
    
    velocity_box_MT {num,1} = Data.Box_MT.vel_means;
    distance_box_MT {num,1} = Data.Box_MT.dist_sum;
    angle_box_MT {num,1} = Data.Box_MT.angle_flipped;
    lifetime_box_MT {num,1} = Data.Box_MT.life_times;
    
    %% Bin lifetime based on the position of the first comet. Save lifetime and crd in a cell. 
    % lifetime is calculated: EB1_analysis_v2_0919 <- inside
    % function:cal_track_stats from xCrd_insideBox, yCrd_insideBox
    xCrd = Data.xCrd_insideBox;
    for i = 1:size(xCrd,1)
        xCrd_nan = xCrd(i,~isnan(xCrd(i,:)));
        lifetime_box_MT_xCrd1 (i,1) = xCrd_nan (1);
    end;
    lifetime_box_MT {num,2} = lifetime_box_MT_xCrd1; % position
    %% Calculate the percentage of antipolar MTs in each spindle
    bin_num = length(p_M_nj);
    half = bin_num/2;
    TwoPole_value = [antipolar_per(1:n,:); antipolar_per(end-n+1:end,:)]; % two columns because of two poles
    ave_pole_region (num,:) = mean(TwoPole_value(:));
    
    Midzone_value = antipolar_per(half - n/2+1 : half + n/2, :);
    ave_midzone (num,:) = mean(Midzone_value(:));
    clear ('Data', 'lifetime_box_MT_xCrd1', 'xCrd_nan');
    fprintf('num = %d, filename is %s\n', num, mat_name);
end;
  
%% assign lifetime a bin_index [1-23]. left pole [1-3], midzone [11-13], right pole [21-23]
  for num = 1:length(MAT_list_all)
    A = lifetime_box_MT {num,1};
    M = lifetime_box_MT {num,2};
    binEdges = linspace(min(M),max(M),nbins+1);
    [~,bin_index] = histc(M,binEdges);
    lifetime_box_MT {num,3} =bin_index;  
    
    lifetime_left_pole {num,1}= []; lifetime_right_pole {num,1}= []; lifetime_midzone{num,1} = [];
    for k = 1:length(bin_index)
        if bin_index(k,1) >= 1 && bin_index (k,1) <= 3
            lifetime_left_pole{num,1} (length(lifetime_left_pole{num,1})+1, 1) = A (k,1);
        elseif  bin_index(k,1) >= 21 && bin_index(k,1)  <= 23
            lifetime_right_pole{num,1} (length(lifetime_right_pole{num,1})+1, 1) = A (k,1);
        elseif  bin_index(k,1) >= 11 && bin_index(k,1)  <= 13
            lifetime_midzone{num,1} (length(lifetime_midzone{num,1})+1, 1) = A (k,1);
        end; 
        P =lifetime_left_pole{num,1}; Q=lifetime_right_pole{num,1}; 
        lifetime_total_pole {num,1} = [P;Q];  % combine left and right pole
    end;
  end; 

%% Save all data of lifetime in pole/midzone region in a matrix
lifetime.pole_matrix = []; 
for i = 1: length(lifetime_total_pole)
lifetime.pole_matrix = [lifetime.pole_matrix; lifetime_total_pole{i}]; 
end; 

lifetime.midzone_matrix = []; 
for i = 1: length(lifetime_midzone)
lifetime.midzone_matrix = [lifetime.midzone_matrix; lifetime_midzone{i}]; 
end; 

lifetime.pole_mean = mean(lifetime.pole_matrix);
lifetime.pole_std = std(lifetime.pole_matrix);
lifetime.midzone_mean = mean(lifetime.midzone_matrix);
lifetime.midzone_std = std(lifetime.midzone_matrix);
  %%
save('Parameter_Analysis');
close all;