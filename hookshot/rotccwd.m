function R = rotccwd(angle)
    R = [+cosd(angle) -sind(angle); 
         +sind(angle) +cosd(angle)];
end
