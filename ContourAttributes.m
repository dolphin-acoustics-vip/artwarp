classdef ContourAttributes
    % A container for the different attributes of a tonal contour.
    %   Contains variables such as starting/ending/highest/lowest
    %   frequencies, length, etc.
    
    properties
        startFrequency {mustBeNumeric}
        endFrequency   {mustBeNumeric}
        minFrequency   {mustBeNumeric}
        maxFrequency   {mustBeNumeric}
        % TODO: add all properties
    end
    
    methods
        function obj = ContourAttributes(freq)
            % Construct an instance from the given frequency array
            % TODO
        end
    end
end

