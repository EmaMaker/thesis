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
end
end