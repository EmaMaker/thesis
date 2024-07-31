function u_ = diffdrive_to_uni(u, sim_data)
    u_ = [sim_data.r/2, sim_data.r/2 ; sim_data.r/sim_data.d, -sim_data.r/sim_data.d] * u;
end
