%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TREASURE CHEST LASER-CUT DESIGN
% Modelled on The Legend of Zelda: A Link Between Worlds

% Gold/brass trim will be made with 2mm EVA foam
% Pieces along the top will need the bottom edges sanded to fit.
% Pieces along angled jigsaws (the base) will also need to be sanded to fit.
% Ignore the slight veritcal mismatch in the flattened version.

% TODO:
%   - Draw out on paper.
%   - Determine how much EVA is needed.
%   - Order cut.

clear;
clc;
more off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SET THESE

% any same unit
MATERIAL_THICKNESS = 2.54/4;
WIDTH = 30;

TOP_JIGSAW      = [1 0 0 0 1]; % 1 = side,   0 = top
HIDDEN_JIGSAW   = [0 0 1 0 0]; % 1 = hidden, 0 = top
SIDE_JIGSAW     = [0 1 0 1];   % 1 = front,  0 = side, start from bottom
BOTTOM_JIGSAW   = [1 0 1 0 1]; % 1 = bottom, 0 = front/side
N_TOP_PANELS = 9; % #

DEBUG = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LEAVE THESE ALONE (SCALED BASED ON ABOVE)

TOP_WIDTH     = 39;
BOTTOM_WIDTH  = 32;
HEIGHT        = 22.4;
TOP_LENGTH    = 30;
BOTTOM_LENGTH = 24;
DIAMETER      = TOP_LENGTH;

FACTOR = WIDTH / TOP_WIDTH;

% normalize to given measure
TOP_WIDTH     = TOP_WIDTH     * FACTOR;
BOTTOM_WIDTH  = BOTTOM_WIDTH  * FACTOR;
HEIGHT        = HEIGHT        * FACTOR;
TOP_LENGTH    = TOP_LENGTH    * FACTOR;
BOTTOM_LENGTH = BOTTOM_LENGTH * FACTOR;
DIAMETER      = DIAMETER      * FACTOR;

HIDDEN_FRACTION = 0.2; % fraction of radius used for support beam thickness

% derived
FRONT_HEIGHT    = sqrt(HEIGHT^2       + ((TOP_LENGTH - BOTTOM_LENGTH) / 2)^2);
SIDE_HEIGHT     = sqrt(HEIGHT^2       + ((TOP_WIDTH  - BOTTOM_WIDTH)  / 2)^2);
DIAGONAL_HEIGHT = sqrt(FRONT_HEIGHT^2 + ((TOP_WIDTH  - BOTTOM_WIDTH)  / 2)^2);

FRONT_ANGLE = atand(((TOP_LENGTH - BOTTOM_LENGTH) / 2) / HEIGHT);
SIDE_ANGLE  = atand(((TOP_WIDTH  - BOTTOM_WIDTH)  / 2) / FRONT_HEIGHT);

% store in n x 3 cell array
% {'Name', [x; y; z], [xn; yn; zn]}
% 
Name_Mat_Norm = {};
cc = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOP SIDE

OUTER_RADIUS = DIAMETER / 2;
PANEL_ARC = 180 / N_TOP_PANELS;

LOWER_RADIUS = OUTER_RADIUS - (MATERIAL_THICKNESS / cosd(PANEL_ARC / 2));
PANEL_HEIGHT = 2 * LOWER_RADIUS * sind(PANEL_ARC / 2);

X_LOW  = LOWER_RADIUS * cosd(-PANEL_ARC / 2);
Y_LOW  = LOWER_RADIUS * sind(-PANEL_ARC / 2);
DX     = MATERIAL_THICKNESS;
DY     = PANEL_HEIGHT / length(TOP_JIGSAW);

% build jigsaw
[X, Y] = build_jigsaw(TOP_JIGSAW, 1);
P = [X_LOW + (DX * X); 
     Y_LOW + (DY * Y);
     zeros(size(X))];

% rotate
T = zeros(size(P).*[1,N_TOP_PANELS]);
for ii = 1:N_TOP_PANELS
    phi = (ii * PANEL_ARC) - (PANEL_ARC / 2);
    R = rotz(phi);
    istart = ((ii - 1) * size(P,2)) + 1;
    istop = (istart - 1) + size(P,2);
    T(:,istart:istop) = R*P;
end
P = T;
P = [[OUTER_RADIUS; 0; 0], P, [-OUTER_RADIUS; 0; 0]];
P = [P, P(:,1)];

% add z
P = bsxfun(@plus, P, [0; 0; (TOP_WIDTH/2)]);
P = roty(-90)*P;

% normal
n = [-1; 0; 0];

% save
Name_Mat_Norm{cc,1} = 'TOP_LEFT';
Name_Mat_Norm{cc,2} = P;
Name_Mat_Norm{cc,3} = n;
cc = cc + 1;
% reflect x for other side and save again
R = [-1 0 0; 0 1 0; 0 0 1]; 
Name_Mat_Norm{cc,1} = 'TOP_RIGHT';
Name_Mat_Norm{cc,2} = R*P;
Name_Mat_Norm{cc,3} = R*n;
cc = cc + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOP HIDDEN


OUTER_RADIUS = DIAMETER / 2;
PANEL_ARC = 180 / N_TOP_PANELS;
N_HIDDEN_JIGSAW = length(HIDDEN_JIGSAW);

LOWER_RADIUS = OUTER_RADIUS - (MATERIAL_THICKNESS / cosd(PANEL_ARC / 2));
PANEL_HEIGHT = 2 * LOWER_RADIUS * sind(PANEL_ARC / 2);

INNER_RADIUS = (1 - HIDDEN_FRACTION) * OUTER_RADIUS;

X_LOW  = LOWER_RADIUS * cosd(-PANEL_ARC / 2);
Y_LOW  = LOWER_RADIUS * sind(-PANEL_ARC / 2);
DX     = MATERIAL_THICKNESS;
DY     = PANEL_HEIGHT / length(HIDDEN_JIGSAW);

% draw jigsaw pattern
[X, Y] = build_jigsaw(HIDDEN_JIGSAW);
P = [X_LOW + (DX * X); 
     Y_LOW + (DY * Y)
     zeros(size(X))];

% rotate pattern for each panel
T = zeros(size(P).*[1,N_TOP_PANELS]);
for ii = 1:N_TOP_PANELS
    phi = (ii * PANEL_ARC) - (PANEL_ARC / 2);
    R = rotz(phi);
    istart = ((ii - 1) * size(P,2)) + 1;
    istop = (istart - 1) + size(P,2);
    T(:,istart:istop) = R*P;
end

P = T;
P = [[LOWER_RADIUS; 0; 0], P, [-LOWER_RADIUS; 0; 0]];

% add arch underneath
T = PANEL_ARC * (N_TOP_PANELS:-1:0);
P = [P, (INNER_RADIUS*[cosd(T); sind(T); zeros(size(T))])];
P = [P, P(:,1)];
% add Z
P = bsxfun(@plus, P, [0; 0; (MATERIAL_THICKNESS/2)]);

P = roty(-90)*P;

% normal
n = [-1; 0; 0];

% save
Name_Mat_Norm{cc,1} = 'HIDDEN_LEFT';
Name_Mat_Norm{cc,2} = P;
Name_Mat_Norm{cc,3} = n;
cc = cc + 1;
% reflect x for other side and save again
R = [-1 0 0; 0 1 0; 0 0 1]; 
Name_Mat_Norm{cc,1} = 'HIDDEN_RIGHT';
Name_Mat_Norm{cc,2} = R*P;
Name_Mat_Norm{cc,3} = R*n;
cc = cc + 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TOP PANEL

OUTER_RADIUS = DIAMETER / 2;
PANEL_ARC = 180 / N_TOP_PANELS;
N_TOP_JIGSAW = length(TOP_JIGSAW);

LOWER_RADIUS = OUTER_RADIUS - (MATERIAL_THICKNESS / cosd(PANEL_ARC / 2));
UPPER_RADIUS = LOWER_RADIUS * cosd(-PANEL_ARC / 2) + MATERIAL_THICKNESS;
PANEL_HEIGHT = 2 * LOWER_RADIUS * sind(PANEL_ARC / 2);

% build jigsaw
X_LOW  = (TOP_WIDTH / 2) - MATERIAL_THICKNESS;
Y_LOW  = -(PANEL_HEIGHT / 2);
DX     = MATERIAL_THICKNESS;
DY     = PANEL_HEIGHT / length(TOP_JIGSAW);
[X, Y] = build_jigsaw(~TOP_JIGSAW);
P = [X_LOW + (DX * X);
     Y_LOW + (DY * Y);
     (UPPER_RADIUS) * ones(size(Y))];
P = [P, rotz(180) * P, P(:,1)];

% hole in center
DX     = 0.5 * MATERIAL_THICKNESS;
DY     = 0.5 * PANEL_HEIGHT / length(HIDDEN_JIGSAW);
T = [ DX,  DX, -DX, -DX,  DX;
      DY, -DY, -DY,  DY,  DY;
     UPPER_RADIUS * ones(1,5)];
P = [P, [NaN; NaN; NaN], T];

% normal
n = [0; 0; 1];

% save
%R = eye(3); % for debug
for ii = 1:N_TOP_PANELS
    R = rotx(-(ii-0.5)*180/N_TOP_PANELS);
    Name_Mat_Norm{cc,1} = sprintf('TOP_PANEL_%i', ii);
    Name_Mat_Norm{cc,2} = R*P;
    Name_Mat_Norm{cc,3} = R*n;
    cc = cc + 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FRONT_PANEL

% height isn't the height of this panel because they're tilted
%TOP_WIDTH     = 39;
%BOTTOM_WIDTH  = 32;

JIGSAW_HEIGHT = DIAGONAL_HEIGHT - MATERIAL_THICKNESS;

% SIDE_JIGSAW   % 1 = front, 2 = side, start from bottom
% BOTTOM_JIGSAW % 1 = bottom, 0 = front/side
DX = MATERIAL_THICKNESS;
DY = JIGSAW_HEIGHT / length(SIDE_JIGSAW); % remove heigh of baseboard
% see diagrams in log book
BOTTOM_HEIGHT = MATERIAL_THICKNESS * secd(SIDE_ANGLE);
M = [((BOTTOM_WIDTH / 2) - BOTTOM_HEIGHT); -(FRONT_HEIGHT - MATERIAL_THICKNESS); 0];

n = [0; 0; 1];

% build jigsaw
[X, Y] = build_jigsaw(SIDE_JIGSAW);
P = [DX * X;
     DY * Y;
     zeros(size(Y))];
P = rotz(-SIDE_ANGLE)*P;
P = bsxfun(@plus, P, M);
P = [P, [-1 0 0; 0 1 0; 0 0 1]*fliplr(P)];
[X, Y] = build_jigsaw(~BOTTOM_JIGSAW, 0);
T = [-M(1) + Y * (2 * M(1) / length(BOTTOM_JIGSAW));
     M(2) - X * MATERIAL_THICKNESS;
     zeros(size(X))];
P = [P, T];
P = [P, P(:,1)];


P = rotx(FRONT_ANGLE)*P;
n = rotx(FRONT_ANGLE)*n;
P = bsxfun(@plus, P, [0; 0; (TOP_LENGTH / 2)]);



% save
Name_Mat_Norm{cc,1} = 'FRONT';
Name_Mat_Norm{cc,2} = P;
Name_Mat_Norm{cc,3} = n;
cc = cc + 1;

% reflect in z
P = roty(180)*P;
n = rotx(180)*n;

Name_Mat_Norm{cc,1} = 'BACK';
Name_Mat_Norm{cc,2} = P;
Name_Mat_Norm{cc,3} = n;
cc = cc + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIDE_PANEL

JIGSAW_HEIGHT = DIAGONAL_HEIGHT - MATERIAL_THICKNESS;

% SIDE_JIGSAW   % 1 = front, 2 = side, start from bottom
% BOTTOM_JIGSAW % 1 = bottom, 0 = front/side
DX = MATERIAL_THICKNESS;
DY = JIGSAW_HEIGHT / length(SIDE_JIGSAW); % remove heigh of baseboard
% see diagrams in log book
BOTTOM_HEIGHT = MATERIAL_THICKNESS * secd(FRONT_ANGLE);
M = [((BOTTOM_LENGTH / 2) - BOTTOM_HEIGHT); -(SIDE_HEIGHT - MATERIAL_THICKNESS); 0];

n = [0; 0; 1];

% build jigsaw
[X, Y] = build_jigsaw(~SIDE_JIGSAW);
P = [DX * X;
     DY * Y;
     zeros(size(Y))];
P = rotz(-FRONT_ANGLE)*P;
P = bsxfun(@plus, P, M);
P = [P, [-1 0 0; 0 1 0; 0 0 1]*fliplr(P)];
[X, Y] = build_jigsaw(~BOTTOM_JIGSAW, 0);
T = [-M(1) + Y * (2 * M(1) / length(BOTTOM_JIGSAW));
     M(2) - X * MATERIAL_THICKNESS;
     zeros(size(X))];
P = [P, T];
P = [P, P(:,1)];


P = rotx(SIDE_ANGLE)*P;
n = rotx(SIDE_ANGLE)*n;
P = bsxfun(@plus, P, [0; 0; (TOP_WIDTH / 2)]);
P = roty(90)*P;
n = roty(90)*n;

% save
Name_Mat_Norm{cc,1} = 'LEFT';
Name_Mat_Norm{cc,2} = P;
Name_Mat_Norm{cc,3} = n;
cc = cc + 1;

% reflect in z
P = roty(180)*P;
n = roty(180)*n;

Name_Mat_Norm{cc,1} = 'RIGHT';
Name_Mat_Norm{cc,2} = P;
Name_Mat_Norm{cc,3} = n;
cc = cc + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BOTTOM_PANEL

% build front jigsaw
DX = MATERIAL_THICKNESS;
DY = -(BOTTOM_WIDTH - (2 * MATERIAL_THICKNESS)) / length(BOTTOM_JIGSAW);
X_LOW = (BOTTOM_LENGTH / 2) - MATERIAL_THICKNESS;
Y_LOW = (BOTTOM_WIDTH  / 2) - MATERIAL_THICKNESS;

[X, Y] = build_jigsaw(BOTTOM_JIGSAW, 1);
P = [Y_LOW + DY * Y;
     zeros(size(Y));
     X_LOW + DX * X;];

% build side jigsaw
DX = MATERIAL_THICKNESS;
DY = (BOTTOM_LENGTH - (2 * MATERIAL_THICKNESS)) / length(BOTTOM_JIGSAW);
X_LOW = (BOTTOM_WIDTH  / 2) - MATERIAL_THICKNESS;
Y_LOW = -((BOTTOM_LENGTH / 2) - MATERIAL_THICKNESS);

T = [X_LOW + DX * X;
     zeros(size(Y));
     Y_LOW + DY * Y];


% add corners
P = [[(BOTTOM_WIDTH / 2); 0; -(BOTTOM_LENGTH / 2)], T, [(BOTTOM_WIDTH / 2); 0; (BOTTOM_LENGTH / 2)], P];
P = [P, roty(180)*P];
P = [P, P(:,1)];
% move everything down
P = bsxfun(@plus, P, [0; -HEIGHT; 0]);
n = [0; -1; 0];

Name_Mat_Norm{cc,1} = 'BOTTOM';
Name_Mat_Norm{cc,2} = P;
Name_Mat_Norm{cc,3} = n;
cc = cc + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% draw it all

% outer face or inner face
R = eye(3);
%R = roty(-90);
for ii = 1:size(Name_Mat_Norm,1)
    Name_Mat_Norm{ii,2} = bsxfun(@plus, Name_Mat_Norm{ii,2}, 0 * MATERIAL_THICKNESS * Name_Mat_Norm{ii,3});
    Name_Mat_Norm{ii,2} = R * Name_Mat_Norm{ii,2};
    Name_Mat_Norm{ii,3} = R * Name_Mat_Norm{ii,3};
end

%figure(1);
%clf;
%hold on;
%axis('equal');
%for ii = 1:size(Name_Mat_Norm,1)
%    plot3(Name_Mat_Norm{ii,2}(1,:), Name_Mat_Norm{ii,2}(2,:), Name_Mat_Norm{ii,2}(3,:))
%end
%% draw axes
%plot3([0 1], [0 0], [0 0], 'r')
%plot3([0 0], [0 1], [0 0], 'g')
%plot3([0 0], [0 0], [0 1], 'b')
%hold off;
%view(Name_Mat_Norm{13,3}) % view from a slight angle


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% flatten

ii = 1;
% top sides
M = Name_Mat_Norm{ii,2}(:,1);
Name_Mat_Norm{ii,2} = bsxfun(@minus, Name_Mat_Norm{ii,2},  M);
Name_Mat_Norm{ii,2} = roty( 90) * (Name_Mat_Norm{ii,2});
Name_Mat_Norm{ii,2} = bsxfun(@minus, Name_Mat_Norm{ii,2}, -M);
ii = ii + 1;
M = Name_Mat_Norm{ii,2}(:,1);
Name_Mat_Norm{ii,2} = bsxfun(@minus, Name_Mat_Norm{ii,2},  M);
Name_Mat_Norm{ii,2} = roty(-90) * (Name_Mat_Norm{ii,2});
Name_Mat_Norm{ii,2} = bsxfun(@minus, Name_Mat_Norm{ii,2}, -M);
ii = ii + 1;
% hidden
M = Name_Mat_Norm{ii,2}(:,1);
Name_Mat_Norm{ii,2} = bsxfun(@minus, Name_Mat_Norm{ii,2}, M);
Name_Mat_Norm{ii,2} = roty( 90) * (Name_Mat_Norm{ii,2});
M = [(-TOP_WIDTH / 2) - TOP_LENGTH; 0; (TOP_LENGTH / 2)];
Name_Mat_Norm{ii,2} = bsxfun(@plus,  Name_Mat_Norm{ii,2}, M);
ii = ii + 1;
M = Name_Mat_Norm{ii,2}(:,1);
Name_Mat_Norm{ii,2} = bsxfun(@minus, Name_Mat_Norm{ii,2}, M);
Name_Mat_Norm{ii,2} = roty(-90) * (Name_Mat_Norm{ii,2});
M = [(TOP_WIDTH / 2) + TOP_LENGTH; 0; (TOP_LENGTH / 2)];
Name_Mat_Norm{ii,2} = bsxfun(@plus,  Name_Mat_Norm{ii,2}, M);
ii = ii + 1;
% top
for jj = 1:N_TOP_PANELS
    R = rotx((jj - 0.5)*180/N_TOP_PANELS);
    Name_Mat_Norm{ii,2} = R*Name_Mat_Norm{ii,2};
    Name_Mat_Norm{ii,2} = bsxfun(@plus, Name_Mat_Norm{ii,2}, [0; (jj - 0.5) * PANEL_HEIGHT; 0]);
    ii = ii + 1;
end
% try to move to the z=0 plane
for jj = 1:size(Name_Mat_Norm,1)
    Name_Mat_Norm{jj,2}(3,:) = Name_Mat_Norm{jj,2}(3,:) - (TOP_LENGTH / 2);
end
% all lower pieces out of order for folding purposes
for jj = 1:5
    Name_Mat_Norm{ii + jj - 1,2} = rotx(-FRONT_ANGLE) * Name_Mat_Norm{ii + jj - 1,2};
end
ii = ii + 1;
M = [0; -FRONT_HEIGHT; 0];
for jj = 1:4
    Name_Mat_Norm{ii + jj - 1,2} = bsxfun(@minus, Name_Mat_Norm{ii + jj - 1,2}, M);
    Name_Mat_Norm{ii + jj - 1,2} = rotx(-90 + FRONT_ANGLE) * Name_Mat_Norm{ii + jj - 1,2};
    Name_Mat_Norm{ii + jj - 1,2} = bsxfun(@plus,  Name_Mat_Norm{ii + jj - 1,2}, M);
end
M = [0; -(FRONT_HEIGHT + BOTTOM_LENGTH); 0];
Name_Mat_Norm{ii,2} = bsxfun(@minus, Name_Mat_Norm{ii,2}, M);
Name_Mat_Norm{ii,2} = rotx(-90 + FRONT_ANGLE) * Name_Mat_Norm{ii,2};
Name_Mat_Norm{ii,2} = bsxfun(@plus,  Name_Mat_Norm{ii,2}, M);
ii = ii + 1;
M = [(BOTTOM_WIDTH/2); -(FRONT_HEIGHT + BOTTOM_LENGTH); 0];
Name_Mat_Norm{ii,2} = bsxfun(@minus, Name_Mat_Norm{ii,2}, M);
Name_Mat_Norm{ii,2} = roty(-(90 - SIDE_ANGLE)) * Name_Mat_Norm{ii,2};
Name_Mat_Norm{ii,2} = bsxfun(@plus,  Name_Mat_Norm{ii,2}, M);
ii = ii + 1;
M = [-(BOTTOM_WIDTH/2); -(FRONT_HEIGHT + BOTTOM_LENGTH); 0];
Name_Mat_Norm{ii,2} = bsxfun(@minus, Name_Mat_Norm{ii,2}, M);
Name_Mat_Norm{ii,2} = roty( (90 - SIDE_ANGLE)) * Name_Mat_Norm{ii,2};
Name_Mat_Norm{ii,2} = bsxfun(@plus,  Name_Mat_Norm{ii,2}, M);
% moving jigsaws together
ii = 4 + N_TOP_PANELS + 2;
Name_Mat_Norm{ii,2}(2,:) = Name_Mat_Norm{ii,2}(2,:) + 2 * MATERIAL_THICKNESS;
ii = 4 + N_TOP_PANELS + 3;
Name_Mat_Norm{ii,2}(2,:) = Name_Mat_Norm{ii,2}(2,:) + 1 * MATERIAL_THICKNESS;
Name_Mat_Norm{ii,2}(1,:) = Name_Mat_Norm{ii,2}(1,:) - 1 * MATERIAL_THICKNESS;
ii = 4 + N_TOP_PANELS + 4;
Name_Mat_Norm{ii,2}(2,:) = Name_Mat_Norm{ii,2}(2,:) + 1 * MATERIAL_THICKNESS;
Name_Mat_Norm{ii,2}(1,:) = Name_Mat_Norm{ii,2}(1,:) + 1 * MATERIAL_THICKNESS;
ii = 4 + N_TOP_PANELS + 5;
Name_Mat_Norm{ii,2}(2,:) = Name_Mat_Norm{ii,2}(2,:) + 1 * MATERIAL_THICKNESS;

% check that it's all flat
% as long as there are only a handful of unevenly groups bars, this should be fine
%figure(2);
%clf;
%H = [];
%for ii = 1:size(Name_Mat_Norm,1)
%    H = [H, Name_Mat_Norm{ii,2}(3,:) = Name_Mat_Norm{ii,2}(3,:)];
%end
%hist(H, 100)

% draw flattened SVG for laser cutting
figure(3);
clf;
hold on;
for ii = 1:size(Name_Mat_Norm,1)
    % draw >0 green, <0 red, =0 black
    if sum(Name_Mat_Norm{ii,2}(3,:)) > 0
        c = 'g';
    elseif sum(Name_Mat_Norm{ii,2}(3,:)) < 0
        c = 'r';
    else
        c = 'k';
    end
    %plot3(Name_Mat_Norm{ii,2}(1,:), Name_Mat_Norm{ii,2}(2,:), Name_Mat_Norm{ii,2}(3,:), c);
    
    % blue for cut
    c = 'b';
    plot(Name_Mat_Norm{ii,2}(1,:), Name_Mat_Norm{ii,2}(2,:), c);
end
%plot3([0 1], [0 0], [0 0], 'r')
%plot3([0 0], [0 1], [0 0], 'g')
%plot3([0 0], [0 0], [0 1], 'b')
axis('equal');
axis('off');
hold off;
saveas(3, 'lasercut_chest.svg');
