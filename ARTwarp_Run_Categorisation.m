function ARTwarp_Run_Categorisation

global NET DATA numSamples warpFactorLevel vigilance bias learningRate maxNumCategories maxNumIterations sampleInterval resample

% OBTAINING NETWORK PARAMETERS
% loading all the variables that were set in 'ARTwarp_Get_Parameters'

h = findobj('Tag', 'warpFactorLevel');
warpFactorLevel = str2num(get(h, 'String'))

h = findobj('Tag', 'vigilance');
vigilance = str2num(get(h, 'String'));

h = findobj('Tag', 'bias');
bias = str2num(get(h, 'String'));

h = findobj('Tag', 'learningRate');
learningRate = str2num(get(h, 'String'));

h = findobj('Tag', 'maxNumCategories');
maxNumCategories = round(str2num(get(h, 'String')));

h = findobj('Tag', 'maxNumIterations');
maxNumIterations = round(str2num(get(h, 'String')));

h = findobj('Tag', 'resample');
resample = get(h, 'Value');

% resample frequency contours to new sampling interval if 'resample' is
% selected
if resample == 1
    h = findobj('Tag', 'sampleInterval');
    sampleInterval = str2num(get(h, 'String'))/1000;
    for c1 = 1:numSamples
        DATA(c1).contour = interp1(1:length(DATA(c1).contour), DATA(c1).contour, 1:sampleInterval/DATA(c1).tempres:length(DATA(c1).contour));
        DATA(c1).length = length(DATA(c1).contour);
    end
end

% close the 'parametersGUI' window
h = findobj('Tag','parameterGUI');
close(h)


% INITIALIZING NETWORK
lengths = round([DATA.length]./4); %not sure why this is divided by 4
n = round(mean(lengths));
p = max([DATA.length]); %maximum number of data points of all contours
mx = max([DATA.contour]); %maximum frequency value of all contours
mn = min([DATA.contour]); %minimum frequency value of all contours
Xmax = n; %will be used to set maximum value of X-axis (time) of contour graph
Ymax = mean([DATA.contour]); % will be used to set maximum value of Y-axis (frequency) on contour graph
% Create and initialize the weight matrix.
weight = ones(p, 0); %create an empty matrix 'weight' with p rows (max of DATA.length/equal to # of points of longest contour)

% Create the structure and return.
NET = struct('numFeatures', {p}, 'numCategories', {0}, 'maxNumCategories', {maxNumCategories}, 'weight', {weight}, ...
    'vigilance', {vigilance}, 'bias', {bias}, 'maxNumIterations', {maxNumIterations}, 'learningRate', {learningRate});

% GENERATING THE GRAPHIC DISPLAY
ARTwarp_Create_Figure

% TRAINING
[x, sortedRandom] = sort(randn(numSamples, 1)); %randomize the list of contours
% Go through the data once for every iteration.
for iterationNumber = 1:NET.maxNumIterations
    
    % This variable will allow us to see whether new categories were
    % added during the current iteration.
    % Initialize the number of added categories to 0.
    numChanges = 0; 
    % Classify and learn on each sample.
    for indexNumber = 1:numSamples
        sampleNumber =sortedRandom(indexNumber); 
        % Get the current data sample, stepping through the randomized list in order.
        currentData = DATA(sampleNumber).contour'; %contour vector of the active contour
        currentLength = length(currentData); %length of this contour
        currentName = DATA(sampleNumber).name; %name of this contour
        oldCategory = DATA(sampleNumber).category; %name of the category it is currently assigned to prior to comparison (initialized at 0)
        
        % Activate the categories for this sample.
        % This is equivalent to bottom-up processing in ART.
        bias = NET.bias;
        categoryActivation = ARTwarp_Activate_Categories(currentData, NET.weight, bias); %currentData in this function is the contour vector of the active contour (input)
        
        % Rank the activations in order from highest to lowest.
        % This will allow us easier access to step through the categories.
        [sortedActivations, sortedCategories] = sort(-categoryActivation{1,1});
        
        % Go through each category in the sorted list looking for the best match.
        % This is equivalent to bottom-up--top-down processing in ART.
        resonance = 0;
        match = 0;
        maxMatch = 0;
        numSortedCategories = length(sortedCategories);
        currentSortedIndex = 1;
        while(~resonance)
            
            % If there are no categories yet, we must create one.
            if(numSortedCategories == 0)
                resizedWeight = ARTwarp_Add_New_Category(NET.weight, currentData);
                NET.weight = resizedWeight;
                NET.numCategories = NET.numCategories + 1;
                DATA(sampleNumber).category = 1;
                Xmax = max([Xmax currentLength]);
                Ymax = max([Ymax max(currentData)]);
                resonance = 1;
                break;
            end
            
            % Get the current category based on the sorted index.
            currentCategory = sortedCategories(currentSortedIndex);
            
            % Get the current weight vector from the sorted category list.
            currentWeightVector = NET.weight(:, currentCategory);
            warpFunction = categoryActivation{2, currentCategory};
            
            % Calculate the match given the current data sample and weight vector.
            match = ARTwarp_Calculate_Match(currentData(warpFunction), currentWeightVector);
            DATA(sampleNumber).match = match;
            if match > maxMatch
                maxMatch = match;
            end
            
            % Check to see if the match is better than the vigilance.
            if match > NET.vigilance
                % If so, the current category should code the input.
                % Therefore, we should update the weights and induce resonance.
                % warpFunction = round(mean([warpFunction; 1:(warpFunction(end)-1)/(length(warpFunction)-1):warpFunction(end)]));
                NET.weight = ARTwarp_Update_Weights(currentData, NET.weight, currentCategory, NET.learningRate, warpFunction);
                DATA(sampleNumber).category = currentCategory;
                Xmax = max([Xmax length(find(NET.weight(:, currentCategory)>0))]);
                Ymax = max([Ymax max(NET.weight(:, currentCategory))]);
                resonance = 1;
            else
                % Otherwise, choose the next category in the sorted category list.
                % If the current category is the last in the list, make sure that
                % the maximum number of categories has not been reached. If so,
                % assign the input a category of []. If the maximum has not been
                % reached, create a new category for the input, update the weights,
                % and induce resonance.
                if(currentSortedIndex == numSortedCategories)
                    if(currentSortedIndex == NET.maxNumCategories)
                        DATA(sampleNumber).category = NaN;
                        resonance = 1;
                    else
                        resizedWeight = ARTwarp_Add_New_Category(NET.weight, currentData);
                        NET.weight = resizedWeight;
                        NET.numCategories = NET.numCategories + 1;
                        DATA(sampleNumber).category = currentSortedIndex + 1; Xmax = max([Xmax currentLength]);
                        Ymax = max([Ymax max(currentData)]);
                        resonance = 1;
                    end
                else
                    currentSortedIndex = currentSortedIndex + 1;
                end
            end
        end
        % Test whether the current input was reclassified during the current iteration
        if oldCategory ~= DATA(sampleNumber).category;
            numChanges = numChanges+1;
        end
        % Graphic output
        delete(findobj('Tag', 'P0'));
        h0 = findobj('Tag', '0');
        set(h0, 'XLim', [0 Xmax], 'YLim', [0 Ymax]);
        h1 = line('Parent', h0, 'Color','r', 'Tag', 'P0', 'XData', 1:currentLength, 'YData', currentData);
        h1 = findobj('Tag', 'T0');
        set(h1, 'String', currentName, 'Color', 'r');
        h1 = findobj('Tag', 'Match');
        set(h1, 'String', sprintf('%2.0f%%', maxMatch));
        h1 = findobj('Tag', 'Iteration');
        set(h1, 'String', sprintf('%2.0f', iterationNumber));
        h1 = findobj('Tag', 'Input');
        set(h1, 'String', sprintf('%2.0f of %2.0f', indexNumber, numSamples));
        h1 = findobj('Tag', 'Reclassifications');
        set(h1, 'String', sprintf('%2.0f', numChanges))
        for counter3 = 1:NET.numCategories
            delete(findobj('Tag', ['P' num2str(counter3)]));
            h0 = findobj('Tag', num2str(counter3));
            set(h0, 'Tag', num2str(counter3), 'Visible', 'on', 'XLim', [0 Xmax], 'YLim', [0 Ymax]);
            h1 = line('Parent', h0, 'Color','k', 'Tag', ['P' num2str(counter3)], 'XData', 1:p, 'YData', NET.weight(:,counter3));
            h1 = findobj('Tag', ['T' num2str(counter3)]);
            set(h1, 'Color', 'k', 'Visible', 'on');
        end
        h1 = findobj('Tag', ['P' num2str(DATA(sampleNumber).category)]);
        set(h1, 'Color', 'r');
        h1 = findobj('Tag', ['T' num2str(DATA(sampleNumber).category)]);
        set(h1, 'Color', 'r');
        drawnow
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
    name = sprintf(formatSpec,NET.vigilance, iterationNumber);
    save(name);
end
fprintf('The number of iterations needed was %d\n', iterationNumber);
formatSpec = 'ARTwarp%02.0fFINAL';
endname = sprintf(formatSpec,NET.vigilance);
save(endname);
h = findobj('Tag', 'Runmenu');
set(h, 'Enable', 'on');
h = findobj('Tag', 'Plotmenu');
set(h, 'Enable', 'on');
return
