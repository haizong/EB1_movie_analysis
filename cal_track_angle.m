function [track_ang] = cal_track_angle (xCrd, yCrd)

% This functiion calculate the angle between each track with the horizontal
% line using atan2. The angle takes in the mean of 2:end x, y crd subtracted by 
% the first x, y crd. 
% The data format is a n * 6 matrix. Columns 1:first xcrd;  2:first yCrd; 
% 3: mean of xCrd excluding the first; 4: mean of yCrd excluding the first one;
% 5: radian of tracks   6: degree of tracks
% by HZ, Aug 2015, Bloomington

track_ang = zeros(length(xCrd), 6); 
for i = 1:size(xCrd,1);
    xCrd_nan = xCrd(i,~isnan(xCrd(i,:)));
    yCrd_nan = yCrd(i,~isnan(yCrd(i,:)));
    track_ang (i,1) = xCrd_nan(1);
    track_ang (i,2) = yCrd_nan(1);
    track_ang (i,3) = mean(xCrd_nan(2:end));
    track_ang (i,4) = mean(yCrd_nan(2:end));
    track_ang (i,5) = atan2(track_ang (i,4)-track_ang (i,2), track_ang (i,3)-track_ang (i,1));
    track_ang (i,6) = track_ang (i,5) * 180 /pi;
end;  