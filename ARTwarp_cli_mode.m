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

% The maximum number of categories / number of contours
validationFcn = @(x) (x >= 1) && mod(x,1)==0 && isnumeric(x) && isscalar(x);
addRequired(p, 'maxNumCategories', validationFcn);

% The maximum number of iterations
validationFcn = @(x) (x >= 1) && mod(x,1)==0 && isnumeric(x) && isscalar(x);
addRequired(p, 'maxNumIterations', validationFcn);

% --- Optional parameters ---

% The bias, default = 0.000001 (optional)
validationFcn = @(x) (x >= 0) && (x <= 1) && isnumeric(x) && isscalar(x);
addParameter(p, 'bias', 1e-6, validationFcn);

% The learning rate, default = 0.1 (optional)
validationFcn = @(x) (x > 0) && (x <= 1) && isnumeric(x) && isscalar(x);
addParameter(p, 'learningRate', 0.1, validationFcn);

% Whether the contours should be resampled before categorisation (1 for yes,)
% 0 for no
% default is 1 for yes to resample
validationFcn = @(x) (x==0 || x==1) && isnumeric(x) && isscalar(x);
addParameter(p, 'resample', 1, validationFcn);

% The resampling interval, default = 0.01s (10ms)
validationFcn = @(x) isnumeric(x) && isscalar(x);
addParameter(p, 'sampleInterval', 0.01, validationFcn);

% Optional argument to update weights according to warped contours, 1 =
% update according to warped, 0 = update normally according to original.
% Default is 0
addParameter(p, 'compareWarped', 0, @(x) (x==0 || x==1) && isnumeric(x) && isscalar(x));

% Optional argument to try to recategorise single-contour category
% contours at the end of each iteration, 1 = try to recategorise, 0 = do
% not try to recategorise. Default is 0
addParameter(p, 'recatSingleCats', 0, @(x) (x==0 || x==1) && isnumeric(x) && isscalar(x));

% If number of parameters is below expected, 
% print usage, example usage, and end the program
if nargin == 0
    fprintf("\nYou did not specify input parameters. Now you can enter them interactively:\n")
    run('ARTwarp_cli_builder.m')
    return
elseif nargin > 0 && nargin < 5
    fprintf("\nUsage: ARTwarp_cli_mode('<input_folder_name>', <warp_factor>, <vigilance>, <number_of_contours>, <max_num_of_iterations>)\n");
    fprintf("For example: ARTwarp_cli_mode('ctr', 3, 95, 100, 100)\n");
    return
end

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
recatSingleCats = p.Results.recatSingleCats;

% If the input folder does not exist, raise an error
if isempty(inputFolder)
    error('No input folder specified');
end

% Name the output folder based on the input folder, vigilance and warp factor
outputFolder = inputFolder + "_" + string(vigilance) + "_" + string(warpFactorLevel);

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
    sampleInterval, "compareWarped", compareWarped, "recatSingleCats",...
    recatSingleCats);

% Print all parameters so user is aware of the input
fprintf('\n--- INPUT PARAMETERS ---\n');
fprintf('\ninputFolder       : %s\n', inputFolder);
fprintf('warpFactorLevel   : %g\n', warpFactorLevel);
fprintf('vigilance         : %g\n', vigilance);
fprintf('maxNumCategories  : %d\n', maxNumCategories);
fprintf('maxNumIterations  : %d\n', maxNumIterations);
fprintf('bias              : %g\n', bias);
fprintf('learningRate      : %g\n', learningRate);
fprintf('resample          : %g\n', resample);
fprintf('sampleInterval    : %g\n', sampleInterval);
fprintf('compareWarped     : %d\n', compareWarped);
fprintf('recatSingleCats   : %d\n', recatSingleCats);
fprintf('outputFolder      : %s\n', outputFolder);
drawnow; % forces MATLAB to flush output immediately
% LOAD DATA FROM SPECIFIED INPUT FOLDER

ARTwarp_Load_Data(true, inputFolder);


% RUN CATEGORISATION (INCLUDING NEURAL NETWORK AND DYNAMIC TIME WARPING)
% AND SAVE TO SPECIFIED OUTPUT FOLDER

ARTwarp_Run_Categorisation(true, params, outputFolder)

end

