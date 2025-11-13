function updatedWeight = ART_Update_Weights(input, weight, categoryNumber, learningRate, warpfun, compare_warped)
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
%    compare_warped is a boolean parameter. If compare_warped == 1,
%    the network will learn the input contour (INPUT), but if
%    compare_warped == 0, the network will learn the warped input
%    contour (WARPFUN(INPUT)). 
%
%    The return parameters are as follows:
%    The UPDATEDWEIGHT is a matrix of size NumFeatures-by-NumCategories
%    that holds the new weights of the network after the input has been
%    successfully learned.
%    The WEIGHTCHANGE is a value (0 or 1) which relays whether or not
%    the weight matrix was changed during this updating. Here, 0 represents
%    no change and 1 represents a change.

% Find all elements of the weight which are not NaN
i = find(weight(:,categoryNumber) >0);
weightLength = length(i);
[numFeatures, numCategories] = size(weight);
inputLength = length(input);

% Check the input parameters for correct ranges.
if length(warpfun) ~= weightLength
    error('The length of the input and rows of the weights do not match.');
end
if((categoryNumber < 1) | (categoryNumber > numCategories))
    error('The category number must be in the range [1, NumCategories].');
end

% UPDATE WEIGHT CONTENT
% update the content of the reference contour by a factor of learningRate
% to more closely match the content of the warped input contour
newWeight = weight(i, categoryNumber);
newWeight = newWeight+learningRate*(input(warpfun)-newWeight);

% CALCULATE UPDATED LENGTH AND UNWARPFUNCTION
% if we want to learn the original, unwarped whistle, then we should also
% calculate the required length change and unwarping function. Otherwise,
% if we are just learning the warped contour, we can skip these steps and
% go straight to adding newWeight to the NET.weight matrix
if compare_warped == 0

    % update the total length of the weight by adding 
    % learningRate*(the difference in length between the input and the
    % reference contour)
    newLength = length(newWeight)+round(learningRate*(inputLength-length(newWeight)));

    % get the inverse of the warping function, unwarpfun
    unwarpfun = unwarp(warpfun);

    % interpolate unwarpfun to a new spacing of (length(unwarpfun)-1)/
    % (newLength-1). This ensures unwarpfun has newLength points
    unwarpfun = interp1(1:length(unwarpfun), unwarpfun, 1:(length(unwarpfun)-1)/(newLength-1):length(unwarpfun));

    % get the indexes of newWeight to interpolate over by learning the
    % unwarping function into an array of weightLength indexes with newLength
    % points
    unwarpfun = (1:(weightLength-1)/(newLength-1):weightLength)- ((1:(weightLength-1)/(newLength-1):weightLength)- unwarpfun)*learningRate;

    % interpolate newWeight over these indexes to learn the inverse of the
    % local dynamic time warping
    newWeight = interp1(1:length(newWeight), newWeight, unwarpfun);

% If we are learning the warped contour, specify that the new length of the
% weight entry will just be the old weight length
else
    newLength = weightLength;

end

% Update the associated column in the weight matrix to hold the updated
% reference contour, padding the end with NaNs to maintain the dimensions
% of the matrix.

weight(:,categoryNumber) = zeros(numFeatures,1).*NaN;
weight(1:newLength,categoryNumber) = newWeight';
updatedWeight = weight;
return