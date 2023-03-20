classdef Contour
    % Represents a single tonal waveform
    % Holds the raw frequency values as well as extrapolated variables

    properties
        frequency % An array of raw frequency values
        tempres % Sample rate of frequency
        length
        category
        warpFunction
    end

    methods (Static)
        function obj = Contour(frequency, tempres, length)
            obj.frequency = frequency; % frequency component of csv
            obj.tempres  = tempres; % tempres componenent of the csv
            obj.length = length;
        end
    end
end
