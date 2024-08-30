
clear all

disp('Waiting 5s')
pause(1)

PLOT_TESTS = [
    "results-diffdrive/straightline/chill/01-Aug-2024 15-34-03";
    "results-diffdrive/straightline/chill_errortheta_pisixths/01-Aug-2024 15-56-36";
    "results-diffdrive/square/01-Aug-2024 16-18-51";
    "results-diffdrive/circle/start_center/01-Aug-2024 16-46-41";
    "results-diffdrive/circle/start_tangent/01-Aug-2024 16-55-09";
    "results-diffdrive/circle/toofast/01-Aug-2024 17-35-25"
    "results-diffdrive/straightline/toofast/01-Aug-2024 15-37-48"
    "results-diffdrive/figure8/chill/15-Aug-2024 09-16-21";
    "results-diffdrive/figure8/toofast/15-Aug-2024 09-10-32";
    "results-diffdrive/straightline/abrupt_stop_chill/27-Aug-2024 10-27-31";
    "results-diffdrive/straightline/abrupt_stop_toofast/27-Aug-2024 10-44-35"
    "results-diffdrive/cardioid/start_tangent/01-Aug-2024 18-53-41";
    "results-diffdrive/figure8/fancyreps/09-Aug-2024 13-04-44";
    "results-diffdrive/sin/no_start_error/27-Aug-2024 19-28-17";
    "results-diffdrive/sin/no_start_error/27-Aug-2024 19-29-42";
    "results-diffdrive/sin/no_start_error/27-Aug-2024 19-31-17";
    "results-diffdrive/sin/no_start_error/27-Aug-2024 19-38-03"
    ]

s_ = size(PLOT_TESTS)
for i = 1:s_(1)
    clearvars -except PLOT_TESTS s_ i
    
    sPLOT_TEST = convertStringsToChars(PLOT_TESTS(i));
    PLOT_TEST = [sPLOT_TEST, '/workspace_composite.mat']
    load(PLOT_TEST)

    dir = ['gifs-diffdrive/', sPLOT_TEST, '/']
    mkdir(dir);

    close all; pause(2); video(q{1}', ref_t{1}', Q_pred{1}, U_track{1}, U_corr{1}, 0, 0.12, t{1}, 4, sim_data{1}.tc*0.25, "track only");
    close all; pause(2); video(q{2}', ref_t{2}', Q_pred{2}, U_track{2}, U_corr{2}, 1, 0.12, t{2}, 4, sim_data{2}.tc*0.25, "track and 1-step");
    close all; pause(2); video(q{3}', ref_t{3}', Q_pred{3}, U_track{3}, U_corr{3}, 3, 0.12, t{3}, 4, sim_data{3}.tc*0.25, "track and multistep");
    
    %movefile("*.gif", dir);
    %movefile("*.avi", dir);
    movefile("*.mp4", dir);

end