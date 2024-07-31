function [u, ut, uc, U_corr_history, q_pred] = control_act(t, q, sim_data)   
    dc = decouple_matrix(q, sim_data);
    ut = utrack(t, q, sim_data);
    [uc, U_corr_history, q_pred] = ucorr(t, q, sim_data);

    ut = dc*ut;
    uc = dc*uc;

    u = ut+uc;
    % saturation
    u = min(sim_data.SATURATION, max(-sim_data.SATURATION, u));
end

function [u_corr, U_corr_history, q_pred] = ucorr(t, q, sim_data)
    pred_hor = sim_data.PREDICTION_HORIZON;
    SATURATION = sim_data.SATURATION;
    PREDICTION_SATURATION_TOLERANCE = sim_data.PREDICTION_SATURATION_TOLERANCE;
    tc = sim_data.tc;

    u_corr = zeros(2,1);
    U_corr_history = zeros(2,1,sim_data.PREDICTION_HORIZON);
    q_act = q;
    u_track_pred=zeros(2,1, pred_hor);
    T_inv_pred=zeros(2,2, pred_hor);

    q_pred = [];

    if eq(pred_hor, 0)
        return
    end
    
    if pred_hor > 1
        % move the horizon over 1 step and add trailing zeroes
        U_corr_history = cat(3, sim_data.U_corr_history(:,:, 2:end), zeros(2,1));
    end

    %disp('start of simulation')
    % for each step in the prediction horizon, integrate the system to
    % predict its future state

    for k = 1:pred_hor
        % start from the old (known) state

        % compute the inputs, based on the old state

        % u_corr is the prediction done at some time in the past, as found in U_corr_history
        u_corr_ = U_corr_history(:, :, k);
        % u_track can be computed from q
        t_ = t + tc * (k-1);
        u_track_ = utrack(t_, q_act, sim_data);
        
        T_inv = decouple_matrix(q_act, sim_data);
        % compute inputs (wr, wl)
        u_ = T_inv * (u_corr_ + u_track_);
        % map (wr, wl) to (v, w) for unicicle
        u_ = diffdrive_to_uni(u_, sim_data);

        % integrate unicycle
        theta_new = q_act(3) + tc*u_(2);
        % compute the state integrating with euler
        %x_new = q_act(1) + tc*u_(1) * cos(q_act(3));
        %y_new = q_act(2) + tc*u_(1) * sin(q_act(3));
        % compute the state integrating via runge-kutta
        x_new = q_act(1) + tc*u_(1) * cos(q_act(3) + 0.5*tc*u_(2));
        y_new = q_act(2) + tc*u_(1) * sin(q_act(3) + 0.5*tc*u_(2));

        q_new = [x_new; y_new; theta_new];

        % save history
        q_pred = [q_pred; q_new'];
        u_track_pred(:,:,k) = u_track_;
        T_inv_pred(:,:,k) = T_inv;

        % Prepare old state for next iteration
        q_act = q_new;
    end

    %{
        Now setup the qp problem
        It needs:
        - Unknowns, u_corr at each timestep. Will be encoded as a vector of
        vectors, in which every two elements is a u_j
        i.e. (u_1; u_2; u_3; ...; u_C) = (v_1; w_1; v_2, w_2; v_3, w_3; ...
        ; v_C, w_C)
        It is essential that the vector stays a column, so that u'u is the
        sum of the squared norms of each u_j

        - Box constraints: a constraint for each timestep in the horizon.
        Calculated using the predicted state and inputs. They need to be
        put in matrix (Ax <= b) form
    %}

    % box constrains
    % A becomes sort of block-diagonal
    % A will be at most PREDICTION_HORIZON * 2 * 2 (2: size of T_inv; 2:
    % accounting for T_inv and -T_inv) by PREDICTION_HORIZON (number of
    % vectors in u_corr times the number of elements [2] in each vector)
    A_max_elems = pred_hor * 2 * 2;
    A_deq = [];
    b_deq = [];

    s_ = SATURATION - ones(2,1)*PREDICTION_SATURATION_TOLERANCE;
    for k=1:pred_hor
        T_inv = T_inv_pred(:,:,k);
        u_track = u_track_pred(:,:,k);

        % [T_inv; -T_inv] is a 4x2 matrix
        n_zeros_before = (k-1) * 4;
        n_zeros_after = A_max_elems - n_zeros_before - 4;
        zeros_before = zeros(n_zeros_before, 2);
        zeros_after = zeros(n_zeros_after, 2);
        column = [zeros_before; T_inv; -T_inv; zeros_after];
        A_deq = [A_deq, column];

        d = T_inv*u_track;
        b_deq = [b_deq; s_ - d; s_ + d];
    end
    
    %A_deq
    %b_deq
    % unknowns
   
    % squared norm of u_corr. H must be identity,
    % PREDICTION_HORIZON*size(u_corr)
    H = eye(pred_hor*2)*2;
    % no linear terms
    f = zeros(pred_hor*2, 1);

    % solve qp problem
    options = optimoptions('quadprog', 'Display', 'off');
    U_corr = quadprog(H, f, A_deq, b_deq, [],[],[],[],[],options);

    % reshape the vector of vectors to be an array, each element being
    % u_corr_j as a 2x1 vector
    % and add the prediction at t_k+C
    U_corr_history = reshape(U_corr, [2,1,pred_hor]);
    %sim_data.U_corr_history = U_corr_history;
    % first result is what to do now
    u_corr=U_corr_history(:,:, 1);
    
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
    r = sim_data.r;
    d = sim_data.d;
    %a1 = sim_data.r*0.5;
    %a2 = sim_data.b*sim_data.r/sim_data.d;
    %det_inv = -sim_data.d/(sim_data.b*sim_data.r*sim_data.r);0
    %T_inv = det_inv * [ a1*st - a2*ct, -a1*ct - a2*st;-a1*st-a2*ct , a1*ct - a2*st];

    T_inv = [2*b*ct - d*st, d*ct + 2*b*st ; 2*b*ct + d*st, -d*ct+2*b*st] / (2*b*r);
end


