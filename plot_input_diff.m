function plot_input_diff(t1, t2, U_corr1, U_corr2, type, name1_1, name1_2, name2_1, name2_2, m1, m2)

l1 = length(U_corr1);
l2 = length(U_corr2)

t = t1;
if l1 > l2
    U_corr1 = U_corr1(1:l2, :);
    t = t2;
elseif l2 > l1
    U_corr2 = U_corr2(1:l1, :);
    t = t1;
end

tiledlayout(1,1,'Padding','tight', 'TileSpacing','compact')
nexttile

if type == 0
subplot(1,2,1);
else
subplot(2,1,1);
end
plot(t, U_corr1(:, 1) - U_corr2(:,1), 'Linewidth', 5);
xlabel('\textbf{t[s]}', 'Interpreter','latex');
ylabel([name1_1 '-' name1_2 ' [' m1 ']'], 'Interpreter','latex');

Axes = gca;
Axes.FontSize=26;
Axes.FontWeight='bold';
grid minor;
Axes.PlotBoxAspectRatio = [1 1 1];


if type == 0
subplot(1,2,2);
else
subplot(2,1,2);
end
plot(t, U_corr1(:, 2) - U_corr2(:,2), 'Linewidth', 5);
xlabel('\textbf{t[s]}', 'Interpreter','latex');
ylabel([name2_1 '-' name2_2 ' [' m2 ']'], 'Interpreter','latex');

Axes = gca;
Axes.FontSize=26;
Axes.FontWeight='bold';
grid minor;
Axes.PlotBoxAspectRatio = [1 1 1];
end