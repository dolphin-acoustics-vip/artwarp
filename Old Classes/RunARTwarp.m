%   This file will run all of the new classes that have been rewritten for
%   ARTwarp.


% Data Loading functions  
% 
% To assign the location of the files (in this case csv but for ctr set the
% argument as '/*ctr')
a = Load_Data.Find_Path('/*csv');

% To load the data we are using from said files
b = Load_Data.Data_Loader(a.fileType, a.path);

% This loads the basic parameters (with properties: bias, learningRate,
% maxNumCategories, maxNumIterations, resample, sampleInterval, vigilance,
% warpFactor). Change any of these with c.property = newvalue (only numeric
% values will be accepted)
c = Parameters;




