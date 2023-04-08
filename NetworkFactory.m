classdef NetworkFactory
    % A factory to initialise the network to be used within an ARTwarp run.
    %   Detailed explanation goes here
    
    methods (Static)
        function net = new_network(contours)
            % Creates an empty 
            weights = ones(max([contours.length]), 0);
            net = Network(weights);
        end

        function load_network
            % Load a saved network
            %   TODO: no idea how we would store networks
        end
        
    end
end

