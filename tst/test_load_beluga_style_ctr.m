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
% which is stored in the style of a Beluga-generated CTR file, i.e. which 
% stores one array of length n where the first n-1 indices store the
% frequency contour, and index n stores the total duration of the contour
% in milliseconds. This array will be saved as 'fcontour', according to
% convention.
testDataPath = fullfile(ARTwarpRoot, 'Test_Data');
BelugactrPath = fullfile(testDataPath, 'ctr', 'Beluga_Style_Contours');
mkdir(BelugactrPath);
belugaContourPath = fullfile(BelugactrPath, 'beluga_style_contour.ctr');
% Here the contour has duration 40ms and 9 datapoints (so a mean temporal
% resolution of 5ms)
fcontour = [11000 12000 13000 14000 15000 14000 13000 12000 11000 40];
save(belugaContourPath, 'fcontour');

% Load the dummy contour
ARTwarp_Load_Data(true, BelugactrPath);

% Verify that the duration has been extracted correctly
assert(DATA.ctrlength==0.04)
% Verify that the contour length has been correctly calculated
assert(DATA.length==9)
% Verify that the contour itself is correctly extracted
assert(all((DATA.contour==fcontour(1:end-1))))
% verify that the temporal resolution has been correctly calculated
assert(DATA.tempres==0.005)

% print success message
fprintf("the contour variables from %s were loaded correctly", belugaContourPath)

% Delete the temporary directory and the dummy contour, and clear all local
% and global variables
rmdir(BelugactrPath, "s")
clear