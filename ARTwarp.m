% Load all contours
contours = ContourFactory.load_contours();
assignin("base", "contours", contours); % adds to workspace for checking

% Parameters in workspace
parameters = Parameters();

% Initilaise network in NetworkFactory (reference run_categorisation.m line 49-58)
network = NetworkFactory.new_network(contours);

% Run in Network instance (the rest of run_categorisation.m)
% sub function includes (activate, add_new, calc_match, update_weights)


