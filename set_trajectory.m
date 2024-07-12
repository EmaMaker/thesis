function [ref, dref] = set_trajectory(i)
syms s

switch i
    case 0   
        % a straigth line trajectory at v=0.5m/s
        xref = 0.5*s;
        yref = 0;
    case 1
        % a straigth line trajectory at v=10 m/s
        xref = 10*s;
        yref = 0;
    case 2
        xref = 5*cos(s);
        yref = 5*sin(s);
end

ref = [xref; yref];
dref = diff(ref, s);
end