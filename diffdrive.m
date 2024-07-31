function dq = diffdrive(t, q, u, sim_data)
    dq = unicycle(t, q, diffdrive_to_uni(u, sim_data));
end
