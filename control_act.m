function u = control_act(t, x)

    global ref dref K b saturation

    ref_s = double(subs(ref, t));
    dref_s = double(subs(dref, t));

    
    err = ref_s - feedback(x);
    u_nom = dref_s + K*err;
    
    theta = x(3);

    T_inv = [cos(theta), sin(theta); -sin(theta)/b, cos(theta)/b];

    u = T_inv * ( u_nom );

    % saturation
    u = min(saturation, max(-saturation, u));
end

function x_track = feedback(x)
    global b
    x_track = [ x(1) + b*cos(x(3)); x(2) + b*sin(x(3))  ];
end


