function categoryActivation = ARTwarp_Activate_Categories(input, weight, bias)
% ARTwarp_Activate_Categories    Activates the categories in an ARTwarp network.
%    CATEGORYACTIVATION = ART_Activate_Categories(INPUT, WEIGHT, BIAS)
%    This function returns a structure containing the activation values(biassed 
%    time-warped distances)for each neuron, as well as the warp functions


% Make sure the user supplied the required parameters.
if(nargin ~= 3)
    error('You must specify the 3 input parameters.');
end

[numFeatures, numCategories] = size(weight);

if((bias < 0) | (bias > 1))
    error('The bias must be within the range [0, 1].');
end

% Set up the return variable.
categoryActivation{1,1} = ones(1, numCategories);

% Calculate the activation for each category.
% This is done according to the following equation:
% by calculating the time-warped distance
for j = 1:numCategories
    i = find(weight(:,j) >0);
    X = warp(weight(i,j), input);
    categoryActivation{1, 1}(1,j) = X{1,1} *(1-bias);
    categoryActivation{2,j}= X{1,2};
end


return