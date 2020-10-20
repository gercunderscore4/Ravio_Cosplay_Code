function [elbow1, elbow2] = getElbowBend(p1, p2, c, r)
    
    [a1, a2] = getTangentialLineToCircle(p1, c, r)
    [a3, a4] = getTangentialLineToCircle(p2, c, r);

    m1 = c + r * [cosd(a1), sind(a1)];
    m2 = c + r * [cosd(a2), sind(a2)];
    m3 = c + r * [cosd(a3), sind(a3)];
    m4 = c + r * [cosd(a4), sind(a4)];
    i1 = cheap_intersection(p1, m1, m4, p2);
    i2 = cheap_intersection(p1, m2, m3, p2);

    if isnan(i1(1))
        angleRange1 = linspace(a1, a4, 30)';
        elbow1 = [
            p1;
            c + r * [cosd(angleRange1), sind(angleRange1)];
            p2;
            ];
    else
        elbow1 = [
            p1;
            i1;
            p2;
            ];
    end

    if isnan(i2(1))
        angleRange2 = linspace(a2, a3, 30)';
        elbow2 = [
            p1;
            c + r * [cosd(angleRange2), sind(angleRange2)];
            p2;
            ];
    else
        elbow2 = [
            p1;
            i2;
            p2;
            ];
    end

end