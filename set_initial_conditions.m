function q0 = set_initial_conditions(i)
switch i
    case 0
        q0 = [0; 0; 0];
    case 1
        q0 = [0; 0; pi];
    case 2
        q0 = [0; 0; pi/6];
    case 3
        q0 = [1; 0; 0];
    case 4
        q0 = [1; 0; -pi/6];
    case 5
        q0 = [1; 0; pi/2];
    case 6
        q0 = [0; 0.5; 0];
    case 7
        q0 = [0.75; 0; pi/2];
    case 8
        q0 = [0;0;pi/2];
    case 9
        q0 = [2.5; 0; pi/2];
    case 10
        q0 = [0;0;deg2rad(3)];
end
end