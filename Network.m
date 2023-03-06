classdef Network
    % A shallow neural network of categories of contours
    %   Allows classification of a large dataset into a linguistic
    %   repertoire through refinement with training data
    
    properties
        parameters % User-specified parameters
        categories % The list of neurons (categories)
                   % This grows as previously unseen contours are added
    end
    
    methods
        function net = Network(parameters, categories)
            % Construct an empty or populated instance
            %   Categories can be an empty array (if this neural network is
            %   to be trained from scratch), or already contain some
            %   objects (perhaps loaded from a previous training session)
            net.parameters = parameters;
            net.categories = categories;
        end
        
        function add(contour)
            % Add a contour object to the network
            %   Iterates through the current categories and adds the
            %   contour to the one it is most similar to; if it matches
            %   none of them, create a new category for the contour

            % TODO
        end
    end
end

