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
        % straight line, with initial error
        xref = 5 + 0.5*s;
        yref = 0;
    case 3
        % straight line, initial error, faster
        xref = 5 + 10*s;
        yref = 0;
    case 4
        xref = cos(s);
        yref = sin(s);
    case 5
        xref = 15*cos(s);
        yref = 15*sin(s);
    case 6
        xref = 0.4*s; 
        yref = cos(0.4*s);
        %xref = 0.6*s; 
        %yref = cos(0.6*s);
    case 7
        xref = 5*cos(0.05*s);
        yref = 5*sin(0.05*s);
    case 8
        xref = 0.5*s;
        yref = 1;
    case 9
        xref = 0.9*s;
        yref = 0.5*cos(0.65*s);
    case 10
        xref = cos(0.5*s);
        yref = 0.5 * sin(s);
end

ref = [xref; yref];
dref = diff(ref, s);
end