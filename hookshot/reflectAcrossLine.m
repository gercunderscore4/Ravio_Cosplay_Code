function Pn = reflectAcrossLine(P, m, b)
    if (m == inf) || (m == -inf)
        Pn = P * [-1 0; 0 1];
    else
        Pn = P;
        % https://math.stackexchange.com/questions/525082/reflection-across-a-line
        T = (1 / (1 + m*m)) * [(1-m*m), 2*m; 2*m, (m*m-1)];
        % remove vertical offset
        Pn(:,2) = Pn(:,2) + b;
        % reflect
        Pn = Pn * T;
        % re-add vertical offset
        Pn(:,2) = Pn(:,2) - b;
    end
end
