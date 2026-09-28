% Tests to ensure waitbars throughout the codebase are created and deleted accordingly and all information
% on them is relevant to the function.

tstDir = fileparts(mfilename("fullpath"));
ARTwarpRoot = fullfile(tstDir, '..');
addpath(genpath(ARTwarpRoot));
csvDir = fullfile(ARTwarpRoot, 'Test_Data', 'csv');

%% No waitbar is left after running TempRes3
% Test set up
inDir = tempname;
outDir = tempname;
mkdir(inDir)
copyfile(fullfile(csvDir, '*.csv'), inDir);

numbarsBef = length(findall(0, 'Tag', 'TMWWaitbar'));

% Invisible GUI for testing
h0 = figure('Tag','conversion_parameter_GUI','Visible','off');
setappdata(h0, 'input_folder', inDir);
clean = onCleanup(@() delete(findall(0, 'Tag', 'conversion_parameter_GUI')));
h1 = uicontrol('Parent',h0, 'String', outDir,'Style','edit','Tag','output_folder');
h1 = uicontrol('Parent',h0,'String',num2str(0.005,'%i'),'Style','edit','Tag','tempres');
h1 = uicontrol('Parent',h0,'String', num2str(2,'%i'),'Style','edit','Tag','freqCol');

% Testing TempRes3
TempRes3(false, [], [], "");
numbarsAft = length(findall(0, 'Tag', 'TMWWaitbar'));

rmdir(inDir, 's');
rmdir(outDir, 's');

assert(numbarsBef == numbarsAft, '%d loading bars before and %d after running TempRes3', numbarsBef, numbarsAft)
%% Waitbar removed when TempRes3 errors mid-run
% Test set up
inDir = tempname;
outDir = tempname;
mkdir(inDir)
copyfile(fullfile(csvDir, '*.csv'), inDir);

numbarsBef = length(findall(0, 'Tag', 'TMWWaitbar'));

% Invisible GUI for testing
h0 = figure('Tag','conversion_parameter_GUI','Visible','off');
setappdata(h0, 'input_folder', inDir);
clean = onCleanup(@() delete(findall(0, 'Tag', 'conversion_parameter_GUI')));
h1 = uicontrol('Parent',h0, 'String', outDir,'Style','edit','Tag','output_folder');
h1 = uicontrol('Parent',h0,'String',num2str(0.005,'%i'),'Style','edit','Tag','tempres');
% Wrong column for freqCol for testing
h1 = uicontrol('Parent',h0,'String', num2str(3,'%i'),'Style','edit','Tag','freqCol');

try
    TempRes3(false, [], [], "");
catch
end
numbarsAft = length(findall(0, 'Tag', 'TMWWaitbar'));

rmdir(inDir, 's');
rmdir(outDir, 's');

assert(numbarsBef == numbarsAft, '%d loading bars before and %d after TempRes3 stops mid-run', numbarsBef, numbarsAft)