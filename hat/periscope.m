% designing periscope glasses for hat
clear
clc

% eye
focal = [1 0]';
theta = 45 + [0:90]; % deg
worked = zeros(size(theta));

% mirror 1
m1 = [1 2]';
w1 = 1.0;
a1 = 45; % deg
[p1, v1] = get_point_and_vector(m1, w1, a1);
n1 = [v1(2) -v1(1)]';
n1 = n1 / norm(n1);
l1 = [p1, p1+v1];

% mirror 2
m2 = [2 2]';
w2 = 2.0;
a2 = 45; % deg
[p2, v2] = get_point_and_vector(m2, w2, a2);
n2 = [v2(2) -v2(1)]';
n2 = n2 / norm(n2);
l2 = [p2, p2+v2];

% gap
m3 = [2 4]';
w3 = 2;
a3 = 0; % deg
[p3, v3] = get_point_and_vector(m3, w3, a3);
n3 = [v3(2) -v3(1)]';
n3 = n3 / norm(n3);
l3 = [p3, p3+v3];

p = [];
for ii = 1:length(theta)
    % detect if it hits mirror 1
    p4 = focal;
    v4 = [cosd(theta(ii)) sind(theta(ii))]';
    r = intersect_value_for_line_and_segment(p4, v4, p1, v1);
    if ~isnan(r)
        p5 = p1 + r * v1;
        v5 = v4 - 2 * n1 * dot(n1,v4);
        r = intersect_value_for_line_and_segment(p5, v5, p2, v2);
        if ~isnan(r)
            p6 = p2 + r * v2;
            v6 = v5 - 2 * n2 * dot(n2,v5);
            r = intersect_value_for_line_and_segment(p6, v6, p3, v3);
            if ~isnan(r)
                p7 = p3 + r * v3;
                p8 = p7 + 5 * v6;
                p = [p, [NaN;NaN], p4, p5, p6, p7, p8];
                worked(ii) = 1;
            end
        end
    end
end

figure(1);
clf;
hold on;
plot(focal(1,:), focal(1,:), '*b')
plot(l1(1,:), l1(2,:), 'k')
plot(l2(1,:), l2(2,:), 'k')
plot(l3(1,:), l3(2,:), 'k')
plot(p(1,:), p(2,:), 'r')

plot(-focal(1,:), focal(1,:), '*b')
plot(-l1(1,:), l1(2,:), 'k')
plot(-l2(1,:), l2(2,:), 'k')
plot(-l3(1,:), l3(2,:), 'k')
plot(-p(1,:), p(2,:), 'r')
axis('equal')
hold off;

