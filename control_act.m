function u = control_act(t, q)
    global SATURATION
    
    dc = decouple_matrix(q);
    ut = utrack(t,q);
    uc = ucorr(t,q);
    u = dc * (ut + uc);
    % saturation
    u = min(SATURATION, max(-SATURATION, u));
end

function u_corr = ucorr(t,q)
    global SATURATION PREDICTION_SATURATION_TOLERANCE PREDICTION_HORIZON tc
    
    if eq(PREDICTION_HORIZON, 0)
        u_corr = zeros(2,1);
        return
    end

    persistent U_corr_history;
    if isempty(U_corr_history)
        U_corr_history = zeros(2, 1, PREDICTION_HORIZON);
    end
    
    %disp('start of simulation')
    q_prec = q;
    %q_pred = [];
    %u_track_pred = [];
    %t_inv_pred = [];
    q_pred=zeros(3,1, PREDICTION_HORIZON);
    u_track_pred=zeros(2,1, PREDICTION_HORIZON+1);
    T_inv_pred=zeros(2,2, PREDICTION_HORIZON+1);
    % for each step in the prediction horizon, integrate the system to
    % predict its future state

    % the first step takes in q_k-1 and calculates q_new = q_k
    % this means that u_track_pred will contain u_track_k-1 and will not
    % contain u_track_k+C
    for k = 1:PREDICTION_HORIZON
        % start from the old (known) state

        % calculate the inputs, based on the old state

        % u_corr is the prediction done at some time in the past, as found in U_corr_history
        u_corr_ = U_corr_history(:, :, k);
        % u_track can be calculated from q
        t_ = t + tc*(k-1);
        u_track_ = utrack(t_, q_prec);
        
        T_inv = decouple_matrix(q_prec);
        u_ = T_inv * (u_corr_ + u_track_);
        
        % calc the state integrating with euler
        x_new = q_prec(1) + tc*u_(1) * cos(q_prec(3));
        y_new = q_prec(2) + tc*u_(1) * sin(q_prec(3));
        theta_new = q_prec(3) + tc*u_(2);

        q_new = [x_new; y_new; theta_new];

        % save history
        q_pred(:,:,k) = q_new;
        u_track_pred(:,:,k) = u_track_;
        T_inv_pred(:,:,k) = T_inv;

        % Prepare old state for next iteration
        q_prec = q_new;
    end

    %disp('end of simulation')
    %q_prec
    
    % calculate u_track_k+C
    u_track_pred(:,:,PREDICTION_HORIZON+1) = utrack(t+tc*PREDICTION_HORIZON, q_prec);
    % remove u_track_k-1
    u_track_pred = u_track_pred(:,:,2:end);

    T_inv_pred(:,:,PREDICTION_HORIZON+1) = decouple_matrix(q_prec);
    T_inv_pred = T_inv_pred(:,:,2:end);

    %disp('end of patching data up')

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
    % accounting for T_inv and -T_inv) by PREDICTION_HORIZON*2 (number of
    % vectors in u_corr times the number of elements [2] in each vector)
    A_max_elems = PREDICTION_HORIZON * 2 * 2;
    A_deq = [];
    b_deq = [];

    for k=1:PREDICTION_HORIZON
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
        b_deq = [b_deq; SATURATION - ones(2,1)*PREDICTION_SATURATION_TOLERANCE - d;
            SATURATION - ones(2,1)*PREDICTION_SATURATION_TOLERANCE + d];
    end
    
    %A_deq
    %b_deq
    % unknowns
    
    % squared norm of u_corr. H must be identity,
    % PREDICTION_HORIZON*size(u_corr)
    H = eye(PREDICTION_HORIZON*2)*2;
    % no linear terms
    f = zeros(PREDICTION_HORIZON*2, 1);

    % solve qp problem
    options = optimoptions('quadprog', 'Display', 'off');
    U_corr = quadprog(H, f, A_deq, b_deq, [],[],[],[],[],options);

    % reshape the vector of vectors to be an array, each element being
    % u_corr_j as a 2x1 vector
    U_corr_history = reshape(U_corr, [2,1,PREDICTION_HORIZON]);    

    u_corr=U_corr_history(:,:, 1);
    
end

function u_track = utrack(t, q)    
    global ref dref K
    ref_s = double(subs(ref, t));
    dref_s = double(subs(dref, t));
    
    f = feedback(q);
    err = ref_s - f;
    u_track = dref_s + K*err;
end

function q_track = feedback(q)
    global b
    q_track = [q(1) + b*cos(q(3)); q(2) + b*sin(q(3))  ];
end

function T_inv = decouple_matrix(q)
    global b

    theta = q(3);
    st = sin(theta);
    ct = cos(theta);
    T_inv = [ct, st; -st/b, ct/b];
end


