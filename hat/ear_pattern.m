%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER INPUTS
clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER INPUTS

%svg pattern using "c"
%( *-?\d+\.?\d*, *-?\d+\.?\d*)( *-?\d+\.?\d*, *-?\d+\.?\d*)( *-?\d+\.?\d*, *-?\d+\.?\d*)
%\1\n\2\n

xy = [  8.23389, -0.10609;
       16.00279,  1.96667;
        7.28996,  3.93624;
       14.10097,  9.73597;
        6.31814,  7.34787;
       12.14338, 16.24388;
        5.31842, 10.12880;
       10.13000, 21.49039;
        4.29081, 12.27903;
        8.06085, 25.47551;
        3.23532, 13.79857;
        5.93592, 28.19923;
        2.15194, 14.68740;
        3.75522, 29.66155;
        1.04067, 14.94554;
        1.51874, 29.86248;
       -0.09850, 14.57298;
       -0.83631, 32.43114;
       -1.21578, 20.09434;
       -2.90953, 42.42486;
       -2.01034, 23.51769;
       -4.33727, 48.22257;
       -2.48215, 24.84307;
       -5.11951, 49.82432;
       -2.63121, 24.07044;
       -5.25627, 47.23007;
       -2.45753, 21.19982;
       -4.74752, 40.43983;
       -1.96110, 16.23121;
       -3.59329, 29.45361;
       -1.14192,  9.16460;
       -1.79357, 14.27140;
      ];
%xy = [ 8.23389, -0.10609;
%      16.00279,  2.02917;
%       7.28996,  4.04562;
%      14.10097, 10.00160;
%       6.31814,  7.53537;
%      12.14338, 16.65013;
%       5.31842, 10.36318;
%      10.13000, 21.97477;
%       4.29081, 12.52903;
%       8.06085, 25.97551;
%       3.23532, 14.03294;
%       5.93592, 28.65235;
%       2.15194, 14.87490;
%       3.75522, 30.00530;
%       1.04067, 15.05491;
%       1.51874, 30.03435;
%      -0.09850, 14.57298;
%      -0.89881, 32.43114;
%      -1.32516, 20.09434;
%      -3.17516, 42.42486;
%      -2.19784, 23.51769;
%      -4.74352, 48.22257;
%      -2.71652, 24.84307;
%      -5.60388, 49.82432;
%      -2.88121, 24.07044;
%      -5.75627, 47.23007;
%      -2.69190, 21.19982;
%      -5.20064, 40.43983;
%      -2.14860, 16.23121;
%      -3.93704, 29.45361;
%      -1.25129,  9.16460;
%      -1.96544, 14.27140;
%      ];
%xy = [  0.00000 ,   0.00000;
%        0.71415 ,  -5.45055;
%        1.25130 ,  -9.76617;
%        3.03974 , -23.84794;
%        2.14860 , -17.26246;
%        4.65734 , -37.70560;
%        2.69190 , -22.48888;
%        5.56696 , -47.02351;
%        2.88121 , -25.44544;
%        5.76857 , -51.80169;
%        2.71653 , -26.13213;
%        5.26221 , -52.04014;
%        2.19784 , -24.54895;
%        4.04784 , -47.73884;
%        1.32516 , -20.69590;
%        2.12548 , -38.89781;
%        0.09850 , -14.57298;
%       -0.37958 , -28.52116;
%       -1.04075 , -13.25022;
%       -2.64419 , -25.80245;
%       -2.15225 , -11.78108;
%       -4.85331 , -22.79101;
%       -3.23602 , -10.16560;
%       -7.00699 , -19.48687;
%       -4.29205 ,  -8.40376;
%       -9.10519 , -15.89001;
%       -5.32034 ,  -6.49556;
%      -11.14791 , -12.00043;
%       -6.32091 ,  -4.44101;
%      -13.13517 ,  -7.81814;
%       -7.29374 ,  -2.24009;
%      -15.06696 ,  -3.34313;
%      ];
%xy = [0, 0;
%      3, 0;
%      2, 1;
%      3, 2;
%      3, 3;
%      3, 4;
%      3, 5;
%      2, 6;
%      ];
m = max(size(xy));
x = reshape(xy(:,1), [1,m]);
y = reshape(xy(:,2), [1,m]);
x = cumsum(x);
y = cumsum(y);
x = x - min(x);
y = max(y) - y;
x = [x, 0     ];
y = [y, y(end)];
m = length(x);

% scale
h = 30;
y = y - min(y);
f = h / max(y);
x = f * x * 0.95;
y = f * y;

n = 4;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT SILHOUETTE

%fig1 = figure(1);
%clf;
%hold on;
%plot(+x, y, 'k');
%plot(-x, y, 'k');
%axis('equal')
%hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT 3D SHAPE
k = n + 1;
t = linspace(0, 2*pi, k);
s = sin(t);
c = cos(t);
o = ones(1,k);

fig2 = figure(2);
clf;
hold on;
for ii = 1:n
    x3 = x * cos(ii * 2 * pi / n);
    y3 = x * sin(ii * 2 * pi / n);
    z3 = y;
    plot3(x3, y3, z3, 'k');
end
for ii = 1:m
    x3 = x(ii) * s;
    y3 = x(ii) * c;
    z3 = y(ii) * o;
    plot3(x3, y3, z3, 'k');
end
axis('equal')
view([1,1,1])
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UNFOLD

px = x * pi / n;

deltaL = sqrt(diff(x).^2 + diff(y).^2);
deltaPx = diff(px);
deltaPy = sqrt(deltaL.^2 .- deltaPx.^2);

py = [0 cumsum(deltaPy)];
py = max(py) - py; % flip if necessary, else comment out

% print shape height and pattern height
shape_height   = max(y)  - min(y)
pattern_height = max(py) - min(py)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT PATTERN

xSep = (max(x) + max(px)) * 2;

fig3 = figure(3);
clf;
hold on;
plot(+x, y, 'k');
plot(-x, y, 'k');
plot(xSep + px, py, 'k');
plot(xSep - px, py, 'k');
axis('equal');
axis('off');
hold off;
saveas(fig3, 'ear_pattern.svg')

