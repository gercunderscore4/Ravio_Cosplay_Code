function [cwElbow, ccwElbow] = getElbowBend(p1, p2, c, r)
    
    [a1, a2] = getTangentialLineToCircle(p1, c, r);
    [a3, a4] = getTangentialLineToCircle(p2, c, r);

    m1 = c + r * [cosd(a1), sind(a1)];
    m2 = c + r * [cosd(a2), sind(a2)];
    m3 = c + r * [cosd(a3), sind(a3)];
    m4 = c + r * [cosd(a4), sind(a4)];
    i1 = cheap_intersection(p1, m1, m4, p2);
    i2 = cheap_intersection(p1, m2, m3, p2);

    if isnan(i1(1))
        angleRange1 = flipud(a4 + linspace(0, mod(a1 - a4, 360), 30)');
        cwElbow = [
            p1;
            c + r * [cosd(angleRange1), sind(angleRange1)];
            p2;
            ];
    else
        cwElbow = [
            p1;
            i1;
            p2;
            ];
    end

    if isnan(i2(1))
        angleRange2 = a2 + linspace(0, mod(a3 - a2, 360), 30)';
        ccwElbow = [
            p1;
            c + r * [cosd(angleRange2), sind(angleRange2)];
            p2;
            ];
    else
        ccwElbow = [
            p1;
            i2;
            p2;
            ];
    end
end
