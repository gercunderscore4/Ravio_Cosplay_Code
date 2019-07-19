function [angle1 angle2] = getTangentialLineToCircle(point, center, radius)
    vec = point - center;
    angle = atan2d(vec(2), vec(1));
    d = norm(vec);
    len = sqrt(d^2 - radius^2);
    % sind(theta)/len == sind(90)/d
    % sind(theta) == sind(90)*len/d
    % theta == asind(len/d)
    theta = asind(len/d);
    angle1 = mod(angle - theta, 360.0);
    angle2 = mod(angle + theta, 360.0);
end
