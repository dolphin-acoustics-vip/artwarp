classdef ARTwarp
    % Main data structure for a running ARTwarp instance.

    properties
        parameters % A container for user-specified parameters
        contours   % An array of Contour objects
        network    % The network object currently being manipulated
    end
end