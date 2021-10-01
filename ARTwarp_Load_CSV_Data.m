% This function loads all .csv files in a user-selected directory into a DATA array 
% The files should have frequency in the second column and a header row, as
% is typical for Rocca output of whistle contours
function ARTwarp_Load_CSV_Data

global DATA numSamples tempres

path = uigetdir('*.ctr', 'Select the folder containing the contour files');
eval(['cd ' path]);
path = [path '/*csv'];
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
   % test=csvread(DATA(c1).name,0,0);    %this is if you don't want it to skip the header row...IS THAT RIGHT??
    test=csvread(DATA(c1).name,1,0);   %this is if you want it to skip the
    %header row
    freqContour = test(:,1);
    DATA(c1).ctrlength = freqContour(length(freqContour))/1000;
    DATA(c1).length = length(freqContour)-1;
    DATA(c1).contour = freqContour(1:DATA(c1).length);
    DATA(c1).tempres = DATA(c1).ctrlength/DATA(c1).length;
    DATA(c1).category = 0;
end
h = findobj('Tag', 'Runmenu');                                                                                                                        
set(h, 'Enable', 'on');

