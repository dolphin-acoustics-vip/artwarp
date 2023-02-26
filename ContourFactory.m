classdef ContourFactory
    % A factory to construct contour objects from various sources.
    
    methods (Static)
        function cont = fromCSV(file)
            % Construct a contour from a CSV file.
            % TODO
        end

        function cont = fromCTR(file)
            % Construct a contour from a CTR file.
            % TODO
        end

        function avg = getAverage(contours)
            % Calculate the average contour from the given array, which
            % must be non-empty
        end
    end
end

