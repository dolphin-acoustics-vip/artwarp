addpath("../")
dir_path = cd + "/../Test_Data";

contours = ContourFactory.load_contours(dir_path);

%make new category with size of 1 and the first contour as the reference
cat = Category(1, contours(1));

%assert that initialization has occurred properly
assert(cat.size == 1, "Problem with initializing size");
assert(isequal(cat.reference, contours(1)), "Problem with initializing reference contour");
