clc
clear all
close all

global x0 ref dref b K saturation tc tfin

TRAJECTORY = 0
INITIAL_CONDITIONS = 1
% distance from the center of the unicycle to the point being tracked
% ATTENZIONE! CI SARA' SEMPRE UN ERRORE COSTANTE DOVUTO A b. Minore b,
% minore l'errore
b = 0.2
% proportional gain
K = eye(2)*2


% saturation
% HYP: a diff. drive robot with motors spinning at 100rpm -> 15.7 rad/s.
% Radius of wheels 10cm. Wheels distanced 15cm from each other
% applying transformation, v
% saturation = [1.57, 20];
saturation = [1.57; 20];


% initial state
% In order, [x, y, theta]
x0 = set_initial_conditions(INITIAL_CONDITIONS)
% trajectory to track
[ref, dref] = set_trajectory(TRAJECTORY)

[t, x, ref_t, U] = simulate_discr(60, 0.1);
plot_results(t, x, ref_t, U);

function [t, x, ref_t, U] = simulate_discr(tfin, tc)
    global ref x0 u_discr

    steps = tfin/tc
    
    x = x0';
    t = 0;
    u_discr = control_act(t, x0);
    U = u_discr';

    
    for n = 1:steps
        tspan = [(n-1)*tc n*tc];
        z0 = x(end, :);
        
        [v, z] = ode45(@sistema, tspan, z0);

        x = [x; z];
        t = [t; v];
        
        u_discr = control_act(t(end, :), x(end, :));
        U = [U; ones(length(v), 1)*u_discr'];
    end

    ref_t = double(subs(ref, t'))';
end


function [t, x, ref, U] = simulate_cont(tfin)
    global ref x0

    % simulation time
    tspan = linspace(0, tfin);
    % execute simulation
    [t, x] = ode45(@sistema, tspan, x0);
    
    % recalc and save input at each timestep
    ts = size(t);
    rows = ts(1);
    U = zeros(rows, 2);
    for row = 1:rows
        U(row, :) = control_act(t(row), x(row, :));
    end
    
    % plot results
    ref = double(subs(ref, t'))';
end

function plot_results(t, x, ref, U)
    subplot(2,2,1)
    hold on
    plot(ref(:, 1), ref(:, 2), "DisplayName", "Ref")
    plot(x(:, 1), x(:, 2), "DisplayName", "state")
    xlabel('x')
    ylabel('y')
    legend()
    subplot(2,2,3)
    plot(t, U(:, 1))
    xlabel('t')
    ylabel('input v')
    subplot(2,2,4)
    plot(t, U(:, 2))
    xlabel('t')
    ylabel('input w')
    
    
    subplot(4,4,3)
    hold on
    xlabel('t')
    ylabel('x')
    plot(t, ref(:, 1), "DisplayName", "X_{ref}");
    plot(t, x(:, 1), "DisplayName", "X");
    legend()
    hold off
    
    subplot(4,4,4)
    plot(t, ref(:, 1) - x(:, 1));
    xlabel('t')
    ylabel('x error')
    
    subplot(4,4,7)
    hold on
    xlabel('t')
    ylabel('y')
    plot(t, ref(:, 2), "DisplayName", "Y_{ref}");
    plot(t, x(:, 2), "DisplayName", "Y");
    legend()
    hold off
    
    subplot(4,4,8)
    plot(t, ref(:, 2) - x(:, 2));
    xlabel('t')
    ylabel('y error')
end
