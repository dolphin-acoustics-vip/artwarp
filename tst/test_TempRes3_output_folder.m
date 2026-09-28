% Testing TempRes3 to make sure input and output folders are created appropriately 
% as well as after altering/creating files, they land where they should.

% Finds name of folder containing this file
tstDir = fileparts(mfilename("fullpath"));

% Points to file with previous path /tst and adds /..
ARTwarpRoot = fullfile(tstDir, '..');

% Adds ~/artwarp to search path
addpath(genpath(ARTwarpRoot));

%Creates path to csv directory: ~/artwarp + Test_Data/csv
csvDir = fullfile(ARTwarpRoot, 'Test_Data', 'csv');

% Counts the csv files in Test_Data
numCSV = length(dir(fullfile(csvDir, '*.csv')));

%% Given x csv files x ctr files should be created in correct dir
% Temp directories so no files are actually added onto codebase when tests run
inDir = tempname;
outDir = tempname;
mkdir(inDir)
copyfile(fullfile(csvDir, '*.csv'), inDir);

TempRes3(true, 2, 0.005, inDir, outDir);
numCTR = length(dir(fullfile(outDir, '*.ctr')));

assert(numCTR == numCSV, '%d ctr files created vs %d csv files', numCTR, numCSV);
assert(isempty(dir(fullfile(inDir, '*.ctr'))), 'Input directory has .ctr files after conversion');

% Delete temp directories and files
rmdir(inDir, 's')
rmdir(outDir, 's')

%% Given 4 inputs where should files go
inDir = tempname;
mkdir(inDir)
copyfile(fullfile(csvDir, '*.csv'), inDir);

TempRes3(true, 2, 0.005, inDir);
numCTR = length(dir(fullfile(inDir, '*.ctr')));

assert(numCTR == numCSV, '%d ctr files were created from %d csv files in input directory', numCTR, numCSV);
rmdir(inDir, 's')
%% what should pwd be before and after the call
inDir = tempname;
outDir = tempname;
mkdir(inDir)
copyfile(fullfile(csvDir, '*.csv'), inDir);

currentDir = pwd;
TempRes3(true, 2, 0.005, inDir, outDir);

newDir = pwd;
assert(strcmp(currentDir, newDir), 'Current directory changes after calling TempRes3');

rmdir(inDir, 's')
rmdir(outDir, 's')
%% For the .ctr contents which vars are saved
inDir = tempname;
outDir = tempname;

mkdir(inDir)
copyfile(fullfile(csvDir, '*.csv'), inDir);
TempRes3(true, 2, 0.005, inDir, outDir);

files = dir(fullfile(outDir, '*.ctr'));
for i = 1:length(files)
    % files(i) is the struct for that indv file with name, folder, date...
    % Grabs the actual file
    file = fullfile(files(i).folder, files(i).name);
    
    % Loads file, forcing from .crt to .m
    S = load(file, '-mat');
    transpFreq = transpose(S.freqContour);
    
    % Name of .ctr file to find corresponding .csv
    [~, name] = fileparts(files(i).name);
    rawFreq = csvread(fullfile(inDir, [name, '.csv']), 1, 0);
    
    % Testing freqContours, tempres and ctrlength are as they should be vs their csv
    assert(isequal(transpFreq, rawFreq(:,2)), 'Freq Contours between .ctr and .csv are not the same for file %s', fullfile(inDir, [name, '.csv']));
    assert(S.tempres == 0.005, 'Temp resolution for file %s is not the same as input resolution', fullfile(inDir, [name, '.csv']));
    assert(abs(S.ctrlength - length(rawFreq)*0.005) < (1e-12), 'Diff in contour length between .ctr and .csv, for file %s is not under 1e-12 threshold', fullfile(inDir, [name, '.csv']));
end

rmdir(inDir, 's')
rmdir(outDir, 's')

%% Invalid CSV file is caught and conversion continues
% Testing try and catch on invalid file TempRes3
inDir = tempname;
outDir = tempname;

mkdir(inDir)
copyfile(fullfile(csvDir, '*.csv'), inDir);

% Write a deliberately broken CSV (broken_csv.csv) into inDir
brokenTxt = ["Time [ms], Peak Frequency [Hz]"
"This is not a number, This isnt one either"];
writelines(brokenTxt, fullfile(inDir, 'broken_csv.csv'));

numCSV = length(dir(fullfile(inDir, '*.csv')));

% Warning is visualy off (no msg) but still throws
warning("off","TempRes3:invalidCSV");
clean = onCleanup(@() warning("on", "TempRes3:invalidCSV"));
lastwarn('')

TempRes3(true, 2, 0.005, inDir, outDir);
numCTR = length(dir(fullfile(outDir, '*.ctr')));

% Checks that the warning was thrown (even if no msg)
[msg, id] = lastwarn;
assert(strcmp(id, "TempRes3:invalidCSV"), '%s error id is not TempRes3:invalidCSV', id)
assert(numCTR == numCSV - 1, '%d ctr files were created from %d csv files in input directory', numCTR, numCSV);

rmdir(inDir, 's')
rmdir(outDir, 's')