classdef Contour
    % Represents a single tonal waveform
    % Holds the raw frequency values as well as extrapolated variables

    properties
        frequency % An array of raw frequency values
        tempres % Sample rate of frequency
        length % Length of the current contour
        category % Current category of the contour
        warp_function % Current warp function of the categorised contour
    end

    methods (Static)
        function obj = Contour(frequency, tempres, length, category, warpFunction)
            % Updates the contour with new values
            obj.frequency = frequency; % frequency component of csv
            obj.tempres  = tempres; % tempres component of the csv
            obj.length = length;
            obj.category = category;
            obj.warp_function = warpFunction;
        end
    end
end
