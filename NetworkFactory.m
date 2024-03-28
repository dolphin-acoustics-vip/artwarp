classdef NetworkFactory
    % A factory to initialise the network to be used within an ARTwarp run.
    %   Detailed explanation goes here
    
    methods (Static)
        function net = new_network(contours)
            % Creates an empty network
            weights = ones(max([contours.length]), 0);
            net = Network(weights);
        end

        function load_network
            % Load a saved network
            %   TODO: no idea how we would store networks
        end

        function net = run_categorisation(network, contours, parameters)
            % This will run the network until all contours have been
             % categorised and an iteration has completed with no reclassifications

            % NOTE: contour list should be randomised before entered into this function

            network.reclassifications = 0;
            iteration_number = 1;
            a = 0;

            while(a == 0 && iteration_number < parameters.maxNumIterations)
                % Set the number of reclassifications for the iteration to
                % zero
                network.reclassifications = 0;

                % Run through this iteration, updating the network with each contour in the list
                for i = 1:length(contours)
                    network = network.update_network(contours(i), parameters);
                end

                % Increment iteration number
                iteration_number = iteration_number + 1;

                % Break out of loop if no reclassifications done (categorisation complete)
                if network.reclassifications == 0
                    a = 1;
                end
            end

            % assign net as completed network
            net = network;
        end
        
    end
end

