function [Left_xCrd, Left_yCrd, Right_xCrd, Right_yCrd, xCrd_insideBox, yCrd_insideBox]...
    = Decide_lr (xCoord_r, yCoord_r, box_top, box_bottom, box_midline, box_left, box_right)

Left_xCrd= []; Left_yCrd = [];
Right_xCrd = []; Right_yCrd = [];
n_tracks = length(xCoord_r);

% count tracks between/out up and bottom left and right lines.
tracks_out_ub = 0;   tracks_out_lr = 0;  tracks_btn_ub = 0; 

for i = 1:n_tracks
    % decide if tracks are within the up_bottom boundary
    if any(yCoord_r(i, ~isnan(yCoord_r(i,:))) > box_top) && ...
            any(yCoord_r(i, ~isnan(yCoord_r(i,:))) < box_bottom)
        tracks_btn_ub = tracks_btn_ub +1;
        % decide if tracks fall into left or right
        if any(xCoord_r(i, ~isnan(xCoord_r(i,:))) >= box_left) && ...
                all(xCoord_r(i, ~isnan(xCoord_r(i,:))) <= box_midline)
            Left_xCrd(size(Left_xCrd,1)+1,:) = xCoord_r(i,:);
            Left_yCrd(size(Left_yCrd,1)+1,:) = yCoord_r(i,:);
            
        elseif any(xCoord_r(i, ~isnan(xCoord_r(i,:))) > box_midline) && ...
                any(xCoord_r(i, ~isnan(xCoord_r(i,:))) <= box_right)
            Right_xCrd(size(Right_xCrd,1)+1,:) = xCoord_r(i,:);
            Right_yCrd(size(Right_yCrd,1)+1,:) = yCoord_r(i,:);
            
        elseif all(xCoord_r(i, ~isnan(xCoord_r(i,:))) < box_left) || ...
                all(xCoord_r(i, ~isnan(xCoord_r(i,:))) > box_right)
            tracks_out_lr = tracks_out_lr + 1;
        end;
    else tracks_out_ub = tracks_out_ub + 1;
    end;
end;
tracks_btn_lr = length(Left_xCrd(:,1)) + length(Right_xCrd(:,1));

xCrd_insideBox = [Left_xCrd; Right_xCrd];
yCrd_insideBox = [Left_xCrd; Right_yCrd];