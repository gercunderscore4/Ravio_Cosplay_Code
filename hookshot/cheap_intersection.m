function intercept = cheap_intersection(p1, p2, p3, p4)
    EPSILON = 1E-5;
    
    v21 = p2 - p1;
    v43 = p4 - p3;
    n21 = [-v21(2), v21(1)];
    n43 = [-v43(2), v43(1)];
    du = dot(v43/norm(v43), n21/norm(n21));
    if abs(du) > EPSILON
        t = dot(p1 - p3, n21) / dot(v43, n21);
        s = dot(p3 - p1, n43) / dot(v21, n43);
        if (0 <= t) && (t <= 1) && (0 <= s) && (s <= 1)
            intercept = p3 + (v43 * t);
        else 
            intercept = [NaN, NaN];
        end
    else
        disp('WARNING: Lines are parallel/colinear.')
        intercept = [NaN, NaN];
    end
    
end
