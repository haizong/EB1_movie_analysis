
% This script is the filter for EB1 movie analysis to throw out 
%     1. Mean intensity of detected particles within a single track is above 99th 
%        percentile of the intensity distribution of all detected particles. 
%        This is to filter out tracks associated with centrosome beads, 
%        bright aggregates and hot pixels that are not stationary because 
%        of image registration.
%     2. Tracks with lifetime longer than 1 min. 
%        This is to filter out tracks associated with less bright hot pixels.
%     3. Tracks with lifetime longer than 20 sec and with mean speed lower than 5 ?m/min. ?
%        This is to filter out tracks associated with less bright hot pixels.