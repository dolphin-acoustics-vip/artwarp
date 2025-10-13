% This script is taken from the old 'callback1' variable, and is called
% when the main ARTwarp GUI figure is closed. It saves the network 
% parameters used to a file named 'ARTwarp.mat'

global vigilance bias learningRate maxNumCategories maxNumIterations sampleInterval resample;  
shh=get(0,'ShowHiddenHandles');
set(0,'ShowHiddenHandles','on');
delete(get(0,'CurrentFigure'));
set(0,'ShowHiddenHandles',shh);
filename = 'ARTwarp.mat';
eval(['save ' filename ' vigilance bias learningRate maxNumCategories maxNumIterations sampleInterval resample']);