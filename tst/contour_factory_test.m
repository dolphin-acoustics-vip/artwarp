addpath("../")
dir_path = cd + "/../Test_Data";

assert(length(ContourFactory.getCTR(dir_path)) == 4, "Problems with getting CTR");

assert(length(ContourFactory.getCSV(dir_path)) == 3, "Problems with getting CSV");

contours = ContourFactory.load_contours(dir_path);
assert(length(contours) == 7, "Problems with getting all contours");

for i = 1:length(contours)
    contour = contours(i);
    assert(isprop(contour, "frequency"), "Contour doesn't contain frequency");
    assert(isprop(contour, "tempres"), "Contour doesn't contain tempres");
    assert(isprop(contour, "length"), "Contour doesn't contain length");
end