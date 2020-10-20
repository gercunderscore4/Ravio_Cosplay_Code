% test elbow bend math

clear;
more off;
clc;

r = rand() * 2
c = [rand(), rand()]
t = linspace(0, 360, 30)';
thisCircle = c + r*[cosd(t), sind(t)];

d = (1.1*r) + rand() * 10;
theta = 2*pi*rand();
p1 = d*[cos(theta) sin(theta)]

d = (1.1*r) + rand() * 10;
theta = 2*pi*rand();
p2 = d*[cos(theta) sin(theta)]

[elbow1, elbow2] = getElbowBend(p1, p2, c, r);

figure(1)
clf
hold on
plot(c(1,1),  c(1,2),  'r*')
plot(thisCircle(:,1),  thisCircle(:,2),  'r')
plot(p1(1,1), p1(1,2), 'g*')
plot(p2(1,1), p2(1,2), 'b*')
plot(elbow1(:,1), elbow1(:,2), 'k')
plot(elbow2(:,1), elbow2(:,2), 'm')
axis('equal')
hold off
