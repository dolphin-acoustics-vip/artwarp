classdef Contour
    % Represents a single tonal waveform
    % Holds the raw frequency values as well as extrapolated variables

    properties
        frequencies % An array of raw frequency values
        tempres % Sample rate of frequency
    end

    methods
        function cont = Contour(freq)
            cont.frequencies = freq.frequency; % frequency component of csv
            cont.tempres  = freq.tempres; % tempres componenent of the csv
        end
    end
end
