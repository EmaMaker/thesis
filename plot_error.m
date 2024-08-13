function plot_error(t,ref,x)

    ex = ref(:, 1) - x(:, 1);
    ey = ref(:, 2) - x(:, 2);

    error_norm = sqrt(ex.*ex + ey.*ey);


    plot(t, error_norm, 'Linewidth', 5);

    Axes = gca;
    Axes.FontSize=18;
    Axes.FontWeight='bold';
    Axes.PlotBoxAspectRatio = [1 1 1];
    grid minor;
    
    xlabel("\textbf{t [s]}", FontSize=18, Interpreter="latex")
    ylabel("\textbf{norm of error [m]}", FontSize=18, Interpreter="latex")


end