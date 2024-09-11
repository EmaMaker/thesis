<\clc
clear all
close all

disp('Creating figure')
figure('units','normalized','outerposition',[0 0 1 1])
disp('Photos will start in 3s')
pause(3)

PLOT_TESTS = [
    "results-diffdrive/straightline/chill/10-09-2024-22-30-28";
    "results-diffdrive/straightline/chill_errortheta_pisixths/10-09-2024-22-31-10";
    "results-diffdrive/straightline/chill_errory/10-09-2024-22-32-34";
    "results-diffdrive/circle/start_center/10-09-2024-22-33-21";
    "results-diffdrive/square/10-09-2024-22-40-01";
    "results-diffdrive/figure8/chill/10-09-2024-22-34-26";
    "results-diffdrive/figure8/fancyreps/10-09-2024-21-45-28";
    "results-diffdrive/figure8/toofast/10-09-2024-22-35-17";
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

        clf; plot_input(t{n},sim_data{n}.SATURATION,  U{n}, '', 0)
        export_fig(gcf, '-transparent', [dir, num2str(n), '_total_input_1x2.png'])
        clf; plot_input(t{n},sim_data{n}.SATURATION,  U{n}, '', 1)
        export_fig(gcf, '-transparent', [dir, num2str(n), '_total_input_2x1.png'])
    end
    
    % correction difference (multistep, 1-step)
    clf; plot_input_diff(t{3}, t{2}, U_corr{3}, U_corr{2}, 0, '\textbf{$$\omega_r^{corr, multistep}$$}', '\textbf{$$\omega_r^{corr, 1step}$$}', '\textbf{$$\omega_l^{corr, multistep}$$}', '\textbf{$$\omega_l^{corr, 1step}$$}')
    export_fig(gcf, '-transparent', [dir, 'corr_input_diff_1x2.eps'])
    clf; plot_input_diff(t{3}, t{2}, U_corr{3}, U_corr{2}, 1, '\textbf{$$\omega_r^{corr, multistep}$$}', '\textbf{$$\omega_r^{corr, 1step}$$}', '\textbf{$$\omega_l^{corr, multistep}$$}', '\textbf{$$\omega_l^{corr, 1step}$$}')
    export_fig(gcf, '-transparent', [dir, 'corr_input_diff_2x1.eps'])

    % input difference (saturated track only, 1step)
    clf; plot_input_diff(t{1}, t{2}, U{1}, U{2}, 0, '\textbf{$$\omega_r^{trackonly_sat}$$}', '\textbf{$$\omega_r^{1step}$$}', '\textbf{$$\omega_l^{trackonly-sat}$$}', '\textbf{$$\omega_l^{1step}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_track_1step_1x2.eps'])
    clf; plot_input_diff(t{1}, t{2}, U{1}, U{2}, 1, '\textbf{$$\omega_r^{trackonly_sat}$$}', '\textbf{$$\omega_r^{1step}$$}', '\textbf{$$\omega_l^{trackonly-sat}$$}', '\textbf{$$\omega_l^{1step}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_track_1step_2x1.eps'])

    % input difference (saturated track only, multistep)
    clf; plot_input_diff(t{1}, t{3}, U{1}, U{3}, 0, '\textbf{$$\omega_r^{trackonly_sat}$$}', '\textbf{$$\omega_r^{multistep}$$}', '\textbf{$$\omega_l^{1step}$$}', '\textbf{$$\omega_l^{multistep}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_1step_multistep_1x2.eps'])
    clf; plot_input_diff(t{1}, t{3}, U{1}, U{3}, 1, '\textbf{$$\omega_r^{trackonly_sat}$$}', '\textbf{$$\omega_r^{multistep}$$}', '\textbf{$$\omega_l^{1step}$$}', '\textbf{$$\omega_l^{multistep}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_1step_multistep_2x1.eps'])

    % input difference (1-step, multistep)
    clf; plot_input_diff(t{2}, t{3}, U{2}, U{3}, 0, '\textbf{$$\omega_r^{1step}$$}', '\textbf{$$\omega_r^{multistep}$$}', '\textbf{$$\omega_l^{1step}$$}', '\textbf{$$\omega_l^{multistep}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_1step_multistep_1x2.eps'])
    clf; plot_input_diff(t{2}, t{3}, U{2}, U{3}, 1, '\textbf{$$\omega_r^{1step}$$}', '\textbf{$$\omega_r^{multistep}$$}', '\textbf{$$\omega_l^{1step}$$}', '\textbf{$$\omega_l^{multistep}$$}')
    export_fig(gcf, '-transparent', [dir, 'input_diff_1step_multistep_2x1.eps'])
end