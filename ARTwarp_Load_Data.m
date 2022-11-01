% This function loads all .ctr files in a user-selected directory into a DATA array 

% Additional comments added by WF 8/7/2022 to help us newbies

function ARTwarp_Load_Data

global DATA numSamples tempres

% user selects folder that contains .ctr files and changes the active
% directory to this location and only sees .ctr files
path = uigetdir('*.ctr', 'Select the folder containing the contour files');
cd(path);
path = [path '/*ctr']; %only include files that end in 'ctr'
DATA = dir(path); %creates a structure 'DATA' to hold the list of .ctr files contained in the user-specified folder
DATA = rmfield(DATA,'date'); %remove the extraneous fields that contain the files' metadata
DATA = rmfield(DATA,'datenum');
DATA = rmfield(DATA,'bytes');
DATA = rmfield(DATA,'isdir');
[numSamples x] = size(DATA); %assigns the number of .ctr files that were loaded into the structure DATA (i.e., # of .ctr files in the folder selected) to the variable 'numSamples'
for c1 = 1:numSamples %active contour number, looping from 1 to total number in the folder (the size of DATA)
    clear tempres %removes 'tempres' and 'ctrlength' as variables in the local workspace so they can be created again fresh
    clear ctrlength
    eval(['load ' DATA(c1).name ' -mat']); %loads the active contour name as a .mat file
    if exist('ctrlength', 'var') %if the variable 'ctrlength' exists in the current row c1 (because it's not the first iteration?), assign values to the variables below
        DATA(c1).ctrlength = ctrlength; %load the existing 'ctrlength' value for the current contour (c1)
        DATA(c1).length = length(freqContour); %make the value in the length field the length of 'freqContour'
        DATA(c1).contour = freqContour; % make the value in the contour field the freqContour
    else %if the variable 'ctrlength' doesn't exist (because it's the first contour of the run), assign values based on the following formulas
        DATA(c1).ctrlength = freqContour(length(freqContour))/1000; %ctrlength is the length of freqContour divided by 1000 (why divided by 1000?)
        DATA(c1).length = length(freqContour)-1; %length is the length of freqContour-1
        DATA(c1).contour = freqContour(1:DATA(c1).length); %contour is the freqContour from point 1 thru the length (which is length of freqContour-1 point)
    end
    if exist('tempres', 'var') %if the variable 'tempres' exists (because it was entered in the ARTwarp_Get_Parameters.m file), make this the value in the DATA.tempres field
        DATA(c1).tempres = tempres;
    else
        DATA(c1).tempres = DATA(c1).ctrlength/DATA(c1).length; %if it doesn't, tempres is found by using ctrlength divided by length
    end
    DATA(c1).category = 0; %category name set to 0 for the active contour
end
h = findobj('Tag', 'Runmenu'); %find the object Runmenu (which is in ARTwarp.m)                                                                                                                        
set(h, 'Enable', 'on'); %change its property to on so the menu in the ARTwarp window will be undimmed

