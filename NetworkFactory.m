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

        function net = run_categorisation(network, contours)
            % This will run the network and contours until they have been
             % correctly categorised

            network.reclassifications = 0;
            iteration_number = 1;

            while(a == 0 && iteration_number < Parameters.maxNumIterations)
                % Set the number of reclassifications for the iteration to
                % zero
                network.reclassifications = 0;

                % Run through this iteration
                for i = 1:length(contours)
                    network = network.update_network(network, contours(i));
                end

                % Increment iteration number
                iteration_number = iteration_number + 1;

                % Break out of loop if no reclassifications done
                if network.reclassifications == 0
                    a = 1;
                end
            end

            net = network;
        end
        
    end
end

