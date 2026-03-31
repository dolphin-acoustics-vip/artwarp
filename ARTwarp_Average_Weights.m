function updatedWeight = ARTwarp_Average_Weights(weight, inputLengths, inputCategories)
% ARTwarp_Average_Weights warps every category's reference contour (weight) 
% uniformly to be the mean length of the contours in that category.

%    UPDATEDWEIGHT = ARTwarp_Average_Weights(WEIGHT, INPUTCONTOURS, INPUTCATEGORIES)
%    This function returns a new weight matrix that has warped every weight
%    uniformly so that its new length is the mean length of the contours in that 
%    category.

%    The input parameters are as follows:
%    WEIGHT is a matrix of size 
%    NumFeatures-by-NumCategories which holds the weights of the network.
%    INPUTLENGTHS is a matrix of size 1xnumSamples which holds the lengths of all
%    the input contours
%    INPUTCATEGORIES is a matrix of size 1xnumSamples which holds the categories all
%    input contours were placed into

%    The return parameters are as follows:
%    UPDATEDWEIGHT is a matrix of size NumFeatures-by-NumCategories
%    that holds the new weights of the network after each weight has been
%    interpolated to the new length, given by the mean length of the 
%    contours in that category.

[numFeatures, numCategories] = size(weight);

% For every category:
for cat = 1:numCategories

    % Find all elements of the reference contour for that category which are not NaN
    i = weight(:,cat);
    i = i(i>0);
    weightLength = length(i);

    % Find new length from the average length of contours in that category
    newLength = round(mean(inputLengths(inputCategories==cat)));

    % interpolate (warp) the weight to a new spacing of (weightLength-1)/
    % (newLength-1). This ensures the weight has newLength
    % points, while retaining the same shape
    newWeight = interp1(1:weightLength, i, 1:(weightLength-1)/(newLength-1):weightLength);

    % Update the associated column in the weight matrix to hold the updated
    % reference contour, padding the end with NaNs to maintain the dimensions
    % of the matrix.            
    weight(:,cat) = zeros(numFeatures,1).*NaN;
    weight(1:newLength,cat) = newWeight';
    
end

updatedWeight = weight;