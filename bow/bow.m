clear;
clc;

% generate arc
n = 5;
l = 70;
w = l / 2;
x = linspace(-w, +w, n);
x_sq = x.**2;
f1 = 0.484 / w;
y1 = f1 * x_sq;
y1 = y1 - max(y1);

% calculate distance vs displacement of the ends
r1 = max(x) - min(x)
r2 = sum(sqrt(diff(x).**2 + diff(y1).**2))
r = r1 / r2
r * 90.0

% draw arc
figure(1);
clf;
hold on;
plot(x,y1);
hold off;
axis('equal');

% add width

% points
P = [x; y1];
size(P)
% midpoints
M = (P(:,[1 1:end]) + P(:,[1:end end])) / 2;
size(M)
% deltas
D = [diff(P(1,:)); ...
     diff(P(2,:))];
size(D)
% unit tangents
T = vecnorm(D);
size(T)
% unit normals
N = [-T(2,:); ...
      T(1,:)];
N = [0 N(1,:) 0; ...
     0 N(2,:) 0];
size(N)
% tapering algorithm
F = 5 * cos(pi*M(1,:)/w);
% put it together
Z = [M(1,:) + (F .* N(1,:)); ...
     M(2,:) + (F .* N(2,:))];

figure(2);
clf;
hold on;
plot(Z(1,:), Z(2,:))
hold off;
axis('equal');
