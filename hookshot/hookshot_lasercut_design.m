% draw chain for hookshot
clear;
clc;
more off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER EDITABLE SETTINGS

% circle count, number of points in a calculated arc
cc = 50;

bar_length = 10; % length of each individual bar
count = 8;  % number of bar pairs
theta = 12; % angle the bars make with the horizontal when fully extended, in deg

hw = 2.54/2;   % head/nut width for bolt
sw = 2.54/3.7; % body     width for bolt
bw = 2.54/4;   % spacer   width for bolt

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERIC CIRCLE (FOR EASY PLOTTING)
U = linspace(0,90,cc)';
ca = cosd(U);
sa = flipud(ca);
% unit circle
U = [ ca, sa;
     -sa, ca;
     -ca,-sa;
      sa,-ca;
    ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BARS
w =  bar_length / 2;           % width, half of front-hole to back-hole length
t = w*sind(theta)*cosd(theta); % thickness, perpendicular to width
    
L = [0, -w;
     0,  0;
     0, +w];

% make thick version of bar
phi = 90 - theta;
d = t*tand(theta); % difference from where the front/back hole to where the curve starts
f = t*tand(2*theta);
k = t*secd(2*theta);
q = linspace(-(90 - 2*phi), +(90 - 2*phi), cc)';
P_bar = [k*(+sind(q)), -(w+d-f+k*cosd(q)); % back
         k*(-sind(q)), +(w+d-f+k*cosd(q)); % front
        ];
P_bar = [P_bar;
         P_bar(1,:);
        ];
% add holes to bars
P_bar = [P_bar;
         NaN, NaN;
         (U*bw/2 + [0,-w]); % hole at back
         NaN, NaN;
         (U*bw/2 + [0, 0]); % hole in middle
         NaN, NaN;
         (U*bw/2 + [0, w]); % hole at front
        ];

% final bar
P_end = [k*(+sind(q)), -(  d-f+k*cosd(q)); % back
         k*(-sind(q)), +(w+d-f+k*cosd(q)); % front
        ];
P_end = [P_end;
         P_end(1,:);
        ];
% add holes to bars
P_end = [P_end;
         NaN, NaN;
         (U*bw/2 + [0, 0]); % hole at back
         NaN, NaN;
         (U*bw/2 + [0,+w]); % hole in middle
        ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HANDLE

rho = w*cosd(theta);
rhi = w*sind(theta);
q = linspace(0, 180, cc)';

% slot
H = [
     ([ sa, -ca]*bw/2+ [0, rhi]);
     ([ ca,  sa]*bw/2+ [0, rho]);
     ([-sa,  ca]*bw/2+ [0, rho]);
     ([-ca, -sa]*bw/2+ [0, rhi]);
     ];
H = [H;H(1,:)];
H = [H;
     NaN,NaN;
     H(:,1),-1*H(:,2)];

% outside
M = [
      0*rhi,  0;
     +1*rhi, +(      2*t);
     +1*rhi, +(rho + 2*t);
     -5*rhi, +(rho + 2*t);
     ];
M = [M;
     flipud([M(:,1), -M(:,2)]);
     M(1,:)];

% handle hole
T = [
     ([-3*t,-(rho)]);
     ([-1*t,-(rho)]);
     ];
T = [T;
     flipud([T(:,1), -T(:,2)]);
     T(1,:)];

% put it all together
P_handle = [
            H;
            NaN,NaN;
            M;
            NaN,NaN;
            T;
            ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STABILIZER

thetatophi = linspace(theta, phi, cc)';

% outer box
% outside
M = [
     +((count * 2 + 1) * rhi), +(rho + 2*t);
     -(5 * rhi + rho),         +(rho + 2*t);
     ];
M = [M;
     flipud([M(:,1), -M(:,2)]);
     M(1,:)];

% handle hole
T = [
     ([-2*t-rhi-rho, -(rho)]);
     ([-1*t-rhi,     -(rho)]);
     ];
T = [T;
     flipud([T(:,1), -T(:,2)]);
     T(1,:)];

% stabilization lines
H = [];
for ii = 1:count
    fact = ii * 2 - 1;
    thisline = w*[fact*sind(thetatophi), cosd(thetatophi)];
    if thisline(end,1) >= max(M(:,1))
        break
    end
    
    H = [
         H; 
         thisline;
         NaN, NaN;
         ];
end
H = [H;
     flipud([H(:,1), -H(:,2)]);
     ];

P_stable = [
            M;
            NaN,NaN;
            T;
            NaN,NaN;
            H;
            ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HOOK

% need this to squeeze between the scissoring bolts
bolt_sep = 2*t*cosd(theta) - bw * 2;

% need to reach back with an open slot 
% to use other bolts for stabilization
back_reach = 2*w*cosd(theta) + bw / 2;

T = [
     ([+sa, -ca]*bw/2 + [-bw*3/2, 0]);
     ([+ca, +sa]*bw/2 + [-bw*3/2, 0]);
     -back_reach, bw/2;
     -back_reach, bolt_sep;
     +2*bw+1*t,   bolt_sep;
     +2*bw+1*t,   w;
     +2*bw+3*t,   w;
     ];
T = [T;
     flipud([T(:,1), -T(:,2)]);
     T(1,:)];

P_hook = [T;
          NaN,NaN;
          U*bw/2;
         ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT AND SAVE
figure(1);
clf;
hold on;
angles = linspace(theta,phi,3);
for jj = 1:length(angles)
    phi = angles(jj);
    R = [+cosd(phi) -sind(phi); 
         +sind(phi) +cosd(phi)];
    NL = (R*(L)')';
    NP = (R*(P_bar)')';
    NE = (R*(P_end)')';
    delta_y = (jj-1)*bar_length*1.5;
    delta_x = NL(end, 1);
    
    for ii = 1:count
        w = 2*(ii-1)*abs(delta_x);
        
        % guides
        %plot(w + NL(:,1),          jj +  NL(:,2), 'g');
        %plot(w + NL(:,1),          jj + -NL(:,2), 'g');
        %plot(w + NL([1,n],1),      jj + -NL([1,n],2), 'g*');
        %plot(w + NL([1,n],1),      jj +  NL([1,n],2), 'g*');
        %plot(w + NL(floor(n/2),1), jj +  NL(floor(n/2),2), 'g*');
        
        % bars
        plot(w + NP(:,1), delta_y + +NP(:,2), 'r');
        plot(w + NP(:,1), delta_y + -NP(:,2), 'b');
    end
    w = 2*(count)*abs(delta_x);
    plot(w + NE(:,1), delta_y +  NE(:,2), 'r');
    plot(w + NE(:,1), delta_y + -NE(:,2), 'b');
    
    % stablizer
    plot(P_stable(:,1), delta_y + P_stable(:,2), 'm');
    
    % handle
    plot(delta_x + P_handle(:,1), delta_y + P_handle(:,2), 'g');
    
    % fixed origin point
    %plot(0,delta_y,'g*');
    
    plot(w + P_hook(:,1), delta_y + P_hook(:,2), 'g');
end
axis('equal');
axis('off');
hold off
saveas(1, 'lasercut_hookshot.svg')

