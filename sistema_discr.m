function dq = sistema_discr(t, q, u_discr, sim_data)
    dq = diffdrive(t, q, u_discr, sim_data);
end
