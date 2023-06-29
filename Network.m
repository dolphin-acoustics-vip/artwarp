classdef Network
    % A shallow neural network of categories of contours
    %   Allows classification of a large dataset into a linguistic
    %   repertoire through refinement with training data
    
    properties
        weights
        
    end
    
    methods
        function obj = Network(weights)
            obj.weights = weights;
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

