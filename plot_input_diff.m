function plot_input(t, U_corr1, U_corr2, type)

tiledlayout(1,1,'Padding','tight', 'TileSpacing','compact')
nexttile

if type == 0
subplot(1,2,1);
else
subplot(2,1,1);
end
plot(t, U_corr1(:, 1) - U_corr2(:,1), 'Linewidth', 5);
xlabel('\textbf{t[s]}', 'FontSize', 24, 'Interpreter','latex');
ylabel('\textbf{$$\omega_r^{corr, multistep}$$} - \textbf{$$\omega_r^{corr, 1step}$$ [rad/s]}', 'FontSize', 18, 'Interpreter','latex');

Axes = gca;
Axes.FontSize=18;
Axes.FontWeight='bold';
grid minor;
Axes.PlotBoxAspectRatio = [1 1 1];


if type == 0
subplot(1,2,2);
else
subplot(2,1,2);
end
plot(t, U_corr1(:, 2) - U_corr2(:,2), 'Linewidth', 5);
xlabel('\textbf{t[s]}', 'FontSize', 24, 'Interpreter','latex');
ylabel('\textbf{$$\omega_l^{corr, multistep}$$} - \textbf{$$\omega_l^{corr, 1step}$$ [rad/s]}', 'FontSize', 18, 'Interpreter','latex');

Axes = gca;
Axes.FontSize=18;
Axes.FontWeight='bold';
grid minor;
Axes.PlotBoxAspectRatio = [1 1 1];
end