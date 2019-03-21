% draw chain for hookshot
clear;
clc;
more off;

% Hey! Look! A Link!
%    __________
%   /  ______  \
%  /  /      \  \
%  | |        | |
%  \  \______/  /
%   \__________/  
%    __________      __________      __________
%   /  ______  \    /  ______  \    /  ______  \ 
%  /  /    __\__\__/__/__  __\__\__/__/__    \  \
%  | |    |______________||______________|    | |
%  \  \______/  /  \  \______/  /  \  \______/  /
%   \__________/    \__________/    \__________/ 
%

% ____
%     \
%      \
%      |
% quadrant 1 of a unit circle


% CCW
%      _---|<--_
%     /    |    \
%    V   2 | 1   |
%   -------+-------
%    |   3 | 4   ^
%     \_   |   _/
%       -->|---
% CW
%      _-->|---_
%     /    |    \
%    |   2 | 1   V
%   -------+-------
%    ^   3 | 4   |
%     \_   |   _/
%       ---|<--
%
% CCW 1: [ c,  s]
% CCW 2: [-s,  c]
% CCW 3: [-c, -s]
% CCW 4: [ s, -c]
%
% CW 1: [ s,  c]
% CW 2: [-c,  s]
% CW 3: [-s, -c]
% CW 4: [ c, -s]
ca = cos(linspace(0,pi/2,10)');
sa = flipud(ca);


L = [-0.5, 0;
      sa+1, -ca+1;
     -ca+3,  sa+1;
     4.5, 2];
n = size(L,1);
c = floor(n/2);
L = L / (L(n,1) - L(1,1));
L = L - L(c,:);
% get angle
theta = 90-atan2d(L(1,2) - L(n,2), L(1,1) - L(n,1));

% get thick version
bt = 0.1;
P = add_thickness(L,bt);
% drill holes
ht = 0.05;
P = [P; 
     NaN, NaN;
    ([ ca,  sa;
      -sa,  ca;
      -ca, -sa;
       sa, -ca]*ht + L(1,:));
     NaN, NaN;
    ([ ca,  sa;
      -sa,  ca;
      -ca, -sa;
       sa, -ca]*ht + L(n,:));
     NaN, NaN;
    ([ ca,  sa;
      -sa,  ca;
      -ca, -sa;
       sa, -ca]*ht + L(c,:))];

rho = norm(L(1,:));
rhi = abs(L(1,2));
H = [ [-ca,  sa]*rho+bt + [-bt,0];
     ([ sa,  ca]*bt + [0,rho]);
     ([ ca, -sa]*bt + [0,2*bt]);
      %[-sa,  ca]*(rhi-bt);
    ];
H = [H;flipud(H*[1,0;0,-1])];
H = [H;H(1,:)];

T = [([ ca,  sa]*ht + [0,rho]);
     ([-sa,  ca]*ht + [0,rho]);
     ([-ca, -sa]*ht + [0,rhi]);
     ([ sa, -ca]*ht + [0,rhi]);
    ];
T = [T;T(1,:)];
T = [T;NaN,NaN;flipud(T*[1,0;0,-1])];

theta = acosd(rho-3*bt);
M = linspace(0,theta,18)';
M = [-cosd(M),  sind(M)]*(rho-bt) + [0,bt];
M = [M;flipud(M*[1,0;0,-1])];
M = [M;M(1,:)];

H = [H;
     NaN, NaN;
     T;
     NaN, NaN;
     M;
     ];

fig = figure(1);
clf;
hold on;
angles = linspace(0,55,5);
for jj = 1:length(angles)
    phi = angles(jj);
    R = [cosd(phi) -sind(phi); sind(phi) cosd(phi)];
    C = [L(c,1), 0];
    NL = [R*(L-C)']';
    NP = [R*(P-C)']';
    C = [NL(1,1), 0];
    NL = NL-C;
    NP = NP-C;
    w = NL(n,1);
    for ii = 1:5
        %plot((ii-1.5)*w + NL(:,1),          (jj-1)*1.5 +  NL(:,2));
        %plot((ii-1.5)*w + NL(:,1),          (jj-1)*1.5 + -NL(:,2));
        %plot((ii-1.5)*w + NL([1,n],1),      (jj-1)*1.5 + -NL([1,n],2), '*');
        %plot((ii-1.5)*w + NL([1,n],1),      (jj-1)*1.5 +  NL([1,n],2), '*');
        %plot((ii-1.5)*w + NL(floor(n/2),1), (jj-1)*1.5 +  NL(floor(n/2),2), '*');
        plot((ii-1.5)*w + NP(:,1),          (jj-1)*1.5 +  NP(:,2));
        plot((ii-1.5)*w + NP(:,1),          (jj-1)*1.5 + -NP(:,2));
        plot((  -0.5)*w + H(:,1),           (jj-1)*1.5 + H(:,2));
    end
end
plot([0,0],[0,(1.5*length(angles)+0.25)]-1);
%plot((bt)*[sa;ca],(bt)*[-ca;sa]+3);
%plot((rho*1-bt)*[sa;ca],(rho-bt)*[-ca;sa]+3);
%plot((rho*1+bt)*[sa;ca],(rho+bt)*[-ca;sa]+3);
%plot((rho*3-bt)*[sa;ca],(rho-bt)*[-ca;sa]+3);
axis('equal');
axis('off');
hold off;
saveas(fig, 'nice_hook.svg');
