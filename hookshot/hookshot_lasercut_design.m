%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HOOKSHOT LASER-CUT DESIGN
% Modelled on The Legend of Zelda: A Link Between Worlds

% This hookshot has diamond-shaped sections.
% The actual hook will be made of fabric and sewn to the hook piece provided here.
% The bolts need to be sized and added to the design in advance.
% The stabilizer requires that certain bolts be longer (reach through the
% tracks).
% There will be multiple layers of stabilizer, the first lets the heads of
% untracked bolts flow freely.
% The second layer has tracks for the tracked bolts (some my have spacers).
% Then another layer to help protect the heads.
% The laser-cut matieral needs to be sized to the bolt/head width.
% Either get thicker material or double-up certain layers.

% TODO:
%   - Figure out how to make the handle slide smoothly.
%   - Finish the first stabilizer.
%   - Design the second stabilizer.
%   - Determine thickness.
%   - Design the covers.
%   - Set exterior sizes to help sand into a cylinder.
%   - Edit SVG manually to finess edges.
%   - Format SVG for cutting.
%   - Order cut.

clear;
clc;
more off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER EDITABLE SETTINGS

% circle count, number of points in a calculated arc
cc = 50;

bar_length = 10; % length of each individual bar
count = 7;  % number of bar pairs
theta = 12; % angle the bars make with the horizontal when fully extended, in deg

hw = 2.54*0.4375;   % head/nut width for bolt
sw = 2.54/3; % body     width for bolt
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
% bar connectors going forward
for ii = 1:count
    fact = ii * 2 - 1;
    thisline = w*[fact*sind(thetatophi), cosd(thetatophi)];
    if max(thisline(:,1)) >= max(M(:,1))
        ct = hw/2;
    else
        ct = bw/2;
    end
    thiscontour = add_thickness(thisline, ct);
    
    H = [H;
         thiscontour;
         NaN, NaN;
         ];
    
    if max(thisline(:,1)) >= max(M(:,1))
        break
    end
end
% bar connectors going back
thisline = w*[-sind(thetatophi), cosd(thetatophi)];
thiscontour = add_thickness(thisline, sw/2);
H = [H;
     thiscontour;
     ];
% copy and reflect all stabilizers so far
H = [H;
     NaN, NaN;
     flipud([H(:,1), -H(:,2)]);
     ];
% center line
thisline = [0, 0; rhi*2*count, 0];
thiscontour = add_thickness(thisline, hw/2);
H = [H;
     NaN, NaN;
     thiscontour;
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
bolt_sep = rhi - bw/2;

% need to reach back with an open slot 
% to use other bolts for stabilization
back_reach = 2*w*cosd(theta) + bw / 2;

T = [
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
% PRINT

fprintf('bar (pair) count = %d\n', count)
fprintf('bar dimensions = %5.2f x %5.2f\n', 2*w, 2*t)
fprintf('angle = %5.1f\n', theta)
fprintf('retracted_length = %5.2f\n', 2*rhi*count)
fprintf('extended_length  = %5.2f\n', 2*rho*count)
fprintf('ratio = %5.2f\n', rho/rhi)

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
    % end bars
    w = 2*(count)*abs(delta_x);
    plot(w + NE(:,1), delta_y +  NE(:,2), 'r');
    plot(w + NE(:,1), delta_y + -NE(:,2), 'b');
    
    % stablizer
    plot(P_stable(:,1), delta_y + P_stable(:,2), 'm');
    
    % handle
    plot(delta_x + P_handle(:,1), delta_y + P_handle(:,2), 'g');
    
    % hook
    plot(w + P_hook(:,1), delta_y + P_hook(:,2), 'g');
    
    % fixed origin point
    plot(0,delta_y,'g*');
end
axis('equal');
axis('off');
hold off;
saveas(1, 'lasercut_hookshot.svg')

