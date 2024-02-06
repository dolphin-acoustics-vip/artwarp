classdef NetworkFactory
    % Summary of this class goes here
    %   Detailed explanation goes here
    
    methods (Static)
        function net = new_network()
            % Things to be stored in a Network:
            %       The weights (average contours)
            %       The list of indices of contours within a category
            %       The length of the list of contours (for averaging
            %       purposes)
            net = Network();
        end


        function load_network
            % Load a saved network
            %   This will need to include:
            %           Weights of each category 
            %           Number of whistles that were previously contained
            %           in a category
        end

        function net = run_categorisation(network, contours)
            % This will run the network and contours until they have been
            % correctly categorised

            % Create the condition for the program to keep running until no
            % contours are reclassified or until the max number of
            % iterations have been reached
            network.reclassifications = 0;
            iteration_number = 1;

            % Begin iterations
            while (a == 0 && iteration_number < maxIterations)

                % Set the number of reclassifications for the iteration to
                % zero
                network.reclassifications = 0;

                % Run through this iteration
                for i = 1:length(contours)
                    network = network.update_network(contours(i).frequency, contours(i).category);
                    % Find some way to make this update the category number
                    % and warp function of the contour
                end

                % Increase the iteration number
                iteration_number = iteration_number + 1;

                % Break the loop if there are no reclassifications
                if network.reclassifications == 0
                    a = 1;
                end

                % Assign back to object to allow for checkpointing
                net = network;
            end
        end        
    end
end

