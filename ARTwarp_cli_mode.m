function ARTwarp_cli_mode(varargin)

% PARSE INPUT ARGUMENTS

% Instantiate an inputParser object to manage inputs
p = inputParser;

% Add required positional arguments for: 
% The path to the folder containing the contours to categorise
addRequired(p, 'inputFolder', @isfolder);

% The warp factor level
validationFcn = @(x) (x > 1) && mod(x,1)==0 && isnumeric(x) && isscalar(x);
addRequired(p, 'warpFactorLevel', validationFcn);

% The vigilance percentage
validationFcn = @(x) (x >= 1) && (x <= 99) && isnumeric(x) && isscalar(x);
addRequired(p, 'vigilance', validationFcn);

% The bias
validationFcn = @(x) (x >= 0) && (x <= 1) && isnumeric(x) && isscalar(x);
addRequired(p, 'bias', validationFcn);

% The learning rate
validationFcn = @(x) (x > 0) && (x <= 1) && isnumeric(x) && isscalar(x);
addRequired(p, 'learningRate', validationFcn);

% The maximum number of categories
validationFcn = @(x) (x >= 1) && mod(x,1)==0 && isnumeric(x) && isscalar(x);
addRequired(p, 'maxNumCategories', validationFcn);

% The maximum number of iterations
validationFcn = @(x) (x >= 1) && mod(x,1)==0 && isnumeric(x) && isscalar(x);
addRequired(p, 'maxNumIterations', validationFcn);

% Whether the contours should be resampled before categorisation (1 for yes,)
% 0 for no
validationFcn = @(x) (x==0 || x==1) && isnumeric(x) && isscalar(x);
addRequired(p, 'resample', validationFcn);

% The resampling interval
validationFcn = @(x) isnumeric(x) && isscalar(x);
addRequired(p, 'sampleInterval', validationFcn);

% Optional output folder name argument, default is empty
addOptional(p, 'outputFolder', [], @(x) ischar(x) || isempty(x));

% Optional argument to update weights according to warped contours, 1 =
% update according to warped, 0 = update normally according to original.
% Default is 0
addOptional(p, 'compareWarped', 0, @(x) (x==0 || x==1) && isnumeric(x) && isscalar(x));

% Parse and validate the input arguments (folder paths given must be to
% folders, file path given must be to a file)
parse(p, varargin{:});

% Get the values of valid input arguments
% (note inputFolder must be converted to char class for usage in
% ARTwarp_Load_Data.m)
inputFolder = char(p.Results.inputFolder);
warpFactorLevel = p.Results.warpFactorLevel;
vigilance = p.Results.vigilance;
bias = p.Results.bias;
learningRate = p.Results.learningRate;
maxNumCategories = p.Results.maxNumCategories;
maxNumIterations = p.Results.maxNumIterations;
resample = p.Results.resample;
sampleInterval = p.Results.sampleInterval;
compareWarped = p.Results.compareWarped;

% If the input folder does not exist, raise an error
if isempty(inputFolder)
    error('No input folder specified');
end

% CREATE A LOCAL JOB id FOR USER TO TRACK LOCAL RUNS WHILE OFFLINE (NOT
% RECOMMENDED FOR USE WHEN ABLE TO CONNECT TO OCEAN)
localJobId = char(java.util.UUID.randomUUID);

% and if no output folder name is specified,
% create the output folder using a name formed from the date and time,
% and first 7 characters of the localJobId, for local tracking of outputs
% from recursive output runs
if isempty(p.Results.outputFolder)
    filename_date = replace(char(datetime), {' ', ':'}, '-');
    outputFolder = ['LOCJOB' localJobId(1:7) 'AT' filename_date];
else
    outputFolder = char(p.Results.outputFolder);
end

if ~exist(outputFolder, 'dir')
% If a folder with this name doesn't exist yet, make a
% new folder with the name specified by outputFolder
        mkdir(outputFolder);
end

% PUT NETWORK PARAMETERS INTO A DICTIONARY
params = dictionary("warpFactorLevel", warpFactorLevel, "vigilance",...
    vigilance, "bias", bias, "learningRate", learningRate,...
    "maxNumCategories", maxNumCategories, "maxNumIterations",...
    maxNumIterations, "resample", resample, "sampleInterval",...
    sampleInterval, "compareWarped", compareWarped);

% LOAD DATA FROM SPECIFIED INPUT FOLDER

ARTwarp_Load_Data(true, inputFolder);


% RUN CATEGORISATION (INCLUDING NEURAL NETWORK AND DYNAMIC TIME WARPING)
% AND SAVE TO SPECIFIED OUTPUT FOLDER

ARTwarp_Run_Categorisation(true, params, outputFolder)

end

