% go to the designated folder. Load parameter_analysis.mat. make histogram
% of velocity mean of all MT tracks. 

load ('Parameter_Analysis.mat'); 

vel = []; 
for i = 1: length(velocity_all_MT)
vel = [vel; velocity_all_MT{i}]; 
end; 

mean_vel = mean(vel); 
sd_vel = std(vel);
n_tracks = length(vel); 

hist (vel);
xlabel('Velocity (um/min)','fontsize', 12, 'Fontname', 'arial');
ylabel('Number of EB1 tracks', 'fontsize', 12, 'Fontname', 'arial');
xlim([0,30]);
annotation('textbox',...
    [0.75 0.8 0.1 0.1],...
    'String',{['ave = ' num2str(mean_vel)], ['std =' num2str(sd_vel)], ...
    ['num =' num2str(n_tracks)]}, 'EdgeColor',[1 1 1]);

