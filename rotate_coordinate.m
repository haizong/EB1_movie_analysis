function [x_rot_shift, y_rot_shift] = rotate_coordinate(x, y, theta, center)

% shift points in the plane so that the center of rotation is at the origin
x_shift = x - center(1);
y_shift = y - center(2);

% apply the rotation about the origin
x_rot = x_shift*cos(theta) + y_shift*sin(theta);
y_rot = -x_shift*sin(theta) + y_shift*cos(theta);

% shift again so the origin goes back to the desired center of rotation
x_rot_shift = x_rot + center(1);
y_rot_shift = y_rot + center(2); 

