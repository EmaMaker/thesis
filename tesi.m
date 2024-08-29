clc
clear all
close all

%TESTS = ["sin_faster", "sin", "circle", "straightline", "reverse_straightline"]
TESTS = ["figure8/fancyreps"]

s_ = size(TESTS);

for i = 1:s_(1)    
    clear data sim_data
    close all 
    
    sim_data = load(["tests/robot_common.mat"]);

    TEST = convertStringsToChars(TESTS(i))
    
    
    test_data = load(['tests/' TEST '/common.mat']);
    for fn = fieldnames(test_data)'
        sim_data.(fn{1}) = test_data.(fn{1});
    end

    sim_data.q0 = set_initial_conditions(sim_data.INITIAL_CONDITIONS);
    [ref dref] = set_trajectory(sim_data.TRAJECTORY, sim_data);
    sim_data.ref = ref;
    sim_data.dref = dref;

    spmd (3)
        worker_index = spmdIndex;
        data = load(['tests/' num2str(worker_index) '.mat']);
    
        for fn = fieldnames(data)'
            sim_data.(fn{1}) = data.(fn{1});
        end
        
        sim_data.U_corr_history = zeros(2,1,sim_data.PREDICTION_HORIZON);
        sim_data

        [t, q, ref_t, U, U_track, U_corr, U_corr_pred_history, Q_pred] = simulate_discr(sim_data);
    
        disp('Done')
    end
    
    h = [];
    s1_ = size(worker_index);
    for n = 1:s1_(2)
        h = [h, figure('Name', [TEST ' ' num2str(n)] )];
        plot_results(t{n}, q{n}, ref_t{n}, U{n}, U_track{n}, U_corr{n});
    end

    f1 = [ TEST '/'  datestr(datetime)];
    f = ['results-diffdrive/' f1];
    mkdir(f)
    savefig(h, [f '/figure.fig']);

    h = [h, figure('Name', 'difference between 1step and multistep')]
    subplot(2,1,1)
    plot(t{2}, U_corr{2}(:, 1) - U_corr{3}(:, 1))
    xlabel('t')
    ylabel('difference on w_r between 1-step and multistep')
    subplot(2,1,2)
    plot(t{2}, U_corr{2}(:, 2) - U_corr{3}(:, 2))
    xlabel('t')
    ylabel('difference on w_l between 1-step and multistep')

    clear h
    dsave([f '/workspace_composite.mat']);

    copyfile(['tests/' TEST], f);

    %video(q{1}', ref_t{1}', 0.1, t{1}, 2, sim_data{1}.tc*0.05, "aa");
    %video(q{2}', ref_t{2}', 0.1, t{2}, 2, sim_data{1}.tc*0.05, "aa");
    %video(q{3}', ref_t{3}', 0.1, t{3}, 2, sim_data{1}.tc*0.05, "aa");
end


%% FUNCTION DECLARATIONS

% Discrete-time simulation
function [t, q, ref_t, U, U_track, U_corr, U_corr_pred_history, Q_pred] = simulate_discr(sim_data)
    tc = sim_data.tc;
    steps = sim_data.tfin/tc
    
    q = sim_data.q0';
    t = 0;
    Q_pred = zeros(sim_data.PREDICTION_HORIZON,3,sim_data.tfin/sim_data.tc + 1);
    U_corr_pred_history=zeros(sim_data.PREDICTION_HORIZON,2,steps);

    [u_discr, u_track, u_corr, U_corr_history, q_pred] = control_act(t, q, sim_data);
    sim_data.U_corr_history = U_corr_history;
    U = u_discr';
    U_corr = u_corr';
    U_track = u_track';
    Q_pred(:, :, 1) = q_pred;
    
    for n = 1:steps
        sim_data.old_u_corr = u_corr;
        sim_data.old_u_track = u_track;
        sim_data.old_u = u_discr;

        tspan = [(n-1)*tc n*tc];
        z0 = q(end, :);
        
        %[v, z] = ode45(@sistema_discr, tspan, z0, u_discr);
        [v, z] = ode45(@(v, z) sistema_discr(v, z, u_discr, sim_data), tspan, z0);

        q = [q; z];
        t = [t; v];
        
        [u_discr, u_track, u_corr, U_corr_history, q_pred] = control_act(t(end), q(end, :), sim_data);
        sim_data.U_corr_history = U_corr_history;
        U = [U; ones(length(v), 1)*u_discr'];
        U_corr = [U_corr; ones(length(v), 1)*u_corr'];
        U_track = [U_track; ones(length(v), 1)*u_track'];
        Q_pred(:, :, 1+n) = q_pred;
	
	U_corr_pred_history(:,:,n) = permute(U_corr_history, [3, 1, 2]);
    end

    ref_t = double(subs(sim_data.ref, t'))';
end

%% 
