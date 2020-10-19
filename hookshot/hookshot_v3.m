% Coordinates from:
%     http://hessmer.org/gears/InvoluteSpurGearBuilder.html?circularPitch=8&pressureAngle=20&clearance=0.05&backlash=0.05&profileShift=0&gear1ToothCount=0&gear1CenterHoleDiamater=0&gear2ToothCount=12&gear2CenterHoleDiamater=1&showOption=3
%
% Angle of pressure determines the angle of the rack teeth because they need to be normal to each other.
% In order for two surfaces to touch at a point, they need to be parallel (or discontinuous).
% And the pressure is a normal force, QED.
% 
% The rack and pinion can both be represented by half a tooth, which is reflected and then transformed.
% Rotated n times around for the pinion.
% Translated up to times for the rack.
%
% To determine how far each should move, each rotation of one pinion tooth is a translation of one rack tooth.
% With width calculated as peak to peak for both
% 360/n deg -> (width of rack tooth, pk2pk)
%
% There is a sin(angle of pressure) transverse force.
%
% I should add tracks for the handle piece moving backwards, it often gets stuck from slight rotations.
% I can make this with lines cut out of the outer layer.
% There needs to be a name for this kind of mechanism.

clear;
clf;
more off;
clc;

% pinion (half-tooth)
% 12 teeth (each rotated 360/12 = 30deg = pi/6)
% rotate around 0
% reflect across start
P_pt = [
        0,       -12.6824;
        0.4307,  -12.6751;
        0.9341,  -12.6480;
        0.9244,  -12.6488;
        0.9476,  -12.6472;
        0.9613,  -12.6470;
        0.9479,  -12.6478;
        0.9749,  -12.6472;
        1.0843,  -12.6669;
        1.1927,  -12.7180;
        1.2976,  -12.8003;
        1.3966,  -12.9136;
        1.4873,  -13.0576;
        1.5672,  -13.2316;
        1.6340,  -13.4351;
        1.6855,  -13.6670;
        1.7194,  -13.9266;
        1.7334,  -14.2126;
        1.7330,  -14.4206;
        1.7775,  -14.5860;
        1.8684,  -14.8388;
        2.0235,  -15.1784;
        2.1288,  -15.3759;
        2.2547,  -15.5900;
        2.4039,  -15.8212;
        2.5770,  -16.0661;
        2.7765,  -16.3247;
        3.0017,  -16.5925;
        3.2556,  -16.8702;
        3.5394,  -17.1554;
        3.8162,  -17.4120;
        ];
n = 12;
P_t = [flipud(reflectAcrossLine(P_pt, P_pt(1,2)/P_pt(1,1), 0)); P_pt];
P_pinion = [];
for i = 1:n
    P_pinion = [P_pinion; P_t * rotccwd(-i*360/n)];
end
P_pinion = [P_pinion; P_pinion(1,:)];


% rack teeth
P_rt = [
        0.00000,  2.54648;
        1.11575,  2.54648;
        2.87475, -2.59648;
        4.00000, -2.59648;
        ]
P_rt = P_rt + [0, -15.278874397277832];
w = 8.0
P_r = [flipud(reflectAcrossLine(P_rt, Inf, 0)); P_rt];
P_rack = [];
n
for i = 1:floor(n/4)
    i
    P_rack = [P_rack; (P_r + [(i-1)*w, 0])];
    size(P_rack)
end

hold on
plot(P_pinion(:,1), P_pinion(:,2))
plot(P_rack(:,1), P_rack(:,2))
axis('equal')
hold off
