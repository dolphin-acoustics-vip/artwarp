classdef Category
    % Represents a category of tonal waveforms.
    %   Contains methods for adding contours and calculating
    %   how much a given contour matches others in this category.
    
    properties
        reference  % The average of all contours in the category;
                   % this is what prospective members are compared to
        size % The number of contours in this category
    end
    
    methods
        function cat = Category(size, reference)
            % Construct a new category from the given array, which must
            % contain at least one contour
            cat.size = size;
            cat.reference = reference;
        end

        function val = compare(contour)
            % Compare a given contour object with the reference contour and
            % return a percentage match value
            % TODO
        end

        function cat = add(cat, contour)
            % Update the reference contour with the given new contour and
            % increment the size
            cat.reference = cat.average(contour);
            cat.size = cat.size + 1;
        end

        function cat = remove(cat, contour)
            % Update the reference contour to remove the given contour and
            % decrement the size
            cat.reference = cat.unaverage(contour);
            cat.size = cat.size - 1;

            % If the number of contours in the category drops below 1,
            % empty the reference contour
            if cat.size == 0
                cat.reference = [];
            end
        end

        function avg = average(contour)
            % Calculate the reference contour for the category with a new
            % contour added
            % TODO
        end

        function avg = unaverage(contour)
            % Calculate the reference contour for the category with an old
            % contour removed
            % TODO
        end
    end
end

