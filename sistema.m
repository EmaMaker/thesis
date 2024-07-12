function [x, u_] = sistema(t, x)
    global ref dref K b saturation U tc

    ref_s = double(subs(ref, t));
    dref_s = double(subs(dref, t));

    
    err = ref_s - feedback(x);
    u_nom = dref_s + K*err;
    
    theta = x(3);

    T_inv = [cos(theta), sin(theta); -sin(theta)/b, cos(theta)/b];

    u = T_inv * u_nom;

    % saturation
    u = min(saturation, max(-saturation, u));
    
    i = int8(1.5 + t/tc);
    % save input
    U(i, :) = reshape(u, [1, 2]);

    x = unicycle(t, x, u);
end

function dx = unicycle(t, x, u)
    % u is (v;w)
    % x is (x; y; theta)
    theta = x(3);
    G_x = [cos(theta), 0; sin(theta), 0; 0, 1];
    dx = G_x*u;
end

function x_track = feedback(x)
    global b
    x_track = [ x(1) + b*cos(x(3)); x(2) + b*sin(x(3))  ];
end


