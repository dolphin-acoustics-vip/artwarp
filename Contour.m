classdef Contour
    % Represents a single tonal waveform
    % Holds the raw frequency values as well as extrapolated variables

    properties
        frequencies % An array of raw frequency values
        attributes  % A ContourAttributes instance
    end

    methods
        function cont = Contour(freq)
            % Construct a contour instance from the given frequency array
            cont.frequencies = freq;
            cont.attributes  = ContourAttributes(freq);
        end
    end
end