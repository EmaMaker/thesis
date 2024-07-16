function u = control_act(t, x)
    global ref dref K b SATURATION PREDICTION_SATURATION_TOLERANCE USE_PREDICTION PREDICTION_STEPS

    ref_s = double(subs(ref, t));
    dref_s = double(subs(dref, t));

    
    err = ref_s - feedback(x);
    u_track = dref_s + K*err;
    
    theta = x(3);

    T_inv = [cos(theta), sin(theta); -sin(theta)/b, cos(theta)/b];
    
    u = zeros(2,1);
    if USE_PREDICTION==true 
        % 1-step prediction

        % quadprog solves the problem in the form
        % min 1/2 x'Hx +f'x
        % where x is u_corr. Since u_corr is (v_corr; w_corr), and I want
        % to minimize u'u (norm squared of the function itself) H must be
        % the identity matrix of size 2
        H = eye(2)*2;
        % no linear of constant terms, so 
        f = [];

        % and there are box constraints on the saturation, as upper/lower
        % bounds
        %T = inv(T_inv);
        %lb = -T*saturation - u_track;
        %ub = T*saturation - u_track;
        % matlab says this is a more efficient way of doing
        % inv(T_inv)*saturation
        %lb = -T_inv\saturation - u_track;
        %ub = T_inv\saturation - u_track;

        % Resolve box constraints as two inequalities
        A_deq = [T_inv; -T_inv];
        d = T_inv*u_track;
        b_deq = [SATURATION - ones(2,1)*PREDICTION_SATURATION_TOLERANCE - d;
            SATURATION - ones(2,1)*PREDICTION_SATURATION_TOLERANCE + d];
        
        % solve the problem
        % no <= constraints
        % no equality constraints
        % only upper/lower bound constraints        
        options = optimoptions('quadprog', 'Display', 'off');
        u_corr = quadprog(H, f, A_deq, b_deq, [],[],[],[],[],options);

        u = T_inv * (u_track + u_corr);

        global tu uu
        tu = [tu, t];
        uu = [uu, u_corr];
    else
        u = T_inv * u_track;
    end

    % saturation
    u = min(SATURATION, max(-SATURATION, u));
end

function x_track = feedback(x)
    global b
    x_track = [ x(1) + b*cos(x(3)); x(2) + b*sin(x(3))  ];
end


