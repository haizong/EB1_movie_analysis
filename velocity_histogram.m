load ('Parameter_Analysis.mat'); 

velocity_box_MT_matrix = []; 
for i = 1:length(velocity_box_MT)
    velocity_box_MT_matrix = [velocity_box_MT_matrix;velocity_box_MT{i}]; 
end

mean_vel_box = mean(velocity_box_MT_matrix); 
sd_vel_box = std(velocity_box_MT_matrix);
num_box = length(velocity_box_MT_matrix); 

velocity_all_MT_matrix = []; 
for i = 1:length(velocity_all_MT)
    velocity_all_MT_matrix = [velocity_all_MT_matrix;velocity_all_MT{i}]; 
end

mean_vel_all = mean(velocity_all_MT_matrix); 
sd_vel_all = std(velocity_all_MT_matrix);
num_all = length(velocity_all_MT_matrix); 


figure(); hold on
subplot (2,2,1)
hist (velocity_box_MT_matrix, -1:2:30);
set(gca, 'XTick', 0:4:30);
xlabel('Velocity ($\mu$m/min)','fontsize', 12, 'interpreter','latex', 'Fontname', 'arial');
ylabel('Number of EB1 Tracks', 'fontsize', 12, 'Fontname', 'arial');
xlim([0,30]);
title ('Histogram of MT velocity within the box'); 
annotation('textbox',...
    [0.3 0.8 0.1 0.1],...
    'String',{['ave = ' num2str(mean_vel_box)],['std =' num2str(sd_vel_box)],...
    ['num =' num2str(num_box)]});

subplot (2,2,2)
hist (velocity_all_MT_matrix, -1:2:30);
set(gca, 'XTick', 0:4:30);
xlabel('Velocity ($\mu$m/min)','fontsize', 12, 'interpreter','latex', 'Fontname', 'arial');
ylabel('Number of EB1 Tracks', 'fontsize', 12, 'Fontname', 'arial');
xlim([0,30]);
title ('Histogram of MT velocity from all MTs'); 
annotation('textbox',...
    [0.75 0.8 0.1 0.1],...
    'String',{['ave = ' num2str(mean_vel_all)],['std =' num2str(sd_vel_all)],...
    ['num =' num2str(num_all)]});

print_save_figure(gcf, 'Histogram_of velocity_box MTs');
save ('Parameter_analysis_with_vel_hist.mat');