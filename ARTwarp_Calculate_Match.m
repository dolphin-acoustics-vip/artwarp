function match = ART_Calculate_Match(input, weightVector)
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
[a b] = size(input);
if a < b
    input = input';
end
[a b] = size(weightVector);
if a < b
    weightVector = weightVector';
end

match = 0;
numFeatures = length(input);
i = find(weightVector >0);


if(numFeatures ==0 )
    match = 0;
else

% Calculate the match between the given input and weight vector.
% This is done according to the following equation:
%       Match = |Input^WeightVector| / |Input|

match = min([input weightVector(i)]')./max([input weightVector(i)]');
match = sum(match)/length(i) * 100;
end
return