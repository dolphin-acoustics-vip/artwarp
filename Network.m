classdef Network
    % A shallow neural network of categories of contours
    %   Allows classification of a large dataset into a linguistic
    %   repertoire through refinement with training data
    
    properties
        weights
        categories % Categories within the network
        num_categories % Number of categories in the network
        reclassifications % Number of reclassifications which have occurred
    end
    
    methods
        function obj = Network(weights)
            obj.weights = weights;
            obj.num_categories = 0;
            obj.categories = [];
        end

        function obj = update_network(obj, contour, parameters)
            % Add a contour object to the network
            %   Iterates through the current categories and adds the
            %   contour to the one it is most similar to; if it matches
            %   none of them, create a new category for the contour
            
            matched_category = find_category(obj, contour, parameters);

            % If there is no category the contour fits into, create a new
            % one, with the contour as the reference for it.
            if matched_category == -1
                new_category = Category.category(1, contour);
                obj = obj.add_category(new_category);

                % Reassign category of contour
                contour.category = new_category;

                % If the contour was already in a category, remove it
                if(contour.category) ~= 0
                    obj.categories(contour.category) = obj.categories(contour.category).remove(contour.category, contour);
                end
                
                % Increment number of reclassifications
                obj.reclassifications = obj.reclassifications + 1;
            elseif matched_category ~= contour.category
                % Remove from old category
                obj.categories(contour.category) = obj.categories(contour.category).remove(contour.category, contour);

                % Add to new category
                obj.categories(matched_category) = obj.categories(matched_category).add(contour.category, contour);

                % Alter category property of contour
                contour.category = matched_category;

                % Increment number of reclassifications
                obj.reclassifications = obj.reclassifications + 1;
            end
            
        end

        function matched_category = find_category(obj, contour, parameters)
            % Find the category the new contour fits into

            % If there are no categories, a new one must be created
            if obj.num_categories == 0
                matched_category = -1;
            else
                % Create array for storing matches
                a = zeros(1, obj.num_categories);
                for i = 1:obj.num_categories
                    a(i) = obj.categories(i).compare(contour);
                end

                % Find max match percentage and see if it is above
                % vigilance, return 0 if not
                [max_match, matched_category] = max(a);

                if max_match < parameters.vigilance
                    matched_category = -1;
                end
            end
        end

        function obj = add_category(obj,cat)
            obj.categories = [obj.categories, cat];
            obj.num_categories = obj.num_categories + 1;
        end
    end
end

