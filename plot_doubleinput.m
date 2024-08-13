function plot_doubleinput(t, sat, U_track, U_corr)

tiledlayout(1,1,'Padding','tight', 'TileSpacing','compact')
nexttile

subplot(2,1,1);
hold on
plot(t, U_track(:, 1), 'Linewidth', 5, 'DisplayName', '\omega_r^{track}');
plot(t, U_corr(:, 1), 'Linewidth', 5, 'DisplayName', '\omega_r^{corr}');
legend('FontSize', 12, 'Location', 'east', 'AutoUpdate','off')
plot(t, ones(1,length(t))*sat(1), 'Linewidth', 2.5, 'LineStyle', '--');
plot(t, -ones(1,length(t))*sat(1), 'Linewidth', 2.5, 'LineStyle', '--');
xlabel('\textbf{t[s]}', 'FontSize', 18, 'Interpreter','latex');
hold off


Axes = gca;
Axes.FontSize=18;
Axes.FontWeight='bold';
grid minor;
Axes.PlotBoxAspectRatio = [1 1 1];

subplot(2,1,2);
hold on
plot(t, U_track(:, 2), 'Linewidth', 5, 'DisplayName', '\omega_r^{track}');
plot(t, U_corr(:, 2), 'Linewidth', 5, 'DisplayName', '\omega_r^{corr}');
legend('FontSize', 12, 'Location', 'east', 'AutoUpdate','off')
plot(t, ones(1,length(t))*sat(2), 'Linewidth', 2.5, 'LineStyle', '--');
plot(t, -ones(1,length(t))*sat(2), 'Linewidth', 2.5, 'LineStyle', '--');
xlabel('\textbf{t[s]}', 'FontSize', 18, 'Interpreter','latex');

Axes = gca;
Axes.FontSize=18;
Axes.FontWeight='bold';
grid minor;
Axes.PlotBoxAspectRatio = [1 1 1];

hold off
end