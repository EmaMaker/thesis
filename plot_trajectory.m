function tl = plot_trajectory(t, ref, x)

    tl = tiledlayout(1,1,'Padding','tight', 'TileSpacing','compact');
    nexttile;

    hold on
    grid minor  
    label_interval = 1:1200:length(x);
    labels = strcat(num2str(round(t(label_interval),1)), "s");

    %title("Reference trajectory / Robot position", "FontSize", 18)
    
    plot(ref(:, 1), ref(:, 2), "DisplayName", "Reference trajectory", 'Color', 'blue', 'Linewidth', 12);
    %plot(x(:, 1), x(:, 2), "DisplayName", "Robot position", 'Color', 'green', 'Linewidth', 6);
    [x_arr, y_arr] = arrowed_line(x(:, 1), x(:, 2), 600, 50, 50);
    plot(x_arr, y_arr, "DisplayName", "Robot position", 'Color', 'green', 'Linewidth', 4);
    labelpoints(x(label_interval, 1), x(label_interval, 2), labels, 'N', 0.3, 'FontWeight', 'bold', 'FontSize', 15);

    Axes = gca;
    Axes.FontSize=18;
    Axes.FontWeight='bold';

    xlabel('\textbf{x [m]}', 'FontSize', 18, 'Interpreter', 'latex');
    ylabel('\textbf{y [m]}', 'FontSize', 18, 'Interpreter', 'latex');
    legend('FontSize', 12, 'Location', 'southeast', 'AutoUpdate','off')


    xlim = Axes.XLim;
    ylim = Axes.YLim;
    xl = xlim(2) - xlim(1);
    yl = ylim(2) - ylim(1);
    rx = 0.02 * abs(xl);
    ry = 0.02 * abs(yl);
    rectangle('Position', [x(1,1)-rx, x(1,2)-ry, 2*rx, 2*ry], 'Curvature', [1,1]);
    Axes.XLim = xlim;
    Axes.YLim = ylim;
    Axes.PlotBoxAspectRatio = [1 1 1];
    Axes.Units='normalized' 
    Axes.OuterPosition = [0 0 1.25 1.25];


    hold off
end