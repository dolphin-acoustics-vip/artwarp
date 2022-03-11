function ARTwarp_Plot_Saved_Net

global DATA NET

savedResultsFile = uigetfile('*.mat',...
    'Select saved categorization file (.mat)');

% Save current DATA and network parameters
oldDATA = DATA;
oldNET = NET;

load(savedResultsFile , 'DATA', 'NET');

ARTwarp_Plot_Net();

% Restore current DATA and network parameters
DATA = oldDATA;
NET = oldNET;

end