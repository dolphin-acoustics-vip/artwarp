classdef Category
    % Represents a category of tonal waveforms.
    %   Contains methods for adding contours and calculating
    %   how much a given contour matches others in this category.
    
    properties
        average  % The average of all contours in the category;
                 % this is what prospective members are compared to
        contours % An array of the contour objects in this category
    end
    
    methods
        function cat = Category(contours)
            % Construct a new category from the given array, which must
            % contain at least one contour
            cat.contours = contours;
            cat.average  = ContourFactory.getAverage(contours);
        end

        function val = compare(contour)
            % Compare a given contour object with the average and return a
            % percentage match value
            % TODO
        end

        function add(contour)
            % Add the given contour to the category and update its average
            % TODO
        end
    end
end

