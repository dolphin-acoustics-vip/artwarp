addpath("../")
dir_path = cd + "/../Test_Data";
contours = ContourFactory.load_contours(dir_path);
assert(length(contours) == 7, "Problems with getting all contours");

parameters = Parameters();

network = NetworkFactory.new_network(contours);
assert(isequal(size(network.weights), [1050 0]), "Problem with generating new network")

% Test adding category to Network
cat = Category(2,contours(1));
network = network.add_category(cat);
assert(isequal(network.num_categories, 1), "Problem with changing number of categories.");
assert(isequal(network.categories(network.num_categories), cat), "Problem with adding category.");

% Further tests can be added after compare function in Category.m has been
% implemented