function plot_input(t, sat, U, type, orient)


tiledlayout(1,1,'Padding','tight', 'TileSpacing','compact')
nexttile

if orient == 0
subplot(1,2,1);
else
subplot(2,1,1);
end

hold on
plot(t, U(:, 1), 'Linewidth', 8);
plot(t, ones(1,length(t))*sat(1), 'Linewidth', 2.5, 'LineStyle', '--');
plot(t, -ones(1,length(t))*sat(1), 'Linewidth', 2.5, 'LineStyle', '--');
xlabel('\textbf{t[s]}', 'Interpreter','latex');
ylabel(['\textbf{$$v^{' type '}$$[rad/s]}'], 'Interpreter','latex');
hold off


Axes = gca;
Axes.FontSize=26;
Axes.FontWeight='bold';
grid minor;
Axes.PlotBoxAspectRatio = [1 1 1];


if orient == 0
subplot(1,2,2);
else
subplot(2,1,2);
end

hold on
plot(t, U(:, 2), 'Linewidth', 8);
plot(t, ones(1,length(t))*sat(2), 'Linewidth', 2.5, 'LineStyle', '--');
plot(t, -ones(1,length(t))*sat(2), 'Linewidth', 2.5, 'LineStyle', '--');
xlabel('\textbf{t[s]}', 'Interpreter','latex');
ylabel(['\textbf{$$\omega^{' type '}$$[rad/s]}'], 'Interpreter','latex');
hold off

Axes = gca;
Axes.FontSize=26;
Axes.FontWeight='bold';
grid minor;
Axes.PlotBoxAspectRatio = [1 1 1];
end