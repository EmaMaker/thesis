function dx = unicycle(t, x, u)
    % u is (v;w)
    % x is (x; y; theta)
    theta = x(3);
    G_x = [cos(theta), 0; sin(theta), 0; 0, 1];
    dx = G_x*u;
end
