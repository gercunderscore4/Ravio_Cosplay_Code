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

% circle count, number of points in a calculated arc
CURVE_SIZE = 30;

BOLT_DIA   = 0.6;  % body     width for bolt
HEAD_DIA   = 1.2;  % head/nut width for bolt
SPACER_DIA = 1.2;  % spacer   width for bolt
BOLT_RAD   = BOLT_DIA / 2;
HEAD_RAD   = HEAD_DIA / 2;
SPACER_RAD = SPACER_DIA / 2;

BAR_COUNT = 5;  % number of bar pairs

% comment out one, it will be calculated instead of defined
BAR_W = 1.4 * max(HEAD_DIA, SPACER_DIA); % width of each individual bar
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
ROPE_R = 0.7 * (BAR_L / 2);
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
ROPE_L = ROPE_R * (90 - (2 * THETA)) * 2*pi/180;

% separation between points when fully extended (long) and retracted (short)
REACH_LONG  = BAR_HL * cosd(THETA);
REACH_SHORT = BAR_HL * sind(THETA);

FRONT_EDGE = (2 * BAR_COUNT + 1) * REACH_SHORT;
BACK_EDGE  = -(6 * REACH_SHORT + REACH_LONG);
TOP_HEIGHT = REACH_LONG + BAR_W;

BOX_LENGTH = FRONT_EDGE - BACK_EDGE;
BOX_HEIGHT = TOP_HEIGHT * 2;

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
%                 /  |               +---------------+            -
%                    |               ^               |
%                    |       curve centers here      |
%                    |                               |
%                    |                               |
%                    |                               |
%                    |                               |
%                    |      towards center hole      |
%                    .         and other side        .
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
OMEGA_RANGE = linspace(-OMEGA, +OMEGA, CURVE_SIZE)';
% create curves at end
BAR_POINTS = [0, BAR_CS] + BAR_CR * [sind(OMEGA_RANGE), cosd(OMEGA_RANGE)];
% duplicate and rotate 180deg
BAR_POINTS = [BAR_POINTS; -1*BAR_POINTS];
% return to start
BAR_POINTS = [BAR_POINTS;BAR_POINTS(1,:)];

% add holes to bars
BAR_POINTS = [BAR_POINTS;
              NaN, NaN;
              (UNIT_CIRCLE * BOLT_RAD + [0,-BAR_HL]); % hole at back
              NaN, NaN;
              (UNIT_CIRCLE * BOLT_RAD + [0, 0]); % hole in middle
              NaN, NaN;
              (UNIT_CIRCLE * BOLT_RAD + [0, BAR_HL]); % hole at front
             ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START BARS

% final bar (half-length)
START_BAR_POINTS = [
                    BAR_CR * (-sind(OMEGA_RANGE)), +(BAR_CS + BAR_CR * cosd(OMEGA_RANGE)); % back
                    BAR_HW * -COS_ARC, BAR_HW * -SIN_ARC;
                    BAR_HW *  SIN_ARC, BAR_HW * -COS_ARC;
                   ];
% conect end to start
START_BAR_POINTS = [
                    START_BAR_POINTS;
                    START_BAR_POINTS(1,:);
                   ];
% add holes to bars
START_BAR_POINTS = [
                    START_BAR_POINTS;
                    NaN, NaN;
                    (UNIT_CIRCLE * BOLT_RAD + [0, 0]); % hole at back
                    NaN, NaN;
                    (UNIT_CIRCLE * BOLT_RAD + [0,+BAR_HL]); % hole in middle
                   ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END BARS

PSI = 45;
CORNER_OFFSET = BAR_HW * cot(PSI);

% final bar (half-length)
END_BAR_POINTS = [
                  BAR_HL * cosd(PSI) - BAR_HW * cosd(PSI - 90), - BAR_HL * sind(PSI) + BAR_HW * sind(PSI - 90);
                  BAR_HL * cosd(PSI) + BAR_HW * cosd(PSI - 90), - BAR_HL * sind(PSI) - BAR_HW * sind(PSI - 90);
                  BAR_HW, CORNER_OFFSET;
                  BAR_CR * (-sind(OMEGA_RANGE)), +(BAR_CS + BAR_CR * cosd(OMEGA_RANGE)); % back
                 ];
[a1, ~] = getTangentialLineToCircle(END_BAR_POINTS(1,:), [0 0], BAR_HW);
[~, a2] = getTangentialLineToCircle(END_BAR_POINTS(end,:), [0 0], BAR_HW);
A_RANGE = linspace(a2, a1, CURVE_SIZE)';
END_BAR_POINTS = [
                  END_BAR_POINTS;
                  (BAR_HW) * [cosd(A_RANGE), sind(A_RANGE)];
                 ];
% conect end to start
END_BAR_POINTS = [
                  END_BAR_POINTS;
                  END_BAR_POINTS(1,:);
                 ];
% add holes to bars
END_BAR_POINTS = [
                  END_BAR_POINTS;
                  NaN, NaN;
                  (UNIT_CIRCLE * BOLT_RAD + [0, 0]); % hole at back
                  NaN, NaN;
                  (UNIT_CIRCLE * BOLT_RAD + [0,+BAR_HL]); % hole in middle
                 ];
% flip vertically
END_BAR_POINTS = [END_BAR_POINTS(:,1), -END_BAR_POINTS(:,2)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ROTOR

ROPE_RANGE = linspace(-2 * THETA, -90, CURVE_SIZE)';
BAR_RANGE = linspace(PHI, -2 * THETA, CURVE_SIZE)';
END_RANGE = 90 + linspace(OMEGA, 0, CURVE_SIZE)';

% get corner of start bar and rotate
ROTOR_POINTS = [
                -BAR_HW, 0;
                BAR_CR * cosd(END_RANGE), BAR_CS + BAR_CR * sind(END_RANGE); % back
               ];
ROTOR_POINTS = (rotccwd(-THETA) * (ROTOR_POINTS)')';
% add curves
ROTOR_POINTS = [
                ROTOR_POINTS;
                (BAR_CS + BAR_CR) * [cosd(BAR_RANGE), sind(BAR_RANGE)];
                ROPE_R * [cosd(ROPE_RANGE), sind(ROPE_RANGE)];
               ];
% attach tangentially to circle around center hole
[~, a1] = getTangentialLineToCircle(ROTOR_POINTS(1,:), [0 0], BAR_HW);
[a2, ~] = getTangentialLineToCircle(ROTOR_POINTS(end,:), [0 0], BAR_HW);
A_RANGE = linspace(a2, a1, CURVE_SIZE)';
ROTOR_POINTS = [
                ROTOR_POINTS;
                (BAR_HW) * [cosd(A_RANGE), sind(A_RANGE)];
               ];
% conect end to start
ROTOR_POINTS = [
                ROTOR_POINTS;
                ROTOR_POINTS(1,:);
               ];
% add holes to bars
ROTOR_POINTS = [ROTOR_POINTS;
                NaN, NaN;
                (UNIT_CIRCLE * BOLT_RAD + [0, 0]); % hole at back
               ];
% rotate to match start bar
ROTOR_POINTS = (rotccwd(THETA) * (ROTOR_POINTS)')';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HANDLE

X = [
     BAR_HW;
     BAR_HW + BAR_W + ROPE_L + BAR_HW + BAR_W + BAR_W;
     ];
Y = [
     ROPE_R + BAR_W;
     ROPE_R + BAR_W;
     ];
H = [
     -X, Y
     flipud([-X -Y])
     ];
H = [
     H;
     H(1,:);
     ];

X = [
     BAR_HW + BAR_W;
     BAR_HW + BAR_W + ROPE_L + BAR_HW + BAR_W;
     ];
Y = [
     ROPE_R;
     ROPE_R;
     ];
B = [
     -X, Y
     flipud([-X -Y])
     ];
B = [
     B;
     B(1,:);
     ];
 
 SMPL_HNDL_POINTS = [
                     H;
                     NaN, NaN;
                     B;
                     ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTER STABILIZER

Y = [
     FRONT_EDGE, REACH_LONG + BAR_W;
     BACK_EDGE,  REACH_LONG + BAR_W;
     BACK_EDGE,  REACH_LONG + REACH_SHORT;
    ];
TRENCH_RADIUS = BAR_CR + BAR_CS + ROTOR_E;
a1 = asind(Y(end,2)/TRENCH_RADIUS);
if (numel(a1) > 1) || imag(a1)
    a1 = 90;
end
A_RANGE = linspace(a1, 0, CURVE_SIZE)';
Y = [
     Y; 
     TRENCH_RADIUS * [cosd(A_RANGE), sind(A_RANGE)];
     ];
Y = [
     Y; 
     flipud([Y(:,1), -Y(:,2)]);
     Y(1,:)
     ];
STABLE_OUTER = Y;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOP PIECE

Y = [FRONT_EDGE, REACH_LONG + BAR_W;
     BACK_EDGE,  REACH_LONG + BAR_W;
     BACK_EDGE,  REACH_LONG + REACH_SHORT;
     FRONT_EDGE, REACH_LONG + REACH_SHORT;
    ];
Y = [Y; Y(1,:)];
Y = [
     Y; 
     NaN, NaN;
     flipud([Y(:,1), -Y(:,2)]);
     ];

TOP_PIECE = Y;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRINT

fprintf('bar (pair) count = %d\n', BAR_COUNT)
fprintf('bar dimensions = %5.2f x %5.2f\n', 2 * BAR_HL, 2 * BAR_HW)
fprintf('angle (theta) = %5.1f\n', THETA)
fprintf('angle (phi)   = %5.1f\n', PHI)
fprintf('retracted_length = %5.2f\n', 2 * REACH_SHORT * BAR_COUNT)
fprintf('extended_length  = %5.2f\n', 2 * REACH_LONG * BAR_COUNT)
fprintf('ratio = %5.2f\n', REACH_LONG / REACH_SHORT)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT AND SAVE

if 0 == 1
    figure(1);
    clf;
    hold on;
    angles = linspace(THETA, PHI, 5);
    for jj = 1:length(angles)
        % get angle and separation distances
        ZETA = angles(jj);
        % draw above previous
        dy = (jj-1) * BAR_L * 2;
        % bar separation at this angle
        dx = BAR_HL * sind(ZETA);

        % rotate bars
        R = rotccwd(-ZETA);
        NR = (R * (ROTOR_POINTS)')';
        NS = (R * (START_BAR_POINTS)')';
        NB = (R * (BAR_POINTS)')';
        NE = (R * (END_BAR_POINTS)')';

        % rotor
        plot(NR(:,1), dy + +NR(:,2), 'k');
        plot(NR(:,1), dy + -NR(:,2), 'g');
        % start bars
        plot(NS(:,1), dy + +NS(:,2), 'r');
        plot(NS(:,1), dy + -NS(:,2), 'b');
        % bars
        for ii = 2:BAR_COUNT
            BAR_REACH = 2 * (ii-1) * abs(dx);
            plot(BAR_REACH + NB(:,1), dy + +NB(:,2), 'r');
            plot(BAR_REACH + NB(:,1), dy + -NB(:,2), 'b');
        end
        % end bars
        BAR_REACH = 2 * (BAR_COUNT) * abs(dx);
        plot(BAR_REACH + NE(:,1), dy +  NE(:,2), 'r');
        plot(BAR_REACH + NE(:,1), dy + -NE(:,2), 'b');

        % stablizer
        %plot(STABLE_OUTER(:,1), dy + STABLE_OUTER(:,2), 'b');

        % handle
        %plot(dx + ADV_HNDL_POINTS(:,1), dy + ADV_HNDL_POINTS(:,2), 'g');

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

if 1 == 1
    figure(2);
    clf;
    hold on;

    % bar separation at this angle
    dx = BAR_HL * sind(THETA);
    % draw above previous
    Y_SEP = BAR_L * 1.5;
    dy = 0;

    R = rotccwd(-THETA);
    NR = (R * (ROTOR_POINTS)')';
    NS = (R * (START_BAR_POINTS)')';
    NB = (R * (BAR_POINTS)')';
    NE = (R * (END_BAR_POINTS)')';

    % OUTER STABILIZER 1
    dy = dy + Y_SEP;
    plot(NR(:,1), dy + +NR(:,2), 'b');
    plot(STABLE_OUTER(:,1), dy + STABLE_OUTER(:,2), 'b');
    plot(SMPL_HNDL_POINTS(:,1), dy - SMPL_HNDL_POINTS(:,2), 'b');

    % BARS 1
    % start bars
    dy = dy + Y_SEP;
    plot(NS(:,1), dy + +NS(:,2), 'r');
    for ii = 2:BAR_COUNT
        BAR_REACH = 2 * (ii-1) * abs(dx);
        plot(BAR_REACH + NB(:,1), dy + NB(:,2), 'r');
    end
    BAR_REACH = 2 * (BAR_COUNT) * abs(dx);
    plot(BAR_REACH + NE(:,1), dy +  NE(:,2), 'r');
    plot(SMPL_HNDL_POINTS(:,1), dy - SMPL_HNDL_POINTS(:,2), 'r');
    plot(TOP_PIECE(:,1), dy + TOP_PIECE(:,2), 'r');

    axis('equal');
    axis('off');
    hold off;
    saveas(2, 'lasercut_pieces.svg')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INDIVIDUAL PIECES
% this section is to help design individual pieces without drawing thw whole thing

if 0 == 1
    figure(3);
    clf;
    hold on;

    % redicle on origin
    plot(0, 0, 'r+');

    %R = rotccwd(-THETA);
    %START_BAR_POINTS = (R * (START_BAR_POINTS'))';
    %plot(START_BAR_POINTS(:,1), START_BAR_POINTS(:,2), 'k');
    %BAR_POINTS = (R * (BAR_POINTS'))';
    %plot(BAR_L*sind(THETA) + BAR_POINTS(:,1), BAR_POINTS(:,2), 'k');
    %plot(END_BAR_POINTS(:,1), END_BAR_POINTS(:,2), 'k');
    %plot(TOP_PIECE(:,1), TOP_PIECE(:,2), 'k');
    %plot(STABLE_OUTER(:,1), STABLE_OUTER(:,2), 'k');
    %plot(ADV_HNDL_POINTS(:,1), ADV_HNDL_POINTS(:,2), 'k');
    plot(SMPL_HNDL_POINTS(:,1), SMPL_HNDL_POINTS(:,2), 'k');
    %plot(ROTOR_POINTS(:,1), ROTOR_POINTS(:,2), 'k');

    axis('equal');
    axis('off');
    hold off;
end
