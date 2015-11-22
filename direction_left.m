function [antipolar_x1,antipolar_y1, antipolar_xCrd, antipolar_yCrd, ...
    poleward_x1,poleward_y1, poleward_xCrd, poleward_yCrd] = ...
    direction_left (track_ang, xCrd, yCrd)

antipolar_x1 = []; 
antipolar_y1 = []; 
antipolar_xCrd = []; 
antipolar_yCrd = [];
poleward_x1 = [];  
poleward_y1 = [];   
poleward_xCrd = [];  
poleward_yCrd = [];

for i = 1:size(track_ang,1)
    if  track_ang (i,6) >= -90 && track_ang (i,6) <= 90
        antipolar_x1(size(antipolar_x1,1)+1,1) =  track_ang (i,1);
        antipolar_y1(size(antipolar_y1,1)+1,1) =  track_ang (i,2);
        antipolar_xCrd(size(antipolar_xCrd,1)+1,:) = xCrd(i,:);  % rotated Crd in A or B
        antipolar_yCrd(size(antipolar_yCrd,1)+1,:) = yCrd(i,:);
    else
        poleward_x1(size(poleward_x1,1)+1,1) =  track_ang (i,1);
        poleward_y1(size(poleward_y1,1)+1,1) =  track_ang (i,2);
        poleward_xCrd(size(poleward_xCrd,1)+1,:) = xCrd(i,:);
        poleward_yCrd(size(poleward_yCrd,1)+1,:) = yCrd(i,:);
    end;
end;
