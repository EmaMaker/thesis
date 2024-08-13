function plot_results(t, x, ref, U, U_track, U_corr)
    subplot(4,2,1)
    hold on
    title("trajectory / state")
    plot(ref(:, 1), ref(:, 2), "DisplayName", "Ref")
    plot(x(:, 1), x(:, 2), "DisplayName", "state")
    rectangle('Position', [x(1,1)-0.075, x(1,2)-0.075, 0.15, 0.15], 'Curvature', [1,1])
    xlabel('x')
    ylabel('y')
    legend()
    subplot(4,2,3)
    plot(t, U(:, 1))
    xlabel('t')
    ylabel('input wr')
    subplot(4,2,4)
    plot(t, U(:, 2))
    xlabel('t')
    ylabel('input wl')
    hold off

    subplot(4,2,5)
    plot(t, U_corr(:, 1))
    xlabel('t')
    ylabel('correction input wr')
    subplot(4,2,6)
    plot(t, U_corr(:, 2))
    xlabel('t')
    ylabel('correction input wl')
    
    
    subplot(4,2,7)
    plot(t, U_track(:, 1))
    xlabel('t')
    ylabel('tracking input wr')
    subplot(4,2,8)
    plot(t, U_track(:, 2))
    xlabel('t')

    ylabel('tracking input wl')
    
    ex = ref(:, 1) - x(:, 1);
    ey = ref(:, 2) - x(:, 2);
    
    subplot(8,8,5)
    hold on
    xlabel('t')
    ylabel('x')
    plot(t, ref(:, 1), "DisplayName", "X_{ref}");
    plot(t, x(:, 1), "DisplayName", "X");
    legend()
    hold off
    
    subplot(8,8,6)
    plot(t, ex);
    xlabel('t')
    ylabel('x error')
    
    subplot(8,8,13)
    hold on
    xlabel('t')
    ylabel('y')
    plot(t, ref(:, 2), "DisplayName", "Y_{ref}");
    plot(t, x(:, 2), "DisplayName", "Y");
    legend()
    hold off
    
    subplot(8,8,14)
    plot(t, ey);
    xlabel('t')
    ylabel('y error')

    subplot(4, 4, 4);
    error_norm = sqrt(ex.*ex + ey.*ey);
    plot(t, error_norm );
    xlabel("t")
    ylabel("error norm")
   
end
