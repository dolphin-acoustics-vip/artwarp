% This class represents an abstraction of a tonal waveform
% Using ContourFactory, a dataset can be read into ARTwarp and turned into
%   these base units (individual contours), which are then used by the
%   neural network.

classdef Contour
    % Represents a single tonal waveform
    % Holds the raw frequency values as well as extrapolated variables

    properties
        frequency % An array of frequency values
        tempres   % Sample rate of frequency
        length    % The number of frequency samples
        category % The category this contour is
            % organised into
        warpFunction % The warp function of the contour, will be used to
            % re-calculate the average after this contour is add or removed
            % from its category
    end

    methods (Static)
        function obj = Contour(frequency, tempres, length)
            % Constructs a new contour object with a given array of
            % frequency values, temporal resolution, and length
            obj.frequency = frequency;
            obj.tempres  = tempres;
            obj.length = length;
        end
    end
end
