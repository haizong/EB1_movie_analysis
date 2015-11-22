%% plot rotated tracks on max proj rotated image
% max proj using FIJI, load it as img_ori, rot_angle is saved in _processed
% mat file. 

imread(); 
load('.mat'); 
img_center = size(img_ori)/2;
img_maxrot = imrotate(img_ori, rot_angle, 'crop');
img_min = min(img_ori(:));
img_max = max(img_ori(:));
figure, imshow(img_maxrot, [img_min, img_max]);

antipolar_x = [A.antipolar_xCrd; B.antipolar_xCrd];
antipolar_y = [A.antipolar_yCrd; B.antipolar_yCrd];
poleward_x = [A.poleward_xCrd; B.poleward_xCrd];
poleward_y = [A.poleward_yCrd; B.poleward_yCrd];

plot_tracks (antipolar_x, antipolar_y,'y');
plot_tracks (poleward_x, poleward_y,'g');
plot_box (box_perm.top, box_perm.bottom, box_perm.left, box_perm.right, box_perm.midline);
title('Tracks on rotated image', 'fontsize',fontsize, 'fontname', 'arial');

