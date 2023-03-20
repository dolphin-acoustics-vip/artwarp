classdef NetworkFactory
    % Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Static)
        function net = new_network(contours)
            weight = ones(max([contours.length]), 0);
            net = Network(weight);
        end

        function load_network
            % Load a saved network
            %   TODO: no idea how we would store networks
        end
        
    end
end

