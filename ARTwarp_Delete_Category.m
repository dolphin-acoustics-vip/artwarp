function [updatedWeight, updatedCategories] =...
    ARTwarp_Delete_Category(weight, categoryNumber, contourCategories)

% Function to delete the category specified by `categoryNumber` from the
% weight matrix and update the category references of the
% contours to reflect the new shape of the weights matrix

% Update the weights matrix and number of categories
updatedWeight = weight;
updatedWeight(:,categoryNumber) = [];

% Update the category references
updatedCategories = contourCategories;
for i = 1:length(contourCategories)
    cat = contourCategories(i);
    if cat == categoryNumber
        error("Attempted to delete a non-empty category: a category was found which matches the deletion reference")
    elseif cat > categoryNumber
        updatedCategories(i) = cat - 1;
    end
end




