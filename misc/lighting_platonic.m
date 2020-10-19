close all
clear all
clear
clc

DEG = pi/180;

function rho = luminosity_func(theta)
    rho = cosd(theta) .* [theta>-90] .* ([theta<90] + [theta>270]);;
end

% light pattern, copy to for-loops below
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
d = 1;

% tetrahedral points (self similar, so put lights on a larger tetrahedron)
p = d * [ sqrt(8/9),          0, -1/3;
         -sqrt(2/9),  sqrt(2/3), -1/3;
         -sqrt(2/9), -sqrt(2/3), -1/3;
                  0,          0,    1];

% octahedral points (put lights on an cube)
%p = d * [-1,  0,  0;
%          1,  0,  0;
%          0, -1,  0;
%          0,  1,  0;
%          0,  0, -1;
%          0,  0,  1];

% cubic points (put lights on an octahedron)
%p = d * (1/sqrt(3)) * [-1, -1, -1;
%                       -1, -1,  1;
%                       -1,  1, -1;
%                       -1,  1,  1;
%                        1, -1, -1;
%                        1, -1,  1;
%                        1,  1, -1;
%                        1,  1,  1];

% point source for debug
%p = d * [1 0 0];

n = size(p,1);

figure();
hold on
plot3(p(:,1), p(:,2), p(:,3), 'k-')
plot3(p(:,1), p(:,2), p(:,3), 'k*')
hold off
axis equal
axis off

% for each point on sphere
for ii = 1:size(x_shell,1)
    for jj = 1:size(x_shell,2)
        % for each point of light
        for kk = 1:n
            u1 = p(kk,:);
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
