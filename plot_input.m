function plot_input(t, sat, U, type)

tiledlayout(1,1,'Padding','tight', 'TileSpacing','compact')
nexttile

subplot(2,1,1);
hold on
plot(t, U(:, 1), 'Linewidth', 5);
plot(t, ones(1,length(t))*sat(1), 'Linewidth', 2.5, 'LineStyle', '--');
plot(t, -ones(1,length(t))*sat(1), 'Linewidth', 2.5, 'LineStyle', '--');
xlabel('\textbf{t[s]}', 'FontSize', 18, 'Interpreter','latex');
ylabel(['\textbf{$$w_r^{' type '}$$[rad/s]}'], 'FontSize', 18, 'Interpreter','latex');
hold off


Axes = gca;
Axes.FontSize=18;
Axes.FontWeight='bold';
grid minor;
Axes.PlotBoxAspectRatio = [1 1 1];

subplot(2,1,2);
hold on
plot(t, U(:, 2), 'Linewidth', 5);
plot(t, ones(1,length(t))*sat(2), 'Linewidth', 2.5, 'LineStyle', '--');
plot(t, -ones(1,length(t))*sat(2), 'Linewidth', 2.5, 'LineStyle', '--');
xlabel('\textbf{t[s]}', 'FontSize', 18, 'Interpreter','latex');
ylabel(['\textbf{$$w_l^{' type '}$$[rad/s]}'], 'FontSize', 18, 'Interpreter','latex');
hold off

Axes = gca;
Axes.FontSize=18;
Axes.FontWeight='bold';
grid minor;
Axes.PlotBoxAspectRatio = [1 1 1];
end