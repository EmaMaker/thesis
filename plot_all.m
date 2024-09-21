clc
clear all
close all

disp('Creating figure')
figure('units','normalized','outerposition',[0 0 1 1])
disp('Photos will start in 3s')
pause(3)

PLOT_TESTS = [
    "results-unicycle-costfun2-soltraj/circle/start_center/21-09-2024-15-29-40"
    "results-diffdrive-costfun2-soltraj/circle/start_center/21-09-2024-12-16-00"
    ]

s_ = size(PLOT_TESTS)
for i = 1:s_(1)
    clearvars -except PLOT_TESTS s_ i
    
    sPLOT_TEST = convertStringsToChars(PLOT_TESTS(i));
    PLOT_TEST = [sPLOT_TEST, '/workspace_composite.mat']
    load(PLOT_TEST)

    dir = ['images-', ROBOT, '-costfun2-soltraj/', sPLOT_TEST, '/']
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