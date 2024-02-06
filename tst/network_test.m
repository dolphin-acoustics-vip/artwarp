addpath("../")
dir_path = cd + "/../Test_Data";
contours = ContourFactory.load_contours(dir_path);
assert(length(contours) == 7, "Problems with getting all contours");

network = NetworkFactory.new_network(contours);
assert(isequal(size(network.weight), [1050 0]), "Problem with generating new network")
