function dq = sistema_discr(t, q, u_discr, sim_data)
    theta = q(3);
    G_q = [cos(theta), 0; sin(theta), 0; 0, 1];
    dq = G_q*diffdrive_to_uni(u_discr, sim_data);
end
