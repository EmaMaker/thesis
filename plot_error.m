function plot_error(t,ref,x)
    hold on

    ex = ref(:, 1) - x(:, 1);
    ey = ref(:, 2) - x(:, 2);

    error_norm = sqrt(ex.*ex + ey.*ey);
    plot(t, error_norm, 'Linewidth', 8, 'DisplayName', 'norm of error [m]');

    avg = ones(1, length(error_norm)) * error_norm / length(error_norm);
    plot(t, avg*ones(1, length(error_norm)), 'DisplayName', 'average error [m]', 'LineWidth', 4);

    Axes = gca;
    Axes.FontSize=22;
    Axes.FontWeight='bold';
    Axes.PlotBoxAspectRatio = [1 1 1];
    grid minor;
    
    legend('FontSize', 18, 'Location', 'northeast', 'AutoUpdate','off')
    xlabel("\textbf{t [s]}", Interpreter="latex")
    ylabel("\textbf{tracking error}", Interpreter="latex")

    hold off
end