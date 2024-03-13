addpath("../")
dir_path = cd + "/../Test_Data";

contours = ContourFactory.load_contours(dir_path);

% Make new category with size of 1 and the first contour as the reference
cat = Category(1, contours(1));

% Assert that initialization has occurred properly
assert(cat.size == 1, "Problem with initializing size");
assert(isequal(cat.reference, contours(1)), "Problem with initializing reference contour");

% Add another contour
cat.add(cat, contours(2));

% Assert size has increased
% Once average has been implemented, should also check that the new
% reference is correct
assert(cat.size == 2, "Problem with increasing size after addition of contour");

% Remove contour
cat.remove(cat, contours(2));

% Assert size has decreased
% Once unaverage has been implemented, should also check that the new
% reference is correct
assert(cat.size == 1, "Problem with decreasing size after removal of contour");

% Remove another contour, making category empty
cat.remove(cat, contours(1));

% Assert size is now 0 and reference contour is empty
assert(cat.size == 0, "Problem with decreasing size after removal of contour");
assert(cat.reference == [], "Problem with emptying reference contour when category is empty")
