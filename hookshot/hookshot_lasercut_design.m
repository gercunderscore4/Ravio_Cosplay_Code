%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HOOKSHOT LASER-CUT DESIGN
% Modelled on The Legend of Zelda: A Link Between Worlds

% This hookshot has diamond-shaped sections.
% The bolts need to be sized and added to the design in advance.
% The laser-cut matieral needs to be sized to the bolt/head width.
%
% Final SVG requires some adjustements for laser cutting.

clear;
clc;
more off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER EDITABLE SETTINGS

% cm, deg

% circle count, number of points in a calculated arc
CURVE_SIZE = 30;

% material width
MAT_W = 2.54 / 4;

% used for handle
INDEX_FINDER_WIDTH = 2;

BOLT_DIA   = 0.41656 - 0.02; % body     width for bolt % #8 0.1640" / 4.1656 mm minus some kerfing
HEAD_DIA   = 1.0;            % head/nut width for bolt
SPACER_DIA = 1.0;            % spacer   width for bolt
BOLT_RAD   = BOLT_DIA / 2;
HEAD_RAD   = HEAD_DIA / 2;
SPACER_RAD = SPACER_DIA / 2;

BAR_COUNT = 5;  % number of bar pairs

% comment out one, it will be calculated instead of defined
BAR_W = 1.5 * max(HEAD_DIA, SPACER_DIA); % width of each individual bar
BAR_L = 10; % length of each individual bar
%THETA = 15.0; % final angle of the bar with the horizon, deg

if exist('BAR_W', 'var') && exist('BAR_L', 'var') && ~exist('THETA', 'var')
    THETA = asind(2 * BAR_W / BAR_L) / 2;
elseif exist('BAR_W', 'var') && ~exist('BAR_L', 'var') && exist('THETA', 'var')
    BAR_L = BAR_W / (sind(2 * THETA) / 2);
elseif ~exist('BAR_W', 'var') && exist('BAR_L', 'var') && exist('THETA', 'var')
    BAR_W = BAR_L * sind(2 * THETA) / 2;
else
    disp('ERROR: Bars are overdefined.')
    disp('PICK 2: BAR_L, BAR_W, THETA')
end

% rope radius, inner radius of the rotor along which the rope is slotted
ROPE_W = 2.54 * 1 / 8;
ROPE_R = 0.4 * (BAR_L / 2);
% space for rotor to rotate freely
ROTOR_E = 0.5;

% THETA is the final angle of the bar with the horizon.
% 0deg would create perfectly flat lines, ideal, but impossible
% anything 45deg and above makes no sense
%
% BAR_W = BAR_L * sind(THETA) * cosd(THETA)
% BAR_W = BAR_L * sind(2 * THETA) / 2
% 2 * BAR_W / BAR_L = sind(2 * THETA)
% arcsind(2 * BAR_W / BAR_L) = 2 * THETA
% arcsind(2 * BAR_W / BAR_L) / 2 = THETA
% THETA = asind(2 * BAR_W / BAR_L) / 2
%
% note: sin(2 * x) = 2 * sin(x) * cos(x)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USEFUL CALCULATIONS

% half-length/width
BAR_HL = BAR_L / 2;
BAR_HW = BAR_W / 2;

PHI = 90 - THETA;
OMEGA = PHI - THETA;

THETA_TO_PHI = linspace(THETA, PHI, CURVE_SIZE)';

% length of rope
ROPE_L = ROPE_R * OMEGA * 2*pi/180;

% separation between points when fully extended (long) and retracted (short)
REACH_LONG  = BAR_HL * cosd(THETA);
REACH_SHORT = BAR_HL * sind(THETA);

FRONT_EDGE = (2 * BAR_COUNT + 0.5) * REACH_SHORT;
BACK_EDGE  = -1 * (ROPE_L + 3*BAR_HW);

HNDL_W = MAT_W * 2;
HNDL_INNER_W = INDEX_FINDER_WIDTH + MAT_W + ROPE_L;
HNDL_OUTER_W = HNDL_W + HNDL_INNER_W;
HNDL_INNER_H = INDEX_FINDER_WIDTH * 4;
HNDL_OUTER_H = HNDL_W + HNDL_INNER_H + HNDL_W;
HNDL_INNER_HH = HNDL_INNER_H / 2;
HNDL_OUTER_HH = HNDL_OUTER_H / 2;

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
%
UNIT_CIRCLE = linspace(0, 90, CURVE_SIZE)';
COS_ARC = cosd(UNIT_CIRCLE);
SIN_ARC = flipud(COS_ARC);
UNIT_CIRCLE = [ COS_ARC,  SIN_ARC;
               -SIN_ARC,  COS_ARC;
               -COS_ARC, -SIN_ARC;
                SIN_ARC, -COS_ARC;
              ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BARS

LINE = [0, -BAR_HL;
        0,  0;
        0, +BAR_HL];

%                    |---------------| BAR_HW
%
% /                  +---------------+---------------+  -         -
%  \                 |\\             |               |  |         |
%   \                | \ \           |               |  |         |
%    \               |  \  \         |               |  |         |
%     \              |   \   \       |               |  | BAR_LE  |
%      \             |    \    \     |               |  |         |
%       \            |     \     \   |               |  |         |
%        \           |      \      \ | hole here     |  |         |
%         \          +-------\-------+---------------+  -         | BAR_SR
%  BAR_CR  \         |        \      |               |            |
%           \        |         \     |               |            |
%            \       |          \    |               |            |
%             \      |           \   |               |            |
%              \     |            \  |               |            |
%               \    |             \ |               |            |
%                \   |              \|               |            |
%                 /  |               +---------------+  -         -
%                    |               ^               |  |
%                    |       curve centers here      |  |
%                    |                               |  |
%                    |                               |  | BAR_CS
%                    |                               |  |
%                    |                               |  |
%                    |          center hole          |  |
%                    |               +               |  -
%                    |                               |
%                    .           other side          .
%                    .              |                .
%                    .              v                .
%
% BAR_L  : bar length from end-hole to end-hole
% BAR_W  : bar width from side to side
% BAR_HL : half-length
% BAR_HW : half-width
%
% BAR_LE : Length exstension necessary for the outside edges to reathe the next bar's outside edge when extended
% BAR_CR : Radius of the cruve at the end of the bar. 
%          The start fo the curve is matched to that angle at which the bars meet to hide it.
% BAR_SR : Sub-radial distance, subtract this before adding the curve to account for its long radius.
% BAR_CS : Length from middle of bar to curve center
%
% BAR_HL only reaches from the center to the hole.
% Need to provide more area for the screw and make the edges form a continuous line.
% By extending the bar by BAR_LE, and making and arc over the end, we can create more area.
% The arc should be of raduis BAR_CR so that it's angle matches the outline of the next bar.
% And by using a circular curve instead of a pointy end, it'll be smaller (vertically) when retracted.
% And less dangerous.
%
BAR_LE = BAR_HW * tand(THETA); % difference from where the front/back hole to where the curve starts
BAR_SR = BAR_HW * tand(2 * THETA);
BAR_CR = BAR_HW * secd(2 * THETA);
BAR_CS = BAR_HL + BAR_LE - BAR_SR;
BAR_R = BAR_CS + BAR_CR; % bar max radius

INNER_HEIGHT = BAR_R * cosd(THETA); % height (from center) of bar while inside
OUTER_HEIGHT = INNER_HEIGHT + BAR_HW;
OUTER_RADIUS = sqrt(OUTER_HEIGHT^2 + (4*MAT_W)^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REGULAR BARS

OMEGA_RANGE = linspace(-OMEGA, +OMEGA, CURVE_SIZE)';

% create curves at end
POINTS = [0, BAR_CS] + BAR_CR * [sind(OMEGA_RANGE), cosd(OMEGA_RANGE)];
% duplicate and rotate 180deg
POINTS = [POINTS; -1*POINTS];
% return to start
POINTS = [POINTS;POINTS(1,:)];

% add holes to bars
BAR_POINTS = [
              POINTS;
              NaN, NaN;
              UNIT_CIRCLE * BOLT_RAD + [0,-BAR_HL]; % hole at back
              NaN, NaN;
              UNIT_CIRCLE * BOLT_RAD + [0,0]; % hole in middle
              NaN, NaN;
              UNIT_CIRCLE * BOLT_RAD + [0,BAR_HL]; % hole at front
              ];

COVER_POINTS = [
                POINTS;
                NaN, NaN;
                UNIT_CIRCLE * HEAD_RAD + [0,-BAR_HL]; % hole at back
                NaN, NaN;
                UNIT_CIRCLE * HEAD_RAD + [0,0]; % hole in middle
                NaN, NaN;
                UNIT_CIRCLE * HEAD_RAD + [0,BAR_HL]; % hole at front
                ];

clear POINTS;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START BARS

% final bar (half-length)
POINTS = [
          BAR_CR * -sind(OMEGA_RANGE), BAR_CS + BAR_CR * cosd(OMEGA_RANGE); % back
          BAR_HW * -COS_ARC, BAR_HW * -SIN_ARC;
          BAR_HW *  SIN_ARC, BAR_HW * -COS_ARC;
          ];
% conect end to start
POINTS = [
          POINTS;
          POINTS(1,:);
          ];
% add holes to bars
START_BAR_POINTS = [
                    POINTS;
                    NaN, NaN;
                    (UNIT_CIRCLE * BOLT_RAD + [0, 0]); % hole at back
                    NaN, NaN;
                    (UNIT_CIRCLE * BOLT_RAD + [0,+BAR_HL]); % hole in middle
                    ];

START_COVER_POINTS = [
                      POINTS;
                      NaN, NaN;
                      UNIT_CIRCLE * HEAD_RAD + [0, 0]; % hole at back
                      NaN, NaN;
                      UNIT_CIRCLE * HEAD_RAD + [0,+BAR_HL]; % hole in middle
                      ];

clear POINTS;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END BARS

PSI = 45;
CORNER_OFFSET = BAR_HW * cot(PSI);

% final bar (half-length)
POINTS = [
          BAR_HL * cosd(PSI) - BAR_HW * cosd(PSI - 90), - BAR_HL * sind(PSI) + BAR_HW * sind(PSI - 90);
          BAR_HL * cosd(PSI) + BAR_HW * cosd(PSI - 90), - BAR_HL * sind(PSI) - BAR_HW * sind(PSI - 90);
          BAR_HW, CORNER_OFFSET;
          BAR_CR * -sind(OMEGA_RANGE), BAR_CS + BAR_CR * cosd(OMEGA_RANGE) % back
          ];
[a1, ~] = getTangentialLineToCircle(POINTS(1,:), [0 0], BAR_HW);
[~, a2] = getTangentialLineToCircle(POINTS(end,:), [0 0], BAR_HW);
A_RANGE = linspace(a2, a1, CURVE_SIZE)';
POINTS = [
          POINTS;
          BAR_HW * [cosd(A_RANGE), sind(A_RANGE)];
          ];
% conect end to start
POINTS = [
          POINTS;
          POINTS(1,:);
          ];
% flip vertically
POINTS = POINTS * [1,0;0,-1];
% add holes to bars
END_BAR_POINTS = [
                  POINTS;
                  NaN, NaN;
                  UNIT_CIRCLE * BOLT_RAD; % hole at back
                  NaN, NaN;
                  UNIT_CIRCLE * BOLT_RAD + [0,-BAR_HL]; % hole in middle
                  ];

END_COVER_POINTS = [
                    POINTS;
                    NaN, NaN;
                    UNIT_CIRCLE * HEAD_RAD; % hole at back
                    NaN, NaN;
                    UNIT_CIRCLE * HEAD_RAD + [0,-BAR_HL]; % hole in middle
                    ];

clear PSI CORNER_OFFSET a1 a2 A_RANGE POINTS;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ROTOR

P1 = [-BAR_HW, BAR_CS + BAR_SR];
R = norm(P1);
A = atan2d(P1(2), P1(1));

[~, a1] = getTangentialLineToCircle(P1, [0 0], BAR_HW);
[a2, ~] = getTangentialLineToCircle([0, -ROPE_R], [0 0], BAR_HW);
% add 2*theta to get the junction to be flat
A_RANGE = linspace(a2, a1, CURVE_SIZE)'                + 2 * THETA;
ROPE_RANGE = linspace(-2 * THETA, -90, CURVE_SIZE)'    + 2 * THETA;
BAR_RANGE = linspace(A - THETA, -2*THETA, CURVE_SIZE)' + 2 * THETA;
END_RANGE = 90 + linspace(OMEGA, 0, CURVE_SIZE)'       + 2 * THETA;

% add curves
ROTOR_POINTS = [
                R * [cosd(BAR_RANGE), sind(BAR_RANGE)];
                ROPE_R + ROPE_W*2/2, 0;
                ROPE_R + ROPE_W*2/2, 1*ROPE_W;
                ROPE_R + ROPE_W*3/2, 1*ROPE_W;
                ROPE_R + ROPE_W*3/2, 2*ROPE_W;
                ROPE_R - ROPE_W*1/2, 2*ROPE_W;
                ROPE_R - ROPE_W*1/2, 1*ROPE_W;
                ROPE_R, ROPE_W;
                ROPE_R, 0;
                ROPE_R * [cosd(ROPE_RANGE), sind(ROPE_RANGE)];
                BAR_HW * [cosd(A_RANGE), sind(A_RANGE)];
                ];
ROTOR_POINTS = [
                ROTOR_POINTS;
                ROTOR_POINTS(1,:);
               ];
% add holes to bars
ROTOR_POINTS = [
                ROTOR_POINTS;
                NaN, NaN;
                UNIT_CIRCLE * BOLT_RAD; % hole at back
                ];

ROTOR_POINTS = (rotccwd(-THETA)*ROTOR_POINTS')';

clear a1 a2 ROPE_RANGE BAR_RANGE END_RANGE A_RANGE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HANDLE

% curve used for blocking the back
H = (INNER_HEIGHT - HNDL_OUTER_HH) / 2;
S_CURVE = [
            -1*BAR_HW - BAR_HW * SIN_ARC, INNER_HEIGHT + H * (-1 + COS_ARC);
            -3*BAR_HW + BAR_HW * COS_ARC, INNER_HEIGHT + H * (-1 - SIN_ARC);
            ];

% get corner of start bar and rotate
P1 = (rotccwd(-THETA) * [-BAR_HW, BAR_CS + BAR_SR]')';
P2 = [0, -ROPE_R];
% attach tangentially to circle around center hole
[~, a1] = getTangentialLineToCircle(P1,   [0 0], BAR_HW);
[a2, ~] = getTangentialLineToCircle(P2, [0 0], BAR_HW);
A_RANGE = linspace(a2, a1, CURVE_SIZE)';
HANDLE_1 = [
            P1;
            P1(1,1), +INNER_HEIGHT;
            S_CURVE;
            flipud(S_CURVE * [1,0;0,-1]);
            0, -INNER_HEIGHT;
            -0*ROPE_W, -ROPE_R - ROPE_W*2/2;
            -1*ROPE_W, -ROPE_R - ROPE_W*2/2;
            -1*ROPE_W, -ROPE_R - ROPE_W*3/2;
            -2*ROPE_W, -ROPE_R - ROPE_W*3/2;
            -2*ROPE_W, -ROPE_R + ROPE_W*1/2;
            -1*ROPE_W, -ROPE_R + ROPE_W*1/2;
            -1*ROPE_W, -ROPE_R;
            -0*ROPE_W, -ROPE_R;
            P2;
            BAR_HW * [cosd(A_RANGE), sind(A_RANGE)];
            P1
            ];

% middle handle
HANDLE_2 = [
            HANDLE_1(1,:);
            -BAR_HW, 0;
            HANDLE_1(1,1), HANDLE_1(1,2);
            HANDLE_1(1,1), INNER_HEIGHT;
            S_CURVE;
           ];
HANDLE_2 = [
            HANDLE_2;
            flipud(HANDLE_2*[1,0;0,-1]);
            ];

% main handle

% middle handle
HANDLE_3 = [
            HANDLE_1(1,:);
            -BAR_HW, 0;
            HANDLE_1(1,1), HANDLE_1(1,2);
            HANDLE_1(1,1), INNER_HEIGHT;
            S_CURVE;
            -3*BAR_HW + -HNDL_OUTER_W + -HNDL_W/2 * (SIN_ARC - 1), HNDL_OUTER_HH + HNDL_W/2 * (COS_ARC - 1);
            ];
HANDLE_3 = [
            HANDLE_3;
            flipud(HANDLE_3*[1,0;0,-1]);
            NaN, NaN;
            -3*BAR_HW + -HNDL_INNER_W, +HNDL_INNER_HH;
            -3*BAR_HW                , +HNDL_INNER_HH;
            -3*BAR_HW                , -HNDL_INNER_HH;
            -3*BAR_HW + -HNDL_INNER_W, -HNDL_INNER_HH;
            -3*BAR_HW + -HNDL_INNER_W, +HNDL_INNER_HH;
            ];

clear a1 a2 A_RANGE;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTER STABILIZER

Y = [
     S_CURVE + [-ROPE_L, 0];
     BACK_EDGE,  OUTER_HEIGHT;
     FRONT_EDGE, OUTER_HEIGHT;
    ];
Y = [
     INNER_HEIGHT * [COS_ARC, SIN_ARC];
     Y; 
     ];
Y = [
     Y; 
     flipud(Y*[1,0;0,-1]);
     Y(1,:)
     ];
STABLE_OUTER = Y;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOP PIECE

Y = [
     FRONT_EDGE, INNER_HEIGHT;
     S_CURVE + [-ROPE_L, 0];
     BACK_EDGE,  OUTER_HEIGHT;
     FRONT_EDGE, OUTER_HEIGHT;
     FRONT_EDGE, INNER_HEIGHT;
     ];
Y = [
     Y;
     NaN, NaN;
     Y * [1,0;0,-1];
     ];
TOP_PIECE = Y;

clear Y;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FULL SIDE

Y = [
     BACK_EDGE,  +OUTER_HEIGHT;
     FRONT_EDGE, +OUTER_HEIGHT;
     FRONT_EDGE, -OUTER_HEIGHT;
     BACK_EDGE,  -OUTER_HEIGHT;
     BACK_EDGE,  +OUTER_HEIGHT;
     NaN, NaN;
     UNIT_CIRCLE * BOLT_RAD;
     %NaN, NaN;
     %BACK_EDGE,         +OUTER_RADIUS;
     %BACK_EDGE - MAT_W, +OUTER_RADIUS;
     %BACK_EDGE - MAT_W, -OUTER_RADIUS;
     %BACK_EDGE,         -OUTER_RADIUS;
     %BACK_EDGE,         +OUTER_RADIUS;
     ];
Y = [
     Y;
     NaN, NaN;
     Y * [1,0;0,-1];
     ];
FULL_SIDE = Y;

clear Y;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMPLIFY PLOTTING

c1 = size(START_BAR_POINTS,1);
c2 = size(BAR_POINTS,1);
c3 = size(END_BAR_POINTS,1);
L1 = NaN*ones(c1 + c2*(BAR_COUNT-1) + c3 + BAR_COUNT,3);
L2 = NaN*ones(c1 + c2*(BAR_COUNT-1) + c3 + BAR_COUNT,3);
L1(1:c1,:) = [START_BAR_POINTS 0*ones(c1,1)];
L2(1:c1,:) = [START_COVER_POINTS 0*ones(c1,1)];
for ii = 1:BAR_COUNT-1
    indx = (c1 + 1) + (ii-1) * (c2 + 1);
    L1(indx+1:(indx+c2),:) = [BAR_POINTS ii*ones(c2,1)];
    L2(indx+1:(indx+c2),:) = [COVER_POINTS ii*ones(c2,1)];
end
indx = (c1 + 1) + (BAR_COUNT-1) * (c2 + 1);
L1((indx+1):(indx+c3),:) = [END_BAR_POINTS BAR_COUNT*ones(c3,1)];
L2((indx+1):(indx+c3),:) = [END_COVER_POINTS BAR_COUNT*ones(c3,1)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT AND SAVE

if true
    figure(1);
    clf;
    hold on;
    jjmax = 3;
    
    for jj = 1:jjmax
        % get angle and separation distances
        completion = ((jj-1)/(jjmax-1));
        ZETA = THETA + OMEGA * completion;
        PULL = -ROPE_L * completion ;
        
        % draw above previous
        dy = (jj-1) * BAR_L * 2;
        % bar separation at this angle
        dx = BAR_L * sind(ZETA);
        DX = [dx 0];
        
        % rotate bars
        R = rotccwd(-ZETA);
        NR = (R * (ROTOR_POINTS)')';
        NB = (R * (L1(:,1:2))')' + L1(:,3)*DX;
        NC = (R * (L2(:,1:2))')' + L2(:,3)*DX;
        
        plot(FULL_SIDE(:,1),       dy + FULL_SIDE(:,2),    'g');
        plot(STABLE_OUTER(:,1),    dy + STABLE_OUTER(:,2), 'k');
        plot(PULL + HANDLE_1(:,1), dy + HANDLE_1(:,2),     'k');
        plot(NR(:,1),              dy + NR(:,2),           'k');
        plot(TOP_PIECE(:,1),       dy + TOP_PIECE(:,2),    'r');
        plot(PULL + HANDLE_2(:,1), dy + HANDLE_2(:,2),     'r');
        plot(NC(:,1),              dy + NC(:,2),           'r');
        plot(TOP_PIECE(:,1),       dy + TOP_PIECE(:,2),    'b');
        plot(PULL + HANDLE_3(:,1), dy + HANDLE_3(:,2),     'b');
        plot(NB(:,1),              dy + NB(:,2),           'b');

        plot(NB(:,1),              dy - NB(:,2),           'b');
        plot(PULL + HANDLE_3(:,1), dy - HANDLE_3(:,2),     'b');
        plot(TOP_PIECE(:,1),       dy - TOP_PIECE(:,2),    'b');
        plot(NC(:,1),              dy - NC(:,2),           'r');
        plot(PULL + HANDLE_2(:,1), dy - HANDLE_2(:,2),     'r');
        plot(TOP_PIECE(:,1),       dy - TOP_PIECE(:,2),    'r');
        plot(NR(:,1),              dy - NR(:,2),           'k');
        plot(PULL + HANDLE_1(:,1), dy - HANDLE_1(:,2),     'k');
        plot(STABLE_OUTER(:,1),    dy - STABLE_OUTER(:,2), 'k');
        plot(FULL_SIDE(:,1),       dy - FULL_SIDE(:,2),    'g');

        % fixed origin point
        plot(0,dy,'r+');
    end
    axis('equal');
    axis('off');
    hold off;
    saveas(1, 'lasercut_hookshot.svg')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LAYERS

if false
    figure(2);
    clf;
    hold on;
    
    % get angle and separation distances
    completion = 0;
    ZETA = THETA + OMEGA * completion;
    PULL = -ROPE_L * completion ;
    
    % bar separation at this angle
    dx = BAR_L * sind(ZETA);
    DX = [dx 0];
    
    % rotate bars
    R = rotccwd(-ZETA);
    NR = (R * (ROTOR_POINTS)')';
    NB = (R * (L1(:,1:2))')' + L1(:,3)*DX;
    NC = (R * (L2(:,1:2))')' + L2(:,3)*DX;

    jj = 0;
    
    jj = jj + 1;
    dy = (jj-1) * BAR_L * 2;
    plot(FULL_SIDE(:,1),       dy + FULL_SIDE(:,2),    'g');
    
    jj = jj + 1;
    dy = (jj-1) * BAR_L * 2;
    plot(STABLE_OUTER(:,1),    dy + STABLE_OUTER(:,2), 'k');
    plot(PULL + HANDLE_1(:,1), dy + HANDLE_1(:,2),     'k');
    plot(NR(:,1),              dy + NR(:,2),           'k');

    jj = jj + 1;
    dy = (jj-1) * BAR_L * 2;
    plot(TOP_PIECE(:,1),       dy + TOP_PIECE(:,2),    'r');
    plot(PULL + HANDLE_2(:,1), dy + HANDLE_2(:,2),     'r');
    plot(NC(:,1),              dy + NC(:,2),           'r');
    
    jj = jj + 1;
    dy = (jj-1) * BAR_L * 2;
    plot(TOP_PIECE(:,1),       dy + TOP_PIECE(:,2),    'b');
    plot(PULL + HANDLE_3(:,1), dy + HANDLE_3(:,2),     'b');
    plot(NB(:,1),              dy + NB(:,2),           'b');

    axis('equal');
    axis('off');
    hold off;
    saveas(2, 'lasercut_pieces.svg')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INDIVIDUAL PIECES
% this section is to help design individual pieces without drawing thw whole thing

if false
    figure(3);
    clf;
    hold on;

    % redicle on origin
    plot(0, 0, 'r+');
    
    %R = rotccwd(-THETA);

    plot(HANDLE_1(:,1),         HANDLE_1(:,2),         'k');
    %plot(HANDLE_2(:,1),         HANDLE_2(:,2),         'k');
    %plot(HANDLE_3(:,1),         HANDLE_3(:,2),         'k');
    %plot(FULL_SIDE(:,1),        FULL_SIDE(:,2),        'k');
    %plot(STABLE_OUTER(:,1),     STABLE_OUTER(:,2),     'k');
    %plot(TOP_PIECE(:,1),        TOP_PIECE(:,2),        'k');
    %plot(ROTOR_POINTS(:,1),     ROTOR_POINTS(:,2),     'k');
    %plot(START_BAR_POINTS(:,1), START_BAR_POINTS(:,2), 'k');
    %plot(BAR_POINTS(:,1),       BAR_POINTS(:,2),       'k');
    %plot(END_BAR_POINTS(:,1),   END_BAR_POINTS(:,2),   'k');

    axis('equal');
    axis('off');
    hold off;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRINT

fprintf('bar (pair) count = %d\n', BAR_COUNT)
fprintf('bar dimensions = %5.2f x %5.2f\n', 2 * BAR_HL, 2 * BAR_HW)
fprintf('angle (theta) = %5.1f\n', THETA)
fprintf('angle (phi)   = %5.1f\n', PHI)
fprintf('retracted_length = %5.2f\n', 2 * REACH_SHORT * BAR_COUNT)
fprintf('extended_length  = %5.2f\n', 2 * REACH_LONG * BAR_COUNT)
fprintf('ratio = %5.2f\n', REACH_LONG / REACH_SHORT)
fprintf('box height = %5.2f\n', 2 * OUTER_HEIGHT)
fprintf('box length = %5.2f\n', FRONT_EDGE - BACK_EDGE)
fprintf('box width = %5.2f\n', 8 * MAT_W)
fprintf('box radius = %5.2f\n', 2 * OUTER_RADIUS)

