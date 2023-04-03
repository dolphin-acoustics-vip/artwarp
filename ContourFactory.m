% A factory to import contour objects from a directory containing a dataset
% Ideally, this file should be ignored and only the created Contour objects
%   interacted with.
% Datasets can contain both CSV and CTR files

classdef ContourFactory
    methods (Static)
        function contours_shuffled = load_contours(varargin)
            if length(varargin) == 1
                dir_path = varargin{1};
            else
                dir_path = cd + "/Test_Data"; % temporarily the subdirectory ./Test_Data
            end
            % path = uigetdir('Select the folder containing the contour files') % loads folder
            contours = [ ContourFactory.getCSV(dir_path), ContourFactory.getCTR(dir_path) ];
            shuffled_index = randperm(size(contours, 2));
            contours_shuffled = contours;
            contours_shuffled(1, shuffled_index) = contours(1,:);
        end
        function contours = getCSV(dir_path)
            % Construct a contour from a CSV file.
            files = dir(dir_path + "/*.csv");
            files = {files.name};
            contours = [];
            for i = 1:length(files)
                file_path = fullfile(dir_path, char(files(i)));
                contents = readtable(file_path); % ignore warning, it extracts the headers as identifiers
                frequency = contents.PeakFrequency_Hz_;
                ctrLen = size(frequency, 1);
                tempres = (contents.Time_ms_(ctrLen) - contents.Time_ms_(1)) / ctrLen;
                contours = [contours, Contour(frequency, tempres, ctrLen)]; %#ok<*AGROW> % ignore warning until better solution found
            end
        end

        function contours = getCTR(dir_path)
            % Construct a contour from a CTR file.
            files = dir(dir_path + "/*.ctr");
            files = {files.name};
            contours = [];
            for i = 1:length(files)
                file_path = fullfile(dir_path, char(files(i)));
                contents = load(file_path, "-mat");
                frequency = transpose(contents.freqContour);
                tempres = contents.tempres;
                ctrLen = size(frequency, 1);
                contours = [contours, Contour(frequency, tempres, ctrLen)];
            end
        end
    end
end

