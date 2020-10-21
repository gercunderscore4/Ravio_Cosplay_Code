function [cwAngle, ccwAngle] = getTangentialLineToCircle(point, center, radius)
    vec = point - center;
    angle = atan2d(vec(2), vec(1));
    d = norm(vec);
    len = sqrt(d^2 - radius^2);
    % sind(theta)/len == sind(90)/d
    % sind(theta) == sind(90)*len/d
    % theta == asind(len/d)
    theta = asind(len/d);
    cwAngle  = mod(angle - theta, 360.0);
    ccwAngle = mod(angle + theta, 360.0);
end
