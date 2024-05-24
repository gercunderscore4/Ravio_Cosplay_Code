% in 2D, reflect into all quadrants
function np = quad_symmetry(p)
    np = [
        p;
        NaN, NaN;
        p*[-1,0;0,1];
        NaN, NaN;
        p*[1,0;0,-1];
        NaN, NaN;
        p*[-1,0;0,-1];
    ];
end
