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
CURVE_SIZE = 30;

BOLT_DIA   = 0.6;  % body     width for bolt
HEAD_DIA   = 1.2;  % head/nut width for bolt
SPACER_DIA = 1.2;  % spacer   width for bolt
BOLT_RAD   = BOLT_DIA / 2;
HEAD_RAD   = HEAD_DIA / 2;
SPACER_RAD = SPACER_DIA / 2;

BAR_COUNT = 7;  % number of bar pairs
BAR_L = 10; % length of each individual bar
BAR_W = 1.4 * max(HEAD_DIA, SPACER_DIA); % width of each individual bar
BAR_HL = BAR_L / 2;
BAR_HW = BAR_W / 2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USEFUL CALCULATIONS

% THETA is the final angle of the bar with the horizon.
% 0deg would create perfectly flat lines, ideal, but impossible
% anything 45deg and above makes no sense
%
% BAR_HW = BAR_HL * sind(THETA) * cosd(THETA)
% BAR_HW = BAR_HL * sind(2 * THETA) / 2
% 2 * BAR_HW / BAR_HL = sind(2 * THETA)
% arcsind(2 * BAR_HW / BAR_HL) = 2 * THETA
% arcsind(2 * BAR_HW / BAR_HL) / 2 = THETA
% THETA = asind(2 * BAR_HW / BAR_HL) / 2
%
% note: sin(2 * x) = 2 * sin(x) * cos(x)
%
THETA = asind(2 * BAR_HW / BAR_HL) / 2;
PHI = 90 - THETA;
OMEGA = PHI - THETA;

THETA_TO_PHI = linspace(THETA, PHI, CURVE_SIZE)';

% separation between points when fully extended (long) and retracted (short)
REACH_LONG  = BAR_HL * cosd(THETA);
REACH_SHORT = BAR_HL * sind(THETA);

FRONT_EDGE = (2 * BAR_COUNT + 1) * REACH_SHORT;
BACK_EDGE  = -(6 * REACH_SHORT + REACH_LONG);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERIC CIRCLE (FOR EASY PLOTTING)

% CCW
%      _---|<--_
%     /    |    \
%    V   2 | 1   |
%   -------+-------
%    |   3 | 4   ^
%     \_   |   _/
%       -->|---
%
% CCW 1: [ c,  s]
% CCW 2: [-s,  c]
% CCW 3: [-c, -s]
% CCW 4: [ s, -c]
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
OMEGA_RANGE = linspace(-OMEGA, +OMEGA, CURVE_SIZE)';
% create curves at end
BAR_POINTS = [0, BAR_HL + BAR_LE - BAR_SR] + BAR_CR * [sind(OMEGA_RANGE), cosd(OMEGA_RANGE)];
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
% BAR ENDS

PSI = 45;
CORNER_OFFSET = BAR_HW * cot(PSI);

% final bar (half-length)
P_end = [
         BAR_CR * (-sind(OMEGA_RANGE)), +(BAR_HL+BAR_LE-BAR_SR+BAR_CR * cosd(OMEGA_RANGE)); % back
         -BAR_HW, -CORNER_OFFSET;
         BAR_HL * cosd(PSI) - BAR_HW * cosd(PSI - 90), - BAR_HL * sind(PSI) + BAR_HW * sind(PSI - 90);
         BAR_HL * cosd(PSI) + BAR_HW * cosd(PSI - 90), - BAR_HL * sind(PSI) - BAR_HW * sind(PSI - 90);
         +BAR_HW, +CORNER_OFFSET;
        ];
P_end = [P_end;
         P_end(1,:);
        ];
% add holes to bars
P_end = [P_end;
         NaN, NaN;
         (UNIT_CIRCLE * BOLT_RAD + [0, 0]); % hole at back
         NaN, NaN;
         (UNIT_CIRCLE * BOLT_RAD + [0,+BAR_HL]); % hole in middle
        ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HANDLE

% slot
H = [
     ([ SIN_ARC, -COS_ARC] * BOLT_RAD + [0, REACH_SHORT]);
     ([ COS_ARC,  SIN_ARC] * BOLT_RAD + [0, REACH_LONG]);
     ([-SIN_ARC,  COS_ARC] * BOLT_RAD + [0, REACH_LONG]);
     ([-COS_ARC, -SIN_ARC] * BOLT_RAD + [0, REACH_SHORT]);
     ];
% return to start
H = [H;H(1,:)];

% outside
M = [
     -1 * REACH_SHORT,   (           - REACH_SHORT - BOLT_RAD);
     +1 * REACH_SHORT, + (             REACH_SHORT - BOLT_RAD);
     +1 * REACH_SHORT, + (REACH_LONG + REACH_SHORT);
     -6 * REACH_SHORT, + (REACH_LONG + REACH_SHORT);
     -6 * REACH_SHORT, - (REACH_LONG + REACH_SHORT);
     -1 * REACH_SHORT, - (REACH_LONG + REACH_SHORT);
     ];
% back to start
M = [M; M(1,:)];

% handle hole
T = [
     ([-5 * BAR_HW,-(REACH_LONG)]);
     ([-2 * BAR_HW,-(REACH_LONG)]);
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
% INNER STABILIZER

% center line
M = [([2 * REACH_SHORT, 0] +  HEAD_RAD * [-COS_ARC,  SIN_ARC]);
     FRONT_EDGE, HEAD_RAD;
     FRONT_EDGE, REACH_LONG + BAR_W;
     BACK_EDGE,  REACH_LONG + BAR_W;
     BACK_EDGE,  REACH_LONG + REACH_SHORT;
    ];
M = [M;
     0,                  REACH_LONG + REACH_SHORT;
     0,                               REACH_SHORT - BOLT_RAD;
     -2 * REACH_SHORT,              - REACH_SHORT - BOLT_RAD;
     -2 * REACH_SHORT, - REACH_LONG - REACH_SHORT;
     flipud([M(:,1), -M(:,2)]);
     M(1,:)];

% stabilization lines
H = [];
% bar connectors going forward
for ii = 1:BAR_COUNT
    fact = ii * 2 - 1;
    thisline = BAR_HL * [fact * sind(THETA_TO_PHI), cosd(THETA_TO_PHI)];
    thiscontour = add_thickness(thisline, HEAD_RAD);
    
    H = [H;
         thiscontour;
         NaN, NaN;
         ]; %#ok<AGROW>
    
    if max(thisline(:,1)) >= max(M(:,1))
        break
    end
end
% copy and reflect all stabilizers so far
H = [H;
     NaN, NaN;
     flipud([H(:,1), -H(:,2)]);
     ];
H = [H;
     NaN, NaN;
     thiscontour;
     ];
 
STABLE_INNER = [
                M;
                NaN,NaN;
                H;
                NaN,NaN;
                UNIT_CIRCLE * BOLT_RAD;
                ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OUTER STABILIZER

% outer frme
M = [FRONT_EDGE, REACH_LONG + BAR_W;
     BACK_EDGE,  REACH_LONG + BAR_W;
    ];
M = [M; flipud([M(:,1), -M(:,2)]); M(1,:)];

% handle hole
H = [
     BACK_EDGE   + REACH_SHORT, REACH_LONG;
     -2 * BAR_HW - REACH_SHORT, REACH_LONG;
    ];
H = [H; flipud([H(:,1), -H(:,2)]); H(1,:)];

% slots going back
T = BAR_HL * [-cosd(THETA_TO_PHI), sind(THETA_TO_PHI)];
T = add_thickness(T, HEAD_RAD);
T = [
     T; 
     NaN, NaN;
     flipud([T(:,1), -T(:,2)])
     ];

STABLE_OUTER = [
                M;
                NaN,NaN;
                H;
                NaN,NaN;
                T;
                NaN,NaN;
                UNIT_CIRCLE * BOLT_RAD;
                ];

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
% HANDLE PIECE

% outside
M = [
     -6 * REACH_SHORT, + (REACH_LONG + REACH_SHORT);
     -1 * REACH_SHORT, + (REACH_LONG + REACH_SHORT);
     ];
% back to start
M = [M; flipud([M(:,1), -M(:,2)])];
M = [M; M(1,:)];

% handle hole
T = [
     ([-5 * BAR_HW,-(REACH_LONG)]);
     ([-2 * BAR_HW,-(REACH_LONG)]);
     ];
T = [T;
     flipud([T(:,1), -T(:,2)]);
     T(1,:)];

% put it all together
HANDLE_PIECE = [
                M;
                NaN,NaN;
                T;
                ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HOOK

% put it all together
HOOK = [
        BAR_HW * UNIT_CIRCLE;
        NaN, NaN;
        HEAD_RAD * UNIT_CIRCLE;
        ];

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

figure(1);
clf;
hold on;
angles = linspace(THETA, PHI, 3);
for jj = 1:length(angles)
    ZETA = angles(jj);
    R = [+cosd(ZETA) -sind(ZETA); 
         +sind(ZETA) +cosd(ZETA)];
    NL = (R * (LINE)')';
    NP = (R * (BAR_POINTS)')';
    NE = (R * (P_end)')';
    delta_y = (jj-1) * BAR_L * 2;
    delta_x = NL(end, 1);
    
    for ii = 1:BAR_COUNT
        BAR_REACH = 2 * (ii-1) * abs(delta_x);
        
        % guides
        %plot(BAR_REACH + NL(:,1),          jj +  NL(:,2), 'g');
        %plot(BAR_REACH + NL(:,1),          jj + -NL(:,2), 'g');
        %plot(BAR_REACH + NL([1,n],1),      jj + -NL([1,n],2), 'g * ');
        %plot(BAR_REACH + NL([1,n],1),      jj +  NL([1,n],2), 'g * ');
        %plot(BAR_REACH + NL(floor(n/2),1), jj +  NL(floor(n/2),2), 'g * ');
        
        % bars
        plot(BAR_REACH + NP(:,1), delta_y + +NP(:,2), 'r');
        plot(BAR_REACH + NP(:,1), delta_y + -NP(:,2), 'b');
    end
    % end bars
    BAR_FAR_REACH = 2 * (BAR_COUNT) * abs(delta_x);
    plot(BAR_FAR_REACH + NE(:,1), delta_y +  NE(:,2), 'r');
    plot(BAR_FAR_REACH + NE(:,1), delta_y + -NE(:,2), 'b');
    
    % hook
    plot(BAR_FAR_REACH + HOOK(:,1), delta_y + HOOK(:,2), 'g');
    
    % stablizer
    plot(STABLE_INNER(:,1), delta_y + STABLE_INNER(:,2), 'k');
    plot(STABLE_OUTER(:,1), delta_y + STABLE_OUTER(:,2), 'c');
    
    % handle
    plot(delta_x + P_handle(:,1), delta_y + P_handle(:,2), 'g');
    
    % fixed origin point
    plot(0,delta_y,'g * ');
end
axis('equal');
axis('off');
hold off;
saveas(1, 'lasercut_hookshot.svg')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHOW UNIQUE PIECES

figure(2);
clf;
hold on;
Y_SEP = BAR_L * 1.5;

R = [+cosd(THETA) -sind(THETA); 
     +sind(THETA) +cosd(THETA)];
NL = (R * (LINE)')';
NP = (R * (BAR_POINTS)')';
NE = (R * (P_end)')';
delta_x = NL(end, 1);
delta_y = 0;
BAR_FAR_REACH = 2 * (BAR_COUNT) * abs(delta_x);

% OUTER STABILIZER 1
delta_y = delta_y + Y_SEP;
plot(STABLE_OUTER(:,1), delta_y + STABLE_OUTER(:,2), 'c');

% INNER STABILIZER 1
delta_y = delta_y + Y_SEP;
plot(delta_x + P_handle(:,1), delta_y - P_handle(:,2), 'g');
plot(STABLE_INNER(:,1), delta_y - STABLE_INNER(:,2), 'g');
plot(BAR_FAR_REACH + HOOK(:,1), delta_y + HOOK(:,2), 'g');

% BARS 1
delta_y = delta_y + Y_SEP;
for ii = 1:BAR_COUNT
    BAR_REACH = 2 * (ii-1) * abs(delta_x);
    plot(BAR_REACH + NP(:,1), delta_y + +NP(:,2), 'r');
end
plot(BAR_FAR_REACH + NE(:,1), delta_y +  NE(:,2), 'r');
plot(delta_x + HANDLE_PIECE(:,1), delta_y - HANDLE_PIECE(:,2), 'r');
plot(TOP_PIECE(:,1), delta_y + TOP_PIECE(:,2), 'r');

% BARS 2
delta_y = delta_y + Y_SEP;
for ii = 1:BAR_COUNT
    BAR_REACH = 2 * (ii-1) * abs(delta_x);
    plot(BAR_REACH + NP(:,1), delta_y + -NP(:,2), 'b');
end
plot(BAR_FAR_REACH + NE(:,1), delta_y + -NE(:,2), 'b');
plot(delta_x + HANDLE_PIECE(:,1), delta_y - HANDLE_PIECE(:,2), 'b');
plot(TOP_PIECE(:,1), delta_y + TOP_PIECE(:,2), 'b');

% INNER STABILIZER 2
delta_y = delta_y + Y_SEP;
plot(delta_x + P_handle(:,1), delta_y + P_handle(:,2), 'g');
plot(STABLE_INNER(:,1), delta_y + STABLE_INNER(:,2), 'g');
plot(BAR_FAR_REACH + HOOK(:,1), delta_y + HOOK(:,2), 'g');

% OUTER STABILIZER 2
delta_y = delta_y + Y_SEP;
plot(STABLE_OUTER(:,1), delta_y + STABLE_OUTER(:,2), 'c');

axis('equal');
axis('off');
hold off;
saveas(2, 'lasercut_pieces.svg')
