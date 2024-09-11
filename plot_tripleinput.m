function plot_tripleinput(t, sat, U, U_track, U_corr, type, in1, in2, m1, m2)

%tiledlayout(1,1,'Padding','tight', 'TileSpacing','compact')
%nexttile

ylim1_ = sat(1)*2.5;
ylim2_ = sat(2)*2.5;
lw = 6;

if type == 0
subplot(1,2,1);
else
subplot(2,1,1);
end

hold on
plot(t, U_track(:, 1), 'Linewidth', lw-1, 'DisplayName', [in1 '^{track}'], 'Color', 'cyan');
plot(t, U_corr(:, 1), 'Linewidth', lw-1, 'DisplayName', [in1 '^{corr}'], 'Color', 'green');
plot(t, U(:, 1), 'Linewidth', lw, 'DisplayName', in1, 'Color', 'red');

legend('FontSize', 18, 'Location', 'northeast', 'AutoUpdate','off')
xlabel('\textbf{t[s]}', 'Interpreter','latex');
ylabel(['\textbf{[', m1 ']}'], 'Interpreter','latex');

plot(t, ones(1,length(t))*sat(1), 'Linewidth', 2.5, 'LineStyle', '--', 'Color', 'black');
plot(t, -ones(1,length(t))*sat(1), 'Linewidth', 2.5, 'LineStyle', '--', 'Color', 'black');

hold off


Axes = gca;
Axes.FontSize=22;
Axes.FontWeight='bold';
grid minor;
Axes.PlotBoxAspectRatio = [1 1 1];
ylim([-ylim1_, ylim1_])


if type == 0
subplot(1,2,2);
else
subplot(2,1,2);
end

hold on
plot(t, U_track(:, 2), 'Linewidth', lw-1, 'DisplayName', [in2 '^{track}'], 'Color', 'cyan');
plot(t, U_corr(:, 2), 'Linewidth', lw-1, 'DisplayName', [in2 '^{corr}'], 'Color', 'green');
plot(t, U(:, 2), 'Linewidth', lw, 'DisplayName', in2, 'Color', 'red');

legend('FontSize', 18, 'Location', 'northeast', 'AutoUpdate','off')
xlabel('\textbf{t[s]}', 'Interpreter','latex');
ylabel(['\textbf{[', m2 ']}'], 'Interpreter','latex');

plot(t, ones(1,length(t))*sat(1), 'Linewidth', 2.5, 'LineStyle', '--', 'Color', 'black');
plot(t, -ones(1,length(t))*sat(1), 'Linewidth', 2.5, 'LineStyle', '--', 'Color', 'black');


Axes = gca;
Axes.FontSize=22;
Axes.FontWeight='bold';
grid minor;
Axes.PlotBoxAspectRatio = [1 1 1];
ylim([-ylim2_, ylim2_])

hold off
end