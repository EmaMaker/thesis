function plot_doubleinput(t, sat, U_track, U_corr, type)

tiledlayout(1,1,'Padding','tight', 'TileSpacing','compact')
nexttile


if type == 0
subplot(1,2,1);
else
subplot(2,1,1);
end

hold on
plot(t, U_track(:, 1), 'Linewidth', 8, 'DisplayName', '\omega_r^{track}');
plot(t, U_corr(:, 1), 'Linewidth', 8, 'DisplayName', '\omega_r^{corr}');
legend('FontSize', 22, 'Location', 'east', 'AutoUpdate','off')
plot(t, ones(1,length(t))*sat(1), 'Linewidth', 2.5, 'LineStyle', '--');
plot(t, -ones(1,length(t))*sat(1), 'Linewidth', 2.5, 'LineStyle', '--');
xlabel('\textbf{t[s]}', 'FontSize', 22, 'Interpreter','latex');
hold off


Axes = gca;
Axes.FontSize=22;
Axes.FontWeight='bold';
grid minor;
Axes.PlotBoxAspectRatio = [1 1 1];


if type == 0
subplot(1,2,2);
else
subplot(2,1,2);
end

hold on
plot(t, U_track(:, 2), 'Linewidth', 8, 'DisplayName', '\omega_l^{track}');
plot(t, U_corr(:, 2), 'Linewidth', 8, 'DisplayName', '\omega_l^{corr}');
legend('FontSize', 22, 'Location', 'east', 'AutoUpdate','off')
plot(t, ones(1,length(t))*sat(2), 'Linewidth', 2.5, 'LineStyle', '--');
plot(t, -ones(1,length(t))*sat(2), 'Linewidth', 2.5, 'LineStyle', '--');
xlabel('\textbf{t[s]}', 'FontSize', 22, 'Interpreter','latex');

Axes = gca;
Axes.FontSize=22;
Axes.FontWeight='bold';
grid minor;
Axes.PlotBoxAspectRatio = [1 1 1];

hold off
end