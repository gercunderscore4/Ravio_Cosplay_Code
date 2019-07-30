%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TORNADO ROD LASER-CUT DESIGN
% Modelled on The Legend of Zelda: A Link Between Worlds

% Final SVG requires some adjustements for laser cutting.

clear;
clc;
more off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GENERIC CIRCLE (FOR EASY PLOTTING)

% circle count, number of points in a calculated arc
CURVE_SIZE = 30;

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
% USER EDITABLE SETTINGS

% cm, deg

% material width
MAT_W = 2.54 / 4;
MAT_HW = MAT_W / 2;

WING_L = 20;
CENTER_R = 5;

POLE_H = 2 * 2.54;
POLE_R = 2.54 / 2;

ROD_L = 15;
BUTTON_L = 6 * MAT_W;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USEFUL CALCULATIONS

ROD_HW = POLE_R + 2 * MAT_W;
ROD_W = 2 * ROD_HW;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BUTTON

THIN_ROW_W = 2 * MAT_W;
CROSSBAR_H =  2 * MAT_W;

ROD_POINTS = [
              POLE_R + MAT_W, 0;
              POLE_R + MAT_W, 2 * MAT_W;
              POLE_R + MAT_W + MAT_HW * (1 - COS_ARC), 2 * MAT_W * (1 + SIN_ARC);
              POLE_R + MAT_W + MAT_HW * (1 + SIN_ARC), 2 * MAT_W * (1 + COS_ARC);
              ROD_HW, -CROSSBAR_H;
              THIN_ROW_W, -CROSSBAR_H + -(ROD_HW - THIN_ROW_W);
              THIN_ROW_W, -ROD_L;
              ];
ROD_POINTS = [
              flipud(ROD_POINTS)*[-1,0;0,1];
              ROD_POINTS;
              ];
ROD_POINTS = [
              ROD_POINTS;
              THIN_ROW_W + BUTTON_L, -ROD_L;
              THIN_ROW_W + BUTTON_L, -ROD_L + -MAT_W*2;
              THIN_ROW_W + BUTTON_L, -ROD_L + -MAT_W*2;
              -THIN_ROW_W, -ROD_L + -MAT_W*2;
              ROD_POINTS(1,:);
              ];

ROD_POINTS = [
              ROD_POINTS;
              NaN, NaN;
              +(THIN_ROW_W - MAT_W), -CROSSBAR_H + -(ROD_HW - THIN_ROW_W) + -CROSSBAR_H/2;
              +(THIN_ROW_W - MAT_W), -ROD_L;
              -(THIN_ROW_W - MAT_W), -ROD_L;
              -(THIN_ROW_W - MAT_W), -CROSSBAR_H + -(ROD_HW - THIN_ROW_W) + -CROSSBAR_H/2;
              +(THIN_ROW_W - MAT_W), -CROSSBAR_H + -(ROD_HW - THIN_ROW_W) + -CROSSBAR_H/2;
              ];
ROD_POINTS = ROD_POINTS';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASE

CASE_POINTS = [
               ROD_HW - 1.5*MAT_W, 0;
               ROD_HW - 1.5*MAT_W, 2*MAT_W;
               ROD_HW,             2*MAT_W;
               ROD_HW, 0;
               ROD_HW, 0 - MAT_W;
               ROD_HW + MAT_W, 0 - MAT_W;
               ROD_HW + MAT_W, -CROSSBAR_H + -MAT_W*2 + MAT_W;
               ROD_HW,         -CROSSBAR_H + -MAT_W*2 + MAT_W;
               ROD_HW,         -CROSSBAR_H + -MAT_W*2;
               ROD_HW + MAT_W, -CROSSBAR_H + -MAT_W*2;
               THIN_ROW_W + MAT_W, -CROSSBAR_H + -MAT_W*2 + -(ROD_HW - THIN_ROW_W);
               THIN_ROW_W,         -CROSSBAR_H + -MAT_W*2 + -(ROD_HW - THIN_ROW_W);
               THIN_ROW_W,         -CROSSBAR_H + -MAT_W*2 + -(ROD_HW - THIN_ROW_W) - MAT_W;
               THIN_ROW_W + MAT_W, -CROSSBAR_H + -MAT_W*2 + -(ROD_HW - THIN_ROW_W) - MAT_W;
               THIN_ROW_W + MAT_W, -ROD_L + MAT_W;
               THIN_ROW_W,         -ROD_L + MAT_W;
               THIN_ROW_W,         -ROD_L;
               THIN_ROW_W + MAT_W, -ROD_L;
               THIN_ROW_W + MAT_W, -ROD_L + -MAT_W*2 + -MAT_W*3;
               THIN_ROW_W,         -ROD_L + -MAT_W*2 + -MAT_W*3;
               THIN_ROW_W,         -ROD_L + -MAT_W*2 + -MAT_W*2;
               ];
CASE_POINTS = [
               CASE_POINTS;
               flipud(CASE_POINTS)*[-1,0;0,1];
               CASE_POINTS(1,:);
               ];
CASE_POINTS = CASE_POINTS';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CASE SIDES

SIDE_1_POINT = [
                ROD_HW, 0;
                ROD_HW, 0 - MAT_W;
                ROD_HW + MAT_W, 0 - MAT_W;
                ROD_HW + MAT_W, -CROSSBAR_H + -MAT_W*2 + MAT_W;
                ROD_HW,         -CROSSBAR_H + -MAT_W*2 + MAT_W;
                ROD_HW,         -CROSSBAR_H + -MAT_W*2;
                ];
SIDE_1_POINT = SIDE_1_POINT - [ROD_HW + MAT_W + MAT_HW, 0];
SIDE_1_POINT = [
                SIDE_1_POINT;
                flipud(SIDE_1_POINT)*[-1,0;0,1];
                SIDE_1_POINT(1,:);
                ];
SIDE_1_POINT = SIDE_1_POINT + [ROD_HW + MAT_W + MAT_HW, 0];
SIDE_1_POINT = SIDE_1_POINT';

SIDE_2_POINT = [
                ROD_HW + MAT_W, -CROSSBAR_H + -MAT_W*2;
                ROD_HW, -CROSSBAR_H + -MAT_W*2;
                THIN_ROW_W, -CROSSBAR_H + -MAT_W*2 + -(ROD_HW - THIN_ROW_W);
                THIN_ROW_W + MAT_W, -CROSSBAR_H + -MAT_W*2 + -(ROD_HW - THIN_ROW_W);
                ];
SIDE_2_POINT = [
                SIDE_2_POINT;
                SIDE_2_POINT(1,:);
                ];
SIDE_2_POINT = SIDE_2_POINT';

SIDE_3_POINT = [
                THIN_ROW_W,         -CROSSBAR_H + -MAT_W*2 + -(ROD_HW - THIN_ROW_W);
                THIN_ROW_W,         -CROSSBAR_H + -MAT_W*2 + -(ROD_HW - THIN_ROW_W) - MAT_W;
                THIN_ROW_W + MAT_W, -CROSSBAR_H + -MAT_W*2 + -(ROD_HW - THIN_ROW_W) - MAT_W;
                THIN_ROW_W + MAT_W, -ROD_L + MAT_W;
                THIN_ROW_W,         -ROD_L + MAT_W;
                THIN_ROW_W,         -ROD_L;
                ];
SIDE_3_POINT = SIDE_3_POINT - [THIN_ROW_W + MAT_W + MAT_HW, 0];
SIDE_3_POINT = [
                SIDE_3_POINT;
                flipud(SIDE_3_POINT)*[-1,0;0,1];
                SIDE_3_POINT(1,:);
                ];
SIDE_3_POINT = SIDE_3_POINT + [THIN_ROW_W + MAT_W + MAT_HW, 0];
SIDE_3_POINT = SIDE_3_POINT';

SIDE_4_POINT = [
                THIN_ROW_W,         -CROSSBAR_H + -MAT_W*2 + -(ROD_HW - THIN_ROW_W);
                THIN_ROW_W,         -CROSSBAR_H + -MAT_W*2 + -(ROD_HW - THIN_ROW_W) - MAT_W;
                THIN_ROW_W + MAT_W, -CROSSBAR_H + -MAT_W*2 + -(ROD_HW - THIN_ROW_W) - MAT_W;
                THIN_ROW_W + MAT_W, -ROD_L + MAT_W;
                THIN_ROW_W,         -ROD_L + MAT_W;
                THIN_ROW_W,         -ROD_L;
                THIN_ROW_W + MAT_W, -ROD_L;
                THIN_ROW_W + MAT_W, -ROD_L + -MAT_W*2 + -MAT_W*2;
                ];
SIDE_4_POINT = SIDE_4_POINT - [THIN_ROW_W + MAT_W + MAT_HW, 0];
SIDE_4_POINT = [
                SIDE_4_POINT;
                flipud(SIDE_4_POINT)*[-1,0;0,1];
                SIDE_4_POINT(1,:);
                ];
SIDE_4_POINT = SIDE_4_POINT - [THIN_ROW_W + MAT_W + MAT_HW, 0];
SIDE_4_POINT = SIDE_4_POINT';


SIDE_5_POINT = [
                THIN_ROW_W + MAT_W, -ROD_L + -MAT_W*2 + -MAT_W*3;
                THIN_ROW_W,         -ROD_L + -MAT_W*2 + -MAT_W*3;
                THIN_ROW_W,         -ROD_L + -MAT_W*2 + -MAT_W*2;
                ];
SIDE_5_POINT = [
                SIDE_5_POINT;
                flipud(SIDE_5_POINT)*[-1,0;0,1];
                ];
SIDE_5_POINT = SIDE_5_POINT - [0, -ROD_L + -MAT_W*2 + -MAT_W*3.5];
SIDE_5_POINT = [
                SIDE_5_POINT;
                flipud(SIDE_5_POINT)*[1,0;0,-1];
                SIDE_5_POINT(1,:);
                ];
SIDE_5_POINT = SIDE_5_POINT + [0, -ROD_L + -MAT_W*2 + -MAT_W*3.5];
SIDE_5_POINT = SIDE_5_POINT';

% relections
SIDE_6_POINT = (SIDE_1_POINT'*[-1,0;0,1])';

SIDE_7_POINT = (SIDE_2_POINT'*[-1,0;0,1])';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BASE

BASE_POINTS = [
               ROD_HW - 1.0*MAT_W, MAT_HW;
               ROD_HW - 1.5*MAT_W, MAT_HW;
               ROD_HW - 1.5*MAT_W, MAT_HW + MAT_W;
               ROD_HW - 0.0*MAT_W, MAT_HW + MAT_W;
               ];
BASE_POINTS = [
               BASE_POINTS;
               flipud(BASE_POINTS)*[1,0;0,-1];
               BASE_POINTS(1,:);
               ];
BASE_POINTS = [
               BASE_POINTS;
               NaN, NaN;
               flipud(BASE_POINTS)*[-1,0;0,1];
               ];
BASE_POINTS = [
               BASE_POINTS;
               NaN, NaN;
               +(ROD_HW + MAT_W), +(2.5 * MAT_W);
               -(ROD_HW + MAT_W), +(2.5 * MAT_W);
               -(ROD_HW + MAT_W), -(2.5 * MAT_W);
               +(ROD_HW + MAT_W), -(2.5 * MAT_W);
               +(ROD_HW + MAT_W), +(2.5 * MAT_W);
               NaN, NaN;
               POLE_R * UNIT_CIRCLE;
               ];
BASE_POINTS = BASE_POINTS';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WINGS

hole = [
        ROD_HW,         +MAT_HW;
        ROD_HW,         -MAT_HW;
        ROD_HW - MAT_W, -MAT_HW;
        ROD_HW - MAT_W, +MAT_HW;
        ROD_HW,         +MAT_HW;
        ];

OCT_H = ROD_HW + MAT_W;
OCT_W = OCT_H * tand(360/(8*2));
WING_POINTS = [
               % octagon around holes
               OCT_W, OCT_H;
               OCT_H, OCT_W;
               % connect octagon and wings without adding weakness
               OCT_H, max([POLE_R, OCT_W, 2*MAT_W]);
               % wing, with jigsaw for pieces to attach to top
               WING_L - 5*MAT_W, 1.5*MAT_W;
               WING_L - 5*MAT_W, 2*MAT_W;
               WING_L - 4*MAT_W, 2*MAT_W;
               WING_L - 4*MAT_W, 1*MAT_W;
               WING_L - 2*MAT_W, 1*MAT_W;
               WING_L - 2*MAT_W, 2*MAT_W;
               WING_L - 0*MAT_W, 2*MAT_W;
               WING_L - 0*MAT_W, 1*MAT_W;
               WING_L - 1*MAT_W, 1*MAT_W;
               ];
WING_POINTS = [
               WING_POINTS        *[ 1,0;0, 1];
               flipud(WING_POINTS)*[ 1,0;0,-1];
               WING_POINTS        *[-1,0;0,-1];
               flipud(WING_POINTS)*[-1,0;0, 1];
               WING_POINTS(1,:);
               ];
WING_POINTS = [
               WING_POINTS;
               % hole for pole
               NaN, NaN;
               POLE_R * UNIT_CIRCLE;
               % holes for breaks
               NaN, NaN;
               (rotccwd( 45)*(hole'))';
               NaN, NaN;
               (rotccwd(135)*(hole'))';
               NaN, NaN;
               (rotccwd(225)*(hole'))';
               NaN, NaN;
               (rotccwd(315)*(hole'))';
               % holes for attatching top
               NaN, NaN;
               (rotccwd( 90)*(hole'))';
               NaN, NaN;
               (rotccwd(270)*(hole'))';
               ];
WING_POINTS = WING_POINTS';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WING SIDES

WSIDE_1_POINTS = [
                  WING_L - 5*MAT_W, 2*MAT_W;
                  WING_L - 4*MAT_W, 2*MAT_W;
                  WING_L - 4*MAT_W, 1*MAT_W;
                  WING_L - 2*MAT_W, 1*MAT_W;
                  WING_L - 2*MAT_W, 2*MAT_W;
                  WING_L - 1*MAT_W, 2*MAT_W;
                  ];
DELTA = [0, 2.5*MAT_W];
WSIDE_1_POINTS = WSIDE_1_POINTS - DELTA;
WSIDE_1_POINTS = [
                  WSIDE_1_POINTS;
                  flipud(WSIDE_1_POINTS)*[1,0;0,-1];
                  WSIDE_1_POINTS(1,:);
                  ];
WSIDE_1_POINTS = WSIDE_1_POINTS + DELTA;
WSIDE_1_POINTS = WSIDE_1_POINTS';

WSIDE_2_POINTS = ((WSIDE_1_POINTS')*[1,0;0,-1])';

WSIDE_3_POINTS = ((WSIDE_1_POINTS')*[-1,0;0,1])';

WSIDE_4_POINTS = ((WSIDE_1_POINTS')*[-1,0;0,-1])';

WSIDE_5_POINTS = [
                  WING_L - 0*MAT_W, +2*MAT_W;
                  WING_L - 0*MAT_W, +1*MAT_W;
                  WING_L - 1*MAT_W, +1*MAT_W;
                  WING_L - 1*MAT_W, -1*MAT_W;
                  WING_L - 0*MAT_W, -1*MAT_W;
                  WING_L - 0*MAT_W, -2*MAT_W;
                  WING_L + 1*MAT_W, -2*MAT_W;
                  WING_L + 1*MAT_W, -1*MAT_W;
                  WING_L + 2*MAT_W, -1*MAT_W;
                  WING_L + 2*MAT_W, +1*MAT_W;
                  WING_L + 1*MAT_W, +1*MAT_W;
                  WING_L + 1*MAT_W, +2*MAT_W;
                  WING_L - 0*MAT_W, +2*MAT_W;
                  ];
WSIDE_5_POINTS = WSIDE_5_POINTS';

WSIDE_6_POINTS = ((WSIDE_5_POINTS')*[-1,0;0,1])';

WSIDE_7_POINTS = [
                  1*MAT_HW, OCT_H + 0*MAT_W;
                  1*MAT_HW, OCT_H + 1*MAT_W;
                  3*MAT_HW, OCT_H + 1*MAT_W;
                  3*MAT_HW, OCT_H + 2*MAT_W;
                  1*MAT_HW, OCT_H + 2*MAT_W;
                  1*MAT_HW, OCT_H + 3*MAT_W;
                  ];
WSIDE_7_POINTS = [
                  WSIDE_7_POINTS;
                  flipud(WSIDE_7_POINTS)*[-1,0;0,1];
                  WSIDE_7_POINTS(1,:);
                  ];
WSIDE_7_POINTS = WSIDE_7_POINTS';

WSIDE_8_POINTS = ((WSIDE_7_POINTS')*[1,0;0,-1])';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WING HOLDER

HOLDER_POINTS = [
                 POLE_R * UNIT_CIRCLE;
                 NaN, NaN;
                 (POLE_R + MAT_W) * UNIT_CIRCLE;
                 ];
HOLDER_POINTS = HOLDER_POINTS';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT AND SAVE

figure(1);
clf;
hold on;

plot(0,0,'r+');

plot(ROD_POINTS(1,:) - 2*ROD_W , ROD_POINTS(2,:), 'k');

plot(CASE_POINTS(1,:), CASE_POINTS(2,:), 'k');
plot(SIDE_1_POINT(1,:), SIDE_1_POINT(2,:), 'b');
plot(SIDE_2_POINT(1,:), SIDE_2_POINT(2,:), 'b');
plot(SIDE_3_POINT(1,:), SIDE_3_POINT(2,:), 'b');
plot(SIDE_4_POINT(1,:), SIDE_4_POINT(2,:), 'b');
plot(SIDE_5_POINT(1,:), SIDE_5_POINT(2,:), 'b');
plot(SIDE_6_POINT(1,:), SIDE_6_POINT(2,:), 'b');
plot(SIDE_7_POINT(1,:), SIDE_7_POINT(2,:), 'b');

plot(CASE_POINTS(1,:) + 2 * ROD_W, CASE_POINTS(2,:), 'k');

plot(BASE_POINTS(1,:), BASE_POINTS(2,:) + 8*MAT_W, 'k');

plot(BASE_POINTS(1,:), BASE_POINTS(2,:) + 15*MAT_W, 'k');

plot(WING_POINTS(1,:), WING_POINTS(2,:) + 30*MAT_W, 'k');
plot(WSIDE_1_POINTS(1,:), WSIDE_1_POINTS(2,:) + 30*MAT_W, 'b');
plot(WSIDE_2_POINTS(1,:), WSIDE_2_POINTS(2,:) + 30*MAT_W, 'b');
plot(WSIDE_3_POINTS(1,:), WSIDE_3_POINTS(2,:) + 30*MAT_W, 'b');
plot(WSIDE_4_POINTS(1,:), WSIDE_4_POINTS(2,:) + 30*MAT_W, 'b');
plot(WSIDE_5_POINTS(1,:), WSIDE_5_POINTS(2,:) + 30*MAT_W, 'b');
plot(WSIDE_6_POINTS(1,:), WSIDE_6_POINTS(2,:) + 30*MAT_W, 'b');
plot(WSIDE_7_POINTS(1,:), WSIDE_7_POINTS(2,:) + 30*MAT_W, 'b');
plot(WSIDE_8_POINTS(1,:), WSIDE_8_POINTS(2,:) + 30*MAT_W, 'b');

plot(WING_POINTS(1,:), WING_POINTS(2,:) + 45*MAT_W, 'k');

plot(HOLDER_POINTS(1,:), HOLDER_POINTS(2,:) + 55*MAT_W, 'k');

axis('equal');
axis('off');
hold off;
saveas(1, 'torando_design.svg')
