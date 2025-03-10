clear;
clf;
more off;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USER EDITABLE SETTINGS

% cm, deg

% circle count, number of points in a calculated arc
CURVE_SIZE = 30;

% material width
MAT_W = 2.54 / 4;

% used for handle
INDEX_FINDER_WIDTH = 2;

BOLT_DIA   = 0.41656; %0.41656 - 0.02; % body     width for bolt % #8 0.1640" / 4.1656 mm minus some kerfing
HEAD_DIA   = 1.0;            % head/nut width for bolt
SPACER_DIA = 1.0;            % spacer   width for bolt
BOLT_RAD   = BOLT_DIA / 2;
HEAD_RAD   = HEAD_DIA / 2;
SPACER_RAD = SPACER_DIA / 2;

BAR_COUNT = 7;  % number of bar pairs

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

% half-length/width
BAR_HL = BAR_L / 2;
BAR_HW = BAR_W / 2;

% rope radius, inner radius of the rotor along which the rope is slotted
PINION_R = BAR_HL + BAR_HW*0.8;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USEFUL CALCULATIONS

% angles
%
% Retracted:        % Extended:          % difference:
% +-------------    % +--------------    % +-------------
% |\ PHI            % |\ THETA           % |\ THETA
% | \               % |   \              % | \ \
% |  \              % | PHI  \           % |  \   \
% |   \             % |         \        % |   \     \
% |    \            % |            \     % |    \ OMEGA \
% |THETA\           % |                  % |THETA\
%
% OMEGA is the radius travel between retracted and extended.

PHI = 90 - THETA;
OMEGA = PHI - THETA;

THETA_TO_PHI = linspace(THETA, PHI, CURVE_SIZE)';

% separation between points when fully extended (long) and retracted (short)
REACH_LONG  = BAR_HL * cosd(THETA);
REACH_SHORT = BAR_HL * sind(THETA);

FRONT_EDGE = (2 * BAR_COUNT + 0.5) * REACH_SHORT;
BACK_EDGE  = -1 * (0 + 3*BAR_HW);

HNDL_W = MAT_W * 2;
HNDL_INNER_W = INDEX_FINDER_WIDTH + MAT_W + 0;
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
UNIT_CIRCLE = [
    +COS_ARC, +SIN_ARC;
    -SIN_ARC, +COS_ARC;
    -COS_ARC, -SIN_ARC;
    +SIN_ARC, -COS_ARC;
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
% BAR_LE : Length exstension necessary for the outside edges to reach the next bar's outside edge when extended
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
OUTLINE_POINTS = [0, BAR_CS] + BAR_CR * [sind(OMEGA_RANGE), cosd(OMEGA_RANGE)];
% duplicate and rotate 180deg
OUTLINE_POINTS = [
    OUTLINE_POINTS; 
    -1*OUTLINE_POINTS
    ];
% return to start
OUTLINE_POINTS = [
    OUTLINE_POINTS;
    OUTLINE_POINTS(1,:)
    ];

% add holes to bars
BAR_POINTS = [
    OUTLINE_POINTS;
    NaN, NaN;
    UNIT_CIRCLE * BOLT_RAD + [0,-BAR_HL]; % hole at back
    NaN, NaN;
    UNIT_CIRCLE * BOLT_RAD + [0,0]; % hole in middle
    NaN, NaN;
    UNIT_CIRCLE * BOLT_RAD + [0,BAR_HL]; % hole at front
    ];

COVER_POINTS = [
    OUTLINE_POINTS;
    NaN, NaN;
    UNIT_CIRCLE * HEAD_RAD + [0,-BAR_HL]; % hole at back
    NaN, NaN;
    UNIT_CIRCLE * HEAD_RAD + [0,0]; % hole in middle
    NaN, NaN;
    UNIT_CIRCLE * HEAD_RAD + [0,BAR_HL]; % hole at front
    ];

HIGHEST_VALUE = (rotccwd(THETA) * OUTLINE_POINTS')';
HIGHEST_VALUE = max(HIGHEST_VALUE(:,2));

clear OUTLINE_POINTS;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START BARS

% final bar (half-length)
POINTS = [
    BAR_CR * -sind(OMEGA_RANGE), BAR_CS + BAR_CR * cosd(OMEGA_RANGE); % back
    ];
% conect end to start
POINTS = [
    POINTS;
    (rotccwd(180) * POINTS')' + [0, BAR_HL];
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

%a = atan2d(BAR_HW, BAR_HL);
%d = norm([BAR_HW, BAR_HL]);
%a_range = 45 + linspace(-a, +a, CURVE_SIZE)';
%% front, no hole, slightly curved
%front_points = BAR_CR * [sind(OMEGA_RANGE), -cosd(OMEGA_RANGE)] + [0, -BAR_CS]; % front
%% back, standard bar end
%back_points = d * [cosd(a_range), sind(a_range)];
%% create bend
%[cwElbowl1, ccwElbowl1] = getElbowBend(front_points(end,:), back_points(1,:), [0,0], BAR_HW);
%[cwElbowl2, ccwElbowl2] = getElbowBend(back_points(end,:), front_points(1,:), [0,0], BAR_HW);
%POINTS = [
%    front_points;
%    ccwElbowl1;
%    back_points;
%    ccwElbowl2;
%    ];

front_points = BAR_CR * [sind(OMEGA_RANGE), -cosd(OMEGA_RANGE)] + [0, -BAR_CS]; % front
[cwElbowl, ccwElbowl] = getElbowBend(front_points(end,:), front_points(1,:), [0,0], BAR_HW);
POINTS = [
    front_points;
    ccwElbowl;
    ];

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

clear a d a_range front_points back_points cwElbowl1 ccwElbowl1 cwElbowl2 ccwElbowl2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RACK & PINION

% PINION
% Want just enough teeth to open and close the hookshot.
% Also need a circular sector to wrap around to the end bar.
% Stop the circular sector at the end bar so that the handle has more area to expand into.

% pinion (half-tooth)
% 20 teeth (each rotated 360/20 = 18deg = pi/10)
n = 20;
psi = 360 / n;
% tooth shape needs to be updated when n is updated
% recommend: http://hessmer.org/gears/InvoluteSpurGearBuilder.html?circularPitch=8&pressureAngle=20&clearance=0.05&backlash=0.05&profileShift=0&gear1ToothCount=0&gear1CenterHoleDiamater=0&gear2ToothCount=12&gear2CenterHoleDiamater=1&showOption=3
% requires some working
PINION_HALF_TOOTH = [
    -0.12748, -0.80490;
    -0.11272, -0.80710;
    -0.09578, -0.80929;
    -0.09017, -0.81009;
    -0.08833, -0.81090;
    -0.08657, -0.81214;
    -0.08491, -0.81381;
    -0.08336, -0.81590;
    -0.08195, -0.81841;
    -0.08069, -0.82134;
    -0.07959, -0.82468;
    -0.07797, -0.83256;
    -0.07720, -0.84199;
    -0.07766, -0.85624;
    -0.07760, -0.86290;
    -0.07647, -0.87556;
    -0.07518, -0.88407;
    -0.07326, -0.89398;
    -0.07057, -0.90529;
    -0.06700, -0.91796;
    -0.06245, -0.93185;
    -0.05680, -0.94693;
    -0.04990, -0.96321;
    -0.04171, -0.98049;
    -0.03269, -0.99767;
    -0.00000, -0.99767;
    ];
PINION_HALF_TOOTH = PINION_HALF_TOOTH * PINION_R;
PINION_TOOTH = [PINION_HALF_TOOTH; flipud(reflectAcrossLine(PINION_HALF_TOOTH, Inf, 0))];

PINION = [];
for ii = -1:ceil(OMEGA/psi)
    PINION = [PINION; (rotccwd(ii*360/n) * PINION_TOOTH')']; %#ok<AGROW>
end


top_points = [BAR_CR * -sind(OMEGA_RANGE), BAR_CS + BAR_CR * cosd(OMEGA_RANGE)]; % back
top_points = (rotccwd(-THETA) * top_points')';

%PINION = [
%    PINION;
%    top_points;
%    ];
%[cwElbowl1, ccwElbowl1] = getElbowBend(PINION(end,:), PINION(1,:), [0,0], BAR_HW);
%PINION = [
%    PINION;
%    ccwElbowl1
%    ];
PINION = [
    PINION;
    top_points;
    PINION(1,:);
    ];

PINION = [
    PINION;
    NaN, NaN;
    UNIT_CIRCLE * BOLT_RAD;
    ];
pinion_back = min(PINION(:,1));

% RACK
% Simple rack attached to the handle.
% 

% rack teeth
RACK_HALF_TOOTH = [
    -0.14254, -0.81672;
    -0.10278, -0.81672;
    -0.04010, -1.00000;
    -0.00000, -1.00000;
    ];
RACK_HALF_TOOTH = RACK_HALF_TOOTH * PINION_R;
w = (RACK_HALF_TOOTH(end,1) - RACK_HALF_TOOTH(1,1)) * 2;
RACK_UNIT_PER_DEG = w / psi;
RACK_DISTANCE = RACK_UNIT_PER_DEG * OMEGA;
RACK_TOOTH = [
    RACK_HALF_TOOTH;
    flipud(reflectAcrossLine(RACK_HALF_TOOTH, Inf, 0));
    ];
rack_high = abs(max(RACK_HALF_TOOTH(:,2)));
rack_low  = abs(min(RACK_HALF_TOOTH(:,2)));

RACK = [];
for ii = -1:ceil(OMEGA/psi)
    RACK = [RACK; (RACK_TOOTH + [ii*w, 0])]; %#ok<AGROW>
end
RACK = [
    RACK(2:end,:);
    ];
rack_back  = min(RACK(:,1));
rack_front = max(RACK(:,1));

RACK = [
    RACK;
    rack_front,          -rack_low - BAR_HW;
    rack_back  - BAR_HW, -rack_low - BAR_HW;
    rack_back  - BAR_HW, +rack_low + BAR_HW;
    rack_front,          +rack_low + BAR_HW;
    rack_front,          +rack_low;
    rack_back,           +rack_low;
    RACK(1,:);
    ];

FRONT_VALUE   = 2*REACH_LONG-REACH_SHORT;
BACK_VALUE    = -2*REACH_SHORT;
HIGHEST_VALUE = max(RACK(:,2));

OUTER_BOX = [
    FRONT_VALUE,          -HIGHEST_VALUE;
    BACK_VALUE,           -HIGHEST_VALUE;
    BACK_VALUE,           +HIGHEST_VALUE;
    FRONT_VALUE,          +HIGHEST_VALUE;
    FRONT_VALUE,          +HIGHEST_VALUE - BAR_HW;
    BACK_VALUE  + BAR_HW, +HIGHEST_VALUE - BAR_HW;
    BACK_VALUE  + BAR_HW, -HIGHEST_VALUE + BAR_HW;
    FRONT_VALUE,          -HIGHEST_VALUE + BAR_HW;
    FRONT_VALUE,          -HIGHEST_VALUE;
    ];

SIDE_PANEL = [
    FRONT_VALUE, +HIGHEST_VALUE;
    BACK_VALUE,  +HIGHEST_VALUE;
    BACK_VALUE,  -HIGHEST_VALUE;
    FRONT_VALUE, -HIGHEST_VALUE;
    FRONT_VALUE, +HIGHEST_VALUE;
    NaN, NaN;
    -SIN_ARC*BOLT_RAD + 2*REACH_SHORT,                 +COS_ARC*BOLT_RAD;
    -COS_ARC*BOLT_RAD + 2*REACH_SHORT,                 -SIN_ARC*BOLT_RAD;
    FRONT_VALUE, -BOLT_RAD;
    FRONT_VALUE, +BOLT_RAD;
    0 + 2*REACH_SHORT, BOLT_RAD;
    NaN, NaN;
    ];

clear n w psi PINION_HALF_TOOTH PINION_TOOTH RACK_HALF_TOOTH RACK_TOOTH;
% PINION
% RACK
% RACK_UNIT_PER_DEG

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMPLIFY PLOTTING

c1 = size(START_BAR_POINTS, 1);
c2 = size(BAR_POINTS,       1);
c3 = size(END_BAR_POINTS,   1);
L1 = NaN*ones(c1 + c2*(BAR_COUNT-1) + c3 + BAR_COUNT,3);
L2 = NaN*ones(c1 + c2*(BAR_COUNT-1) + c3 + BAR_COUNT,3);
L1(1:c1,:) = [START_BAR_POINTS   0*ones(c1,1)];
L2(1:c1,:) = [START_COVER_POINTS 0*ones(c1,1)];
for ii = 1:BAR_COUNT-1
    indx = (c1 + 1) + (ii-1) * (c2 + 1);
    L1(indx+1:(indx+c2),:) = [BAR_POINTS   ii*ones(c2,1)];
    L2(indx+1:(indx+c2),:) = [COVER_POINTS ii*ones(c2,1)];
end
indx = (c1 + 1) + (BAR_COUNT-1) * (c2 + 1);
L1((indx+1):(indx+c3),:) = [END_BAR_POINTS   BAR_COUNT*ones(c3,1)];
L2((indx+1):(indx+c3),:) = [END_COVER_POINTS BAR_COUNT*ones(c3,1)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT ANIMATION

if true
    % mechanism in different states of operation
    figure(1);
    clf;
    hold on;
    jjmax = 3;
    
    for jj = 1:jjmax
        % get angle and separation distances
        completion = (jj-1) / (jjmax-1);
        ZETA = THETA + OMEGA * completion;
        PUSH = OMEGA * completion * RACK_UNIT_PER_DEG;
        
        % draw above previous
        dy = (jj-1) * BAR_L * 2;
        % bar separation at this angle
        dx = BAR_L * sind(ZETA);
        DX = [dx 0];
        
        % rotate bars
        R = rotccwd(-ZETA);
        NR = RACK;
        NP = (rotccwd(-OMEGA * completion) * (PINION)')';
        NB = (R * (L1(:,1:2))')' + L1(:,3)*DX;
        NC = (R * (L2(:,1:2))')' + L2(:,3)*DX;
        
        plot(NB(:,1),          dy + NB(:,2),          'b');
        plot(NC(:,1),          dy + NC(:,2),          'r');

        %plot(NC(:,1),          dy - NC(:,2),          'r');
        %plot(NB(:,1),          dy - NB(:,2),          'b');

        plot(OUTER_BOX(:,1),   dy + OUTER_BOX(:,2),   'k');
        plot(SIDE_PANEL(:,1),  dy + SIDE_PANEL(:,2),  'k');
        

        % fixed origin point
        plot(0,dy,'r+');
    end
    axis('equal');
    axis('off');
    hold off;
end

if false
    % layers separated vertically
    figure(2);
    clf;
    hold on;
    % get angle and separation distances
    completion = 0;
    ZETA = THETA + OMEGA * completion;
    PUSH = OMEGA * completion * RACK_UNIT_PER_DEG;
    
    % draw above previous
    dy = BAR_L * 2;
    % bar separation at this angle
    dx = BAR_L * sind(ZETA);
    DX = [dx 0];

    % rotate bars
    R = rotccwd(-ZETA);
    NP = (rotccwd(-OMEGA * completion) * (PINION)')' + [PUSH, 0];
    NB = (R * (L1(:,1:2))')' + L1(:,3)*DX + [PUSH, 0];
    NC = (R * (L2(:,1:2))')' + L2(:,3)*DX + [PUSH, 0];
    NR = RACK;
    
    plot(SIDE_PANEL(:,1),  0*dy + SIDE_PANEL(:,2),  'k');
    plot(NR(:,1),          0*dy + NR(:,2),          'r');
    plot(NP(:,1),          0*dy + NP(:,2),          'r');
    plot(OUTER_BOX(:,1),   0*dy + OUTER_BOX(:,2),   'm');
    plot(NB(:,1),          0*dy + NB(:,2),          'g');
    plot(OUTER_BOX(:,1),   0*dy + OUTER_BOX(:,2),   'g');
    plot(NC(:,1),          0*dy + NC(:,2),          'b');
    plot(OUTER_BOX(:,1),   0*dy + OUTER_BOX(:,2),   'b');

    axis('equal');
    axis('off');
    hold off;
end

if false
    % each part separated vertically
    figure(3)
    clf;
    hold on;
    
    dy = BAR_L * 2;
    
    plot(PINION(:,1),           1*dy + PINION(:,2),           'k');
    plot(RACK(:,1),             2*dy + RACK(:,2),             'k');
    plot(START_BAR_POINTS(:,1), 3*dy + START_BAR_POINTS(:,2), 'k');
    plot(BAR_POINTS(:,1),       4*dy + BAR_POINTS(:,2),       'k');
    plot(END_BAR_POINTS(:,1),   5*dy + END_BAR_POINTS(:,2),   'k');
    plot(OUTER_BOX(:,1),        6*dy + OUTER_BOX(:,2),        'k');
    plot(SIDE_PANEL(:,1),       7*dy + SIDE_PANEL(:,2),       'k');
    
    axis('equal');
    axis('off');
    hold off;
end

if false
	% save to svgs
    figure(4)
    clf;
    hold on;
	
    ZETA = THETA + OMEGA * completion;
    PUSH = OMEGA * completion * RACK_UNIT_PER_DEG;
    
    % draw above previous
    dy = BAR_L * 2;
    % bar separation at this angle
    dx = BAR_L * sind(ZETA);
    DX = [dx 0];

    % rotate bars
    R = rotccwd(-ZETA);
    NP = (rotccwd(-OMEGA * completion) * (PINION)')' + [PUSH, 0];
    NB1 = (R * (START_BAR_POINTS)')' + 0*DX + [PUSH, 0];
    NB2 = (R * (BAR_POINTS)')'       + 1*DX + [PUSH, 0];
    NB3 = (R * (END_BAR_POINTS)')'   + 2*DX + [PUSH, 0];
    NR = RACK;
    
    plot(SIDE_PANEL(:,1),  0*dy + SIDE_PANEL(:,2),  'k');
    plot(OUTER_BOX(:,1),   0*dy + OUTER_BOX(:,2),   'm');
    plot(NR(:,1),          0*dy + NR(:,2),          'r');
    plot(NP(:,1),          0*dy + NP(:,2),          'r');
    plot(NB1(:,1),         0*dy + NB1(:,2),         'g');
    plot(NB2(:,1),         0*dy + NB2(:,2),         'g');
    plot(NB3(:,1),         0*dy + NB3(:,2),         'g');

    axis('equal');
    axis('off');
    hold off;

    writePointsToSvg(SIDE_PANEL, "svg/SIDE_PANEL.svg");
    writePointsToSvg(OUTER_BOX,  "svg/OUTER_BOX.svg");
    writePointsToSvg(NR,         "svg/RACK.svg");
    writePointsToSvg(NP,         "svg/PINION.svg");
    writePointsToSvg(NB1,        "svg/START_BAR_POINTS.svg");
    writePointsToSvg(NB2,        "svg/BAR_POINTS.svg");
    writePointsToSvg(NB3,        "svg/END_BAR_POINTS.svg");

end
