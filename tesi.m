clc
clear all
close all

% options
ROBOT = 'unicycle'
TESTS = ["straightline/chill", "straightline/chill_errortheta_pisixths", "straightline/toofast", "straightline/chill_errory", "circle/start_center", "figure8/chill", "figure8/toofast", "square"]
%TESTS = ["circle/start_center"]

% main
s_ = size(TESTS);
for i = 1:length(TESTS)
    clearvars -except i s_ TESTS ROBOT
    close all 
    
    % load simulation parameters common to all robots and all tests
    sim_data = load(["tests/robot_common.mat"]);

    TEST = convertStringsToChars(TESTS(i))
    
    % load test data (trajectory, etc)
    test_data = load(['tests/' TEST '/common.mat']);
    for fn = fieldnames(test_data)'
        sim_data.(fn{1}) = test_data.(fn{1});
    end
    
    % set trajectory and starting conditions
    sim_data.q0 = set_initial_conditions(sim_data.INITIAL_CONDITIONS);
    [ref dref] = set_trajectory(sim_data.TRAJECTORY, sim_data);
    sim_data.ref = ref;
    sim_data.dref = dref;
    
    % spawn a new worker for each controller
    % 1: track only
    % 2: track + 1step
    % 3: track + multistep
    spmd (3)
        worker_index = spmdIndex;
        % load controller-specific options
        data = load(['tests/' num2str(worker_index) '.mat']);
        for fn = fieldnames(data)'
            sim_data.(fn{1}) = data.(fn{1});
        end

        % load robot-specific options
        % put here to overwrite any parameter value left over in the tests
        % .mat files, just in case
        data = load(['tests/' ROBOT '.mat']);
        for fn = fieldnames(data)'
            sim_data.(fn{1}) = data.(fn{1});
        end
        
        % initialize prediction horizon
        sim_data.U_corr_history = zeros(2,1,sim_data.PREDICTION_HORIZON);
        sim_data

        % simulate robot
        tic;
        [t, q, y, ref_t, U, U_track, U_corr, U_corr_pred_history, Q_pred] = simulate_discr(sim_data);
        toc;
    
        disp('Done')
    end
    
    % save simulation data
    f1 = [ TEST '/'  char(datetime, 'dd-MM-yyyy-HH-mm-ss')]; % windows compatible name
    f = ['results-' ROBOT '/' f1];
    mkdir(f)
    % save workspace
    dsave([f '/workspace_composite.mat']);
    % save test file
    copyfile(['tests/' TEST], f);
    
    % save figures + plot results
    h = [];
    % plot results
    s1_ = size(worker_index);
    for n = 1:s1_(2)
        h = [h, figure('Name', [TEST ' ' num2str(n)] )];
        plot_results(t{n}, q{n}, ref_t{n}, U{n}, U_track{n}, U_corr{n});
    end
    % plot correction different between 1-step and multistep
    h = [h, figure('Name', 'difference between 1step and multistep')];
    subplot(2,1,1)
    plot(t{2}, U_corr{2}(:, 1) - U_corr{3}(:, 1))
    xlabel('t')
    ylabel(['difference on ' sim_data{1}.input1_name ' between 1-step and multistep'])
    subplot(2,1,2)
    plot(t{2}, U_corr{2}(:, 2) - U_corr{3}(:, 2))
    xlabel('t')
    ylabel(['difference on ' sim_data{1}.input2_name ' between 1-step and multistep'])
    % save figures
    savefig(h, [f '/figure.fig']);

    %video(q{1}', ref_t{1}', 0.1, t{1}, 2, sim_data{1}.tc*0.05, "aa");
    %video(q{2}', ref_t{2}', 0.1, t{2}, 2, sim_data{1}.tc*0.05, "aa");
    %video(q{3}', ref_t{3}', 0.1, t{3}, 2, sim_data{1}.tc*0.05, "aa");
end


%% FUNCTION DECLARATIONS

% Discrete-time simulation
function [t, q, y, ref_t, U, U_track, U_corr, U_corr_pred_history, Q_pred] = simulate_discr(sim_data)
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
    y = [];

    if eq(sim_data.robot, 0)
        fun = @(t, q, u_discr, sim_data) unicycle(t, q, u_discr, sim_data);
    elseif eq(sim_data.robot, 1)
        fun = @(t, q, u_discr, sim_data) diffdrive(t, q, u_discr, sim_data);
    end
    
    for n = 1:steps
        sim_data.old_u_corr = u_corr;
        sim_data.old_u_track = u_track;
        sim_data.old_u = u_discr;

        tspan = [(n-1)*tc n*tc];
        z0 = q(end, :);
        
        opt = odeset('MaxStep', 0.005);
        [v, z] = ode45(@(v, z) fun(v, z, u_discr, sim_data), tspan, z0, opt);

        q = [q; z];
        t = [t; v];
                
        [u_discr, u_track, u_corr, U_corr_history, q_pred] = control_act(t(end), q(end, :), sim_data);
        sim_data.U_corr_history = U_corr_history;
        U = [U; ones(length(v), 1)*u_discr'];
        U_corr = [U_corr; ones(length(v), 1)*u_corr'];
        U_track = [U_track; ones(length(v), 1)*u_track'];
        Q_pred(:, :, 1+n) = q_pred;
	
	    U_corr_pred_history(:,:,n) = permute(U_corr_history, [3, 1, 2]);
        
        y1 = q(:, 1) + sim_data.b * cos(q(:,3));
        y2 = q(:, 2) + sim_data.b * sin(q(:,3));
        y = [y; y1, y2];
    end

    ref_t = double(subs(sim_data.ref, t'))';
end

%% 
