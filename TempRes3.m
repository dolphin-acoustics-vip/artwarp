function TempRes3(is_cli_mode, freqCol, tempres, folder_name)

% Procedure to convert frequency-time formatted .csv files to .ctrs for
% categorisation by ARTwarp
%
% INPUTS
% - is_cli_mode (1x1 boolean): boolean flag indicating whether to bypass
% collecting parameters through the GUI. If is_cli_mode = false, the
% program will promt the user to enter values for freqCol, tempres, and
% folder_name
% - freqCol (1x1 double): the column containing the frequency values in the
% csv file. Should be 1 for pulse trains and 2 for whistles from ROCCA
% - tempres (1x1 double): the temporal resolution of the audio sample
% (time between consecutive frequency values being recorded, in seconds)
% - folder_name (char): the path to the folder containing the .csv files to
% convert
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

% If not running in CLI mode, get values for folder_name, freqCol and
% tempres from the uicontrol objects
if ~is_cli_mode

    h = findobj('Tag', 'folder_name');
    folder_name = get(h, 'String');

    h = findobj('Tag', 'freqCol');
    freqCol = str2num(get(h, 'String'));

    h = findobj('Tag', 'tempres');
    tempres = str2num(get(h, 'String'));

end

% Validate folder_name
if ~isfolder(folder_name)
    errordlg('The specified folder does not exist.', 'Invalid Input');
    return;
end

% Validate freqCol
if isnan(freqCol) || mod(freqCol,1) ~= 0 || freqCol <= 0
    errordlg('freqCol must be a positive integer.', 'Invalid Input');
    return;
end

% Validate tempres
if isnan(tempres) || tempres <= 0
   errordlg('tempres must be a real number greater than 0.', 'Invalid Input');
   return;
end

% if not running in cli mode, close the 'conversion_parameter_GUI' window
if ~is_cli_mode
    h = findobj('Tag','conversion_parameter_GUI');
    close(h)
end

% NAVIGATE TO FOLDER
cd (folder_name);


% CONVERT .csv FILES TO .ctr AND SAVE TO THE SAME FOLDER
% loop through the .csv files in the folder
fileList = dir([folder_name '//*.csv']);

for i=1:length(fileList) 
    curFile = fileList(i).name;
    curFile
    allCols = csvread(curFile,1,0); %use for whistle contour files
    freqContour=allCols(:,freqCol)';
%    Ia(i)= ([fileList([2,i]), i]); %To select the second column of fileList i.e. the csv files in the folder for i rows????
%    fcontour=Ia(2,i)'; % Define fcontour as the second column of the csv files 
%    filename=sprintf('Ia%d.ctr', i); % Save new files as .ctr files
    [filepath,name,ext] = fileparts(curFile);
    filename = fullfile(filepath,[name '.ctr']);
    ctrlength=length(freqContour)*tempres;% this calculates the duration of each contour 
    save(filename,'freqContour','tempres','ctrlength')

end

% Output success message
fprintf('Converted .ctr files succesfully saved to: %s\n', folder_name)