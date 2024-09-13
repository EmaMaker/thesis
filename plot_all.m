clc
clear all
close all

disp('Creating figure')
figure('units','normalized','outerposition',[0 0 1 1])
disp('Photos will start in 3s')
pause(3)

PLOT_TESTS = [
    "results-diffdrive/straightline/chill/11-09-2024-16-57-01";
    "results-diffdrive/straightline/chill_errortheta_pisixths/11-09-2024-16-57-43";
    "results-diffdrive/straightline/chill_errory/11-09-2024-16-59-04";
    "results-diffdrive/straightline/toofast/11-09-2024-16-58-24";
    "results-diffdrive/circle/start_center/11-09-2024-16-59-50";
    "results-diffdrive/square/11-09-2024-17-06-14";
    "results-diffdrive/figure8/chill/11-09-2024-17-00-53";
    %"results-diffdrive/figure8/fancyreps/11-09-2024--45-28";
    "results-diffdrive/figure8/toofast/11-09-2024-17-01-43";

    "results-unicycle/straightline/chill/11-09-2024-17-07-51";
    "results-unicycle/straightline/chill_errortheta_pisixths/11-09-2024-17-08-35";
    "results-unicycle/straightline/chill_errory/11-09-2024-17-10-00";
    "results-unicycle/straightline/toofast/11-09-2024-17-09-18";
    "results-unicycle/circle/start_center/11-09-2024-17-10-48";
    "results-unicycle/square/11-09-2024-17-17-21";
    "results-unicycle/figure8/chill/11-09-2024-17-11-53";
    %"results-unicycle/figure8/fancyreps/11-09-2024--45-28";
    "results-unicycle/figure8/toofast/11-09-2024-17-12-45";
    ]

s_ = size(PLOT_TESTS)
for i = 1:s_(1)
    clearvars -except PLOT_TESTS s_ i
    
    sPLOT_TEST = convertStringsToChars(PLOT_TESTS(i));
    PLOT_TEST = [sPLOT_TEST, '/workspace_composite.mat']
    load(PLOT_TEST)

    dir = ['images-', ROBOT, '/', sPLOT_TEST, '/']
    mkdir(dir);
    
    for n=1:3
        in1 = sim_data{n}.input1_name;
        in2 = sim_data{n}.input2_name;
        m1 = sim_data{n}.m1;
        m2 = sim_data{n}.m2;
 
        pause(1); clf; plot_trajectory(t{n}, ref_t{n}, q{n})
        pause(0.5); export_fig(gcf, '-transparent', [dir, num2str(n), '_trajectory.png'])
        pause(1); clf; plot_error(t{n}, ref_t{n}, q{n})
        pause(0.5); export_fig(gcf, '-transparent', [dir, num2str(n), '_error.png'])
        pause(1); clf; plot_doubleinput(t{n}, sim_data{n}.SATURATION,  U_track{n}, U_corr{n}, 0, in1, in2, m1, m2)
        pause(0.5); export_fig(gcf, '-transparent', [dir, num2str(n), '_double_input_1x2.png'])
        pause(1); clf; plot_doubleinput(t{n}, sim_data{n}.SATURATION,  U_track{n}, U_corr{n}, 1, in1, in2, m1, m2)
        pause(0.5); export_fig(gcf, '-transparent', [dir, num2str(n), '_double_input_2x1.png'])
        pause(1); clf; plot_tripleinput(t{n}, sim_data{n}.SATURATION, U{n}, U_track{n}, U_corr{n}, 0, in1, in2, m1, m2)
        pause(0.5); export_fig(gcf, '-transparent', [dir, num2str(n), '_triple_input_1x2.png'])
        pause(1); clf; plot_tripleinput(t{n}, sim_data{n}.SATURATION, U{n}, U_track{n}, U_corr{n}, 1, in1, in2, m1, m2)
        pause(0.5); export_fig(gcf, '-transparent', [dir, num2str(n), '_triple_input_2x1.png'])
       
        %pause(1); clf; plot_input(t{n}, sim_data{n}.SATURATION, U_track{n}, 'track')
        %pause(0.5); export_fig(gcf, '-transparent', [dir, num2str(n), '_track_input.png'])
        %pause(1); clf; plot_input(t{n}, sim_data{n}.SATURATION, U_corr{n}, 'corr')
        %pause(0.5); export_fig(gcf, '-transparent', [dir, num2str(n), '_corr_input.png'])

        pause(1); clf; plot_input(t{n},sim_data{n}.SATURATION,  U{n}, 0, '', in1, in2, m1, m2)
        pause(0.5); export_fig(gcf, '-transparent', [dir, num2str(n), '_total_input_1x2.png'])
        pause(1); clf; plot_input(t{n},sim_data{n}.SATURATION,  U{n}, 1, '', in1, in2, m1, m2)
        pause(0.5); export_fig(gcf, '-transparent', [dir, num2str(n), '_total_input_2x1.png'])

        pause(1); clf; plot_trajectory(t{n}, ref_t{n}, y{n})
        pause(0.5); export_fig(gcf, '-transparent', [dir, num2str(n), '_trajectory_out.png'])
        pause(1); clf; plot_error(t{n}, ref_t{n}, y{n})
        pause(0.5); export_fig(gcf, '-transparent', [dir, num2str(n), '_error_out.png'])
    end
    
    % correction difference (multistep, 1-step)
    pause(1); clf; plot_input_diff(t{3}, t{2}, U_corr{3}, U_corr{2}, 0, ['\textbf{$$' in1 '^{corr, multistep}$$}'], ['\textbf{$$' in1 '^{corr, 1step}$$}'], ['\textbf{$$' in2 '^{corr, multistep}$$}'], ['\textbf{$$' in2 '^{corr, 1step}$$}'], m1, m2)
    pause(0.5); export_fig(gcf, '-transparent', [dir, 'corr_input_diff_1x2.png'])
    pause(1); clf; plot_input_diff(t{3}, t{2}, U_corr{3}, U_corr{2}, 1, ['\textbf{$$' in1 '^{corr, multistep}$$}'], ['\textbf{$$' in1 '^{corr, 1step}$$}'], ['\textbf{$$' in2 '^{corr, multistep}$$}'], ['\textbf{$$' in2 '^{corr, 1step}$$}'], m1, m2)
    pause(0.5); export_fig(gcf, '-transparent', [dir, 'corr_input_diff_2x1.png'])

    % input difference (saturated track only, 1-step)
    pause(1); clf; plot_input_diff(t{1}, t{2}, U{1}, U{2}, 0, ['\textbf{$$' in1 '^{trackonly-sat}$$}'], ['\textbf{$$' in1 '^{1step}$$}'], ['\textbf{$$' in2 '^{trackonly-sat}$$}'], ['\textbf{$$' in2 '^{1step}$$}'], m1, m2)
    pause(0.5); export_fig(gcf, '-transparent', [dir, 'input_diff_track_1step_1x2.png'])
    pause(1); clf; plot_input_diff(t{1}, t{2}, U{1}, U{2}, 1, ['\textbf{$$' in1 '^{trackonly-sat}$$}'], ['\textbf{$$' in1 '^{1step}$$}'], ['\textbf{$$' in2 '^{trackonly-sat}$$}'], ['\textbf{$$' in2 '^{1step}$$}'], m1, m2)
    pause(0.5); export_fig(gcf, '-transparent', [dir, 'input_diff_track_1step_2x1.png'])
    
    % input difference (saturated track only, multistep)
    pause(1); clf; plot_input_diff(t{1}, t{3}, U{1}, U{3}, 0, ['\textbf{$$' in1 '^{trackonly-sat}$$}'], ['\textbf{$$' in1 '^{multistep}$$}'], ['\textbf{$$' in2 '^{trackonly-sat}$$}'], ['\textbf{$$' in2 '^{multistep}$$}'], m1, m2)
    pause(0.5); export_fig(gcf, '-transparent', [dir, 'input_diff_track_multistep_1x2.png'])
    pause(1); clf; plot_input_diff(t{1}, t{3}, U{1}, U{3}, 1, ['\textbf{$$' in1 '^{trackonly-sat}$$}'], ['\textbf{$$' in1 '^{multistep}$$}'], ['\textbf{$$' in2 '^{trackonly-sat}$$}'], ['\textbf{$$' in2 '^{multistep}$$}'], m1, m2)
    pause(0.5); export_fig(gcf, '-transparent', [dir, 'input_diff_track_multistep_2x1.png'])
    
    % input difference (1-step, multistep)
    pause(1); clf; plot_input_diff(t{2}, t{3}, U{2}, U{3}, 0, ['\textbf{$$' in1 '^{1step}$$}'], ['\textbf{$$' in1 '^{multistep}$$}'], ['\textbf{$$' in2 '^{1step}$$}'], ['\textbf{$$' in2 '^{multistep}$$}'], m1, m2)
    pause(0.5); export_fig(gcf, '-transparent', [dir, 'input_diff_1step_multistep_1x2.png'])
    pause(1); clf; plot_input_diff(t{2}, t{3}, U{2}, U{3}, 1, ['\textbf{$$' in1 '^{1step}$$}'], ['\textbf{$$' in1 '^{multistep}$$}'], ['\textbf{$$' in2 '^{1step}$$}'], ['\textbf{$$' in2 '^{multistep}$$}'], m1, m2)
    pause(0.5); export_fig(gcf, '-transparent', [dir, 'input_diff_1step_multistep_2x1.png'])
end