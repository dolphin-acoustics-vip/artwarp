classdef Run_Categorisation_Functions %< Run_Categorisation
    %RUN_CATEGORISATION_FUNCTIONS Summary of this class goes here
    %   Detailed explanation goes here

    properties
        CategoryActivation
        ResizedWeight
        Match
        UpdatedWeight
        Input
        warpedInput
        Weight
        Bias
        WarpFactor
        weightVector
        categoryNumber
        LearningRate
        warpfun
    end

    methods (Static)
        function obj = Activate_Categories(obj)
            % Activate_Categories    Activates the categories in an ARTwarp network.
            %    CATEGORYACTIVATION = ART_Activate_Categories(INPUT, WEIGHT, BIAS)
            %    This function returns a structure containing the activation values(biassed 
            %    time-warped distances)for each neuron, as well as the warp functions

            %The arguments passed from ARTwarp_Run_Categorisation.m
                %input = the contour frequency vector of the active contour
                %weight = NET.weight (not sure where 'weight' came from)
                %bias = 'bias' from ParametersGUI

            
%             % Checks the required parameters are inputthe required parameters.
%             if(nargin ~= 3)
%                 error('You must specify the 3 input parameters.');
%             end

            [~, numCategories] = size(obj.Weight);
% 
%             if((bias < 0) || (bias > 1))
%                 error('The bias must be within the range [0, 1].');
%             end

            % Set up the return variable.
            obj.CategoryActivation{1,1} = ones(1, numCategories); %create a matrix that is 1 row x numCategories columns, initialized with ones and returns 1x1 cell array

            % Calculate the activation for each category.
            % This is done according to the following equation:
            % by calculating the time-warped distance
            for j = 1:numCategories
                i = find(obj.Weight(:,j) >0); %find the indices of all non-zero rows of 'weight' where the column is the indexed category
                
                w.inputContour = obj.Input;
                w.WARPFACTOR = obj.WarpFactor;
                w.refContour = obj.Weight(i,j);

                w = Warp.warp(w); %calls the warp function from Warp.m and determines the warp function of two contours (reference contour='weight(i,j)', active contour='input')
                X = w.WARP;

                obj.CategoryActivation{1, 1}(1,j) = X{1,1} *(1-obj.Bias);
                obj.CategoryActivation{2,j}= X{1,2};
            end
        end

        function obj = Add_New_Category(obj)
            % ART_Add_New_Category    Adds a new category to the given weight matrix.
            %    RESIZEDWEIGHT = ART_Add_New_Category(WEIGHT)
            %    This function returns a new weight matrix which is identical to the
            %    given weight matrix except that it contains one more category which
            %    is initialized to all 1's.
            % 
            %    The input parameter is as follows:
            %    The WEIGHT is a matrix of size NumFeatures-by-NumCategories which
            %    holds the weights of the network.
            %
            %    The return parameter is as follows:
            %    The RESIZEDWEIGHT is a matrix of size NumFeatures-by-NumCategories+1
            %    which holds the weights of the old matrix plus a new category of all
            %    values of 1.

            
%             % Make sure that the user specified the weight matrix.
%             if(nargin < 2)
%                 error('You have specified too few parameters.');    
%             elseif(nargin > 2)
%                 error('You have specified too many parameters.');    
%             end

            % Create the return weight matrix with the right dimensions.
            [numFeatures, ~] = size(obj.Weight);
            newCategory = ones(numFeatures, 1).*NaN;
            newCategory(1:length(obj.Input)) = obj.Input;
            obj.ResizedWeight = [obj.Weight, newCategory];
        end

        function obj = Calculate_Match(obj)
            % ART_Calculate_Match    Calculates the match value of an input to a category.
            %    MATCH = ART_Calculate_Match(INPUT, WEIGHTVECTOR)
            %    This function returns a value which represents the amount of match
            %    between the given input and the given category.
            % 
            %    The input parameters are as follows:
            %    The INPUT is a vector of size NumFeatures that contains the input
            %    signal into the network. The WEIGHTVECTOR is a matrix of size 
            %    NumFeatures which holds the weights of the network for a given
            %    category. The length of the INPUT vector must equal the length of
            %    the WEIGHTVECTOR.
            %
            %    The return parameter is as follows:
            %    The MATCH is a measure of the degree of match between the input
            %    and the current category.


            % Initialize the local variables.
            [a, b] = size(obj.warpedInput);
            if a < b
                input = obj.warpedInput';
            end
            [a, b] = size(obj.weightVector);
            if a < b
                weightVector = obj.weightVector';
            end

            numFeatures = length(obj.warpedInput');
            i = find(obj.weightVector'>0);
            

            if numFeatures == 0
                obj.Match = 0;
            else

                % Calculate the match between the given input and weight vector.
                % This is done according to the following equation:
                %       Match = |Input^WeightVector| / |Input|
                x = obj.warpedInput';
                y = obj.weightVector';
                obj.Match = min([x y(i)]')./max([x y(i)]');
                obj.Match = sum(obj.Match)/length(i) * 100;
            end
        end

        function obj = Update_Weights(obj)
            % ART_Update_Weights    Updates the weight matrix of an ART network.
            %    [UPDATEDWEIGHT, WEIGHTCHANGE] = ART_Update_Weights(INPUT, WEIGHT, CATEGORYNUMBER, LEARNINGRATE)
            %    This function returns a new weight matrix that has "learned" the input
            %    in the given category, as well as a value correspoding to whether or 
            %    not the weight matrix was changed (0 = no change; 1 = change).
            % 
            %    The input parameters are as follows:
            %    The INPUT is a vector of size NumFeatures that contains the input
            %    signal into the network. The WEIGHT is a matrix of size 
            %    NumFeatures-by-NumCategories which holds the weights of the network.
            %    The CATEGORYNUMBER is the number of the category that codes the 
            %    current input. The LEARNINGRATE is the rate at which the network 
            %    should learn new inputs. The length of the INPUT vector must equal
            %    the number of rows in the WEIGHT matrix, the CATEGORYNUMBER must
            %    be in the range [1, NumCategories], and the LEARNINGRATE must be
            %    in the range [0, 1].
            %
            %    The return parameters are as follows
            %    The UPDATEDWEIGHT is a matrix of size NumFeatures-by-NumCategories
            %    that holds the new weights of the network after the input has been
            %    successfully learned.
            %    The WEIGHTCHANGE is a value (0 or 1) which relays whether or not
            %    the weight matrix was changed during this updating. Here, 0 represents
            %    no change and 1 represents a change.


            % Find all elements of the weight which are not NaN
            i = find(obj.Weight(:,obj.categoryNumber) >0);
            weightLength = length(i);
            [numFeatures, numCategories] = size(obj.Weight);
            inputLength = length(obj.Input);
            
%             % Check the input parameters for correct ranges.
%             if length(warpfun) ~= weightLength
%                 error('The length of the input and rows of the weights do not match.');
%             end
%             
%             if((categoryNumber < 1) || (categoryNumber > numCategories))
%                 error('The category number must be in the range [1, NumCategories].');
%             end
%             if((learningRate < 0) || (learningRate > 1)
%                 error('The learning rate must be within the range [0, 1].');
%             end

            % UPDATE WEIGHT CONTENT
            newWeight = obj.Weight(i, obj.categoryNumber);
            newWeight = newWeight+obj.LearningRate*(obj.Input(obj.warpfun)-newWeight); % calculates updated weight

            % CALCULATE UPDATED LENGTH AND UNWARPFUNCTION
            newLength = length(newWeight)+round(obj.LearningRate*(inputLength-length(newWeight))); % calculates length change            
            unw = Warp.unwarp(obj.warpfun);
            unwarpfun = unw.unwarpfun;
            
            unwarpfun = interp1(1:length(unwarpfun), unwarpfun, 1:(length(unwarpfun)-1)/(newLength-1):length(unwarpfun));
            unwarpfun = (1:(weightLength-1)/(newLength-1):weightLength)- ((1:(weightLength-1)/(newLength-1):weightLength)- unwarpfun)*learningRate;

            % UPDATE WEIGHT LENGTH AND SHAPE
            newWeight = interp1(1:length(newWeight), newWeight, unwarpfun);
            weight(:, obj.categoryNumber) = zeros(numFeatures,1).*NaN;
            weight(1:newLength, obj.categoryNumber) = newWeight';
            obj.UpdatedWeight = weight;
        end
    end
end