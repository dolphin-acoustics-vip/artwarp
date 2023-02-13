% This function loads all .ctr files in a user-selected directory into a DATA array 

% Additional comments added by WF 8/7/2022 to help us newbies

function ARTwarp_Load_Data

global DATA numSamples tempres

% user selects folder that contains .ctr files and changes the active
% directory to this location and only sees .ctr files
path = uigetdir('*.ctr', 'Select the folder containing the contour files');
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
    eval(['load ' fullfile(DATA(c1).folder, DATA(c1).name) ' -mat']);
    if exist('ctrlength', 'var')
        DATA(c1).ctrlength = ctrlength;
        DATA(c1).length = length(freqContour);
        DATA(c1).contour = freqContour;
    elseif exist('fcontour', 'var')
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
end
h = findobj('Tag', 'Runmenu'); %find the object Runmenu (which is in ARTwarp.m)                                                                                                                        
set(h, 'Enable', 'on'); %change its property to on so the menu in the ARTwarp window will be undimmed
