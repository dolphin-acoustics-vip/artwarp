% GET ARTwarp ROOT PATH FOR REFERENCE WHILE RUNNING IN CONTINUOUS
% INTEGRATION
tstDir = fileparts(mfilename("fullpath"));
ARTwarpRoot = fullfile(tstDir, '..');

% Add the ARTwarp root path to the MATLAB path so we can run ARTwarp's
% functions
addpath(genpath(ARTwarpRoot))

% Initialise global variable DATA so we can examine their changes after
% ARTwarp_Load_Data
global DATA

% Generate and save a dummy contour to a temporary directory Test_Data/ctr 
% which is stored in the style of a TempRes3-generated CTR file, i.e. which 
% stores an array of length n which stores the frequency contour, and
% seperately stores variables 'tempres' and 'ctrlength' which store the
% temporal resolution (in seconds) and the total duration (in seconds)
% respectively. The frequency contour array will be saved as 'freqcontour',
% according to convention.
testDataPath = fullfile(ARTwarpRoot, 'Test_Data');
TempResctrPath = fullfile(testDataPath, 'ctr', 'TempRes_Style_Contours');
mkdir(TempResctrPath);
TempResContourPath = fullfile(TempResctrPath, 'TempRes3_style_contour.ctr');
% Here the contour has duration 40ms, length 9 datapoints, and mean
% temporal resolution 5ms
freqContour = [11000 12000 13000 14000 15000 14000 13000 12000 11000];
tempres = 0.005;
ctrlength = 0.04;
save(TempResContourPath, 'freqContour', 'tempres', 'ctrlength');

% Load the dummy contour
ARTwarp_Load_Data(true, TempResctrPath);

% Verify that the duration has been extracted correctly
assert(DATA.ctrlength==0.04)
% Verify that the contour length has been correctly calculated
assert(DATA.length==9)
% Verify that the contour itself is correctly extracted
assert(all((DATA.contour==freqContour)))
% verify that the temporal resolution has been correctly calculated
assert(DATA.tempres==0.005)

% print success message
fprintf("the contour variables from %s were loaded correctly", TempResContourPath)

% Delete the temporary directory and the dummy contour, and clear all local
% and global variables
rmdir(TempResctrPath, "s")
clear