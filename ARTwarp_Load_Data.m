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
for c1 = 1:numSamples
    clear tempres
    clear ctrlength
    clear fcontour
    
    % Parses the file name as a string variable
    filename = fullfile(DATA(c1).folder, DATA(c1).name);
    load(filename, '-mat'); % enforce reading the file as a MAT-file regardless of its extension
    
    % If the CTR file contains a variable 'fcontour', assume it stores the
    % duration of the contour (total time in milliseconds) in the final
    % index of the 'fcontour' array. If the file does not also contain a
    % variable 'tempres', we will use this duration to calculate the
    % temporal resolution later
    if exist('fcontour', 'var')
        % extract the duration from the last index and store it in the
        % ctrlength field (dividing by 1000 to get duration in seconds)
        DATA(c1).ctrlength = fcontour(length(fcontour))/1000;
        % calculate and store the length of the frequency contour,
        % remembering to subtract 1 for the last index
        DATA(c1).length = length(fcontour)-1;
        % extract and store the frequency contour from the remaining
        % indexes
        DATA(c1).contour = fcontour(1:DATA(c1).length);

    % Otherwise, if the CTR file contains a variable 'freqContour', assume
    % it stores the temporal resolution tempres seperately (if at all), and
    % that the entire 'freqContour' array contains only frequency points
    elseif exist('freqContour', 'var')
        % store the duration as an empty array to indicate not provided yet
        DATA(c1).ctrlength = [];
        % store the length of the frequency contour
        DATA(c1).length = length(freqContour);
        % extract and store the frequency contour itself
        DATA(c1).contour = freqContour(1:DATA(c1).length);

    % Otherwise, throw an error: no expected contour variable was present
    else
        error("The file '%s' did not contain either a variable 'fcontour' or a variable 'freqContour'", filename)
    end

    % If the CTR file contains a variable 'tempres', store this as the
    % temporal resolution of the contour and use this to calculate the
    % total duration of the contour from duration = tempres*(length-1)
    if exist('tempres', 'var')
        DATA(c1).tempres = tempres;
        DATA(c1).ctrlength = DATA(c1).tempres*(DATA(c1).length-1);

    % Otherwise, if the CTR file contains a variable 'ctrlength', use this
    % and the length to calculate the temporal resolution from tempres =
    % duration/(length-1)
    elseif exist('ctrlength', 'var')
        DATA(c1).tempres = ctrlength/(DATA(c1).length-1);

    % Otherwise, if we previously found and saved the duration of the
    % contour, use this and the length to calculate the temporal resolution
    % from tempres = duration/(length-1)
    elseif ~isempty(DATA(c1).ctrlength)
        DATA(c1).tempres = DATA(c1).ctrlength/(DATA(c1).length-1);
        
    % Otherwise, output a warning. If no temporal resolution is provided,
    % we cannot resample without an error.
    else
        fprintf("WARNING - no duration or temporal resolution was provided in the file '%s':\n" + ...
            "choosing to resample before categorisation will result in an error.\n", filename);
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
end

% if not running in cli mode, update the gui to undim the 'run' menu
if ~is_cli_mode
    h = findobj('Tag', 'Runmenu'); %find the object Runmenu (which is in ARTwarp.m)                                                                                                                        
    set(h, 'Enable', 'on'); %change its 'Enable' property to 'on' so the menu in the ARTwarp window will be undimmed
end