function intercept = cheap_intersection(A, B, C, D)
    EPSILON = 1E-5;
    
    E = B - A;
    F = D - C;
    P = [-E(2), E(1)];
    G = dot(F/norm(F), P/norm(P));
    if abs(G) > EPSILON
        h = dot(A - C, P) / G;
        if (0 <= h) && (h <= 1)
            intercept = C + F * h;
        else 
            intercept = [NaN, NaN];
        end
    else
        disp('WARNING: Lines are parallel.')
        intercept = [NaN, NaN];
    end
    
end
