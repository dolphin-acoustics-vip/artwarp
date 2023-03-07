% show current figure:
%   https://uk.mathworks.com/help/matlab/ref/shg.html
% figure:
%   https://uk.mathworks.com/help/matlab/ref/figure.html#bvjs6ew-1
% figure properties:
%   https://uk.mathworks.com/help/matlab/ref/matlab.ui.figure-properties.html

classdef plot_net
    properties
        DATA
        weight
        num_categories
        num_features
        fig
        maxCols = 5;
    end

    methods (Static)
        function obj = plot_net(DATA,NET)
            % should be DATA instance?
            obj.DATA           = DATA;
            % should be NET instance?
            obj.weight         = NET.weight;
            obj.num_categories  = NET.numCategories;
            obj.num_features   = NET.numFeatures;
            obj.fig            = figure(ToolBar="none", ...
                                        Name="Plot Net", ...
                                        Visible="on", ...
                                        WindowState="maximized");
            obj.plot_overlap();
        end
    end
    methods
        function plot_overlap(obj)
            close all;
            reset(gcf);
            % HELP: check that numCategories should already be an int
            numCols = min([obj.maxCols obj.num_categories]); % 1 row will not exceed maxCols
            numRows = ceil(obj.num_categories / obj.maxCols);

            for subPlotNum = 1 : obj.num_categories
                % subplot for each category (adjust dimensions)
                % fprintf('subplot:%d Row:%d Col:%d\n', subPlotNum, currRow, currCol);
                subplot(numRows, numCols, subPlotNum);
                plot(1:obj.num_features, obj.weight(:,subPlotNum), "r", LineWidth=1);
                title("Category " + subPlotNum);
                set(gca, 'XTick', [], 'YTick', []);
                hold on
                % find all contours that are in category
                contours_indexes = find([obj.DATA.category] == subPlotNum);
                for contour_index = contours_indexes
                    % plot overlapped
                    contour = obj.DATA(contour_index).contour;
                    plot(1:length(contour), contour, Color=[0, 0, 0, 0.2]);
                end
                hold off
            end
        end

        function iterate(obj)
            for subPlotNum = 1 : obj.num_categories
                fprintf('subplot:%d Row:%d Col:%d\n', subPlotNum, ceil(subPlotNum / obj.maxCols), mod(subPlotNum - 1, obj.maxCols)+1);
            end
        end

        function plot_side(obj)
             reset(gcf);
        end
    end
end