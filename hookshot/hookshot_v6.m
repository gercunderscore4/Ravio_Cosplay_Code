clear;
clf;
% more off;
clc;

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

W_BOARD = 2*gtos(W_MAT + H_LEGO, R_BARREL);
H_SLAT = gtos(R_HANDLE + W_MAT, R_BARREL) - (H_LEGO + W_MAT);
L_SLAT = L_BARREL - 2*W_MAT;
L_CURVE = R_BARREL - (R_HANDLE + W_MAT);
L_BOARD = L_SLAT;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FRONT PANEL

chain_hole =  get_rect(L_BAR, 2*H_LEGO);

board_hole = get_rect(F_TAB*W_BOARD, W_MAT) + [0, H_LEGO + W_MAT/2];

slat_hole = get_rect(W_MAT, F_TAB*H_SLAT) + [R_HANDLE + W_MAT/2, H_LEGO + W_MAT + H_SLAT*H_TAB];

% outer circle
FRONT_PANEL = [
    R_BARREL*UNIT_CIRCLE;
    NaN, NaN;
    chain_hole;
    NaN, NaN;
    board_hole;
    NaN, NaN;
    reflectAcrossLine(board_hole, 0, 0);
    NaN, NaN;
    quad_symmetry(slat_hole);
];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BACK PANEL

theta = acosd(R_HANDLE/R_BARREL);
thetas = linspace(theta, 0, CURVE_SIZE);

outline_first_quad = [
    R_HANDLE*[+SIN_ARC, -COS_ARC] + [0, R_BARREL - R_HANDLE];
    R_BARREL*[cosd(thetas)', sind(thetas)'];
];

% outer circle
BACK_PANEL = [
    quad_symmetry(outline_first_quad);
    NaN, NaN;
    board_hole;
    NaN, NaN;
    reflectAcrossLine(board_hole, 0, 0);
    NaN, NaN;
    quad_symmetry(slat_hole);
];    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CURVE PANEL

x = R_HANDLE + W_MAT;
y = H_LEGO + W_MAT;
theta = acosd(x / R_BARREL);
phi = asind(y / R_BARREL);
thetas = linspace(theta, phi, CURVE_SIZE);

curve_bottom_tab = get_rect(F_TAB*L_CURVE, W_MAT) + [x + L_CURVE/2, y - W_MAT/2];

CURVE_PANEL = [
    x, y;
    R_BARREL*[cosd(thetas)', sind(thetas)'];
    x, y;
    NaN, NaN;
    slat_hole;
    NaN, NaN;
    curve_bottom_tab;
];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SLAT PANEL

slat = get_rect(L_SLAT, H_SLAT) + [0, H_SLAT/2];
slat_bottom_tab = get_rect(F_TAB*L_SLAT, W_MAT) + [0, -W_MAT/2];
slat_side_tab = get_rect(W_MAT, F_TAB*H_SLAT) + [L_SLAT/2 + W_MAT/2, H_SLAT*H_TAB];
slat_curve_hole = get_rect(W_MAT, F_TAB*H_SLAT) + [0, H_SLAT*H_TAB];
slat_connector_hole = get_rect(W_LEGO, H_LEGO) + [L_SLAT/2 - W_LEGO/2, H_LEGO/2];


SLAT_PANEL = [
    slat;
    NaN, NaN;
    slat_bottom_tab;
    NaN, NaN;
    slat_side_tab;
    NaN, NaN;
    reflectAcrossLine(slat_side_tab, inf, 0);
    NaN, NaN;
    slat_curve_hole;
    NaN, NaN;
    slat_connector_hole;
];
SLAT_PANEL = SLAT_PANEL + [0, W_MAT + H_LEGO];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BOARD PANEL

board = get_rect(W_BOARD, L_BOARD);
board_top_tab = get_rect(F_TAB*W_BOARD, W_MAT) + [0, L_BOARD/2 + W_MAT/2];

curve_trench = get_rect(F_TAB*L_CURVE, W_MAT) + [R_HANDLE + W_MAT + L_CURVE/2, 0];
slat_trench = get_rect(W_MAT, F_TAB*L_SLAT) + [R_HANDLE + W_MAT/2, 0];

BOARD_PANEL = [
    board;
    NaN, NaN;
    board_top_tab;
    NaN, NaN;
    reflectAcrossLine(board_top_tab, 0, 0);
    NaN, NaN;
    curve_trench
    NaN, NaN;
    reflectAcrossLine(curve_trench, inf, 0);
    NaN, NaN;
    slat_trench
    NaN, NaN;
    reflectAcrossLine(slat_trench, inf, 0);
    NaN, NaN;
    % slot down the middle
    R_AXLE*[-SIN_ARC, +COS_ARC] + [0, +(L_BAR-W_SEP)/2];
    R_AXLE*[-COS_ARC, -SIN_ARC] + [0, -(L_BAR-W_SEP)/2];
    R_AXLE*[+SIN_ARC, -COS_ARC] + [0, -(L_BAR-W_SEP)/2];
    R_AXLE*[+COS_ARC, +SIN_ARC] + [0, +(L_BAR-W_SEP)/2];
];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HANDLE PANEL

HANDLE_PANEL = [
    get_rect(L_HANDLE, H_HANDLE);
    NaN, NaN;
    get_rect(L_HANDLE - D_HANDLE, H_HANDLE - 2*D_HANDLE) + [R_HANDLE, 0];
];
HANDLE_PANEL = HANDLE_PANEL + [(L_HANDLE - 2*D_HANDLE)/2 - L_BARREL/2, 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOTS

FRONT_PANEL_3D = add_3d(FRONT_PANEL) + [0, 0, +L_BOARD/2];
FRONT_PANEL_3D = add_breadth(FRONT_PANEL_3D, [0, 0, +W_MAT]);

BACK_PANEL_3D = add_3d(BACK_PANEL) + [0, 0, -L_BOARD/2];
BACK_PANEL_3D = add_breadth(BACK_PANEL_3D, [0, 0, -W_MAT]);

CURVE_PANEL_3D = quad_symmetry(CURVE_PANEL);
CURVE_PANEL_3D = add_3d(CURVE_PANEL_3D) + [0, 0, -W_MAT/2];
CURVE_PANEL_3D = add_breadth(CURVE_PANEL_3D, [0, 0, W_MAT]);

BOARD_PANEL_TOP_3D = add_3d(BOARD_PANEL);
BOARD_PANEL_TOP_3D = [BOARD_PANEL_TOP_3D(:,1), BOARD_PANEL_TOP_3D(:,3), BOARD_PANEL_TOP_3D(:,2)];
BOARD_PANEL_TOP_3D = BOARD_PANEL_TOP_3D + [0, H_LEGO, 0];
BOARD_PANEL_TOP_3D = add_breadth(BOARD_PANEL_TOP_3D, [0, W_MAT, 0]);

BOARD_PANEL_BOTTOM_3D = BOARD_PANEL_TOP_3D + [0, -(H_LEGO*2 + W_MAT), 0]; 

SLAT_PANEL_RIGHT_3D = [
  SLAT_PANEL;
  NaN, NaN;
  reflectAcrossLine(SLAT_PANEL, 0, 0);
];  
SLAT_PANEL_RIGHT_3D = add_3d(SLAT_PANEL_RIGHT_3D);
SLAT_PANEL_RIGHT_3D = [SLAT_PANEL_RIGHT_3D(:,3), SLAT_PANEL_RIGHT_3D(:,2), SLAT_PANEL_RIGHT_3D(:,1)];
SLAT_PANEL_RIGHT_3D = SLAT_PANEL_RIGHT_3D + [R_HANDLE, 0, 0];
SLAT_PANEL_RIGHT_3D = add_breadth(SLAT_PANEL_RIGHT_3D, [W_MAT, 0, 0]);

SLAT_PANEL_LEFT_3D = SLAT_PANEL_RIGHT_3D + [-(D_HANDLE + W_MAT), 0, 0]; 

HANDLE_PANEL_3D = add_3d(HANDLE_PANEL);
HANDLE_PANEL_3D = [HANDLE_PANEL_3D(:,3), HANDLE_PANEL_3D(:,2), HANDLE_PANEL_3D(:,1)];
HANDLE_PANEL_3D = HANDLE_PANEL_3D + [-R_HANDLE, 0, 0];
HANDLE_PANEL_3D = add_breadth(HANDLE_PANEL_3D, [D_HANDLE, 0, 0]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOTS

% 2D
if false
    figure(1)
    clf;
    hold on;
    plot(BACK_PANEL(:,1), BACK_PANEL(:,2),  'k');
    axis('equal');
    axis('off');
    hold off;

    figure(2)
    clf;
    hold on;
    plot(FRONT_PANEL(:,1), FRONT_PANEL(:,2),  'k');
    axis('equal');
    axis('off');
    hold off;

    figure(3)
    clf;
    hold on;
    plot(+CURVE_PANEL(:,1), +CURVE_PANEL(:,2),  'k');
    axis('equal');
    axis('off');
    hold off;

    figure(4)
    clf;
    hold on;
    plot(SLAT_PANEL(:,1), SLAT_PANEL(:,2),  'k');
    axis('equal');
    axis('off');
    hold off;

    figure(5)
    clf;
    hold on;
    plot(BOARD_PANEL(:,1), BOARD_PANEL(:,2),  'k');
    axis('equal');
    axis('off');
    hold off;

    figure(6)
    clf;
    hold on;
    plot(HANDLE_PANEL(:,1), HANDLE_PANEL(:,2),  'k');
    axis('equal');
    axis('off');
    hold off;
end

% schematic
if true
    figure(7)
    clf;
    hold on;
    x = 0;
    y = 0;
    delta = 2*L_BARREL;
    plot(BACK_PANEL(:,1)+x, BACK_PANEL(:,2)+y,  'k');
    x = x + delta;
    plot(FRONT_PANEL(:,1)+x, FRONT_PANEL(:,2)+y,  'k');
    x = x + delta;
    plot(CURVE_PANEL(:,1)+x, CURVE_PANEL(:,2)+y,  'k');
    x = 0;
    y = y + delta;
    plot(SLAT_PANEL(:,1)+x, SLAT_PANEL(:,2)+y,  'k');
    x = x + delta;
    plot(BOARD_PANEL(:,1)+x, BOARD_PANEL(:,2)+y,  'k');
    x = x + delta;
    plot(HANDLE_PANEL(:,1)+x, HANDLE_PANEL(:,2)+y,  'k');
    axis('equal');
    axis('off');
    hold off;
end

if true
    figure(8)
    clf;
    hold on;
    plot3(FRONT_PANEL_3D(:,1), FRONT_PANEL_3D(:,2), FRONT_PANEL_3D(:,3), 'k')
    plot3(BACK_PANEL_3D(:,1), BACK_PANEL_3D(:,2), BACK_PANEL_3D(:,3), 'k')
    plot3(CURVE_PANEL_3D(:,1), CURVE_PANEL_3D(:,2), CURVE_PANEL_3D(:,3), 'k')
    plot3(BOARD_PANEL_TOP_3D(:,1), BOARD_PANEL_TOP_3D(:,2), BOARD_PANEL_TOP_3D(:,3), 'k')
    plot3(BOARD_PANEL_BOTTOM_3D(:,1), BOARD_PANEL_BOTTOM_3D(:,2), BOARD_PANEL_BOTTOM_3D(:,3), 'k')
    plot3(SLAT_PANEL_RIGHT_3D(:,1), SLAT_PANEL_RIGHT_3D(:,2), SLAT_PANEL_RIGHT_3D(:,3), 'k')
    plot3(SLAT_PANEL_LEFT_3D(:,1), SLAT_PANEL_LEFT_3D(:,2), SLAT_PANEL_LEFT_3D(:,3), 'k')
    %plot3(HANDLE_PANEL_3D(:,1), HANDLE_PANEL_3D(:,2), HANDLE_PANEL_3D(:,3), 'k')

    plot3([0 10], [0 0], [0 0], 'r')
    plot3([0 0], [0 10], [0 0], 'g')
    plot3([0 0], [0 0], [0 10], 'b')
    axis('equal');
    axis('off');
    hold off;
end
    
if false
	% save to svgs
    %writePointsToSvg(SIDE_PANEL, "svg/SIDE_PANEL.svg");
end

