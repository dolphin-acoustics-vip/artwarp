% FORMATTING

global DATA

clear all
[filename, path] = uigetfile('X', 'Select a Folder and type a search pattern');
cd C:\matlabR12\work
DATA = dir('C:\MATLABR12\work\*87-10-08*.ctr');
DATA = rmfield(DATA,'date');
DATA = rmfield(DATA,'bytes');
DATA = rmfield(DATA,'isdir');
[numSamples x] = size(DATA);
o = zeros(1, 250);
for c1 = 1:numSamples
    name = ['                         '];
    name(1: length(DATA(c1).name)) = DATA(c1).name;
    DATA(c1).name = name;
    eval(['load ' DATA(c1).name ' -mat']);
    DATA(c1).contour = interp1(1:length(fcontour)-1, fcontour(1:end-1), 1:10/2.902:length(fcontour)-1);
    DATA(c1).length = length(fcontour(1:end-1));
    DATA(c1).category = 0;
end
