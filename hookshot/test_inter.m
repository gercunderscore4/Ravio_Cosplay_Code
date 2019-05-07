clear;
clc;

N = 20;

figure(1);
while 1
    clf;
    R = rand(1,8);
    intercept = cheap_intersection(R(1:2), R(3:4), R(5:6), R(7:8));
    hold on;
    plot(R(1:2:3), R(2:2:4))
    plot(R(5:2:7), R(6:2:8))
    plot(intercept(1), intercept(2), '*')
    hold off
    input('');
end

