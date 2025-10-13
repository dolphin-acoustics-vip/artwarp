% This script is taken from the old 'callback2' variable. It is called when
% the radio button 'resample' is selected on the main ARTwarp GUI figure,
% and enables the user to enter a value to the 'sample interval' field
% (un-dims the field)

h1 = findobj('Tag','resample');
h2 = findobj('Tag','sampleInterval');
s1 = get(h1,'value');
if s1 == 1
    set(h2, 'Enable', 'on');
else 
    set(h2, 'Enable', 'off');
end