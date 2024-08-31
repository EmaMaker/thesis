function plot_error(t,ref,x)
    hold on

    ex = ref(:, 1) - x(:, 1);
    ey = ref(:, 2) - x(:, 2);

    error_norm = sqrt(ex.*ex + ey.*ey);
    plot(t, error_norm, 'Linewidth', 5, 'DisplayName', 'norm of error');

    avg = ones(1, length(error_norm)) * error_norm / length(error_norm);
    plot(t, avg*ones(1, length(error_norm)), 'DisplayName', 'average error', 'LineWidth', 3);

    Axes = gca;
    Axes.FontSize=18;
    Axes.FontWeight='bold';
    Axes.PlotBoxAspectRatio = [1 1 1];
    grid minor;
    
    legend('FontSize', 12, 'Location', 'northeast', 'AutoUpdate','off')
    xlabel("\textbf{t [s]}", FontSize=18, Interpreter="latex")
    ylabel("\textbf{norm of error [m]}", FontSize=18, Interpreter="latex")

    hold off
end