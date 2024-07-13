function x0 = set_initial_conditions(i)
switch i
    case 0
        x0 = [0; 0; 0];
    case 1
        x0 = [0; 0; pi];
    case 2
        x0 = [0, 0; pi/6];
end
end