function [NP] = add_thickness(P, t)
    if 2 ~= size(P,2)
        disp('WARNING: Points are incorrectly sized, should be 2xN.')
    end
    n = size(P,1);
    NP = [];
    if 0 >= n
        % done
    elseif 1 == n
        nt = linspace(0,2*pi,36);
        NP = [t * cos(nt') + P(1,1); t * sin(nt') + P(1,1)];
    else
        if 1
            % using midpoints
            nt = linspace(pi*3/2,pi*1/2,18);
            m = n-1;
            
            theta = atan2d(P(2,2) - P(1,2), P(2,1) - P(1,1));
            R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
            NP = (R*[t*cos(nt); t*sin(nt)])' + P(1,:);
            
            M = (P(1:(n-1),:) + P(2:n,:)) / 2;
            U = P(2:n,:) - P(1:(n-1),:);
            U = bsxfun(@rdivide,U,sqrt(sum(U.^2,2)));
            U = [-U(:,2), U(:,1)];
            NP = [NP; M+t*U];

            % end end
            theta = atan2d(P(m,2) - P(n,2), P(m,1) - P(n,1));
            R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
            NP = [NP; ((R*[t*cos(nt); t*sin(nt)])' + P(n,:))];
    
            % reverse the trangetial section
            NP = [NP; flipud(M-t*U); NP(1,:)];
            
            % remove NaNs
            NP(~any(~isnan(NP),2),:)=[];
        else
            % using points
            nt = linspace(pi*3/2,pi*1/2,18);
            m = n-1;
            
            theta = atan2d(P(2,2) - P(1,2), P(2,1) - P(1,1));
            R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
            NP = (R*[t*cos(nt); t*sin(nt)])' + P(1,:);

            U = P(2:n,:) - P(1:(n-1),:);
            U = bsxfun(@rdivide,U,sqrt(sum(U.^2,2)));
            U = [-U(:,2), U(:,1)];
            U = [0 0; U(1:m,:)] + [U(1:m,:); 0 0];
            U = bsxfun(@rdivide,U,sqrt(sum(U.^2,2)));
            NP = [NP; P+t*U];
            
            % end end
            theta = atan2d(P(m,2) - P(n,2), P(m,1) - P(n,1));
            R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
            NP = [NP; ((R*[t*cos(nt); t*sin(nt)])' + P(n,:))];
    
            % reverse the trangetial section
            NP = [NP; flipud(P-t*U); NP(1,:)];
            
            % remove NaNs
            NP(~any(~isnan(NP),2),:)=[];
        end
    end
end
