clc
clear all
close all

disp('Creating figure')
figure
disp('Photos will start in 3s')
pause(3)

PLOT_TESTS = [
    %"results-diffdrive/straightline/chill/01-Aug-2024 15:34:03";
    %"results-diffdrive/straightline/chill_errortheta_pisixths/01-Aug-2024 15:56:36";
    %"results-diffdrive/square/01-Aug-2024 16:18:51";
    %"results-diffdrive/circle/start_center/01-Aug-2024 16:46:41";
    %"results-diffdrive/circle/start_tangent/01-Aug-2024 16:55:09";
    %"results-diffdrive/circle/toofast/01-Aug-2024 17:35:25"
    %"results-diffdrive/straightline/toofast/01-Aug-2024 15:37:48"
    %"results-diffdrive/figure8/chill/15-Aug-2024 09:16:21";
    %"results-diffdrive/figure8/toofast/15-Aug-2024 09:10:32"cd
    "results-diffdrive/straightline/abrupt_stop_chill/27-Aug-2024 10:27:31";
    "results-diffdrive/straightline/abrupt_stop_toofast/27-Aug-2024 10:44:35"
    "results-diffdrive/sin/no_start_error/27-Aug-2024 19:28:17";
    "results-diffdrive/sin/no_start_error/27-Aug-2024 19:29:42";
    "results-diffdrive/sin/no_start_error/27-Aug-2024 19:31:17";
    "results-diffdrive/sin/no_start_error/27-Aug-2024 19:38:03"
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
        export_fig(gcf, '-transparent', [dir, num2str(n), '_trajectory.eps'])
        %exportgraphics(gcf, [dir, num2str(n), '_trajectory.png'], Resolution=300);
        %print([dir, num2str(n), '_trajectory.png'], '-dpng')
        clf; plot_error(t{n}, ref_t{n}, q{n})
        export_fig(gcf, '-transparent', [dir, num2str(n), '_error.eps'])
        %print([dir, num2str(n), '_error.png'], '-dpng')
        %clf; plot_input(t{n}, sim_data{n}.SATURATION, U_track{n}, 'track')
        %export_fig(gcf, '-transparent', [dir, num2str(n), '_track_input.eps'])
        %print([dir, num2str(n), '_track_input.png'], '-dpng')
        %clf; plot_input(t{n}, sim_data{n}.SATURATION, U_corr{n}, 'corr')
        %export_fig(gcf, '-transparent', [dir, num2str(n), '_corr_input.eps'])
        %print([dir, num2str(n), '_corr_input.png'], '-dpng')
        clf; plot_doubleinput(t{n}, sim_data{n}.SATURATION,  U_track{n}, U_corr{n})
        export_fig(gcf, '-transparent', [dir, num2str(n), '_double_input.eps'])
        clf; plot_tripleinput(t{n}, sim_data{n}.SATURATION, U{n}, U_track{n}, U_corr{n})
        export_fig(gcf, '-transparent', [dir, num2str(n), '_triple_input.eps'])
        %clf; plot_input(t{n},sim_data{n}.SATURATION,  U{n}, '')
        %export_fig(gcf, '-transparent', [dir, num2str(n), '_total_input.eps'])
        %print([dir, num2str(n), '_total_input.png'], '-dpng')
    end
    clf; plot_input_diff(t{3}, U_corr{3}, U_corr{2},0)
    export_fig(gcf, '-transparent', [dir, num2str(n), 'corr_input_diff_1x2.eps'])
    %print([dir, 'corr_input_diff_1x2.png'], '-dpng')
    clf; plot_input_diff(t{3}, U_corr{3}, U_corr{2},1)
    export_fig(gcf, '-transparent', [dir, num2str(n), 'corr_input_diff_2x1.eps'])
    %print([dir, 'corr_input_diff_2x1.png'], '-dpng')
end