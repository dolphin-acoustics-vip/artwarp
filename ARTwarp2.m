% FORMATTING
clear all
close gcf

cd C:\matlab\Pfiffe
DATA = dir('C:\matlab\Pfiffe\*txt');
DATA = rmfield(DATA,'date');
DATA = rmfield(DATA,'bytes');
DATA = rmfield(DATA,'isdir');


ID = [023 024 025 026 027 028 029 030 031 NaN NaN NaN NaN NaN;
    038 039 040 041 042 NaN NaN NaN NaN NaN NaN NaN NaN NaN;
    049 050 051 052 053 054 055 056 057 058 059 060 061 062;
    093 094 095 096 097 098 NaN NaN NaN NaN NaN NaN NaN NaN]';

id = find(ID > 0);

[numSamples x] = size(DATA); 

for i = 1:numSamples
    eval(['s = load(''' DATA(i).name ''');']);
    DATA(i).contour = s';
    DATA(i).length = length(s);
    [x DATA(i).ID] = find(ID == str2num(DATA(i).name(1:3)));
    DATA(i).category = 0;
end

[numSamples x] = size(DATA); 

% INITIALIZING NETWORK
lengths = round([DATA.length]./4);
n = round(mean(lengths));
p = max([DATA.length]);
mx = max([DATA.contour]);
mn = min([DATA.contour]);
Xmax = n;
Ymax = mean([DATA.contour]);
% Create and initialize the weight matrix.
weight = ones(p, 0);

% Create the structure and return.
NET = struct('numFeatures', {p}, 'numCategories', {0}, 'maxNumCategories', {56}, 'weight', {weight}, ...
    'vigilance', {96}, 'bias', {0.000001}, 'numIterations', {100}, 'learningRate', {0.3});

numCols = round(NET.maxNumCategories^0.5);
numRows = numCols+1;
rowHeight = (0.98 - 0.01*numRows)/numRows;
colWidth = (0.98 - 0.01*numCols)/(numCols+1);

% GENERATE FIGURE
h0 = figure('Units','normalized', ...
    'Color',[0.752941176470588 0.752941176470588 0.752941176470588], ...
    'MenuBar','none', ...
    'Name','ART2 Neural Network', ...
    'NumberTitle','off', ...
    'PaperPosition',[18 180 576 432], ...
    'PaperUnits','points', ...
    'Position',[0 0.04036458333333333 1 0.8671875], ...
    'Tag','Figure1');
h1 = axes('Parent',h0, ...
    'Units','normalized', ...
    'CameraUpVector',[0 1 0], ...
    'CameraUpVectorMode','manual', ...
    'Position',[0.01 (rowHeight+0.01)*(numRows-1) + 0.01 colWidth rowHeight ], ...
    'Tag', '0', ...
    'XTick',[], ...
    'YTick',[]);
h2 = text('Parent',h1, ...
    'Units','normalized', ...
    'FontSize',9, ...
    'HorizontalAlignment','center', ...
    'Position',[0.5 1], ...
    'String',' ', ...
    'Tag','T0', ...
    'VerticalAlignment', 'cap');
h1 = axes('Parent',h0, ...
    'Units','normalized', ...
    'CameraUpVector',[0 1 0], ...
    'CameraUpVectorMode','manual', ...
    'Position',[(colWidth) + 0.02 (rowHeight+0.01)*(numRows-1) + 0.01 colWidth rowHeight], ...
    'Tag', 'X', ...
    'Visible', 'off', ...
    'XTick',[], ...
    'YTick',[]);
h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0 1], ...
    'String','Match:',...
    'VerticalAlignment', 'cap');
h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0 0.66], ...
    'String','Iteration:',...
    'VerticalAlignment', 'middle');
h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0 0.33], ...
    'String','Input:',...
    'VerticalAlignment', 'middle');
h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0 0], ...
    'String','Reclassified:',...
    'VerticalAlignment', 'bottom');

h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0.5 1], ...
    'String',' ',...
    'Tag','Match',...
    'VerticalAlignment', 'cap');
h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0.5 0.66], ...
    'String',' ',...
    'Tag','Iteration',...
    'VerticalAlignment', 'middle');
h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0.5 0.33], ...
    'String',' ',...
    'Tag','Input',...
    'VerticalAlignment', 'middle');
h2 = text('Parent',h1, ...
    'FontSize',9, ...
    'HorizontalAlignment','left', ...
    'Position',[0.5 0], ...
    'String',' ',...
    'Tag','Reclassifications',...
    'VerticalAlignment', 'bottom');


number = 1;
for counter2 = 0:1:numCols
    for counter1 = numRows-2:-1:0
        h1 = axes('Parent',h0, ...
            'Units','normalized', ...
            'CameraUpVector',[0 1 0], ...
            'CameraUpVectorMode','manual', ...
            'Position',[(colWidth+0.01)*counter2 + 0.01 (rowHeight+0.01)*counter1 + 0.01 colWidth rowHeight], ...
            'Tag', num2str(number), ...
            'Visible', 'off', ...
            'XTick',[], ...
            'YTick',[]);
        h2 = text('Parent',h1, ...
            'Units','normalized', ...
            'FontSize',9, ...
            'HorizontalAlignment','center', ...
            'Position',[0.5 1], ...
            'String',['Neuron ' num2str(number)], ...
            'Tag',['T' num2str(number)], ...
            'VerticalAlignment', 'cap', ...
            'Visible', 'off');
        number = number+1;
    end
end






% TRAINING


[x, sortedRandom] = sort(randn(numSamples, 1));
% Go through the data once for every iteration.
for iterationNumber = 1:NET.numIterations
    
    % This variable will allow us to see whether new categories were 
    % added during the current iteration.
    % Initialize the number of added categories to 0.
    numChanges = 0;
    % Classify and learn on each sample.
    for indexNumber = 1:numSamples
        sampleNumber =sortedRandom(indexNumber);
        % Get the current data sample.
        currentData = DATA(sampleNumber).contour
        currentLength = length(currentData);
        currentName = DATA(sampleNumber).name;
        oldCategory = DATA(sampleNumber).category;
        
        % Activate the categories for this sample.
        % This is equivalent to bottom-up processing in ART.
        bias = NET.bias;
        categoryActivation = ARTwarp_Activate_Categories(currentData, NET.weight, bias);
        
        % Rank the activations in order from highest to lowest.
        % This will allow us easier access to step through the categories.
        [sortedActivations, sortedCategories] = sort(-categoryActivation{1,1});
        
        % Go through each category in the sorted list looking for the best match.
        % This is equivalent to bottom-up--top-down processing in ART.
        resonance = 0;
        match = 0;
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
            
            % Check to see if the match is better than the vigilance.
            if match > NET.vigilance
                % If so, the current category should code the input.
                % Therefore, we should update the weights and induce resonance.
                % warpFunction = round(mean([warpFunction; 1:(warpFunction(end)-1)/(length(warpFunction)-1):warpFunction(end)]));
                NET.weight = ARTwarp_Update_Weights(currentData', NET.weight, currentCategory, NET.learningRate, warpFunction);
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
        set(h1, 'String', sprintf('%2.0f%%', match));
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
    end
    % If no new categories were added, and no inputs were reclassified in the current iteration
    % then we've reached equilibrium. Thus, we can stop training.
    if numChanges == 0
        break;
    end
    
end

fprintf('The number of iterations needed was %d\n', iterationNumber);
%eval(['save ecotype' num2str(vigilance) ' DATA NET iterationNumber']);

return

