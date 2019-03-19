function [X, Y] = build_jigsaw(pattern, end_value)
    % build jigsaw

    if (~exist('end_value','var'))
        ev1 = 0;
        ev2 = 0;
    else
        ev1 = end_value(1);
        ev2 = end_value(end);
    end

    % ensure that it's low at both ends
    EXTENDED_JIGSAW = [ev1, pattern, ev2];

    % indices for getting that square shape (need two points between each section to for vertical line)
    %    2---
    %    |
    %    |
    % ---1
    XI = repelem(1:length(EXTENDED_JIGSAW),2);
    XI = XI(2:end-1);
    YI = repelem(0:length(pattern),2);

    X = EXTENDED_JIGSAW(XI);
    Y = YI;

    % remove repeats
    rem = find(~diff(EXTENDED_JIGSAW(XI)));
    rem = [0, diff(rem) == 1] .* rem;
    rem = nonzeros(rem);
    X(rem) = [];
    Y(rem) = [];
    
    %Points = [X; Y];
end
