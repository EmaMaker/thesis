function [u, ut, q_pred] = control_act(t, q, sim_data)   
    pred_hor = sim_data.PREDICTION_HORIZON;
    
    % track only
    if eq(pred_hor, 0)

        dc = decouple_matrix(q, sim_data);
        ut = utrack(t, q, sim_data);
        u = dc*ut;
        
        % saturation
        u = min(sim_data.SATURATION, max(-sim_data.SATURATION, u));
        prob = [];
        q_pred = [];
        return
    end
    
    % mpc
    SATURATION = sim_data.SATURATION;
    PREDICTION_SATURATION_TOLERANCE = sim_data.PREDICTION_SATURATION_TOLERANCE;
    tc = sim_data.tc;
    s_ = SATURATION - ones(2,1)*PREDICTION_SATURATION_TOLERANCE;

    % prediction
    %T_invs = zeros(2,2, pred_hor);
    %Qs = zeros(3,1,pred_hor);
    %drefs = zeros(2,1, pred_hor);
    %refs = zeros(2,1, pred_hor);

    % optim problem
    prob = optimproblem('ObjectiveSense', 'minimize');
    % objective
    obj = 0;
    % decision vars
    ss_ = repmat(s_, [1,1, pred_hor]);
    ucorr = optimvar('ucorr', 2, pred_hor,'LowerBound', -ss_, 'UpperBound', ss_);
    % state vars
    Q = optimvar('state', 3, pred_hor);
    % initial conditions
    prob.Constraints.evo = Q(:, 1) == q';

    
    % linearization around robot trajectory
    % only needs to be calculated once
    theta = q(3);
    st = sin(theta);
    ct = cos(theta);       
    T_inv = decouple_matrix(q, sim_data);
    

    for k=1:pred_hor
        t_ = t + tc * (k-1);
        
        % reference trajectory and derivative
        ref_s = double(subs(sim_data.ref, t_));
        dref_s = double(subs(sim_data.dref, t_));

        %{
        % linearization around trajectory trajectory, hybrid approach
        % theta from reference position and velocity
        if eq(k, 1)
            % only for the first step, theta from the current state
            theta = q(3);
        else
            % then linearize around reference trajectory
            % proper way
            theta = mod( atan2(dref_s(2), dref_s(1)) + 2*pi, 2*pi);
            % or, derivative using difference. Seem to give the same
            % results
            %ref_s1 = double(subs(sim_data.ref, t_ + tc));
            %theta = atan2(ref_s1(2)-ref_s(2), ref_s1(1)-ref_s(1));
        end
        st = sin(theta);
        ct = cos(theta);       
        T_inv = decouple_matrix([ref_s(1); ref_s(2); theta], sim_data);
        %}

        %{
        % linearization around trajectory trajectory, "correct" approach
        theta = mod( atan2(dref_s(2), dref_s(1)) + 2*pi, 2*pi);
        st = sin(theta);
        ct = cos(theta);       
        T_inv = decouple_matrix([ref_s(1); ref_s(2); theta], sim_data);
        %}
                    
        
        % not at the end of the horizon
        if k < pred_hor - 1
            if eq(sim_data.robot, 0)
                % inputs for unicycle
                v = ucorr(1,k);
                w = ucorr(2,k);
            else
                % inputs for differential drive
                v = sim_data.r * (ucorr(1,k) + ucorr(2,k)) / 2;
                w = sim_data.r * (ucorr(1,k) - ucorr(2,k)) / sim_data.d;
            end

            % evolution constraints
            c = Q(:, k+1) == Q(:, k) + [v*tc*ct; v*tc*st; w*tc];
            prob.Constraints.evo = [prob.Constraints.evo; c];
        end

        % objective
        % sum of squared norms of u-q^d

        % feedback + tracking input
        % cannot use the utrack function, or the current formulation makes
        % the problem become non linear
        err = ref_s - [Q(1, k) + sim_data.b*ct; Q(2, k) + sim_data.b*st ];
        ut_ = dref_s + sim_data.K*err;
        %ut = utrack(t_, Q(k, :), sim_data);
        qd = T_inv*ut_;
        ud = ucorr(:, k)-qd;
        obj = obj + (ud')*ud;
    end
    % end linearization around trajectory


    prob.Objective = obj;
    %show(prob)
    %disp("to struct")
    %prob2struct(prob);
    
    opts=optimoptions(@quadprog,'Display','off');
    sol = solve(prob, 'Options',opts);
    u = sol.ucorr(:, 1);
    q_pred = sol.state';

    % ideal tracking for the predicted state
    ut = decouple_matrix(q_pred, sim_data)*utrack(t, q_pred, sim_data);
end

function u_track = utrack(t, q, sim_data)    
    ref_s = double(subs(sim_data.ref, t));
    dref_s = double(subs(sim_data.dref, t));
    
    f = feedback(q, sim_data.b);
    err = ref_s - f;
    u_track = dref_s + sim_data.K*err;
end

function q_track = feedback(q, b)
    q_track = [q(1) + b*cos(q(3)); q(2) + b*sin(q(3))  ];
end

function T_inv = decouple_matrix(q, sim_data)
    theta = q(3);

    st = sin(theta);
    ct = cos(theta);
    
    b = sim_data.b;

    if eq(sim_data.robot, 0)
        T_inv = [ct, st; -st/b, ct/b];
    elseif eq(sim_data.robot, 1)
        r = sim_data.r;
        d = sim_data.d;
        
        T_inv = [2*b*ct - d*st, d*ct + 2*b*st ; 2*b*ct + d*st, -d*ct+2*b*st] / (2*b*r);
    end
end


