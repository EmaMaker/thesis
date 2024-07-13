clc
clear all
close all

global x0 ref dref b K saturation

TRAJECTORY = 4
INITIAL_CONDITIONS = 0
% distance from the center of the unicycle to the point being tracked
% ATTENZIONE! CI SARA' SEMPRE UN ERRORE COSTANTE DOVUTO A b. Minore b,
% minore l'errore
b = 0.2
% proportional gain
K = eye(2)*2.5
% saturation
saturation = [5; 0.5];


% initial state
% In order, [x, y, theta]
x0 = set_initial_conditions(INITIAL_CONDITIONS)
% trajectory to track
[ref, dref] = set_trajectory(TRAJECTORY)


% simulation time
tspan = 0:0.1:60;
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
ref_t = double(subs(ref, t'))';

subplot(3,2,1)
hold on
xlabel('t')
ylabel('x')
plot(t, ref_t(:, 1));
plot(t, x(:, 1));
legend()
hold off

subplot(3,2,2)
plot(t, ref_t(:, 1) - x(:, 1));
xlabel('t')
ylabel('x error')

subplot(3,2,3)
hold on
xlabel('t')
ylabel('y')
plot(t, ref_t(:, 2));
plot(t, x(:, 2));
legend()
hold off

subplot(3,2,4)
plot(t, ref_t(:, 2) - x(:, 2));
xlabel('t')
ylabel('y error')


subplot(3,2,5)
plot(t, U(:, 1))
xlabel('t')
ylabel('input v')

subplot(3,2,6)
plot(t, U(:, 2))
xlabel('t')
ylabel('input w')
