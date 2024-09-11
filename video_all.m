
clear all

disp('Waiting 5s')
pause(1)

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

    dir = ['videos-diffdrive/', sPLOT_TEST, '/']
    mkdir(dir);

    close all; pause(2); video(q{1}', ref_t{1}', Q_pred{1}, U_track{1}, U_corr{1}, 0, 0.12, t{1}, 4, sim_data{1}.tc*0.25, "track only");
    close all; pause(2); video(q{2}', ref_t{2}', Q_pred{2}, U_track{2}, U_corr{2}, 1, 0.12, t{2}, 4, sim_data{2}.tc*0.25, "track and 1-step");
    close all; pause(2); video(q{3}', ref_t{3}', Q_pred{3}, U_track{3}, U_corr{3}, 3, 0.12, t{3}, 4, sim_data{3}.tc*0.25, "track and multistep");
    
    %movefile("*.gif", dir);
    movefile("*.avi", dir);
    %movefile("*.mp4", dir);

end