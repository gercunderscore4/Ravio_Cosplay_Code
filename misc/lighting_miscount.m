close all
clear all
clear
clc

DEG = pi/180;

% light pattern, copy to for-loops below
function rho = luminosity_func(theta)
    rho = cosd(theta) .* [theta>-90] .* ([theta<90] + [theta>270]);;
end
lum_theta = -180:180;
lum_rho = luminosity_func(lum_theta);

r_shell = 5;
[x_shell, y_shell, z_shell] = sphere;
x_shell = x_shell * r_shell;
y_shell = y_shell * r_shell;
z_shell = z_shell * r_shell;
h_shell = zeros(size(x_shell));

% n points, spread out evenly like on the vertices of a platonic solid
% direction the point to is same as their angle from the center
% number and distance from center is the only factor, "d"
r_light = 4.9;

N = 40;
N_count = 0;
p = zeros(N,3); % estimates size
a = 4 * pi / N;
d = sqrt(a);
M_theta = round(pi/d);
d_theta = pi / M_theta;
d_phi = a / d_theta;
for m = 0:(M_theta-1)
    theta = pi*(m+0.5) / M_theta;
    M_phi = round(2*pi*sin(theta) / d_phi);
    for n = 0:(M_phi-1)
        phi = 2 * pi * n / M_phi;
        N_count = N_count + 1;
        p(N_count,:) = [sin(theta)*cos(phi), sin(theta)*sin(phi), cos(theta)];
    end
end
p = p(1:N_count,:); % fix size
n = size(p,1)

p = r_light * p; % discretize to slices
p = [p(:,1), p(:,2), round(p(:,3))]; % discretize to slices

figure();
hold on
plot3(p(:,1), p(:,2), p(:,3), 'k-')
plot3(p(:,1), p(:,2), p(:,3), 'k*')
hold off
axis equal
axis off
view(0, 30)
[[1:size(p,1)]', p(:,3), atan2d(p(:,1), p(:,2))]

% for each point on sphere
for ii = 1:size(x_shell,1)
    for jj = 1:size(x_shell,2)
        % for each point of light
        for kk = 1:n
            u1 = [p(kk,1), p(kk,2), 0]; % flat
            u1 = u1 / norm(u1);
            u2 = [x_shell(ii,jj), y_shell(ii,jj), z_shell(ii,jj)] - p(kk,:);
            u2 = u2 / norm(u2);
            phi = acosd(dot(u1,u2));
            h_shell(ii,jj) = h_shell(ii,jj) + luminosity_func(phi);
        end
    end
end

figure();

subplot(2,2,1);
plot(lum_theta, lum_rho);
yticks([0:0.25:1]);
xticks([-90:30:90]);
xlim([-90 90])

subplot(2,2,2);
hold on
t = linspace(0,pi,100);
for r_tick = [0:0.25:1]
    text(r_tick, -0.1, num2str(r_tick))
    plot(r_tick*cos(t), r_tick*sin(t), 'k-')
end
for t_tick = [-90:30:90]
    text(-1.1*sind(t_tick), 1.1*cosd(t_tick), num2str(t_tick))
    plot([0, -sind(t_tick)], [0, cosd(t_tick)], 'k-')
end
plot(-lum_rho .* sin(lum_theta*DEG), lum_rho .* cos(lum_theta*DEG), 'b-')
hold off
axis equal
axis off

subplot(2,2,3);
pcolor(h_shell);
colormap jet
shading interp
caxis([0 2])
axis off
daspect([1 2 1])

subplot(2,2,4);
surf(x_shell, y_shell, z_shell, h_shell);
colormap jet
shading interp
axis equal
axis off
colorbar
caxis([0 2])
