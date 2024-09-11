function dq = unicycle(t, q, u_discr, sim_data)
    theta = q(3);
    %dq = T(q)*W*u

    % T_q (unicycle)
    T_q = [cos(theta), 0; sin(theta), 0; 0, 1];
    dq = T_q*u_discr;
end
