classdef NetworkFactory
    % Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Static)
        function net = loadNetwork(params, file)
            % Load a saved network
            %   TODO: no idea how we would store networks
            net = Network(params, []); % array with loaded categories
        end
        
        function net = newNetwork(params)
            % Return an empty network for training
            %   This network starts off with an empty array of categories
            net = Network(params, []);
        end
    end
end

