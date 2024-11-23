function [p, v] = get_point_and_vector(m, w, a)
    v = w * [cosd(a) sind(a)]';
    p = m - (v / 2);
end
