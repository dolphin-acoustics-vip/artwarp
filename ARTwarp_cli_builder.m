function ARTwarp_cli_builder()
% This file creates the CLI command based on the input parameters.

% --- Required inputs (enforced) ---

% Input folder
while true
    % strtrim to ensure there are no leading or trailing spaces.
    inputFolder = strtrim(input('Enter input folder name: ', 's'));
    if ~isempty(inputFolder) && isfolder(inputFolder)
        break;
    end
    fprintf('Invalid input. Please enter a valid folder name.\n');
end

% Warp factor level (>1, integer)
while true
    val = input('Enter warp factor level (1 <= integer <= 3): ');
    if isnumeric(val) && isscalar(val) && val >= 1 && val <= 3 && mod(val,1)==0
        warpFactorLevel = val;
        break;
    end
    fprintf('Invalid input. Must be an integer between 1 and 3 inclusive.\n');
end

% Vigilance (1–99)
while true
    val = input('Enter vigilance (1–99, e.g. 95): ');
    if isnumeric(val) && isscalar(val) && val >= 1 && val <= 99
        vigilance = val;
        break;
    end
    fprintf('Invalid input. Must be between 1 and 99.\n');
end

% Contour number / maximum number of categories (>=1 integer)
while true
    val = input('Enter number of contours / maximum number of categories (>=1): ');
    if isnumeric(val) && isscalar(val) && val >= 1 && mod(val,1)==0
        maxNumCategories = val;
        break;
    end
    fprintf('Invalid input. Must be an integer >= 1.\n');
end

% Max iterations (>=1 integer)
while true
    val = input('Enter max iterations (>=1): ');
    if isnumeric(val) && isscalar(val) && val >= 1 && mod(val,1)==0
        maxNumIterations = val;
        break;
    end
    fprintf('Invalid input. Must be an integer >= 1.\n');
end

% --- Defaults for optional parameters ---
def.bias = 1e-6;
def.learningRate = 0.1;
def.resample = 1;
def.sampleInterval = 0.01;
def.compareWarped = 0;
def.recatSingleCats = 0;
def.outputFolder = '';

fprintf('\n--- Optional parameters (press Enter to use default) ---\n');

% Bias (>0)
while true
    tmp = input(sprintf('Bias (default %g): ', def.bias));
    if isempty(tmp)
        bias = def.bias;
        break;
    elseif isnumeric(tmp) && isscalar(tmp) && tmp >= 0 && tmp <= 1
        bias = tmp;
        break;
    end
    fprintf('Invalid input. Bias must be a positive number.\n');
end

% Learning rate (0 < lr <= 1)
while true
    tmp = input(sprintf('Learning rate (default %g): ', def.learningRate));
    if isempty(tmp)
        learningRate = def.learningRate;
        break;
    elseif isnumeric(tmp) && isscalar(tmp) && tmp > 0 && tmp <= 1
        learningRate = tmp;
        break;
    end
    fprintf('Invalid input. Must be between 0 and 1.\n');
end

% Resample (0 or 1)
while true
    tmp = input(sprintf('Resample? 1=yes, 0=no (default %d): ', def.resample));
    if isempty(tmp)
        resample = def.resample;
        break;
    elseif isnumeric(tmp) && isscalar(tmp) && (tmp == 0 || tmp == 1)
        resample = tmp;
        break;
    end
    fprintf('Invalid input. Must be 0 or 1.\n');
end

% Sample interval (>0)
while true
    tmp = input(sprintf('Sample interval (default %g seconds): ', def.sampleInterval));
    if isempty(tmp)
        sampleInterval = def.sampleInterval;
        break;
    elseif isnumeric(tmp) && isscalar(tmp) && tmp > 0
        sampleInterval = tmp;
        break;
    end
    fprintf('Invalid input. Must be a positive number.\n');
end

% compareWarped (0 or 1), default 0
while true
    tmp = input(sprintf('compareWarped? 1=yes, 0=no (default %d): ', def.compareWarped));
    if isempty(tmp)
        compareWarped = def.compareWarped;
        break;
    elseif isnumeric(tmp) && isscalar(tmp) && (tmp == 0 || tmp == 1)
        compareWarped = tmp;
        break;
    end
    fprintf('Invalid input. Must be 0 or 1.\n');
end

% recatSingleCats (0 or 1), default 0
while true
    tmp = input(sprintf('recatSingleCats? 1=yes, 0=no (default %d): ', def.recatSingleCats));
    if isempty(tmp)
        recatSingleCats = def.recatSingleCats;
        break;
    elseif isnumeric(tmp) && isscalar(tmp) && (tmp == 0 || tmp == 1)
        recatSingleCats = tmp;
        break;
    end
    fprintf('Invalid input. Must be 0 or 1.\n');
end

% Output folder name
% strtrim to ensure there are no leading or trailing spaces.
tmp = strtrim(input('Enter output folder name (optional): ', 's'));
if isempty(tmp)
    outputFolder = def.outputFolder;
else
    outputFolder = tmp;
end

% Build command string to run the CLI
cmd = sprintf("ARTwarp_cli_mode('%s', %d, %d, %d, %d", ...
    inputFolder, warpFactorLevel, vigilance, maxNumCategories, maxNumIterations);

% Only include optional paramameters if they are different from the defaults
if bias ~= def.bias
    cmd = sprintf('%s, ''bias'', %g', cmd, bias);
end

if learningRate ~= def.learningRate
    cmd = sprintf('%s, ''learningRate'', %g', cmd, learningRate);
end

if resample ~= def.resample
    cmd = sprintf('%s, ''resample'', %d', cmd, resample);
end

if sampleInterval ~= def.sampleInterval
    cmd = sprintf('%s, ''sampleInterval'', %g', cmd, sampleInterval);
end

if compareWarped ~= def.compareWarped
    cmd = sprintf('%s, ''compareWarped'', %g', cmd, compareWarped);
end

if recatSingleCats ~= def.recatSingleCats
    cmd = sprintf('%s, ''recatSingleCats'', %g', cmd, recatSingleCats);
end

if ~strcmp(outputFolder, def.outputFolder)
    cmd = sprintf('%s, ''outputFolder'', ''%s''', cmd, outputFolder);
end

cmd = sprintf('%s)', cmd);

% Print the CLI command
fprintf('\nGenerated command:\n%s\n', cmd);

% Ask to run CLI mode directly
while true
    proceed = strtrim(input('\nDo you want to proceed? (y/n) ', 's'));
    if lower(proceed) == 'y'
        eval(cmd)
        break;
    elseif lower(proceed) == 'n'
        break;
    end
    fprintf('Invalid input. Must be between y or n.\n');
end