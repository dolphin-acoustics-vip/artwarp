% This function loads all .ctr files in a user-selected directory into a DATA array 

% Additional comments added by WF 8/7/2022 to help us newbies

function ARTwarp_Load_Data(is_cli_mode, input_folder)

global DATA numSamples tempres

% user selects folder that contains .ctr files and changes the active
% directory to this location and only sees .ctr files

% if running in cli mode, get the path to the .ctrs from input_folder:
if is_cli_mode
    path = input_folder;

% otherwise, get the user to select the path from the gui
else
    path = uigetdir('*.ctr', 'Select the folder containing the contour files');
end

path = [path '/*ctr'];

DATA = dir(path);
DATA = rmfield(DATA,'date');
DATA = rmfield(DATA,'datenum');
DATA = rmfield(DATA,'bytes');
DATA = rmfield(DATA,'isdir');
[numSamples x] = size(DATA);

% this line is needed to trick Matlab into beleiving that fcontour is a
% variable (which it will be soon) and to stop it trying to use the built
% in graphics function fcontour(...)
fcontour = 0;
if ~is_cli_mode
    waitbr = waitbar(0, 'Loading contours...');
end
for c1 = 1:numSamples
    clear tempres
    clear ctrlength
    clear fcontour
    
    % Parses the file name as a string variable
    filename = fullfile(DATA(c1).folder, DATA(c1).name);
    load(filename, '-mat'); % enforce reading the file as a MAT-file regardless of its extension
    
    if exist('fcontour', 'var')
        DATA(c1).ctrlength = fcontour(length(fcontour))/1000;
        DATA(c1).length = length(fcontour);
        DATA(c1).contour = fcontour(1:DATA(c1).length);
    else
        DATA(c1).ctrlength = freqContour(length(freqContour))/1000;
        DATA(c1).length = length(freqContour)-1;
        DATA(c1).contour = freqContour(1:DATA(c1).length);
    end
    if exist('tempres', 'var') %if the variable 'tempres' exists (because it was entered in the ARTwarp_Get_Parameters.m file), make this the value in the DATA.tempres field
        DATA(c1).tempres = tempres;
    else
        DATA(c1).tempres = DATA(c1).ctrlength/DATA(c1).length; %if it doesn't, tempres is found by using ctrlength divided by length
    end

    DATA(c1).category = 0; %category name set to 0 for the active contour

    DATA(c1).match = []; %match set initially to a null value (empty array) for the active contour

    if exist('id', 'var') % if the variable 'id' exists, make this the value in the DATA.id field (this forms a unique identifier for each contour)
        DATA(c1).id = id;
        clear id; % then clear the id variable to avoid all subsequent contours being assigned the same ID!
    else
        DATA(c1).id = []; % otherwise, make the value in the DATA.id field [], to show that no ID has been assigned
    end

    if exist('parent_ids', 'var') % if the variable 'parent_ids' exists, make this the value in the DATA.parent_ids field
        DATA(c1).parent_ids = parent_ids;
        clear parent_ids; % then clear the parent_ids variable to avoid all subsequent contours being assigned the same parent_ids!
    else
        DATA(c1).parent_ids = []; % otherwise, make the value in the DATA.parent_ids field [], to show that no parent_ids have been assigned
    end
    if ~is_cli_mode
        waitbar(c1/numSamples, waitbr, sprintf('Loaded %d of %d samples', c1, numSamples));
    end
end

if ~is_cli_mode
    close(waitbr)
end

% if not running in cli mode, update the gui to undim the 'run' menu
if ~is_cli_mode
    h = findobj('Tag', 'Runmenu'); %find the object Runmenu (which is in ARTwarp.m)                                                                                                                        
    set(h, 'Enable', 'on'); %change its 'Enable' property to 'on' so the menu in the ARTwarp window will be undimmed
end