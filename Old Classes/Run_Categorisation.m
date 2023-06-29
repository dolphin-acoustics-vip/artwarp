classdef Run_Categorisation
    %RUN_CATEGORISATION Summary of this class goes here
    %   Detailed explanation goes here

    properties
        bias {mustBeNumeric} = 1.0000e-06
        learningRate {mustBeNumeric} = 0.1000            
        maxNumCategories {mustBeNumeric} = 56               
        maxNumIterations {mustBeNumeric} = 100
        resample {mustBeNumeric} = 0
        sampleInterval {mustBeNumeric} = 0.0100
        vigilance {mustBeNumeric} = 90
        warpFactor {mustBeNumeric} = 3
        NET
        DATA
        numSamples
    end

    methods (Static)

        function obj = AssignParameters(inputParameters)
            obj.bias = inputParameters.bias;
            obj.learningRate = inputParameters.learningRate;
            obj.maxNumCategories = inputParameters.maxNumCategories;
            obj.maxNumIterations = inputParameters.maxNumIterations;
            obj.resample = inputParameters.resample;
            obj.sampleInterval = inputParameters.sampleInterval;
            obj.vigilance = inputParameters.vigilance;
            obj.warpFactor = inputParameters.warpFactor;
        end

        function obj = Run_Categorisation()

            a = Load_Data.Find_Path('/*csv');
            b = Load_Data.Data_Loader(a.fileType, a.path);
            obj.DATA = b.DATA;
            obj.numSamples = b.numsamples;

            if obj.resample == 1
                for c1 = 1:obj.numSamples
                    obj.DATA(c1).contour = interp1(1:length(obj.DATA(c1).contour), obj.DATA(c1).contour, 1:obj.sampleInterval/obj.DATA(c1).tempres:length(obj.DATA(c1).contour));
                    obj.DATA(c1).length = length(obj.DATA(c1).contour);
                end
            end


            % INITIALIZING NETWORK
            lengths = round([obj.DATA.length]./4); %not sure why this is divided by 4
            n = round(mean(lengths));
            p = max([obj.DATA.length]); %maximum number of data points of all contours

%These variables were not used anywhere
%             mx = max([obj.DATA.contour]); %maximum frequency value of all contours
%             mn = min([obj.DATA.contour]); %minimum frequency value of all contours


            Xmax = n; %will be used to set maximum value of X-axis (time) of contour graph
            contourMean = zeros(1, b.numsamples);
            for i = 1:b.numsamples
                contourMean(i) = mean(b.DATA(i).contour);
            end
            Ymax = mean(contourMean); % will be used to set maximum value of Y-axis (frequency) on contour graph
            % Create and initialize the weight matrix.
            weight = ones(p, 0); %create an empty matrix 'weight' with p rows (max of DATA.length/equal to # of points of longest contour)

            % Create the structure and return.
            obj.NET = struct('numFeatures', {p}, 'numCategories', {0}, 'maxNumCategories', {obj.maxNumCategories}, 'weight', {weight}, ...
                'vigilance', {obj.vigilance}, 'bias', {obj.bias}, 'maxNumIterations', {obj.maxNumIterations}, 'learningRate', {obj.learningRate});

            % TRAINING
            [~, sortedRandom] = sort(randn(obj.numSamples, 1)); %randomize the list of contours
            % Go through the data once for every iteration.
            for iterationNumber = 1:obj.NET.maxNumIterations
                
                % This variable will allow us to see whether new categories were
                % added during the current iteration.
                % Initialize the number of added categories to 0.
                numChanges = 0; 
                % Classify and learn on each sample.
                for indexNumber = 1:obj.numSamples
                    sampleNumber = sortedRandom(indexNumber); 
                    % Get the current data sample, stepping through the randomized list in order.
                    currentData = obj.DATA(sampleNumber).contour'; %contour vector of the active contour
                    currentLength = length(currentData); %length of this contour
                    currentName = obj.DATA(sampleNumber).name; %name of this contour
                    oldCategory = obj.DATA(sampleNumber).category; %name of the category it is currently assigned to prior to comparison (initialized at 0)
        
                    % Activate the categories for this sample.
                    % This is equivalent to bottom-up processing in ART.
                    a = Run_Categorisation_Functions;
                    a.Input = currentData;
                    a.Weight = obj.NET.weight;
                    a.Bias = obj.bias;
                    a.WarpFactor = obj.warpFactor;
                    a = a.Activate_Categories(a); %currentData in this function is the contour vector of the active contour (input)
                    categoryActivation = a.CategoryActivation;

                    % Rank the activations in order from highest to lowest.
                    % This will allow us easier access to step through the categories.
                    [~, sortedCategories] = sort(-categoryActivation{1,1});
        
                    % Go through each category in the sorted list looking for the best match.
                    % This is equivalent to bottom-up--top-down processing in ART.
                    resonance = 0;
                    maxMatch = 0;
                    numSortedCategories = length(sortedCategories);
                    currentSortedIndex = 1;
                    while(~resonance) %the ~resonance here means that if resonance is changed from zero the loop will not repeat
            
                        % If there are no categories yet, we must create one.
                        if numSortedCategories == 0
                            
                            
                            a = a.Add_New_Category(a);
                            resizedWeight = a.ResizedWeight;

                            obj.NET.weight = resizedWeight;
                            obj.NET.numCategories = obj.NET.numCategories + 1;
                            obj.DATA(sampleNumber).category = 1;
                            Xmax = max([Xmax currentLength]);
                            Ymax = max([Ymax max(currentData)]);
                            resonance = 1; %#ok<NASGU> 
                            break;
                        end
            
                        % Get the current category based on the sorted index.
                        currentCategory = sortedCategories(currentSortedIndex);
            
                        % Get the current weight vector from the sorted category list.
                        currentWeightVector = obj.NET.weight(:, currentCategory);
                        warpFunction = categoryActivation{2, currentCategory};
            
                        % Calculate the match given the current data sample and weight vector.
                        a.warpedInput = currentData(warpFunction);
                        a.weightVector = currentWeightVector;
                        a = a.Calculate_Match(a);
                        match = a.Match;

                        obj.DATA(sampleNumber).match = match;
                        if match > maxMatch
                            maxMatch = match;
                        end
            
                        % Check to see if the match is better than the vigilance.
                        if match > obj.NET.vigilance
                            % If so, the current category should code the input.
                            % Therefore, we should update the weights and induce resonance.
                            % warpFunction = round(mean([warpFunction; 1:(warpFunction(end)-1)/(length(warpFunction)-1):warpFunction(end)]));
                            
                            a.categoryNumber = currentCategory;
                            a.LearningRate = obj.NET.learningRate;
                            a.warpfun = warpFunction;
                            a = a.Update_Weights(a);
                            obj.NET.weight = a.UpdatedWeight;

                            obj.DATA(sampleNumber).category = currentCategory;
                            Xmax = max([Xmax length(find(obj.NET.weight(:, currentCategory)>0))]);
                            Ymax = max([Ymax max(obj.NET.weight(:, currentCategory))]);
                            resonance = 1;
                        else
                            % Otherwise, choose the next category in the sorted category list.
                            % If the current category is the last in the list, make sure that
                            % the maximum number of categories has not been reached. If so,
                            % assign the input a category of []. If the maximum has not been
                            % reached, create a new category for the input, update the weights,
                            % and induce resonance.
                            if(currentSortedIndex == numSortedCategories)
                                if(currentSortedIndex == obj.NET.maxNumCategories)
                                    obj.DATA(sampleNumber).category = NaN;
                                    resonance = 1;
                                else
                                    a = a.Add_New_Category(a);
                                    resizedWeight = a.ResizedWeight;
                                    obj.NET.weight = resizedWeight;
                                    obj.NET.numCategories = obj.NET.numCategories + 1;
                                    obj.DATA(sampleNumber).category = currentSortedIndex + 1; 
                                    Xmax = max([Xmax currentLength]);
                                    Ymax = max([Ymax max(currentData)]);
                                    resonance = 1;
                                end
                            else
                                currentSortedIndex = currentSortedIndex + 1;
                            end
                        end
                    end
                    % Test whether the current input was reclassified during the current iteration
                    if oldCategory ~= obj.DATA(sampleNumber).category
                        numChanges = numChanges+1;
                    end



                    % Graphic output
%                     delete(findobj('Tag', 'P0'));
%                     h0 = findobj('Tag', '0');
%                     set(h0, 'XLim', [0 Xmax], 'YLim', [0 Ymax]);
%                     h1 = line('Parent', h0, 'Color','r', 'Tag', 'P0', 'XData', 1:currentLength, 'YData', currentData);
%                     h1 = findobj('Tag', 'T0');
%                     set(h1, 'String', currentName, 'Color', 'r');
%                     h1 = findobj('Tag', 'Match');
%                     set(h1, 'String', sprintf('%2.0f%%', maxMatch));
%                     h1 = findobj('Tag', 'Iteration');
%                     set(h1, 'String', sprintf('%2.0f', iterationNumber));
%                     h1 = findobj('Tag', 'Input');
%                     set(h1, 'String', sprintf('%2.0f of %2.0f', indexNumber, numSamples));
%                     h1 = findobj('Tag', 'Reclassifications');
%                     set(h1, 'String', sprintf('%2.0f', numChanges))



%                     for counter3 = 1:obj.NET.numCategories
%                         delete(findobj('Tag', ['P' num2str(counter3)]));
%                         h0 = findobj('Tag', num2str(counter3));
%                         set(h0, 'Tag', num2str(counter3), 'Visible', 'on', 'XLim', [0 Xmax], 'YLim', [0 Ymax]);
%                         h1 = line('Parent', h0, 'Color','k', 'Tag', ['P' num2str(counter3)], 'XData', 1:p, 'YData', NET.weight(:,counter3));
%                         h1 = findobj('Tag', ['T' num2str(counter3)]);
%                         set(h1, 'Color', 'k', 'Visible', 'on');
%                     end
%                     h1 = findobj('Tag', ['P' num2str(DATA(sampleNumber).category)]);
%                     set(h1, 'Color', 'r');
%                     h1 = findobj('Tag', ['T' num2str(DATA(sampleNumber).category)]);
%                     set(h1, 'Color', 'r');
%                     drawnow



                    %print statements added by JNO 23/02/2018
                    fprintf('Iteration %d\n', iterationNumber)
                    fprintf('Whistle %2.0f\n', indexNumber);
                    fprintf('Number of whistles reclassified %2.0f\n', numChanges);
                    %print statements below added by WF 15/05/2022
                    fprintf('Contour Name: %s\n', currentName);
        
                end
                % If no new categories were added, and no inputs were reclassified in the current iteration
                % then we've reached equilibrium. Thus, we can stop training.
                if numChanges == 0
                    break;
                end  
                %%added save info into this loop so that data is saved after every
                %%iteration (JNO 23/02/2018) 
                %added iteration number to the name so that a new mat file is saved
                %after every iteration, not overwritten. Also changed 'eval' to 'save'. (WF 9/25/22)
                %fprintf('Finished iteration number %d\n', iterationNumber)
                %fprintf('Number of whistles reclassified %2.0f\n', numChanges);
                formatSpec = 'ARTwarp%02.0fit%03.0f'; 
                name = sprintf(formatSpec, obj.NET.vigilance, iterationNumber);
                save(name);
            end
            fprintf('The number of iterations needed was %d\n', iterationNumber);
            formatSpec = 'ARTwarp%02.0fFINAL';
            endname = sprintf(formatSpec, obj.NET.vigilance);
            save(endname);
        end
    end
end