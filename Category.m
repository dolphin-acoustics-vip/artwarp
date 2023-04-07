classdef Category
    % Represents a category of tonal waveforms.
    %   Contains methods for adding contours and calculating
    %   how much a given contour matches others in this category, as well
    %   as updating the category with a new contour or removing the contour
    %   from a category.
    
    properties
        average_cont     % The average of all contours in the category;
                        % this is what new contours are compared to.
        num_conts        % The number of contours which have already been categorised into this category
    end
    
    methods
        function cat = category(average_cont, numConts)
            % Construct a category object. If numConts drops to be below
            % zero, the category will need to be deleted from the network
            % since it no longer contains any contours
            cat.numConts = numConts;
            cat.average_cont  = average_cont;
        end

        function val = compare(contour)
            % Compare a given contour object with the average and return a
            % percentage match value (val)
            % TODO

            % Incorporate the code from ARTwarp_Calculate_Match
        end

        function cat = add(cat, contour)
            % Add the given contour to the category and update its average
            % TODO

            cat.average_cont = average(cat.average_cont, contour);
            cat.num_conts = cat.num_conts + 1;
        end

        function cat = remove(cat, contour)
            % Remove the given contour from a category and update its
            % average
            % TODO

            cat.average_cont = unaverage(cat.average_cont, contour);
            cat.num_conts = cat.num_conts - 1;
            
            % If the number of contours in the category drops to below 1,
            % empty the average contour

            if cat.num_conts == 0
                cat.average_cont = [];
            end
        end

        function new_average = average(old_average, contour)
            % Calculate the average contour for the category with a new
            % contour added (new_average)

            % This will need to take the contour, its warpfunction, and the
            % properties of cat
        end

        function new_average = unaverage(old_average, contour)
            % Calculate the average contour for the category with an old
            % contour removed (new_average)

            % This will need to take the contour, its warpfunction, and the
            % properties of cat
        end
    end
end

