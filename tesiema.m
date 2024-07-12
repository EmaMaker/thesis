clc
clear all
close all

global x0 ref dref b K saturation

TRAJECTORY = 0
INITIAL_CONDITIONS = 0
% distance from the center of the unicycle to the point being tracked
% ATTENZIONE! CI SARA' SEMPRE UN ERRORE COSTANTE DOVUTO A b. Minore b,
% minore l'errore
b = 0.2
% proportional gain
K = eye(2)*2
% saturation
saturation = [5; 0.2];


% initial state
% In order, [x, y, theta]
x0 = set_initial_conditions(INITIAL_CONDITIONS)
% trajectory to track
[ref, dref] = set_trajectory(TRAJECTORY)


% simulation time
tspan = 0:0.1:10;
% execute simulation

[t, x] = ode45(@sistema, tspan, x0)

% plot results
ref_t = reshape(double(subs(ref, t)), [101,2]);

subplot(3,2,1)
hold on
plot(t, ref_t(:, 1));
plot(t, x(:, 1));
legend()
subplot(3,2,2)
plot(t, ref_t(:, 1) - x(:, 1));
subplot(3,2,3)
hold on
plot(t, ref_t(:, 2));
plot(t, x(:, 2));
legend()
subplot(3,2,4)
plot(t, ref_t(:, 2) - x(:, 2));

