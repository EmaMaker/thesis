function dq = sistema_discr(t, q, u_discr, sim_data)
    theta = q(3);
    %dq = T(q)*W*u

    % T_q (unicycle)
    T_q = [cos(theta), 0; sin(theta), 0; 0, 1];
    % W*u
    Wu = diffdrive_to_uni(u_discr, sim_data);
    dq = T_q*Wu;
end
