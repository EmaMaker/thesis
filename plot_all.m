clc
clear all
close all

disp('Creating figure')
figure('units','normalized','outerposition',[0 0 1 1])
disp('Photos will start in 3s')
pause(3)

PLOT_TESTS = [
<<<<<<< HEAD
    "results-diffdrive/straightline/chill/01-Aug-2024 15-34-03";
    "results-diffdrive/straightline/chill_errortheta_pisixths/01-Aug-2024 15-56-36";
    "results-diffdrive/square/01-Aug-2024 16-18-51";
    "results-diffdrive/circle/start_center/01-Aug-2024 16-46-41";
    "results-diffdrive/circle/start_tangent/01-Aug-2024 16-55-09";
    "results-diffdrive/circle/toofast/01-Aug-2024 17-35-25";
    "results-diffdrive/straightline/toofast/01-Aug-2024 15-37-48";
    "results-diffdrive/figure8/chill/15-Aug-2024 09-16-21";
    "results-diffdrive/figure8/toofast/15-Aug-2024 09-10-32";
    "results-diffdrive/straightline/abrupt_stop_chill/27-Aug-2024 10-15-43";
    "results-diffdrive/straightline/abrupt_stop_toofast/27-Aug-2024 10-44-35";
    "results-diffdrive/sin/no_start_error/27-Aug-2024 19-28-17";
    "results-diffdrive/sin/no_start_error/27-Aug-2024 19-29-42";
    "results-diffdrive/sin/no_start_error/27-Aug-2024 19-31-17";
    "results-diffdrive/sin/no_start_error/27-Aug-2024 19-38-03";
=======
        "results-uni/straightline/chill/30-08-2024 19-37-07";
        "results-uni/straightline/chill_errortheta_pisixths/30-08-2024 19-38-37";
        "results-uni/square/30-08-2024 19-44-27";
        "results-uni/sin/no_start_error/30-08-2024 19-45-33";
        "results-uni/circle/start_center/30-08-2024 19-50-23";
        "results-uni/circle/start_tangent/30-08-2024 19-51-58";
        "results-uni/circle/toofast/30-08-2024 19-48-47";
        "results-uni/circle/start_center_plus_tolerance/01-09-2024 19-20-41";
>>>>>>> c772cb1 (plots: increase font size for better reading in ppt)
    ]

s_ = size(PLOT_TESTS)
for i = 1:s_(1)
    clearvars -except PLOT_TESTS s_ i
    
    sPLOT_TEST = convertStringsToChars(PLOT_TESTS(i));
    PLOT_TEST = [sPLOT_TEST, '/workspace_composite.mat']
    load(PLOT_TEST)

    dir = ['images-diffdrive/', sPLOT_TEST, '/']
    mkdir(dir);
    
    
    for n=1:3
        %{
        clf; plot_trajectory(t{n}, ref_t{n}, q{n})
        export_fig(gcf, '-transparent', [dir, num2str(n), '_trajectory.png'])
        clf; plot_error(t{n}, ref_t{n}, q{n})
        export_fig(gcf, '-transparent', [dir, num2str(n), '_error.png'])
        clf; plot_doubleinput(t{n}, sim_data{n}.SATURATION,  U_track{n}, U_corr{n}, 0)
        export_fig(gcf, '-transparent', [dir, num2str(n), '_double_input_1x2.png'])
        clf; plot_doubleinput(t{n}, sim_data{n}.SATURATION,  U_track{n}, U_corr{n}, 1)
        export_fig(gcf, '-transparent', [dir, num2str(n), '_double_input_2x1.png'])
        clf; plot_tripleinput(t{n}, sim_data{n}.SATURATION, U{n}, U_track{n}, U_corr{n}, 0)
        export_fig(gcf, '-transparent', [dir, num2str(n), '_triple_input_1x2.png'])
        clf; plot_tripleinput(t{n}, sim_data{n}.SATURATION, U{n}, U_track{n}, U_corr{n}, 1)
        export_fig(gcf, '-transparent', [dir, num2str(n), '_triple_input_2x1.png'])
        
        %clf; plot_input(t{n}, sim_data{n}.SATURATION, U_track{n}, 'track')
        %export_fig(gcf, '-transparent', [dir, num2str(n), '_track_input.png'])
        %clf; plot_input(t{n}, sim_data{n}.SATURATION, U_corr{n}, 'corr')
        %export_fig(gcf, '-transparent', [dir, num2str(n), '_corr_input.png'])
        %}
        clf; plot_input(t{n},sim_data{n}.SATURATION,  U{n}, '', 0)
        export_fig(gcf, '-transparent', [dir, num2str(n), '_total_input_1x2.png'])
        clf; plot_input(t{n},sim_data{n}.SATURATION,  U{n}, '', 1)
        export_fig(gcf, '-transparent', [dir, num2str(n), '_total_input_2x1.png'])
    end
    
    
    %{
    % correction difference (multistep, 1-step)
<<<<<<< HEAD
    clf; plot_input_diff(t{3}, t{2}, U_corr{3}, U_corr{2}, 0, '\textbf{$$\omega_r^{corr, multistep}$$}', '\textbf{$$\omega_r^{corr, 1step}$$}', '\textbf{$$\omega_l^{corr, multistep}$$}', '\textbf{$$\omega_l^{corr, 1step}$$}')
    export_fig(gcf, '-transparent', [dir, 'corr_input_diff_1x2.eps'])
    clf; plot_input_diff(t{3}, t{2}, U_corr{3}, U_corr{2}, 1, '\textbf{$$\omega_r^{corr, multistep}$$}', '\textbf{$$\omega_r^{corr, 1step}$$}', '\textbf{$$\omega_l^{corr, multistep}$$}', '\textbf{$$\omega_l^{corr, 1step}$$}')
    export_fig(gcf, '-transparent', [dir, 'corr_input_diff_2x1.eps'])

    % input difference (saturated track only, 1step)
    clf; plot_input_diff(t{1}, t{2}, U{1}, U{2}, 0, '\textbf{$$\omega_r^{trackonly-sat}$$}', '\textbf{$$\omega_r^{1step}$$}', '\textbf{$$\omega_l^{trackonly-sat}$$}', '\textbf{$$\omega_l^{1step}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_track_1step_1x2.eps'])
    clf; plot_input_diff(t{1}, t{2}, U{1}, U{2}, 1, '\textbf{$$\omega_r^{trackonly-sat}$$}', '\textbf{$$\omega_r^{1step}$$}', '\textbf{$$\omega_l^{trackonly-sat}$$}', '\textbf{$$\omega_l^{1step}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_track_1step_2x1.eps'])

    % input difference (saturated track only, multistep)
    clf; plot_input_diff(t{2}, t{3}, U{2}, U{3}, 0, '\textbf{$$\omega_r^{1step}$$}', '\textbf{$$\omega_r^{multistep}$$}', '\textbf{$$\omega_l^{1step}$$}', '\textbf{$$\omega_l^{multistep}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_1step_multistep_1x2.eps'])
    clf; plot_input_diff(t{2}, t{3}, U{2}, U{3}, 1, '\textbf{$$\omega_r^{1step}$$}', '\textbf{$$\omega_r^{multistep}$$}', '\textbf{$$\omega_l^{1step}$$}', '\textbf{$$\omega_l^{multistep}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_1step_multistep_2x1.eps'])

=======
    clf; plot_input_diff(t{3}, t{2}, U_corr{3}, U_corr{2}, 0, '\textbf{$$v^{corr, multistep}$$}', '\textbf{$$v^{corr, 1step}$$}', '\textbf{$$\omega^{corr, multistep}$$}', '\textbf{$$\omega^{corr, 1step}$$}')
    export_fig(gcf, '-transparent', [dir, 'corr_input_diff_1x2.png'])
    clf; plot_input_diff(t{3}, t{2}, U_corr{3}, U_corr{2}, 1, '\textbf{$$v^{corr, multistep}$$}', '\textbf{$$v^{corr, 1step}$$}', '\textbf{$$\omega^{corr, multistep}$$}', '\textbf{$$\omega^{corr, 1step}$$}')
    export_fig(gcf, '-transparent', [dir, 'corr_input_diff_2x1.png'])

    % input difference (saturated track only, 1step)
    clf; plot_input_diff(t{1}, t{2}, U{1}, U{2}, 0, '\textbf{$$v^{trackonly-sat}$$}', '\textbf{$$v^{1step}$$}', '\textbf{$$\omega^{trackonly-sat}$$}', '\textbf{$$\omega^{1step}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_track_1step_1x2.png'])
    clf; plot_input_diff(t{1}, t{2}, U{1}, U{2}, 1, '\textbf{$$v^{trackonly-sat}$$}', '\textbf{$$v^{1step}$$}', '\textbf{$$\omega^{trackonly-sat}$$}', '\textbf{$$\omega^{1step}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_track_1step_2x1.png'])
    
    % input difference (saturated track only, 1step)
    clf; plot_input_diff(t{1}, t{3}, U{1}, U{3}, 0, '\textbf{$$v^{trackonly-sat}$$}', '\textbf{$$v^{multistep}$$}', '\textbf{$$\omega^{trackonly-sat}$$}', '\textbf{$$\omega^{multistep}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_track_multistep_1x2.png'])
    clf; plot_input_diff(t{1}, t{3}, U{1}, U{3}, 1, '\textbf{$$v^{trackonly-sat}$$}', '\textbf{$$v^{multistep}$$}', '\textbf{$$\omega^{trackonly-sat}$$}', '\textbf{$$\omega^{multistep}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_track_multistep_2x1.png'])
    

    % input difference (1-step, multistep)
    clf; plot_input_diff(t{2}, t{3}, U{2}, U{3}, 0, '\textbf{$$v^{1step}$$}', '\textbf{$$v^{multistep}$$}', '\textbf{$$\omega^{1step}$$}', '\textbf{$$\omega^{multistep}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_1step_multistep_1x2.png'])
    clf; plot_input_diff(t{2}, t{3}, U{2}, U{3}, 1, '\textbf{$$v^{1step}$$}', '\textbf{$$v^{multistep}$$}', '\textbf{$$\omega^{1step}$$}', '\textbf{$$\omega^{multistep}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_1step_multistep_2x1.png'])
    %}
>>>>>>> c772cb1 (plots: increase font size for better reading in ppt)
end