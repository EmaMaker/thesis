
clear all

disp('Waiting 5s')
pause(1)

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

    dir = ['videos-' ROBOT '/', sPLOT_TEST, '/']
    mkdir(dir);

    close all; pause(2); video(q{1}', ref_t{1}', Q_pred{1}, U_track{1}, U_corr{1}, 0, 0.12, t{1}, 4, sim_data{1}.tc*0.25, "track only");
    close all; pause(2); video(q{2}', ref_t{2}', Q_pred{2}, U_track{2}, U_corr{2}, 1, 0.12, t{2}, 4, sim_data{2}.tc*0.25, "track and 1-step");
    close all; pause(2); video(q{3}', ref_t{3}', Q_pred{3}, U_track{3}, U_corr{3}, 3, 0.12, t{3}, 4, sim_data{3}.tc*0.25, "track and multistep");
    
    %movefile("*.gif", dir);
    movefile("*.avi", dir);
    %movefile("*.mp4", dir);

end