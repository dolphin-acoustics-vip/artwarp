function resizedWeight = ART_Add_New_Category(weight, input)
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


% Make sure that the user specified the weight matrix.
if(nargin < 2)
    error('You have specified too few parameters.');    
elseif(nargin > 2)
    error('You have specified too many parameters.');    
end

% Create the return weight matrix with the right dimensions.
[numFeatures, numCategories] = size(weight);
newCategory = ones(numFeatures, 1).*NaN;
newCategory(1:length(input)) = input;
resizedWeight = [weight, newCategory];

return