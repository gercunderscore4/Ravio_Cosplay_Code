clear;
clf;
% more off;
clc;
format long g;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER EDITABLE SETTINGS

% units: mm, deg
% W_ = width
% H_ = height
% L_ = length
% D_ = diameter
% R_ = radius

% circle count, number of points in a calculated arc
CURVE_SIZE = 30;

% material width
W_MAT = 5; % cardboard, 4.8, measured 3

% Lego Technic
H_LEGO = 8+1; % 7.76 % adding 1mm wiggle room
W_LEGO = 7; % 7.38
D_AXLE = 5; % 4.72
R_AXLE = D_AXLE/2;
W_SEP = 8; % 7.97 (separation between hole)
L_BAR = 11 * W_SEP;

% M11 beam x16
% M6 beam x2
% M6,M4 beam x2
% peg x25
% M5 beam x1
% M4 axle x1
% M6 axle x1
% bush x4
% M14 axle x1

% handle (based on old prop)
D_HANDLE = 20;
R_HANDLE = D_HANDLE/2;
H_HANDLE = 105; % overall height, including 
L_HANDLE = D_HANDLE + W_MAT + L_BAR;

% barrel (based on old prop)
D_BARREL = H_HANDLE; % using handle height for this inner part, outer dia was 125mm, the additional 10mm layer will be added later
R_BARREL = D_BARREL/2;
L_BARREL = L_BAR + 2*W_MAT; % when fully extended, the first section of the mechanism should stretch to be very nearly the length of a bar, then add front and back plate widths

% fraction of width used for a structural tab
F_TAB = 0.3; % / 1.0
H_TAB = 0.4; % / 1.0
% These are the tabs that will be used to hold and glue pieces in place.
% Their actual size and placement is allowed to vary (if it makes areas too weak).
% For simplicity, making tabs 30% of the length of the edge it's on, and usually in the middle.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERIC CIRCLE (FOR EASY PLOTTING)

% CCW
%      _---|<--_
%     /    |    \
%    V   2 | 1   |
%   -------+-------
%    |   3 | 4   A
%     \_   |   _/
%       -->|---
%
% CCW 1: [ c,  s]
% CCW 2: [-s,  c]
% CCW 3: [-c, -s]
% CCW 4: [ s, -c]
%
% CCW
%      _-->|---_
%     /    |    \
%    |   2 | 1   V
%   -------+-------
%    A   3 | 4   |
%     \_   |   _/
%       ---|<--
%
% CCW 1: [ s,  c]
% CCW 2: [-c,  s]
% CCW 3: [-s, -c]
% CCW 4: [ c, -s]

UNIT_CIRCLE = linspace(0, 90, CURVE_SIZE)';
COS_ARC = cosd(UNIT_CIRCLE);
SIN_ARC = flipud(COS_ARC);
UNIT_CIRCLE = [
    +COS_ARC, +SIN_ARC;
    -SIN_ARC, +COS_ARC;
    -COS_ARC, -SIN_ARC;
    +SIN_ARC, -COS_ARC;
];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIZES

% FRONT and BACK are the circular panels on the .... front and back
% FRONT has a hole for the scissor mechanism (the "chain" of the hookshot)
% BACK has holes for the handle

% BOARDs are the main internal panels that keep the mechanism in place
% main feature is a slot used to allow an axle to move along the length of the device

% SLATs are verical panels used to keep the handle from moving side-to-side

% CURVEs are curved panels between the slats and board to hold then both in place  

% HANDLE is the handle, made from cylinders, vaguely U-shaped

W_BOX = 44;
H_BOX = 2*H_LEGO;
L_BOX = 5*W_SEP;
R_BOX = norm([W_BOX, H_BOX])/2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BEAM

% gap for elastic bands
R_GAP = 2.9*W_SEP;
Y_GAP = gtos(W_BOX/2, R_GAP);
THETA_GAP = atan2d(Y_GAP, W_BOX/2);
THETA_GAP = linspace(THETA_GAP, 180-THETA_GAP, CURVE_SIZE)';

% front and back cover
N_PANELS = 5;  % odd
THETA_BOX = atan2d(H_BOX, W_BOX);
THETA_BOX = linspace(THETA_BOX, 180-THETA_BOX, N_PANELS+1)';
BOX_CURVE = [
    R_BOX*[cosd(THETA_BOX), sind(THETA_BOX)];
];
DELTA_PANEL = BOX_CURVE(1,:) - BOX_CURVE(2,:);
W_PANEL = norm(DELTA_PANEL);
THETA_PANEL = atan2d(DELTA_PANEL(2), DELTA_PANEL(1)) / ((N_PANELS-1)/2);
H_BOX_CURVE = BOX_CURVE((N_PANELS+1)/2,2);
PANEL = [
    get_rect(W_PANEL, L_BOX);
    NaN, NaN;
    R_AXLE*UNIT_CIRCLE + W_SEP*[0,-2];
    NaN, NaN;
    R_AXLE*UNIT_CIRCLE + W_SEP*[0,+2];
    NaN, NaN;
    get_rect(W_PANEL+2*D_AXLE, D_AXLE) + W_SEP*[0,+1];
    NaN, NaN;
] + [0, L_BOX/2 + H_BOX_CURVE];
PANELS = [];
for i = linspace(-(N_PANELS-1)/2, +(N_PANELS-1)/2, N_PANELS)
    PANELS = [PANELS; [rotccwd(i*THETA_PANEL) * PANEL']'; NaN, NaN];
end

BEAM = [
    W_SEP/2*[+SIN_ARC, -COS_ARC];
    W_SEP/2*[+COS_ARC, +SIN_ARC] + W_SEP*[0,4];
    W_SEP/2*[-SIN_ARC, +COS_ARC] + W_SEP*[0,4];
    W_SEP/2*[-COS_ARC, -SIN_ARC];
    NaN, NaN;
    R_AXLE*UNIT_CIRCLE + W_SEP*[0,0];
    NaN, NaN;
    R_AXLE*UNIT_CIRCLE + W_SEP*[0,1];
    NaN, NaN;
    R_AXLE*UNIT_CIRCLE + W_SEP*[0,2];
    NaN, NaN;
    R_AXLE*UNIT_CIRCLE + W_SEP*[0,3];
    NaN, NaN;
    R_AXLE*UNIT_CIRCLE + W_SEP*[0,4];
    NaN, NaN;
    get_rect(W_BOX, L_BOX) + [0, L_BOX/2 - W_SEP/2];
    NaN, NaN;
    get_rect(H_BOX, L_BOX - W_SEP/2) + [+(W_BOX + H_BOX)/2, L_BOX/2 - W_SEP/4];
    NaN, NaN;
    get_rect(H_BOX, L_BOX - W_SEP/2) + [-(W_BOX + H_BOX)/2, L_BOX/2 - W_SEP/4];
    NaN, NaN;
    -W_BOX/2, Y_GAP;
    +W_BOX/2, Y_GAP;
    NaN, NaN;
    R_GAP*[cosd(THETA_GAP), sind(THETA_GAP)];
    NaN, NaN;
    BOX_CURVE + [0, L_BOX - W_SEP/2]  + [0, -H_BOX/2];
    NaN, NaN;
    BOX_CURVE*[1,0;0,-1] + [0, -W_SEP/2]  + [0, H_BOX/2];
    NaN, NaN;
    PANELS + [0, L_BOX - W_SEP/2 - H_BOX/2];
    NaN, NaN;
    PANELS*[1,0;0,-1] + [0, -W_SEP/2 + H_BOX/2];
];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COVER

C_BOX = 2*pi*R_BOX
PHI_BOX = atan2d(H_BOX, W_BOX);
ARC_SIDE = C_BOX*(PHI_BOX/180);
ARC_TOP = C_BOX/2 - ARC_SIDE;

COVER = [
    get_rect(ARC_TOP, L_BOX) + [0, L_BOX/2 - W_SEP/2];
    NaN, NaN;
    get_rect(ARC_SIDE/2, L_BOX - W_SEP/2) + [+(ARC_SIDE/2 + ARC_TOP)/2, L_BOX/2 - W_SEP/4];
    NaN, NaN;
    get_rect(ARC_SIDE/2, L_BOX - W_SEP/2) + [-(ARC_SIDE/2 + ARC_TOP)/2, L_BOX/2 - W_SEP/4];
    NaN, NaN;
    R_AXLE*UNIT_CIRCLE + W_SEP*[0,0];
    NaN, NaN;
    R_AXLE*UNIT_CIRCLE + W_SEP*[0,4];
    NaN, NaN;
];
COVER = [
    COVER; 
    COVER + [1*C_BOX/2, 0]
    COVER + [2*C_BOX/2, 0]
    COVER + [3*C_BOX/2, 0]
];
COVER = COVER + [C_BOX, 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOTS

% 2D
if true
    figure(1)
    clf;
    hold on;
    plot(BEAM(:,1), BEAM(:,2),  'k');
    plot(COVER(:,1), COVER(:,2),  'k');
    axis('equal');
    axis('off');
    hold off;

end

if true
    writePointsToSvg([BEAM; COVER], "hook_connector.svg");
end

