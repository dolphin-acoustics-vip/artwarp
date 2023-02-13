classdef Load_Datatype < Load_Data
    %   LOAD_DATA This class contains the functions to load the data into the
    %   app, whether it is in CTR or CSV format

    properties (Access = public)
          data % Holds the data which is loaded
    end

    methods (Static)
        function obj = ARTwarp_Load_CSV_Data(path)
            %ARTwarp_Load_CSV_Data Loads in the CSV Data

            %Assign this data variable to be the directory (list of files) of the folder in path. This has a number of unneeded columns which are also removed by this rmfield() function.
            obj.data = rmfield(dir(path),{'date', 'datenum', 'bytes', 'isdir'}); 

            [numSamples, ~] = size(obj.data);

            for c1 = 1:numSamples
                %Here we extract the relevant data to use (potentially this
                %can be rewritten into a seperate function?)


                test=readtable(fullfile(obj.data(c1).folder, obj.data(c1).name));
                freqContour = table2array(test(:,1)); %to select the data and remove the header
                obj.data(c1).ctrlength = freqContour(length(freqContour))/1000;
                obj.data(c1).length = length(freqContour)-1;
                obj.data(c1).contour = freqContour(1:obj.data(c1).length);
                obj.data(c1).tempres = obj.data(c1).ctrlength/obj.data(c1).length;
                obj.data(c1).category = 0;
            end
        end


        function obj = ARTwarp_Load_CTR_Data(path)
            %ARTwarp_Load_CTR_Data Loads in the CTR Data
            
            %Assign this data variable to be the directory (list of files) of the folder in path. This has a number of unneeded columns which are also removed by this rmfield() function.
            obj.data = rmfield(dir(path),{'date', 'datenum', 'bytes', 'isdir'}); 

            [numSamples, ~] = size(obj.data);

            for c1 = 1:numSamples
                clear tempres
                clear ctrlength
                clear fcontour
                eval(['load ' fullfile(obj.data(c1).folder, obj.data(c1).name) ' -mat']);
                if exist('ctrlength', 'var')
                    obj.data(c1).ctrlength = ctrlength;
                    obj.data(c1).length = length(freqContour);
                    obj.data(c1).contour = freqContour;
                elseif exist('fcontour', 'var')
                    obj.data(c1).ctrlength = fcontour(length(fcontour))/1000;
                    obj.data(c1).length = length(fcontour);
                    obj.data(c1).contour = fcontour(1:obj.data(c1).length);
                else
                    obj.data(c1).ctrlength = freqContour(length(freqContour))/1000;
                    obj.data(c1).length = length(freqContour)-1;
                    obj.data(c1).contour = freqContour(1:obj.data(c1).length);
                end
                if exist('tempres', 'var')
                    obj.data(c1).tempres = tempres;
                else
                    obj.data(c1).tempres = obj.data(c1).ctrlength/obj.data(c1).length;
                end
                obj.data(c1).category = 0;
            end
        end

        function obj = ARTwarp_Load_TXT_Data(path)

            obj.data = rmfield(dir(path),{'date', 'datenum', 'bytes', 'isdir'}); %Assigns this DATA variable to be the directory (list of files) of the folder in path. This has a number of unneeded columns which are removed here
            [numSamples, ~] = size(obj.data); %This finds the number of contours in the folder and assigns it to the variable numSample
            for c1 = 1:numSamples
    
                % make sure to skip the header row, since it has characters in it and
                % csvread only works with numeric values.  The frequency should be in
                % the second column
                test=readtable(obj.data(c1).name,'\t');
                fcontour = table2array(test(:,1)); %to select the data and remove the header
                obj.data(c1).ctrlength = fcontour(length(fcontour))/1000;
                obj.data(c1).length = length(fcontour)-1;
                obj.data(c1).contour = fcontour(1:obj.data(c1).length);
                obj.data(c1).tempres = obj.data(c1).ctrlength/obj.data(c1).length;
                obj.data(c1).category = 0;
            end
        end
    end
end