function dq = unicycle(t, q, u)
    % u is (v;w)
    % x is (x; y; theta)
    theta = q(3);
    G_q = [cos(theta), 0; sin(theta), 0; 0, 1];
    dq = G_q*u;
end
