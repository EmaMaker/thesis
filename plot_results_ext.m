
% Plots
function plot_results(t, x, ref, U, U_track, U_corr)
    subplot(4,2,1)
    plot_results(ref, x)
    subplot(4,2,3)
    plot(t, U(:, 1))
    xlabel('t [s]')
    ylabel('input w_r [rad/s]')
    subplot(4,2,4)
    plot(t, U(:, 2))
    xlabel('t')
    ylabel('input w_l [rad/s]')
    hold off

    
    
    subplot(4,2,7)
    plot(t, U_track(:, 1))
    xlabel('t [s]')
    ylabel('tracking input w_r [rad/s]')
    subplot(4,2,8)
    plot(t, U_track(:, 2))
    xlabel('t [s]')

    ylabel('tracking input w_l [rad/s]')
    
    ex = ref(:, 1) - x(:, 1);
    ey = ref(:, 2) - x(:, 2);
    
    subplot(8,8,5)
    hold on
    xlabel('t [s]')
    ylabel('x [n]')
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
    plot_error(t, ref, x)
   
end
