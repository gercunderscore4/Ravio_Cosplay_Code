% add width to a flat drawing that is already in 3D
% "width" is oversued already, so using a synonym
function NP = add_breadth(P, v)
    % first make the lines between the layers
    % grab points, remove NaNs (breaks), copy and add the breadth vector
    % put a NaN between each
    A = P;
    A(any(isnan(A), 2), :) = [];
    B = A + v;
    C = NaN*ones(size(A));
    lines = reshape([A';B';C'], size(A,2), [])';
    NP = [
        P;
        NaN, NaN, NaN;
        P + v;
        NaN, NaN, NaN;
        lines;
    ];
end

