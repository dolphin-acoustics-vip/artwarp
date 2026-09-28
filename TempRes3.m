function TempRes3(is_cli_mode, freqCol, tempres, folder_name, output_folder)

% Procedure to convert frequency-time formatted .csv files to .ctrs for
% categorisation by ARTwarp
%
% INPUTS
% - is_cli_mode (1x1 boolean): boolean flag indicating whether to bypass
% collecting parameters through the GUI. If is_cli_mode = false, the
% program will promt the user to enter values for freqCol, tempres,
% input_folder and output_folder
% - freqCol (1x1 double): the column containing the frequency values in the
% csv file. Should be 1 for pulse trains and 2 for whistles from ROCCA
% - tempres (1x1 double): the temporal resolution of the audio sample
% (time between consecutive frequency values being recorded, in seconds)
% - input_folder (char): the path to the folder containing the .csv files to
% convert
% - output_folder (char): the path to the folder where the created .ctr are
%
% OUTPUTS
% None.

% LEGACY CODE FOR MANUALLY EDITING freqCol AND tempres
%freqCol = 1; %should be 1 for pulse trains and 2 for whistles from ROCCA

%tempres=0.011 %Modify it according to the files - This is the value I used for the Valencia analysis
%tempres=0.012 %Modify it according to the files - This is the value I used for the Southall delphinus analysis
%tempres=0.010 %Modify it according to the files - This is the value I used for Units/whistles

%folder_name = uigetdir(); %Code for selecting the folder
%if (~folder_name); return; end

% No output folder given set as empty
if nargin < 5
    output_folder = '';
end

% If not running in CLI mode, get values for folder_name, freqCol,
% tempres and output_folder from the uicontrol objects
if ~is_cli_mode
    h = findobj('Tag', 'conversion_parameter_GUI');
    folder_name = getappdata(h, 'input_folder');

    h = findobj('Tag', 'output_folder');
    output_folder = get(h, 'String');

    h = findobj('Tag', 'freqCol');
    freqCol = str2num(get(h, 'String'));

    h = findobj('Tag', 'tempres');
    tempres = str2num(get(h, 'String'));

end

% Default output folder to input one
if isempty(output_folder)
    output_folder = folder_name;
end

% Validate folder_name
if ~isfolder(folder_name)
    error('The specified folder does not exist. Invalid Input');
end

% Validate freqCol
if isnan(freqCol) || mod(freqCol,1) ~= 0 || freqCol <= 0
    error('freqCol must be a positive integer. Invalid Input');
end

% Validate tempres
if isnan(tempres) || tempres <= 0
   error('tempres must be a real number greater than 0. Invalid Input');
end

% Create output folder if one doesnt exist
if ~isfolder(output_folder)
    mkdir(output_folder)
end

% if not running in cli mode, close the 'conversion_parameter_GUI' window
if ~is_cli_mode
    h = findobj('Tag','conversion_parameter_GUI');
    close(h)
end

% CONVERT .csv FILES TO .ctr and save to output_folder
% loop through the .csv files in the folder
fileList = dir(fullfile(folder_name, '*.csv'));
if isempty(fileList)
    error('No .csv files found in the selected folder.');
end
if ~is_cli_mode
    waitbr = waitbar(0, 'Converting csv to ctr...');
    cleanupWb = onCleanup(@() delete(findall(0, 'Tag', 'TMWWaitbar')));
end

for i=1:length(fileList) 
    curFile = fileList(i).name;
    try 
        allCols = csvread(fullfile(folder_name,curFile),1,0); %use for whistle contour files
    catch
        warning("TempRes3:invalidCSV","%s is an invalid csv, please check", fullfile(folder_name,curFile))
        continue;
    end
    freqContour=allCols(:,freqCol)';
%    Ia(i)= ([fileList([2,i]), i]); %To select the second column of fileList i.e. the csv files in the folder for i rows????
%    fcontour=Ia(2,i)'; % Define fcontour as the second column of the csv files 
%    filename=sprintf('Ia%d.ctr', i); % Save new files as .ctr files
    [~,name] = fileparts(curFile);
    filename = fullfile(output_folder,[name '.ctr']);
    ctrlength=length(freqContour)*tempres;% this calculates the duration of each contour 
    save(filename,'freqContour','tempres','ctrlength')
    if ~is_cli_mode
        waitbar(i/length(fileList),waitbr, sprintf('File %d of %d converted...', i, length(fileList)));
    end
end
fprintf('Converted .ctr files succesfully saved to: %s\n', output_folder);
if ~is_cli_mode
    close(waitbr)
end