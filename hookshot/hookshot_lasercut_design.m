% draw chain for hookshot
clear;
clc;
more off;

% circle count, number of points in a 90deg arc
cc = 50;

bar_length = 10;
count = 7;  % number of pairs of bars
theta = 12; % angle the bars make with the horizontal when fully extended, in deg
hw = 2.54/4;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate basic circle for reuse
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
         (U*hw/2 + [0,-w]); % hole at back
         NaN, NaN;
         (U*hw/2 + [0, 0]); % hole in middle
         NaN, NaN;
         (U*hw/2 + [0, w]); % hole at front
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
         (U*hw/2 + [0, 0]); % hole at back
         NaN, NaN;
         (U*hw/2 + [0,+w]); % hole in middle
        ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% handle

rho = w*cosd(theta);
rhi = w*sind(theta);
q = linspace(0, 180, cc)';

% slot
H = [
     ([ sa, -ca]*hw/2+ [0, rhi]);
     ([ ca,  sa]*hw/2+ [0, rho]);
     ([-sa,  ca]*hw/2+ [0, rho]);
     ([-ca, -sa]*hw/2+ [0, rhi]);
     ];
H = [H;H(1,:)];
H = [H;
     NaN,NaN;
     H(:,1),-1*H(:,2)];

% outside
M = [
      0*rhi,  0;
     +1*rhi, +(      t);
     +1*rhi, +(rho + t);
     -4*rhi, +(rho + t);
     -4*rhi, -(rho + t);
     +1*rhi, -(rho + t);
     +1*rhi, -(      t);
      0*rhi,  0;
     ];

% handle hole
T = [
     ([-3*t, (rho)]);
     ([-3*t,-(rho)]);
     ([-1*t,-(rho)]);
     ([-1*t, (rho)]);
     ];
T = [T;T(1,:)];

% put it all together
P_handle = [
            H;
            NaN,NaN;
            M;
            NaN,NaN;
            T;
            ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stabilizer


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hook

% final bar
bolt_sep = 2*t*cosd(theta)-hw*2;
back_reach = 2*w*cosd(theta) + hw/2;
temp = [
        +hw+t,          -w;
        +hw,            -w;
        +hw,            -bolt_sep;
        -back_reach, -bolt_sep;
        -back_reach, -hw/2;
        ([+sa, -ca]*hw/2 + [-hw*3/2, 0]);
        ([+ca, +sa]*hw/2 + [-hw*3/2, 0]);
        -back_reach, +hw/2;
        -back_reach, +bolt_sep;
        +hw,            +bolt_sep;
        +hw,            +w;
        +hw+t,          +w;
        ];
temp = [temp;temp(1,:)];
P_hook = [temp;
          NaN,NaN;
          U*hw/2;
         ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stablizer


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot
figure(1);
clf;
hold on;
angles = linspace(theta,phi,3);
for jj = 1:length(angles)
    phi = angles(jj);
    R = [+cosd(phi) -sind(phi); 
         +sind(phi) +cosd(phi)];
    NL = [R*(L)']';
    NP = [R*(P_bar)']';
    NE = [R*(P_end)']';
    jj = (jj-1)*bar_length*1.5;
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
        plot(w + NP(:,1), jj + +NP(:,2), 'r');
        plot(w + NP(:,1), jj + -NP(:,2), 'b');
    end
    w = 2*(count)*abs(delta_x);
    plot(w + NE(:,1), jj +  NE(:,2), 'r');
    plot(w + NE(:,1), jj + -NE(:,2), 'b');
    
    
    % handle
    plot3(delta_x + P_handle(:,1), jj + P_handle(:,2), 'g');
    
    % stablizer
    %plot(S(:,1), jj + S(:,2), 'b');
    
    % fixed origin point
    %plot(0,jj,'g*');
    
    plot(w + P_hook(:,1), jj + P_hook(:,2), 'g');
end
axis('equal');
axis('off');
hold off

