% split a sphere into lunes (outside of the wedge)
clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER INPUTS

% pick one
%c = 100; % circumference
%r = 1; % radius
d = 10; % diameter

n = 6;  % points in curves
m = 4;   % number of lunes % number based on Skyward Sword
q = m;   % number of lunes to display
z = 90;  % accurate curves

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CAULCULATED VALUES

if exist('c', 'var') && ~exist('r', 'var') && ~exist('d', 'var')
    r = c / (2 * pi);
    d = r * 2;
elseif ~exist('c', 'var') && exist('r', 'var') && ~exist('d', 'var')
    d = r * 2;
    c = r * (2 * pi);
elseif ~exist('c', 'var') && ~exist('r', 'var') && exist('d', 'var')
    r = d / 2;
    c = r * (2 * pi);
else
    disp('ERROR: Sphere is overdefined.')
    disp('PICK 1: c, r, d')
end

phi = 2 * pi / m;

nr = r * sin(phi / 2);
theta = linspace(-pi/2, pi/2, n+1);

tx = nr * cos(theta);
ty = linspace(-c/4, c/4, n+1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LUNE CURVES

x = nr * cos(linspace(-pi/2, pi/2, z));
y = linspace(-c/4, c/4, z);

x = [x, -fliplr(x)];
y = [y,  fliplr(y)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INTERIOR LINES

x2 = [tx ; -tx; NaN * ones(size(tx))];
x2 = x2(:);
y2 = repelem(ty,3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EXTERIOR LINES

total_visible_width = q * 2 * nr;

x3 = repmat([0 1 NaN]*total_visible_width, n + 1);
y3 = repelem(ty, 3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRINT

lune_width = (2 * nr) / 2.54;

disp('width list')
blarg = tx' * 2 / 2.54;
for ii = blarg
    fprintf('%10.2f\n', ii);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT

figure(1);
clf;
hold on;

for ii = 1:q
    % lune
    plot((ii - 0.5) * 2 * nr + x,  y,  'k');
    % lines interior to lune
    plot((ii - 0.5) * 2 * nr + x2, y2, 'b');
end

% draw lines across
plot(x3, y3, 'b');

% border
plot([0 0 1 1 0]*total_visible_width, [-1 1 1 -1 -1]*c/4, 'k');
fprintf('Border height: %f\n', c/2)

% cut line
plot([0 1]*total_visible_width, [1 1]*(c/4 * 2/9), 'r');

axis('equal');
axis('off');
hold off;

saveas(1, 'orb_sphere_pattern.svg')

