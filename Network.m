classdef Network
    % A shallow neural network of categories of contours
    %   Allows classification of a large dataset into a linguistic
    %   repertoire through refinement with training data
    
    properties
        categories % Categories within the network
        num_categories % Number of categories in the network
        reclassifications % Number of reclassifications which have occurred
    end
    
    methods
        function obj = add_category(obj, cat)
            obj.categories = [obj.categories, cat];
            obj.num_categories = obj.num_categories + 1;
        end
        
        function matched_category = check(obj, contour)
            % Check where the contour fits into the network
            
            % Assign the number of categories already in the network (this
            % is for optimisation and will allow us to check whether the
            % network is empty
            num_cats = obj.num_categories;

            if num_cats == 0
                matched_category = -1;
            else
                % Create an array to store all the match percentages
                a = zeros(1, num_cats);
                for i = 1:numCats
                    a(i) = obj.categories(i).compare(contour);
                end
    
                % Check that the max percentage is above the vigilance, return
                % zero if it is not
                [max_match, matched_category] = max(a);
    
                if max_match < Parameters.vigilance
                    matched_category = -1;
                end
            end
        end

        function obj = update_network(obj, contour, contour_category)
            % Find the value of the category the contour needs to go into
            matched_category = check(obj, contour);

            if matched_category == -1
                % Add a new category if there are none that it fits into

                new_category = Category.category(contour, 1);
                obj = obj.add_category(new_category);

                % If this contour was already in a category we need to
                % remove it from that category
                if contour_category ~= 0
                    obj.categories(contour_category) = obj.categories(contour_category).remove(contour);
                end

                % Add one to the number of reclassifications
                obj.reclassifications = obj.reclassifications + 1;
            elseif matched_category ~= contour_category
                % Remove from old category
                obj.categories(contour_category) = obj.categories(contour_category).remove(contour);

                % Add to new category
                obj.categories(matched_category) = obj.categories(matched_category).add(contour);

                % Add one to the number of reclassifications
                obj.reclassifications = obj.reclassifications + 1;
            end
        end
    end
end

