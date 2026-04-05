% GET ARTwarp ROOT PATH FOR REFERENCE WHILE RUNNING IN CONTINUOUS
% INTEGRATION
tstDir = fileparts(mfilename("fullpath"));
ARTwarpRoot = fullfile(tstDir, '..');

% Add the ARTwarp root path to the MATLAB path so we can run ARTwarp's
% functions
addpath(genpath(ARTwarpRoot))

% CONVERT .csv FILES TO .ctr
% read from the Test_Data/csv folder and convert .csvs to .ctrs

% Format the absolute file path of the directory containing the .csvs
csvDir = fullfile(ARTwarpRoot, 'Test_Data', 'csv');
% Run TempRes3 to convert the .csvs at this location to .ctrs. Note that we
% do not need to navigate to the ARTwarpRoot directory to run this, but
% TempRes3 must be on the MATLAB path
TempRes3(true, 2, 0.005, csvDir)

% CATEGORISE .ctr FILES USING ARTwarp_cli_mode.m
% Note that we load data directly from Test_Data/csv as ARTwarp_Load_Data.m
% automatically reads only the .ctr files in the folder. Note also that we
% do not need to navigate to the ARTwarpRoot directory to run this, but
% ARTwarp_cli_mode must be on the MATLAB path 

% Categorise using the parameters warpFactorLevel = 3, vigilance =
% 96, bias = 0.000001, learningRate = 0.1, maxNumCategories = 56,
% maxNumIterations = 100, resample = 1, sampleInterval = 0.01,
% compareWarped = 1 and recatSingleCats = 1
% Command format: ARTwarp_cli_mode('<input_folder_name>', <warp_factor>, <vigilance>, <number_of_contours>, <max_num_of_iterations>)
ARTwarp_cli_mode(csvDir, 3, 96, 56, 100, 'compareWarped', 1, 'recatSingleCats', 1)