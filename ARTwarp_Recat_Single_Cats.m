function [updatedCategories, updatedMatches, updatedWeight,...
    updatedNumCategories] = ARTwarp_Recat_Single_Cats(categories,...
    matches, contours, weight, vigilance, bias, learningRate,...
    compareWarped)

% A function to recategorise contours which are alone in their category, if
% they match another category's reference contour above the vigilance
% threshold

% INPUTS:
% categories: 1xnumSamples double, stores the category assignment of
% each contour
% matches: 1xnumSamples double, stores the matches of each contour to
% its assigned category (at the time of assignation)
% contours: numSamplesxnumFeatures double, where each row stores the
% frequency points for a contour in Hz
% weight: numFeaturesxnumCategories double, where each column stores
% the frequency points for a reference contour in Hz. Note that the order
% of the columns implicitly defines the category identifier, i.e column 1
% corresponds to category 1, column 2 to category 2, etc.
% vigilance: 1x1 double, storing the threshold match above which a new
% contour should be placed into a category
% bias: 1x1 double, stores a small factor by which to weight category
% activations. Currently the bias value seems to have no effect, as it
% weights an ordered list of activations equally and so does not change
% this order
% learningRate: 1x1 double, stores the factor by which the weights
% should be modified when learning a new input
% compareWarped: 1x1 double, either 0 or 1, where 1 = update weights
% according to warped contours, 0 = update weights according to original
% contours as usual

% OUTPUTS:
%- updatedCategories: 1xnumSamples double, stores the updated category
% assignment of each contour
%- updatedMatches: 1xnumSamples double, stores the updated matches of each
% contour to its assigned category
%- updatedWeight: numFeaturesxupdatedNumCategories double, stores the
% updated reference contours in its columns after any modification due to
% single-contour-category contour reassignment. Note that the number of
% columns may have decreased, if a single-contour-category was deleted
%- updatedNumCategories: stores the updated number of categories (columns
% of the weights matrix) after any single-contour-category deletions

% --- INITIALISE VARIABLES ---

[numSamples, ~] = size(contours);
[~, numCategories] = size(weight);

% --- LOCATE CONTOURS WHICH ARE ALONE IN THEIR CATEGORY ---

% Find indexes of lone contours
loneIndexes = ones(1,numSamples);

% Discount indexes containing NaN or 0
loneIndexes(isnan(categories)) = 0;

% For each category number:
for category = 1:numCategories
    % Find the logical indexes of contours in that category
    catIndexes = (categories==category);
    % If there is not exactly one contour in the category:
    if sum(catIndexes) ~= 1
        % Then indicate that these are not indexes of a lone contour
        loneIndexes(catIndexes) = 0;
    end
end
loneIndexes = logical(loneIndexes); % Convert to logical for indexing
numLoneSamples = sum(loneIndexes); % Record the number of lone contours

% Read the contours into a struct for easier processing
loneContoursMat = contours(loneIndexes,:);
loneCatsMat = categories(loneIndexes);
loneMatchesMat = matches(loneIndexes);
loneContours = struct('contour', [], 'category', 0, 'match', 0);
for i = 1:numLoneSamples
    loneContours(i).contour = loneContoursMat(i,:);
    loneContours(i).contour = loneContours(i).contour(~isnan(loneContours(i).contour));
    loneContours(i).category = loneCatsMat(i);
    loneContours(i).match = loneMatchesMat(i);
end

% --- SINGLE TRAINING ITERATION FOR LONE CONTOURS ---

% Randomise the order of the lone contours to reclassify
[~, sortedRandom] = sort(randn(numLoneSamples, 1));

% Record the number of single-contour categories recategorised
singleCatsMoved = 0;

% Classify and learn on each sample.
for indexNumber = 1:numLoneSamples
    sampleNumber = sortedRandom(indexNumber); 
    % Get the current data sample, stepping through the randomized list in
    % order
    currentData = loneContours(sampleNumber).contour';
    % Name of the category it is currently assigned to prior to comparison 
    % (initialized at 0)
    oldCategory = loneContours(sampleNumber).category;
        
    % Activate the categories for this sample
    % This is equivalent to bottom-up processing in ART
    categoryActivation = ARTwarp_Activate_Categories(currentData, weight, bias);
        
    % Find the category with the highest activation value (and hence the
    % highest match) for this sample, EXCLUDING ITS CURRENT CATEGORY
    % This assumes the highest activation is that 
    categoryActivation{1,1}(oldCategory) = NaN;
    [~, bestMatchCategory] = max(categoryActivation{1,1});
            
     % Get the weight vector for the best-matching category
     bestMatchWeightVector = weight(:, bestMatchCategory);
     warpFunction = categoryActivation{2, bestMatchCategory};
            
     % Calculate the match given the current data sample and the weight vector
     match = ARTwarp_Calculate_Match(currentData(warpFunction), bestMatchWeightVector);
            
     % Check to see if the match is better than the vigilance
     if match > vigilance

         % If so, the current category should code the input
         weight = ARTwarp_Update_Weights(currentData, weight,...
             bestMatchCategory, learningRate, warpFunction, compareWarped);

         % Update the category and match of the lone contour in the
         % loneContours struct
         loneContours(sampleNumber).category = bestMatchCategory;
         loneContours(sampleNumber).match = match;

         % Update the category and match of the lone contour in the
         % general matches and categories arrays (note we can index by
         % categories==oldCategory only because oldCategory is unique)
         oldCatIdx = (categories==oldCategory);
         matches(oldCatIdx) = match;
         categories(oldCatIdx) = bestMatchCategory;

         % Delete the old (now empty) category
         [weight, categories] = ARTwarp_Delete_Category(weight,...
             oldCategory, categories);
         numCategories = numCategories - 1;
         
         % Update the categories of lone contours to correct for any shift
         % caused by the deleted category
         newCategories = categories(loneIndexes);
         for i = 1:numLoneSamples
            loneContours(i).category = newCategories(i);
         end

         singleCatsMoved = singleCatsMoved + 1;

     end
end

% Display the total number of lone contours reclassified
fprintf('Number of single-contour-category contours reclassified %2.0f\n',...
    singleCatsMoved);

% --- RETURN UPDATED ARRAYS ---

% Formalise the return of the modified categories, matches, weight matrix
% and the number of categories
updatedCategories = categories;
updatedMatches = matches;
updatedWeight = weight;
updatedNumCategories = numCategories;