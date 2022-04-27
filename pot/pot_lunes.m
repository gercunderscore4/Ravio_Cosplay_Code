% split a cylindrical shape into lunes
% input curve is assumed to be along an edge between lunes
clear;
%clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER INPUTS

d = 30;   % max diameter in cm
m = 8;   % number of lunes
z = 90;  % accurate curves
curved = false; % false = flat material like cardboard
                % true = bendable EVA foam

p = [0        ,                              1.5* sind(-40);
     cosd(-40),                              1.5* sind(-40);
     cosd(-10),                              1.5* sind(-10);
     cosd( 10),                              1  * sind( 10);
     cosd( 40),                              1  * sind( 40);
     cosd( 50),                              1  * sind( 50);
     %cosd( 50) + 0.15*(cosd(-40)-cosd(-40)), 1  * sind( 50) + 0.15*(sind(-40)-sind(-40));
     cosd( 50) + 0.15*(cosd(  0)-cosd(-40)), 1  * sind( 50) + 0.15*(sind(  0)-sind(-40));
     cosd( 50) + 0.15*(cosd( 45)-cosd(-40)), 1  * sind( 50) + 0.15*(sind( 45)-sind(-40));
     cosd( 50) + 0.15*(cosd( 90)-cosd(-40)), 1  * sind( 50) + 0.15*(sind( 90)-sind(-40));
     cosd( 50) + 0.15*(cosd(135)-cosd(-40)), 1  * sind( 50) + 0.15*(sind(135)-sind(-40));
     cosd( 50) + 0.15*(cosd(180)-cosd(-40)), 1  * sind( 50) + 0.15*(sind(180)-sind(-40));
     cosd( 50),                              1  * sind( 50);
     ];

connections = [1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2;
               1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2;
               1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2;
               1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2;
               1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2;
               4, 1, 1, 1, 1, 1, 1, 3, 3, 4, 4, 4;
               4, 4, 4, 1, 1, 5, 3, 3, 3, 4, 4, 4;
               4, 4, 7, 5, 5, 5, 5, 3, 3, 3, 4, 4;
               6, 7, 7, 5, 5, 5, 5, 8, 3, 6, 6, 4;
               6, 7, 7, 7, 7, 8, 8, 8, 8, 6, 6, 6;
               8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8;
               ];
connections = flipud(connections);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALCULATED VALUES

c = pi*d;
r = d/2;

x = p(:,1);
y = p(:,2);
n = numel(x);
% scale
s = r / max(x);
x = s * x;
y = s * y;

phi = 2 * pi / m;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3D PARTS

x3 = NaN * ones((n + 1)*m + (m+2)*n, 1);
z3 = NaN * ones((n + 1)*m + (m+2)*n, 1);
y3 = NaN * ones((n + 1)*m + (m+2)*n, 1);
% vertical
for ii = 1:m
    offset = (n+1)*(ii-1);
    indices = offset + (1:n);
    theta = phi * (ii - 1);
    x3(indices) = x * sin(theta);
    z3(indices) = x * cos(theta);
    y3(indices) = y;
end
% horizontal
for ii = 1:n
    offset = (n + 1)*m + (m+1)*(ii-1);
    indices = offset + (1:m+1);
    theta = linspace(0,2*pi,m+1);
    x3(indices) = x(ii) * sin(theta);
    z3(indices) = x(ii) * cos(theta);
    y3(indices) = y(ii) * ones(m+1,1);
end

% squares for one lune
x3s = NaN*ones(1,(n-1)*6);
y3s = NaN*ones(1,(n-1)*6);
z3s = NaN*ones(1,(n-1)*6);
for ii = 1:n-1
    x3s((ii-1)*6 + 1) =  x(ii + 0) * sin(0);
    x3s((ii-1)*6 + 2) =  x(ii + 0) * sin(phi);
    x3s((ii-1)*6 + 3) =  x(ii + 1) * sin(phi);
    x3s((ii-1)*6 + 4) =  x(ii + 1) * sin(0);
    x3s((ii-1)*6 + 5) =  x(ii + 0) * sin(0);

    y3s((ii-1)*6 + 1) =  y(ii + 0);
    y3s((ii-1)*6 + 2) =  y(ii + 0);
    y3s((ii-1)*6 + 3) =  y(ii + 1);
    y3s((ii-1)*6 + 4) =  y(ii + 1);
    y3s((ii-1)*6 + 5) =  y(ii + 0);

    z3s((ii-1)*6 + 1) =  x(ii + 0) * cos(0);
    z3s((ii-1)*6 + 2) =  x(ii + 0) * cos(phi);
    z3s((ii-1)*6 + 3) =  x(ii + 1) * cos(phi);
    z3s((ii-1)*6 + 4) =  x(ii + 1) * cos(0);
    z3s((ii-1)*6 + 5) =  x(ii + 0) * cos(0);
end
y3s = y3s - min(y);

% squares for all lunes (complete)
lxfs = numel(x3s);
xfsc = [];
yfsc = [];
zfsc = [];
for jj = 1:m
    theta = jj * phi;
    for ii = 1:n-1
        x3sc((jj-1)*lxfs + (ii-1)*6 + 1) =  x(ii + 0) * sin(theta + 0);
        x3sc((jj-1)*lxfs + (ii-1)*6 + 2) =  x(ii + 0) * sin(theta + phi);
        x3sc((jj-1)*lxfs + (ii-1)*6 + 3) =  x(ii + 1) * sin(theta + phi);
        x3sc((jj-1)*lxfs + (ii-1)*6 + 4) =  x(ii + 1) * sin(theta + 0);
        x3sc((jj-1)*lxfs + (ii-1)*6 + 5) =  x(ii + 0) * sin(theta + 0);
    
        y3sc((jj-1)*lxfs + (ii-1)*6 + 1) =  y(ii + 0);
        y3sc((jj-1)*lxfs + (ii-1)*6 + 2) =  y(ii + 0);
        y3sc((jj-1)*lxfs + (ii-1)*6 + 3) =  y(ii + 1);
        y3sc((jj-1)*lxfs + (ii-1)*6 + 4) =  y(ii + 1);
        y3sc((jj-1)*lxfs + (ii-1)*6 + 5) =  y(ii + 0);
    
        z3sc((jj-1)*lxfs + (ii-1)*6 + 1) =  x(ii + 0) * cos(theta + 0);
        z3sc((jj-1)*lxfs + (ii-1)*6 + 2) =  x(ii + 0) * cos(theta + phi);
        z3sc((jj-1)*lxfs + (ii-1)*6 + 3) =  x(ii + 1) * cos(theta + phi);
        z3sc((jj-1)*lxfs + (ii-1)*6 + 4) =  x(ii + 1) * cos(theta + 0);
        z3sc((jj-1)*lxfs + (ii-1)*6 + 5) =  x(ii + 0) * cos(theta + 0);
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FLAT PARTS

xf = x * sin(phi/2);
yf = ones(size(xf));
yc = 0;
for ii = 1:n-1
    yf(ii) = yc;
    dy = y(ii+1) - y(ii);
    dx = x(ii+1) - x(ii);
    yc = yc + sqrt(dy*dy + dx*dx);
end
yf(n) = yc;

% squares for one lune
xfs = NaN*ones(1,(n-1)*6);
yfs = NaN*ones(1,(n-1)*6);
for ii = 1:n-1
    xfs((ii-1)*6 + 1) =  xf(ii + 0);
    xfs((ii-1)*6 + 2) = -xf(ii + 0);
    xfs((ii-1)*6 + 3) = -xf(ii + 1);
    xfs((ii-1)*6 + 4) =  xf(ii + 1);
    xfs((ii-1)*6 + 5) =  xf(ii + 0);

    yfs((ii-1)*6 + 1) =  yf(ii + 0);
    yfs((ii-1)*6 + 2) =  yf(ii + 0);
    yfs((ii-1)*6 + 3) =  yf(ii + 1);
    yfs((ii-1)*6 + 4) =  yf(ii + 1);
    yfs((ii-1)*6 + 5) =  yf(ii + 0);
end

% bottom corner in 0,0
xfs = xfs - min(xfs);
yfs = yfs - min(yfs);
dxfs = max(xfs);

% squares for all lunes (complete)
lxfs = numel(xfs);
xfsc = [];
yfsc = [];
for ii = 0:m-1
    xfsc = [xfsc, xfs + (dxfs*ii)];
    yfsc = [yfsc, yfs            ];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BREAK APART

if (size(connections, 1) == m) && (size(connections, 2) == n)
    connections = connections(:); % flatten
    uniqueIds = unique(connections);
    idCount = numel(uniqueIds);
    pieces = cell(idCount,1);
    for ii = 1:idCount
        pieces{ii} = find(connections == uniqueIds(ii));
    end
    
    colors = zeros(idCount, 3);
    for ii = 1:idCount
        colors(ii,:) = hsv2rgb([(ii-1)/idCount, 0.9, 0.6]);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3D PLOT

if false
    figure(1);
    clf;
    hold on;
    
    plot3(x3, z3, y3, 'k');
    
    view([45 30]);
    axis('equal');
    axis('off');
    hold off;
    
    %saveas(1, 'pot_wireframe.svg')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FLAT LUNE PLOT

if false
    figure(2);
    clf;
    hold on;
    
    plot(xf, yf, 'k');
    
    axis('equal');
    hold off;
    
    %saveas(1, 'pot_flat.svg')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FLAT LUNES ON SHEET PLOT

if true
    figure(3);
    clf;
    hold on;
    
    ii = 1:numel(xfsc)/m;
    plot(xfsc(ii), yfsc(ii), 'k');

    %plot(xfsc, yfsc, 'k');

    %for ii = 1:numel(pieces)
    %    pieceIDs = pieces{ii};
    %    pieceColor = colors(ii,:);
    %    for jj = 1:numel(pieceIDs)
    %        ind = (pieceIDs(jj)-1)*6;
    %        fill(xfsc(ind+1:ind+4), yfsc(ind+1:ind+4), pieceColor);
    %    end
    %end

    axis('equal');
    hold off;
    
    %saveas(1, 'pot_flat.svg')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BROKEN PLOT

if false
    figure(4);
    clf;
    hold on;
    
    %plot(xfsc, yfsc, 'k');
    centerOfPot = [0, 0, (max(y) / 2)];
    for ii = 1:numel(pieces)
        pieceIDs = pieces{ii};
        pieceColor = colors(ii,:);

        xMid = 0;
        zMid = 0;
        yMid = 0;
        for jj = 1:numel(pieceIDs)
            ind = (pieceIDs(jj)-1)*6;
            xMid = xMid + sum(x3sc(ind+1:ind+4));
            zMid = zMid + sum(z3sc(ind+1:ind+4));
            yMid = yMid + sum(y3sc(ind+1:ind+4));
        end
        xMid = xMid / (4 * numel(pieceIDs));
        zMid = zMid / (4 * numel(pieceIDs));
        yMid = yMid / (4 * numel(pieceIDs));
        xMid = 0.3*d * xMid / norm([xMid, zMid, yMid], 2);
        zMid = 0.3*d * zMid / norm([xMid, zMid, yMid], 2);
        yMid = 0.3*d * yMid / norm([xMid, zMid, yMid], 2);

        for jj = 1:numel(pieceIDs)
            ind = (pieceIDs(jj)-1)*6;
            plot3(x3sc(ind+1:ind+5) + xMid, 
                  z3sc(ind+1:ind+5) + zMid, 
                  y3sc(ind+1:ind+5) + yMid, 
                  'Color', pieceColor,
                  'LineWidth', 2.0);
        end
    end
    
    axis('equal');
    hold off;
    
    %saveas(1, 'pot_broken.svg')
end
