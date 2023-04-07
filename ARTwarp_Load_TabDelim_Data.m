% This function loads all .txt files in a user-selected directory into a DATA array 
% The files should have frequency in the second column and no header row,
% as well as using a tab character for the delimter

%April 26 2017, changed line 27 so that it loads reference contours which
%have frequency in the first column, not the second column

function ARTwarp_Load_TabDelim_Data

global DATA numSamples tempres

path = uigetdir('*.ctr', 'Select the folder containing the contour files');
disp(['path = ' path]);
eval(['cd ' path]);
path = [path '/*txt'];
DATA = dir(path);
DATA = rmfield(DATA,'date');
DATA = rmfield(DATA,'datenum');
DATA = rmfield(DATA,'bytes');
DATA = rmfield(DATA,'isdir');
[numSamples x] = size(DATA);
for c1 = 1:numSamples
    
    % make sure to skip the header row, since it has characters in it and
    % csvread only works with numeric values.  The frequency should be in
    % the second column
    test=dlmread(DATA(c1).name,'\t');
    fcontour = test(:,1);
    DATA(c1).ctrlength = fcontour(length(fcontour))/1000;
    DATA(c1).length = length(fcontour)-1;
    DATA(c1).contour = fcontour(1:DATA(c1).length);
    DATA(c1).tempres = DATA(c1).ctrlength/DATA(c1).length;
    DATA(c1).category = 0;
end
h = findobj('Tag', 'Runmenu');                                                                                                                        
set(h, 'Enable', 'on');

