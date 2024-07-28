clc
clear all
close all

%TESTS = ["sin_faster", "sin", "circle", "straightline", "reverse_straightline"]
TESTS = ["straightline"]

s_ = size(TESTS);

for i = 1:s_(2)    
    clear data sim_data
    close all
    
%for i = 1:1
    TEST = convertStringsToChars(TESTS(i))
    
    sim_data = load(['tests/' TEST '/common.mat']);
    
    sim_data.q0 = set_initial_conditions(sim_data.INITIAL_CONDITIONS);
    [ref dref] = set_trajectory(sim_data.TRAJECTORY);
    sim_data.ref = ref;
    sim_data.dref = dref;


    spmd (3)
        worker_index = spmdIndex;
        data = load(['tests/' TEST '/' num2str(spmdIndex) '.mat']);
    
        sim_data.PREDICTION_HORIZON = data.PREDICTION_HORIZON;
        sim_data.U_corr_history = zeros(2,1,sim_data.PREDICTION_HORIZON);
        sim_data
    
        [t, q, ref_t, U, U_track, U_corr] = simulate_discr(sim_data);
    
        disp('Done')
    end
    
    h = [];
    s1_ = size(worker_index);
    for n = 1:s1_(2)
        h_ = figure('Name', [TEST ' ' num2str(n)] );
        h = [h, h_];
        plot_results(t{n}, q{n}, ref_t{n}, U{n}, U_track{n}, U_corr{n});
    end

    f1 = [ TEST '-'  datestr(datetime)];
    f = ['results/' f1];
    mkdir(f)
    savefig(h, [f '/' f1 '.fig']);
    save([f '/workspace.mat']);

    copyfile(['tests/' TEST], f);
end

%% 

% data = load(['tests/' TEST '/' num2str(2) '.mat']);
% sim_data.PREDICTION_HORIZON = data.PREDICTION_HORIZON;
% sim_data.U_corr_history = zeros(2,1,sim_data.PREDICTION_HORIZON);
% sim_data
% [t, q, ref_t, U, U_track, U_corr] = simulate_discr(sim_data);
% 
% %% 
% plot_results(t,q,ref_t,U, U_track, U_corr);


%% FUNCTION DECLARATIONS

% Discrete-time simulation
function [t, q, ref_t, U, U_track, U_corr] = simulate_discr(sim_data)
    tc = sim_data.tc;
    steps = sim_data.tfin/tc
    
    q = sim_data.q0';
    t = 0;
    [u_discr, u_track, u_corr, U_corr_history] = control_act(t, q, sim_data);
    sim_data.U_corr_history = U_corr_history;
    U = u_discr';
    U_corr = u_corr';
    U_track = u_track';
    
    for n = 1:steps
        sim_data.old_u_corr = u_corr;
        sim_data.old_u_track = u_track;
        sim_data.old_u = u_discr;

        tspan = [(n-1)*tc n*tc];
        z0 = q(end, :);
        
        %[v, z] = ode45(@sistema_discr, tspan, z0, u_discr);
        [v, z] = ode45(@(v, z) sistema_discr(v, z, u_discr), tspan, z0);

        q = [q; z];
        t = [t; v];
        
        [u_discr, u_track, u_corr, U_corr_history] = control_act(t(end), q(end, :), sim_data);
        sim_data.U_corr_history = U_corr_history;
        U = [U; ones(length(v), 1)*u_discr'];
        U_corr = [U_corr; ones(length(v), 1)*u_corr'];
        U_track = [U_track; ones(length(v), 1)*u_track'];
    end

    ref_t = double(subs(sim_data.ref, t'))';
end


% Continuos-time simulation
function [t, q, ref, U] = simulate_cont(tfin)
    global ref q0

    % simulation time
    tspan = linspace(0, tfin);
    % execute simulation
    [t, q] = ode45(@sistema, tspan, q0);
    
    % recalc and save input at each timestep
    ts = size(t);
    rows = ts(1);
    U = zeros(rows, 2);
    for row = 1:rows
        U(row, :) = control_act(t(row), q(row, :));
    end
    
    % plot results
    ref = double(subs(ref, t'))';
end
%% 

% Plots
function plot_results(t, x, ref, U, U_track, U_corr)
    subplot(4,2,1)
    hold on
    title("trajectory / state")
    plot(ref(:, 1), ref(:, 2), "DisplayName", "Ref")
    plot(x(:, 1), x(:, 2), "DisplayName", "state")
    xlabel('x')
    ylabel('y')
    legend()
    subplot(4,2,3)
    plot(t, U(:, 1))
    xlabel('t')
    ylabel('input v')
    subplot(4,2,4)
    plot(t, U(:, 2))
    xlabel('t')
    ylabel('input w')

    subplot(4,2,5)
    plot(t, U_corr(:, 1))
    xlabel('t')
    ylabel('input correction v')
    subplot(4,2,6)
    plot(t, U_corr(:, 2))
    xlabel('t')
    ylabel('input correction w')
    
    
    subplot(4,2,7)
    plot(t, U_track(:, 1))
    xlabel('t')
    ylabel('tracking input v')
    subplot(4,2,8)
    plot(t, U_track(:, 2))
    xlabel('t')
    ylabel('tracking input w')
    
    
    subplot(8,4,3)
    hold on
    xlabel('t')
    ylabel('x')
    plot(t, ref(:, 1), "DisplayName", "X_{ref}");
    plot(t, x(:, 1), "DisplayName", "X");
    legend()
    hold off
    
    subplot(8,4,4)
    plot(t, ref(:, 1) - x(:, 1));
    xlabel('t')
    ylabel('x error')
    
    subplot(8,4,7)
    hold on
    xlabel('t')
    ylabel('y')
    plot(t, ref(:, 2), "DisplayName", "Y_{ref}");
    plot(t, x(:, 2), "DisplayName", "Y");
    legend()
    hold off
    
    subplot(8,4,8)
    plot(t, ref(:, 2) - x(:, 2));
    xlabel('t')
    ylabel('y error')
   
end
