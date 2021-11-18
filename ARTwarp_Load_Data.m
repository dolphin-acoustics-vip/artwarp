% This function loads all .ctr files in a user-selected directory into a DATA array 
function ARTwarp_Load_Data

global DATA numSamples tempres

path = uigetdir('*.ctr', 'Select the folder containing the contour files');
eval(['cd ' path]);
path = [path '/*ctr'];
DATA = dir(path);
DATA = rmfield(DATA,'date');
DATA = rmfield(DATA,'datenum');
DATA = rmfield(DATA,'bytes');
DATA = rmfield(DATA,'isdir');
[numSamples x] = size(DATA);

% this line is needed to ctrick Matlab into beleiving that fcontour is a
% variable (which it will be soon) and to stop it trying to use the built
% in graphics function fcontour(...)
fcontour = 0;
for c1 = 1:numSamples
    clear tempres
    clear ctrlength
    clear fcontour
    eval(['load ' DATA(c1).name ' -mat']);
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
    if exist('tempres', 'var')
        DATA(c1).tempres = tempres;
    else
        DATA(c1).tempres = DATA(c1).ctrlength/DATA(c1).length;
    end
    DATA(c1).category = 0;
end
h = findobj('Tag', 'Runmenu');                                                                                                                        
set(h, 'Enable', 'on');

