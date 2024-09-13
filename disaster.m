clc
clear all
close allQQQ

%load('results-diffdrive/circle/start_center/10-09-2024 13-27-12/workspace_composite.mat')
load('results-diffdrive/circle/start_center/10-09-2024 15-33-08/workspace_composite.mat')
%load('/home/emamaker/documents/Università/tesi/tesi-sim/results-diffdrive/square/10-09-2024 13-53-35/workspace_composite.mat')



y = cell(1,3);
for n = 1:3
    y{n} = [q{n}(:,1) + sim_data{n}.b*cos(q{n}(:,3)), q{n}(:,2) + sim_data{n}.b*sin(q{n}(:,3))];
end


figure(1)
hold on
plot(ref_t{n}(:, 1), ref_t{n}(:, 2), "DisplayName", "Ref", "LineStyle", "--", 'LineWidth', 2)
for n=1:3
    plot(y{n}(:, 1), y{n}(:, 2), "DisplayName", ['state' num2str(n)], 'LineWidth', 2)
end
legend()
hold off

%U_corr{1} = U{1} - U_track{1}
plot_input(2, t, U, 'sat')
plot_input(3, t, U_track, 'track')
plot_input(4, t, U_corr, 'corr')

plot_traj(t, y, ref_t)

function plot_input(nfig, t, input, name)
    figure(nfig)
    subplot(2,1,1)
    hold on
    plot(t{1}, input{1}(:,1), "DisplayName", ['w_r ' num2str(1) name], 'LineWidth', 2, 'LineStyle', '-.')
    plot(t{2}, input{2}(:,1), "DisplayName", ['w_r ' num2str(2) name], 'LineWidth', 4, 'LineStyle', ':')
    plot(t{3}, input{3}(:,1), "DisplayName", ['w_r ' num2str(3) name], 'LineWidth', 2, 'LineStyle', '--')

    subplot(2,1,2)
    hold on
    plot(t{1}, input{1}(:,2), "DisplayName", ['w_l ' num2str(1) name], 'LineWidth', 2, 'LineStyle', '-.')
    plot(t{2}, input{2}(:,2), "DisplayName", ['w_l ' num2str(2) name], 'LineWidth', 4, 'LineStyle', ':')
    plot(t{3}, input{3}(:,2), "DisplayName", ['w_l ' num2str(3) name], 'LineWidth', 2, 'LineStyle', '--')    %{
    
    %{
    for n=1:3
        subplot(2,1,1)
        hold on
        plot(t{n}, input{n}(:,1), "DisplayName", ['w_r ' num2str(n) name], 'LineWidth', 2, 'LineStyle', '-.')
        subplot(2,1,2)
        hold on
        plot(t{n}, input{n}(:,2), "DisplayName", ['w_l ' num2str(n) name], 'LineWidth', 2, 'LineStyle', '-.')
    
    end
    %}
    subplot(2,1,1)
    legend()
    subplot(2,1,2)
    legend
    hold off
end

function plot_traj(t, q, ref_t)
    figure(10)
    for n=1:3
        ref = ref_t{n};
        x = q{n};
        ex = ref(:, 1) - x(:, 1);
        ey = ref(:, 2) - x(:, 2);

        subplot(2,2,1)
        hold on
        plot(t{n}, x(:,1), 'DisplayName', ['x ' num2str(n)], 'LineWidth', 2)
        legend()
        subplot(2,2,2)
        hold on
        plot(t{n}, x(:,2), 'DisplayName', ['y ' num2str(n)], 'LineWidth', 2)
        legend()
        subplot(2,2,3)
        hold on
        plot(t{n}, ex, 'DisplayName', ['errx ' num2str(n)], 'LineWidth', 2)
        legend()
        subplot(2,2,4)
        hold on
        plot(t{n}, ey, 'DisplayName', ['erry ' num2str(n)], 'LineWidth', 2)
        legend()
    end
end