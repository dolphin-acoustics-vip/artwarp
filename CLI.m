function exitcode = CLI(varargin)
    switch varargin{1}
        case 'train'
            if varargin{2} == "-l" % 4th param is the network path
                disp("load");
                net = NetworkFactory.load_network(varargin{3});
            else
                disp("new");
                net = NetworkFactory.new_network();
            end
            
        otherwise
            disp("Invalid subcommand '" + varargin(1) + "'; run 'artwarp help' for a list of valid commands")
    end

    exitcode = 0;
end