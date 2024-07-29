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
    case 11
        % cardioid
        a = 0.5;
        xref = 2*a*(1-cos(0.5*s))*sin(0.5*s);
        %xref = 4*a*(0.2-cos(0.5*s))*sin(0.5*s);
        yref = 2*a*(1-cos(0.5*s))*cos(0.5*s);
    case 12
        % square! in parametic form! https://math.stackexchange.com/questions/978486/parametric-form-of-square
        %speed = 0.3;
        speed = 0.18;
        side = 2;
        s_ = speed * s;
        %xref = side * cos(s) / max(abs(cos(speed*s)), abs(sin(speed*s))) ;
        %yref = side * sin(s) / max(abs(cos(speed*s)), abs(sin(speed+s))) ;
        p = (sqrt(2) * (abs(sin(s_ + pi/4)) + abs(cos(s_ + pi/4))));
        xref = side * cos(s_) / p;
        yref = side * sin(s_) / p;
end

ref = [xref; yref];
dref = diff(ref, s);
end